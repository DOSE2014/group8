import http.client
import json, login

from suite_functions import check_reply

params = """{

"name" : "PBI Test",
"description" : "Questa e una prova",
"type" : "requirement",
"priority" : 20,
"dueDate" : 1852495723

}""";

expected_response = json.loads("""
{"developers": [{"id": 1, "lastname": "Pagano", "firstname": "Filippo"}, 
{"id": 2, "lastname": "Reghenzani", "firstname": "Federico"}, {"id": 5, 
"lastname": "Reghenzani", "firstname": "Federico"}]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/1/pbis/create", params, headers)

    return check_reply(conn, expected_response, debug)
