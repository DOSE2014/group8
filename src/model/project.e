note
	description: "Summary description for {PROJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECT

create
	make

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	manager: USER
	stakeholder: USER
	creationDate: DATE
	
	make(id: INTEGER; name, description: STRING; manager, stakeholder: USER; creationDate: DATE)
		do
			Current.id := id
			Current.name := name
			Current.description := description
			Current.manager := manager
			Current.stakeholder := stakeholder
			Current.creationDate := creationDate
		end

feature
	getId: INTEGER
		do
		end

	setId(i: INTEGER)
		do
		end
	
	getName: STRING
		do
		end
	
	setName(s: STRING)
		do
		end
	
	getDescription: STRING
		do
		end
	
	setDescription(s: STRING)
		do
		end
	
	getManager: USER
		do
		end
	
	setManager(u: USER)
		do
		end
	
	getStakeholder: USER
		do
		end
	
	setStakeholder(u: USER)
		do
		end
	
	getCreationDate: DATE
		do
		end

	setCreationDate(d: DATE)
		do
		end
end
