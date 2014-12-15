----------------------------------------------------------------------------------------------------------------------------------------------------------
-- SIGNATURE
----------------------------------------------------------------------------------------------------------------------------------------------------------

sig Lang {}
sig ProgrammingLanguage {}

abstract sig User {
	speaks : some Lang
}

sig Developer extends User {
	knows : some ProgrammingLanguage
}
sig Stakeholder extends User {}


sig Project {
   manager : one Developer,
   stakeholder : one Stakeholder,
   developers : set Developer,
	backlogs : lone Backlog,
	chats : set Chat
}

sig Backlog {
	pbis : set PBI,
	sprintlogs : set Sprintlog
}

sig PBI {
	tasks : some Task
}

sig Task {
	hasAssigned : lone Developer
}
sig Sprintlog { 
	pbis : set PBI
}

sig Message {
	user : one User
}
sig Chat {
	messages : set Message,
	users : some User
}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- FACT
----------------------------------------------------------------------------------------------------------------------------------------------------------


fact {
   Project.developers = {d : Developer | d not in Project.manager}
}
fact PBIConstraint {
	all p : PBI | p in Backlog.pbis
}
fact SprintlogConstraint {
	all s : Sprintlog | s in Backlog.sprintlogs
}
fact ChatConstraint {
	all c : Chat | c in Project.chats
}
fact BacklogConstraint {
	all b : Backlog | b in Project.backlogs
}
fact TaskConstraint {
	all t : Task | t in PBI.tasks
	all p1,p2 : PBI | all t : Task | (t in p1.tasks and t in p2.tasks) implies p1=p2 
}

fact TaskAssignConstraint {
	all t : Task | all d : Developer |all p: PBI | all backlog : Backlog |  all proj : Project | 
 (t.hasAssigned = none) or ((t.hasAssigned = d) and t in p.tasks and p in backlog.pbis and backlog in proj.backlogs)
 implies d in proj.developers

}

fact MessageConstraint {
	all m : Message | m in Chat.messages
	all c1,c2 : Chat | all m : Message | (m in c1.messages and m in c2.messages) implies c1=c2  
}

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREDICATED
----------------------------------------------------------------------------------------------------------------------------------------------------------

pred addDevToProj(p, p' : Project, d : Developer) {
   (d in p'.developers) && (d not in p.developers)
}

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ASSERTION
----------------------------------------------------------------------------------------------------------------------------------------------------------
assert addDelConsistent {
	all p,p' : Project | all d : Developer | addDevToProj[p,p',d] implies #(p'.developers)=#(p.developers)+1
}

assert NoTaskAssignedIfIsNotInProject {
	all p : Project | all d : Developer | all pbi : PBI | all t : Task | (t in pbi.tasks and pbi in p.backlogs.pbis and d = t.hasAssigned) implies (d in p.developers)
}


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- RUNNING
----------------------------------------------------------------------------------------------------------------------------------------------------------


pred show() {#Developer >3 #Project > 1}
run show for 7 but 2 Project, 3 Sprintlog, 1 Chat, 3 Message

check addDelConsistent
check NoTaskAssignedIfIsNotInProject
