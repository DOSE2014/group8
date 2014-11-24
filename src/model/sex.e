class
	SEX
	
feature
	male : INTEGER = 1
	female : INTEGER = 0

frozen to_string(i : INTEGER) : STRING
	once
		if i = male then
			Result := "M"
		else
			Result := "F"
		end
	end
end
