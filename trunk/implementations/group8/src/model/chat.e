note
	description: "Summary description for {CHAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHAT

create
	make, make_default

feature
	id: INTEGER
	project : PROJECT

feature{NONE}
	make (		i:INTEGER;
				proj:PROJECT
	)
	do
		id:=i
		project:= proj
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
	getProject : PROJECT
		do
			Result := project
		end
	setProject (proj : PROJECT)
		do
			project := proj
		end
	to_json: JSON_OBJECT
		do
			create Result.make
			Result.put_integer(id, "id")
			Result.put_integer(project.getId, "project")
		end
end
