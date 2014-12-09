class
	PBITYPE
feature
	requirement: INTEGER = 1
	nonFunctionalRequirement: INTEGER = 2
	bugFix: INTEGER = 3

feature
frozen	to_integer(s : STRING) : INTEGER
	require
		is_valid(s)
	do
		if s = "requirement" then Result := requirement end
		if s = "nonFunctionalRequirement" then Result := nonFunctionalRequirement end
		if s = "bugFix" then Result := bugFix end
	end

    is_valid(s : STRING) : BOOLEAN
	do
		Result := s.is_equal ("requirement")  or s.is_equal ("nonFunctionalRequirement") or s.is_equal ("bugFix")
	end
end
