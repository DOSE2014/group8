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
	projectDBHandler: PROJECT_DB_HANDLER
feature
	make(s: SQLITE_DATABASE; pDBhand: PROJECT_DB_HANDLER)
		do
			db := s
			projectDBHandler := pDBhand
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

	getBacklogFromProjectId(idproj: INTEGER): BACKLOG
	do
		create Result.make_default
		create dbQueryStatement.make ("SELECT * FROM Backlog WHERE project=" + idproj.out + ";", db)
		dbQueryStatement.execute (agent genBacklog(?, 3, Result))
		if Result.getId = 0 then
			Result := Void
		end
	end

	insertBacklog(b: BACKLOG)
	do
		create dbinsertstatement.make ("INSERT INTO Backlog(description, project)" +
										 "VALUES ('" + b.getdescription + "', '" + b.getproject.getid.out +	 "');", db)
		dbinsertstatement.execute
		if dbinsertstatement.has_error
		then print("Error while inserting a new backlog.%N")
		end
	end
	updateBacklog(b: BACKLOG)
	do
		create dbModifyStatement.make("UPDATE Backlog SET id = '" +
										b.getid.out +"', description = '"+b.getdescription+"', project='"+ b.getproject.getid.out+
										"' WHERE id='"+ b.getid.out+ "';", db)
		dbModifyStatement.execute
		if dbModifyStatement.has_error
		then print("Error while updating a backlog.%N")
		end
	end

	deleteBacklogFromProjectId(id: INTEGER)
		do
			create dbmodifystatement.make ("DELETE FROM Backlog WHERE project=" + id.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting backlog.")
			end
		end

feature{NONE}
	genBacklog(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: BACKLOG): BOOLEAN
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setDescription (row.string_value (2).out)
			resultobject.setProject ( projectDBHandler.getProjectFromID( row.string_value (3).to_integer) )
		end
feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
end
