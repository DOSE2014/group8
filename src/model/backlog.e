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
	
	make(id: INTEGER; description: STRING; project: PROJECT)
		do
			Current.id := id
			Current.description := description
			Current.project := project
		end
feature
	getProject: PROJECT
		do
			Result := Current.project
		end
	setProject(p: PROJECT)
		do
			Current.project := p
		end
	getId: INTEGER
		do
			Result := Current.id
		end
	setId(id: INTEGER)
		do
			Current.id := id
		end
	getDescription: STRING
		do
			Result := Current.description
		end
	setDescription(s: STRING)
		do
			Current.description := s
		end
end
