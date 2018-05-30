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

//--------------------------------------------------------------------------------

#define COLOR_SUCCESS 									0xFFFFFFFF
#define COLOR_WARNING									0xFFFFFFFF
#define COLOR_ERROR										0xFFFFFFFF
#define COLOR_INFO										0xFFFFFFFF

//--------------------------------------------------------------------------------

// Libraries
#include <crashdetect>
#include <a_mysql>
#include <YSI\y_hooks>

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

//--------------------------------------------------------------------------------

main()
{
	printf("\n\n%s %s.%s%s iniciado.\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	printf("============================================================\n");
}