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

feature
	make(i: INTEGER; n, desc: STRING; mgr, st: USER; cr: DATE)
		do
			id := i
			name := n
			description := desc
			manager := mgr
			stakeholder := st
			creationDate := cr
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
