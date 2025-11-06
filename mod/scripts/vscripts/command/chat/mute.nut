global function ServerChatCommand_Mute_Init
global function Fire_MutePlayer
global function Fire_UnmutePlayer
global function Fire_IsMutePlayer
global function Fire_GetPlayerMuteEndTime

table< string, float > Mutes = {}

void function ServerChatCommand_Mute_Init()
{
    AddChatCommandCallback( "/mute", ServerChatCommand_Mute )
    AddChatCommandCallback( "/unmute", ServerChatCommand_Unmute )
}

void function ServerChatCommand_Mute(entity player, array<string> args)
{
    if( !Fire_IsPlayerAdmin( player ) )
    {
        Fire_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() < 1 || args.len() > 2){
        Fire_ChatServerPrivateMessage(player, "用法: /mute <玩家名> [时间(秒)]")
        Fire_ChatServerPrivateMessage(player, "不指定时间则永久禁言")
        return
    }
    
    entity target = GetPlayerByNamePrefix(args[0])
    if( !IsValid(target) )
        return
    if( target == player ){
        Fire_ChatServerPrivateMessage(player, "你不能禁言自己")
        return
    }
    if( Fire_IsPlayerAdmin(target) ){
        Fire_ChatServerPrivateMessage(player, "你不能禁言管理员")
        return
    }
    
    if(args.len() == 1){
        Fire_MutePlayer(target, 0)
        Fire_ChatServerPrivateMessage(player, "已永久禁言玩家 " + target.GetPlayerName())
        return
    }
    
    float time = float(args[1])
    if(time <= 0){
        Fire_ChatServerPrivateMessage(player, "禁言时间必须大于0")
        return
    }
        
    Fire_MutePlayer(target, time)
    Fire_ChatServerPrivateMessage(player, "已禁言玩家 " + target.GetPlayerName() + " " + time + " 秒")
}

void function ServerChatCommand_Unmute(entity player, array<string> args)
{
    if( !Fire_IsPlayerAdmin( player ) )
    {
        Fire_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if(args.len() != 1){
        Fire_ChatServerPrivateMessage(player, "用法: /unmute <玩家名>")
        return
    }
    
    entity target = GetPlayerByNamePrefix(args[0])
    if( !IsValid(target) )
        return
    if( !(GetPlayerUID(target) in Mutes) )
        return

    Fire_UnmutePlayer(target)
    Fire_ChatServerPrivateMessage( target, "你已被解除禁言" )
    Fire_ChatServerPrivateMessage( player, "已解除禁言 " + target.GetPlayerName() )
}

void function Fire_MutePlayer( entity player, float time = 0)
{
    string playerName = player.GetPlayerName()
    string playerUID = GetPlayerUID(player)

    if( playerUID in Mutes )
        return
    
    if(time <= 0)
    {
        Mutes[playerUID] <- 0
        Fire_ChatServerPrivateMessage( player, "你已被永久禁言" )
    }
    else
    {
        Mutes[playerUID] <- Time() + time
        Fire_ChatServerPrivateMessage( player, "你已被禁言 " + time + " 秒" )
    }
}

void function Fire_UnmutePlayer( entity player )
{
    string playerUID = GetPlayerUID(player)
    if( playerUID in Mutes )
        delete Mutes[playerUID]
}

bool function Fire_IsMutePlayer(entity player)
{
    if(IsValid(player))
        return false
    return (player.GetUID() in Mutes)
}

float function Fire_GetPlayerMuteEndTime(entity player)
{
    if(IsValid(player))
        return -1.0
    
    string playerUID = player.GetUID()
    
    if(playerUID in Mutes)
        return Mutes[playerUID]
    return -1.0
}