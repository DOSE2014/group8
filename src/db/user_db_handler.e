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
	dbInserStatement: SQLITE_INSERT_STATEMENT
	dbModifyStatement: SQLITE_MODIFY_STATEMENT

feature
	make(s: SQLITE_DATABASE)
		do
			db := s
		end

feature
	getUsers: USER[]
		do
		end
	getUser(id: INTEGER)
		do
		end
	addUser(id: INTEGER;
			firstName, lastName: STRING; sex: SEX; dateOfBirth: DATE;
			country, timezone, email, password: STRING;
			userType: USERTYPE; organization: STRING; programmingLanguages: STRING[])
		do
		end
	deleteUser(id: INTEGER)
		do
		end
end
