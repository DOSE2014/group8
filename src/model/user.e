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

	make(		id: INTEGER;
			firstName, lastName: STRING;
			sex: SEX;
			dateOfBirth: DATE;
			country, timezone, email, password: STRING;
			userType: USERTYPE;
			organization: STRING;
			programmingLanguages: STRING[]
			)
		do
			Current.id := id
			Current.firstName := firstName
			Current.lastName := lastName
			Current.sex := sex
			Current.dateOfBirth := dateOfBirth
			Current.country := country
			Current.timezone := timezone
			Current.email := email
			Current.password := password
			Current.organization := organization
			Current.programmingLanguages := programmingLanguages
		end

feature
	getId: INTEGER
		do
			Result := Current.id
		end
	setId(i: INTEGER)
		do
			Current.id := i
		end
	getFirstName: STRING
		do
			Result := Current.firstName
		end
	setFirstName(s: STRING)
		do
			Current.firstName := s
		end
	getLastName: STRING
		do
			Result := Current.lastName
		end
	setLastName(s: STRING)
		do
			Current.lastName := s
		end
	getSex: SEX
		do
			Result := Current.sex
		end
	setSex(s: SEX)
		do
			Current.sex := s
		end
	getDateOfBirth: DATE
		do
			Result := Current.dateOfBirth
		end
	setDateOfBirth(d: DATE)
		do
			Current.dateOfBirth := d
		end
	getCountry: STRING
		do
			Result := Current.country
		end
	setCountry(c: STRING)
		do
			Current.country := c
		end
	getTimezone: STRING
		do
			Result := Current.timezone
		end
	setTimezone(t: STRING)
		do
			Current.timezone := t
		end
	getEmail: STRING
		do
			Result := Current.email
		end
	setEmail(e: STRING)
		do
			Current.email := e
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
			Result := Current.organization
		end
	setOrganization(o: STRING)
		do
			Current.organization := o
		end
	getProgrammingLanguages: STRING[]
		do
			Result.make_array
			Result := Current.programmingLanguages
		end
	setProgrammingLanguages(p: STRING[])
		do
			Current.programmingLanguages := p
		end
end
