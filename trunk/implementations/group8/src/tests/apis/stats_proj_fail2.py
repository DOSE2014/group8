import http.client
import json, login

from suite_functions import check_reply

params = """{
}""";

expected_response = json.loads("""
{"points":0}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/stats/projpoints?idproj=1&iddev=22346", params, headers)

    return check_reply(conn, expected_response, debug)
