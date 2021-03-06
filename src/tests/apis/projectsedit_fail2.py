import http.client
import json, login

from suite_functions import check_reply

params = """{
"name" : "Test 2",
"description" : "ooook",
"manager" : 2
}""";

expected_response = json.loads("""
{"status":"error","code":1,"reason":"Project doesn't exist."}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/23652/edit", params, headers)

    return check_reply(conn, expected_response, debug)
