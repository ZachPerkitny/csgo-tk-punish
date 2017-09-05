#include <sourcemod>
#include <sdktools>

#define PLUGIN_NAME "CSGO Team Kill Manager"
#define PLUGIN_AUTHOR "Zach Perkitny"
#define PLUGIN_DESCRIPTION "Plugin that allows players to punish teamkillers."
#define PLUGIN_VERSION "0.0.1"

#define DEFAULT_TIMER_FLAGS TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE

#define SPRITE_BEAM "sprites/laser.vmt"
#define SPRITE_HALO "sprites/halo01.vmt"
#define SOUND_BLIP "buttons/blip1.wav"
#define SOUND_FREEZE "physics/glass/glass_impact_bullet4.wav"

/* Punish Types */
enum PunishType {
  PunishTypes_Slap,
  PunishTypes_Beacon,
  PunishTypes_Freeze,
  PunishTypes_Burn,
  PunishTypes_Slay
};

/* ConVars
----------------------------- */
/* Slap ConVars */
ConVar g_SlapPunishmentEnabled;
ConVar g_MinTksForSlap;
ConVar g_SlapDamage;
/* Beacon Convars */
ConVar g_BeaconPunishmentEnabled;
ConVar g_MinTksForBeacon;
ConVar g_BeaconTime;
ConVar g_BeaconRadius;
/* Freeze Convars */
ConVar g_FreezePunishmentEnabled;
ConVar g_MinTksForFreeze;
ConVar g_FreezeTime;
/* Burn Convars */
ConVar g_BurnPunishmentEnabled;
ConVar g_MinTksForBurn;
ConVar g_BurnTime;
/* Slay Convars */
ConVar g_SlayPunishmentEnabled;
ConVar g_MinTksForSlay;

/* Client Arrays */
int g_VictimsAttackerClient[MAXPLAYERS + 1];
char g_VictimsAttackerName[MAXPLAYERS + 1][MAX_NAME_LENGTH];
int g_TeamKills[MAXPLAYERS + 1];
int g_ClientFreezeTime[MAXPLAYERS + 1];
int g_ClientBeaconTime[MAXPLAYERS + 1];

/* Model Indexes for temp entities */
int g_BeamSprite;
int g_HaloSprite;

/* Sounds */
bool g_BlipSound;
bool g_FreezeSound;

/* Colors */
int green[4] = {75, 255, 75, 255};

public Plugin myinfo =
{
  name = PLUGIN_NAME,
  author = PLUGIN_AUTHOR,
  description = PLUGIN_DESCRIPTION,
  version = PLUGIN_VERSION
}

public void OnPluginStart()
{
  /* ConVars
  ----------------------------- */
  /* Slap ConVars */
  g_SlapPunishmentEnabled = CreateConVar(
    "tkm_slap_punishment_enabled", "1", "Whether slap is enabled in the punishments menu.", FCVAR_NOTIFY, true, 0.0, true, 1.0
  );
  g_MinTksForSlap = CreateConVar(
    "tkm_min_tks_for_slap", "1", "Minimum tks before a user can be punished with a slap.", FCVAR_NONE, true, 1.0
  );
  g_SlapDamage = CreateConVar(
    "tkm_slap_damage", "15", "Health to Subtract when a user is punished by a slap.", FCVAR_NONE, true, 0.0
  );
  /* Beacon Convars */
  g_BeaconPunishmentEnabled = CreateConVar(
    "tkm_beacon_punishment_enabled", "1", "Whether beacon is enabled in the punishments menu.", FCVAR_NOTIFY, true, 0.0, true, 1.0
  );
  g_MinTksForBeacon = CreateConVar(
    "tkm_min_tks_for_beacon", "1", "Minimum tks before a user can be punished with a beacon.", FCVAR_NONE, true, 1.0
  );
  g_BeaconTime = CreateConVar(
    "tkm_beacon_time", "5", "Time (in seconds) the beaon is active.", FCVAR_NONE, true, 0.0
  );
  g_BeaconRadius = CreateConVar(
    "tkm_beacon_radius", "375", "Sets the radius for the beacons.", FCVAR_NONE, true, 50.0, true, 1500.0
  );
  /* Freeze Convars */
  g_FreezePunishmentEnabled = CreateConVar(
    "tkm_freeze_punishment_enabled", "1", "Whether freeze is enabled in the punishments menu.", FCVAR_NOTIFY, true, 0.0, true, 1.0
  );
  g_MinTksForFreeze = CreateConVar(
    "tkm_min_tks_for_freeze", "2", "Minimum tks before a user can be punished with freeze.", FCVAR_NONE, true, 1.0
  );
  g_FreezeTime = CreateConVar(
    "tkm_freeze_time", "5", "Time (in seconds) the user is frozen for.", FCVAR_NONE, true, 0.0
  );
  /* Burn Convars */
  g_BurnPunishmentEnabled = CreateConVar(
    "tkm_burn_punishment_enabled", "1", "Whether burn is enabled in the punishments menu.", FCVAR_NOTIFY, true, 0.0, true, 1.0
  );
  g_MinTksForBurn = CreateConVar(
    "tkm_min_tks_for_burn", "2", "Minimum tks before a user can be punished with burn.", FCVAR_NONE, true, 1.0
  );
  g_BurnTime = CreateConVar(
    "tkm_burn_time", "5", "Time (in seconds) the user is burned for.", FCVAR_NONE, true, 0.0
  );
  /* Slay Convars */
  g_SlayPunishmentEnabled = CreateConVar(
    "tkm_slay_punishment_enabled", "1", "Whether slay is enabled in the punishments menu.", FCVAR_NOTIFY, true, 0.0, true, 1.0
  );
  g_MinTksForSlay = CreateConVar(
    "tkm_min_tks_for_slay", "3", "Minimum tks before a user can be punished with slay.", FCVAR_NONE, true, 1.0
  );
  /* Events */
  HookEvent("player_death", Event_OnPlayerDeath);
}

