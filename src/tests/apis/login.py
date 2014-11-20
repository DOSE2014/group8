import http.client

params = """
{
    "email" : "federico@reghe.net",
    "password" : "nonteladico"
}
""";

headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
conn = http.client.HTTPConnection("localhost", 8080)
conn.request("POST", "/account/login", params, headers)
response = conn.getresponse()

print("REPLY HTTP STATUS: ", response.status)
print("HEADERS:")
headers = response.getheaders()
for h in headers:
	print(""+h[0]+": "+h[1])

print("DATA:")
data = response.read()
print(data.decode('utf-8'))
conn.close()
