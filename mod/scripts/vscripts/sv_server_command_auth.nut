global function ServerCommandAuth_Init
global function IsServerCommandAuthed

table< string, bool > ServerCommandAuthedPlayers // 记录授权玩家UID
string serverCommandName                         // 随机生成的授权命令名

void function ServerCommandAuth_Init()
{
    int randomCount = RandomInt(20)
    serverCommandName  = "Fire_ServerCommandAuth_"
    for (int i = 0; i < randomCount; i++)
    {
        serverCommandName  += string(RandomInt(1000))
    }
    print("Command: " + serverCommandName )

    AddConsoleCommandCallback(serverCommandName , ServerCommandAuth_CommandCallback)
    AddCallback_OnClientConnected(OnClientConnected)
    AddCallback_OnClientDisconnected(OnClientDisconnected)
}

bool function ServerCommandAuth_CommandCallback(entity player, array<string> args)
{
    string playerUID = player.GetUID()
    if (!(playerUID in ServerCommandAuthedPlayers))
    {
        ServerCommandAuthedPlayers[playerUID] <- true
    }
    return true
}

void function OnClientConnected(entity player)
{
    string playerUID = player.GetUID()
    if (playerUID in ServerCommandAuthedPlayers)
        return
    ClientCommand( player, serverCommandName )
}

void function OnClientDisconnected(entity player)
{
    string playerUID = player.GetUID()
    if (playerUID in ServerCommandAuthedPlayers)
        delete ServerCommandAuthedPlayers[playerUID]
}

bool function IsServerCommandAuthed(entity player)
{
    string playerUID = player.GetUID()
    return (playerUID in ServerCommandAuthedPlayers)
}