/* Set Client Stats to Default on Connect */
public void OnClientConnected(int client)
{
  g_VictimsAttackerClient[client] = -1;
  g_VictimsAttackerName[client] = "";
  g_TeamKills[client] = 0;
  g_ClientFreezeTime[client] = 0;
}

/* cache models and sounds */
public void OnMapStart()
{
  g_BlipSound = PrecacheSound(SOUND_BLIP);
  g_FreezeSound = PrecacheSound(SOUND_FREEZE);
  g_BeamSprite = PrecacheModel(SPRITE_BEAM);
  g_HaloSprite = PrecacheModel(SPRITE_HALO);
}

public void Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
  int victim = GetClientOfUserId(event.GetInt("userid"));
  int attacker = GetClientOfUserId(event.GetInt("attacker"));
  if(victim && attacker) // ensure both are valid clients
  {
    int victim_team = GetClientTeam(victim);
    int attacker_team = GetClientTeam(attacker);
    /* if friendly fire */
    if(victim_team == attacker_team)
    {
      /* Update Attacker's Team Kills and set the victim's attacker */
      GetClientName(attacker, g_VictimsAttackerName[victim], MAX_NAME_LENGTH);
      g_VictimsAttackerClient[victim] = attacker;
      g_TeamKills[attacker]++;
      /* Show Team Kill Selection Menu */
      ShowTeamKillSelectionMenu(victim);
    }
  }
}

public int Handle_TeamKillSelectionMenu(Menu menu, MenuAction action, int client, int option)
{
  if(action == MenuAction_Select)
  {
      char name[MAX_NAME_LENGTH];
      strcopy(name, sizeof(name), g_VictimsAttackerName[client]);
      if(option == 0) { // forgive
        PrintToChatAll("[TKM] %s has been forgiven for the team kill.", name);
      } else if(option == 1) // punish
      {
        PrintToChatAll("[TKM] %s will be punished for team killing!", name);
        /* Show Team Kill Punishment Menu */
        ShowTeamKillPunishmentMenu(client);
      }
  } else if(action == MenuAction_End)
  {
    delete menu;
  }
}

public int Handle_TeamKillPunishmentMenu(Menu menu, MenuAction action, int client, int option)
{
  if(action == MenuAction_Select)
  {
      char name[MAX_NAME_LENGTH];
      strcopy(name, sizeof(name), g_VictimsAttackerName[client]);
      int attacker = g_VictimsAttackerClient[client];
      char info[32];
      PunishType type;
      /* get punishment type */
      menu.GetItem(option, info, sizeof(info));
      type = view_as<PunishType>(StringToInt(info));
      switch(type){
        case PunishTypes_Slap:
        {
          int damage = g_SlapDamage.IntValue;
          SlapPlayer(attacker, damage, true);
          PrintToChatAll("[TKM] %s has been slapped for %d damage!", name, damage);
        }
        case PunishTypes_Beacon:
        {
          int time = g_BeaconTime.IntValue;
          CreateBeacon(attacker, time);
          PrintToChatAll("[TKM] %s has a beacon activated for %d seconds!", name, time);
        }
        case PunishTypes_Freeze:
        {
          int time = g_FreezeTime.IntValue;
          FreezePlayer(attacker, time);
          PrintToChatAll("[TKM] %s has been frozen for %d seconds!", name, time);
        }
        case PunishTypes_Burn:
        {
          float time = g_BurnTime.FloatValue;
          IgniteEntity(attacker, time);
          PrintToChatAll("[TKM] %s has been set on fire for %d seconds!", name, g_BurnTime.IntValue);
        }
        case PunishTypes_Slay:
        {
          ForcePlayerSuicide(attacker);
          PrintToChatAll("[TKM] %s has been slayed!", name);
        }
      }

  } else if(action == MenuAction_End)
  {
    delete menu;
  }
}

