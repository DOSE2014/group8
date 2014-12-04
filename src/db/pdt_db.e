note
	description: "Summary description for {PDT_DB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class	-- Declared as frozen to not inherit this by mistake
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
			create pbiDBHandler.make(db, backlogDBHandler, sprintlogDBHandler)
			create taskDBHandler.make(db, userDBHandler, pbiDBHandler)
		end

feature
	getUserFromId(i: INTEGER): USER
		do
			Result := userDBHandler.getuserfromid(i)
		end
	getDevelopers: LINKED_SET[USER]
		do
			Result := userDBHandler.getDevelopers
		end
	getUserFromEmailPassword(email, password: STRING): USER
		do
			Result := userDBHandler.getuserfromemailpassword (email, password)
		end

	insertUser(u: USER)
		do
			userDBHandler.insertUser(u)
		end

	deleteUserFromId(u: INTEGER)
		do
			userDBHandler.deleteuser (u)
		end
	getProjectFromId(id: INTEGER): PROJECT
		do
			Result:= projectDBHandler.getProjectFromId(id)
		end
	insertProject(p: PROJECT): INTEGER
		do
			Result := projectDBHandler.insertProject(p)
		end
	deleteProjectFromId(p: INTEGER)
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
	deletePBIFromId(pbi: INTEGER)
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
	deleteSprintlogFromId(s: INTEGER)
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
	deleteTaskFromId(t: INTEGER)
		do
			taskdbhandler.deletetask (t)
		end
	addDeveloperToProject(d: INTEGER; p: INTEGER)
		do
			projectdbhandler.addDeveloperToProject(d, p)
		end
	getProjectsVisibleToUser(u: INTEGER): LINKED_SET[PROJECT]
		do
			Result := projectdbhandler.getProjectsVisibleToUser(u)
		end
	deleteDeveloperFromProject(d: INTEGER; p: INTEGER)
		do
			projectdbhandler.deleteDeveloperFromProject(d, p)
		end
	getBacklogFromProjectId(id: INTEGER): BACKLOG
		do
			Result := backlogdbhandler.getbacklogFromProjectId(id)
		end
	deleteBacklogFromProjectId(id: INTEGER)
		do
			backlogdbhandler.deleteBacklogFromProjectId(id)
		end
	getTasksFromPBIId(pbi: INTEGER): LINKED_SET[TASK]
		do
			Result := taskdbhandler.getTasksFromPBIId(pbi)
		end
	existsEmailInUser(email: STRING): BOOLEAN
		local
			u: USER
		do
			u := userdbhandler.existsEmail(email)
			if u = Void
			then Result := false
			else Result := true
			end
		end
	listPBIOfSprintlogID(s: INTEGER): LINKED_SET[PBI]
		do
			Result := pbidbhandler.listPBIOfSprintlogID(s)
		end
	editPBI(pbi: PBI)
		do
			pbidbhandler.editPBI(pbi)
		end
	listSprintlogsFromBacklogId(b: INTEGER) : LINKED_SET[SPRINTLOG]
		do
			Result := sprintlogdbhandler.listSprintlogsFromBacklogId(b)
		end
	editUser(u: USER)
		do
			userdbhandler.editUser(u)
		end
	existsNameInProject(name: STRING): BOOLEAN
		local
			p: PROJECT
		do
			p := projectdbhandler.getProjectFromName(name)
			if p = Void
			then Result := false
			else Result := true
			end
		end
	editTask(t:TASK)
	do
		taskdbhandler.edittask (t)
	end

	getDevelopersFromProjectId(p: INTEGER): LINKED_SET[USER]
	do
		Result := userdbhandler.getdevelopersFromProjectId(p)
	end


	editProject(p: PROJECT)
	do
		projectdbhandler.editProject(p)
	end

	checkVisibilityForProject(u: INTEGER; p :INTEGER) : BOOLEAN
	do
		Result := projectdbhandler.checkVisibilityForProject(u,p)
	end

	getpbisfrombacklogid(id: INTEGER): LINKED_SET[PBI]
		do
			Result := pbidbHandler.getPBIsFromBacklogId(id)
		end
end
