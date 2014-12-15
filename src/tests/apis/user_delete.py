import http.client
import json, login_sh

from suite_functions import check_reply

params = """
""";

expected_response = json.loads("""
{"status":"ok"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login_sh.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/account/delete", params, headers)

    return check_reply(conn, expected_response, debug)
