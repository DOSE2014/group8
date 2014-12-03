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
	sex: INTEGER -- See SEX class
	dateOfBirth: DATE_TIME
	country: STRING
	timezone: STRING
	email: STRING
	password: STRING
	userType: INTEGER -- See USERTYPE class
	organization: detachable STRING
	deleted: BOOLEAN
	programmingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
	languages: LINKED_SET[LANGUAGE]

feature
	make(
			i: INTEGER;
			fName, lName: STRING;
			s: INTEGER;
			doB: DATE_TIME;
			cntr, tmzn, eml, pass: STRING;
			usrtp: INTEGER;
			org: STRING;
			prgmLangs: LINKED_SET[PROGRAMMING_LANGUAGE]
			langs: LINKED_SET[LANGUAGE]
			)
		require
			s={SEX}.male or s={SEX}.female
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
			usertype := usrtp
			organization := org
			programmingLanguages := prgmLangs
			languages := langs
		end

	make_without_langs(
				i: INTEGER;
				fName, lName: STRING;
				s: INTEGER;
				doB: DATE_TIME;
				cntr, tmzn, eml, pass: STRING;
				usrtp: INTEGER;
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
			usertype := usrtp
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
	getSex: INTEGER
		do
			Result := sex
		end
	setSex(s: INTEGER)
		do
			sex := s
		end
	getDateOfBirth: DATE_TIME
		do
			Result := dateOfBirth
		end
	setDateOfBirth(d: DATE_TIME)
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
			hashedString : STRING
		do
			-- Convert a string to SHA1 hash
			create hashEngine.make
			hashEngine.update_from_string(p)
			hashedString := hashEngine.digest_as_string
			hashedString.to_lower	 -- Manitain lowercase hex
			Result := hashedstring
		end
	getUserType: INTEGER
		do
			Result := usertype
		end
	setUserType(u: INTEGER)
		do
			usertype := u
		end
	getOrganization: STRING
		do
			Result := organization
		end
	setOrganization(o: STRING)
		do
			organization := o
		end
	isDeleted: BOOLEAN
		do
			Result := deleted
		end
	setDeleted(d: BOOLEAN)
		do
			deleted := d
		end
	getProgrammingLanguages: LINKED_SET[PROGRAMMING_LANGUAGE]
		do
			Result := programmingLanguages
		end
	setProgrammingLanguages(p: LINKED_SET[PROGRAMMING_LANGUAGE])
		do
			programmingLanguages := p
		end
	getLanguages: LINKED_SET[LANGUAGE]
		do
			Result := languages
		end
	setLanguages(l: LINKED_SET[LANGUAGE])
		do
			languages := l
		end

	to_minimal_json : JSON_OBJECT
	require
		getid /= 0
	do
		create Result.make
		Result.put_integer(id, "id")
		Result.put_string (firstname, "firstname")
		Result.put_string (lastname, "lastname")
	end

	to_json : JSON_OBJECT
	require
		-- user must be loaded to generate json
		getid /= 0
	local
		epoch: DATE_TIME
		sex_class : SEX
		ut_class : USERTYPE
		plangs: JSON_ARRAY
		langs: JSON_ARRAY
	do
		create sex_class
		create ut_class
		create plangs.make_array
		create langs.make_array

		if userType = ut_class.developer then
			across  programminglanguages as pl
			loop
				plangs.add (create {JSON_STRING}.make_json(pl.item.getName))
			end
		end

		across languages as l
		loop
			langs.add(create {JSON_STRING}.make_json(l.item.getName))
		end


		create epoch.make_from_epoch (0)
		create Result.make
		Result.put_integer(id, "id")
		Result.put_string (firstname, "firstname")
		Result.put_string (lastname, "lastname")
		Result.put_string (sex_class.to_string(sex), "sex")
		Result.put_integer(dateOfBirth.definite_duration (epoch).seconds_count, "dateOfBirth")
		Result.put_string (country, "country")
		Result.put_string (timezone, "timezone")
		Result.put_string (ut_class.to_string(userType), "userType")
		if organization /= Void then
			Result.put_string (organization, "organization")
		end
		Result.put_string (email, "email")
		if plangs /= Void then
			Result.put(plangs, "programmingLanguages")
		end
		Result.put(langs, "languages")
	end
end
