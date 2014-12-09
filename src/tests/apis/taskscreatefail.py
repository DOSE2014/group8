import http.client
import json, login

from suite_functions import check_reply

params = """{
"name" : "A created task!",
"description" : "A description for this task!",
"points" : 102,
"state" : "ongoing",
"pbi" : 5
}""";

expected_response = json.loads("""
{"status":"error","reason":"Developer not exists or not in the project.","field":"developer"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/1/pbis/2/createtask", params, headers)

    return check_reply(conn, expected_response, debug)
