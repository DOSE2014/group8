import sys, shutil
import login, register, registerfail, info, info2

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

print("\n"+bcolors.OKBLUE + "Welcome in PDT test suite for REST APIs" + bcolors.ENDC)
print("Use --verbose for verbosity, obviously.\n")


print("\nBackuping pdt.db DB... ",end="")
# FIRST OF ALL SAVE A COPY OF THE DB
shutil.copy2("../../../pdt.db", "pdtcopy.db")
print("Done\n")

verbose = False
if len(sys.argv) > 1 and sys.argv[1] == "--verbose":
    verbose = True


def test_(name, function):
    print("["+name+"] ", end="")
    sys.stdout.flush()

    try:
        if function(verbose):
            print(bcolors.OKGREEN+"OK"+bcolors.ENDC)
        else:
            print(bcolors.FAIL+"ERROR"+bcolors.ENDC)
    except(ConnectionRefusedError):
        print(bcolors.WARNING+"CONNECTION REFUSED"+bcolors.ENDC)
    except Exception as e:
        print(bcolors.FAIL+"EXCEPTION ("+e+")"+bcolors.ENDC)

test_("LOGIN", login.exec_test)
#test_("REGISTER", register.exec_test)
test_("REGISTER-FAIL", registerfail.exec_test)
test_("INFO", info.exec_test)
test_("INFO2", info2.exec_test)

# RESTORE THE DATABASE
print("\nRestoring pdt.db DB... ",end="")
shutil.move("pdtcopy.db", "../../../pdt.db")
print("Done (don't forget to restart Eiffel for next tests!)")
