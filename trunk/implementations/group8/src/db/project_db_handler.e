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
	getProjectFromId(id: INTEGER): PROJECT
	do
		create Result.make_default
		create dbQueryStatement.make ("SELECT * FROM Project WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genProject(?, 7, Result))
			if Result.getId = 0 then
				Result := Void
			end
	end

	insertProject(p:PROJECT)
	local
		epoch: DATE_TIME
	do
		create epoch.make_from_epoch (0)
		create dbinsertstatement.make ("INSERT INTO Project" +
										 "VALUES ('" + p.getid.out + "', '" + p.getname + "', '" + p.getdescription + "', '" + p.getmanager.getid.out +
										 "', '" + p.getstakeholder.getid.out + "', '" + p.getcreationdate.definite_duration (epoch).seconds_count.out + "', '" +
										ec.bool_to_int(p.getDeleted).out +	 "');", db)
		dbinsertstatement.execute
		if dbinsertstatement.has_error
		then print("Error while inserting a new user.%N")
		end
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

	deleteDeveloperFromProject(d: INTEGER; p: INTEGER)
		do
			create dbmodifystatement.make ("DELETE FROM Developer_Project WHERE developer=" + d.out + " AND project=" + p.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting developer from project.")
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
			resultobject.setDeleted(row.string_value (7).to_boolean)
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
feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
end
