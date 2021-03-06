note
	description: "Summary description for {HTTP_SESSIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTTP_SESSIONS

inherit
	LOG

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

	create_session(u : USER)
	-- Creates a new (empty) session (you should sends a HTTP response after this)
	require
		u /= Void
	local
		session_obj : WSF_COOKIE_SESSION
	do
		create session_obj.make_new(session_cookie_name, session_manager)
		session_obj.remember (u, "user_obj")
		session_obj.commit -- Save to disk the session
		session_obj.apply(http_request, http_response, "/") -- Create cookie session for entire app path (/)
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
	do
		cookie_id := ec.any_to_wsf_string(http_request.cookie(session_cookie_name))
		session_data := session_manager.session_data(cookie_id.value)

		Result := ec.any_to_user(session_data["user_obj"])

--		create user.make (ec.any_to_int(session_data["id"]),
--						  ec.any_to_string(session_data["first_name"]),
--						  ec.any_to_string(session_data["last_name"]),
--						  ec.any_to_int(session_data["sex"]),
--						  Void,
--						  ec.any_to_string(session_data["country"]),
--						  ec.any_to_string(session_data["timezone"]),
--						  ec.any_to_string(session_data["email"]),
--						  Void,
--						  ec.any_to_int (session_data["usertype"]),
--						  ec.any_to_string(session_data["organization"]),
--						  Void, Void) -- TODO

	ensure
		Result /= Void

	end

	exists_session : BOOLEAN
	require
		http_request    /= Void
		session_manager /= Void
	local
		cookie_str : STRING
	-- Returns True or False if the session already exists or not.
	do
		Result := False
		-- Check if there is cookie
		if attached {WSF_STRING} http_request.cookie(session_cookie_name) as cookie_id then
			-- and if there is a session related
			cookie_str := cookie_id.value
			Result := session_manager.session_exists(cookie_str)
		end
	end
end
