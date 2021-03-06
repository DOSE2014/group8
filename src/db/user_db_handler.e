note
	description: "Summary description for {USER_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER_DB_HANDLER

inherit
	LOG

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	programmingLanguageDBHandler: PROGRAMMING_LANGUAGE_DB_HANDLER
	languageDBHandler: LANGUAGE_DB_HANDLER

	programmingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
	languages: LINKED_SET[LANGUAGE]

	--Data updated everytime a user is taken from DB
	programmingLanguageUser_Hash: HASH_TABLE[LINKED_SET[PROGRAMMING_LANGUAGE], INTEGER]
	languageUser_Hash: HASH_TABLE[LINKED_SET[LANGUAGE], INTEGER]

	ec: EIFFEL_CONVERSION

feature
	make(s: SQLITE_DATABASE; lanDBHand: LANGUAGE_DB_HANDLER; proglanDBHand: PROGRAMMING_LANGUAGE_DB_HANDLER)
		do
			db := s
			programmingLanguageDBHandler := proglanDBHand
			languageDBHandler := lanDBHand
			programminglanguages := programminglanguageDBHandler.getProgrammingLanguages
			languages := languageDBHandler.getLanguages
		end

feature{NONE}
	genUser(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: USER): BOOLEAN
		local
			d: DATE_TIME
		do
			resultobject.setid (row.string_value (1).to_integer)
			resultobject.setfirstname (row.string_value (2))
			resultobject.setlastname (row.string_value (3))

			if row.string_value (4).to_integer = {SEX}.male
			then resultobject.setsex ({SEX}.male)
			else resultobject.setsex ({SEX}.female)
			end

			create d.make_from_epoch (row.string_value (5).to_integer)
			resultobject.setdateofbirth (d)

			resultobject.setcountry (row.string_value (6))
			resultobject.settimezone (row.string_value (7))
			resultobject.setemail (row.string_value (8))
			resultobject.setpassword (row.string_value (9))

			if row.string_value (10).to_integer = {USERTYPE}.developer
			then resultobject.setusertype({USERTYPE}.developer)
			else resultobject.setusertype({USERTYPE}.stakeholder)
			end

			if not row.is_null(11) then
				resultobject.setorganization (row.string_value (11))
			else
				resultobject.setorganization (Void)
			end

			resultobject.setdeleted (row.string_value (12).to_integer = 1)
			if resultobject.getusertype = {USERTYPE}.developer then
				programmingLanguageUser_Hash := getprogrammingLanguageUser
				resultobject.setprogramminglanguages (programminglanguageuser_hash.at (resultobject.getid))
			end
			languageUser_Hash := getLanguageUser
			resultobject.setlanguages (languageuser_hash.at (resultobject.getid))
			Result := false
		end

	genUsers(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: LINKED_SET[USER]): BOOLEAN
		local
			x: BOOLEAN
			u: USER
		do
			create u.make_default
			x := genUser(row, numColumns, u)
			resultobject.extend (u)
		end

	genStats(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: LINKED_LIST[STAT_ENTRY]): BOOLEAN
	local
		st : STAT_ENTRY
		userid,points : INTEGER
	do
		userid := row.integer_value(1)
		points := row.integer_value(2)
		create st.make_from_int (userid, points)
		resultobject.extend(st)
	end

	getLastInsertRowId(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: INTEGER): BOOLEAN
		do
			resultobject.set_item (row.string_value (1).to_integer)
			Result := false
		end

	create_ProgrammingLanguageUser_Hash(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: HASH_TABLE[LINKED_SET[PROGRAMMING_LANGUAGE], INTEGER]): BOOLEAN
		local
			i: NATURAL
			linset: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			from i := 1
			until i > numColumns
			loop
				if resultobject.has (row.string_value (i+1).to_integer)
				then resultobject.at (row.string_value (i+1).to_integer).extend (programminglanguages.at (row.string_value (i).to_integer))
				else
					create linset.make
					linset.extend (programmingLanguages.at (row.string_value (i).to_integer))
					resultobject.extend (linset, row.string_value (i+1).to_integer)
				end

				i := i + 2
			end
			Result := false
		end

	getProgrammingLanguageUser: HASH_TABLE[LINKED_SET[PROGRAMMING_LANGUAGE], INTEGER]
		do
			create Result.make(10)
			create dbQueryStatement.make("SELECT * FROM ProgrammingLanguage_User;", db)
			dbQueryStatement.execute(agent create_ProgrammingLanguageUser_Hash(?, 2, Result))
		end

	create_LanguageUser_Hash(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: HASH_TABLE[LINKED_SET[LANGUAGE], INTEGER]): BOOLEAN
		local
			i: NATURAL
			linset: LINKED_SET[LANGUAGE]
		do
			from i := 1
			until i > numColumns
			loop
				if resultobject.has (row.string_value (i+1).to_integer)
				then resultobject.at (row.string_value (i+1).to_integer).extend (languages.at (row.string_value (i).to_integer))
				else
					create linset.make
					linset.extend (languages.at (row.string_value (i).to_integer))
					resultobject.extend (linset, row.string_value (i+1).to_integer)
				end

				i := i + 2
			end
			Result := false
		end

	getLanguageUser: HASH_TABLE[LINKED_SET[LANGUAGE], INTEGER]
		do
			create Result.make(10)
			create dbQueryStatement.make("SELECT * FROM Language_User;", db)
			dbQueryStatement.execute(agent create_LanguageUser_Hash(?, 2, Result))
		end

