import http.client
import json, login

from suite_functions import check_reply

params = "";

expected_response = json.loads("""
{"description":"To be implemented","pbis":[{"id":1,"name":"The system should allow user to create and manage its own account","description":"To use the system user have to log in or register. Logged in users can change profile settings and delete account","sprintlog":1,"type":"requirement","priority":3,"dueDate":1416898814},{"id":2,"name":"The system should allow developer to create and manage a project","description":"To start project developer have to create it. After creation developer becomes the manager of this project. Also manager can change settings of this project or delete it","sprintlog":1,"type":"requirement","priority":3,"dueDate":1416898814},{"id":3,"name":"The system should allow manager to create and manage a backlog","description":"After project creation manager have to create backlog. Also, if necessary, manager can edit or delete it","sprintlog":2,"type":"requirement","priority":3,"dueDate":1416898814},{"id":10,"name":"The system should allow developers to change the states of tasks ","description":"There are three states for every task: awaiting, ongoing, completed. After creation the state of task automatically becomes “awaiting”. When developer begins to do the assigned task he/she changes task state to “ongoing”. After task completion developer changes task state to “completed”","sprintlog":1,"type":"requirement","priority":3,"dueDate":1416898814},{"id":12,"name":"The system should allow user to chat with other users","description":"Users can communicate with each other. Also it is possible to create group chats. After project creation group chat with all team members except stakeholder automatically appears. If project manager adds new team member, he/she automatically joins to project chat","sprintlog":1,"type":"requirement","priority":2,"dueDate":1416898814},{"id":14,"name":"The system should allow user to see ongoing events on dashboard","description":"Users can see dashboard. Dashboard shows ongoing events of the users’ project. If user has more than one project, he sees only one dashboard with ongoing events of every project (it must be clear that every event belongs to its project)","sprintlog":1,"type":"requirement","priority":2,"dueDate":1416898814},{"id":15,"name":"The system should be fault tolerant (availability)","description":"The system must be available at most of time (not less than 99% of time)","sprintlog":1,"type":"nonfunctionalrequirement","priority":3,"dueDate":1416898814},{"id":16,"name":"The system should provide data integrity","description":"All information of this system, including databases, software, the executable code components of the system and chat history and all the data should not be lost, also system should have redundant copies","sprintlog":1,"type":"nonfunctionalrequirement","priority":3,"dueDate":1416898814}]}

""")

def exec_test(debug=False):
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain", "Cookie" : "_pdt_session_id_="+login.cookie_id+""}
    conn = http.client.HTTPConnection("localhost", 8080)
    conn.request("GET", "/projects/1/getbacklog", params, headers)

    return check_reply(conn, expected_response, debug)
