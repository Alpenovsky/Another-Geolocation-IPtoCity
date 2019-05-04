#include <sourcemod>
#include <system2>
#include <csgocolors>
#include <regex>

char clientIP[18];

public void OnPluginStart() {

}

public void OnClientPutInServer(client)
{
    
    CreateTimer(1.0, OnCommand, client);
    
}

public Action OnCommand(Handle timer, any client) {
    GetClientIP(client, clientIP, sizeof(clientIP));
    
    new String:player_authid[32];
    GetClientAuthId(client, AuthId_Steam2, player_authid, sizeof(player_authid));
    
    char url[256];
    url = "http://185.25.149.88/ip.php?ip=";
    StrCat(url, 296, clientIP);
   // PrintToChat(client, "%s", url);
    //GetCmdArg(1, url, sizeof(url));

    PrintToServer("");
    PrintToServer("INFO: Retrieve URL %s", url);

    System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallback, url);
    httpRequest.Any = client;
    httpRequest.Timeout = 30;
    httpRequest.GET();
    delete httpRequest;

    return Plugin_Handled;
}


void HttpResponseCallback(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method) {
    char url[256];
 //   char country[256];
 //   char region[256];
 //   char isp[256];
    char xregion[256];
    char xisp[256];
    request.GetURL(url, sizeof(url));

    if (!success) {
        PrintToServer("ERROR: Couldn't retrieve URL %s. Error: %s", url, error);
        PrintToServer("");
        PrintToServer("INFO: Finished");
        PrintToServer("");

        return;
    }

    response.GetLastURL(url, sizeof(url));

    PrintToServer("INFO: Successfully retrieved URL %s in %.0f milliseconds", url, response.TotalTime * 1000.0);
    PrintToServer("");
    PrintToServer("INFO: HTTP Version: %s", (response.HTTPVersion == VERSION_1_0 ? "1.0" : "1.1"));
    PrintToServer("INFO: Status Code: %d", response.StatusCode);
    PrintToServer("INFO: Downloaded %d bytes with %d bytes/seconds", response.DownloadSize, response.DownloadSpeed);
    PrintToServer("INFO: Uploaded %d bytes with %d bytes/seconds", response.UploadSize, response.UploadSpeed);
    PrintToServer("");
    PrintToServer("INFO: Retrieved the following headers:");

    char name[128];
    char value[128];
    ArrayList headers = response.GetHeaders();

    for (int i = 0; i < headers.Length; i++) {
        headers.GetString(i, name, sizeof(name));
        response.GetHeader(name, value, sizeof(value));
        PrintToServer("\t%s: %s", name, value);
    }
    
    PrintToServer("");
    PrintToServer("INFO: Content (%d bytes):", response.ContentLength);
    PrintToServer("");
    char player_name[MAX_NAME_LENGTH];
    char content[128];
    for (int found = 0; found < response.ContentLength;) {
        found += response.GetContent(content, sizeof(content), found);
        PrintToServer(content);
    }
    GetClientName(request.Any, player_name, sizeof(player_name));
    PrintToServer("");
    PrintToServer("INFO: Finished");
    PrintToServer("");

    Regex regex = CompileRegex("<region>(.*?)</region>");
   // region = CompileRegex("<ip>(.*?)</ip>");
   // isp = CompileRegex("<ip>(.*?)</ip>");


   regex.Match(content);
    
    //PrintToServer("numMatch : %d", numMatched);
    regex.GetSubString(1, xregion, 256);
  //  PrintToChatAll("TEST ====> %s,", xregion);

/**/
    Regex regex2 = CompileRegex("<ip>(.*?)</ip>");
   // region = CompileRegex("<ip>(.*?)</ip>");
   // isp = CompileRegex("<ip>(.*?)</ip>");


    regex2.Match(content);
    //PrintToServer("numMatch : %d", numMatched);
    regex2.GetSubString(1, xisp, 256);
    PrintToChatAll("TEST2 ====> %s, %s", xisp, xregion);
    delete headers;
}
