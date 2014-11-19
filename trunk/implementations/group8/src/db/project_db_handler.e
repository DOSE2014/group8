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
	uDBhand: USER_DB_HANDLER
feature{NONE}
	make(s: SQLITE_DATABASE, userDBHandler: USER_DB_HANDLER)
		do
			db := s
			uDBhand := userDBHandler
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
	deleteProject(p:PROJECT)
	do
			create dbmodifystatement.make ("DELETE FROM Project WHERE id=" + p.getid.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting project.%N")
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
			create uDBhand.make (db)
			resultobject.setManager (uDBhand.getuserfromid (row.string_value (4).to_integer))
			resultobject.setStakeholder (uDBhand.getuserfromid (row.string_value (5).to_integer))
			create d.make_from_epoch (row.string_value (6).to_integer)
			resultobject.setCreationDate (d)
			resultobject.setDeleted(row.string_value (7).to_boolean)
		end
feature{NONE}
	ec : EIFFEL_CONVERSION once create Result end
end
