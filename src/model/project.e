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
			Result:=id
		end

	setId(i: INTEGER)
		do
			id:=i
		end

	getName: STRING
		do
			Result:=name
		end

	setName(s: STRING)
		do
			name:= s
		end

	getDescription: STRING
		do
			Result:= description
		end

	setDescription(s: STRING)
		do
			description:=s
		end

	getManager: USER
		do
			Result:=manager
		end

	setManager(u: USER)
		do
			manager:=u
		end

	getStakeholder: USER
		do
			Result:=stakeholder
		end

	setStakeholder(u: USER)
		do
			stakeholder:=u
		end

	getCreationDate: DATE
		do
			Result:=creationDate
		end

	setCreationDate(d: DATE)
		do
			creationDate:=d
		end
end
