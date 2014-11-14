note
	description: "Summary description for {HTTP_SESSIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_SESSIONS

feature
	session_manager: WSF_SESSION_MANAGER
		deferred
		end
	http_request : WSF_REQUEST
		deferred
		end
	http_response : WSF_RESPONSE
		deferred
		end
	session_cookie_name : STRING once Result := "_pdt_session_id_" end

feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end

feature

	create_session
	-- Creates a new (empty) session and sends it to the browser
	local
		session_obj : WSF_COOKIE_SESSION
	do
		create session_obj.make_new(session_cookie_name, session_manager)

	end

	destroy_session
	-- Destroy a session (logout user)
	local
		session_obj : WSF_COOKIE_SESSION
	do
		-- Load the current session (if it does not exist, create a new one, but this is not important)
		create session_obj.make(http_request, session_cookie_name, session_manager)
		-- Now destroy that session.
		session_obj.destroy
	end

	set_session_user (u : USER)
	require
		exists_session
	do

	end

	get_session_user : USER
	-- Returns the USER object from the existent current session. Note: in this object it is not
	-- setted either password nor password hash.
	require
		exists_session
	local
		cookie_id : WSF_STRING

		-- Note: WSF_SESSION_DATA is a specialization of STRING_TABLE that is specialization
		-- of HASH_TABLE and can be used as associative array xxx[cookiename]=value
		session_data : WSF_SESSION_DATA
		user : USER
	do
		cookie_id := ec.any_to_wsf_string(http_request.cookie(session_cookie_name))
		session_data := session_manager.session_data(cookie_id.value)

		create user.make (ec.any_to_int(session_data["id"]),
						  ec.any_to_string(session_data["first_name"]),
						  ec.any_to_string(session_data["last_name"]),
						  ec.any_to_int(session_data["sex"]),
						  Void,
						  ec.any_to_string(session_data["country"]),
						  ec.any_to_string(session_data["timezone"]),
						  ec.any_to_string(session_data["email"]),
						  Void, Void, ec.any_to_string(session_data["organization"]),
						  Void, Void) -- TODO

	ensure
		Result /= Void

	end

	exists_session : BOOLEAN
	-- Returns True or False if the session already exists or not.
	do
		Result := False
		-- Check if there is cookie
		if attached {WSF_STRING} http_request.cookie(session_cookie_name) as cookie_id then
			-- and if there is a session related
			Result := session_manager.session_exists(cookie_id.value)
		end
	end

end
