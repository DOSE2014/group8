note
	description: "Summary description for {REST_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_ACCOUNT

inherit
	AUTHENTICATION

create
	make

feature {NONE}	-- Constructor
	make(sm : WSF_SESSION_MANAGER; hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	require
		sm   /= Void
		hreq /= Void
		hres /= Void
	do
		session_manager := sm
		http_request  := hreq
		http_response := hres
	end


feature
	-- declaring deferred properties
	session_manager : WSF_SESSION_MANAGER
	http_request : WSF_REQUEST
	http_response : WSF_RESPONSE

end
