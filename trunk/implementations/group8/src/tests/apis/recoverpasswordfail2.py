import http.client
import json, login

from suite_functions import check_reply

params = """{
"email" : "federico1.reghenzani@mail.polimi.it",
"dateOfBirth" : 100
}""";

expected_response = json.loads("""
{"status":"error", "reason": "Email and/or DateOfBirth not valid."}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/account/recoverpassword", params, headers)

    return check_reply(conn, expected_response, debug)
