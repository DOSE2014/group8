class
	USERTYPE

feature
	developer: INTEGER = 1
	stakeholder: INTEGER = 0

frozen to_string(i : INTEGER) : STRING
	once
		if i = developer then
			Result := "developer"
		else
			Result := "stakeholder"
		end
	end

end
