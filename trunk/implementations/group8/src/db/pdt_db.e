note
	description: "Summary description for {PDT_DB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PDT_DB

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	userDBHandler: USER_DB_HANDLER
	projectDBHandler: PROJECT_DB_HANDLER

feature
	make(pathToDB: STRING)
		require
			validPath: pathToDB /= Void and not pathToDB.is_empty
		do
			create db.make_open_read_write(pathToDB)
			create userdbhandler.make(db)
			create projectDBHandler.make (db, userdbhandler)
		end

feature
	getUserFromId(i: INTEGER): USER
		local
			u : USER
		do
			Result := userDBHandler.getuserfromid(i)
		end
	getUserFromEmailPassword(email, password: STRING): USER
		do
			Result := userDBHandler.getuserfromemailpassword (email, password)
		end

	insertUser(u: USER)
		do
			userDBHandler.insertUser(u)
		end

	deleteUser(u: USER)
		do
			userDBHandler.deleteuser (u)
		end
	getProjectFromId(id: INTEGER): PROJECT
		do
			Result:= projectDBHandler.getProjectFromId(id)
		end
		insertProject(p:PROJECT)
		do
			projectDBHandler.insertProject(p)
		end
		deleteProject(p:PROJECT)
		do
			projectDBHandler.deleteProject(p)
		end


end
