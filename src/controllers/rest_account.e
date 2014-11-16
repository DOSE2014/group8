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

	account_info(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /account/userinfo
	-- METHOD: GET
	require
		hreq /= Void
		hres /= Void
	do
		http_request  := hreq
		http_response := hres

		-- User must be logged
		if ensure_authenticated then


		end
	end

	register(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /account/register
	-- METHOD: POST
	do
		if ensure_not_authenticated then

			

		end

	end

end
