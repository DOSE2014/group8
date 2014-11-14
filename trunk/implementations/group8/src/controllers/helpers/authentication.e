note
	description: "Summary description for {AUTHENTICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUTHENTICATION

inherit
	HTTP_SESSIONS

feature	-- DEFERRED feature
	http_request : WSF_REQUEST
		deferred
		end
	http_response : WSF_RESPONSE
		deferred
		end

feature {NONE}
	helper : HTTP_FUNCTIONS

feature
	is_logged : BOOLEAN
	do
		Result := exists_session
	end

	get_user : USER
	do
		Result := get_session_user
	end

feature -- Ensure feature

	ensure_authentication : BOOLEAN
	-- check only if a user is logged. In negative case
	-- produce an HTTP error in JSON
	do
		if not is_logged then
			helper.send_error_json (
			http_response,
			Void,
			{HTTP_FUNCTIONS}.NOT_AUTHENTICATED)
		end
	end


feature
	login(user : STRING; password : STRING) : BOOLEAN
	do

	end

	logout
	do

	end

end
