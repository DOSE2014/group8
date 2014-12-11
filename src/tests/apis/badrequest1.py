import http.client
import json, login

from suite_functions import check_reply

params = """{
"id" ::""/
}""";

expected_response = json.loads("""
{"status":"error", "reason":"JSON request malformed"}
""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/projects/create", params, headers)
    
    if not check_reply(conn, expected_response, debug):
        return False

    conn.request("POST", "/projects/1/adddeveloper", params, headers)

    if not check_reply(conn, expected_response, debug):
        return False
        
    conn.request("POST", "/projects/1/remdeveloper", params, headers)

    if not check_reply(conn, expected_response, debug):
        return False
        
    conn.request("POST", "/projects/1/edit", params, headers)

    if not check_reply(conn, expected_response, debug):
        return False

    conn.request("POST", "/projects/1/pbis/create", params, headers)

    if not check_reply(conn, expected_response, debug):
        return False


    return True
