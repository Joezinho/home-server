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

#define @sqlhost "127.0.0.1"
#define @sqluser "root"
#define @sqlpass ""
#define @sqldata ""

new mysql;

hook OnGameModeInit()
{	
	mysql = mysql_connect(@sqlhost, @sqluser, @sqlpass, @sqldata);
	return 1;
}

/* Connection established. */