global function ServerChatCommand_Chat_Init
global function Fire_SetChatEnabled
global function Fire_IsChatEnabled

void function ServerChatCommand_Chat_Init()
{
    AddChatCommandCallback( "/chat",  ServerChatCommand_Chat )
}

void function ServerChatCommand_Chat(entity player, array<string> args)
{
    if( !Fire_IsPlayerAdmin( player ) ){
        Fire_ChatServerPrivateMessage(player, "你没有管理员权限")
        return
    }

    if( args.len() != 1 ){
        Fire_ChatServerPrivateMessage(player, "用法: /chat < on/off >")
        Fire_ChatServerPrivateMessage(player, "状态: " + (Fire_IsChatEnabled() ? "启用" : "禁用"))
        return
    }

    string args0 = args[0].tolower()
    bool isChatEnabled = Fire_IsChatEnabled()

    if( Fire_IsAffirmative(args0) && !isChatEnabled )
    {
        Fire_SetChatEnabled(true)
        Fire_ChatServerBroadcast( "已启用聊天" )
    }
    else if( !Fire_IsAffirmative(args0) && isChatEnabled )
    {
        Fire_SetChatEnabled(false)
        Fire_ChatServerBroadcast( "已禁用聊天" )
    }
}

void function Fire_SetChatEnabled(bool enabled)
{
    SetConVarBool( "Fire_ChatEnabled", enabled )
}

bool function Fire_IsChatEnabled()
{
    return GetConVarBool("Fire_ChatEnabled")
}