import http.client
import json, login

from suite_functions import check_reply

params = "";

expected_response = json.loads("""
{"projects":[{"id":1,"name":"DOSE","description":"Create DOSE software","manager":2,"stakeholder":3,"creationDate":1415555014,"deleted":false,"developers":[1]}]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/list", params, headers)

    return check_reply(conn, expected_response, debug)
