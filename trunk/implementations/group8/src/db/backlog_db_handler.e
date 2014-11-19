note
	description: "Summary description for {BACKLOG_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BACKLOG_DB_HANDLER

create
	make
feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT
feature{NONE}
	make(s: SQLITE_DATABASE)
		do
			db := s
		end
feature
	getBacklogFromId(id: INTEGER): BACKLOG
	do
		create Result.make_default
		create dbQueryStatement.make ("SELECT * FROM Backlog WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genBacklog(?, 3, Result))
			if Result.getId = 0 then
				Result := Void
			end
	end
	insertBacklog(b:backlog)
	do
		create dbinsertstatement.make ("INSERT INTO Backlog" +
										 "VALUES ('" + b.getid.out + "', '" + b.getdescription + "', '" + b.getproject.getid.out +	 "');", db)
		dbinsertstatement.execute
		if dbinsertstatement.has_error
		then print("Error while inserting a new backlog.%N")
		end
	end
	updateBacklog(b:backlog)
	do
		create dbModifyStatement.make("UPDATE Backlog SET id = '" +
										b.getid.out +"', description = '"+b.getdescription+"', project='"+ b.getproject.getid.out+
										"' WHERE id='"+ b.getid.out+ "';", db)
		dbModifyStatement.execute
		if dbModifyStatement.has_error
		then print("Error while updating a backlog.%N")
		end
	end


feature{NONE}
	genBacklog(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: BACKLOG): BOOLEAN
	local
		pDBhand: PROJECT_DB_HANDLER
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setDescription (row.string_value (2).out)
			create pDBhand.make (db)
			resultobject.setProject ( pDBHand.getProjectFromID( ec.any_to_int(row.string_value (3)) ) )
		end
feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
end
