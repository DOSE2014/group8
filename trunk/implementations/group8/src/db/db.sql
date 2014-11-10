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
	`organization`	TEXT
);
INSERT INTO `User` VALUES(1,'Filippo','Pagano',1,712022400,'Italy','UTC+01:00','paganofilippo@gmail.com','password',1,'');
INSERT INTO `User` VALUES(2,'Federico','Reghenzani',1,712022400,'Italy','UTC+01:00','federico1.reghenzani@mail.polimi.it','password',1,'');
INSERT INTO `User` VALUES(3,'Мунир','Махмутов',1,712022400,'Russia','UTC+03:00','munir.makhmutov@gmail.com','password',0,'Россия, Республика Татарстан, Казань');
CREATE TABLE `Task` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`description`	TEXT,
	`sprintlog`	INTEGER,
	`developer`	INTEGER,
	`points`	INTEGER,
	`state`	INTEGER,
	`pbi`	INTEGER
);
INSERT INTO `Task` VALUES(1,'First task','Something to get done',1,1,1,1,1);
CREATE TABLE `Sprintlog` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`description`	TEXT,
	`backlog`	INTEGER,
	`startDate`	INTEGER,
	`endDate`	INTEGER
);
INSERT INTO `Sprintlog` VALUES(1,'Chat','Lets make a chat',1,1415555293,1415575293);
CREATE TABLE "Project" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT UNIQUE,
	`description`	TEXT,
	`manager`	INTEGER,
	`stakeholder`	INTEGER,
	`creationDate`	TEXT
);
INSERT INTO `Project` VALUES(1,'DOSE','Create DOSE software',1,3,1415555014);
CREATE TABLE "ProgrammingLanguage_User" (
	`programmingLanguage`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(programmingLanguage,user)
);
INSERT INTO `ProgrammingLanguage_User` VALUES(1,1);
INSERT INTO `ProgrammingLanguage_User` VALUES(1,2);
CREATE TABLE `ProgrammingLanguage` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT
);
INSERT INTO `ProgrammingLanguage` VALUES(1,'Eiffel');
INSERT INTO `ProgrammingLanguage` VALUES(2,'AngularJS');
CREATE TABLE `PBI` (
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
INSERT INTO `Message` VALUES(1,'Filippo',1415555014,1,'Hello world! :)');
CREATE TABLE "Language_User" (
	`language`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(language,user)
);
INSERT INTO `Language_User` VALUES(1,1);
INSERT INTO `Language_User` VALUES(2,1);
INSERT INTO `Language_User` VALUES(1,2);
INSERT INTO `Language_User` VALUES(2,2);
INSERT INTO `Language_User` VALUES(4,3);
INSERT INTO `Language_User` VALUES(2,3);
CREATE TABLE "Language" (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT
);
INSERT INTO `Language` VALUES(1,'Italian');
INSERT INTO `Language` VALUES(2,'English');
INSERT INTO `Language` VALUES(3,'Spanish');
INSERT INTO `Language` VALUES(4,'Russian');
CREATE TABLE "Developer_Project" (
	`developer`	INTEGER NOT NULL,
	`project`	INTEGER NOT NULL,
	PRIMARY KEY(developer,project)
);
INSERT INTO `Developer_Project` VALUES(1,1);
INSERT INTO `Developer_Project` VALUES(2,1);
CREATE TABLE `Chat_User` (
	`chat`	INTEGER NOT NULL,
	`user`	INTEGER NOT NULL,
	PRIMARY KEY(chat,user)
);
INSERT INTO `Chat_User` VALUES(1,1);
INSERT INTO `Chat_User` VALUES(1,2);
INSERT INTO `Chat_User` VALUES(1,3);
CREATE TABLE `Chat` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`project`	INTEGER
);
INSERT INTO `Chat` VALUES(1,1);
CREATE TABLE `Backlog` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`description`	TEXT,
	`project`	INTEGER
);
INSERT INTO `Backlog` VALUES(1,'To be implemented',1);
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
COMMIT;
