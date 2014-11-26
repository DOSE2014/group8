note
	description: "Summary description for {REST_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_ACCOUNT

inherit
	AUTHENTICATION
	HTTP_FUNCTIONS
	LOG

create
	make

feature {NONE}	-- Constructors
	make(sm : WSF_SESSION_MANAGER; pdt_db : PDT_DB)
	require
		sm /= Void
		pdt_db /= Void
	do
		session_manager := sm
		db := pdt_db
	end

feature{NONE}  -- Private properies
	db : PDT_DB

feature -- declaring deferred properties
	session_manager : WSF_SESSION_MANAGER
	http_request : WSF_REQUEST
	http_response : WSF_RESPONSE

feature

	account_info(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /account/userinfo
	-- METHOD: GET
	require
		hreq /= Void
		hres /= Void
	local
		hp : HTTP_PARSER
		u : USER
		json_error : JSON_OBJECT
	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)

		-- User must be logged
		if ensure_authenticated then

			if hp.get_param("id") = Void then
				-- CASE 1: no id passed
				u := get_session_user
			else
				-- CASE 2: id passed
				if hp.get_param("id").is_integer then
					u := db.getuserfromid (hp.get_param("id").to_integer)
				end
			end

			if u /= Void then
				send_json(http_response, u.to_json)
			else
				create json_error.make
				json_error.put_string ("error", "status")
				send_json(http_response, json_error)
				log.warning ("/account/userinfo [GET] Trying to get a non-existent user.")
			end

		end
	end

	-- Underscore at name's end to prevent overloading
	-- of inerith method
	login_(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	require
		hreq /= Void
		hres /= Void
	local
		hp : HTTP_PARSER
		param_email : STRING
		param_password : STRING
	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		if is_logged then
			-- Already logged - do nothing:
			send_generic_ok(hres)
		else
			if hp.is_good_request then
				param_email 	:= hp.post_param ("email")
				param_password	:= hp.post_param ("password")
				-- Regex check is unuseless

				-- From AUTHENTICATION:
				login(param_email, param_password, db)
			else
				-- Bad request
				send_malformed_json(http_response)
				log.warning("/account/login [POST] JSON request malformed.")
			end
		end
	end

	register(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /account/register
	-- METHOD: POST
	local
		regex : REGEX
		hp : HTTP_PARSER
		ok : BOOLEAN
		error_reason : STRING
		json_error : JSON_OBJECT
		u : USER

		-- Parameters
		param_email 	: detachable STRING
		param_fname 	: detachable STRING
		param_lname 	: detachable STRING
		param_sex   	: detachable STRING
		param_dob       : detachable STRING
		param_country   : detachable STRING
		param_organiz   : detachable STRING
		param_timezone  : detachable STRING
		param_password  : detachable STRING
		param_type      : detachable STRING
		param_langs		: detachable ARRAYED_LIST [STRING]
		param_plangs	: detachable ARRAYED_LIST [STRING]

		availableProgL	: LINKED_SET[PROGRAMMING_LANGUAGE]
		selectedProgL	: LINKED_SET[PROGRAMMING_LANGUAGE]

		availableLangs	: LINKED_SET[LANGUAGE]
		selectedLangs	: LINKED_SET[LANGUAGE]

	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		if ensure_not_authenticated and hp.is_good_request then

			create regex.make
			-- Create the error object even if it is not necessary
			-- (in this case, this object is not used)
			create json_error.make
			json_error.put_string ("error", "status")

			-- Guard variable: if FALSE an error occurred
			ok := TRUE

			param_email 	:= hp.post_param ("email")
			param_fname 	:= hp.post_param ("firstname")
			param_lname 	:= hp.post_param ("lastname")
			param_dob 		:= hp.post_param ("dateOfBirth")
			param_sex   	:= hp.post_param ("sex")
			param_country   := hp.post_param ("country")
			param_timezone  := hp.post_param ("timezone")
			param_password  := hp.post_param ("password")
			param_organiz   := hp.post_param ("organization")
			param_type      := hp.post_param ("type")
			param_langs		:= hp.post_array_param ("languages")
			param_plangs	:= hp.post_array_param ("programmingLanguages")

			if ok and not regex.check_email (param_email) then
				error_reason := "E-Mail not present or not correct."
				ok := FALSE
			end

			if ok and db.existsEmailInUser(param_email) then
				error_reason := "E-Mail already exists"
				ok := FALSE
			end

			if ok and not regex.check_name (param_fname) then
				error_reason := "First-name not present or not correct (3<=length<=50)."
				ok := FALSE
			end

			if ok and not regex.check_name (param_lname) then
				error_reason := "Last-name not present or not correct (3<=length<=50)."
				ok := FALSE
			end

			if ok and (param_sex = Void or
					not (param_sex.is_equal("M") or param_sex.is_equal("F"))) then
				error_reason := "Sex not present or not correct."
				ok := FALSE
			end

			if ok and not regex.check_unixtime (param_dob) then
				error_reason := "Date of birth not present or not correct (3<=length<=50)."
				ok := FALSE
			end

			if ok and not regex.check_name (param_country) then
				error_reason := "Country not present or not correct (3<=length<=50)."
				ok := FALSE
			end

			if ok and not regex.check_timezone (param_timezone) then
				error_reason := "Timezone not present or not correct (check IANA TZ Database)."
				ok := FALSE
			end

			if ok and not regex.check_name (param_organiz) then
				error_reason := "Organization not present or not correct."
				ok := FALSE
			end

			if ok and not regex.check_name (param_password) then
				error_reason := "Password not present or not correct (3<=length<=50)."
				ok := FALSE
			end

			if ok and (param_type = Void or
					not (param_type.is_equal("developer") or param_type.is_equal("stakeholder"))) then
				error_reason := "Type not present or not correct."
				ok := FALSE
			end

			if ok and (param_langs = Void or param_langs.count < 1 ) then
				error_reason := "Languages not present."
				ok := FALSE
			end

			-- Check programming languges only if user is a developer.
			if ok and (param_type.is_equal("developer")) and (param_plangs = Void or param_plangs.count < 1 ) then
				error_reason := "Programming languages not present."
				ok := FALSE
			end

			if not ok then
				log.warning("/account/register [POST] Request error: " + error_reason)
				json_error.put_string (error_reason, "reason")
				send_json(hres, json_error)
			end

			if ok then

				-- Retrive all lang and programming lang
				availableProgL := db.getprogramminglanguages
				availableLangs  := db.getlanguages

				create selectedProgL.make
				create selectedLangs.make

				-- Now search proglangs selected by user
				if param_type.is_equal("developer")	then
					across availableProgL as apl
					loop
						across param_plangs as ppl
						loop
							if apl.item.getName.is_equal(ppl.item) then
								-- Append to selected progL
								selectedProgL.force (apl.item)
							end
						end
					end
				end

				-- Now search langs selected by user
				across availableLangs as apl
				loop
					across param_langs as ppl
					loop
						if apl.item.getName.is_equal(ppl.item) then
							-- Append to selected progL
							selectedLangs.force (apl.item)
						end
					end

				end


				-- Create the user
				create u.make (0, param_fname, param_lname,	ec.bool_to_int(param_sex.is_equal("M")),
							   create {DATE_TIME}.make_from_epoch(param_dob.to_integer_32), param_country,
							   param_timezone, param_email, param_password,
							   ec.bool_to_int(param_type.is_equal("developer")),param_organiz,
							   selectedProgL, selectedLangs)

				db.insertUser(u)

				log.info ("/account/register [POST] Created a new user "+param_fname + " "+param_lname)

				-- send OK to the user :)				
				send_generic_ok(hres)

			end

		else
			if hp.is_good_request then
				-- HTTP error has already sent to the user by ensure_not_authenticated
				log.warning ("/account/register [POST] Error user already authenticated.")

			else
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/account/register [POST] JSON request malformed.")

			end

		end

	end

	langs(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /account/langs
	-- METHOD: GET
	local
		programmingLanguages : LINKED_SET[PROGRAMMING_LANGUAGE]
		languages : LINKED_SET[LANGUAGE]
		j_plangs: JSON_ARRAY
		j_langs: JSON_ARRAY

		json_response : JSON_OBJECT
	do
		-- Read programming languages from db and
		-- converet the LINKED_SET into a JSON_ARRAY
		programmingLanguages := db.getprogramminglanguages
		create j_plangs.make_array
		across programmingLanguages as lan
		loop
			j_plangs.add(create {JSON_STRING}.make_json(lan.item.getName))
		end

		-- Same opereation with languages		
		languages := db.getlanguages
		create j_langs.make_array
		across languages as lan
		loop
			j_langs.add(create {JSON_STRING}.make_json(lan.item.getName))
		end

		-- And now create and sends JSON
		create json_response.make
		json_response.put (j_plangs, "programmingLanguages")
		json_response.put (j_langs, "languages")
		send_json(hres, json_response)
	end


end
