import http.client
import json, login

from suite_functions import check_reply

params = """{
}""";

expected_response = json.loads("""
{"pbis":[2,10,12,15,16]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/1/sprintlogs/1/listpbis", params, headers)

    return check_reply(conn, expected_response, debug)
