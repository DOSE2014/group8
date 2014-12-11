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
INSERT INTO `Task` VALUES ('1','First task','Something to get done','1','1','1','1','1415555293');
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
INSERT INTO `Language`(name) VALUES ('Afar');
INSERT INTO `Language`(name) VALUES ('Abkhazian');
INSERT INTO `Language`(name) VALUES ('Achinese');
INSERT INTO `Language`(name) VALUES ('Acoli');
INSERT INTO `Language`(name) VALUES ('Adangme');
INSERT INTO `Language`(name) VALUES ('Adyghe; Adygei');
INSERT INTO `Language`(name) VALUES ('Afro-Asiatic languages');
INSERT INTO `Language`(name) VALUES ('Afrihili');
INSERT INTO `Language`(name) VALUES ('Afrikaans');
INSERT INTO `Language`(name) VALUES ('Ainu');
INSERT INTO `Language`(name) VALUES ('Akan');
INSERT INTO `Language`(name) VALUES ('Akkadian');
INSERT INTO `Language`(name) VALUES ('Albanian');
INSERT INTO `Language`(name) VALUES ('Aleut');
INSERT INTO `Language`(name) VALUES ('Algonquian languages');
INSERT INTO `Language`(name) VALUES ('Southern Altai');
INSERT INTO `Language`(name) VALUES ('Amharic');
INSERT INTO `Language`(name) VALUES ('English, Old (ca.450-1100)');
INSERT INTO `Language`(name) VALUES ('Angika');
INSERT INTO `Language`(name) VALUES ('Apache languages');
INSERT INTO `Language`(name) VALUES ('Arabic');
INSERT INTO `Language`(name) VALUES ('Official Aramaic (700-300 BCE); Imperial Aramaic (700-300 BCE)');
INSERT INTO `Language`(name) VALUES ('Aragonese');
INSERT INTO `Language`(name) VALUES ('Armenian');
INSERT INTO `Language`(name) VALUES ('Mapudungun; Mapuche');
INSERT INTO `Language`(name) VALUES ('Arapaho');
INSERT INTO `Language`(name) VALUES ('Artificial languages');
INSERT INTO `Language`(name) VALUES ('Arawak');
INSERT INTO `Language`(name) VALUES ('Assamese');
INSERT INTO `Language`(name) VALUES ('Asturian; Bable; Leonese; Asturleonese');
INSERT INTO `Language`(name) VALUES ('Athapascan languages');
INSERT INTO `Language`(name) VALUES ('Australian languages');
INSERT INTO `Language`(name) VALUES ('Avaric');
INSERT INTO `Language`(name) VALUES ('Avestan');
INSERT INTO `Language`(name) VALUES ('Awadhi');
INSERT INTO `Language`(name) VALUES ('Aymara');
INSERT INTO `Language`(name) VALUES ('Azerbaijani');
INSERT INTO `Language`(name) VALUES ('Banda languages');
INSERT INTO `Language`(name) VALUES ('Bamileke languages');
INSERT INTO `Language`(name) VALUES ('Bashkir');
INSERT INTO `Language`(name) VALUES ('Baluchi');
INSERT INTO `Language`(name) VALUES ('Bambara');
INSERT INTO `Language`(name) VALUES ('Balinese');
INSERT INTO `Language`(name) VALUES ('Basque');
INSERT INTO `Language`(name) VALUES ('Basa');
INSERT INTO `Language`(name) VALUES ('Baltic languages');
INSERT INTO `Language`(name) VALUES ('Beja; Bedawiyet');
INSERT INTO `Language`(name) VALUES ('Belarusian');
INSERT INTO `Language`(name) VALUES ('Bemba');
INSERT INTO `Language`(name) VALUES ('Bengali');
INSERT INTO `Language`(name) VALUES ('Berber languages');
INSERT INTO `Language`(name) VALUES ('Bhojpuri');
INSERT INTO `Language`(name) VALUES ('Bihari languages');
INSERT INTO `Language`(name) VALUES ('Bikol');
INSERT INTO `Language`(name) VALUES ('Bini; Edo');
INSERT INTO `Language`(name) VALUES ('Bislama');
INSERT INTO `Language`(name) VALUES ('Siksika');
INSERT INTO `Language`(name) VALUES ('Bantu (Other)');
INSERT INTO `Language`(name) VALUES ('Bosnian');
INSERT INTO `Language`(name) VALUES ('Braj');
INSERT INTO `Language`(name) VALUES ('Breton');
INSERT INTO `Language`(name) VALUES ('Batak languages');
INSERT INTO `Language`(name) VALUES ('Buriat');
INSERT INTO `Language`(name) VALUES ('Buginese');
INSERT INTO `Language`(name) VALUES ('Bulgarian');
INSERT INTO `Language`(name) VALUES ('Burmese');
INSERT INTO `Language`(name) VALUES ('Blin; Bilin');
INSERT INTO `Language`(name) VALUES ('Caddo');
INSERT INTO `Language`(name) VALUES ('Central American Indian languages');
INSERT INTO `Language`(name) VALUES ('Galibi Carib');
INSERT INTO `Language`(name) VALUES ('Catalan; Valencian');
INSERT INTO `Language`(name) VALUES ('Caucasian languages');
INSERT INTO `Language`(name) VALUES ('Cebuano');
INSERT INTO `Language`(name) VALUES ('Celtic languages');
INSERT INTO `Language`(name) VALUES ('Chamorro');
INSERT INTO `Language`(name) VALUES ('Chibcha');
INSERT INTO `Language`(name) VALUES ('Chechen');
INSERT INTO `Language`(name) VALUES ('Chagatai');
INSERT INTO `Language`(name) VALUES ('Chinese');
INSERT INTO `Language`(name) VALUES ('Chuukese');
INSERT INTO `Language`(name) VALUES ('Mari');
INSERT INTO `Language`(name) VALUES ('Chinook jargon');
INSERT INTO `Language`(name) VALUES ('Choctaw');
INSERT INTO `Language`(name) VALUES ('Chipewyan; Dene Suline');
INSERT INTO `Language`(name) VALUES ('Cherokee');
INSERT INTO `Language`(name) VALUES ('Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic');
INSERT INTO `Language`(name) VALUES ('Chuvash');
INSERT INTO `Language`(name) VALUES ('Cheyenne');
INSERT INTO `Language`(name) VALUES ('Chamic languages');
INSERT INTO `Language`(name) VALUES ('Coptic');
INSERT INTO `Language`(name) VALUES ('Cornish');
INSERT INTO `Language`(name) VALUES ('Corsican');
INSERT INTO `Language`(name) VALUES ('Creoles and pidgins, English based');
INSERT INTO `Language`(name) VALUES ('Creoles and pidgins, French-based ');
INSERT INTO `Language`(name) VALUES ('Creoles and pidgins, Portuguese-based ');
INSERT INTO `Language`(name) VALUES ('Cree');
INSERT INTO `Language`(name) VALUES ('Crimean Tatar; Crimean Turkish');
INSERT INTO `Language`(name) VALUES ('Creoles and pidgins ');
INSERT INTO `Language`(name) VALUES ('Kashubian');
INSERT INTO `Language`(name) VALUES ('Cushitic languages');
INSERT INTO `Language`(name) VALUES ('Czech');
INSERT INTO `Language`(name) VALUES ('Dakota');
INSERT INTO `Language`(name) VALUES ('Danish');
INSERT INTO `Language`(name) VALUES ('Dargwa');
INSERT INTO `Language`(name) VALUES ('Land Dayak languages');
INSERT INTO `Language`(name) VALUES ('Delaware');
INSERT INTO `Language`(name) VALUES ('Slave (Athapascan)');
INSERT INTO `Language`(name) VALUES ('Dogrib');
INSERT INTO `Language`(name) VALUES ('Dinka');
INSERT INTO `Language`(name) VALUES ('Divehi; Dhivehi; Maldivian');
INSERT INTO `Language`(name) VALUES ('Dogri');
INSERT INTO `Language`(name) VALUES ('Dravidian languages');
INSERT INTO `Language`(name) VALUES ('Lower Sorbian');
INSERT INTO `Language`(name) VALUES ('Duala');
INSERT INTO `Language`(name) VALUES ('Dutch, Middle (ca.1050-1350)');
INSERT INTO `Language`(name) VALUES ('Dutch; Flemish');
INSERT INTO `Language`(name) VALUES ('Dyula');
INSERT INTO `Language`(name) VALUES ('Dzongkha');
INSERT INTO `Language`(name) VALUES ('Efik');
INSERT INTO `Language`(name) VALUES ('Egyptian (Ancient)');
INSERT INTO `Language`(name) VALUES ('Ekajuk');
INSERT INTO `Language`(name) VALUES ('Elamite');
INSERT INTO `Language`(name) VALUES ('English');
INSERT INTO `Language`(name) VALUES ('English, Middle (1100-1500)');
INSERT INTO `Language`(name) VALUES ('Esperanto');
INSERT INTO `Language`(name) VALUES ('Estonian');
INSERT INTO `Language`(name) VALUES ('Ewe');
INSERT INTO `Language`(name) VALUES ('Ewondo');
INSERT INTO `Language`(name) VALUES ('Fang');
INSERT INTO `Language`(name) VALUES ('Faroese');
INSERT INTO `Language`(name) VALUES ('Fanti');
INSERT INTO `Language`(name) VALUES ('Fijian');
INSERT INTO `Language`(name) VALUES ('Filipino; Pilipino');
INSERT INTO `Language`(name) VALUES ('Finnish');
INSERT INTO `Language`(name) VALUES ('Finno-Ugrian languages');
INSERT INTO `Language`(name) VALUES ('Fon');
INSERT INTO `Language`(name) VALUES ('French');
INSERT INTO `Language`(name) VALUES ('French, Middle (ca.1400-1600)');
INSERT INTO `Language`(name) VALUES ('French, Old (842-ca.1400)');
INSERT INTO `Language`(name) VALUES ('Northern Frisian');
INSERT INTO `Language`(name) VALUES ('Eastern Frisian');
INSERT INTO `Language`(name) VALUES ('Western Frisian');
INSERT INTO `Language`(name) VALUES ('Fulah');
INSERT INTO `Language`(name) VALUES ('Friulian');
INSERT INTO `Language`(name) VALUES ('Ga');
INSERT INTO `Language`(name) VALUES ('Gayo');
INSERT INTO `Language`(name) VALUES ('Gbaya');
INSERT INTO `Language`(name) VALUES ('Germanic languages');
INSERT INTO `Language`(name) VALUES ('Georgian');
INSERT INTO `Language`(name) VALUES ('German');
INSERT INTO `Language`(name) VALUES ('Geez');
INSERT INTO `Language`(name) VALUES ('Gilbertese');
INSERT INTO `Language`(name) VALUES ('Gaelic; Scottish Gaelic');
INSERT INTO `Language`(name) VALUES ('Irish');
INSERT INTO `Language`(name) VALUES ('Galician');
INSERT INTO `Language`(name) VALUES ('Manx');
INSERT INTO `Language`(name) VALUES ('German, Middle High (ca.1050-1500)');
INSERT INTO `Language`(name) VALUES ('German, Old High (ca.750-1050)');
INSERT INTO `Language`(name) VALUES ('Gondi');
INSERT INTO `Language`(name) VALUES ('Gorontalo');
INSERT INTO `Language`(name) VALUES ('Gothic');
INSERT INTO `Language`(name) VALUES ('Grebo');
INSERT INTO `Language`(name) VALUES ('Greek, Ancient (to 1453)');
INSERT INTO `Language`(name) VALUES ('Greek, Modern (1453-)');
INSERT INTO `Language`(name) VALUES ('Guarani');
INSERT INTO `Language`(name) VALUES ('Swiss German; Alemannic; Alsatian');
INSERT INTO `Language`(name) VALUES ('Gujarati');
INSERT INTO `Language`(name) VALUES ('Gwichin');
INSERT INTO `Language`(name) VALUES ('Haida');
INSERT INTO `Language`(name) VALUES ('Haitian; Haitian Creole');
INSERT INTO `Language`(name) VALUES ('Hausa');
INSERT INTO `Language`(name) VALUES ('Hawaiian');
INSERT INTO `Language`(name) VALUES ('Hebrew');
INSERT INTO `Language`(name) VALUES ('Herero');
INSERT INTO `Language`(name) VALUES ('Hiligaynon');
INSERT INTO `Language`(name) VALUES ('Himachali languages; Western Pahari languages');
INSERT INTO `Language`(name) VALUES ('Hindi');
INSERT INTO `Language`(name) VALUES ('Hittite');
INSERT INTO `Language`(name) VALUES ('Hmong; Mong');
INSERT INTO `Language`(name) VALUES ('Hiri Motu');
INSERT INTO `Language`(name) VALUES ('Croatian');
INSERT INTO `Language`(name) VALUES ('Upper Sorbian');
INSERT INTO `Language`(name) VALUES ('Hungarian');
INSERT INTO `Language`(name) VALUES ('Hupa');
INSERT INTO `Language`(name) VALUES ('Iban');
INSERT INTO `Language`(name) VALUES ('Igbo');
INSERT INTO `Language`(name) VALUES ('Icelandic');
INSERT INTO `Language`(name) VALUES ('Ido');
INSERT INTO `Language`(name) VALUES ('Sichuan Yi; Nuosu');
INSERT INTO `Language`(name) VALUES ('Ijo languages');
INSERT INTO `Language`(name) VALUES ('Inuktitut');
INSERT INTO `Language`(name) VALUES ('Interlingue; Occidental');
INSERT INTO `Language`(name) VALUES ('Iloko');
INSERT INTO `Language`(name) VALUES ('Interlingua (International Auxiliary Language Association)');
INSERT INTO `Language`(name) VALUES ('Indic languages');
INSERT INTO `Language`(name) VALUES ('Indonesian');
INSERT INTO `Language`(name) VALUES ('Indo-European languages');
INSERT INTO `Language`(name) VALUES ('Ingush');
INSERT INTO `Language`(name) VALUES ('Inupiaq');
INSERT INTO `Language`(name) VALUES ('Iranian languages');
INSERT INTO `Language`(name) VALUES ('Iroquoian languages');
INSERT INTO `Language`(name) VALUES ('Italian');
INSERT INTO `Language`(name) VALUES ('Javanese');
INSERT INTO `Language`(name) VALUES ('Lojban');
INSERT INTO `Language`(name) VALUES ('Japanese');
INSERT INTO `Language`(name) VALUES ('Judeo-Persian');
INSERT INTO `Language`(name) VALUES ('Judeo-Arabic');
INSERT INTO `Language`(name) VALUES ('Kara-Kalpak');
INSERT INTO `Language`(name) VALUES ('Kabyle');
INSERT INTO `Language`(name) VALUES ('Kachin; Jingpho');
INSERT INTO `Language`(name) VALUES ('Kalaallisut; Greenlandic');
INSERT INTO `Language`(name) VALUES ('Kamba');
INSERT INTO `Language`(name) VALUES ('Kannada');
INSERT INTO `Language`(name) VALUES ('Karen languages');
INSERT INTO `Language`(name) VALUES ('Kashmiri');
INSERT INTO `Language`(name) VALUES ('Kanuri');
INSERT INTO `Language`(name) VALUES ('Kawi');
INSERT INTO `Language`(name) VALUES ('Kazakh');
INSERT INTO `Language`(name) VALUES ('Kabardian');
INSERT INTO `Language`(name) VALUES ('Khasi');
INSERT INTO `Language`(name) VALUES ('Khoisan languages');
INSERT INTO `Language`(name) VALUES ('Central Khmer');
INSERT INTO `Language`(name) VALUES ('Khotanese; Sakan');
INSERT INTO `Language`(name) VALUES ('Kikuyu; Gikuyu');
INSERT INTO `Language`(name) VALUES ('Kinyarwanda');
INSERT INTO `Language`(name) VALUES ('Kirghiz; Kyrgyz');
INSERT INTO `Language`(name) VALUES ('Kimbundu');
INSERT INTO `Language`(name) VALUES ('Konkani');
INSERT INTO `Language`(name) VALUES ('Komi');
INSERT INTO `Language`(name) VALUES ('Kongo');
INSERT INTO `Language`(name) VALUES ('Korean');
INSERT INTO `Language`(name) VALUES ('Kosraean');
INSERT INTO `Language`(name) VALUES ('Kpelle');
INSERT INTO `Language`(name) VALUES ('Karachay-Balkar');
INSERT INTO `Language`(name) VALUES ('Karelian');
INSERT INTO `Language`(name) VALUES ('Kru languages');
INSERT INTO `Language`(name) VALUES ('Kurukh');
INSERT INTO `Language`(name) VALUES ('Kuanyama; Kwanyama');
INSERT INTO `Language`(name) VALUES ('Kumyk');
INSERT INTO `Language`(name) VALUES ('Kurdish');
INSERT INTO `Language`(name) VALUES ('Kutenai');
INSERT INTO `Language`(name) VALUES ('Ladino');
INSERT INTO `Language`(name) VALUES ('Lahnda');
INSERT INTO `Language`(name) VALUES ('Lamba');
INSERT INTO `Language`(name) VALUES ('Lao');
INSERT INTO `Language`(name) VALUES ('Latin');
INSERT INTO `Language`(name) VALUES ('Latvian');
INSERT INTO `Language`(name) VALUES ('Lezghian');
INSERT INTO `Language`(name) VALUES ('Limburgan; Limburger; Limburgish');
INSERT INTO `Language`(name) VALUES ('Lingala');
INSERT INTO `Language`(name) VALUES ('Lithuanian');
INSERT INTO `Language`(name) VALUES ('Mongo');
INSERT INTO `Language`(name) VALUES ('Lozi');
INSERT INTO `Language`(name) VALUES ('Luxembourgish; Letzeburgesch');
INSERT INTO `Language`(name) VALUES ('Luba-Lulua');
INSERT INTO `Language`(name) VALUES ('Luba-Katanga');
INSERT INTO `Language`(name) VALUES ('Ganda');
INSERT INTO `Language`(name) VALUES ('Luiseno');
INSERT INTO `Language`(name) VALUES ('Lunda');
INSERT INTO `Language`(name) VALUES ('Luo (Kenya and Tanzania)');
INSERT INTO `Language`(name) VALUES ('Lushai');
INSERT INTO `Language`(name) VALUES ('Macedonian');
INSERT INTO `Language`(name) VALUES ('Madurese');
INSERT INTO `Language`(name) VALUES ('Magahi');
INSERT INTO `Language`(name) VALUES ('Marshallese');
INSERT INTO `Language`(name) VALUES ('Maithili');
INSERT INTO `Language`(name) VALUES ('Makasar');
INSERT INTO `Language`(name) VALUES ('Malayalam');
INSERT INTO `Language`(name) VALUES ('Mandingo');
INSERT INTO `Language`(name) VALUES ('Maori');
INSERT INTO `Language`(name) VALUES ('Austronesian languages');
INSERT INTO `Language`(name) VALUES ('Marathi');
INSERT INTO `Language`(name) VALUES ('Masai');
INSERT INTO `Language`(name) VALUES ('Malay');
INSERT INTO `Language`(name) VALUES ('Moksha');
INSERT INTO `Language`(name) VALUES ('Mandar');
INSERT INTO `Language`(name) VALUES ('Mende');
INSERT INTO `Language`(name) VALUES ('Irish, Middle (900-1200)');
INSERT INTO `Language`(name) VALUES ('Mikmaq; Micmac');
INSERT INTO `Language`(name) VALUES ('Minangkabau');
INSERT INTO `Language`(name) VALUES ('Uncoded languages');
INSERT INTO `Language`(name) VALUES ('Mon-Khmer languages');
INSERT INTO `Language`(name) VALUES ('Malagasy');
INSERT INTO `Language`(name) VALUES ('Maltese');
INSERT INTO `Language`(name) VALUES ('Manchu');
INSERT INTO `Language`(name) VALUES ('Manipuri');
INSERT INTO `Language`(name) VALUES ('Manobo languages');
INSERT INTO `Language`(name) VALUES ('Mohawk');
INSERT INTO `Language`(name) VALUES ('Mongolian');
INSERT INTO `Language`(name) VALUES ('Mossi');
INSERT INTO `Language`(name) VALUES ('Multiple languages');
INSERT INTO `Language`(name) VALUES ('Munda languages');
INSERT INTO `Language`(name) VALUES ('Creek');
INSERT INTO `Language`(name) VALUES ('Mirandese');
INSERT INTO `Language`(name) VALUES ('Marwari');
INSERT INTO `Language`(name) VALUES ('Mayan languages');
INSERT INTO `Language`(name) VALUES ('Erzya');
INSERT INTO `Language`(name) VALUES ('Nahuatl languages');
INSERT INTO `Language`(name) VALUES ('North American Indian languages');
INSERT INTO `Language`(name) VALUES ('Neapolitan');
INSERT INTO `Language`(name) VALUES ('Nauru');
INSERT INTO `Language`(name) VALUES ('Navajo; Navaho');
INSERT INTO `Language`(name) VALUES ('Ndebele, South; South Ndebele');
INSERT INTO `Language`(name) VALUES ('Ndebele, North; North Ndebele');
INSERT INTO `Language`(name) VALUES ('Ndonga');
INSERT INTO `Language`(name) VALUES ('Low German; Low Saxon; German, Low; Saxon, Low');
INSERT INTO `Language`(name) VALUES ('Nepali');
INSERT INTO `Language`(name) VALUES ('Nepal Bhasa; Newari');
INSERT INTO `Language`(name) VALUES ('Nias');
INSERT INTO `Language`(name) VALUES ('Niger-Kordofanian languages');
INSERT INTO `Language`(name) VALUES ('Niuean');
INSERT INTO `Language`(name) VALUES ('Norwegian Nynorsk; Nynorsk, Norwegian');
INSERT INTO `Language`(name) VALUES ('Bokmål, Norwegian; Norwegian Bokmål');
INSERT INTO `Language`(name) VALUES ('Nogai');
INSERT INTO `Language`(name) VALUES ('Norse, Old');
INSERT INTO `Language`(name) VALUES ('Norwegian');
INSERT INTO `Language`(name) VALUES ('Pedi; Sepedi; Northern Sotho');
INSERT INTO `Language`(name) VALUES ('Nubian languages');
INSERT INTO `Language`(name) VALUES ('Classical Newari; Old Newari; Classical Nepal Bhasa');
INSERT INTO `Language`(name) VALUES ('Chichewa; Chewa; Nyanja');
INSERT INTO `Language`(name) VALUES ('Nyamwezi');
INSERT INTO `Language`(name) VALUES ('Nyankole');
INSERT INTO `Language`(name) VALUES ('Nyoro');
INSERT INTO `Language`(name) VALUES ('Nzima');
INSERT INTO `Language`(name) VALUES ('Occitan (post 1500); Provençal');
INSERT INTO `Language`(name) VALUES ('Ojibwa');
INSERT INTO `Language`(name) VALUES ('Oriya');
INSERT INTO `Language`(name) VALUES ('Oromo');
INSERT INTO `Language`(name) VALUES ('Osage');
INSERT INTO `Language`(name) VALUES ('Ossetian; Ossetic');
INSERT INTO `Language`(name) VALUES ('Turkish, Ottoman (1500-1928)');
INSERT INTO `Language`(name) VALUES ('Otomian languages');
INSERT INTO `Language`(name) VALUES ('Papuan languages');
INSERT INTO `Language`(name) VALUES ('Pangasinan');
INSERT INTO `Language`(name) VALUES ('Pahlavi');
INSERT INTO `Language`(name) VALUES ('Pampanga; Kapampangan');
INSERT INTO `Language`(name) VALUES ('Panjabi; Punjabi');
INSERT INTO `Language`(name) VALUES ('Papiamento');
INSERT INTO `Language`(name) VALUES ('Palauan');
INSERT INTO `Language`(name) VALUES ('Persian, Old (ca.600-400 B.C.)');
INSERT INTO `Language`(name) VALUES ('Persian');
INSERT INTO `Language`(name) VALUES ('Philippine languages');
INSERT INTO `Language`(name) VALUES ('Phoenician');
INSERT INTO `Language`(name) VALUES ('Pali');
INSERT INTO `Language`(name) VALUES ('Polish');
INSERT INTO `Language`(name) VALUES ('Pohnpeian');
INSERT INTO `Language`(name) VALUES ('Portuguese');
INSERT INTO `Language`(name) VALUES ('Prakrit languages');
INSERT INTO `Language`(name) VALUES ('Provençal, Old (to 1500)');
INSERT INTO `Language`(name) VALUES ('Pushto; Pashto');
INSERT INTO `Language`(name) VALUES ('Reserved for local use');
INSERT INTO `Language`(name) VALUES ('Quechua');
INSERT INTO `Language`(name) VALUES ('Rajasthani');
INSERT INTO `Language`(name) VALUES ('Rapanui');
INSERT INTO `Language`(name) VALUES ('Rarotongan; Cook Islands Maori');
INSERT INTO `Language`(name) VALUES ('Romance languages');
INSERT INTO `Language`(name) VALUES ('Romansh');
INSERT INTO `Language`(name) VALUES ('Romany');
INSERT INTO `Language`(name) VALUES ('Romanian; Moldavian; Moldovan');
INSERT INTO `Language`(name) VALUES ('Rundi');
INSERT INTO `Language`(name) VALUES ('Aromanian; Arumanian; Macedo-Romanian');
INSERT INTO `Language`(name) VALUES ('Russian');
INSERT INTO `Language`(name) VALUES ('Sandawe');
INSERT INTO `Language`(name) VALUES ('Sango');
INSERT INTO `Language`(name) VALUES ('Yakut');
INSERT INTO `Language`(name) VALUES ('South American Indian (Other)');
INSERT INTO `Language`(name) VALUES ('Salishan languages');
INSERT INTO `Language`(name) VALUES ('Samaritan Aramaic');
INSERT INTO `Language`(name) VALUES ('Sanskrit');
INSERT INTO `Language`(name) VALUES ('Sasak');
INSERT INTO `Language`(name) VALUES ('Santali');
INSERT INTO `Language`(name) VALUES ('Sicilian');
INSERT INTO `Language`(name) VALUES ('Scots');
INSERT INTO `Language`(name) VALUES ('Selkup');
INSERT INTO `Language`(name) VALUES ('Semitic languages');
INSERT INTO `Language`(name) VALUES ('Irish, Old (to 900)');
INSERT INTO `Language`(name) VALUES ('Sign Languages');
INSERT INTO `Language`(name) VALUES ('Shan');
INSERT INTO `Language`(name) VALUES ('Sidamo');
INSERT INTO `Language`(name) VALUES ('Sinhala; Sinhalese');
INSERT INTO `Language`(name) VALUES ('Siouan languages');
INSERT INTO `Language`(name) VALUES ('Sino-Tibetan languages');
INSERT INTO `Language`(name) VALUES ('Slavic languages');
INSERT INTO `Language`(name) VALUES ('Slovak');
INSERT INTO `Language`(name) VALUES ('Slovenian');
INSERT INTO `Language`(name) VALUES ('Southern Sami');
INSERT INTO `Language`(name) VALUES ('Northern Sami');
INSERT INTO `Language`(name) VALUES ('Sami languages');
INSERT INTO `Language`(name) VALUES ('Lule Sami');
INSERT INTO `Language`(name) VALUES ('Inari Sami');
INSERT INTO `Language`(name) VALUES ('Samoan');
INSERT INTO `Language`(name) VALUES ('Skolt Sami');
INSERT INTO `Language`(name) VALUES ('Shona');
INSERT INTO `Language`(name) VALUES ('Sindhi');
INSERT INTO `Language`(name) VALUES ('Soninke');
INSERT INTO `Language`(name) VALUES ('Sogdian');
INSERT INTO `Language`(name) VALUES ('Somali');
INSERT INTO `Language`(name) VALUES ('Songhai languages');
INSERT INTO `Language`(name) VALUES ('Sotho, Southern');
INSERT INTO `Language`(name) VALUES ('Spanish; Castilian');
INSERT INTO `Language`(name) VALUES ('Sardinian');
INSERT INTO `Language`(name) VALUES ('Sranan Tongo');
INSERT INTO `Language`(name) VALUES ('Serbian');
INSERT INTO `Language`(name) VALUES ('Serer');
INSERT INTO `Language`(name) VALUES ('Nilo-Saharan languages');
INSERT INTO `Language`(name) VALUES ('Swati');
INSERT INTO `Language`(name) VALUES ('Sukuma');
INSERT INTO `Language`(name) VALUES ('Sundanese');
INSERT INTO `Language`(name) VALUES ('Susu');
INSERT INTO `Language`(name) VALUES ('Sumerian');
INSERT INTO `Language`(name) VALUES ('Swahili');
INSERT INTO `Language`(name) VALUES ('Swedish');
INSERT INTO `Language`(name) VALUES ('Classical Syriac');
INSERT INTO `Language`(name) VALUES ('Syriac');
INSERT INTO `Language`(name) VALUES ('Tahitian');
INSERT INTO `Language`(name) VALUES ('Tai languages');
INSERT INTO `Language`(name) VALUES ('Tamil');
INSERT INTO `Language`(name) VALUES ('Tatar');
INSERT INTO `Language`(name) VALUES ('Telugu');
INSERT INTO `Language`(name) VALUES ('Timne');
INSERT INTO `Language`(name) VALUES ('Tereno');
INSERT INTO `Language`(name) VALUES ('Tetum');
INSERT INTO `Language`(name) VALUES ('Tajik');
INSERT INTO `Language`(name) VALUES ('Tagalog');
INSERT INTO `Language`(name) VALUES ('Thai');
INSERT INTO `Language`(name) VALUES ('Tibetan');
INSERT INTO `Language`(name) VALUES ('Tigre');
INSERT INTO `Language`(name) VALUES ('Tigrinya');
INSERT INTO `Language`(name) VALUES ('Tiv');
INSERT INTO `Language`(name) VALUES ('Tokelau');
INSERT INTO `Language`(name) VALUES ('Klingon; tlhIngan-Hol');
INSERT INTO `Language`(name) VALUES ('Tlingit');
INSERT INTO `Language`(name) VALUES ('Tamashek');
INSERT INTO `Language`(name) VALUES ('Tonga (Nyasa)');
INSERT INTO `Language`(name) VALUES ('Tonga (Tonga Islands)');
INSERT INTO `Language`(name) VALUES ('Tok Pisin');
INSERT INTO `Language`(name) VALUES ('Tsimshian');
INSERT INTO `Language`(name) VALUES ('Tswana');
INSERT INTO `Language`(name) VALUES ('Tsonga');
INSERT INTO `Language`(name) VALUES ('Turkmen');
INSERT INTO `Language`(name) VALUES ('Tumbuka');
INSERT INTO `Language`(name) VALUES ('Tupi languages');
INSERT INTO `Language`(name) VALUES ('Turkish');
INSERT INTO `Language`(name) VALUES ('Altaic languages');
INSERT INTO `Language`(name) VALUES ('Tuvalu');
INSERT INTO `Language`(name) VALUES ('Twi');
INSERT INTO `Language`(name) VALUES ('Tuvinian');
INSERT INTO `Language`(name) VALUES ('Udmurt');
INSERT INTO `Language`(name) VALUES ('Ugaritic');
INSERT INTO `Language`(name) VALUES ('Uighur; Uyghur');
INSERT INTO `Language`(name) VALUES ('Ukrainian');
INSERT INTO `Language`(name) VALUES ('Umbundu');
INSERT INTO `Language`(name) VALUES ('Undetermined');
INSERT INTO `Language`(name) VALUES ('Urdu');
INSERT INTO `Language`(name) VALUES ('Uzbek');
INSERT INTO `Language`(name) VALUES ('Vai');
INSERT INTO `Language`(name) VALUES ('Venda');
INSERT INTO `Language`(name) VALUES ('Vietnamese');
INSERT INTO `Language`(name) VALUES ('Volapük');
INSERT INTO `Language`(name) VALUES ('Votic');
INSERT INTO `Language`(name) VALUES ('Wakashan languages');
INSERT INTO `Language`(name) VALUES ('Walamo');
INSERT INTO `Language`(name) VALUES ('Waray');
INSERT INTO `Language`(name) VALUES ('Washo');
INSERT INTO `Language`(name) VALUES ('Welsh');
INSERT INTO `Language`(name) VALUES ('Sorbian languages');
INSERT INTO `Language`(name) VALUES ('Walloon');
INSERT INTO `Language`(name) VALUES ('Wolof');
INSERT INTO `Language`(name) VALUES ('Kalmyk; Oirat');
INSERT INTO `Language`(name) VALUES ('Xhosa');
INSERT INTO `Language`(name) VALUES ('Yao');
INSERT INTO `Language`(name) VALUES ('Yapese');
INSERT INTO `Language`(name) VALUES ('Yiddish');
INSERT INTO `Language`(name) VALUES ('Yoruba');
INSERT INTO `Language`(name) VALUES ('Yupik languages');
INSERT INTO `Language`(name) VALUES ('Zapotec');
INSERT INTO `Language`(name) VALUES ('Blissymbols; Blissymbolics; Bliss');
INSERT INTO `Language`(name) VALUES ('Zenaga');
INSERT INTO `Language`(name) VALUES ('Standard Moroccan Tamazight');
INSERT INTO `Language`(name) VALUES ('Zhuang; Chuang');
INSERT INTO `Language`(name) VALUES ('Zande languages');
INSERT INTO `Language`(name) VALUES ('Zulu');
INSERT INTO `Language`(name) VALUES ('Zuni');
INSERT INTO `Language`(name) VALUES ('No linguistic content; Not applicable');
INSERT INTO `Language`(name) VALUES ('Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki');
COMMIT;
