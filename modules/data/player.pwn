/* Copyright (c) Multiweb Devs 2018 - All Rights Reserved
 _______________________________________________________
| FILENAME :
|		player.pwn
|_______________________________________________________
| DESCRIPTION :
|		* Changes in the players database
|_______________________________________________________
| NOTE :
|		* This file should only contain information about player's data.
|		* This is not intended to handle player actions and such.
|_______________________________________________________*/

#include <YSI\y_hooks>

//--------------------------------------------------------------------------------

#define         START_X         1449.01
#define         START_Y         -2287.10
#define         START_Z         13.54
#define         START_A         96.36
#define         START_INT       0
#define         START_VW        0

//--------------------------------------------------------------------------------

enum e_player_adata
{
	e_player_database_id,
	e_player_password,
	e_player_regdate,
	e_player_ip[16],
	e_player_lastlogin,
	e_player_playedtime
}
static gPlayerAccountData[MAX_PLAYERS][e_player_adata];

//--------------------------------------------------------------------------------

enum e_player_pdata
{
    Float:e_player_x,
    Float:e_player_y,
    Float:e_player_z,
    Float:e_player_a,
    e_player_int,
    e_player_vw,
    e_player_spawn
}
static gPlayerPositionData[MAX_PLAYERS][e_player_pdata];

//------------------------------------------------------------------------------

enum e_player_cdata
{
    e_player_skin,
    e_player_gender,
    e_player_money,
    e_player_level,
    Float:e_player_health,
    Float:e_player_armour
}
static gPlayerCharacterData[MAX_PLAYERS][e_player_cdata];

//--------------------------------------------------------------------------------

static bool:gIsPlayerLogged[MAX_PLAYERS];
static bool:gIsPlayerRegistered[MAX_PLAYERS];

//--------------------------------------------------------------------------------

forward OnAccountCheck(playerid);
forward OnAccountRegister(playerid);
forward OnAccountLoad(playerid);

//--------------------------------------------------------------------------------

// Temporary vars
static gPlayerEmail[MAX_PLAYERS][128];
static gPlayerName[MAX_PLAYERS][64];
static gPlayerGender[MAX_PLAYERS];
static gPlayerAge[MAX_PLAYERS][11];

//--------------------------------------------------------------------------------

ResetPlayerData(playerid)
{
	// Current time
	new ct = gettime();

	// Reset all player status
	gIsPlayerLogged[playerid] = false;
	gIsPlayerRegistered[playerid] = false;

	gPlayerAccountData[playerid][e_player_database_id] = 0;
	gPlayerAccountData[playerid][e_player_regdate] = ct;
	gPlayerAccountData[playerid][e_player_lastlogin] = ct;
	gPlayerAccountData[playerid][e_player_playedtime] = ct;

	gPlayerPositionData[playerid][e_player_x]           = 1449.01;
	gPlayerPositionData[playerid][e_player_y]           = -2287.10;
	gPlayerPositionData[playerid][e_player_z]           = 13.54;
	gPlayerPositionData[playerid][e_player_a]           = 96.36;
	gPlayerPositionData[playerid][e_player_int]         = 0;
	gPlayerPositionData[playerid][e_player_vw]          = 0;
	gPlayerPositionData[playerid][e_player_spawn]		= LAST_POSITION;

	gPlayerCharacterData[playerid][e_player_gender]     = 0;
    gPlayerCharacterData[playerid][e_player_money]      = 350;
    gPlayerCharacterData[playerid][e_player_skin]       = 188;
    gPlayerCharacterData[playerid][e_player_health]     = 100.0;
    gPlayerCharacterData[playerid][e_player_armour]     = 0.0;

    SetPlayerLevel(playerid, 1);
}

//--------------------------------------------------------------------------------

GetPlayerDatabaseID(playerid)
{
	return gPlayerAccountData[playerid][e_player_database_id];
}

GetPlayerSpawnPosition(playerid)
{
	return gPlayerPositionData[playerid][e_player_spawn];
}

