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
	sprintlogDBHandler: SPRINTLOG_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; backdbhand: BACKLOG_DB_HANDLER; sprintdbhand: SPRINTLOG_DB_HANDLER)
		do
			db := s
			backlogDBHandler := backdbhand
			sprintlogDBHandler := sprintdbhand
		end

feature
	getPBIFromID(id: INTEGER): PBI
		do
			create Result.make_default
			create dbQueryStatement.make ("SELECT * FROM PBI WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genPBI(?, 8, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	insertPBI(pbi: PBI)
		local
			epoch: DATE_TIME
			sprint : STRING
		do
			create epoch.make_from_epoch (0)

			if attached pbi.getSprintlog then
				sprint := "'" + pbi.getSprintlog.getid.out + "'"
			else
				sprint := "NULL"
			end
			create dbInsertStatement.make("INSERT INTO PBI(name, description, backlog, sprintlog, type, priority, dueDate) VALUES('" +
											pbi.getname + "', '" + pbi.getdescription + "', '" + pbi.getbacklog.getid.out + "', " + sprint + ", '" +
											pbi.gettype.out + "', '" + pbi.getpriority.out + "', '" + pbi.getduedate.definite_duration(epoch).seconds_count.out + "');", db)
			dbInsertStatement.execute
			if dbInsertStatement.has_error
			then print("Error while inserting pbi.")
			end
		end

	deletePBI(pbi: INTEGER)
		do
			create dbModifyStatement.make("DELETE FROM PBI WHERE id=" + pbi.out + ";", db)
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while deleting pbi.")
			end
		end
	editPBI(pbi: PBI)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			if attached pbi.getsprintlog then
				create dbModifyStatement.make("UPDATE PBI SET name = '" + pbi.getname + "', description = '" + pbi.getdescription + "', backlog='" + pbi.getbacklog.getid.out +
											"', sprintlog = '" + pbi.getsprintlog.getid.out + "', type = '" + pbi.gettype.out + "', priority = '" +
											pbi.getpriority.out + "', dueDate = '" + pbi.getduedate.definite_duration(epoch).seconds_count.out + "' WHERE id='" +
											pbi.getid.out+ "';", db)
			else
				create dbModifyStatement.make("UPDATE PBI SET name = '" + pbi.getname + "', description = '" + pbi.getdescription + "', backlog='" + pbi.getbacklog.getid.out +
											"', type = '" + pbi.gettype.out + "', priority = '" +
											pbi.getpriority.out + "', dueDate = '" + pbi.getduedate.definite_duration(epoch).seconds_count.out + "' WHERE id='" +
											pbi.getid.out+ "';", db)
			end
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while updating a backlog.%N")
			end
		end

	getPBIsFromBacklogId(id: INTEGER): LINKED_SET[PBI]
		do
			create Result.make
			create dbquerystatement.make ("SELECT * FROM PBI WHERE backlog=" + id.out + ";", db)
			dbquerystatement.execute (agent genpbis(?, 8, Result))
			if Result.count = 0
			then Result := Void
			end
		end
		getpbisfromsprintlogid(id: INTEGER) : LINKED_SET[PBI]
		do
			create Result.make
				create dbquerystatement.make ("SELECT * FROM PBI WHERE sprintlog=" + id.out + ";", db)
				dbquerystatement.execute (agent genPBIs(?, 8, Result))
				if Result.count = 0 then
					Result := Void
				end
		end

		listPBIOfSprintlogId(s: INTEGER): LINKED_SET[PBI]
		do
			create Result.make
			create dbquerystatement.make ("SELECT * FROM PBI Where sprintlog=" + s.out + ";", db)
			dbquerystatement.execute (agent genpbis (?, 8, Result))
			if Result.count = 0
			then Result := Void
			end
		end
		insertpbiintosprintlog(pbi,s:INTEGER)
		do
		create dbModifyStatement.make("UPDATE PBI SET sprintlog = '" + s.out + "' WHERE id='" +
											pbi.out + "';", db)
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while updating pbi.")
			end
		end
		removepbifromsprintlog(pbi,s:INTEGER)
			do
			create dbModifyStatement.make("UPDATE PBI SET sprintlog = NULL WHERE id='" +
												pbi.out + "';", db)
				dbModifyStatement.execute
				if dbModifyStatement.has_error
				then print("Error while updating pbi.")
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
			resultobject.setsprintlog(sprintlogDBHandler.getSprintlogFromId(row.string_value (5).to_integer))
			resultobject.settype (row.string_value (6).to_integer)
			resultobject.setpriority (row.string_value(7).to_integer)
			create d.make_from_epoch (row.string_value (8).to_integer)
			resultobject.setduedate (d)

			Result := false
		end

	genPBIs(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: LINKED_SET[PBI]): BOOLEAN
		local
			x: BOOLEAN
			p: PBI
		do
			create p.make_default
			x := genpbi (row, numColumns, p)
			resultobject.extend (p)
			Result := false
		end
end
