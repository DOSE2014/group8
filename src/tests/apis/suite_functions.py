import json

def check_reply(conn, expected_response, debug=False):
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
