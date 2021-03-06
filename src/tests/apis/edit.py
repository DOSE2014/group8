import http.client
import json
import login

params = """
{
    "id"    : 2,
    "email" : "ciccio@bombo.it",
    "firstname" : "Cicco",
    "lastname" : "Bombo",
    "country" : "Italy",
    "sex" : "M",
    "timezone" : "Europe/Rome",
    "type" : "developer",
    "password" : "nonteladico",
    "dateOfBirth" : "1248757",
    "organization" : "Politecnico di Milano",
    "languages" : [ "Italian", "English" ],
    "programmingLanguages" : [ "C++", "PHP"] 
}
""";

expected_response = json.loads("""{"status":"ok"}""");

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("POST", "/account/edit", params, headers)
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
