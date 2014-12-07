note
	description: "{MESSAGE} is the message class. A message is charaterized by id, user sending a message, date of the message, chat to which it belongs and a message content."
	author: "Filippo"
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

create
	make, make_default


feature{NONE}
	id: INTEGER
	user : USER
	date : DATE_TIME
	chat : CHAT
	content : STRING

feature
	make (i : INTEGER; u : USER; d : DATE_TIME; c : CHAT; cont : STRING)
	do
		id :=i
		user:=u
		date:= d
		chat:= c
		content:=cont
	end
	make_default
		do

		end
feature
	getId: INTEGER
		do
			Result:= id
		end
	setId(i: INTEGER)
		do
			id:=i
		end
	getUser : USER
		do
			Result:= user
		end
	setUser( u : USER)
		do
			user := u
		end
	getDate : DATE_TIME
		do
			Result := date
		end
	setDate (d : DATE_TIME )
	do
		date := d
	end
	getChat : CHAT
	do
		Result:= chat
	end
	setChat (c : CHAT)
	do
		chat:= c
	end
	getContent : STRING
	do
		Result:= content
	end
	setContent ( cont : STRING )
	do
		content := cont
	end

	to_json: JSON_OBJECT
		require
			getId /= 0
		local
			epoch: DATE_TIME
		do
			create epoch.make_from_epoch(0)
			create Result.make
			Result.put_integer(id, "id")
			Result.put_string(user.getfirstname.out + " " + user.getLastName, "user")
			Result.put_integer(date.definite_duration(epoch).seconds_count, "date")
			Result.put_integer(chat.getId, "chat")
			Result.put_string(content, "content")
		end
end
