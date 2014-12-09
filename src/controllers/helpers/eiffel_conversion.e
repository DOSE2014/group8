note
	description: "This is an absurd and useless class to provide to Eiffel language a casting system."
	author: "Milan3"
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_CONVERSION

feature

	any_to_int(var : ANY) : INTEGER
	do
		if attached {INTEGER} var as conversion then
			Result := conversion
		else
			Result := 0
		end
	end

	any_to_string(var : ANY) : STRING
	do
		if attached {STRING} var as conversion then
			Result := conversion
		else
			Result := ""
		end
	end

	any_to_user(var : ANY) : USER
	do
		if attached {USER} var as conversion then
			Result := conversion
		else
			Result := Void
		end
	end

	any_to_wsf_string(var : ANY) : WSF_STRING
	do
		if attached {WSF_STRING} var as conversion then
			Result := conversion
		-- else -- This is not compiling -_-
		--	Result := ""
		end
	end
	bool_to_int(b:BOOLEAN): INTEGER
	do
		if b then
			Result:=1
		else
			Result:=0
		end
	end

	int_to_bool(i:INTEGER):BOOLEAN
	do
		if i=0 then
			Result:=false
		else
			Result:=true
		end
	end
end
