note
	description: "Summary description for {SPRINTLOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPRINTLOG

create
	make,
	make_default

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	backlog: BACKLOG
	startDate: DATE_TIME
	endDate: DATE_TIME

feature
	make(i: INTEGER; n, desc: STRING; b: BACKLOG; s, e: DATE_TIME)
		do
			id := i
			name := n
			description := desc
			backlog := b
			startDate := s
			endDate := e
		end
	make_default
		do
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
	setName(s: STRING)
		do
			name := s
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
	getStartDate: DATE_TIME
		do
			Result := startDate
		end
	setStartDate(d: DATE_TIME)
		do
			startDate := d
		end
	getEndDate: DATE_TIME
		do
			Result := endDate
		end
	setEndDate(d: DATE_TIME)
		do
			endDate := d
		end
end
