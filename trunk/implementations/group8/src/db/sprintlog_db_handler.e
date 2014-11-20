note
	description: "Summary description for {SPRINTLOG_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPRINTLOG_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	backlogDBHandler: BACKLOG_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; backDBHand: BACKLOG_DB_HANDLER)
		do
			db := s
			backlogDBHandler := backDBHand
		end

feature
	getSprintlogFromId(id: INTEGER): SPRINTLOG
		do
			create Result.make_default
			create dbQueryStatement.make("SELECT * FROM Sprintlog WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute(agent genSprintlog(?, 6, Result))
			if Result.getId = 0
			then Result := Void
			end
		end

	insertSprintlog(s: SPRINTLOG)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbInsertStatement.make("INSERT INTO Sprintlog(id, name, description, backlog, startDate, endDate) VALUES ('" +
											s.getid.out + "', '" + s.getname + "', '" + s.getdescription + "', '" + s.getbacklog.getid.out + "', '" +
											s.getstartdate.definite_duration(epoch).seconds_count.out + "', '" +
											s.getenddate.definite_duration(epoch).seconds_count.out + "');", db)
			dbInsertStatement.execute
			if dbInsertStatement.has_error
			then print("Error while inserting new Sprintlog")
			end

			--TODO Should insert backlog from here? I think the method to insert backlog should be called separately.
		end

	deleteSprintlog(s: SPRINTLOG)
		do
			create dbModifyStatement.make("DELETE FROM Sprintlog WHERE id=" + s.getid.out + ";", db)
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while deleting sprintlog")
			end
		end

feature{NONE}
	genSprintlog(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: SPRINTLOG): BOOLEAN
		local
			d: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setName(row.string_value (2))
			resultobject.setdescription (row.string_value (3))
			resultobject.setbacklog (backlogDBHandler.getBacklogFromId(row.string_value (4).to_integer))
			create d.make_from_epoch (row.string_value (5).to_integer)
			resultobject.setstartdate (d)
			create d.make_from_epoch (row.string_value (6).to_integer)
			resultobject.setenddate (d)

			Result := false
		end

end
