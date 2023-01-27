#include <sourcemod>
#include <tf2>
#include <tf2_stocks>

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
    // https://wiki.alliedmods.net/Team_Fortress_2_Events
    HookEvent("arena_round_start", OnArenaRoundStart); // When players can move.
    HookEvent("teamplay_round_start", OnRoundStart); // Before players can move (Doesn't affect arena?)
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
    
    if(g_iWarden == 0) { // We check if it's zero, set it to the client index of current warden for easier management.
        g_iWarden = client;
    } else {
        PrintToChat(client, "[SM] Warden is already chosen!");
    }
        
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
    
    if(g_iWarden != client) {
        PrintToChat(client, "[SM] You are not warden!");
    } else {
        g_iWarden = 0;
        PrintToChat(client, "[SM] You have retired from warden.");
    }
    
    return Plugin_Handled;
}

// EVENTS: 

public Action OnArenaRoundStart(Event event, const char[] name, bool dontBroadcast) {
    
    // TODO: Seperate game-mode event calling into seperate files for module management.
    
    
    
}

public Action OnRoundStart(Event event, const char[] name, bool dontBroadcast) {
    
}

// TODO:
/*
DESIGN:
- WHEN ADDING STATE VARIABLES FOR SIMPLE FEATURES, ENFORCE THE USAGE OF SIMILAR OOP PRINCIPLES, DATAPACKS & METHODMAPS.

*/
