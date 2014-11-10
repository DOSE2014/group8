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

	make(id: INTEGER; name, description: STRING; backlog: BACKLOG; startDate, endDate: DATE)
		do
			Current.id := id
			Current.name := name
			Current.description := description
			Current.backlog := backlog
			Current.startDate := startDate
			Current.endDate := endDate
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
	getDescription: STRING
		do
			Result := Current.description
		end
	setDescription(s: STRING)
		do
			Current.description := s
		end
	getBacklog: BACKLOG
		do
			Result := Current.backlog
		end
	setBacklog(b: BACKLOG)
		do
			Current.backlog := b
		end
	getStartDate: DATE
		do
			Result := Current.startDate
		end
	setStartDate(d: DATE)
		do
			Current.startDate := d
		end
	getEndDate: DATE
		do
			Result := Current.endDate
		end
	setEndDate(d: DATE)
		do
			Current.endDate := d
		end
end
