/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		Adds message functions
|_______________________________________________________
| DESCRIPTION :
|		* This file should only contain message functions.
|_______________________________________________________
| NOTE :
|		* SendClientMessagef
|_______________________________________________________*/

//--------------------------------------------------------------------------------

SendClientMessagef(playerid, color, const message[], va_args<>)
{
   new string[145];
   va_format(string, sizeof(string), message, va_start<3>);
   return SendClientMessage(playerid, color, string);
}

SendClientMessageToAllf(color, const message[], va_args<>)
{
   new string[145];
   va_format(string, sizeof(string), message, va_start<2>);
   return SendClientMessageToAll(color, string);
}
