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
		param_priority    : INTEGER
		param_dueDate	  : INTEGER

		regex : REGEX
		json_error  : JSON_OBJECT
		error_reason : STRING

		ok : BOOLEAN

		u : USER
		p : PBI
		proj : PROJECT
		backlog : BACKLOG
		pbitype : PBITYPE

	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		create pbitype

		if ensure_authenticated and hp.is_good_request then

			u := get_session_user

			-- First GET the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param ("idproj").is_integer then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/create [POST] Missing idproj in URL.")
			else
				id_project := hp.path_param("idproj").to_integer
				proj := db.getprojectfromid (id_project)

				if not attached proj then	-- does project exist?
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/pbis/create [POST] Project not existent.")
				elseif proj.getmanager.getId = u.getId then					-- is the user the manager?

					-- Next check the POST parameters
					create regex.make
					-- Create the error object even if it is not necessary
					-- (in this case, this object is not used)
					create json_error.make
					json_error.put_string ("error", "status")


					ok := TRUE

					param_name := hp.post_param ("name")
					if ok and (not attached param_name or not regex.check_name (param_name)) then
						error_reason := "Name not present or not correct."
						json_error.put_string ("name","field")
						ok := FALSE
					end

					param_description := hp.post_param ("description")
					if ok and not attached param_description then
						error_reason := "Description not present or not correct."
						json_error.put_string ("description","field")
						ok := FALSE
					end


					param_type := hp.post_param ("type")
					if ok and (not regex.check_name (param_type) or not pbitype.is_valid(param_type)) then
						error_reason := "Type not present or not correct."
						json_error.put_string ("type","field")
						ok := FALSE
					end

					param_priority := hp.post_int_param ("priority")
					if ok and not regex.check_integer (param_priority.out) then
						error_reason := "Priority not present or not integer."
						json_error.put_string ("priority","field")
						ok := FALSE
					end

					param_duedate := hp.post_int_param ("dueDate")
					if ok and not regex.check_integer (param_duedate.out) then
						error_reason := "dueDate not present or not unixtimestamp."
						json_error.put_string ("dueDate","field")
						ok := FALSE
					end


					if not ok then
						log.warning("/projects/{idproj}/pbis/create [POST] Request error: " + error_reason)
						json_error.put_string (error_reason, "reason")
						send_json(hres, json_error)
					else

						backlog := db.getBacklogFromProjectId (id_project)

						create p.make (0, param_name, param_description, backlog, Void, pbitype.to_integer(param_type),
						param_priority.to_integer, create {DATE_TIME}.make_from_epoch(param_dueDate.to_integer))

						db.insertpbi (p)

						log.info ("/projects/"+id_project.out+"/pbis/create [POST] Added pbi to project")

						-- send OK to the user :)				
						send_generic_ok(hres)

					end
				else
					no_permission
				end
			end -- else not attached hp.path_param("idproj")
		else
			if not hp.is_good_request then
				send_malformed_json (http_response)
			end
		end -- end ensure authenticated

	end -- end current feature





	edit_pbi(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbi}/delete
	-- METHOD: POST
	local
		id_project : INTEGER
		id_pbi : INTEGER
		hp : HTTP_PARSER

		pbi : PBI
		proj : PROJECT
		u : USER

		param : STRING
		param_int : INTEGER
		regex : REGEX
		pbitype : PBITYPE
	do
		http_request  := hreq
		http_response := hres

		create hp.make (hreq)

		if ensure_authenticated and hp.is_good_request then

			u := get_session_user

			-- First GET the id of the project
			if not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/edit [POST] Missing idproj in URL.")
			else
				id_project := hp.path_param("idproj").to_integer
				proj := db.getprojectfromid (id_project)

				if not attached proj then	-- does project exist?
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/pbis/{idpbi}/edit [POST] Project not existent.")

				-- is the user the manager?
				elseif proj.getmanager.getId /= u.getId then
					no_permission	-- send error to the user
				elseif not attached hp.path_param("idpbi") then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/pbis/{idpbi}/edit [POST] Missing idpbi in URL.")
				else
					id_pbi := hp.path_param("idpbi").to_integer
					pbi := db.getpbifromid (id_pbi)

					if not attached pbi then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/pbis/{idpbi}/edit [POST] PBI not existent.")
					else

						create regex.make
						create pbitype

						param := hp.post_param ("name")
						if regex.check_name (param) then
							pbi.setname (param)
						end

						param := hp.post_param ("description")
						if regex.check_name (param) then
							pbi.setdescription (param)
						end

						param := hp.post_param ("type")
						if regex.check_name (param) and pbitype.is_valid(param) then
							pbi.settype (pbitype.to_integer(param))
						end

						param_int := hp.post_int_param ("priority")
						if regex.check_integer (param_int.out) then
							pbi.setpriority (param_int)
						end

						param_int := hp.post_int_param ("dueDate")
						if regex.check_unixtime (param_int.out) then
							pbi.setduedate (create {DATE_TIME}.make_from_epoch(param_int))
						end

						db.editpbi (pbi)

						log.deb ("/projects/{idproj}/pbis/{idpbi}/edit [POST] PBI with id " + pbi.getid.out + " edited.")
						-- send OK to the user :)				
						send_generic_ok(hres)

					end

				end
			end
		else
			if not hp.is_good_request then
				send_malformed_json (http_response)
			end
		end -- end ensure authenticated
	end	-- end current feature






	delete_pbi(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /projects/{idproj}/pbis/{idpbi}/delete
	-- METHOD: POST
	local
		id_project : INTEGER
		id_pbi : INTEGER
		hp : HTTP_PARSER

		pbi : PBI
		tasksOfPBI: LINKED_SET[TASK]
		proj : PROJECT
		u : USER
	do
		http_request  := hreq
		http_response := hres

		create hp.make (hreq)

		if ensure_authenticated then

			u := get_session_user

			-- First GET the id of the project
			if not attached hp.path_param("idproj") then
				send_malformed_json(http_response)
				-- And logs it
				log.warning ("/projects/{idproj}/pbis/{idpbi}/delete [POST] Missing idproj in URL.")
			else
				id_project := hp.path_param("idproj").to_integer
				proj := db.getprojectfromid (id_project)

				if not attached proj then	-- does project exist?
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/pbis/{idpbi}/delete [POST] Project not existent.")

				-- is the user the manager?
				elseif proj.getmanager.getId /= u.getId then
					no_permission	-- send error to the user
				elseif not attached hp.path_param("idpbi") then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/pbis/{idpbi}/delete [POST] Missing idpbi in URL.")
				else
					id_pbi := hp.path_param("idpbi").to_integer
					pbi := db.getpbifromid (id_pbi)

					if not attached pbi then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/pbis/{idpbi}/delete [POST] PBI not existent.")
					else
						db.deletepbifromid (pbi.getid)
						tasksOfPBI := db.gettasksfrompbiid (pbi.getid)
						across tasksOfP as t
						loop
							db.deletetaskfromid (t.item.getId)
						end
						log.deb ("/projects/{idproj}/pbis/{idpbi}/delete [POST] PBI with id " + pbi.getid.out + " deleted.")

						-- send OK to the user :)				
						send_generic_ok(hres)

					end

				end
			end

		end -- end ensure authenticated
	end	-- end current feature

end
