import http.client
import json, login

from suite_functions import check_reply

params = """{

"name" : "test",
"description" : "test text",
"startDate" : 1404338400000,
"endDate" : 1418338800000

}""";

expected_response = json.loads("""
{"status":"error","reason":"PBI not present or not correct.","field":"idpbis"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/1/sprintlogs/create", params, headers)

    return check_reply(conn, expected_response, debug)
