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

			programmingLanguageUser_Hash := getprogrammingLanguageUser
			languageUser_Hash := getLanguageUser
			resultobject.setprogramminglanguages (programminglanguageuser_hash.at (resultobject.getid))
			resultobject.setlanguages (languageuser_hash.at (resultobject.getid))
			Result := false
		end

	genDevelopers(row: SQLITE_RESULT_ROW; numColumns: NATURAL; resultobject: LINKED_SET[USER]): BOOLEAN
		local
			i: NATURAL
			u: USER
			d: DATE_TIME
		do
			from i := 1
			until i > row.count
			loop
				create u.make_default
				u.setid (row.string_value (i).to_integer)
				u.setfirstname (row.string_value (i + 1))
				u.setlastname (row.string_value (i + 2))

				if row.string_value (i + 3).to_integer = {SEX}.male
				then u.setsex ({SEX}.male)
				else u.setsex ({SEX}.female)
				end

				create d.make_from_epoch (row.string_value (i + 4).to_integer)
				u.setdateofbirth (d)

				u.setcountry (row.string_value (i + 5))
				u.settimezone (row.string_value (i + 6))
				u.setemail (row.string_value (i + 7))
				u.setpassword (row.string_value (i + 8))

				if row.string_value (i + 9).to_integer = {USERTYPE}.developer
				then u.setusertype({USERTYPE}.developer)
				else u.setusertype({USERTYPE}.stakeholder)
				end

				if not row.is_null(i + 10) then
					u.setorganization (row.string_value (i + 10))
				else
					u.setorganization (Void)
				end

				programmingLanguageUser_Hash := getprogrammingLanguageUser
				languageUser_Hash := getLanguageUser
				u.setprogramminglanguages (programminglanguageuser_hash.at (u.getid))
				u.setlanguages (languageuser_hash.at (u.getid))

				resultobject.extend (u)
				i := i + 11
			end
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
			dbQueryStatement.execute (agent genUser(?, 11, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	getUserFromEmailPassword(email, password: STRING): USER
		do
			create Result.make_default
			create dbquerystatement.make ("SELECT * FROM User WHERE email='" + email + "' AND password='" + password + "';", db)
			dbquerystatement.execute (agent genUser(?, 11, Result))
			if Result.getId = 0 then
				Result := Void
			end
		end

	getDevelopers: LINKED_SET[USER]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM User WHERE userType=" + {USERTYPE}.developer.out + ";", db)
			dbquerystatement.execute (agent genDevelopers(?, 11, Result))
			if Result.count = 0
			then Result := Void
			end
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
