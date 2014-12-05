import http.client
import json, login_sh

from suite_functions import check_reply

params = """{
"name" : "7es7 pr0j3c7",
"description" : "Qu3st4 3 un4 pr0v4",
"manager" : 2
}""";

expected_response = json.loads("""
{"status":"created", "id":2}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login_sh.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/create", params, headers)

    return check_reply(conn, expected_response, debug)
