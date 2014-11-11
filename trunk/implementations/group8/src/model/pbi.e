note
	description: "Summary description for {PBI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PBI

create
	make

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	backlog: BACKLOG
	sprintlog: SPRINTLOG
	type: PBITYPE
	priority: INTEGER
	dueDate: DATE

feature
	make(i: INTEGER; n, desc: STRING; b: BACKLOG; s: SPRINTLOG; t: PBITYPE; p: INTEGER; d: DATE)
		do
			id := i
			name := n
			description := desc
			backlog := b
			sprintlog := s
			type := t
			priority := p
			dueDate := d
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
	getSprintlog: SPRINTLOG
		do
			Result := sprintlog
		end
	setSprintlog(s: SPRINTLOG)
		do
			sprintlog := s
		end
	getType: PBITYPE
		do
			Result := type
		end
	setType(t: PBITYPE)
		do
			type := t
		end
	getPriority: INTEGER
		do
			Result := priority
		end
	setPriority(p: INTEGER)
		do
			priority := p
		end
	getDueDate: DATE
		do
			Result := dueDate
		end
	setDueDate(d: DATE)
		do
			dueDate := d
		end
end
