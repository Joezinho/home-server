/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		dashboard.pwn
|_______________________________________________________
| DESCRIPTION :
|		* Apply visual textdraws to dashboard
|_______________________________________________________
| NOTE :
|		* This file should be changed only for textdraw codes
|_______________________________________________________*/

#include <YSI\y_hooks>

//--------------------------------------------------------------------------------

#define DIALOG_REGISTER_PRIMARY						DIALOG_REGISTER_EMAIL

#define pTD_LOGIN									5
#define pTD_REGISTER								6				
#define pTD_CREDITS									7
#define pTD_EXIT									8

//--------------------------------------------------------------------------------

static PlayerText:gptDashboard[MAX_PLAYERS][9];
static bool:dashIsVisible[MAX_PLAYERS];
static bool:backIsVisible[MAX_PLAYERS];

//--------------------------------------------------------------------------------

loadDashboard(playerid)
{
	if(dashIsVisible[playerid])
		return 1;
	dashIsVisible[playerid] = true;
	backIsVisible[playerid] = false;

	gptDashboard[playerid][0] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "mdl-1001:mirror01");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][0], 647.000000, 448.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][0], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][0], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][0], 0);

	gptDashboard[playerid][1] = CreatePlayerTextDraw(playerid, 275.000000, 80.000000, "mdl-1001:dash_text");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][1], 100.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][1], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][1], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][1], 0);

	gptDashboard[playerid][2] = CreatePlayerTextDraw(playerid, 275.000000, 125.000000, "mdl-1001:white_ret");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][2], 100.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][2], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][2], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][2], 0);

	gptDashboard[playerid][3] = CreatePlayerTextDraw(playerid, 275.000000, 160.000000, "mdl-1001:white_ret");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][3], 100.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][3], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][3], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][3], 0);

	gptDashboard[playerid][4] = CreatePlayerTextDraw(playerid, 275.000000, 195.000000, "mdl-1001:white_ret");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][4], 100.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][4], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][4], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][4], 0);

	gptDashboard[playerid][5] = CreatePlayerTextDraw(playerid, 280.000000, 125.000000, "mdl-1001:signin_text");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][5], 100.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][5], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][5], -33554433);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][5], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, gptDashboard[playerid][5], true);

	gptDashboard[playerid][6] = CreatePlayerTextDraw(playerid, 280.000000, 160.000000, "mdl-1001:signup_text");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][6], 100.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][6], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][6], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, gptDashboard[playerid][6], true);

	gptDashboard[playerid][7] = CreatePlayerTextDraw(playerid, 280.000000, 195.000000, "mdl-1001:credits_text");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][7], 100.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][7], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][7], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][7], 0);
	PlayerTextDrawSetSelectable(playerid, gptDashboard[playerid][7], true);

	gptDashboard[playerid][8] = CreatePlayerTextDraw(playerid, 275.000000, 250.000000, "mdl-1001:exit");
	PlayerTextDrawTextSize(playerid, gptDashboard[playerid][8], 100.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, gptDashboard[playerid][8], 1);
	PlayerTextDrawColor(playerid, gptDashboard[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, gptDashboard[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, gptDashboard[playerid][8], 255);
	PlayerTextDrawFont(playerid, gptDashboard[playerid][8], 4);
	PlayerTextDrawSetProportional(playerid, gptDashboard[playerid][8], 0);
	PlayerTextDrawSetSelectable(playerid, gptDashboard[playerid][8], true);

	for(new i = 0; i < sizeof(gptDashboard[]); i++)
		PlayerTextDrawShow(playerid, gptDashboard[playerid][i]);

	SelectTextDraw(playerid, COLOR_SELECTION);
	return 1;
}

loadBackgroundOnly(playerid)
{
	if(!dashIsVisible[playerid] || backIsVisible[playerid])
		return 1;

	for(new i = 2; i < sizeof(gptDashboard[]); i++)
	{
		if(i > 1)
			PlayerTextDrawDestroy(playerid, gptDashboard[playerid][i]);
	}
	dashIsVisible[playerid] = false;
	backIsVisible[playerid] = true;
	return 1;
}

forward hideAllDashboard(pid);
public hideAllDashboard(pid)
{
	dashIsVisible[pid] = false;
	backIsVisible[pid] = false;
	CancelSelectTextDraw(pid);
	VSL_HideTextdraws(pid);
	return 1;
}

VSL_HideTextdraws(pid) { 
	for (new i = 0; i < sizeof(gptDashboard[]); i++)
	{
		if(i >= 0)
			PlayerTextDrawDestroy(pid, gptDashboard[pid][i]);
	}
	return true;
}

GetPlayerDashIsVisible(playerid)
{
	if(dashIsVisible[playerid] || backIsVisible[playerid])
		return true;

	return false;
}

//--------------------------------------------------------------------------------

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW && dashIsVisible[playerid])
	{
		SelectTextDraw(playerid, COLOR_SELECTION);
	}
	return 1;
}

