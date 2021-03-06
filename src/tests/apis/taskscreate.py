import http.client
import json, login

from suite_functions import check_reply

params = """{
"name" : "A created task!",
"description" : "A description for this task!",
"points" : 102,
"developer" : 1,
"state" : "ongoing",
"pbi" : 5,
"completionDate" : 2134565
}""";

expected_response = json.loads("""
{"status":"ok"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/1/pbis/2/createtask", params, headers)

    return check_reply(conn, expected_response, debug)
