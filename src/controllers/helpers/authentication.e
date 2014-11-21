note
	description: "Summary description for {AUTHENTICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUTHENTICATION

inherit
	HTTP_SESSIONS
	LOG

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
			json_error.put_string ("error", "status")
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

	ensure_not_authenticated: BOOLEAN
	-- check only if a user is logged. In negative case
	-- produce an HTTP error in JSON 405
	local
		json_error : JSON_OBJECT
	do
		if is_logged then

			create json_error.make
			json_error.put_string ("error", "status")
			json_error.put_string ("You must NOT be logged to perform this action!", "reason")

			helper.send_error_json (
			http_response,
			json_error,
			{HTTP_FUNCTIONS}.REQUEST_ERROR)

			Result := False
		else
			Result := True
		end
	end


feature
	login(email : STRING; password : STRING; db : PDT_DB)
	local
		json_reply : JSON_OBJECT
		hash : SHA1
		password_hashed : STRING
		u : USER
	do
		create json_reply.make
		create hash.make

		-- Hash the password
		-- After this instruction you cannot read again password
		hash.update_from_string(password)
		password_hashed := hash.digest_as_string
		password_hashed.to_lower	-- Eiffel uses upper case for HEX values, let's convert it!

		-- For security reason and for eventually future use
		hash.reset

		log.severe(password_hashed)

		-- Search user & password from database
		u := db.getUserFromEmailPassword(email, password_hashed)

		if u = Void then
			-- Login failed
			json_reply.put_string ("error", "status")
			log.warning("/account/login [POST] Login failed using "+email)
		else
			-- Login OK ^_^
			json_reply.put_string ("ok", "status")
			create_session(u)
			log.info("/account/login [POST] Login successful from "+email)
		end

		helper.send_json(http_response, json_reply)
	end

	logout
	do
		destroy_session
	end

end
