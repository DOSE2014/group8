note
	description: "Summary description for {REST_CHAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REST_CHAT

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
	getChatFromProjectId(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			chat: CHAT
			j_chat: JSON_OBJECT
			j_messages: JSON_ARRAY
			j_users: JSON_ARRAY
			messages: LINKED_SET[MESSAGE]
			idProj: INTEGER
			u: USER
			project: PROJECT
			j_error: JSON_OBJECT
			users: LINKED_SET[USER]
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)

			if ensure_authenticated then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/chat/{idproj}/getchat [GET] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/chat/" + idProj.out + "/getchat [GET] Project not existent.")
					else
						chat := db.getchatfromProjectid(idProj)
						messages := db.getmessagesfromchatid (chat.getid)
						users := db.getusersfromchatid (chat.getid)

						if attached chat then
							j_chat := chat.to_json
							if attached users then
								create j_users.make_array
								across users as usr
								loop
									j_users.add (usr.item.to_minimal_json)
								end
								j_chat.put (j_users, "users")
								if attached messages then
									create j_messages.make_array
									across messages as msg
									loop
										j_messages.add (msg.item.to_json)
									end
									j_chat.put (j_messages, "messages")
									send_json (hres, j_chat)
								else
									j_chat.put_integer (-1, "messages")
									send_json (hres, j_chat)
								end
							else
								j_chat.put_integer (-1, "users")
								send_json (hres, j_chat)
							end
						else
							create j_error.make
							j_error.put_string("error", "status")
							j_error.put_string("no", "chat")
						end
					end
				end
			end
		end

	insertMessage(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			u: USER
			project: PROJECT
			idProj: INTEGER
			chat: CHAT
			param_content: STRING
			date: DATE_TIME
			message: MESSAGE
		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)

			if ensure_authenticated and hp.is_good_request then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/chat/{idproj}/insertmessage [POST] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/chat/" + idproj.out + "/insertmessage [POST] Project not existent.")
					else
						param_content := hp.post_param ("content")
						create date.make_now
						chat := db.getchatfromprojectid (idproj)

						create message.make (0, u, date, chat, param_content)
						message.setid (db.insertmessage (message))
						log.info ("/chat/" + idProj.out + "/insertmessage [POST] Inserted message.")
						send_generic_ok (hres)
					end
				end
			end
		end

	addUserInChat(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			u: USER
			user: USER
			project: PROJECT
			manager: USER
			idProj: INTEGER
			param_user: INTEGER
			chat: CHAT
		do
			http_request := hreq
			http_response := hres
			create hp.make (hreq)
			if ensure_authenticated and hp.is_good_request then
				u := get_session_user
					if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/chat/{idproj}/adduser [POST] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/chat/" + idproj.out + "/adduser [POST] Project not existent.")
					else
						manager := project.getmanager
						if u.getid /= manager.getid then
							no_permission
						else

							param_user := hp.post_int_param("user")
							user := db.getuserfromid (param_user)
							if attached user then
								db.adduserinchat(user, chat)
								log.info ("/chat/" + idProj.out + "/adduser [POST] Added user.")
								send_generic_ok (hres)
							end
						end
					end
				end
			end
		end

	deleteUserInChat(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			u: USER
			user: USER
			project: PROJECT
			manager: USER
			idProj: INTEGER
			param_user: INTEGER
			chat: CHAT
		do
			http_request := hreq
			http_response := hres
				create hp.make (hreq)
				if ensure_authenticated and hp.is_good_request then
				u := get_session_user
					if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/chat/{idproj}/deleteuser [POST] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/chat/" + idproj.out + "/deleteuser [POST] Project not existent.")
					else
						manager := project.getmanager
						if u.getid /= manager.getid then
							no_permission
						else
							param_user := hp.post_int_param("user")
							user := db.getuserfromid (param_user)
							if attached user then
								db.deleteuserinchat(user, chat)
								log.info ("/chat/" + idProj.out + "/deleteuser [POST] Deleted user.")
								send_generic_ok (hres)
							end
						end
					end
				end
			end
		end

	polling(hreq: WSF_REQUEST; hres: WSF_RESPONSE)
		require
			hreq /= Void
			hres /= Void
		local
			hp: HTTP_PARSER
			chatId: INTEGER
			j_messages: JSON_ARRAY
			messages: LINKED_SET[MESSAGE]
			idProj: INTEGER
			u: USER
			project: PROJECT
			j_error: JSON_OBJECT
			lastMessageId: INTEGER
			j_result: JSON_OBJECT

		do
			http_request := hreq
			http_response := hres

			create hp.make (hreq)

			if ensure_authenticated then
				u := get_session_user

				if not attached hp.path_param("idproj")
				then
					send_malformed_json(http_response)
					-- And logs it
					log.warning ("/chat{idproj}/polling [GET] Missing idproj in URL.")
				else
					idProj := hp.path_param ("idproj").to_integer
					project := db.getprojectfromid (idProj)
					if not attached project
					then	-- does project exist?
						send_malformed_json(http_response)
						-- And logs it
						log.warning ("/chat/" + idProj.out + "/polling [GET] Project not existent.")
					else
						chatId := hp.get_param ("chatid").to_integer
						lastMessageId := hp.get_param ("lastmessageid").to_integer

						if attached chatId and attached lastmessageid then
							messages := db.getNewMessages(chatId, lastMessageId)
							if attached messages then
								create j_messages.make_array
								across messages as msg
								loop
									j_messages.add (msg.item.to_json)
								end
								create j_result.make
								j_result.put(j_messages, "messages")
								send_json (hres, j_result)
							else
								create j_result.make
								j_result.put_integer(-1, "messages")
								send_json (hres, j_result)
							end
						else
							create j_error.make
							j_error.put_string("error", "status")
							j_error.put_string("no", "chatId")
						end
					end
				end
			end

		end

end