GetPlayerGender(playerid)
{
	return gPlayerCharacterData[playerid][e_player_gender];
}

GetPlayerGenderName(playerid)
{
	new genderName[10];
	if(!GetPlayerGender(playerid))
		genderName = "Masculino";
	else
		genderName = "Feminino";
	return genderName;
}

GetPlayerCash(playerid)
{
	return gPlayerCharacterData[playerid][e_player_money];
}

GetPlayerLevel(playerid)
{
	return gPlayerCharacterData[playerid][e_player_level];
}

GetPlayerActualSkin(playerid)
{
	gPlayerCharacterData[playerid][e_player_skin] = GetPlayerSkin(playerid);
	return gPlayerCharacterData[playerid][e_player_skin];
}

//--------------------------------------------------------------------------------

SetPlayerCash(playerid, money)
{
	ResetPlayerMoney(playerid);
	gPlayerCharacterData[playerid][e_player_money] = money;
	GivePlayerMoney(playerid, money);
}

SetPlayerLevel(playerid, val)
{
	SetPlayerScore(playerid, val);
	gPlayerCharacterData[playerid][e_player_level] = val;
}

//--------------------------------------------------------------------------------

SetPlayerRegistered(playerid, bool:set)
{
	gIsPlayerRegistered[playerid] = set;
}
SetPlayerLogged(playerid, bool:set)
{
	gIsPlayerLogged[playerid] = set;

	new query[56];
	mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `isOnline`='%d' WHERE `user_id`='%d'", set, GetPlayerDatabaseID(playerid));
	mysql_tquery(db_handle, query);
}

IsPlayerRegistered(playerid)
{
	if(!IsPlayerConnected(playerid))
		return false;

	if(gIsPlayerRegistered[playerid])
		return true;

	return false;
}

IsPlayerLogged(playerid)
{
	if(!IsPlayerConnected(playerid))
		return false;
	if(gIsPlayerLogged[playerid])
		return true;

	return false;
}

//--------------------------------------------------------------------------------

GetPlayerIPf(playerid)
{
    new ip[16];
    GetPlayerIp(playerid, ip, 16);
    printf("my ip : %s", ip);
    return ip;
}

GetPlayerRegDataUnix(playerid)
{
    return gPlayerAccountData[playerid][e_player_regdate];
}

GetPlayerLastLoginUnix(playerid)
{
    return gPlayerAccountData[playerid][e_player_lastlogin];
}

//--------------------------------------------------------------------------------

SavePlayerAccount(playerid)
{
	if(!IsPlayerLogged(playerid))
		return 0;

	new Float:x, Float:y, Float:z, Float:a, interior, world;
	world = GetPlayerVirtualWorld(playerid);
	interior = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, x, y, z);

	new Float:health, Float:armour;
	GetPlayerHealth(playerid, health) && GetPlayerArmour(playerid, armour);

	new query[1310];
	mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET\
	`x`='%.2f', `y`='%.2f', `z`='%.2f', `a`='%.2f', `interior`='%d', `virtual_world`='%d', `spawn`='%d',\
	`health`='%.2f', `armour`='%.2f', `money`='%d', `gender`='%d', `skin`='%d', `level`='%d',\
	`last_login`='%d', `played_time`='%d', `ip`='%s' WHERE `user_id`='%d'",\
	x, y, z, a, interior, world, GetPlayerSpawnPosition(playerid),\
	health, armour, GetPlayerCash(playerid), GetPlayerGender(playerid), GetPlayerActualSkin(playerid), GetPlayerLevel(playerid),\
	gettime(), gPlayerAccountData[playerid][e_player_playedtime], GetPlayerIPf(playerid), gPlayerAccountData[playerid][e_player_database_id]);
	mysql_query(db_handle, query);
	return 1;
}

//--------------------------------------------------------------------------------

