global function FireChat_Init
global function Fire_GetPrefix
global function Fire_SetPrefix
global function Fire_ChatServerPrivateMessage
global function Fire_ChatServerBroadcast

struct
{
    string prefix = "[31m[FIRE][37m"
} SvFire

void function FireChat_Init()
{
    AddCallback_OnReceivedSayTextMessage(OnReceivedSayTextMessage)
}

ClServer_MessageStruct function OnReceivedSayTextMessage(ClServer_MessageStruct message)
{
    entity player = message.player
    if(Fire_IsPlayerAdmin(player))
        return message

    if( !Fire_IsChatEnabled() )
    {
        Fire_ChatServerPrivateMessage( player, "聊天已关闭(仅管理员可发言)" )
        message.shouldBlock = true
        return message
    }
    else if( Fire_IsMutePlayer(player) )
    {
        float endTime = Fire_GetPlayerMuteEndTime(player)
        
        if(endTime == 0)
        {
            Fire_ChatServerPrivateMessage( player, "你已被永久禁言" )
            message.shouldBlock = true
            return message
        }

        float remaining = endTime - Time()
        if(remaining > 0)
        {
            Fire_ChatServerPrivateMessage( player, "你已被禁言，剩余 " + format("%.1f", remaining) + " 秒" )
            message.shouldBlock = true
            return message
        }else
        {
            Fire_UnmutePlayer(player)
        }
    }
    return message
}

string function Fire_GetPrefix()
{
    return SvFire.prefix
}

void function Fire_SetPrefix(string newPrefix)
{
    SvFire.prefix = newPrefix
}

void function Fire_ChatServerPrivateMessage(entity player, string message)
{
    Chat_ServerPrivateMessage( player, SvFire.prefix + message, false, false )
}

void function Fire_ChatServerBroadcast(string message)
{
    Chat_ServerBroadcast( SvFire.prefix + message, false )
}