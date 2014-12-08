import http.client
import json, login

from suite_functions import check_reply

params = """{
}""";

expected_response = json.loads("""
{"pbis":[2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/1/sprintlogs/1/listpbis", params, headers)

    return check_reply(conn, expected_response, debug)
