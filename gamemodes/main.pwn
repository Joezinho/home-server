/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		main.pwn
|_______________________________________________________
| DESCRIPTION :
|		* Coupling of all modules and definition of values.
|_______________________________________________________
| NOTE :
|		* This file should not contain game or other scripts.
|		* This file should only have module coupling and values definition.
|_______________________________________________________*/

#include <a_samp>

//--------------------------------------------------------------------------------

#define SCRIPT_VERSION_MAJOR		"0"
#define SCRIPT_VERSION_MINOR		"0"
#define SCRIPT_VERSION_PATH			"1"
#define SCRIPT_VERSION_NAME			"HP"

//--------------------------------------------------------------------------------

// Undefining samp's default values (500)
#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif
#define MAX_PLAYERS 90

//--------------------------------------------------------------------------------

// Libraries
#include <a_mysql>


//--------------------------------------------------------------------------------

// Modules
#include "../modules/data/connection.pwn"

//--------------------------------------------------------------------------------