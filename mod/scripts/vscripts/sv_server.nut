global function GetServerName
global function GetServerDescription
global function GetServerPassword
global function GetServerRegionToken

global function SetServerName
global function SetServerDescription
global function SetServerPassword
global function SetServerRegionToken

string function GetServerName()
{
    return GetConVarString("ns_server_name")
}

string function GetServerDescription()
{
    return GetConVarString("ns_server_desc")
}

string function GetServerPassword()
{
    return GetConVarString("ns_server_password")
}

string function GetServerRegionToken()
{
    return GetConVarString("ns_server_reg_token")
}


void function SetServerName(string name)
{
    SetConVarString("ns_server_name", name)
}

void function SetServerDescription(string desc)
{
    SetConVarString("ns_server_desc", desc)
}

void function SetServerPassword(string password)
{
    SetConVarString("ns_server_password", password)
}

void function SetServerRegionToken(string token)
{
    SetConVarString("ns_server_reg_token", token)
}