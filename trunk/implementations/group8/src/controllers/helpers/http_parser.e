note
	description: "Summary description for {HTTP_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_PARSER
inherit
	LOG
create
	make

feature{NONE}

	parser: JSON_PARSER
	j_object: JSON_OBJECT
	good_request : BOOLEAN

feature
	http_request : WSF_REQUEST	-- public due to precodition

	make(hreq : WSF_REQUEST)
	local
		l_payload, l_name: STRING

	do
		http_request := hreq
		-- If request is POST, running the JSON parser
		if http_request.is_post_request_method then
			-- create emtpy string objects
			create l_payload.make_empty
			create l_name.make_empty

			-- read the payload from the request and store it in the string
			hreq.read_input_data_into (l_payload)

			log.deb("HTTP POST payload: "+l_payload)

			-- now parse the json object that we got as part of the payload
			create parser.make_parser (l_payload)

			-- if the parsing was successful and we have a json object, we fetch the properties
			-- for the todo description and the userId
			if attached {JSON_OBJECT} parser.parse as j_object_ass and parser.is_parsed then
				j_object := j_object_ass
				good_request := TRUE
			else
				log.deb ("HTTP_PARSER Oh no, this is a bad Request")
				good_request := FALSE
			end
		end
	end

feature
	is_good_request : BOOLEAN
	do
			Result := good_request
	end

	get_param(name : STRING) : STRING
	require
		http_request.is_get_request_method
	do


		-- we have to convert the json string into an eiffel string
		if attached {WSF_STRING} http_request.query_parameter(name) as s then
			Result := s.string_representation
		end
	end

	post_param(name : STRING) : STRING
	require
		http_request.is_post_request_method
	do
		-- we have to convert the json string into an eiffel string
		if attached {JSON_STRING} j_object.item (name) as s then
			Result := s.unescaped_string_8
		end
	end


	post_array_param(name : STRING) : ARRAYED_LIST [STRING]
	require
		http_request.is_post_request_method

	local
		i  : INTEGER
	do
		-- we have to convert the json string into an arrayed_list []
		if attached {JSON_ARRAY} j_object.item (name) as arr then

			create Result.make (arr.count)
			i := 1
			across arr.array_representation as j_value loop
				if attached {JSON_STRING} j_value.item as j_str then
					Result.extend (j_str.unescaped_string_8)
				end
			end
		end
	end

end
