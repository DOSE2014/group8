note
	description: "Summary description for {PBI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PBI

create
	make,
	make_default

feature{NONE}
	id: INTEGER
	name: STRING
	description: STRING
	backlog: BACKLOG
	sprintlog: SPRINTLOG
	type: INTEGER
	priority: INTEGER
	dueDate: DATE_TIME

feature
	make(i: INTEGER; n, desc: STRING; b: BACKLOG; s: SPRINTLOG;  t: INTEGER; p: INTEGER; d: DATE_TIME)
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
	getSprintlog: SPRINTLOG
		do
			Result := sprintlog
		end
	setSprintlog(s: SPRINTLOG)
		do
			sprintlog := s
		end
	getType: INTEGER
		do
			Result := type
		end
	setType(t: INTEGER)
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
	getDueDate: DATE_TIME
		do
			Result := dueDate
		end
	setDueDate(d: DATE_TIME)
		do
			dueDate := d
		end

	to_json: JSON_OBJECT
		local
			j_pbi: JSON_OBJECT
			epoch: DATE_TIME
		do
			create j_pbi.make
			create epoch.make_from_epoch (0)
			j_pbi.put_integer (id, "id")
			j_pbi.put_string (name, "name")
			j_pbi.put_string (description, "description")
			if attached sprintlog then
				j_pbi.put_integer (sprintlog.getid, "sprintlog")
			else
				j_pbi.put (create {JSON_NULL}, "sprintlog")
			end
			if type = {PBITYPE}.bugfix then
				j_pbi.put_string ("bugfix", "type")
			elseif type = {PBITYPE}.nonfunctionalrequirement then
				j_pbi.put_string ("nonfunctionalrequirement", "type")
			elseif type = {PBITYPE}.requirement then
				j_pbi.put_string ("requirement", "type")
			end

			j_pbi.put_integer (priority, "priority")
			j_pbi.put_integer (duedate.definite_duration (epoch).seconds_count, "dueDate")


			Result := j_pbi
		end
end
