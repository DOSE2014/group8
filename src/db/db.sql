BEGIN TRANSACTION;
CREATE TABLE "User" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`firstname`	TEXT,
	`lastname`	TEXT,
	`sex`	INTEGER,
	`dateOfBirth`	INTEGER,
	`country`	TEXT,
	`timezone`	TEXT,
	`email`	TEXT,
	`password`	TEXT,
	`userType`	INTEGER,
	`organization`	TEXT,
	`deleted`	INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE `Task` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`description`	TEXT,
	`developer`	INTEGER,
	`points`	INTEGER,
	`state`	INTEGER,
	`pbi`	INTEGER,
	`completionDate` INTEGER
);
CREATE TABLE `Sprintlog` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`description`	TEXT,
	`backlog`	INTEGER,
	`startDate`	INTEGER,
	`endDate`	INTEGER
);
CREATE TABLE "Project" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT UNIQUE,
	`description`	TEXT,
	`manager`	INTEGER,
	`stakeholder`	INTEGER,
	`creationDate`	TEXT,
	`deleted`	INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE "ProgrammingLanguage_User" (
	`programmingLanguage`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(programmingLanguage,user)
);
CREATE TABLE `ProgrammingLanguage` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT
);
CREATE TABLE "PBI" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`description`	TEXT,
	`backlog`	INTEGER,
	`sprintlog`	INTEGER,
	`type`	INTEGER,
	`priority`	INTEGER,
	`dueDate`	TEXT
);
CREATE TABLE `Message` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`user`	INTEGER,
	`date`	TEXT,
	`chat`	INTEGER,
	`content`	TEXT
);
CREATE TABLE "Language_User" (
	`language`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(language,user)
);
CREATE TABLE "Language" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT
);
CREATE TABLE "Developer_Project" (
	`developer`	INTEGER NOT NULL,
	`project`	INTEGER NOT NULL,
	PRIMARY KEY(developer,project)
);
CREATE TABLE `Chat_User` (
	`chat`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(chat,user)
);
CREATE TABLE `Chat` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`project`	INTEGER
);
CREATE TABLE `Backlog` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`description`	TEXT,
	`project`	INTEGER
);
INSERT INTO `User` VALUES ('1','Filippo','Pagano','1','712022400','Italy','UTC+01:00','paganofilippo@gmail.com','password','1',NULL,'0');
INSERT INTO `User` VALUES ('2','Federico','Reghenzani','1','712022400','Italy','UTC+01:00','federico1.reghenzani@mail.polimi.it','password','1',NULL,'0');
INSERT INTO `User` VALUES ('3','Мунир','Махмутов','1','712022400','Russia','UTC+03:00','munir.makhmutov@gmail.com','password','0','Россия, Республика Татарстан, Казань','0');
INSERT INTO `Task` VALUES ('1','First task','Something to get done','1','1','1','1');
INSERT INTO `Sprintlog` VALUES ('1','Chat','Lets make a chat','1','1415555293','1415575293');
INSERT INTO `Sprintlog` VALUES ('2','Prototype','Tuesday, November 25th – 8 am (CET)v','2','1415689214','1416898814');
INSERT INTO `Project` VALUES ('1','DOSE','Create DOSE software','1','3','1415555014','0');
INSERT INTO `ProgrammingLanguage_User` VALUES ('1','1');
INSERT INTO `ProgrammingLanguage_User` VALUES ('1','2');
INSERT INTO `ProgrammingLanguage` VALUES ('1','Eiffel');
INSERT INTO `ProgrammingLanguage` VALUES ('2','AngularJS');
INSERT INTO `PBI` VALUES ('1','The system should allow user to create and manage its own account','To use the system user have to log in or register. Logged in users can change profile settings and delete account','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('2','The system should allow developer to create and manage a project','To start project developer have to create it. After creation developer becomes the manager of this project. Also manager can change settings of this project or delete it','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('3','The system should allow manager to create and manage a backlog','After project creation manager have to create backlog. Also, if necessary, manager can edit or delete it','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('4','The system should allow developers and manager to see project’s backlog','Developers, manager of the project must have opportunity to see project’s backlog','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('5','The system should allow manager to create and manage a sprint logs','After backlog creation manager can create a sprint logs. Also, if necessary, manager can edit or delete it. If sprint is started, then manager cannot edit or delete the backlog','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('6','The system should allow developers and manager to see project’s sprint logs','Developers and manager of the project must have opportunity to see project’s sprint logs','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('7','The system should allow manager to assign tasks with points to the developers','Manager can check tasks with different points and assign them to different developers of current project','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('8','The system should allow manager to divide sprint log into tasks and manage these tasks','Manager can create, modify and delete tasks, that then will be assigned to developers','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('9','The system should allow manager and developer to see his/her tasks','Manager/developer can see tasks that were assigned to him/her by himself/manager','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('10','The system should allow developers to change the states of tasks ','There are three states for every task: awaiting, ongoing, completed. After creation the state of task automatically becomes “awaiting”. When developer begins to do the assigned task he/she changes task state to “ongoing”. After task completion developer changes task state to “completed”','1', '1', '1','3','1416898814');
INSERT INTO `PBI` VALUES ('11','The system should allow user to see project statistics','Users can see projects’ statistics that represents percent of their execution with dates when sprint logs were finished','1', '1', '1','2','1416898814');
INSERT INTO `PBI` VALUES ('12','The system should allow user to chat with other users','Users can communicate with each other. Also it is possible to create group chats. After project creation group chat with all team members except stakeholder automatically appears. If project manager adds new team member, he/she automatically joins to project chat','1', '1', '1','2','1416898814');
INSERT INTO `PBI` VALUES ('13','The system should allow forming chart of developers according to their points','Developers and managers can see developers’ chart. Chart is formed in order to their developers’ points, that they gained by tasks’ performing. Also it can be possible to use other kinds of order to form chart','1', '1', '1','2','1416898814');
INSERT INTO `PBI` VALUES ('14','The system should allow user to see ongoing events on dashboard','Users can see dashboard. Dashboard shows ongoing events of the users’ project. If user has more than one project, he sees only one dashboard with ongoing events of every project (it must be clear that every event belongs to its project)','1', '1', '1','2','1416898814');
INSERT INTO `PBI` VALUES ('15','The system should be fault tolerant (availability)','The system must be available at most of time (not less than 99% of time)','1', '1', '2','3','1416898814');
INSERT INTO `PBI` VALUES ('16','The system should provide data integrity','All information of this system, including databases, software, the executable code components of the system and chat history and all the data should not be lost, also system should have redundant copies','1', '1', '2','3','1416898814');
INSERT INTO `PBI` VALUES ('17','The system should provide confidentiality','Access to certain information should be provided only to corresponding authorized users, which have permissions to it. All passwords should be stored in the system in an encrypted form.','1', '1', '2','3','1416898814');
INSERT INTO `PBI` VALUES ('18','The system should be user friendly','Interface of the system should be intuitively understandable by the user','1', '1', '2','2','1416898814');
INSERT INTO `PBI` VALUES ('19','Create an account','To create user’s account','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('20','Log in','To log in','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('21','Manage account','To manage user’s account','1','1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('22','Delete account','To delete user’s account','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('23','Create project','To create project','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('24','Manage project','To manage project','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('25','Close the project ','To close project','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('26','Create backlogs, sprint logs and tasks ','To create backlog, sprint logs and tasks','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('27','Manage backlogs, sprint logs and tasks ','To manage backlog, sprint logs and tasks','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('28','Backlogs, sprint logs and tasks review','To show backlogs, sprint logs and tasks to developers and managers','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('29','Assign tasks','Manager assigns tasks with points to the developers','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('30','Change task states','To change task states','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('31','Developers chart','The system should allow forming chart of developers','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('32','Project’s progress','To show ongoing tasks on dashboard and project statistics','1', '1', '3','3','1416898814');
INSERT INTO `PBI` VALUES ('33','Chat','To organize communication between users','1', '1', '3','3','1416898814');
INSERT INTO `Message` VALUES ('1','Filippo','1415555014','1','Hello world! :)');
INSERT INTO `Language_User` VALUES ('1','1');
INSERT INTO `Language_User` VALUES ('2','1');
INSERT INTO `Language_User` VALUES ('1','2');
INSERT INTO `Language_User` VALUES ('2','2');
INSERT INTO `Language_User` VALUES ('4','3');
INSERT INTO `Language_User` VALUES ('2','3');
INSERT INTO `Language` VALUES ('1','Italian');
INSERT INTO `Language` VALUES ('2','English');
INSERT INTO `Language` VALUES ('3','Spanish');
INSERT INTO `Language` VALUES ('4','Russian');
INSERT INTO `Developer_Project` VALUES ('1','1');
INSERT INTO `Developer_Project` VALUES ('2','1');
INSERT INTO `Chat_User` VALUES ('1','1');
INSERT INTO `Chat_User` VALUES ('1','2');
INSERT INTO `Chat_User` VALUES ('1','3');
INSERT INTO `Chat` VALUES ('1','1');
INSERT INTO `Backlog` VALUES ('1','To be implemented','1');
COMMIT;
