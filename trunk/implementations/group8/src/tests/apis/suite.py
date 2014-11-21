import sys
import login, register


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

verbose = False
if len(sys.argv) > 1 and sys.argv[1] == "--verbose":
    verbose = True

print("\n"+bcolors.OKBLUE + "Welcome in PDT test suite for REST APIs" + bcolors.ENDC)
print("Use --verbose for verbosity obviously.\n")

def test_(name, function):
    print("["+name+"] ", end="")

    try:
        if function(verbose):
            print(bcolors.OKGREEN+"OK"+bcolors.ENDC)
        else:
            print(bcolors.OKERROR+"ERROR"+bcolors.ENDC)
    except(ConnectionRefusedError):
        print(bcolors.WARNING+"CONNECTION REFUSED"+bcolors.ENDC)

test_("LOGIN", login.exec_test)
test_("REGISTER", register.exec_test)