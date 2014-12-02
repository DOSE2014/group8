note
	description: "Summary description for {REST_PROJECT_PBIS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_PROJECTS_PBIS

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

	create_pbi(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/create
	-- METHOD: POST
	local
		id_project : INTEGER
		hp : HTTP_PARSER

		param_name        : STRING
		param_description : STRING
		param_type 		  : STRING
		param_priority    : STRING

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)

		-- First GET the id of the project
		if not attached hp.path_param("idproj") then
			send_malformed_json(http_response)
			-- And logs it
			log.warning ("/projects/{idproj}/pbis/create [POST] Missing idproj in URL.")
		end
		id_project := hp.path_param("idproj").to_integer


		-- Next check the POST parameters
		create regex.make
		-- Create the error object even if it is not necessary
		-- (in this case, this object is not used)
		create json_error.make
		json_error.put_string ("error", "status")


		ok := TRUE

		param_name := hp.post_param ("name")
		if ok and not regex.check_name (param_name) then
			error_reason := "Name not present or not correct."
			ok := FALSE
		end

		param_description := hp.post_param ("description")
		if ok and not regex.check_name (param_description) then
			error_reason := "Description not present or not correct."
			ok := FALSE
		end

		param_description := hp.post_param ("description")
		if ok and not regex.check_name (param_description) then
			error_reason := "Description not present or not correct."
			ok := FALSE
		end

		param_description := hp.post_param ("type")
		if ok and not regex.check_name (param_type) then
			error_reason := "Type not present or not correct."
			ok := FALSE
		end

		param_priority := hp.post_param ("priority")
		if ok and not regex.check_integer (param_priority) then
			error_reason := "Priority not present or not integer."
			ok := FALSE
		end

		if not ok then
			log.warning("/projects/{idproj}/pbis/create [POST] Request error: " + error_reason)
			json_error.put_string (error_reason, "reason")
			send_json(hres, json_error)
		end

		if ok then
			
		end
	end


end
