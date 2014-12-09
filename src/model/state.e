class
	STATE

feature
	ongoing   : INTEGER = 0
	completed : INTEGER = 1
	awaiting  : INTEGER = 2

frozen	to_integer(s : STRING) : INTEGER
	require
		is_valid(s)
	do
		if s = "ongoing" then Result := ongoing end
		if s = "completed" then Result := completed end
		if s = "awaiting" then Result := awaiting end
	end

	frozen to_string(i : INTEGER) : STRING
	do
		if i = 0 then Result := "ongoing" end
		if i = 1 then Result := "completed" end
		if i = 2 then Result := "awaiting" end
	end

    is_valid(s : STRING) : BOOLEAN
	do
		Result := s.is_equal ("ongoing")  or s.is_equal ("completed") or s.is_equal ("awaiting")
	end
end
