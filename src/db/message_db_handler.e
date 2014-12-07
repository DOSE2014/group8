note
	description: "Summary description for {MESSAGE_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	userDBHandler: USER_DB_HANDLER
	chatDBHandler: CHAT_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; userDBHand: USER_DB_HANDLER; chatDBHand: CHAT_DB_HANDLER)
		do
			db := s
			userDBHandler := userDBHand
			chatdbhandler := chatdbhand
		end
	getMessageFromId(id: INTEGER): MESSAGE
		do
			create Result.make_default
			create dbquerystatement.make ("SELECT * FROM Message WHERE id=" + id.out + ";", db)
			dbquerystatement.execute (agent genMessage(?, 5, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	getChatMessagesFromChatID(id: INTEGER): LINKED_SET[MESSAGE]
		do
			create Result.make
			create dbquerystatement.make ("SELECT * FROM Message WHERE chat=" + id.out + ";", db)
			dbquerystatement.execute (agent genMessages(?, 5, Result))
			if Result.count = 0 then
				Result := Void
			end
		end
	
feature{NONE}
	genMessage(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: MESSAGE): BOOLEAN
		local
			d: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setuser (userDBHandler.getUserFromId(row.string_value (2).to_integer))
			create d.make_from_epoch (row.string_value (3).to_integer)
			resultobject.setdate (d)
			resultobject.setchat (chatDBHandler.getChatFromId(row.string_value (4).to_integer))
			resultobject.setcontent (row.string_value (5))

			Result := false
		end
	genMessages(row:SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: LINKED_SET[MESSAGE]): BOOLEAN
		local
			x: BOOLEAN
			msg: MESSAGE
		do
			create msg.make_default
			x := genMessage(row, numColumns, msg)
			resultobject.extend(msg)
			Result := false
		end

end
