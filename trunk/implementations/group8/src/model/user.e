note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

create
	make

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
	programmingLanguages: STRING[]

feature
	make(		i: INTEGER;
			fName, lName: STRING;
			s: SEX;
			doB: DATE;
			cntr, tmzn, eml, pass: STRING;
			usrtp: USERTYPE;
			org: STRING;
			prgmLangs: STRING[]
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
			password := pass
			organization := org
			programmingLanguages := prgmLangs
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
	getPassword: STRING
		do
			--Decryption stuff?
		end
	setPassword(p: STRING)
		do
			--Encryption stuff?
		end
	getOrganization: STRING
		do
			Result := organization
		end
	setOrganization(o: STRING)
		do
			organization := o
		end
	getProgrammingLanguages: STRING[]
		do
			Result := programmingLanguages
		end
	setProgrammingLanguages(p: STRING[])
		do
			programmingLanguages := p
		end
end
