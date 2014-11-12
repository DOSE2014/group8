note
	description: "Summary description for {USER_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInserStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	genUser(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: USER): BOOLEAN
		local
			i: NATURAL
		do
			from i := 1
			until i > numColumns
			loop
				print("Row " + i.out + ": " + row.string_value(i) + "%N")
				i := i + 1
			end
			Result := false
		end
feature
	make(s: SQLITE_DATABASE)
		do
			db := s
		end

feature
	getUser(id: INTEGER): USER
		do
			create Result.make_default
			create dbQueryStatement.make ("SELECT * FROM User WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genUser(?, 11, Result))
		end
	deleteUser(id: INTEGER)
		do
		end
end
