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
		id_pbi : INTEGER
		hp : HTTP_PARSER

		param_name         : STRING
		param_description  : STRING
		param_points       : INTEGER
		param_developer    : INTEGER
		param_state        : STRING
		param_completionDate: INTEGER

		state : STATE

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

		p : PROJECT
		pbi : PBI
		t: TASK
		dev,m : USER
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
				send_generic_error ("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbis}/create [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					send_generic_error ("Project not found.", hres)
					ok := FALSE
				end
			end

			-- First GET the id of the project
			if not attached hp.path_param("idpbi") or not hp.path_param("idpbi").is_integer then
				send_generic_error ("idpbi not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbis}/create [POST] Missing idpbi in URL.")
				ok := FALSE
			elseif ok then
				id_pbi := hp.path_param("idpbi").to_integer
				pbi := db.getpbifromid(id_pbi)
				if not attached pbi or pbi.getbacklog.getproject.getid /= p.getId then
					send_generic_error ("PBI not found or not in project.", hres)
					ok := FALSE
				end
			end

			m := get_session_user
			-- CHECK if m is manager
			if ok and p.getmanager.getid /= m.getid then
				send_generic_error ("The current user is not manager of the project", hres)
				ok := FALSE
			end

			if ok then
				-- Next check the POST parameters
				create regex.make

				json_error.put_string ("error", "status")

				param_name := hp.post_param ("name")
				if ok and (not attached param_name or param_name.is_empty) then
					error_reason := "Name not present or not correct."
					ok := FALSE
				end

				param_description := hp.post_param ("description")
				if ok and (not attached param_description or param_description.is_empty) then
					error_reason := "Description not present or not correct."
					ok := FALSE
				end

				param_points := hp.post_int_param ("points")
				if ok and (not attached param_points or param_points < 0) then
					error_reason := "Points not present or not correct."
					ok := FALSE
				end

				create state
				param_state := hp.post_param ("state")
				if ok and (not attached param_state or not state.is_valid (param_state)) then
					error_reason := "State not present or not correct."
					ok := FALSE
				end

				param_developer := hp.post_int_param ("developer")
				if ok and not attached param_developer then
					error_reason := "Developer not present."
					ok := FALSE
				elseif ok then
					dev := db.getuserfromid (param_developer)
					if not attached dev or not db.checkvisibilityforproject (dev.getid, p.getid) then
						error_reason := "Developer not exists or not in the project."
						ok := FALSE
					end
				end

				param_completionDate := hp.post_int_param ("completionDate")
				if ok and not regex.check_unixtime (param_completionDate.out)then
					error_reason := "Completion date in bad format"
					ok := FALSE
				end

				if ok and not p.getmanager.getid.is_equal (m.getid) then
					error_reason := "The current user is not manager of the project"
					ok := FALSE
				end

				if not ok then
					log.warning("/projects/{idproj}/pbis/{idpbis}/createtask [POST] Request error: " + error_reason)
					json_error.put_string (error_reason, "reason")
					send_json(hres, json_error)
				end
			end -- end if ok

			if ok then
					create completionDate.make_from_epoch (param_completiondate)
					create t.make (0, param_name, param_description, dev, param_points.to_integer, state.to_integer(param_state), pbi, completiondate)
					db.inserttask (t)
					log.info ("/projects/{idproj}/pbis/{idpbis}/createtask [POST] Created a new task "+param_name )
					-- send OK to the user :)				
					send_generic_ok(hres)
			end

		else
			if not hp.is_good_request then
				send_malformed_json (hres)
			end
		end -- end ensure authenticated

	end -- end current feature

feature
	deletetask(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/tasks/{idtask}/delete
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		hp  : HTTP_PARSER
		m   : USER
		p   : PROJECT

		t  : TASK
		ok : BOOLEAN

		id_project : INTEGER
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
			if ok and ( not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer) then
				send_generic_error ("idproj not found or not integer.", hres)
				ok := FALSE
				log.warning ("/projects/{idproj}/tasks/{idtask}/delete [POST] Missing idproj in URL.")
			end
			id_project := hp.path_param("idproj").to_integer

			-- Third GET the id of the task
			if ok and (not attached hp.path_param("idtask") or not hp.path_param("idtask").is_integer) then
				send_generic_error ("idtask not found or not integer.", hres)
				ok := FALSE
				log.warning (" /projects/{idproj}/tasks/{idtask}/delete [POST] Missing idtask in URL.")
			end
			id_task := hp.path_param("idtask").to_integer

			t := db.gettaskfromid (id_task)
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

			if ok then
				db.deletetaskfromid (t.getid)
				log.info (" /projects/{idproj}/tasks/{idtask}/delete [POST] Deleted a task "+t.getname )
				-- send OK to the user :)				
				send_generic_ok(hres)
			end
		end	-- end if ensure authenticated
	end

