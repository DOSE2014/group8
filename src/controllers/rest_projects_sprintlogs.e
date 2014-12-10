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

feature {NONE} -- Constructors

	make (sm: WSF_SESSION_MANAGER; pdt_db: PDT_DB)
		require
			sm /= Void
			pdt_db /= Void
		do
			session_manager := sm
			db := pdt_db
		end

feature {NONE} -- Private properies

	db: PDT_DB

feature -- declaring deferred properties

	session_manager: WSF_SESSION_MANAGER
	http_request: WSF_REQUEST
	http_response: WSF_RESPONSE

feature {NONE}
	printListOfSprintlog(id_project : INTEGER)
	local
		sprints: LINKED_SET [SPRINTLOG]
		j_sprint: JSON_OBJECT
		j_sprints: JSON_ARRAY
		json_response: JSON_OBJECT

	do
		sprints := db.listsprintlogsfromprojectid (id_project) --Get sprints
		create j_sprints.make_array

		if attached sprints then
			across
				sprints as s
			loop --prepare json array of sprints
				j_sprint := s.item.to_minimal_json
				j_sprints.add (j_sprint)
			end
		end

		create json_response.make
		json_response.put (j_sprints, "sprintlogs") --put json array of sprints into response
		send_json (http_response, json_response) -- and send it
		-- If there are no sprintlogs, the output is correct (empty array)
	end

