note
	description: "Summary description for {PROGRAMMING_LANGUAGE_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROGRAMMING_LANGUAGE_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	programmingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]

feature
	make(s: SQLITE_DATABASE)
		do
			db := s
			programmingLanguages := getProgrammingLanguagesFromDB
		end

feature
	getProgrammingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			Result := programmingLanguages
		end

feature{NONE}
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

	getProgrammingLanguagesFromDB: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM ProgrammingLanguage;", db)
			dbQueryStatement.execute (agent create_ProgrammingLanguage_Set(?, 2, Result))
		end
end
