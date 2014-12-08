# System libraries
import sys, shutil

from suite_functions import *

# Tests
import login, register, edit, registerfail, info, info2, infofail, developerslist, login_sh
import projectslist, projectscreate, projectsadddev, projectsremdev, projectsedit
import projectscreatebacklog, projectsdeletebacklog, projectscreatefail,projectscreatefail2
import projectsaddpbi, projectsdelpbi, projectseditpbi, taskslist, taskscreate
import tasksdelete, tasksedit, stats, sprintlogslist, sprintlogscreate, sprintlogscreate_fail
import sprintlogslistpbis, sprintlogsaddpbi, sprintlogsdelpbi, sprintlogsdelete, recoverpasswordok
import recoverpasswordfail, recoverpasswordfail2, projectsgetbacklog, stats_proj, stats_proj2



print_logo()


print("\nBackuping pdt.db DB... ",end="")
# FIRST OF ALL SAVE A COPY OF THE DB
shutil.copy2("../../../pdt.db", "pdtcopy.db")
print("Done")

print("\nReplacing pdt.db with database_for_testing.db... ",end="")
shutil.copy2("database_for_testing.db", "../../../pdt.db")
print("Done\n")


verbose = False
if len(sys.argv) > 1 and sys.argv[1] == "--verbose":
    verbose = True



try:

    # LIST OF TASKS TO DO:
    
    test_("/account/login - 1", login.exec_test, verbose)
    test_("/account/login - 2 (SH)", login_sh.exec_test, verbose)
    test_("/account/login - SQL-INJECTION", login.exec_test, verbose)
    test_("/account/register", register.exec_test, verbose)
    test_("/account/register - FAIL", registerfail.exec_test, verbose)
    test_("/account/recoverpassword", recoverpasswordok.exec_test, verbose)
    test_("/account/recoverpassword - FAIL 1", recoverpasswordfail.exec_test, verbose)
    test_("/account/recoverpassword - FAIL 2", recoverpasswordfail2.exec_test, verbose)
    test_("/account/edit", edit.exec_test, verbose)
    test_("/account/userinfo - 1", info.exec_test, verbose)
    test_("/account/userinfo - 2", info2.exec_test, verbose)
    test_("/account/userinfo - FAIL", infofail.exec_test, verbose)
    test_("/account/listdevelopers", developerslist.exec_test, verbose)
    test_("/projects/list", projectslist.exec_test, verbose)
    test_("/projects/create", projectscreate.exec_test, verbose)
    test_("/projects/create - FAIL 1", projectscreatefail.exec_test, verbose)
    test_("/projects/create - FAIL 2", projectscreatefail2.exec_test, verbose)
    test_("/projects/1/getbacklog", projectsgetbacklog.exec_test, verbose)
    test_("/projects/1/adddeveloper", projectsadddev.exec_test, verbose)
    test_("/projects/1/remdeveloper", projectsremdev.exec_test, verbose)
    test_("/projects/2/edit", projectsedit.exec_test, verbose)
    test_("/projects/2/createbacklog", projectscreatebacklog.exec_test, verbose)
    test_("/projects/2/deletebacklog", projectsdeletebacklog.exec_test, verbose)
    test_("/projects/1/pbis/create", projectsaddpbi.exec_test, verbose)
    test_("/projects/1/pbis/1/edit", projectseditpbi.exec_test, verbose)
    test_("/projects/1/pbis/1/delete", projectsdelpbi.exec_test, verbose)
    test_("/projects/1/pbis/2/listtasks", taskslist.exec_test, verbose)
    test_("/projects/1/pbis/2/createtask", taskscreate.exec_test, verbose)
    test_("/projects/1/pbis/2/tasks/1/edit", tasksedit.exec_test, verbose)

    test_("/projects/1/pbis/2/tasks/1/delete", tasksdelete.exec_test, verbose)   
    test_("/projects/1/sprintlogs/list", sprintlogslist.exec_test, verbose)
    test_("/projects/1/sprintlogs/create", sprintlogscreate.exec_test, verbose)
    test_("/projects/1/sprintlogs/create - FAIL", sprintlogscreate_fail.exec_test, verbose)
    test_("/projects/1/sprintlogs/1/listpbis", sprintlogslistpbis.exec_test, verbose)
    test_("/projects/1/sprintlogs/1/addpbi", sprintlogsaddpbi.exec_test, verbose)
    test_("/projects/1/sprintlogs/1/removepbi", sprintlogsdelpbi.exec_test, verbose)
    test_("/projects/1/sprintlogs/2/delete", sprintlogsdelete.exec_test, verbose)
    
    test_("/stats/devpoint", stats.exec_test, verbose)
    test_("/stats/projpoint", stats_proj.exec_test, verbose)
    test_("/stats/projpoint - 2", stats_proj2.exec_test, verbose)

finally:
    print_stats()
    
    # RESTORE THE DATABASE
    print("\nRestoring pdt.db DB... ",end="")
    shutil.move("pdtcopy.db", "../../../pdt.db")
    print("Done (** don't forget to restart Eiffel for next tests! **)")
    
    
