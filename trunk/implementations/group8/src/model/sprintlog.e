note
	description: "Summary description for {SPRINTLOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPRINTLOG

create
	make

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	backlog: BACKLOG
	startDate: DATE
	endDate: DATE

feature
	make(i: INTEGER; n, desc: STRING; b: BACKLOG; s, e: DATE)
		do
			id := i
			name := n
			description := desc
			backlog := b
			startDate := s
			endDate := e
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
	getDescription: STRING
		do
			Result := description
		end
	setDescription(s: STRING)
		do
			description := s
		end
	getBacklog: BACKLOG
		do
			Result := backlog
		end
	setBacklog(b: BACKLOG)
		do
			backlog := b
		end
	getStartDate: DATE
		do
			Result := startDate
		end
	setStartDate(d: DATE)
		do
			startDate := d
		end
	getEndDate: DATE
		do
			Result := endDate
		end
	setEndDate(d: DATE)
		do
			endDate := d
		end
end
