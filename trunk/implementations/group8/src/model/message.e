note
	description: "{MESSAGE} is the message class. A message is charaterized by id, user sending a message, date of the message, chat to which it belongs and a message content."
	author: "Filippo"
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

create
	make


feature{NONE}
	id: INTEGER
	user : USER
	date : DATE
	chat : CHAT
	content : STRING

feature
	make (i : INTEGER; u : USER; d : DATE; c : CHAT; cont : STRING)
	do
		id :=i
		user:=u
		date:= d
		chat:= c
		content:=cont
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
	getDate : DATE
		do
			Result := date
		end
	setDate (d : DATE )
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
end
