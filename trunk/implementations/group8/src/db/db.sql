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
	`creationDate`	TEXT
);
CREATE TABLE "ProgrammingLanguage_User" (
	`user`	INTEGER NOT NULL,
	`programmingLanguage`	INTEGER NOT NULL,
	PRIMARY KEY(user,programmingLanguage)
);
CREATE TABLE `ProgrammingLanguage` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT
);
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

COMMIT;
