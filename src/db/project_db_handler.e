note
	description: "Summary description for {PROJECT_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECT_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT
	userDBhandler: USER_DB_HANDLER
feature
	make(s: SQLITE_DATABASE; uDBHand: USER_DB_HANDLER)
		do
			db := s
			userDBhandler := uDBHand
		end

feature

--  Do not use this method bugged (see BACKLOG_DB_HANDLER for better functions)
--  Federico
--
--	getBacklogIdFromProjectAndUser(p : PROJECT; u : USER) : INTEGER
--	require
--		p /= Void and u /= Void
--	local
--		query_res_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
--	do
--		create dbQueryStatement.make ("SELECT `id` FROM Backlog WHERE project=? AND EXISTS(SELECT * FROM Project WHERE manager=? AND project=?);", db)
--		query_res_cursor := dbQueryStatement.execute_new_with_arguments (<<p.getId, u.getId, p.getId>>)
--		if query_res_cursor.after then
--			-- there are no rows in the result of the query
--			Result := -1
--		else
--			Result := ec.any_to_int (query_res_cursor.item.value(1))
--		end

--	end

	getProjectFromId(id: INTEGER): PROJECT
	local
	do
		create Result.make_default
		create dbQueryStatement.make ("SELECT * FROM Project WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genProject(?, 7, Result))
			if Result.getId = 0 then
				Result := Void
			end
	end

	getProjectFromName(name: STRING): PROJECT
		do
			create Result.make_default
			create dbquerystatement.make ("SELECT * FROM Project WHERE name='" + name + "';", db)
			dbquerystatement.execute (agent genProject(?, 7, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	insertProject(p:PROJECT): INTEGER
	local
		epoch: DATE_TIME
		rowId: INTEGER
		cursor: SQLITE_STATEMENT_ITERATION_CURSOR
	do
		create epoch.make_from_epoch (0)
		create dbinsertstatement.make ("INSERT INTO Project(name, description, manager, stakeholder, creationDate, deleted) " +
										 "VALUES ('" + p.getname + "', '" + p.getdescription + "', '" + p.getmanager.getid.out +
										 "', '" + p.getstakeholder.getid.out + "', '" + p.getcreationdate.definite_duration (epoch).seconds_count.out + "', '" +
										ec.bool_to_int(p.getDeleted).out +	 "');", db)
		dbinsertstatement.execute
		create dbquerystatement.make ("SELECT last_insert_rowid();", db)
		cursor := dbquerystatement.execute_new
		if not cursor.after then
			rowId := cursor.item.value(1).out.to_integer
		end

		if dbinsertstatement.has_error
		then print("Error while inserting a new project.%N")
		end
		Result := rowId
	end

	deleteProject(p: INTEGER)
	do
			create dbmodifystatement.make ("DELETE FROM Project WHERE id=" + p.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting project.%N")
			end
	end

	addDeveloperToProject(d: INTEGER; p: INTEGER)
		do
			create dbinsertstatement.make ("INSERT INTO Developer_Project(developer, project) VALUES('" + d.out + "', '" + p.out + "');", db)
			dbinsertstatement.execute
			if dbinsertstatement.has_error
			then print("Error while inserting a developer in project.")
			end
		end

	getProjectsVisibleToUser(u: INTEGER): LINKED_SET[PROJECT]
		do
			create Result.make
			create dbquerystatement.make ("SELECT id, name, description, manager, stakeholder, creationDate, deleted FROM PROJECT JOIN Developer_Project" +
											" ON Project.id = Developer_Project.project WHERE manager=" + u.out + " OR stakeholder=" + u.out +
											" OR Developer_Project.developer=" + u.out + ";", db)
			dbquerystatement.execute (agent genProjects(?, 7, Result))
			if Result.count = 0
			then Result := Void
			end
		end

	checkVisibilityForProject(u : INTEGER; p : INTEGER) : BOOLEAN
	local
		query_result_cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		e:STRING
	do
		create dbquerystatement.make ("SELECT * FROM PROJECT JOIN Developer_Project" +
											" ON Project.id = Developer_Project.project WHERE (manager=" + u.out + " OR stakeholder=" + u.out +
											" OR Developer_Project.developer=" + u.out + ")  AND id="+p.out+";", db)
		query_result_cursor := dbquerystatement.execute_new


		if not query_result_cursor.item.is_null (1) then
			Result := True
		else
			Result := False
		end
	end

	deleteDeveloperFromProject(d: INTEGER; p: INTEGER)
		do
			create dbmodifystatement.make ("DELETE FROM Developer_Project WHERE developer=" + d.out + " AND project=" + p.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting developer from project.")
			end
		end

	editProject(p: PROJECT)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbmodifystatement.make ("UPDATE Project SET name='" + p.getname + "', description='" + p.getdescription + "', manager='" + p.getmanager.getid.out + "', stakeholder='"
											+ p.getstakeholder.getid.out + "', creationDate='" + p.getcreationdate.definite_duration (epoch).seconds_count.out + "', deleted='"
											+ p.getdeleted.to_integer.out + "' WHERE id=" + p.getid.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while updating project.")
			end

		end

feature{NONE}
	genProject(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: PROJECT): BOOLEAN
		local
			d: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setName (row.string_value (2).out)
			resultobject.setDescription (row.string_value (3).out)
			resultobject.setManager (userDBHandler.getuserfromid (row.string_value (4).to_integer))
			resultobject.setStakeholder (userDBHandler.getuserfromid (row.string_value (5).to_integer))
			create d.make_from_epoch (row.string_value (6).to_integer)
			resultobject.setCreationDate (d)
			resultobject.setdeleted (ec.int_to_bool (row.string_value (7).to_integer))
		end

	genProjects(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject:LINKED_SET[PROJECT]): BOOLEAN
		local
			x: BOOLEAN
			p: PROJECT
		do
			create p.make_default
			x := genproject (row, numColumns, p)
			resultobject.extend (p)
			Result := false
		end
	getLastInsertRowId(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: INTEGER): BOOLEAN
		do
			resultobject.set_item (row.string_value (1).to_integer)
			Result := false
		end
feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
end
