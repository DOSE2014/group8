note
	description: "Summary description for {REST_PROJECTS_PBIS_TASKS}."
	author: ""
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


end
