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

	make(id: INTEGER; name, description: STRING; backlog: BACKLOG; sprintlog: SPRINTLOG; type: PBITYPE; priority: INTEGER; dueDate: DATE)
		do
			Current.id := id
			Current.name := name
			Current.description := description
			Current.backlog := backlog
			Current.sprintlog := sprintlog
			Current.type := type
			Current.priority := priority
			Current.dueDate := dueDate
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
	setName(s: STRING)
		do
			Current.name := s
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
	getSprintlog: SPRINTLOG
		do
			Result := Current.sprintlog
		end
	setSprintlog(s: SPRINTLOG)
		do
			Current.sprintlog := s
		end
	getType: PBITYPE
		do
			Result := Current.type
		end
	setType(t: PBITYPE)
		do
			Current.type := t
		end
	getPriority: INTEGER
		do
			Result := Current.priority
		end
	setPriority(p: INTEGER)
		do
			Current.priority := p
		end
	getDueDate: DATE
		do
			Result := Current.dueDate
		end
	setDueDate(d: DATE)
		do
			Current.dueDate := d
		end
end
