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
	do
		http_request  := hreq
		http_response := hres

		create hp.make(hreq)
		if not attached hp.path_param("idproj") then
			send_malformed_json(http_response)
			-- And logs it
			log.warning ("/projects/{idproj}/pbis/create [POST] Missing idproj in URL.")
		end

		id_project := hp.path_param("idproj").to_integer

		

	end


end
