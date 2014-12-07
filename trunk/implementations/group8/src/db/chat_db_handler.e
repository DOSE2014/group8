note
	description: "Summary description for {CHAT_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHAT_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	projectDBHandler: PROJECT_DB_HANDLER
	userDBHandler: USER_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; projDBHand: PROJECT_DB_HANDLER; userDBHand: USER_DB_HANDLER)
		do
			db := s
			projectDBHandler := projDBHand
			userDBHandler := userDBHand
		end

feature
	getChatFromId(id: INTEGER): CHAT
		do
			create Result.make_default
			create dbquerystatement.make ("SELECT * FROM Chat WHERE id=" + id.out + ";", db)
			dbquerystatement.execute (agent genChat(?, 2, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end


feature{NONE}
	genChat(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: CHAT): BOOLEAN
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setproject (projectDBHandler.getprojectfromid (row.string_value (2).to_integer))
			Result := false
		end
end
