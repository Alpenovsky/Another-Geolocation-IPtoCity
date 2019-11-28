#include <sourcemod>
#include <ripext>
#include <csgocolors>

HTTPClient httpClient;

public Plugin myinfo =
{
    name = "AnotherGeolocation",
    author = "Alpen, 13dzielnica.pl",
    description = "Shows geolocation of players",
    version = "1.1",
    url = "13dzielnica.pl"
};

public void OnClientPutInServer(client)
{
    if (IsFakeClient(client)) return;
    char    clientIP[18];
    char    url[256];
    url =   "json/";
    
    GetClientIP(client, clientIP, sizeof(clientIP));
    StrCat(url, 296, clientIP);

    httpClient = new HTTPClient("http://ip-api.com");
    httpClient.Get(url, OnJsonIPReceived, client);
}

public void OnJsonIPReceived(HTTPResponse response, any:client)
{

    if (response.Status != HTTPStatus_OK) {
        // Failed to retrieve json with IP info
        return;
    }
    if (response.Data == null) {
        // Invalid JSON response
        return;
    }
    decl String:name[MAX_NAME_LENGTH+1];
    GetClientName(client, name, sizeof(name));

    JSONObject jsonIPInfo = view_as<JSONObject>(response.Data);

    char country[256];
    char regionName[256];
    char city[256];
    char isp[256];

    jsonIPInfo.GetString("country", country, sizeof(country));
    jsonIPInfo.GetString("regionName", regionName, sizeof(regionName));
    jsonIPInfo.GetString("city", city, sizeof(city));
    jsonIPInfo.GetString("isp", isp, sizeof(isp));

    
    CPrintToChatAll("{darkred}Player {orange}%s {lightgreen}connected", name);
    CPrintToChatAll("{green}*** {darkred}Country: {orange} %s", country);
    CPrintToChatAll("{green}*** {darkred}Region: {orange} %s, %s", regionName, city);
    CPrintToChatAll("{green}*** {darkred}ISP: {orange} %s", isp);
}  