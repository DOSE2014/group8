# System libraries
import sys, shutil, time

# Tests
import login, register, edit, registerfail, info, info2, infofail, developerslist, projectslist
import projectsaddpbi, projectsdelpbi, projectseditpbi

# Helper class for colors
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
    print("["+name+"] ",end="")
    sys.stdout.flush()

    try:
        if function(verbose):
            print(bcolors.OKGREEN+"OK"+bcolors.ENDC)
        else:
            print(bcolors.FAIL+"ERROR"+bcolors.ENDC)
    except(ConnectionRefusedError):
        print(bcolors.WARNING+"CONNECTION REFUSED"+bcolors.ENDC)
    except Exception as e:
        print(bcolors.FAIL+"EXCEPTION ("+str(e)+")"+bcolors.ENDC)
    finally:
        time.sleep(0.2)

try:

    # LIST OF TASKS TO DO:
    
    test_("/account/login - 1", login.exec_test)
    test_("/account/login - SQL-INJECTION", login.exec_test)
    test_("/account/register", register.exec_test)
    test_("/account/register - FAIL", registerfail.exec_test)
    test_("/account/edit", edit.exec_test)
    test_("/account/userinfo - 1", info.exec_test)
    test_("/account/userinfo - 2", info2.exec_test)
    test_("/account/userinfo - FAIL", infofail.exec_test)
    test_("/account/listdevelopers", developerslist.exec_test)
    test_("/projects/listprojects", projectslist.exec_test)
    test_("/projects/1/pbis/create", projectsaddpbi.exec_test)
    test_("/projects/1/pbis/1/edit", projectseditpbi.exec_test)
    test_("/projects/1/pbis/1/delete", projectsdelpbi.exec_test)

finally:
    # RESTORE THE DATABASE
    print("\nRestoring pdt.db DB... ",end="")
    shutil.move("pdtcopy.db", "../../../pdt.db")
    print("Done (don't forget to restart Eiffel for next tests!)")
