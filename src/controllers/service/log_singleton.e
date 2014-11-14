note
	description: "Summary description for {LOG_SINGLETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOG_SINGLETON

feature

	warning(s : STRING)
	do
		print(s)
	end

end
