#if SERVER
global function Fire_Init
#endif
global function Fire_IsAffirmative
global function Fire_IsNegative

#if SERVER
void function Fire_Init()
{
    AddCallback_OnClientConnected(OnClientConnected)
}

void function OnClientConnected(entity player)
{
    string announcement = GetConVarString("Fire_Announcement")
    if(announcement != ""){
        Fire_ChatServerPrivateMessage(player, "公告：" + announcement)
    }
}
#endif // SERVER

bool function Fire_IsAffirmative(string input)
{
    string lowerInput = input.tolower()
    
    return ( lowerInput == "on" || lowerInput == "true" || lowerInput == "1" || lowerInput == "yes" || lowerInput == "enable" || lowerInput == "enabled" || lowerInput == "start" )
}

bool function Fire_IsNegative(string input)
{
    string lowerInput = input.tolower()

    return ( lowerInput == "off" || lowerInput == "false" || lowerInput == "0" || lowerInput == "no" || lowerInput == "disable" || lowerInput == "disabled" || lowerInput == "stop" )
}