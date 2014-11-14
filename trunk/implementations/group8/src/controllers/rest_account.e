note
	description: "Summary description for {REST_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_ACCOUNT

inherit
	AUTHENTICATION
	LOG

create
	make

feature {NONE}	-- Constructors
	make(sm : WSF_SESSION_MANAGER)
	require
		sm   /= Void
	do
		session_manager := sm
	end


feature -- declaring deferred properties
	session_manager : WSF_SESSION_MANAGER
	http_request : WSF_REQUEST
	http_response : WSF_RESPONSE

feature

	account_info( hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	require
		hreq /= Void
		hres /= Void
	do
		http_request  := hreq
		http_response := hres

		log.warning("AAA")

		-- User must be logged
		if ensure_authenticated then



		end
	end

end
