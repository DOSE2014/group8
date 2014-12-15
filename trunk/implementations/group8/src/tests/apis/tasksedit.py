import http.client
import json, login

from suite_functions import check_reply

params = """{
"name" : "A created task",
"description" : "A description for this edited task",
"points" : 34,
"developer" : 1,
"state" : "completed"
}""";

expected_response = json.loads("""
{"status":"ok"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/1/tasks/5/edit", params, headers)

    return check_reply(conn, expected_response, debug)
