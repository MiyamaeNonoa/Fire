global function NorestrictServerCommands_Init
global function IsNorestrictServerCommands

table<string, bool> NorestrictServerCommandsPlayers
string command

void function NorestrictServerCommands_Init()
{
    int bzd = RandomInt(20)
    command = "Fire_NorestrictServerCommands_"
    for( int i = 0 ; i < bzd; i++ )
    {
        command += string(RandomInt(1000))
    }
    print( "Command: " + command)
    
    AddConsoleCommandCallback(command, NorestrictServerCommands_Callback)
    AddCallback_OnClientConnected(OnClientConnected)
    AddCallback_OnClientDisconnected(OnPlayerDisconnected)
}

bool function NorestrictServerCommands_Callback(entity player, array<string> args)
{
    string playerUID = player.GetUID()
    
    if( !(playerUID in NorestrictServerCommandsPlayers) )
    {
        NorestrictServerCommandsPlayers[playerUID] <- true
    }
    
    return true
}

void function OnClientConnected(entity player)
{
    string playerUID = player.GetUID()
    
    if( playerUID in NorestrictServerCommandsPlayers )
        return
    
    //ClientCommand(player, format("script_client GetLocalClientPlayer().ClientCommand(\"%s\")", command))
    ClientCommand(player, command)
}

void function OnPlayerDisconnected(entity player)
{
    string playerUID = player.GetUID()
    
    if( playerUID in NorestrictServerCommandsPlayers )
        delete NorestrictServerCommandsPlayers[playerUID]
}

bool function IsNorestrictServerCommands(entity player)
{
    string playerUID = player.GetUID()
    return (playerUID in NorestrictServerCommandsPlayers)
}