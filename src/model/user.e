note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

create
	make,
	make_without_langs,
	make_default

feature{NONE}
	id: INTEGER
	firstName: STRING
	lastName: STRING
	sex: SEX
	dateOfBirth: DATE
	country: STRING
	timezone: STRING
	email: STRING
	password: STRING
	userType: USERTYPE
	organization: STRING
	programmingLanguages: SET[STRING]
	languages: SET[STRING]

feature
	make(
			i: INTEGER;
			fName, lName: STRING;
			s: SEX;
			doB: DATE;
			cntr, tmzn, eml, pass: STRING;
			usrtp: USERTYPE;
			org: STRING;
			prgmLangs: SET[STRING]
			langs: SET[STRING]
			)
		do
			id := i
			firstName := fName
			lastName := lName
			sex := s
			dateOfBirth := doB
			country := cntr
			timezone := tmzn
			email := eml
			password := passHash(pass)
			organization := org
			programmingLanguages := prgmLangs
			languages := langs
		end

	make_without_langs(
				i: INTEGER;
				fName, lName: STRING;
				s: SEX;
				doB: DATE;
				cntr, tmzn, eml, pass: STRING;
				usrtp: USERTYPE;
				org: STRING;
				)
		do
			id := i
			firstName := fName
			lastName := lName
			sex := s
			dateOfBirth := doB
			country := cntr
			timezone := tmzn
			email := eml
			password := passHash(pass)
			organization := org
		end

	make_default
		do
		end

feature
	getId: INTEGER
		do
			Result := id
		end
	setId(i: INTEGER)
		do
			id := i
		end
	getFirstName: STRING
		do
			Result := firstName
		end
	setFirstName(s: STRING)
		do
			firstName := s
		end
	getLastName: STRING
		do
			Result := lastName
		end
	setLastName(s: STRING)
		do
			lastName := s
		end
	getSex: SEX
		do
			Result := sex
		end
	setSex(s: SEX)
		do
			sex := s
		end
	getDateOfBirth: DATE
		do
			Result := dateOfBirth
		end
	setDateOfBirth(d: DATE)
		do
			dateOfBirth := d
		end
	getCountry: STRING
		do
			Result := country
		end
	setCountry(c: STRING)
		do
			country := c
		end
	getTimezone: STRING
		do
			Result := timezone
		end
	setTimezone(t: STRING)
		do
			timezone := t
		end
	getEmail: STRING
		do
			Result := email
		end
	setEmail(e: STRING)
		do
			email := e
		end
	getPasswordHash: STRING
		do
			-- Return hash of the string
			Result := password
		end

	checkPassword(p : STRING) : BOOLEAN
		do
			Result := password = passHash(p)
		end

	setPassword(p: STRING)
			-- convert immediatly the password to hash
		do
			password := passHash(p)
		end

	passHash(p : STRING) : STRING
		local
			hashEngine : SHA1
		do
			-- Convert a string to SHA1 hash
			create hashEngine.make
			hashEngine.update_from_string(p)
			Result := hashEngine.digest_as_string
		end
	getOrganization: STRING
		do
			Result := organization
		end
	setOrganization(o: STRING)
		do
			organization := o
		end
	getProgrammingLanguages: SET[STRING]
		do
			Result := programmingLanguages
		end
	setProgrammingLanguages(p: SET[STRING])
		do
			programmingLanguages := p
		end
end
