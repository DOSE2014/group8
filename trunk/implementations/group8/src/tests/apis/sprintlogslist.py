import http.client
import json, login

from suite_functions import check_reply

params = "";

expected_response = json.loads("""
{"sprintlogs":[{"id":1,"name":"Chat","description":"Lets make a chat","startDate":1415555293,"endDate":1415575293},{"id":2,"name":"Prototype","description":"Tuesday, November 25th – 8 am (CET)v","startDate":1415689214,"endDate":1416898814}]}

""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/1/sprintlogs/list", params, headers)

    return check_reply(conn, expected_response, debug)