public OnAccountLoad(playerid)
{
	new registros;
	cache_get_row_count(registros);
	if(registros > 0)
	{
        GetPlayerIp(playerid, gPlayerAccountData[playerid][e_player_ip], 16);

        cache_get_value_name_int(0, "last_login", gPlayerAccountData[playerid][e_player_lastlogin]);
        cache_get_value_name_int(0, "played_time", gPlayerAccountData[playerid][e_player_playedtime]);

        cache_get_value_name_float(0, "x", gPlayerPositionData[playerid][e_player_x]);
        cache_get_value_name_float(0, "y", gPlayerPositionData[playerid][e_player_y]);
        cache_get_value_name_float(0, "z", gPlayerPositionData[playerid][e_player_z]);
        cache_get_value_name_float(0, "a", gPlayerPositionData[playerid][e_player_a]);
        cache_get_value_name_int(0, "interior", gPlayerPositionData[playerid][e_player_int]);
        cache_get_value_name_int(0, "virtual_world", gPlayerPositionData[playerid][e_player_vw]);
        cache_get_value_name_int(0, "spawn", gPlayerPositionData[playerid][e_player_spawn]);

        cache_get_value_name_int(0, "skin", gPlayerCharacterData[playerid][e_player_skin]);
        cache_get_value_name_float(0, "health", gPlayerCharacterData[playerid][e_player_health]);
        cache_get_value_name_float(0, "armour", gPlayerCharacterData[playerid][e_player_armour]);
        cache_get_value_name_int(0, "gender", gPlayerCharacterData[playerid][e_player_gender]);
        cache_get_value_name_int(0, "money", gPlayerCharacterData[playerid][e_player_money]);
        cache_get_value_name_int(0, "level", gPlayerCharacterData[playerid][e_player_level]);

        SetSpawnInfo(playerid, 255, gPlayerCharacterData[playerid][e_player_skin], gPlayerPositionData[playerid][e_player_x], gPlayerPositionData[playerid][e_player_y], gPlayerPositionData[playerid][e_player_z], gPlayerPositionData[playerid][e_player_a], 0, 0, 0, 0, 0, 0);

        SetPlayerInterior(playerid,     gPlayerPositionData[playerid][e_player_int]);
        SetPlayerVirtualWorld(playerid, gPlayerPositionData[playerid][e_player_vw]);

        SetPlayerLevel(playerid,       gPlayerCharacterData[playerid][e_player_level]);
        SetPlayerHealth(playerid,       gPlayerCharacterData[playerid][e_player_health]);
        SetPlayerArmour(playerid,       gPlayerCharacterData[playerid][e_player_armour]);
       	SetPlayerCash(playerid,			gPlayerCharacterData[playerid][e_player_money]);

        SetPlayerLogged(playerid, true);
        LoadPlayerSpawn(playerid);
    }
	return 1;
}

//--------------------------------------------------------------------------------

public OnAccountCheck(playerid)
{
	new registros;
	cache_get_row_count(registros);
	if(registros > 0)
	{
		cache_get_value_name(0, "password", gPlayerAccountData[playerid][e_player_password], MAX_PLAYER_PASSWORD);
		cache_get_value_name_int(0, "user_id", gPlayerAccountData[playerid][e_player_database_id]);
		cache_get_value_name_int(0, "last_login", gPlayerAccountData[playerid][e_player_lastlogin]);
		cache_get_value_name_int(0, "regdate", gPlayerAccountData[playerid][e_player_regdate]);

		cache_get_value_name_int(0, "skin", gPlayerCharacterData[playerid][e_player_skin]);
		cache_get_value_name_int(0, "level", gPlayerCharacterData[playerid][e_player_level]);
		cache_get_value_name_int(0, "money", gPlayerCharacterData[playerid][e_player_money]);

		SetPlayerRegistered(playerid, true);
	}
	else
	{
		SetPlayerRegistered(playerid, false);
	}

	printf("row count: %d, registrado: %s", registros, (!gIsPlayerRegistered[playerid]) ? "Não" : "Sim");
	SendClientMessagef(playerid, COLOR_INFO, "<!> {ffffff}Bem-vindo(a) {d63939}%s{ffffff}, você foi conectado com a dashboard.", GetPlayerFirstName(playerid));
	if(!IsPlayerRegistered(playerid)) { SendClientMessage(playerid, COLOR_INFO, "<!> {ffffff}Você não possuí uma conta cadastrada, clique em registrar para começar."); }
	return 1;
}

