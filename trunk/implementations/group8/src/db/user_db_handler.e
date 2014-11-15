note
	description: "Summary description for {USER_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	dbInsertStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

	--Data taken from DB and kept in memory throughout the execution for simplicity, shouldn't change in runtime
	programmingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
	languages: LINKED_SET[LANGUAGE]

	--Data updated everytime a user is taken from DB
	programmingLanguageUser_Hash: HASH_TABLE[LINKED_SET[PROGRAMMING_LANGUAGE], INTEGER]
	languageUser_Hash: HASH_TABLE[LINKED_SET[LANGUAGE], INTEGER]

feature
	make(s: SQLITE_DATABASE)
		do
			db := s
			programminglanguages := getprogramminglanguages
			languages := getlanguages
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

			resultobject.setorganization (row.string_value (11))

			programmingLanguageUser_Hash := getprogrammingLanguageUser
			languageUser_Hash := getLanguageUser
			resultobject.setprogramminglanguages (programminglanguageuser_hash.at (resultobject.getid))
			resultobject.setlanguages (languageuser_hash.at (resultobject.getid))

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
			create dbQueryStatement.make("SELECT * FROM ProgrammingLanguage_User", db)
			dbQueryStatement.execute(agent create_ProgrammingLanguageUser_Hash(?, 2, Result))
		end

	create_ProgrammingLanguage_Set(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: LINKED_SET[PROGRAMMING_LANGUAGE]): BOOLEAN
		local
			i: NATURAL
			proglan: PROGRAMMING_LANGUAGE
		do
			from i := 1
			until i > numColumns
			loop
				create proglan.make(row.string_value (i).to_integer_32, row.string_value (i+1))
				resultObject.extend (proglan)
				i := i + 2
			end
			Result := false
		end

	getProgrammingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM ProgrammingLanguage", db)
			dbQueryStatement.execute (agent create_ProgrammingLanguage_Set(?, 2, Result))
		end

	create_Language_Set(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultObject: LINKED_SET[LANGUAGE]): BOOLEAN
		local
			i: NATURAL
			lan: LANGUAGE
		do
			from i := 1
			until i > numColumns
			loop
				create lan.make(row.string_value (i).to_integer_32, row.string_value (i+1))
				resultObject.extend (lan)
				i := i + 2
			end
			Result := false
		end

	getLanguages: LINKED_SET[LANGUAGE]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM Language", db)
			dbQueryStatement.execute (agent create_Language_Set(?, 2, Result))
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
			create dbQueryStatement.make("SELECT * FROM Language_User", db)
			dbQueryStatement.execute(agent create_LanguageUser_Hash(?, 2, Result))
		end

feature
	getUser(id: INTEGER): USER
		do
			create Result.make_default
			create dbQueryStatement.make ("SELECT * FROM User WHERE id=" + id.out + ";", db)
			dbQueryStatement.execute (agent genUser(?, 11, Result))
		end

	insertUser(u: USER)
		local
			i, j: INTEGER
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch (0)
			create dbinsertstatement.make ("INSERT INTO User(id, firstname, lastname, sex, dateOfBirth, country, timezone, email, password, usertype, organization)" +
											 "VALUES ('" + u.getid.out + "', '" + u.getfirstname + "', '" + u.getlastname + "', '" + u.getsex.out +
											 "', '" + u.getdateofbirth.definite_duration (epoch).seconds_count.out + "', '" + u.getcountry + "', '" +
											 u.gettimezone + "', '" + u.getemail + "', '" + u.getpasswordhash + "', '" + u.getusertype.out + "', '" + u.getorganization +
											 "');", db)
			dbinsertstatement.execute
			if dbinsertstatement.has_error
			then print("Error while inserting a new user.%N")
			end

			from i := 1
			until i > programminglanguages.count
			loop
				from j := 1
				until j > u.getprogramminglanguages.count
				loop
					if programminglanguages.at (i).getid = u.getprogramminglanguages.at(j).getid
					then
						create dbinsertstatement.make ("INSERT INTO ProgrammingLanguage_User(programmingLanguage, user) VALUES ('" + programminglanguages.at (i).getid.out + "', '" +
											u.getid.out + "');", db)
						dbinsertstatement.execute
						if dbinsertstatement.has_error
						then print("Error while inserting a new entry in ProgrammingLanguage_User.%N")
						end
					end
					j := j + 1
				end
				i := i + 1
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
											u.getid.out + "');", db)
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

	deleteUser(u: USER)
		do
			create dbmodifystatement.make ("DELETE FROM User WHERE id=" + u.getid.out + ";", db)
			dbmodifystatement.execute
			if dbmodifystatement.has_error
			then print("Error while deleting user.%N")
			end

			--TODO Delete entries from Language_User, ProgrammingLanguage_User?
		end
end