feature

	listSprintlogs (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
	-- PATH: /projects/{idproj}/sprintlogs/list
	-- METHOD: GET
	require
		hreq /= Void
		hres /= Void
	local


		u: USER
		id_project: INTEGER
		hp: HTTP_PARSER
	do
		http_request := hreq
		http_response := hres

		create hp.make (hreq)
		if ensure_authenticated then
			u := get_session_user
				--		print (hp.path_param ("idproj"))
			if attached hp.path_param ("idproj") and hp.path_param ("idproj").is_integer then
				id_project := hp.path_param ("idproj").to_integer --get id of the project
				if db.checkVisibilityForProject (u.getId, id_project) then

					printListOfSprintlog(id_project)

				else -- if user has no visibility of the project
					no_permission
					log.warning ("/projects/{idproj}/sprintlogs/list [GET] The user has not access to project.")
				end

			else -- if not attached hp.path_param("idproj")
				send_generic_error("Project id not found or not integer.", hres)
				log.warning ("/projects/{idproj}/sprintlogs/list [GET] Missing idproj in URL.")
			end -- End if else end attached hp.path_param("idproj")

		end -- End ensure_authenticated
	end



	createSprintlog (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
	-- PATH: /projects/{idproj}/sprintlogs/create
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		id_project: INTEGER
		hp: HTTP_PARSER
		param_name: STRING
		param_description: STRING
		param_startDate: INTEGER
		param_endDate: detachable INTEGER
		param_idpbis: detachable ARRAYED_LIST [STRING]
		regex: REGEX
		ok: BOOLEAN
		p: PROJECT
		m: USER
		s: SPRINTLOG

		json_error  : JSON_OBJECT
		error_reason : STRING
		error_field  : STRING
	do
		http_request := hreq
		http_response := hres

		ok := TRUE
		create hp.make (hreq)
		if ensure_authenticated and hp.is_good_request then

			-- Get id of the project from url and check if it's a good
			-- project id. Then verify the user permission
			if attached hp.path_param ("idproj") and hp.path_param ("idproj").is_integer then --CHECK request
				id_project := hp.path_param ("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					ok := FALSE
					send_generic_error("Project does not exists.", hres)
					log.warning ("/projects/{idproj}/sprintlogs/create [POST] Project does not exist.")
				end
			else
				ok := FALSE
				send_generic_error("Project does not exists.", hres)
				log.warning ("/projects/{idproj}/sprintlogs/create [POST] idproj not valid.")
			end

			m := get_session_user
			-- CHECK if m is manager
			if ok and p.getmanager.getid /= m.getid then
				no_permission
				ok := FALSE
			end

			if ok then

				create json_error.make
				create regex.make
				json_error.put_string ("error", "status")

				-- BEGIN check the POST parameters
				param_name := hp.post_param ("name")
				if ok and (not attached param_name or param_name.is_empty) then
					error_reason := "Name not present or not correct."
					error_field  := "name"
					ok := FALSE
				end

				param_description := hp.post_param ("description")
				if ok and (not attached param_description or param_description.is_empty) then
					error_reason := "Description not present or not correct."
					error_field  := "description"
					ok := FALSE
				end

				param_startDate := hp.post_int_param ("startDate")
				if ok and (not attached param_startdate or not regex.check_unixtime(param_startDate.out)) then
					error_reason := "Start date not present or not correct (it should be unixtimestamp in seconds)."
					error_field  := "startDate"
					ok := FALSE
				end

				param_endDate := hp.post_int_param ("endDate")
				if ok and (not attached param_enddate or not regex.check_unixtime(param_endDate.out)) then
					error_reason := "Start date not present or not correct (it should be unixtimestamp in seconds)."
					error_field  := "endDate"
					ok := FALSE
				end

				--TODO: check if every pbi exists
				param_idpbis := hp.post_array_param ("idpbis")
				if attached param_idpbis then
					across
						param_idpbis as e
					loop
						if ok and not regex.check_integer (e.item) then
							error_reason := "PBI not present or not correct."
							json_error.put_string ("idpbis", "field")
							ok := FALSE
						end
					end --end loop
				else
					error_reason := "PBI not present or not correct."
					error_field  := "idpbis"
					ok := FALSE
				end

				if not ok then
					log.warning("/projects/{idproj}/sprintlogs/create [POST] Request error: " + error_reason)
					json_error.put_string (error_reason, "reason")
					json_error.put_string (error_field,  "field")
					send_json(hres, json_error)
				end

			end

			if ok then --FINALLY good REPLY (JSON send should be only here)
				create s.make (0, param_name, param_description, db.getbacklogfromprojectid (id_project),
								create {DATE_TIME}.make_from_epoch (param_startDate),
								create {DATE_TIME}.make_from_epoch (param_endDate))
				db.insertsprintlog (s)
				log.info ("/projects/{idproj}/sprintlogs/create [POST] Created a new sprintlog " + param_name)
				send_generic_ok (hres) -- send OK to the user :)
			end


		else --if not authenticated or not good request
			if not hp.is_good_request then
					-- Bad request
				send_malformed_json (http_response)
				log.warning ("/projects/{idproj}/sprintlogs/create [POST] JSON request malformed.")
			end
		end -- end ensure authenticated and good request
	end -- end current feature

	listPBIs (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
			-- PATH: /projects/{idproj}/sprintlogs/{idsprintlog}/listpbis
			-- METHOD: GET
		require
			hreq /= Void
			hres /= Void
		local
			id_project: INTEGER
			id_sprintlog: INTEGER
			hp: HTTP_PARSER
			regex: REGEX
			json_error: JSON_OBJECT
			error_reason: STRING
			ok: BOOLEAN
			p: PROJECT
			u: USER
			s: SPRINTLOG
			pbis: LINKED_SET [PBI]
			j_pbis: JSON_ARRAY
			json_response: JSON_OBJECT
			j_number: JSON_NUMBER
		do
			http_request := hreq
			http_response := hres
			create json_error.make
			json_error.put_string ("error", "status")
			ok := TRUE
			create hp.make (hreq)
			if ensure_authenticated then
				if attached hp.path_param ("idproj") then
					id_project := hp.path_param ("idproj").to_integer
					p := db.getprojectfromid (id_project)
					if attached hp.path_param ("idsprintlog") then
						id_sprintlog := hp.path_param ("idsprintlog").to_integer
						s := db.getsprintlogfromid (id_sprintlog)
						if not attached s then
							error_reason := "Sprintlog does not exist"
							log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idproj in URL.")
							ok := FALSE
								--TODO check if sprintlog belongs to project
						end
						u := get_session_user
						if ok and not db.checkvisibilityforproject (u.getid, p.getid) then --CHECK u is into project
							error_reason := "The current user is not into the project"
							ok := FALSE
						end
					else --if the URL doesnt contain idsprintlog
						send_malformed_json (http_response)
							-- And logs it
						log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idsprintlog in URL.")
						ok := FALSE
					end --end if attached hp.path_param("idsprintlog")
					if not ok and not hres.status_committed then
						log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis  [POST] Request error: " + error_reason)
						json_error.put_string (error_reason, "reason")
						send_json (hres, json_error)
					else
						if ok then
							pbis := db.getpbisfromsprintlogid (id_sprintlog)
							create j_pbis.make_array
							across
								pbis as pbi
							loop
								create j_number.make_integer (pbi.item.getid)
								j_pbis.add (j_number)
							end
							create json_response.make
							json_response.put (j_pbis, "pbis")
							log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Reply sent")
								-- send to the user :)
							send_json (hres, json_response)
						end
					end
				else --if if the URL doesnt contain idproject
					send_malformed_json (http_response)
						-- And logs it
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idproj in URL.")
					ok := FALSE
				end --end if attached hp.path_param("idproj")
			else --if not authenticated or bad request
				if not hp.is_good_request then
						-- Bad request
					send_malformed_json (http_response)
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] JSON request malformed.")
				end
			end -- end ensure authenticated and good request
		end -- end current feature

	addPBI (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
			-- /projects/{idproj}/sprintlogs/{idsprintlog}/addpbi
			-- METHOD: POST
			--db.insertpbiintosprintlog (pbi,s)
		require
			hreq /= Void
			hres /= Void
		local
			id_project: INTEGER
			hp: HTTP_PARSER
			param_id: STRING
			regex: REGEX
			json_error: JSON_OBJECT
			error_reason: STRING
			ok: BOOLEAN
			p: PROJECT
			m: USER
			s: SPRINTLOG
		do
			http_request := hreq
			http_response := hres
			ok := TRUE
			create hp.make (hreq)
			if ensure_authenticated and hp.is_good_request then
					-- First GET the id of the project
				if attached hp.path_param ("idproj") and attached hp.path_param ("idsprintlog") then
					id_project := hp.path_param ("idproj").to_integer
					p := db.getprojectfromid (id_project)
					param_id := hp.path_param ("idsprintlog")
					s := db.getsprintlogfromid (param_id.to_integer)
					if (not attached s or not attached p) then --TODO: should also check if sprintlog belongs to project
						error_reason := "Sprintlog or project does not exist"
							-- And logs it
						log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idproj or idsprintlog in URL.")
						ok := FALSE
					end
						-- Next check the POST parameters
					create regex.make
						-- Create the error object even if it is not necessary
						-- (in this case, this object is not used)
					create json_error.make
					json_error.put_string ("error", "status")
					if attached hp.post_int_param ("id") then
						param_id := hp.post_int_param ("id").out
					end
					if ok and (not attached param_id or not regex.check_integer (param_id)) then
						error_reason := "Id not present or not correct."
						json_error.put_string ("id", "field")
						ok := FALSE
					end
						--CHECK m is manager
					m := get_session_user
					if ok and not p.getmanager.getid.is_equal (m.getid) then
						error_reason := "The current user is not manager of the project"
						ok := FALSE
					end
					if ok then
						db.insertpbiintosprintlog (param_id.to_integer, s.getid)
						log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] Added PBI to sprintlog " + s.getid.out)
							-- send OK to the user :)
						send_generic_ok (hres)
					else
						log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi  [POST] Request error: " + error_reason)
						json_error.put_string (error_reason, "reason")
						send_json (hres, json_error)
					end --End if ok
				else --if not attached hp.path_param ("idproj") or idsprintlog
					send_malformed_json (http_response)
						-- And logs it
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] Missing idproj in URL.")
					ok := FALSE
				end -- end if attached hp.path_param ("idproj")
			else --if not authenticated or bad request
				if not hp.is_good_request then
						-- Bad request
					send_malformed_json (http_response)
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] JSON request malformed.")
				end
			end -- end ensure authenticated and good request
		end -- end current feature

	removePBI (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
			-- /projects/{idproj}/sprintlogs/{idsprintlog}/removepbi
			-- METHOD: POST
			--db.removepbifromsprintlog(pbi,s)
		require
			hreq /= Void
			hres /= Void
		local
			id_project: INTEGER
			hp: HTTP_PARSER
			param_id: STRING
			regex: REGEX
			json_error: JSON_OBJECT
			error_reason: STRING
			ok: BOOLEAN
			p: PROJECT
			m: USER
			s: SPRINTLOG
		do
			http_request := hreq
			http_response := hres
			ok := TRUE
			create hp.make (hreq)
			if ensure_authenticated and hp.is_good_request then
					-- First GET the id of the project
				if not attached hp.path_param ("idproj") then
					send_malformed_json (http_response)
						-- And logs it
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Missing idproj in URL.")
					ok := FALSE
				else
					id_project := hp.path_param ("idproj").to_integer
					p := db.getprojectfromid (id_project)
					if not attached hp.path_param ("idsprintlog") then
						send_malformed_json (http_response)
							-- And logs it
						log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Missing idsprintlog in URL.")
						ok := FALSE
					else
						param_id := hp.path_param ("idsprintlog")
						s := db.getsprintlogfromid (param_id.to_integer)
						if not attached s then
							error_reason := "Sprintlog does not exist"
								-- And logs it
							log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Missing idproj in URL.")
							ok := FALSE
						end
							-- Next check the POST parameters
						create regex.make
							-- Create the error object even if it is not necessary
							-- (in this case, this object is not used)
						create json_error.make
						json_error.put_string ("error", "status")
						if attached hp.post_int_param ("id") then
							param_id := hp.post_int_param ("id").out
						end
						if ok and (not attached param_id or not regex.check_integer (param_id)) then
							error_reason := "Id not present or not correct."
							json_error.put_string ("id", "field")
							ok := FALSE
						end
							--CHECK m is manager
						m := get_session_user
						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end

						if ok then
							db.removepbifromsprintlog (param_id.to_integer, s.getid)
							log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Added PBI to sprintlog " + s.getid.out)
								-- send OK to the user :)
							send_generic_ok (hres)
						else
							log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi  [POST] Request error: " + error_reason)
							json_error.put_string (error_reason, "reason")
							send_json (hres, json_error)
						end
					end
				end
			else
				if not hp.is_good_request then
						-- Bad request
					send_malformed_json (http_response)
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] JSON request malformed.")
				end
			end -- end ensure authenticated and good request
		end -- end current feature

	deleteSprintlog (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
			-- projects/{idproj}/sprintlogs/{idsprintlog}/delete
			-- METHOD: POST
		require
			hreq /= Void
			hres /= Void
		local
			id_project: INTEGER
			id_sprintlog: INTEGER
			hp: HTTP_PARSER
			json_error: JSON_OBJECT
			error_reason: STRING
			ok: BOOLEAN
			p: PROJECT
			m: USER
			s: SPRINTLOG
		do
			http_request := hreq
			http_response := hres
			ok := TRUE
			create hp.make (hreq)
			if ensure_authenticated and hp.is_good_request then
					-- First GET the id of the project
				if not attached hp.path_param ("idproj") then
					send_malformed_json (http_response)
						-- And logs it
					log.warning ("projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Missing idproj in URL.")
					ok := FALSE
				else
					id_project := hp.path_param ("idproj").to_integer
					p := db.getprojectfromid (id_project)
					if ok and not attached hp.path_param ("idsprintlog") then
						send_malformed_json (http_response)
							-- And logs it
						log.warning ("projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Missing idsprintlog in URL.")
						ok := FALSE
					else
						id_sprintlog := hp.path_param ("idsprintlog").to_integer
						s := db.getsprintlogfromid (id_sprintlog)
						if not attached s then
							error_reason := "Sprintlog does not exist"
								-- And logs it
							log.warning ("projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Missing idproj in URL.")
							ok := FALSE
								--TODO check if sprintlog belongs to project
						end
							--CHECK m is manager
						m := get_session_user
						if ok and not p.getmanager.getid.is_equal (m.getid) then
							error_reason := "The current user is not manager of the project"
							ok := FALSE
						end
					end
					if not ok and not hres.status_committed then
						log.warning ("projects/{idproj}/sprintlogs/{idsprintlog}/delete  [POST] Request error: " + error_reason)
						json_error.put_string (error_reason, "reason")
						send_json (hres, json_error)
					else
						if ok then
							db.deletesprintlogfromid (id_sprintlog)
							log.info ("projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Deleted sprintlog " + s.getid.out)
								-- send OK to the user :)
							send_generic_ok (hres)
						end
					end
				end
			else
				if not hp.is_good_request then
						-- Bad request
					send_malformed_json (http_response)
					log.warning ("/projects/{idproj}/sprintlogs/create [POST] JSON request malformed.")
				end
			end -- end ensure authenticated and good request
		end -- end current feature

end