//--------------------------------------------------------------------------------

public OnAccountRegister(playerid)
{
	gPlayerAccountData[playerid][e_player_database_id] = cache_insert_id();

	SetPlayerColor(playerid, 0xffffffff);
	SetPlayerInterior(playerid, START_INT);
	SetPlayerVirtualWorld(playerid, START_VW);
	SetSpawnInfo(playerid, 255, (!gPlayerGender[playerid]) ? 188 : 190, START_X, START_Y, START_Z, 0, 0, 0, 0, 0, 0, 0);

	//ShowTutorialForPlayer(playerid);
	gPlayerCharacterData[playerid][e_player_gender] = gPlayerGender[playerid];

	new query[256];
	mysql_format(db_handle, query, sizeof(query), "INSERT INTO `players` (`user_id`, `x`, `y`, `z`, `a`, `gender`, `skin`, `regdate`)\
		VALUES ('%d', '%.2f', '%.2f', '%.2f', '%.2f', '%d', '%d', '%d')", gPlayerAccountData[playerid][e_player_database_id], gPlayerPositionData[playerid][e_player_x], gPlayerPositionData[playerid][e_player_y], gPlayerPositionData[playerid][e_player_z], gPlayerPositionData[playerid][e_player_a], gPlayerCharacterData[playerid][e_player_gender], gPlayerCharacterData[playerid][e_player_skin], gPlayerAccountData[playerid][e_player_regdate]);
	mysql_query(db_handle, query);
	printf("[mysql] DEBUG: new account registered on database. ID: %d | Name: %s", gPlayerAccountData[playerid][e_player_database_id], GetPlayerNamef(playerid));
	
	LoadPlayerSpawn(playerid);
	return 1;
}

//--------------------------------------------------------------------------------

hook OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid))
		return 1;

	TogglePlayerSpectating(playerid, true);
	loadDashboard(playerid);

	new query[100 + MAX_PLAYER_NAME], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));
	mysql_format(db_handle, query, sizeof(query), "SELECT * FROM users LEFT JOIN players ON users.id=players.user_id WHERE `username` = '%e' LIMIT 1", playerName);
	mysql_tquery(db_handle, query, "OnAccountCheck", "i", playerid);
	return 1;
}

