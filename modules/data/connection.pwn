/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		connection.pwn
|_______________________________________________________
| DESCRIPTION :
|		* Connect the server to the database
|_______________________________________________________
| NOTE :
|		* It should only contain connection information
|_______________________________________________________*/

#include <YSI\y_hooks>

//--------------------------------------------------------------------------------

new MySQL:db_handle;
static bool:devMode = @gDevMode;

//--------------------------------------------------------------------------------

hook OnGameModeInit()
{
	// Enabling logs if are running in dev mode.
	if(devMode == true){
		mysql_log(ALL);
		print("Server running in development mode.\n");
	}

	db_handle = mysql_connect_file();
	if(mysql_errno(db_handle) != 0)
	{
		printf("[mysql] ERROR: Couldn't connect to the database (%d).", mysql_errno(db_handle));
		SendRconCommand("exit");
	}
	else printf("[mysql] DEBUG: Connected to database successfully (%d).", _:db_handle);
	return 1;
}

hook OnGameModeExit()
{
	if(db_handle) return mysql_close(db_handle);
	return 1;
}