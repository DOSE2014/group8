import json, sys, time

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

# Helper class for colors
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    
def print_logo():
    print("\n"+bcolors.OKBLUE)
    print("""
      _____  _____ _______   _______        _      _____       _ _       
     |  __ \\|  __ \\__   __| |__   __|      | |    / ____|     (_) |      
     | |__) | |  | | | |       | | ___  ___| |_  | (___  _   _ _| |_ ___ 
     |  ___/| |  | | | |       | |/ _ \\/ __| __|  \\___ \\| | | | | __/ _ \\
     | |    | |__| | | |       | |  __/\\__ \\ |_   ____) | |_| | | | | __/
     |_|    |_____/  |_|       |_|\\___||___/\\__| |_____/ \\__,_|_|\\__\\___|
                                                                         
    """)
    print("\n"+bcolors.ENDC)
    print("Use --verbose for verbosity.")
    
    

counter_ok = 0
counter_error = 0
counter_exception = 0


def test_(name, function, verbose):
    global counter_ok, counter_error, counter_exception
    print("["+name+"] ",end="")
    sys.stdout.flush()

    try:
        if function(verbose):
            print(bcolors.OKGREEN+"OK"+bcolors.ENDC)
            counter_ok = counter_ok + 1
        else:
            print(bcolors.WARNING+"ERROR"+bcolors.ENDC)
            counter_error = counter_error + 1
    except(ConnectionRefusedError):
        print(bcolors.WARNING+"CONNECTION REFUSED"+bcolors.ENDC)
        counter_exception = counter_exception + 1
    except Exception as e:
        print(bcolors.FAIL+"EXCEPTION ("+str(e)+")"+bcolors.ENDC)
        counter_exception = counter_exception + 1
    finally:
        time.sleep(0.1)
        
def print_stats():
    total = counter_ok + counter_exception + counter_error
    print("")
    print(bcolors.OKGREEN+"Test success: "+str(counter_ok) + " ("+("{0:.2f}".format (counter_ok*100/total))+"%)"+bcolors.ENDC)
    print(bcolors.WARNING+"Test error: "+str(counter_error)+ " ("+("{0:.2f}".format (counter_error*100/total))+"%)"+bcolors.ENDC)
    print(bcolors.FAIL+"Test exception: "+str(counter_exception)+ " ("+("{0:.2f}".format( counter_exception*100/total))+"%)"+bcolors.ENDC)

        
        