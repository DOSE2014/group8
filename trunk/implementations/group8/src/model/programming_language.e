note
	description: "Summary description for {PROGRAMMING_LANGUAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROGRAMMING_LANGUAGE

create
	make

feature{NONE}
	id: INTEGER
	name: STRING

feature
	make(i: INTEGER; s: STRING)
		do
			id := i
			name := s
		end

feature
	getId: INTEGER
		do
			Result := id
		end
	setId(i: INTEGER)
		do
			id := i
		end
	getName: STRING
		do
			Result := name
		end
	setName(s: STRING)
		do
			name := s
		end


end
