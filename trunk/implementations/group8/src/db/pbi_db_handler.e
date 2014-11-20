note
	description: "Summary description for {PBI_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PBI_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	backlogDBHandler: BACKLOG_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; backdbhand: BACKLOG_DB_HANDLER)
		do
			db := s
			backlogDBHandler := backdbhand
		end

feature
	getPBIFromID(id: INTEGER): PBI
		do
			create Result.make_default
			create dbQueryStatement.make ("SELECT * FROM PBI WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genPBI(?, 7, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	insertPBI(pbi: PBI)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbInsertStatement.make("INSERT INTO PBI(id, name, description, backlog, type, priority, dueDate) VALUES('" + pbi.getid.out + "', '" +
											pbi.getname + "', '" + pbi.getdescription + "', '" + pbi.getbacklog.getid.out + "', '" + pbi.gettype.out + "', '" +
											pbi.getpriority.out + "', '" + pbi.getduedate.definite_duration(epoch).seconds_count.out + "');", db)
			dbInsertStatement.execute
			if dbInsertStatement.has_error
			then print("Error while inserting pbi.")
			end
		end

	deletePBI(pbi: PBI)
		do
			create dbModifyStatement.make("DELETE FROM PBI WHERE id=" + pbi.getid.out + ";", db)
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while deleting pbi.")
			end
		end

feature{NONE}
	genPBI(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: PBI): BOOLEAN
		local
			d: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setname (row.string_value (2))
			resultobject.setdescription (row.string_value (3))
			resultobject.setbacklog(backlogDBHandler.getBacklogFromId(row.string_value (4).to_integer))
			resultobject.settype (row.string_value (5).to_integer)
			resultobject.setpriority (row.string_value(6).to_integer)
			create d.make_from_epoch (row.string_value (7).to_integer)
			resultobject.setduedate (d)

			Result := false
		end
end
