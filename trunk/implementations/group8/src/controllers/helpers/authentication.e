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
	helper : HTTP_FUNCTIONS once create Result end

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

	ensure_authenticated: BOOLEAN
	-- check only if a user is logged. In negative case
	-- produce an HTTP error in JSON
	local
		json_error : JSON_OBJECT
	do
		if not is_logged then

			create json_error.make
			json_error.put_string ("status", "error")
			json_error.put_string ("You must be logged to perform this action!", "reason")

			helper.send_error_json (
			http_response,
			json_error,
			{HTTP_FUNCTIONS}.NOT_AUTHENTICATED)

			Result := False
		else
			Result := True
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
