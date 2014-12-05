note
	description: "Summary description for {STAT_ENTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STAT_ENTRY

create
	make_from_obj,
	make_from_int

feature{NONE}
	user : USER
	userid : INTEGER
	points : INTEGER

feature{NONE}
	make_from_obj(u : USER; p : INTEGER)
	do
		user := u
		points := p
	end
	make_from_int(u : INTEGER; p : INTEGER)
	do
		userid := u
		points := p
	end

feature
	getUser : USER
	do
		Result := user
	end

	getUserId : INTEGER
	do
		Result := userid
	end

	getPoints : INTEGER
	do
		Result := points
	end

	setUser(u : USER)
	require
		u /= Void
	do
		user := u
	end

	setUserId(id : INTEGER)
	do
		userid := id
	end

	setPoints(p : INTEGER)
	do
		points := p
	end


end
