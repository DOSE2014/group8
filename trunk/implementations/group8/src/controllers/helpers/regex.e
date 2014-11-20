note
	description: "Summary description for {REGEX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REGEX

create
	make

feature{NONE}

	regex_mail : STRING = "([-!#-'*+-9=?A-Z^-~]+(\.[-!#-'*+-9=?A-Z^-~]+)*|%"([]!#-[^-~ \t]|(\\[\t -~]))+%")@([0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)*|\[((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}|IPv6:((((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){6}|::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){5}|[0-9A-Fa-f]{0,4}::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){4}|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):)?(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){3}|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,2}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){2}|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,3}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,4}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::)((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3})|(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3})|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,5}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3})|(((0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}):){0,6}(0|[1-9A-Fa-f][0-9A-Fa-f]{0,3}))?::)|(?!IPv6:)[0-9A-Za-z-]*[0-9A-Za-z]:[!-Z^-~]+)])";
	regex_mail_obj : RX_PCRE_REGULAR_EXPRESSION
	once
		create Result.make
		Result.compile(regex_mail)
	end

	regex_name : STRING = "[- 'a-zA-Z0-9]{3,50}"
	regex_name_obj : RX_PCRE_REGULAR_EXPRESSION
	once
		create Result.make
		Result.compile(regex_name)
	end

	regex_timezone : STRING = "([A-Z][A-Za-z]+\/[A-Za-z_-]+(\/[A-Za-z_-]+)?)|(UTC)|(W-SU)|(Zulu)"
	regex_timezone_obj : RX_PCRE_REGULAR_EXPRESSION
	once
		create Result.make
		Result.compile(regex_timezone)
	end

	-- source : http://www.pelagodesign.com/blog/2009/05/20/iso-8601-date-validation-that-doesnt-suck/
	regex_date_iso8601 : STRING = "([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?"
	regex_date_iso8601_obj : RX_PCRE_REGULAR_EXPRESSION
	once
		create Result.make
		Result.compile(regex_date_iso8601)
	end

	make
	do

	end

feature
	check_email(s : STRING) : BOOLEAN
	do
		if (s /= Void) then
			Result := regex_mail_obj.recognizes(s)
		else
			Result := False
		end
	end

	check_name(s : STRING) : BOOLEAN
	do
		if (s /= Void) then
			Result := regex_name_obj.recognizes(s)
		else
			Result := False
		end
	end

	check_timezone(s : STRING) : BOOLEAN
	do
		if (s /= Void) then
			Result := regex_timezone_obj.recognizes(s)
		else
			Result := False
		end
	end

	check_date_iso8601(s : STRING) : BOOLEAN
	do
		if (s /= Void) then
			Result := regex_date_iso8601_obj.recognizes(s)
		else
			Result := False
		end
	end

end


