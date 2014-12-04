import http.client
import json, login

from suite_functions import check_reply

params = """
{}
""";

expected_response = json.loads("""
{
"tasks":
[
	{"id":2,
	 "name":"Second test task",
	 "description":"BLablabla",
	 "points":23,
	 "developer":2,
	 "state":"Completed",
	 "pbi":2
	},
	{"id":3,
	 "name":"Another test",
	 "description":"Blablablabla",
	 "points":10,
         "developer":2,
         "state":"Completed",
         "pbi":2
       }
]
}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/1/pbis/2/listtasks", params, headers)

    return check_reply(conn, expected_response, debug)
