import http.client
import json

params = """
{
    "email" : "federico1.reghenzani@mail.polimi.it",
    "password" : "' OR '1'='1"
}
""";

expected_response = json.loads("""{"status":"error"}""");

cookie_id = ""

def exec_test(debug=False):
    global cookie_id

    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/account/login", params, headers)
    response = conn.getresponse()

    if debug:
        print("")
        print("\tREPLY HTTP STATUS: ", response.status)
        print("\tHEADERS:")
    headers = response.getheaders()
    
    for h in headers:
        if debug:
            print("\t\t"+h[0]+": "+h[1])
        if h[0] == "Set-Cookie":
            where = int(h[1].find("_pdt_session_id_="))
            where2 = int(h[1].find(";"))
            cookie_id = h[1][where+17:where2]

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
