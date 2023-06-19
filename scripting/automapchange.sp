#include <sourcemod>

Handle mapTimer;
ConVar sourceTV;

public Plugin myinfo =
{
	name		=	"Auto Map Change",
	author		=	"Minesettimi",
	description	=	"Auto changes the map after 10 minutes of no activity.",
	version		=	"1.0",
	url			=	""
}

public void OnPluginStart() {
    sourceTV = FindConVar("tv_enable");
}

public void OnMapStart() {
    CreateTimer(30.0, PlayerCheck, 0, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
    mapTimer = INVALID_HANDLE;
}

public void OnMapEnd() {
    mapTimer = INVALID_HANDLE;
}

public Action PlayerCheck(Handle timer, any data) {

    if (GetClientCount(false) > (sourceTV.FloatValue == 0 ? 0 : 1))
    {
        if (mapTimer != INVALID_HANDLE)
        {
            KillTimer(mapTimer, false);
            mapTimer = INVALID_HANDLE;
            PrintToServer("[AutoChange] Player joined, cancelling timer.");
        }
    }
    else
    {
        if (mapTimer == INVALID_HANDLE)
        {
            mapTimer = CreateTimer(600.0, MapChange);
            PrintToServer("[AutoChange] No players, restarting map in 10 minutes.");
        }
    }

    return Plugin_Handled

}

public Action MapChange(Handle time, any data) {
    char map[128];

    GetCurrentMap(map, sizeof(map));

    ServerCommand("changelevel %s", map);

    return Plugin_Handled;
}