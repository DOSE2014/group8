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

		ok := TRUE
		create hp.make (hreq)

		if ensure_authenticated then

			-- First GET the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_generic_error ("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					send_generic_error ("Project not found.", hres)
					ok := FALSE
				end
			end

			-- Then GET the id of the sprintlog
			if not attached hp.path_param("idsprintlog") or not hp.path_param("idsprintlog").is_integer then
				send_generic_error ("idsprintlog not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] Missing idsprintlog in URL.")
				ok := FALSE
			else
				id_sprintlog := hp.path_param("idsprintlog").to_integer
				s := db.getsprintlogfromid (id_sprintlog)
				if not attached s then
					send_generic_error ("Sprintlog not found.", hres)
					ok := FALSE
				end
			end

			-- Check the user permission
			u := get_session_user
			if ok and not db.checkvisibilityforproject (u.getid, p.getid) then --CHECK u is into project
				send_generic_error("The current user is not into the project specified.", hres)
				ok := FALSE
			end

			if ok then

				-- If ok, send all PBI list in the current sprintlog to
				-- the client
				pbis := db.getpbisfromsprintlogid (id_sprintlog)
				create j_pbis.make_array

				-- if pbis are not found, the array remains empty
				-- and printed empty without problems.
				if attached pbis then
					across
						pbis as pbi
					loop
						create j_number.make_integer (pbi.item.getid)
						j_pbis.add (j_number)
					end
				end
				create json_response.make
				json_response.put (j_pbis, "pbis")
				log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/listpbis [POST] List of PBI requested.")
					-- send to the user :)
				send_json (hres, json_response)
			end

		end -- end ensure authenticated and good request
	end -- end current feature

	addPBI (hreq: WSF_REQUEST; hres: WSF_RESPONSE)
	-- /projects/{idproj}/sprintlogs/{idsprintlog}/addpbi
	-- METHOD: POST
	require
		hreq /= Void
		hres /= Void
	local
		id_project: INTEGER
		id_sprintlog: INTEGER
		hp: HTTP_PARSER
		param_id: INTEGER
		regex: REGEX
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

			-- First get the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_generic_error ("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					send_generic_error ("Project not found.", hres)
					ok := FALSE
				end
			end

			-- Then get the id of the sprintlog
			if not attached hp.path_param("idsprintlog") or not hp.path_param("idsprintlog").is_integer then
				send_generic_error ("idsprintlog not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] Missing idsprintlog in URL.")
				ok := FALSE
			else
				id_sprintlog := hp.path_param("idsprintlog").to_integer
				s := db.getsprintlogfromid (id_sprintlog)
				if not attached s then
					send_generic_error ("Sprintlog not found.", hres)
					ok := FALSE
				end
			end

			--CHECK m is manager
			m := get_session_user
			if ok and not p.getmanager.getid.is_equal (m.getid) then
				send_generic_error("The current user is not manager of the project", hres)
				ok := FALSE
			end

			if ok then
				param_id := hp.post_int_param ("id")

				if not attached param_id then
					send_generic_error("id of pbi not found or not integer.", hres)
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi  [POST] id of pbi not found or not integer.")
					ok := FALSE
				end
			end

			if ok then
				db.insertpbiintosprintlog (param_id, s.getid)
				log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/addpbi [POST] Added PBI to sprintlog " + s.getid.out)
				-- send OK to the user :)
				send_generic_ok (hres)
			end

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
		id_sprintlog : INTEGER
		hp: HTTP_PARSER
		param_id: INTEGER
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

			-- First get the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_generic_error ("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					send_generic_error ("Project not found.", hres)
					ok := FALSE
				end
			end

			-- Then get the id of the sprintlog
			if not attached hp.path_param("idsprintlog") or not hp.path_param("idsprintlog").is_integer then
				send_generic_error ("idsprintlog not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Missing idsprintlog in URL.")
				ok := FALSE
			else
				id_sprintlog := hp.path_param("idsprintlog").to_integer
				s := db.getsprintlogfromid (id_sprintlog)
				if not attached s then
					send_generic_error ("Sprintlog not found.", hres)
					ok := FALSE
				end
			end

			--CHECK m is manager
			m := get_session_user
			if ok and not p.getmanager.getid.is_equal (m.getid) then
				send_generic_error("The current user is not manager of the project", hres)
				ok := FALSE
			end

			if ok then
				param_id := hp.post_int_param ("id")

				if not attached param_id then
					send_generic_error("id of pbi not found or not integer.", hres)
					log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi  [POST] id of pbi not found or not integer.")
					ok := FALSE
				end
			end

			if ok then
				db.removepbifromsprintlog (param_id, s.getid)
				log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] Added PBI to sprintlog " + s.getid.out)
				-- send OK to the user :)
				send_generic_ok (hres)
			end

		else --if not authenticated or bad request
			if not hp.is_good_request then
					-- Bad request
				send_malformed_json (http_response)
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/removepbi [POST] JSON request malformed.")
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

			-- First get the id of the project
			if not attached hp.path_param("idproj") or not hp.path_param("idproj").is_integer then
				send_generic_error ("idproj not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Missing idproj in URL.")
				ok := FALSE
			else
				id_project := hp.path_param("idproj").to_integer
				p := db.getprojectfromid (id_project)
				if not attached p then
					send_generic_error ("Project not found.", hres)
					ok := FALSE
				end
			end

			-- Then get the id of the sprintlog
			if not attached hp.path_param("idsprintlog") or not hp.path_param("idsprintlog").is_integer then
				send_generic_error ("idsprintlog not found or not integer.", hres)
				-- And logs it
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Missing idsprintlog in URL.")
				ok := FALSE
			else
				id_sprintlog := hp.path_param("idsprintlog").to_integer
				s := db.getsprintlogfromid (id_sprintlog)
				if not attached s then
					send_generic_error ("Sprintlog not found.", hres)
					ok := FALSE
				end
			end

			--CHECK m is manager
			m := get_session_user
			if ok and not p.getmanager.getid.is_equal (m.getid) then
				send_generic_error("The current user is not manager of the project", hres)
				ok := FALSE
			end

			if ok then
				db.deletesprintlogfromid (id_sprintlog)
				log.info ("/projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] Added PBI to sprintlog " + s.getid.out)
				-- send OK to the user :)
				send_generic_ok (hres)
			end

		else --if not authenticated or bad request
			if not hp.is_good_request then
					-- Bad request
				send_malformed_json (http_response)
				log.warning ("/projects/{idproj}/sprintlogs/{idsprintlog}/delete [POST] JSON request malformed.")
			end
		end -- end ensure authenticated and good request

	end -- end current feature

end
