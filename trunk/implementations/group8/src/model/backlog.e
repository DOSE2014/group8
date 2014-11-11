note
	description: "Summary description for {BACKLOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BACKLOG

create
	make

feature{NONE}
	id: INTEGER
	description: STRING
	project: PROJECT

feature
	make(i: INTEGER; desc: STRING; proj: PROJECT)
		do
			id := i
			description := desc
			project := proj
		end
feature
	getProject: PROJECT
		do
			Result := project
		end
	setProject(p: PROJECT)
		do
			project := p
		end
	getId: INTEGER
		do
			Result := id
		end
	setId(i: INTEGER)
		do
			id := i
		end
	getDescription: STRING
		do
			Result := description
		end
	setDescription(s: STRING)
		do
			description := s
		end
end