//--------------------------------------------------------------------------------

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if(gptDashboard[playerid][pTD_LOGIN] == playertextid)
	{
		if(!IsPlayerRegistered(playerid)) { PlayErrorSound(playerid); return 1; }

		PlaySelectSound(playerid);
		static strD[750 + MAX_PLAYER_NAME];

		format(strD, sizeof(strD), "{ffffff}Olá {16a085}%s{ffffff}!\nVocê já possuí uma conta cadastrada em nosso sistema, realize login\ncom a senha que você utilizou para realizar seu cadastro.\
		\n\n{117a65}------------------------------------------------------------------------------------------------\
		\n{16a085}* {ffffff}Registrado desde: \t\t\t\t\t{16a085}%s\n{16a085}* {ffffff}Ultimo login: \t\t\t\t\t\t{16a085}%s\n{16a085}* {ffffff}Level: \t\t\t\t\t\t{16a085}%d\n{16a085}* {ffffff}Sexo: \t\t\t\t\t\t{16a085}%s\
		\n{16a085}* {ffffff}Atual IP: \t\t\t\t\t\t{16a085}%s\n{117a65}------------------------------------------------------------------------------------------------\n\n{ffffff}Insira sua senha abaixo:", GetPlayerFirstName(playerid),\
		convertTimestamp(GetPlayerRegDataUnix(playerid), 1), (GetPlayerLastLoginUnix(playerid) == 0) ? "Nunca" : convertTimestamp(GetPlayerLastLoginUnix(playerid), 1),\
		GetPlayerLevel(playerid), GetPlayerGenderName(playerid), GetPlayerIPf(playerid));

		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login > {d63939}Insira sua senha", strD, "Conectar", "Voltar");
			
		loadBackgroundOnly(playerid);
	}
	else if(gptDashboard[playerid][pTD_REGISTER] == playertextid)
	{
		if(IsPlayerRegistered(playerid)) { PlayErrorSound(playerid); return 0; }

		PlaySelectSound(playerid);
		static strD[420 + MAX_PLAYER_NAME];

		format(strD, sizeof(strD), "{ffffff}Olá {d63939}%s{ffffff}, seu email é necessário para o registro de sua conta no servidor.\n\nCaso perca sua senha, poderá entrar em contato com\
		\num administrador para realizar a recuperação.\n\n{16a085}* {ffffff}Caso seu email esteja inválido, não será possível uma futura recuperação.\
		\n{16a085}* {ffffff}Alterações no seu endereço poderão ser realizadas em contato com um administrador.\n\nInsira um endereço email válido abaixo:", GetPlayerFirstName(playerid));
		ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registrar > {d63939}Email", strD, "Continuar", "Voltar");

		loadBackgroundOnly(playerid);
	}
	else if(gptDashboard[playerid][pTD_CREDITS] == playertextid)
	{
		PlaySelectSound(playerid);
	}
	else if(gptDashboard[playerid][pTD_EXIT] == playertextid)
	{
		PlaySelectSound(playerid);

		ClearPlayerScreen(playerid);
		SendClientMessage(playerid, COLOR_WARNING, "<!> {ffffff}Você foi desconectado automaticamente.");

		DashKick(playerid, 500);
	}
	return 1;
}

//--------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason) { dashIsVisible[playerid] = false; backIsVisible[playerid] = false; return 1; }

//--------------------------------------------------------------------------------

stock DashKick(kickedid, timer = 200)
{
	CancelSelectTextDraw(kickedid);
	hideAllDashboard(kickedid);
	SetTimerEx("@tKick", timer, false, "i", kickedid);
	return true;
}
forward @tKick(playerid);
public @tKick(playerid) return Kick(playerid);