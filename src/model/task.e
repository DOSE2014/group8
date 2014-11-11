note
	description: "Summary description for {TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TASK

create
	make

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	sprintlog: SPRINTLOG
	developer: USER
	points: INTEGER
	state: STATE
	pbi: PBI

	make(id: INTEGER; name, description: STRING; sprintlog: SPRINTLOG; developer: USER; points: INTEGER; state: STATE; pbi: PBI)
	do
		Current.id := id
		Current.name := name
		Current.description := description
		Current.sprintlog := sprintlog
		Current.developer := developer
		Current.points := points
		Current.state := state
		Current.pbi := pbi
	end

feature
	getId: INTEGER
		do
			Result := Current.id
		end
	setId(i: INTEGER)
		do
			Current.id := i
		end
	getName: STRING
		do
			Result := Current.name
		end
	setName(n: STRING)
		do
			Current.name := n
		end
	getDescription: STRING
		do
			Result := Current.description
		end
	setDescription(d: STRING)
		do
			Current.description := d
		end
	getSprintlog: SPRINTLOG
		do
			Result := Current.sprintlog
		end
	setSprintlog(s: SPRINTLOG)
		do
			Current.sprintlog := s
		end
	getDeveloper: USER
		do
			Result := Current.developer
		end
	setDeveloper(d: USER)
		do
			Current.developer := d
		end
	getPoints: INTEGER
		do
			Result := Current.points
		end
	setPoints(p: INTEGER)
		do
			Current.points := p
		end
	getState: STATE
		do
			Result := Current.state
		end
	setState(s: STATE)
		do
			Current.state := s
		end
	getPBI: PBI
		do
			Result := Current.pbi
		end
	setPBI(p: PBI)
		do
			Current.pbi := p
		end
end