//--------------------------------------------------------------------------------

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOGIN:
		{
			if(!response)
				return loadDashboard(playerid) && PlaySelectSound(playerid);

            new tmpstr[MAX_PLAYER_PASSWORD];
            SHA256_PassHash(inputtext, "mlacc", tmpstr, MAX_PLAYER_PASSWORD);

            if(!strcmp(gPlayerAccountData[playerid][e_player_password], tmpstr))
            {
                ClearPlayerScreen(playerid);
                PlayConfirmSound(playerid);

                new query[57 + MAX_PLAYER_NAME + 1], playerName[MAX_PLAYER_NAME + 1];
    			GetPlayerName(playerid, playerName, sizeof(playerName));
    			mysql_format(db_handle, query, sizeof(query),"SELECT * FROM `players` WHERE `user_id` = %d LIMIT 1", gPlayerAccountData[playerid][e_player_database_id]);
    			mysql_tquery(db_handle, query, "OnAccountLoad", "i", playerid);
            }
            else
            {
            	static strD[750 + MAX_PLAYER_NAME];
				format(strD, sizeof(strD), "{ffffff}Olá {16a085}%s{ffffff}!\nVocê já possuí uma conta cadastrada em nosso sistema, realize login\ncom a senha que você utilizou para realizar seu cadastro.\
				\n\n{117a65}------------------------------------------------------------------------------------------------\
				\n{16a085}* {ffffff}Registrado desde: \t\t\t\t\t{16a085}%s\n{16a085}* {ffffff}Ultimo login: \t\t\t\t\t\t{16a085}%s\n{16a085}* {ffffff}Level: \t\t\t\t\t\t{16a085}%d\n{16a085}* {ffffff}Sexo: \t\t\t\t\t\t{16a085}%s\
				\n{16a085}* {ffffff}Atual IP: \t\t\t\t\t\t{16a085}%s\n{117a65}------------------------------------------------------------------------------------------------\
				\n\n{d63939}<!> {ffffff}Senha incorreta, verifique e tente novamente.\n{ffffff}Insira sua senha abaixo:", GetPlayerFirstName(playerid),\
				convertTimestamp(GetPlayerRegDataUnix(playerid), 1), (GetPlayerLastLoginUnix(playerid) == 0) ? "Nunca" : convertTimestamp(GetPlayerLastLoginUnix(playerid), 1),\
				GetPlayerLevel(playerid), GetPlayerGenderName(playerid), GetPlayerIPf(playerid));
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login > {d63939}Senha incorreta", strD, "Conectar", "Voltar");
                PlayErrorSound(playerid);
            }
			return -2;
		}
		case DIALOG_REGISTER_EMAIL:
		{
			if(!response)
				return loadDashboard(playerid) && PlaySelectSound(playerid);

			static strD[2][500 + MAX_PLAYER_NAME];
			if(strlen(inputtext) < 6 || strlen(inputtext) > 128 || strfind(inputtext, "@") == -1 || strfind(inputtext, ".") == -1)
			{
				PlayErrorSound(playerid);
				format(strD[0], sizeof(strD[]), "{ffffff}Olá {d63939}%s{ffffff}, seu email é necessário para o registro de sua conta no servidor.\n\n{d63939}<!> {ffffff}O endereço de email inserido não possuí parâmetros de um endereço padrão.\n{d63939}<!> {ffffff}Tente novamente inserindo os dados corretamente.\n\
				\n{16a085}* {ffffff}Caso seu email esteja inválido, não será possível uma futura recuperação.\n{16a085}* {ffffff}Alterações no seu endereço poderão ser realizadas em contato com um administrador.\n\nInsira um endereço email válido abaixo:",\
				 GetPlayerFirstName(playerid));
				ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registrar > {d63939}Email", strD[0], "Continuar", "Voltar");
			}
			else
			{
				PlayConfirmSound(playerid);

				format(gPlayerEmail[playerid], 128, inputtext);
				for(new i = 0; i < strlen(gPlayerEmail[playerid]); i++)
				{
					gPlayerEmail[playerid][i] = tolower(gPlayerEmail[playerid][i]);
				}

				ClearPlayerScreen(playerid);
				SendClientMessagef(playerid, COLOR_SUCCESS, "* {ffffff}Email cadastrado: {16a085}%s", gPlayerEmail[playerid]);

				format(strD[1], sizeof(strD[]), "{ffffff}O nosso servidor {16a085}Modern Life{ffffff} possuí um painel de controle de usuário, popularmente\
					\nchamado de {16a085}User Control Panel (UCP){ffffff} onde você poderá\ngerenciar seu personagem de forma online e com uma interface de usuário comodativa.\
					\n\n\n{16a085}* {ffffff}Seu username não irá interferir no nickname de seu personagem.\n{16a085}* {ffffff}Uma vez inserido não poderá ser alterado, tenha cautela.\
					\n\n\nVocê pode escolher colocar seu nome ou o nome de usuário qual gostaria de ser exibido:");
				ShowPlayerDialog(playerid, DIALOG_REGISTER_NAME, DIALOG_STYLE_INPUT, "Registrar > {d63939}Nome de usuário", strD[1], "Continuar", "Sair");
			}
			return -2;
		}
		case DIALOG_REGISTER_NAME:
		{
			if(!response)
				return DashKick(playerid);

			else if(response)
			{
				PlayConfirmSound(playerid);
				format(gPlayerName[playerid], 64, inputtext);
				SendClientMessagef(playerid, COLOR_SUCCESS, "* {ffffff}Nome de usuário cadastrado: {16a085}%s", gPlayerName[playerid]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER_GENDER, DIALOG_STYLE_MSGBOX, "Registrar > {d63939}Gênero sexual", "{ffffff}Insira o gênero sexual de seu personagem,\nisso implicará na mudança de seu modelo de skin no jogo.\n\n{16a085}* {ffffff}Esta opção não é definitiva.\n{16a085}* {ffffff}Você poderá mudar seu sexo a qualquer momento no jogo conforme suas ações.",\
				 "Masculino", "Feminino");
			}
			return -2;
		}
		case DIALOG_REGISTER_GENDER:
		{
			if(response)
			{
				gPlayerGender[playerid] = 0;
				SendClientMessage(playerid, COLOR_SUCCESS, "* {ffffff}Gênero cadastrado: {16a085}Masculino");
			}
			else
			{
				gPlayerGender[playerid] = 1;
				SendClientMessage(playerid, COLOR_SUCCESS, "* {ffffff}Gênero cadastrado: {16a085}Feminino");
			}
			PlayConfirmSound(playerid);
			ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Registrar > {d63939}Idade", "{16a085}* {ffffff}A sua data de nascimento inserida deve condizer com nossa realidade atual, sem exageros.\
			\n\nInsira a idade de seu personagem no formato de {16a085}dd/mm/aaaa{ffffff}:", "Continuar", "Sair");
			return -2;
		}
		case DIALOG_REGISTER_AGE:
		{
			if(!response)
				return DashKick(playerid);

			new dd, mm, yy, cyy;
			getdate(cyy, mm, dd);
			if(sscanf(inputtext, "p</>iii", dd, mm, yy))
			{
				PlayErrorSound(playerid);
				ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Registrar > {d63939}Idade", "{16a085}* {ffffff}A sua data de nascimento inserida deve condizer com nossa realidade atual, sem exageros.\
				\n\nInsira a idade de seu personagem no formato de {16a085}dd/mm/aaaa{ffffff}:", "Continuar", "Sair");
			}
			else if(dd < 1 || dd > 31 || mm < 1 || mm > 12 || yy < 1900 || yy > cyy)
			{
				PlayErrorSound(playerid);
				ShowPlayerDialog(playerid, DIALOG_REGISTER_AGE, DIALOG_STYLE_INPUT, "Registrar > {d63939}Idade", "{16a085}* {ffffff}A sua data de nascimento inserida deve condizer com nossa realidade atual, sem exageros.\
				\n\nInsira a idade de seu personagem no formato de {16a085}dd/mm/aaaa{ffffff}:", "Continuar", "Sair");
			}
			else
			{
				PlayConfirmSound(playerid);
				format(gPlayerAge[playerid], 11, inputtext);
				SendClientMessagef(playerid, COLOR_SUCCESS, "* {ffffff}Data de nascimento cadastrada: {16a085}%s", gPlayerAge[playerid]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registrar > {d63939}Senha", "{ffffff}Sua senha é de suma importância para a segurança de sua conta, por isso\ncertifique-se de criar uma senha segura e fácil de ser recordada.\
					\n\n{16a085}* {ffffff}Em caso de recuperação de senha, você deverá entrar em contato com a administração por quaisquer meios.\n{16a085}* {ffffff}É estritamente proibido o compartilhamento de contas, caso for detectado por nosso sistema, você será banido automaticamente.\
					\n{16a085}* {ffffff}Sua senha deve conter entre 6 e 30 caracteres.\n\nInsira sua senha no campo abaixo e clique em registrar.", "Registrar", "Sair");
			}
			return -2;
		}
		case DIALOG_REGISTER:
		{
			if(!response)
				return DashKick(playerid);

			else if(strlen(inputtext) < 6)
			{
				PlayErrorSound(playerid);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registrar > {d63939}Senha curta", "{ffffff}Sua senha é de suma importância para a segurança de sua conta, por isso\ncertifique-se de criar uma senha segura e fácil de ser recordada.\
				\n\n{16a085}* {ffffff}Em caso de recuperação de senha, você deverá entrar em contato com a administração por quaisquer meios.\n{16a085}* {ffffff}É estritamente proibido o compartilhamento de contas, caso for detectado por nosso sistema, você será banido automaticamente.\
				\n{d63939}<!> {ffffff}Sua senha deve conter entre 6 e 30 caracteres.\n\nInsira sua senha no campo abaixo e clique em registrar.", "Registrar", "Sair");
			}
			else if(strlen(inputtext) > 30)
			{
				PlayErrorSound(playerid);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registrar > {d63939}Senha longa", "{ffffff}Sua senha é de suma importância para a segurança de sua conta, por isso\ncertifique-se de criar uma senha segura e fácil de ser recordada.\
				\n\n{16a085}* {ffffff}Em caso de recuperação de senha, você deverá entrar em contato com a administração por quaisquer meios.\n{16a085}* {ffffff}É estritamente proibido o compartilhamento de contas, caso for detectado por nosso sistema, você será banido automaticamente.\
				\n{d63939}<!> {ffffff}Sua senha deve conter entre 6 e 30 caracteres.\n\nInsira sua senha no campo abaixo e clique em registrar.", "Registrar", "Sair");
			}
			else
			{
				PlayConfirmSound(playerid);
				SetPlayerLogged(playerid, true);

				ClearPlayerScreen(playerid);
				SendClientMessage(playerid, COLOR_SUCCESS, "* {ffffff}Registrado com sucesso!");

				static playerName[MAX_PLAYER_NAME];
				GetPlayerName(playerid, playerName, sizeof(playerName));

				new query[524], hashedPass[MAX_PLAYER_PASSWORD];
				SHA256_PassHash(inputtext, "mlacc", hashedPass, MAX_PLAYER_PASSWORD);
				mysql_format(db_handle, query, sizeof(query), "INSERT INTO `users` (`name`, `username`, `password`, `email`, `birthdate`, `created_at`) VALUES ('%e', '%e', '%e', '%e', '%e', current_timestamp())",\
				gPlayerName[playerid], playerName, hashedPass, gPlayerEmail[playerid], gPlayerAge[playerid]);
				mysql_tquery(db_handle, query, "OnAccountRegister", "i", playerid);
			}
			return -2;
		}
	}
	return 1;
}

