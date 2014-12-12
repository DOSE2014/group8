note
	description: "Summary description for {TASK_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TASK_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	userDBHandler: USER_DB_HANDLER
	pbiDBHandler: PBI_DB_HANDLER

feature
	make(s: SQLITE_DATABASE; userdbHand: USER_DB_HANDLER; pbidbhand: PBI_DB_HANDLER)
		do
			db := s
			userDBHandler := userdbHand
			pbiDBHandler := pbidbhand
		end

feature
	getTaskFromId(id: INTEGER): TASK
		do
			create Result.make_default
			create dbQueryStatement.make ("SELECT * FROM Task WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genTask(?, 8, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	insertTask(t: TASK)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbInsertStatement.make("INSERT INTO Task(id, name, description, developer, points, state, pbi, completionDate) VALUES('" + t.getid.out + "', '" +
											t.getname + "', '" + t.getdescription + "', '" + t.getDeveloper.getid.out + "', '" +
											t.getpoints.out + "', '" + t.getState.out + "', '" + t.getpbi.getid.out + "', '" + t.getcompletiondate.definite_duration (epoch).seconds_count.out + "');", db)
			dbInsertStatement.execute
			if dbInsertStatement.has_error
			then print("Error while inserting task.")
			end
		end

	deleteTask(t: INTEGER)
		do
			create dbModifyStatement.make("DELETE FROM Task WHERE id=" + t.out + ";", db)
			dbModifyStatement.execute
			if dbModifyStatement.has_error
			then print("Error while deleting task.")
			end
		end
	getTasksFromPBIId(p: INTEGER): LINKED_SET[TASK]
		do
			create Result.make
			create dbquerystatement.make ("SELECT * FROM Task WHERE pbi=" + p.out + ";", db)
			dbquerystatement.execute (agent genTasks(?, 7, Result))
			if Result.count = 0 then
				Result := Void
			end
		end
	editTask(t: TASK)
	local
		pbisql : STRING
	do
		if t.getpbi /= Void then
			pbisql := ",pbi=" + t.getpbi.getid.out + " "
		else
			pbisql := ""
		end
		create dbmodifystatement.make ("UPDATE Task SET name='" + t.getname + "', description='" +
					t.getdescription + "', developer='" + t.getdeveloper.getid.out + "', points='" + t.getpoints.out +
					"', state='" + t.getstate.out + "' " + pbisql + ", completionDate='" + t.getcompletiondate.definite_duration (epoch).seconds_count.out +
					"' WHERE id=" + t.getid.out + ";", db)

				dbmodifystatement.execute
				if dbmodifystatement.has_error
				then print("Error while updating task.")
				end
	end

feature{NONE}
	genTask(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: TASK): BOOLEAN
		local
			completionDate: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setname (row.string_value (2))
			resultobject.setdescription (row.string_value (3))
			resultobject.setDeveloper (userDBHandler.getUserFromId(row.string_value (4).to_integer))
			resultobject.setpoints (row.string_value(5).to_integer)
			if row.string_value (6).to_integer = {STATE}.completed
			then resultobject.setstate ({STATE}.completed)
			elseif row.string_value (6).to_integer = {STATE}.ongoing
			then resultobject.setstate ({STATE}.ongoing)
			else resultobject.setstate ({STATE}.awaiting)
			end
			resultobject.setpbi (pbiDBHandler.getPBIFromId(row.string_value (7).to_integer))
			create completiondate.make_from_epoch (row.string_value (8).to_integer)
			resultobject.setcompletiondate (completionDate)

			Result := false
		end

	genTasks(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: LINKED_SET[TASK]): BOOLEAN
		local
			x: BOOLEAN
			t: TASK
		do
			create t.make_default
			x := gentask (row, numColumns, t)
			resultobject.extend(t)
			Result := false

		end
end
