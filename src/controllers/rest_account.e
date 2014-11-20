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
	do
		http_request  := hreq
		http_response := hres

		-- User must be logged
		if ensure_authenticated then


		end
	end

	-- Underscore at name's end to prevent overloading
	-- of inerith method
	login_(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	local
		hp : HTTP_PARSER
		param_email : STRING
		param_password : STRING
	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		if is_logged then
			-- TODO
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
		json_ok : JSON_OBJECT
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

			if ok and not regex.check_date_iso8601 (param_dob) then
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

			if ok and (param_plangs = Void or param_plangs.count < 1 ) then
				error_reason := "Programming languages not present."
				ok := FALSE
			end

			if not ok then
				log.warning("/account/register [POST] Request error: " + error_reason)
				json_error.put_string (error_reason, "reason")
				send_json(hres, json_error)
			end

			if ok then

				-- Create the user
				create u.make (0, param_fname, param_lname,	ec.bool_to_int(param_sex.is_equal("M")),
							   create {DATE_TIME}.make(2000,1,1,0,0,0), param_country, param_timezone,
							   param_email, param_password, ec.bool_to_int(param_type.is_equal("developer")),
							   param_organiz, Void, Void)

				db.insertUser(u)

				log.info ("/account/register [POST] Created a new user "+param_fname + " "+param_lname)

				-- send OK to the user :)				
				create json_ok.make
				json_ok.put_string ("ok", "status")
				send_json(hres, json_ok)

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

end