//--------------------------------------------------------------------------------

hook OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid))
		return 1;
	PlayAudioStreamForPlayer(playerid, "https://goo.gl/2FvrtK");

	// Reseting player data
	ResetPlayerData(playerid);

	ClearPlayerScreen(playerid);
	SetPlayerColor(playerid, 0xacacacff);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(!IsPlayerLogged(playerid))
		return 1;

	SavePlayerAccount(playerid);
	SetPlayerLogged(playerid, false);
	return 1;
}

hook OnPlayerRequestSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
		return 1;

	if(!IsPlayerLogged(playerid))
	{
		SendClientMessage(playerid, COLOR_ERROR, "<!> {fffffff}Você não está conectado em sua conta.");
		return -1;
	}
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
		return 1;

	SetPlayerCash(playerid, GetPlayerCash(playerid));
	return 1;
}

//--------------------------------------------------------------------------------

LoadPlayerSpawn(playerid, timer=1000)
{
	CancelSelectTextDraw(playerid);

	SendClientMessage(playerid, COLOR_INFO, "* {ffffff}Carregando seu personagem, aguarde...");
	SetTimerEx("@LoadPlayerSpawn", timer, false, "d", playerid);
}

forward @LoadPlayerSpawn(playerid);
public @LoadPlayerSpawn(playerid)
{
    if(GetPlayerDashIsVisible(playerid))
    	hideAllDashboard(playerid);

    ClearPlayerScreen(playerid);
    SendClientMessage(playerid, COLOR_SUCCESS, "* {ffffff}Conectado.");

    StopAudioStreamForPlayer(playerid);

    TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);
}