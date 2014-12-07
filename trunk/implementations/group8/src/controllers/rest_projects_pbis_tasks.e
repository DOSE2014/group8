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

feature {NONE}	-- Private methods

	print_list_of_tasks(pbiid : INTEGER)
	-- This methods print the list of tasks to the client
	-- having the PBI id requested.
	require
		http_response /= Void
	local
		j_task : JSON_OBJECT
		j_tasks : JSON_ARRAY
		tasks : LINKED_SET[TASK]
		json_response : JSON_OBJECT
	do
		create j_tasks.make_array
		-- Get tasks from database
		tasks := db.gettasksfrompbiid (pbiid)

		if attached tasks then
			-- Across over the tasks array

			across tasks as t
			loop
				j_task := t.item.to_minimal_json
				j_tasks.add (j_task)
			end
		end

		-- Create and fill the JSON response
		create json_response.make
		json_response.put (j_tasks, "tasks")
		send_json(http_response, json_response)
	end

----------------------------------------------------------------------------------------------
-- PUBLIC FEATURES
----------------------------------------------------------------------------------------------
feature
	listtasks(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbis}/listtasks
	-- METHOD: GET
	--TODO: manage unauthorized requests
	require
		hreq /= Void
		hres /= Void
	local
		u : USER
		id_project : INTEGER
		id_pbi :INTEGER
		p:PROJECT
		pbi : PBI
		hp: HTTP_PARSER
		b: BACKLOG
		ok : BOOLEAN
	do
		http_request  := hreq
		http_response := hres

		ok := TRUE

		create hp.make (hreq)

		if ensure_authenticated then

			u := get_session_user
			-- First GET the id of the project
			if ok and (not attached hp.path_param("idproj") or not attached hp.path_param("idproj").is_integer) then
				send_generic_error("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Missing idproj in URL.")
				ok := FALSE
			end
			if ok then
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					ok := FALSE
					send_generic_error("Project does not exists.", hres)
					log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Project does not exist.")
				end
			end

			if ok and not db.checkVisibilityForProject(u.getId, p.getId) then
				no_permission
				ok := FALSE
			end
			-- Second GET the id of the PBI
			if ok and (not attached hp.path_param("idpbi") or not attached hp.path_param("idpbi").is_integer) then
				send_generic_error("idpbi not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Missing idpbis in URL.")
				ok := FALSE
			else
				id_pbi := hp.path_param("idpbi").to_integer
				pbi := db.getpbifromid (id_pbi)
				if not attached pbi then
					ok := FALSE
					send_generic_error("PBI does not exists.", hres)
					log.warning ("/projects/{idproj}/pbis/{idpbi}/listtasks [GET] Project does not exist.")
				end
			end
			if ok then
				b := db.getbacklogfromid (pbi.getbacklog.getid)
				if   b.getproject.getid.is_equal (p.getid) then
					print_list_of_tasks(pbi.getid)
				else
					-- PBI and Project doesn't match
					send_generic_error("PBI in not in Project", hres)
				end
			end

		end	-- end ensure_authenticated
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
		param_completionDate: INTEGER

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

		p : PROJECT
		pbi : PBI
		t: TASK
		u,m : USER
		completionDate: DATE_TIME

	do
		ok := TRUE

		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		-- Create the error object even if it is not necessary
		-- (in this case, this object is not used)
		create json_error.make

		if ensure_authenticated and hp.is_good_request then

			-- First GET the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/create [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
			end

			-- Next check the POST parameters
			create regex.make

			json_error.put_string ("error", "status")

			param_name := hp.post_param ("name")
			if ok and param_name.is_empty then
				error_reason := "Name not present or not correct."
				ok := FALSE
			end

			param_description := hp.post_param ("description")
			if ok and param_description.is_empty then
				error_reason := "Description not present or not correct."
				ok := FALSE
			end

			param_points:= hp.post_int_param ("points").out
			if ok and not regex.check_integer (param_points) and param_points.to_integer < 0 then
				error_reason := "Points not present or not correct."
				ok := FALSE
			end

			param_state:= hp.post_param ("state")
			if ok and not regex.check_name (param_state) and not ec.statestring_to_int(param_state).is_equal (-1) then
				error_reason := "State not present or not correct."
				ok := FALSE
			end

			param_pbi:= hp.post_int_param ("pbi").out
			if ok and  regex.check_integer (param_pbi) then
				pbi:= db.getpbifromid (param_pbi.to_integer)
			end

			if ok and not  regex.check_integer (param_pbi) and pbi.getbacklog.getproject.getid.is_equal (id_project) then
					error_reason := "PBI not present or not correct."
					ok := FALSE
			end

			param_developer:= hp.post_int_param ("developer").out
			if ok and regex.check_integer (param_developer) then
				u := db.getuserfromid (param_developer.to_integer)
			end

			if ok and not regex.check_integer (param_developer) and db.checkvisibilityforproject (u.getid, p.getid)  then
				error_reason := "Developer not present or not correct."
				ok := FALSE
			end

			param_completionDate := hp.post_int_param ("completionDate")
			if ok and not regex.check_unixtime (param_completionDate.out)then
				error_reason := "Completion date in bad format"
				ok := FALSE
			end

			--CHECK m is manager
			m := get_session_user
			if ok then
				p := pbi.getbacklog.getproject
			end

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
					create completionDate.make_from_epoch (param_completiondate)
					create t.make (0, param_name, param_description, u, param_points.to_integer, ec.statestring_to_int(param_state), pbi, completiondate)
					db.inserttask (t)
					log.info ("/projects/"+  id_project.out +"/pbis/"+id_pbis.out +"/createtask [POST] Created a new task "+param_name )
					-- send OK to the user :)				
					send_generic_ok(hres)
				end
			end

		else
			if not hp.is_good_request then
				send_malformed_json (hres)
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
			id_pbi := hp.path_param("idpbi").to_integer
			-- Third GET the id of the task
			if ok and not attached hp.path_param("idtask") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning (" /projects/{idproj}/pbis/{idpbis}/tasks/{idtask}/delete [POST] Missing idpbis in URL.")
			end
			id_task := hp.path_param("idtask").to_integer
			t := db.gettaskfromid (id_task)
	--		pbi := t.getpbi
			p := db.getprojectfromid (id_project)

			if ok and not attached p then
				send_generic_error ("Project not found", hres)
				ok := FALSE
			end

			if ok and not attached t then
				send_generic_error ("Task not found", hres)
				ok := FALSE
			end

			--CHECK m is manager
			if ok and not p.getmanager.getid.is_equal (m.getid) then
				send_generic_error ("The current user is not manager of the project", hres)
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
		end	-- end if ensure authenticated
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
		param_completionDate: INTEGER

		completionDate: DATE_TIME

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
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
			end

			if ok and not attached p then
				send_generic_error ("Project not found", hres)
				ok := FALSE
			end

			-- Second GET the id of the PBI
			if ok and not attached hp.path_param("idpbi") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [GET] Missing idpbis in URL.")
			else
				id_pbi := hp.path_param("idpbi").to_integer
			end
			-- Third GET the id of the task
			if ok and not attached hp.path_param("idtask") then
				ok := FALSE
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [GET] Missing idpbis in URL.")
			else
				id_task := hp.path_param("idtask").to_integer
				t := db.gettaskfromid (id_task)
			end
			if ok and not attached t then
				send_generic_error ("Task not found", hres)
				ok := FALSE
			end

			-- Next check the POST parameters
			create regex.make
			-- Create the error object even if it is not necessary
			-- (in this case, this object is not used)
			create json_error.make
			json_error.put_string ("error", "status")

			param_name := hp.post_param ("name")
			if ok and  param_name.is_empty then
				error_reason := "Name not present or not correct."
				ok := FALSE
			end

			param_description := hp.post_param ("description")
			if ok and  param_description.is_empty then
				error_reason := "Description not present or not correct."
				ok := FALSE
			end

			param_points:= hp.post_int_param ("points").out
			if ok and not regex.check_integer (param_points) and param_points.to_integer < 0 then
				error_reason := "Points not present or not correct."
				ok := FALSE
			end

			param_state:= hp.post_param ("state")
			if ok and not regex.check_name (param_state) and not ec.statestring_to_int(param_pbi).is_equal (-1) then
				error_reason := "State not present or not correct."
				ok := FALSE
			end

			param_pbi:= hp.post_int_param ("pbi").out
			if ok and not  regex.check_integer (param_pbi) and pbi.getbacklog.getproject.getid.is_equal (id_project) then
					error_reason := "PBI not present or not correct."
					ok := FALSE
			end

			param_completionDate := hp.post_int_param ("completionDate")
			if ok and not regex.check_unixtime (param_completionDate.out)then
				error_reason := "Completion date in bad format"
				ok := FALSE
			end

			param_developer:= hp.post_int_param ("developer").out
			u := db.getuserfromid (param_developer.to_integer)
			if ok and not regex.check_integer (param_developer) and db.checkvisibilityforproject (u.getid, p.getid)  then
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
					pbi := db.getpbifromid (param_pbi.to_integer)
					create completiondate.make_from_epoch (param_completionDate)
					create t.make (id_task, param_name, param_description, u, param_points.to_integer, ec.statestring_to_int(param_state), pbi, completionDate)
					db.editTask(t)
					log.info ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit [POST] Edited a task "+param_name )
					-- send OK to the user :)				
					send_generic_ok(hres)
				end
			end

		end -- end ensure_authenticated

	end -- end of feature


end	-- end of class
