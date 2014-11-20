note
	description: "Summary description for {PDT_DB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PDT_DB
inherit
	LOG

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	languageDBHandler: LANGUAGE_DB_HANDLER
	programmingLanguageDBHandler: PROGRAMMING_LANGUAGE_DB_HANDLER
	userDBHandler: USER_DB_HANDLER
	projectDBHandler: PROJECT_DB_HANDLER
	backlogDBHandler: BACKLOG_DB_HANDLER
	sprintlogDBHandler: SPRINTLOG_DB_HANDLER
	pbiDBHandler: PBI_DB_HANDLER
	taskDBHandler: TASK_DB_HANDLER
feature
	make(pathToDB: STRING)
		require
			validPath: pathToDB /= Void and not pathToDB.is_empty
		do
			if ((create {RAW_FILE}.make (pathToDB.as_string_8)).exists) then
				-- If db exists, open it!
				create db.make_open_read_write(pathToDB)
			else
				-- Ok no, we need to create it!
				log.warning("[PDT_DB] no DB found, creating one...")
				-- create db.create_open_read_write(pathToDB)
				-- TODO EXECUTE QUERY FOR CREATION
			end
			create languageDBHandler.make(db)
			create programmingLanguageDBHandler.make(db)
			create userdbhandler.make(db, languageDBHandler, programmingLanguageDBHandler)
			create projectDBHandler.make (db, userdbhandler)
			create backlogDBHandler.make(db, projectDBHandler)
			create sprintlogDBHandler.make(db, backlogDBHandler)
			create pbiDBHandler.make(db, backlogDBHandler)
			create taskDBHandler.make(db, sprintlogDBHandler, userDBHandler, pbiDBHandler)
		end

feature
	getUserFromId(i: INTEGER): USER
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
	getBacklogFromId(id: INTEGER): BACKLOG
		do
			Result := backlogdbhandler.getbacklogfromid (id)
		end
	insertBacklog(b: BACKLOG)
		do
			backlogdbhandler.insertbacklog (b)
		end
	updateBacklog(b: BACKLOG)
		do
			backlogdbhandler.updatebacklog (b)
		end
	getLanguages: LINKED_SET[LANGUAGE]
		do
			Result := languagedbhandler.getlanguages
		end
	getProgrammingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			Result := programminglanguagedbhandler.getprogramminglanguages
		end
	getPBIFromID(id: INTEGER): PBI
		do
			Result := pbidbhandler.getpbifromid (id)
		end
	insertPBI(pbi: PBI)
		do
			pbidbhandler.insertpbi (pbi)
		end
	deletePBI(pbi: PBI)
		do
			pbidbhandler.deletepbi (pbi)
		end
	getSprintlogFromId(id: INTEGER): SPRINTLOG
		do
			Result := sprintlogdbhandler.getsprintlogfromid (id)
		end
	insertSprintlog(s: SPRINTLOG)
		do
			sprintlogdbhandler.insertsprintlog (s)
		end
	deleteSprintlog(s: SPRINTLOG)
		do
			sprintlogdbhandler.deletesprintlog (s)
		end
	getTaskFromId(id: INTEGER): TASK
		do
			Result := taskdbhandler.gettaskfromid (id)
		end
	insertTask(t: TASK)
		do
			taskdbhandler.inserttask (t)
		end
	deleteTask(t: TASK)
		do
			taskdbhandler.deletetask (t)
		end

end
