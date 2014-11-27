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
	to_minimal_json: JSON_OBJECT
		require
			getId /= 0
		do
			create Result.make
			Result.put_integer(id, "id")
			Result.put_string(name, "name")
		end
	to_json: JSON_OBJECT
		require
			getId /= 0
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create Result.make
			Result.put_integer (id, "id")
			Result.put_string (name, "name")
			Result.put_string (description, "description")
			Result.put (manager.to_json, "manager")
			Result.put (stakeholder.to_json, "stakeholder")
			Result.put_integer (creationdate.definite_duration (epoch).seconds_count, "creationDate")
			Result.put_boolean (deleted, "deleted")
		end
end
