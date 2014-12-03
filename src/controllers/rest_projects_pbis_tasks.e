note
	description: "Summary description for {REST_PROJECTS_PBIS_TASKS}."
	author: "Milan3 - Politecnico di Milano"
	date: "$Date$"
	revision: "$Revision$"

class
	REST_PROJECTS_PBIS_TASKS

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
	listtasks(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbis}/listtasks
	-- METHOD: GET
	--TODO: manage unauthorized requests
	require
		hreq /= Void
		hres /= Void
	local
		tasks : LINKED_SET[TASK]
		j_task : JSON_OBJECT
		j_tasks : JSON_ARRAY
		json_response : JSON_OBJECT
		u : USER
		id_project : INTEGER
		id_pbi :INTEGER
		p:PROJECT
		pbi : PBI
		hp: HTTP_PARSER
	do
		http_request  := hreq
		http_response := hres

	if ensure_authenticated then

			u := 	get_session_user
			-- First GET the id of the project
			if not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Missing idproj in URL.")
			end
			id_project := hp.path_param("idproj").to_integer
			p := db.getprojectfromid (id_project)
			if db.getprojectsvisibletouser (u.getid).has (p) then
				-- Second GET the id of the PBI
					if not attached hp.path_param("idpbi") then
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Missing idpbis in URL.")
					end
				id_pbi := hp.path_param("idpbis").to_integer
				pbi := db.getpbifromid (id_pbi)
				if   pbi.getbacklog.getproject.getid.is_equal (p.getid) then
					tasks := db.gettasksfrompbiid (pbi.getid)
					create j_tasks.make_array
					across tasks as t
					loop
						j_task := t.item.to_minimal_json
						j_tasks.add (j_task)
					end
					create json_response.make
								json_response.put (j_tasks, "tasks")
								send_json(hres, json_response)
				end
			end
	end
	end

feature
	createtask(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbis}/createtask
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		id_project : INTEGER
		id_pbis : INTEGER
		hp : HTTP_PARSER

		param_name        : STRING
		param_description        : STRING
		param_points        : STRING
		param_developer        : STRING
		param_state        : STRING
		param_pbi        : STRING

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

		p : PROJECT
		pbi : PBI
		t: TASK
		u,m : USER

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

			param_points:= hp.post_param ("points")
					if ok and not regex.check_integer (param_points) and param_points.to_integer < 0 then
						error_reason := "Points not present or not correct."
						ok := FALSE
					end

				param_state:= hp.post_param ("state")
						if ok and not regex.check_name (param_state) and not ec.statestring_to_int(param_pbi).is_equal (-1) then
							error_reason := "State not present or not correct."
							ok := FALSE
						end

				param_pbi:= hp.post_param ("pbi")
				pbi:= db.getpbifromid (param_pbi.to_integer)
						if ok and not  regex.check_integer (param_pbi) and pbi.getbacklog.getproject.getid.is_equal (id_project) then
								error_reason := "PBI not present or not correct."
								ok := FALSE
						end

				param_developer:= hp.post_param ("developer")
				u := db.getuserfromid (param_developer.to_integer)
						if ok and not regex.check_integer (param_developer) and db.getprojectsvisibletouser (u.getid).has (p)  then
							error_reason := "Developer not present or not correct."
							ok := FALSE
						end
				--CHECK m is manager
						m := get_session_user
						p := pbi.getbacklog.getproject
						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end

			if not ok then
				log.warning("/projects/"+  id_project.out +"/pbis/"+id_pbis.out +"/createtask [POST] Request error: " + error_reason)
				json_error.put_string (error_reason, "reason")
				send_json(hres, json_error)
			else

				if ok then
					create t.make (0, param_name, param_description, u, param_points.to_integer, ec.statestring_to_int(param_state), pbi)
					db.inserttask (t)
					log.info ("/projects/"+  id_project.out +"/pbis/"+id_pbis.out +"/createtask [POST] Created a new task "+param_name )
					-- send OK to the user :)				
					send_generic_ok(hres)
				end


			end

		end -- end ensure authenticated

	end -- end current feature

