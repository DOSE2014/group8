import http.client
import json, login

from suite_functions import check_reply

params = "";

expected_response = json.loads("""
{"developers":[{"id":1,"firstname":"Filippo","lastname":"Pagano"},{"id":2,"firstname":"Cicco","lastname":"Bombo"},{"id":6,"firstname":"Test","lastname":"Developer"},{"id":7,"firstname":"Will Dev","lastname":"Aguilera"},{"id":10,"firstname":"Federico","lastname":"Reghenzani"}]}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/account/listdevelopers", params, headers)

    return check_reply(conn, expected_response, debug)
