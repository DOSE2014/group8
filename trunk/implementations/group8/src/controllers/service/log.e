note
	description: "Summary description for {LOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOG

feature{NONE}
	l : LOG_SINGLETON

feature{ANY}
frozen	log : LOG_SINGLETON once
		create Result
	end

end