feature
	getUserFromId(id: INTEGER): USER
	do
		create Result.make_default
		create dbQueryStatement.make ("SELECT * FROM User WHERE id=" + id.out + ";", db)
		dbQueryStatement.execute (agent genUser(?, 12, Result))
		if Result.getId = 0 then
			Result := Void
		end
	end

	getUserFromEmailPassword(email, password: STRING): USER
	do
		create Result.make_default
		create dbquerystatement.make ("SELECT * FROM User WHERE email='" + email + "' AND password='" + password + "';", db)
		dbquerystatement.execute (agent genUser(?, 12, Result))
		if Result.getId = 0 then
			Result := Void
		end
	end

	getUserFromEmailAndDOB (email : STRING; dateofbirth : INTEGER) : detachable USER
	do
		create Result.make_default
		create dbquerystatement.make ("SELECT * FROM User WHERE email='" + email + "' AND dateOfBirth=" + dateofbirth.out + ";", db)
		dbquerystatement.execute (agent genUser(?, 12, Result))
		if Result.getId = 0 then
			Result := Void
		end

	end

	getDevelopers: LINKED_SET[USER]
	do
		create Result.make
		create dbQueryStatement.make ("SELECT * FROM User WHERE userType=" + {USERTYPE}.developer.out + ";", db)
		dbquerystatement.execute (agent genUsers(?, 12, Result))
		if Result.count = 0
		then Result := Void
		end
	end

	getStakeholders: LINKED_SET[USER]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM User WHERE userType=" + {USERTYPE}.stakeholder.out + ";", db)
			dbquerystatement.execute (agent genUsers(?, 12, Result))
			if Result.count = 0
			then Result := Void
			end
		end

	insertUser(u: USER)
		local
			i, j: INTEGER
			rowId: INTEGER
			epoch: DATE_TIME
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create ec
			create epoch.make_from_epoch (0)
			create dbinsertstatement.make ("INSERT INTO User(firstname, lastname, sex, dateOfBirth, country, timezone, email, password, usertype, organization, deleted)" +
											 "VALUES ('" + u.getfirstname + "', '" + u.getlastname + "', '" + u.getsex.out +
											 "', '" + u.getdateofbirth.definite_duration (epoch).seconds_count.out + "', '" + u.getcountry + "', '" +
											 u.gettimezone + "', '" + u.getemail + "', '" + u.getpasswordhash + "', '" + u.getusertype.out + "', '" + u.getorganization +
											 "', '" + ec.bool_to_int (u.isdeleted).out + "');", db)
			dbinsertstatement.execute
			create dbquerystatement.make ("SELECT last_insert_rowid();", db)
			cursor := dbquerystatement.execute_new
			if not cursor.after then
				rowId := cursor.item.value(1).out.to_integer
			end

			if dbinsertstatement.has_error
			then print("Error while inserting a new user.%N")
			end

			if u.getusertype = {USERTYPE}.developer then
				from i := 1
				until i > programminglanguages.count
				loop
					from j := 1
					until j > u.getprogramminglanguages.count
					loop
						if programminglanguages.at (i).getid = u.getprogramminglanguages.at(j).getid
						then
							create dbinsertstatement.make ("INSERT INTO ProgrammingLanguage_User(programmingLanguage, user) VALUES ('" + programminglanguages.at (i).getid.out + "', '" +
												rowId.out + "');", db)
							dbinsertstatement.execute
							if dbinsertstatement.has_error
							then print("Error while inserting a new entry in ProgrammingLanguage_User.%N")
							end
						end
						j := j + 1
					end
					i := i + 1
				end
			end

			from i := 1
			until i > languages.count
			loop
				from j := 1
				until j > u.getlanguages.count
				loop
					if languages.at (i).getid = u.getlanguages.at(j).getid
					then
						create dbinsertstatement.make ("INSERT INTO Language_User(language, user) VALUES ('" + languages.at (i).getid.out + "', '" +
											rowId.out + "');", db)
						dbinsertstatement.execute
						if dbinsertstatement.has_error
						then print("Error while inserting a new entry in Language_User.%N")
						end
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	deleteUser(u: INTEGER)
		do
			-- First delete the user
			create dbmodifystatement.make ("BEGIN TRANSACTION; DELETE FROM User WHERE id=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting user.%N")
			end

			-- Then, delete Language_User and ProgrammingLanguage_User entries
			create dbmodifystatement.make ("DELETE FROM Language_User WHERE user=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting Language_User.%N")
			end

			create dbmodifystatement.make ("DELETE FROM ProgrammingLanguage_User WHERE user=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting ProgrammingLanguage_User.%N")
			end

			create dbmodifystatement.make ("DELETE FROM Chat_User WHERE user=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting Chat_User.%N")
			end

			create dbmodifystatement.make ("DELETE FROM Developer_Project WHERE developer=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting Developer_Project.%N")
			end

			create dbmodifystatement.make ("DELETE FROM Message WHERE user=" + u.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while deleting Message.%N")
			end

			create dbmodifystatement.make ("UPDATE Task SET developer=NULL WHERE developer=" + u.out + "; COMMIT;", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then log.severe("Error while updating tasks.%N")
			end


		end

	existsEmail(email: STRING): USER
		do
			create Result.make_default
			create dbquerystatement.make ("SELECT * FROM User WHERE email='" + email + "';", db)
			dbquerystatement.execute (agent genUser(?, 12, Result))
			if Result.getId = 0
			then
				Result := Void
			end
		end

	editUser(u: USER)
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbmodifystatement.make ("UPDATE User SET firstName='" + u.getfirstname + "', lastName='" +
				u.getlastname + "', sex='" + u.getsex.out + "', dateOfBirth='" + u.getdateofbirth.definite_duration (epoch).seconds_count.out +
				"', country='" + u.getcountry + "', timezone='" + u.gettimezone + "', email='" + u.getemail + "', password='" + u.getpasswordhash +
				"', userType='" + u.getusertype.out + "', organization='" + u.getorganization + "', deleted='" + u.isdeleted.to_integer.out + "' WHERE id=" + u.getid.out + ";", db)

			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while updating user.")
			end
		end

	getDevelopersFromProjectId(p: INTEGER): LINKED_SET[USER]
		do
			create Result.make
			create dbquerystatement.make ("SELECT id, firstname, lastname, sex, dateOfBirth, country, timezone, email, password, userType, organization, deleted" +
											" FROM User JOIN Developer_Project ON User.id = Developer_Project.developer WHERE project=" + p.out + ";", db)
			dbquerystatement.execute (agent genUsers(?, 12, Result))
			if Result.count = 0
			then Result := Void
			end

		end

	getStatistics : LINKED_LIST[STAT_ENTRY]
	do
		create Result.make
		create dbquerystatement.make ("SELECT developer, SUM(points) AS s FROM Task WHERE state=1 GROUP BY developer ORDER BY s DESC;", db)
		dbquerystatement.execute (agent genStats(?, 2, Result))
	end

	getStatisticsFromUserProject(userid : INTEGER; projid : INTEGER) : INTEGER
	require
		userid > 0
		projid > 0
	local
		cursor : SQLITE_STATEMENT_ITERATION_CURSOR
	do
		Result := 0
		create dbquerystatement.make ("SELECT SUM(points) AS s FROM Task AS t INNER JOIN (PBI AS p INNER JOIN Backlog AS b ON p.backlog = b.id) ON t.pbi = p.id WHERE state=1 AND t.developer="+userid.out+" AND b.project="+projid.out+";", db)
		cursor := dbquerystatement.execute_new
		if not cursor.after and attached cursor.item.value(1) then
			Result := cursor.item.value(1).out.to_integer
		end
	end

	getUsersFromChatId(chatid: INTEGER): LINKED_SET[USER]
		do
			create Result.make
			create dbquerystatement.make ("SELECT id, firstname, lastname, sex, dateOfBirth, country, timezone, email, password, userType, organization, deleted " +
											"FROM User JOIN Chat_User ON User.id = Chat_User.user WHERE chat=" + chatId.out + ";", db)
			dbquerystatement.execute (agent genUsers (?, 12, Result))
			if Result.count = 0
			then Result := Void
			end
		end
	isManagerOfProjects(a : INTEGER) : BOOLEAN
	local
		cursor : SQLITE_STATEMENT_ITERATION_CURSOR
	do
		create ec
		Result := FALSE
		create dbQueryStatement.make ("SELECT COUNT(*) FROM Project WHERE manager=" +a.out + ";", db)
		cursor := dbquerystatement.execute_new
		if not cursor.after and attached cursor.item.value(1) then
			Result := ec.int_to_bool (cursor.item.value(1).out.to_integer)
		end

	end

end
