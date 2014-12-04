note
	description: "Summary description for {REST_PROJECTS_SPRINTLOGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_PROJECTS_SPRINTLOGS

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

	listSprintlogs(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/sprintlogs/list
	-- METHOD: GET
	require
		hreq /= Void
		hres /= Void
	local
		sprints : LINKED_SET[SPRINTLOG]
		j_sprint : JSON_OBJECT
		j_sprints : JSON_ARRAY
		json_response : JSON_OBJECT
		u : USER
		id_project : INTEGER

		p:PROJECT
		pu: LINKED_SET[PROJECT]
		hp: HTTP_PARSER
		e : STRING
	do
		log.warning ("helloW")
		http_request  := hreq
		http_response := hres
		create hp.make(hreq)

	if ensure_authenticated then

			u := 	get_session_user
			-- First GET the id of the project
			if not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/list [GET] Missing idproj in URL.")
			end
				id_project := hp.path_param("idproj").to_integer
			if db.checkVisibilityForProject(u.getId, id_project) then


					sprints := db.listSprintlogsFromBacklogId(db.getbacklogfromprojectid (id_project).getid)
					if sprints.is_empty then
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/sprintlogs/list [GET] There are no sprintlogs for this project")
					else
						create j_sprints.make_array
						across sprints as s
						loop
							j_sprint := s.item.to_minimal_json
							j_sprints.add (j_sprint)
						end
						create json_response.make
									json_response.put (j_sprints, "sprintlogs")
									send_json(hres, json_response)
					end
			else
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/list [GET] The user has not access to project.")
			end
	end
	end

	createSprintlog(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/sprintlogs/create
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		id_project : INTEGER
		id_pbi : INTEGER
		hp : HTTP_PARSER

		param_name        : STRING
		param_description        : STRING
		param_startDate        : STRING
		param_endDate        : detachable STRING
		param_idpbis        : detachable ARRAYED_LIST [STRING]

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

		p : PROJECT
		pbi : PBI
		m : USER
		s: SPRINTLOG

	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)

		if ensure_authenticated then


			-- First GET the id of the project
			if not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/create [POST] Missing idproj in URL.")
			end
			id_project := hp.path_param("idproj").to_integer
			p := db.getprojectfromid (id_project)


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

			param_startDate:= hp.post_param ("startDate")
					if ok and not regex.check_unixtime (param_startDate.out) then
								error_reason := "Start date not present or not correct (it should be unixtimestamp in seconds)."
								json_error.put_integer (200,"code")
								json_error.put_string ("startDate", "field")
								ok := FALSE
							end

			param_endDate:= hp.post_param ("endDate")
					if ok and not regex.check_unixtime (param_startDate.out) then
								error_reason := "End date not present or not correct (it should be unixtimestamp in seconds)."
								json_error.put_integer (200,"code")
								json_error.put_string ("endDate", "field")
								ok := FALSE
							end

				--TODO: check if every pbi exists	
				param_idpbis:= hp.post_array_param ("idpbis")

					across param_idpbis as e
					loop
						if ok and not  regex.check_integer (e.item)  then
								error_reason := "PBI not present or not correct."
								ok := FALSE
						end
					end


				--CHECK m is manager
						m := get_session_user

						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end

			if not ok then
				log.warning("/projects/{idproj}/pbis/create [POST] Request error: " + error_reason)
				json_error.put_string (error_reason, "reason")
				send_json(hres, json_error)
			else

				if ok then
					create s.make (0, param_name, param_description, db.getbacklogfromprojectid (id_project), create {DATE_TIME}.make_from_epoch(param_startDate.to_integer), create {DATE_TIME}.make_from_epoch(param_startDate.to_integer))
					db.insertsprintlog (s)
					log.info ("/projects/{idproj}/pbis/create [POST] Created a new task "+param_name )
					-- send OK to the user :)				
					send_generic_ok(hres)
				end


			end

		end -- end ensure authenticated

	end -- end current feature

	listPBIs(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/sprintlogs/{idsprintlog}/listpbis
	-- METHOD: GET
	do

	end

	addPBI(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- /projects/{idproj}/sprintlogs/{idsprintlog}/addpbi
	-- METHOD: POST
	do

	end

removePBI(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- /projects/{idproj}/sprintlogs/{idsprintlog}/removepbi
	-- METHOD: POST
	do

	end

deleteSprintlog(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- projects/{idproj}/sprintlogs/{idsprintlog}/delete
	-- METHOD: POST
	do

	end
end
