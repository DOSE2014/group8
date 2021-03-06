note
	description: "Summary description for {TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TASK

create
	make, make_default

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	developer: USER
	points: INTEGER
	state: INTEGER
	pbi: PBI
	completionDate: DATE_TIME


feature
	make(i: INTEGER; n, desc: STRING; dev: USER; pts: INTEGER; st: INTEGER; p: PBI; completion_d: DATE_TIME)
	do
		id := i
		name := n
		description := desc
		developer := dev
		points := pts
		state := st
		pbi := p
		completionDate := completion_d
	end
	make_default
		do

		end
		feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
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
	setName(n: STRING)
		do
			name := n
		end
	getDescription: STRING
		do
			Result := description
		end
	setDescription(d: STRING)
		do
			description := d
		end
	getDeveloper: USER
		do
			Result := developer
		end
	setDeveloper(d: USER)
		do
			developer := d
		end
	getPoints: INTEGER
		do
			Result := points
		end
	setPoints(p: INTEGER)
		do
			points := p
		end
	getState: INTEGER
		do
			Result := state
		end
	setState(s: INTEGER)
		do
			state := s
		end
	getPBI: PBI
		do
			Result := pbi
		end
	setPBI(p: PBI)
		do
			pbi := p
		end
	getCompletionDate: DATE_TIME
		do
			Result := completionDate
		end
	setCompletionDate(d: DATE_TIME)
		do
			completionDate := d
		end
	to_minimal_json: JSON_OBJECT
		require
			getId /= 0
		local
			epoch: DATE_TIME
			state_class : STATE
		do
			create epoch.make_from_epoch (0)
			create Result.make
			create state_class

			Result.put_integer(id, "id")
			Result.put_string(name, "name")
			Result.put_string(description, "description")
			Result.put_integer(points, "points")
			Result.put_integer(developer.getid, "developer")
			Result.put_string(state_class.to_string (state), "state")
			Result.put_integer(pbi.getid, "pbi")
			Result.put_integer(completionDate.definite_duration(epoch).seconds_count, "completionDate")
		end


end
