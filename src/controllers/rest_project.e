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
			j_project: JSON_OBJECT
			j_projects: JSON_ARRAY
			json_response: JSON_OBJECT
			u: USER
			hp: HTTP_PARSER
		do
			http_request := hreq
			http_response := hres

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
				across projects as p
				loop
					j_project := p.item.to_minimal_json
					j_projects.add (j_project)
				end

				create json_response.make
				json_response.put (j_projects, "projects")
				send_json(hres, json_response)
			end
		end

end
