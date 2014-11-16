note
	description: "Summary description for {LOG_SINGLETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOG_SINGLETON

feature

	deb(s : STRING)
	-- DEBUG MESSAGE
	require
		s /= Void
	local
		t : TIME
	do
		create t.make_now
		debug("_DEBUG_MSG_")
			-- Check project settings to enable this
			print("["+t.out+"] [DEBUG]: "+s+"%N")
		end
	end


	info(s : STRING)
	require
		s /= Void
	local
		t : TIME
	do
		create t.make_now
		print("["+t.out+"] [INFO]: "+s+"%N")
	end


	warning(s : STRING)
	require
		s /= Void
	local
		t : TIME
	do
		create t.make_now
		print("["+t.out+"] [WARNING]: "+s+"%N")
	end

	severe(s : STRING)
	require
		s /= Void
	local
		t : TIME
	do
		create t.make_now
		print("["+t.out+"] [SEVERE]: "+s+"%N")
	end


end
