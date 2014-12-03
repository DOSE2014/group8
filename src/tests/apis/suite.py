# System libraries
import sys, shutil, time

# Tests
import login, register, edit, registerfail, info, info2, infofail, developerslist, projectslist, projectscreate
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

counter_ok = 0
counter_error = 0
counter_exception = 0

def test_(name, function):
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
    test_("/projects/list", projectslist.exec_test)
    test_("/projects/create", projectscreate.exec_test)
    test_("/projects/1/pbis/create", projectsaddpbi.exec_test)
    test_("/projects/1/pbis/1/edit", projectseditpbi.exec_test)
    test_("/projects/1/pbis/1/delete", projectsdelpbi.exec_test)
    

finally:
    total = counter_ok + counter_exception + counter_error
    print("")
    print(bcolors.OKGREEN+"Test success: "+str(counter_ok) + " ("+("{0:.2f}".format (counter_ok*100/total))+"%)"+bcolors.ENDC)
    print(bcolors.WARNING+"Test error: "+str(counter_error)+ " ("+("{0:.2f}".format (counter_error*100/total))+"%)"+bcolors.ENDC)
    print(bcolors.FAIL+"Test exception: "+str(counter_exception)+ " ("+("{0:.2f}".format( counter_exception*100/total))+"%)"+bcolors.ENDC)

    # RESTORE THE DATABASE
    print("\nRestoring pdt.db DB... ",end="")
    shutil.move("pdtcopy.db", "../../../pdt.db")
    print("Done (** don't forget to restart Eiffel for next tests! **)")
    
    
