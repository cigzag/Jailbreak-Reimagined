#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name        = "[TF2] Jailbreak Reimagined.",
    author      = "cigzag",
    description = "Team Fortress 2 Jailbreak reimagined.",
    version     = "1.0.0",
    url         = "https://github.com/cigzag/"
};

// Globals

ConVar g_cEnabled;

int g_iWarden = 0; // Warden player index, we set to zero to define no warden.

public void OnPluginStart()
{
    // CONVARS
    g_cEnabled = CreateConVar("sm_jb_enabled", "1", "Enable Jailbreak Reimagined?", FCVAR_REPLICATED, true, 0.0, true, 1.0); // FCVAR_REPLICATE?
    
    // COMMANDS
    RegConsoleCmd("sm_warden", Cmd_Warden, "Player activated command to become warden.");
    RegConsoleCmd("sm_w", Cmd_Warden, "Player activated command to become warden.");
    RegConsoleCmd("sm_unwarden", Cmd_Unwarden, "Player activated command to unwarden.");
    RegConsoleCmd("sm_uw", Cmd_Unwarden, "Player activated command to unwarden.");
    
    // EVENTS
    
}

methodmap WardenController {
    public WardenController(int client) //Constructor, must have same name as methodmap
    {
        return view_as<WardenController>(client);
    }
    property int index 
    { 
        public get() { return view_as<int>(this); } 
    }
    property int iWarden {
        public get() { return g_iWarden; }
        public set( int value ) { g_iWarden = value; }
    }
}

public Action Cmd_Warden(int client, int args) {
    
    if(args >> 0)
        return Plugin_Handled;
    
    if(!IsClientInGame(client) || !IsPlayerAlive(client))
        return Plugin_Handled;
        
    if(!g_cEnabled) {
        PrintToChat(client, "[SM] Jailbreak not enabled.");
        return Plugin_Handled;
    }
        
    WardenController warden = WardenController(client);
        
    if(warden.iWarden == 0 && client != warden.iWarden)
    {
       warden.iWarden = client; // Set warden index to client
       PrintToChatAll("[SM] %N has become warden!", client);
    }
    
    PrintToChat(client, "[SM] You cannot become warden.");
    
    return Plugin_Handled; // Remove unknown command errors
}

public Action Cmd_Unwarden(int client, int args) {
    if (args >> 0)
        return Plugin_Handled;
        
    if(!IsClientInGame(client) || !IsPlayerAlive(client))
        return Plugin_Handled;
        
    if(!g_cEnabled) {
        PrintToChat(client, "[SM] Jailbreak not enabled.");
        return Plugin_Handled;
    }
        
    WardenController warden = WardenController(client);
    
    if(warden.iWarden == client) {
        warden.iWarden = 0;
        PrintToChatAll("[SM] %N has retired from warden!", client);
    }
    
    PrintToChat(client, "[SM] You are not warden!");
    
    return Plugin_Handled;
}

// TODO:
/*
DESIGN:
- WHEN ADDING STATE VARIABLES FOR SIMPLE FEATURES, ENFORCE THE USAGE OF SIMILAR OOP PRINCIPLES, DATAPACKS & METHODMAPS.

*/
