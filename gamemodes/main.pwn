/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		main.pwn
|_______________________________________________________
| DESCRIPTION :
|		* Indexing the modules and setting values
|_______________________________________________________
| NOTE :
|		* This file is for linking files only.
|		* Should not be used to create systems
|_______________________________________________________*/

#include <a_samp>

//--------------------------------------------------------------------------------

// Development mode
#define @gDevMode true

// Script versioning
#define SCRIPT_VERSION_NAME								"ML" // Modern Life
#define SCRIPT_VERSION_MAJOR							"0"	
#define SCRIPT_VERSION_MINOR							"0"
#define SCRIPT_VERSION_PATCH							"1"

//--------------------------------------------------------------------------------

#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS 90

//--------------------------------------------------------------------------------

#define MAX_PLAYER_PASSWORD								65

#define LAST_POSITION									0

//--------------------------------------------------------------------------------

#define COLOR_SELECTION									0xff632bff

#define COLOR_SUCCESS									0x16a085ff
#define COLOR_WARNING									0x079992ff
#define COLOR_ERROR										0x990626ff
#define COLOR_INFO										0xd63939ff

//--------------------------------------------------------------------------------

// Libraries
#include <crashdetect>
#include <a_mysql>
#include <YSI\y_hooks>
#include <YSI\y_va>
#include <YSI\y_timers>
#include <sscanf2>
#include <util>

//--------------------------------------------------------------------------------

hook OnGameModeInit()
{
	// Gamemode start message
	printf("\n\n============================================================\n");
	printf("Iniciando %s %s.%s%s...\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	
	// Set the gamemode name to the current version
	new rcon_command[32];
	format(rcon_command, sizeof(rcon_command), "gamemodetext %s %s.%s%s", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	SendRconCommand(rcon_command);
	return 1;
}

//--------------------------------------------------------------------------------

// Modules

/* Server */
#include "../modules/data/connection.pwn"

/* Defs */
#include "../modules/def/dialogs.pwn"
#include "../modules/def/messages.pwn"

/* Data */
#include "../modules/data/player.pwn"

/* Visual */
#include "../modules/visual/dashboard.pwn"

//--------------------------------------------------------------------------------

main()
{
	printf("\n\n%s %s.%s%s iniciado.\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	printf("============================================================\n");
}