feature
	edittask(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/tasks/{idtask}/edit
	-- METHOD: POST
	--NOTE: All fields are OPTIONAL
	require
		hreq /= Void
		hres /= Void
	local
		regex : REGEX
		hp    : HTTP_PARSER
		m     : USER
		p     : PROJECT
		pbi   : PBI
		task  : TASK
		dev   : USER

		ok           : BOOLEAN
		id_project   : INTEGER
		id_task      : INTEGER
		param_string : STRING
		param_int    : INTEGER

		state        : STATE
		completionDate: DATE_TIME
	do
		http_request  := hreq
		http_response := hres
		ok := TRUE	-- Guard variable

		create hp.make(hreq)
		if ensure_authenticated and hp.is_good_request then
			-- Get the current user
			m := get_session_user

			-- First GET the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_generic_error ("idproj not found or not integer.", hres)
				ok := FALSE
				-- And logs it
				log.warning ("/projects/{idproj}/tasks/{idtask}/edit [POST] Missing idproj in URL.")
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)

				if not attached p then
					send_generic_error ("Project not found", hres)
					ok := FALSE
					log.warning ("/projects/{idproj}/tasks/{idtask}/edit [POST] Project not found.")
				end
			end


			-- Second GET the id of the task
			if ok and not attached hp.path_param("idtask") or not hp.path_param("idproj").is_integer then
				ok := FALSE
				send_generic_error ("idtask not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/tasks/{idtask}/edit [POST] Missing idtask in URL.")
			end
			if ok then
				id_task := hp.path_param("idtask").to_integer
				task := db.gettaskfromid (id_task)
				if not attached task then
					send_generic_error ("Task not found", hres)
					ok := FALSE
					log.warning ("/projects/{idproj}/tasks/{idtask}/edit [POST] Task not found.")
				end
			end

			-- CHECK if m is manager
			if ok and not p.getmanager.getid.is_equal (m.getid) then
				send_generic_error ("The current user is not manager of the project", hres)
				ok := FALSE
				log.warning ("/projects/{idproj}/tasks/{idtask}/edit [POST] The current user is not manager of the project.")
			end

			if ok then
				-- Next check the POST parameters
				create regex.make

				param_string := hp.post_param ("name")
				if ok and not param_string.is_empty then
					task.setName (param_string)
				end

				param_string := hp.post_param ("description")
				if ok and not param_string.is_empty then
					task.setDescription (param_string)
				end

				param_int := hp.post_int_param ("points")
				if attached param_int and regex.check_integer (param_int.out) and param_int.to_integer >= 0 then
					task.setPoints (param_int)
				end

				create state
				param_string := hp.post_param ("state")
				if attached param_string and state.is_valid(param_string) then
					task.setState ( state.to_integer(param_string) )
				end

				param_int := hp.post_int_param ("pbi")
				if attached param_int and regex.check_integer (param_int.out)  then
					pbi := db.getpbifromid (param_int)
					if attached pbi then
						if pbi.getbacklog.getproject.getid = id_project then
							task.setpbi (pbi)
						end
					end
				end

				param_int := hp.post_int_param ("completionDate")
				if attached param_int and regex.check_unixtime (param_int.out)then
					create completiondate.make_from_epoch (param_int)
					task.setcompletiondate (completiondate)
				end

				param_int := hp.post_int_param ("developer")
				if attached param_int then
					dev := db.getuserfromid (param_int)
					if db.checkvisibilityforproject (dev.getid, p.getid)  then
						task.setdeveloper (dev)
					end
				end

				db.editTask(task)
				log.info ("/projects/{idproj}/tasks/{idtask}/edit [POST] Edited a task "+task.getname )
				-- send OK to the user :)				
				send_generic_ok(hres)

			end -- end if ok

		elseif not hp.is_good_request then
			 send_malformed_json (hres)
			 log.info ("/projects/{idproj}/tasks/{idtask}/edit [POST] Malformed JSON")

		end -- end ensure_authenticated

	end -- end of feature


end	-- end of class
