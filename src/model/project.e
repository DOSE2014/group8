note
	description: "Summary description for {PROJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECT

create
	make,
	make_default

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	manager: USER
	stakeholder: USER
	creationDate: DATE_TIME
	deleted: BOOLEAN

feature
	make(i: INTEGER; n, desc: STRING; mgr, st: USER; cr: DATE_TIME; b:BOOLEAN)
		do
			id := i
			name := n
			description := desc
			manager := mgr
			stakeholder := st
			creationDate := cr
			deleted:=b
		end
	make_default
		do

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

	getCreationDate: DATE_TIME
		do
			Result:=creationDate
		end

	setCreationDate(d: DATE_TIME)
		do
			creationDate:=d
		end
	getDeleted:BOOLEAN
		do
			Result:=deleted
		end
	setDeleted(b: BOOLEAN)
		do
			deleted:=b
		end
end
