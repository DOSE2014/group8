note
	description: "Summary description for {CHAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHAT

create
	make

feature
	id: INTEGER
	users: SET[USER]
	project : PROJECT

feature{NONE}
	make (		i:INTEGER;
				us:SET[USER];
				proj:PROJECT
	)
	do
		id:=i
		users:= us
		project:= proj
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
	getUsers: SET[USER]
		do
			Result := users
		end
	setUsers (us:SET[USER])
		do
			users := us
		end
	getProject : PROJECT
		do
			Result := project
		end
	setProject (proj : PROJECT)
		do
			project := proj
		end
end