void ShowTeamKillSelectionMenu(int client)
{
  char name[MAX_NAME_LENGTH];
  strcopy(name, sizeof(name), g_VictimsAttackerName[client]);
  /* Display Menu  */
  Menu menu = new Menu(Handle_TeamKillSelectionMenu);
  menu.SetTitle("Decide %s's fate:", name);
  menu.AddItem("forgive", "Forgive Them");
  menu.AddItem("punish", "Punish Them");
  menu.ExitButton = false;
  menu.Display(client, 20);
}

void ShowTeamKillPunishmentMenu(int client)
{
  /* Get Attacker's Client Name */
  char name[MAX_NAME_LENGTH];
  strcopy(name, sizeof(name), g_VictimsAttackerName[client]);
  /* get attacker */
  int attacker = g_VictimsAttackerClient[client];
  /* get total number of team damage for client */
  int team_kills = g_TeamKills[attacker];
  /* Display menu */
  Menu menu = new Menu(Handle_TeamKillPunishmentMenu);
  menu.SetTitle("Select a punishment for %s:", name);
  if(g_SlapPunishmentEnabled.BoolValue &&
    team_kills >= g_MinTksForSlap.IntValue)
  {
    menu.AddItem("0", "Slap");
  }
  if(g_BeaconPunishmentEnabled.BoolValue &&
    team_kills >= g_MinTksForBeacon.IntValue)
  {
    menu.AddItem("1", "Beacon");
  }
  if(g_FreezePunishmentEnabled.BoolValue &&
    team_kills >= g_MinTksForFreeze.IntValue)
  {
    menu.AddItem("2", "Freeze");
  }
  if(g_BurnPunishmentEnabled.BoolValue &&
    team_kills >= g_MinTksForBurn.IntValue)
  {
    menu.AddItem("3", "Burn");
  }
  if(g_SlayPunishmentEnabled.BoolValue &&
    team_kills >= g_MinTksForSlay.IntValue)
  {
    menu.AddItem("4", "Slay");
  }
  menu.ExitButton = false;
  menu.Display(client, 20);
}

void CreateBeacon(int client, int time)
{
  g_ClientBeaconTime[client] = time;
  CreateTimer(1.0, Timer_Beacon, client, DEFAULT_TIMER_FLAGS);
}

public Action Timer_Beacon(Handle timer, any client)
{
  if(!IsClientInGame(client) ||
    !IsPlayerAlive(client) ||
    g_ClientBeaconTime[client] == 0)
  {
      return Plugin_Stop;
  }

  float vec[3];
  GetClientAbsOrigin(client, vec);
  vec[2] += 10;
  /* Broadcast Temp Entity to all clients */
  if(g_BeamSprite && g_HaloSprite)
  {
    TE_SetupBeamRingPoint(vec, 10.0, g_BeaconRadius.FloatValue, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, green, 10, 0);
    TE_SendToAll();
  }
  /* Emit Blip Sound */
  if(g_BlipSound)
  {
    GetClientEyePosition(client, vec);
    EmitAmbientSound(SOUND_BLIP, vec, client, SNDLEVEL_RAIDSIREN);
  }
  g_ClientBeaconTime[client]--;
  return Plugin_Continue;
}

void FreezePlayer(int client, int time)
{
  SetEntityMoveType(client, MOVETYPE_NONE);
  SetEntityRenderColor(client, 0, 128, 255, 192);
  if(g_FreezeSound)
  {
    float vec[3];
    GetClientEyePosition(client, vec);
    EmitAmbientSound(SOUND_FREEZE, vec, client, SNDLEVEL_RAIDSIREN);
  }
  g_ClientFreezeTime[client] = time;
  CreateTimer(1.0, Timer_Freeze, client, DEFAULT_TIMER_FLAGS);
}

void UnFreezePlayer(int client)
{
  SetEntityMoveType(client, MOVETYPE_WALK);
  SetEntityRenderColor(client, 255, 255, 255, 255);
}

public Action Timer_Freeze(Handle timer, any client)
{
  if(!IsClientInGame(client) ||
    !IsPlayerAlive(client) ||
    g_ClientFreezeTime[client] == 0)
  {
      UnFreezePlayer(client);
      return Plugin_Stop;
  }
  g_ClientFreezeTime[client]--;
  return Plugin_Continue;
}