feature
	deletetask(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbis}/tasks/{idtask}/delete
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		hp : HTTP_PARSER
		m : USER
		p:PROJECT
		pbi: PBI
		t : TASK
		json_error : JSON_OBJECT
		ok : BOOLEAN

		id_project : INTEGER
		id_pbi : INTEGER
		id_task : INTEGER

		error_reason : STRING
	do
		http_request  := hreq
		http_response := hres
		ok := TRUE

		create hp.make(hreq)
		if ensure_authenticated and hp.is_good_request then
			-- Get the current user
			m := get_session_user

			-- First GET the id of the project
			if ok and not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				ok := FALSE
				-- And logs it
				log.warning (" /projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/delete [POST] Missing idproj in URL.")
			end
			id_project := hp.path_param("idproj").to_integer
			-- Second GET the id of the PBI
			if ok and not attached hp.path_param("idpbi") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning (" /projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/delete [POST] Missing idpbis in URL.")
			end
			id_pbi := hp.path_param("idpbis").to_integer
			-- Third GET the id of the task
			if ok and not attached hp.path_param("idtask") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning (" /projects/{idproj}/pbis/{idpbis}/tasks/{idtask}/delete [POST] Missing idpbis in URL.")
			end
			id_task := hp.path_param("idtask").to_integer
			t := db.gettaskfromid (id_task)
			pbi := t.getpbi
			p := pbi.getbacklog.getproject


			--CHECK m is manager
						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end

						if not ok then
							log.warning("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [POST] Request error: " + error_reason)
							json_error.put_string (error_reason, "reason")
							send_json(hres, json_error)
						else

							if ok then
								db.deletetaskfromid (t.getid)
								log.info (" /projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/delete [POST] Deleted a task "+t.getname )
								-- send OK to the user :)				
								send_generic_ok(hres)
							end
		end
	end
	end
feature
	edittask(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbis}/tasks/{idtask}/edit
	-- METHOD: POST
	--NOTE: All fields are required
	require
		hreq /= Void
		hres /= Void
	local
		regex : REGEX
		hp : HTTP_PARSER
		m : USER
		p:PROJECT
		pbi: PBI
		t : TASK
		u: USER
		json_error : JSON_OBJECT
		ok : BOOLEAN

		id_project : INTEGER
		id_pbi : INTEGER
		id_task : INTEGER

		param_name        : STRING
		param_description        : STRING
		param_points        : STRING
		param_developer        : STRING
		param_state        : STRING
		param_pbi        : STRING

		error_reason : STRING
	do
		http_request  := hreq
		http_response := hres
		ok := TRUE

		create hp.make(hreq)
		if ensure_authenticated and hp.is_good_request then
			-- Get the current user
			m := get_session_user

			-- First GET the id of the project
			if ok and not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				ok := FALSE
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [POST] Missing idproj in URL.")
			end
			id_project := hp.path_param("idproj").to_integer
			-- Second GET the id of the PBI
			if ok and not attached hp.path_param("idpbi") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [GET] Missing idpbis in URL.")
			end
			id_pbi := hp.path_param("idpbis").to_integer
			-- Third GET the id of the task
			if ok and not attached hp.path_param("idtask") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [GET] Missing idpbis in URL.")
			end
			id_task := hp.path_param("idtask").to_integer
			t := db.gettaskfromid (id_task)
			pbi := t.getpbi
			p := pbi.getbacklog.getproject

			-- Next check the POST parameters
			create regex.make
			-- Create the error object even if it is not necessary
			-- (in this case, this object is not used)
			create json_error.make
			json_error.put_string ("error", "status")

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

			param_points:= hp.post_param ("points")
					if ok and not regex.check_integer (param_points) and param_points.to_integer < 0 then
						error_reason := "Points not present or not correct."
						ok := FALSE
					end

				param_state:= hp.post_param ("state")
						if ok and not regex.check_name (param_state) and not ec.statestring_to_int(param_pbi).is_equal (-1) then
							error_reason := "State not present or not correct."
							ok := FALSE
						end

				param_pbi:= hp.post_param ("pbi")
						if ok and not  regex.check_integer (param_pbi) and pbi.getbacklog.getproject.getid.is_equal (id_project) then
								error_reason := "PBI not present or not correct."
								ok := FALSE
						end

				param_developer:= hp.post_param ("developer")
				u := db.getuserfromid (param_developer.to_integer)
						if ok and not regex.check_integer (param_developer) and db.getprojectsvisibletouser (u.getid).has (p)  then
							error_reason := "Developer not present or not correct."
							ok := FALSE
						end


			--CHECK m is manager
						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end

						if not ok then
							log.warning("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [POST] Request error: " + error_reason)
							json_error.put_string (error_reason, "reason")
							send_json(hres, json_error)
						else

							if ok then
								create t.make (id_task, param_name, param_description, u, param_points.to_integer, ec.statestring_to_int(param_state), pbi)
								db.editTask(t)
								log.info ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [POST] Edited a task "+param_name )
								-- send OK to the user :)				
								send_generic_ok(hres)
							end
		end
	end
	end
	end