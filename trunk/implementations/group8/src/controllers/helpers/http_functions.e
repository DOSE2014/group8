note
	description: "HTTP_FUNCTIONS"
	author: "Milan3 Team"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_FUNCTIONS

feature
	NOT_AUTHORIZED    : INTEGER = 402
	NOT_AUTHENTICATED : INTEGER = 403
	NOT_FOUND         : INTEGER = 404
	REQUEST_ERROR	  : INTEGER = 405
	SERVER_ERROR      : INTEGER = 500

feature
	send_json(res : WSF_RESPONSE; json : JSON_OBJECT)
	-- Send a JSON response with OK HTTP status (200)
	do
		res.set_status_code (200)
		res.header.put_content_type_application_json
		res.header.put_content_length (json.representation.count)
		res.put_string (json.representation)
	rescue
		-- Do nothing in case of client disconnession
	end

	send_error_json(res : WSF_RESPONSE; json : JSON_OBJECT; error : INTEGER)
	-- Send a JSON response with error HTTP status (!=200)
	require
		error = 500 or (error >= 402 and error <= 405)
	do
		res.set_status_code (error)
		res.header.put_content_type_application_json
		res.header.put_content_length (json.representation.count)
		res.put_string (json.representation)
	rescue
		-- Do nothing in case of client disconnession
	end

	send(res : WSF_RESPONSE; text : STRING)
	obsolete
		"Use JSON method instead of this."
	do
		res.set_status_code (200)
		res.header.put_content_type_text_plain
		res.header.put_content_length (text.count)
		res.put_string (text)
	rescue
		-- Do nothing in case of client disconnession
	end

	send_error(res : WSF_RESPONSE; text : STRING; error : INTEGER)
	obsolete
		"Use JSON method instead of this."
	require
		error = 500 or (error >= 402 and error <= 405)
	do
		res.set_status_code (error)
		res.header.put_content_type_text_plain
		res.header.put_content_length (text.count)
		res.put_string (text)
	rescue
		-- Do nothing in case of client disconnession
	end

	send_malformed_json(http_response : WSF_RESPONSE)
	local
		json_error : JSON_OBJECT
	do
		-- Here there is a problem with JSON in HTTP request (e.g. missing commas, etc.)
		-- So sends a 405 to user
		create json_error.make
		json_error.put_string ("error", "status")
		json_error.put_string ("JSON request malformed", "reason")
		send_error_json (http_response,json_error,{HTTP_FUNCTIONS}.REQUEST_ERROR)
	rescue
		-- Do nothing in case of client disconnession
	end

	send_generic_ok(http_response : WSF_RESPONSE)
	local
		json_ok : JSON_OBJECT
	do
		create json_ok.make
		json_ok.put_string ("ok", "status")
		send_json (http_response,json_ok)
	rescue
		-- Do nothing in case of client disconnession
	end

	send_generic_error(str : STRING; http_response : WSF_RESPONSE)
	local
		json_error : JSON_OBJECT
	do
		create json_error.make
		json_error.put_string ("error", "status")
		json_error.put_string (str, "reason")
		send_json (http_response,json_error)
	rescue
		-- Do nothing in case of client disconnession
	end
end
