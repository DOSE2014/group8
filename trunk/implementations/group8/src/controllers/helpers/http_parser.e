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
	l_result: JSON_OBJECT

	make(hreq : WSF_REQUEST)
	local
		l_payload, l_name: STRING

	do
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
	end

feature
	post_param(name : STRING) : STRING
	do
		if attached {JSON_OBJECT} parser.parse as j_object and parser.is_parsed then
				-- we have to convert the json string into an eiffel string
			if attached {JSON_STRING} j_object.item (name) as s then
				Result := s.unescaped_string_8
			end
		end
	end

end
