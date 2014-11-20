import http.client

params = """
{
    "email" : "federico@reghe.net",
    "firstname" : "Federico",
    "lastname" : "Reghenzani",
    "country" : "Italy",
    "sex" : "M",
    "timezone" : "Europe/Rome",
    "type" : "developer",
    "password" : "nonteladico",
    "dateOfBirth" : "1992-07-06",
    "organization" : "Politecnico di Milano",
    "languages" : [ "Italian", "English" ],
    "programmingLanguages" : [ "C++", "PHP"] 
}
""";

headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
conn = http.client.HTTPConnection("localhost", 8080)
conn.request("POST", "/account/register", params, headers)
response = conn.getresponse()

print("REPLY HTTP STATUS: ", response.status)
data = response.read()
print(data)
conn.close()
