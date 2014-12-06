note
	description: "Summary description for {REST_STATS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_STATS

inherit
	AUTHENTICATION
	HTTP_FUNCTIONS
	LOG

create
	make

feature {NONE}	-- Constructors
	make(sm : WSF_SESSION_MANAGER; pdt_db : PDT_DB)
	require
		sm /= Void
		pdt_db /= Void
	do
		session_manager := sm
		db := pdt_db
	end

feature{NONE}  -- Private properies
	db : PDT_DB

feature -- declaring deferred properties
	session_manager : WSF_SESSION_MANAGER
	http_request : WSF_REQUEST
	http_response : WSF_RESPONSE

feature

	devpoints(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /stats/devpoint
	-- METHOD: GET
	local
		ls : LINKED_LIST[STAT_ENTRY]
		ls_json : JSON_ARRAY
		json_object : JSON_OBJECT
		json_response : JSON_OBJECT
	do
		http_request  := hreq
		http_response := hres

		if ensure_authenticated then
			ls := db.getStatistics
			create ls_json.make_array

			if attached ls then
				across ls as stat_entry
				loop
					create json_object.make
					json_object.put_integer (stat_entry.item.getUserId, "dev")
					json_object.put_integer (stat_entry.item.getPoints, "points")
					ls_json.extend (json_object)
				end
			end

			create json_response.make
			json_response.put (ls_json, "stats")
			send_json(hres, json_response)
		end
	end

	projpoints(hreq : WSF_REQUEST; hres : WSF_RESPONSE)
	-- PATH: /stats/devpoint
	-- METHOD: GET
	-- This method returns points of a specified pair developer-project
	local
		id_proj_str : STRING
		id_dev_str  : STRING
		hp : HTTP_PARSER
		ok : BOOLEAN
		points : INTEGER
		json_response : JSON_OBJECT
	do
		http_request  := hreq
		http_response := hres

		create hp.make (hreq)

		if ensure_authenticated then
			id_proj_str := hp.get_param ("idproj")
			id_dev_str  := hp.get_param ("iddev")

			ok := TRUE
			if ok and (not attached id_proj_str or not id_proj_str.is_integer) then
				send_generic_error ("idproj not found or not integer.", hres)
				ok := FALSE
			end
			if ok and (not attached id_dev_str or not id_dev_str.is_integer) then
				send_generic_error ("id_dev not found or not integer.", hres)
				ok := FALSE
			end

			if ok then
				points := db.getstatisticsfromuserproject (id_dev_str.to_integer, id_proj_str.to_integer)

				-- ls is always a list with only one item
				create json_response.make
				json_response.put_integer (points, "points")
				send_json(hres, json_response)
			end

		end
	end

end
