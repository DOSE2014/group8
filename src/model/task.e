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

feature
	make(i: INTEGER; n, desc: STRING; s: SPRINTLOG; dev: USER; pts: INTEGER; st: STATE; p: PBI)
	do
		id := i
		name := n
		description := desc
		sprintlog := s
		developer := dev
		points := pts
		state := st
		pbi := p
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
	getSprintlog: SPRINTLOG
		do
			Result := sprintlog
		end
	setSprintlog(s: SPRINTLOG)
		do
			sprintlog := s
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
	getState: STATE
		do
			Result := state
		end
	setState(s: STATE)
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
end
