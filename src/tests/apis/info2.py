import http.client
import json, login

params = "";

expected_response = json.loads("""

{"id":1,"firstname":"Filippo","lastname":"Pagano","sex":"M","dateOfBirth":712022400,"country":"Italy","timezone":"Europe/Rome","userType":"developer","email":"paganofilippo@gmail.com","programmingLanguages":["Eiffel"],"languages":["Italian","English"]}

""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/account/userinfo?id=1", params, headers)
    response = conn.getresponse()

    if debug:
        print("")
        print("\tREPLY HTTP STATUS: ", response.status)
        print("\tHEADERS:")
        headers = response.getheaders()
    
        for h in headers:
            print("\t\t"+h[0]+": "+h[1])

    data = response.read()
        
    if debug:
        print("\t-DATA-")
        print(data.decode('utf-8'))
        print("\t-END DATA-")
        print("\tEXPECTED: " + json.dumps(expected_response) )
    conn.close()

    if json.loads(data.decode('utf-8')) == expected_response:
        return True
    else:
        return False
