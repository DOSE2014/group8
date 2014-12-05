note
	description: "Summary description for {REST_PROJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_PROJECTS

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
	listProjects(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
	-- PATH: /projects/listProjects
	-- METHOD: GET

		local
			projects: LINKED_SET[PROJECT]
			developersOfProject: LINKED_SET[USER]
			j_developers: JSON_ARRAY
			j_project: JSON_OBJECT
			j_projects: JSON_ARRAY
			json_response: JSON_OBJECT
			j_number: JSON_NUMBER
			u: USER
			hp: HTTP_PARSER
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)
			if ensure_authenticated
			then
				if hp.get_param ("id") = Void
				then
					u := get_session_user
				else
					u := db.getuserfromid (hp.get_param ("id").to_integer)
				end

				projects := db.getprojectsvisibletouser (u.getid)
				create j_projects.make_array
				create j_developers.make_array
				across projects as p
				loop
					j_project := p.item.to_json
					developersofproject := db.getdevelopersfromprojectid (p.item.getId)
					across developersofproject as d
					loop
						create j_number.make_integer (d.item.getId)
						j_developers.add (j_number)
					end
					j_project.put (j_developers, "developers")
					j_projects.add (j_project)
				end

				create json_response.make
				json_response.put (j_projects, "projects")
				send_json(hres, json_response)
			end
		end

	create_project(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		-- PATH: /projects/create
		-- METHOD: POST
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			ok: BOOLEAN
			error_reason: STRING
			json_error: JSON_OBJECT
			json_response: JSON_OBJECT
			p: PROJECT
			projId: INTEGER
			stakeholder: USER
			mgr: USER

			--Parameters
			param_name			: detachable STRING
			param_description	: detachable STRING
			param_manager		: detachable INTEGER
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)

			if ensure_authenticated and hp.is_good_request
			then
				create json_error.make
				json_error.put_string ("error", "status")
				stakeholder := get_session_user
				ok := TRUE

				param_name 			:= hp.post_param ("name")
				param_description 	:= hp.post_param ("description")
				param_manager 		:= hp.post_int_param ("manager")

				if ok and db.existsNameInProject(param_name)
				then
					error_reason := "Project name already exists."
					json_error.put_integer (1, "code")
					ok := FALSE
				end
				if ok and attached param_manager then
					mgr := db.getuserfromid (param_manager)
				else
					ok := FALSE
				end
				if ok and not attached mgr
				then
					error_reason := "Manager doesn't exist."
					json_error.put_integer (1, "code")
					ok := FALSE
				end
				if ok and mgr.getid = stakeholder.getId
				then
					error_reason := "The stakeholder cannot be manager."
					json_error.put_integer (1, "code")
					ok := FALSE
				end

				if ok
				then
					mgr := db.getuserfromid (param_manager.to_integer)
					create p.make (0, param_name, param_description, mgr, stakeholder, create {DATE_TIME}.make_now, FALSE)
					projId := db.insertproject (p)
					p.setid (projId)
					log.info ("/account/register [POST] Created a new project "+ param_name + " "+ param_description)
					create json_response.make
					json_response.put_string ("created", "status")
					json_response.put_integer (projId, "id")
					send_json (hres, json_response)
				end

				if not ok then
					log.warning("/projects/create [POST] Request error: " + error_reason)
					json_error.put_string (error_reason, "reason")
					send_json(hres, json_error)
				end
			end
		end

	addDeveloper(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		-- PATH: /projects/{idproj}/adddeveloper
		-- METHOD: POST
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER

			idProj: INTEGER
			project: PROJECT
			param_iddev: INTEGER
			developer: USER
			u: USER

			json_error: JSON_OBJECT
			error_reason: STRING
		do
			http_request := hreq
			http_response := hres
			create hp.make (hreq)

			if ensure_authenticated
			then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/adddeveloper [POST] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/adddeveloper [POST] Project not existent.")
					end

					if project.getmanager.getid = u.getId
					then
						create json_error.make
						json_error.put_string ("error", "status")

						param_iddev := hp.post_int_param ("iddev")
						developer := db.getuserfromid (param_iddev)
						if not attached developer then
							send_malformed_json(http_response)
							-- And logs it
							log.warning ("/projects/{idproj}/adddeveloper [POST] Developer not existent.")
						elseif developer.getusertype = {USERTYPE}.stakeholder
						then
							error_reason := "New developer cannot be stakeholder."
							json_error.put_integer (1, "code")
							log.warning("/projects/{idproj}/adddeveloper [POST] Request error: " + error_reason)
							json_error.put_string (error_reason, "reason")
							send_json(hres, json_error)
						else
							db.adddevelopertoproject (param_iddev, idProj)

							log.info ("/projects/" + idproj.out + "/adddeveloper [POST] Added developer to project")

							-- send OK to the user :)				
							send_generic_ok(hres)

						end
					else
						no_permission
					end
				end
			end
		end

	remDeveloper(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		-- PATH: /projects/{idproj}/remdeveloper
		-- METHOD: POST
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER

			idProj: INTEGER
			project: PROJECT
			param_iddev: INTEGER
			developer: USER
			u: USER

			json_error: JSON_OBJECT
		do
			http_request := hreq
			http_response := hres
			create hp.make (hreq)


			if ensure_authenticated
			then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/remdeveloper [POST] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/remdeveloper [POST] Project not existent.")
					end

					if project.getmanager.getid = u.getId
					then
						create json_error.make
						json_error.put_string ("error", "status")

						param_iddev := hp.post_int_param ("iddev")
						developer := db.getuserfromid (param_iddev)
						if not attached developer then
							send_malformed_json(http_response)
							-- And logs it
							log.warning ("/projects/{idproj}/adddeveloper [POST] Developer not existent.")
						else
							db.deletedeveloperfromproject (param_iddev, idProj)

							log.info ("/projects/" + idproj.out + "/remdeveloper [POST] Removed developer from project")

							-- send OK to the user :)				
							send_generic_ok(hres)

						end
					else
						no_permission
					end
				end
			end
		end

	editProject(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		-- PATH: /projects/{idproj}/edit
		-- METHOD: POST
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			u: USER
			json_error: JSON_OBJECT
			idProj: INTEGER
			project: PROJECT
			param_name: detachable STRING
			param_description: detachable STRING
			param_manager: detachable INTEGER
			ok: BOOLEAN
			newMgr: USER
			developers: LINKED_SET[USER]

			error_reason: STRING
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)
			if ensure_authenticated and hp.is_good_request
			then
				u := get_session_user
				create json_error.make

				ok := true

				idProj := hp.path_param ("idproj").to_integer
				project := db.getprojectfromid (idProj)

				if ok and not attached project
				then
					error_reason := "Project doesn't exist."
					json_error.put_integer (1, "code")
					ok := false
				end

				if ok and u.getid /= project.getmanager.getid then
					no_permission
				end


				if attached hp.post_param ("name") then
					param_name := hp.post_param ("name")
					if ok and db.existsnameinproject (param_name) then
						error_reason := "Project name already exists."
						json_error.put_integer (1, "code")
						ok := false
					end
				end

				if attached hp.post_param ("description") then
					param_description := hp.post_param ("description")
				end

				if attached hp.post_int_param ("manager") then
					param_manager := hp.post_int_param ("manager")
					newMgr := db.getuserfromid (param_manager)
					if ok and not attached newMgr then
						error_reason := "New manager doesn't exist."
						json_error.put_integer (1, "code")
						ok := false
					end

					if ok and newMgr.getusertype = {USERTYPE}.stakeholder then
						error_reason := "Stakeholder cannot be manager."
						json_error.put_integer (1, "code")
						ok := false
					end

					if ok then
						developers := db.getdevelopersfromprojectid (idproj)
						across developers as d
						loop
							if d.item.getId = newMgr.getid then
								error_reason := "New manager can't be among the developers of the project."
								json_error.put_integer (1, "code")
								ok := false
							end
						end
					end
				end

				if ok then
					if attached param_name then
						project.setname (param_name)
					end
					if attached param_manager then
						project.setmanager (db.getuserfromid (param_manager))
					end
					if attached param_description then
						project.setdescription (param_description)
					end

					db.editProject(project)
					log.info ("/projects/{idproj}/edit [POST] Edited project " + idproj.out + ".")

					-- send OK to the user :)				
					send_generic_ok(hres)

				end

				if not ok then
					log.warning("/projects/{idproj}/edit [POST] Request error: " + error_reason)
					json_error.put_string (error_reason, "reason")
					send_json(hres, json_error)
				end
			end
		end

	getBacklog(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			backlog: BACKLOG
			u: USER
			project: PROJECT
			json_error: JSON_OBJECT
			j_backlog: JSON_OBJECT
			j_pbi: JSON_OBJECT
			j_pbis: JSON_ARRAY
			ok: BOOLEAN
			idProj: INTEGER
			error_reason: STRING
			pbis: LINKED_SET[PBI]
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)

			if ensure_authenticated and hp.is_good_request then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/projects/{idproj}/getbacklog [GET] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/projects/{idproj}/getbacklog [GET] Project not existent.")
					else
						backlog := db.getbacklogfromprojectid (idProj)
						create json_error.make
						if not attached backlog then
							error_reason := "Backlog doesn't exist"
							json_error.put_integer (1, "code")
							log.warning("/projects/{idproj}/getbacklog [GET] Request error: " + error_reason)
							json_error.put_string ("no", "backlog")
						else
							create j_backlog.make
							create j_pbis.make_array
							j_backlog.put_string(backlog.getdescription, "description")
							pbis := db.getPBIsFromBacklogId(backlog.getid)
							across pbis as p
							loop
								j_pbi := p.item.to_json
								j_pbis.add (j_pbi)
							end
							j_backlog.put (j_pbis, "pbis")
						end
					end
				end

			end

		end
end
