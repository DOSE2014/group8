import http.client
import json, login_sh

from suite_functions import check_reply

# ERROR USER 3 IS A STAKEHOLDER!

params = """{
"name" : "Test Project New",
"description" : "Qu3st4 3 un4 pr0v4",
"manager" : 3
}""";

expected_response = json.loads("""
{
    "status":"error",
    "reason" : "The stakeholder that creates the project cannot be manager."
}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login_sh.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/create", params, headers)

    return check_reply(conn, expected_response, debug)
