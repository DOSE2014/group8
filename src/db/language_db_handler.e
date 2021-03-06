note
	description: "Summary description for {LANGUAGE_DB_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LANGUAGE_DB_HANDLER

create
	make

feature{NONE}
	db: SQLITE_DATABASE
	dbQueryStatement: SQLITE_QUERY_STATEMENT
	languages: LINKED_SET[LANGUAGE]

feature
	make(s: SQLITE_DATABASE)
		do
			db := s
			languages := getLanguagesFromDB
		end

feature
	getLanguages: LINKED_SET[LANGUAGE]
		do
			Result := languages
		end

feature{NONE}
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

	getLanguagesFromDB: LINKED_SET[LANGUAGE]
		do
			create Result.make
			create dbQueryStatement.make ("SELECT * FROM Language;", db)
			dbQueryStatement.execute (agent create_Language_Set(?, 2, Result))
		end

end
