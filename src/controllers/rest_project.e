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
	-- PATH: /project/listProjects
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
				end
			end

		end
end
