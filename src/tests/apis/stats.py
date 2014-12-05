import http.client
import json, login

from suite_functions import check_reply

params = """{
}""";

expected_response = json.loads("""
{"stats":[{"dev":2,"points":33},{"dev":1,"points":1}]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/stats/devpoints", params, headers)

    return check_reply(conn, expected_response, debug)
