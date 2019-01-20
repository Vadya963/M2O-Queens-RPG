local database = sqlite( "ebmp-ver-3.1.db" )//база данных
local element_data = {}

function sqlite3(text)
{
	local result = database.query(text)
	return result
}

//----цвета----
local color_tips = [168,228,160]//--бабушкины яблоки
local yellow = [255,255,0]//--желтый
local red = [255,0,0]//--красный
local blue = [0,150,255]//--синий
local white = [255,255,255]//--белый
local green = [0,255,0]//--зеленый
local turquoise = [0,255,255]//--бирюзовый
local orange = [255,100,0]//--оранжевый
local orange_do = [255,150,0]//--оранжевый do
local pink = [255,100,255]//--розовый
local lyme = [130,255,0]//--лайм админский цвет
local svetlo_zolotoy = [255,255,130]//--светло-золотой

local max_heal = 720.0//--макс здоровье игрока
local house_bussiness_radius = 5.0//--радиус размещения бизнесов и домов

//слоты игрока
local max_inv = 24
local array_player_1 = array(getMaxPlayers(), 0)
local array_player_2 = array(getMaxPlayers(), 0)

local state_inv_gui = array(getMaxPlayers(), 0)
local logged = array(getMaxPlayers(), 0)
//--нужды
local alcohol = array(getMaxPlayers(), 0)
local satiety = array(getMaxPlayers(), 0)
local hygiene = array(getMaxPlayers(), 0)
local sleep = array(getMaxPlayers(), 0)
local drugs = array(getMaxPlayers(), 0)

//слоты тс
local array_car_1 = {}
local array_car_2 = {}

//слоты дома
local array_house_1 = {}
local array_house_2 = {}

//сохранение действий игрока
function save_player_action (playerid, text)
{
	local name = getPlayerName(playerid)
	local coord = text.tostring()
	
	local posfile = file("player_action/"+name+".txt", "a")

	local date = split(getDateTime(), ": ")//установка времени
	local month = date[1].tostring()
	local day = date[2].tostring()
	local chas = date[3].tostring()
	local min = date[4].tostring()
	local sec = date[5].tostring()

	local say = "["+day+" "+month+" "+chas+":"+min+":"+sec+"] "
	for (local i = 0; i < say.len(); i++) 
	{
		posfile.writen(say[i], 'b')
	}

	for (local i = 0; i < coord.len(); i++) 
	{	
		posfile.writen(coord[i], 'b')
	}
	
	posfile.writen('\n', 'b')
	posfile.close()
}

function random(min=0, max=RAND_MAX)
{
	srand(getTickCount() * rand())
	return (rand() % ((max + 1) - min)) + min//функция для получения рандомных чисел
}

//---------------------------------------игрок------------------------------------------------------------
function search_inv_player( playerid, id1, id2 )//--цикл по поиску предмета в инв-ре игрока
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1 && array_player_2[playerid][i] == id2)
		{
			val = val + 1
		}
	}

	return val
}

function search_inv_player_2_parameter(playerid, id1)//--вывод 2 параметра предмета в инв-ре игрока
{
	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1)
		{
			return array_player_2[playerid][i]
		}
	}
}

function inv_player_empty(playerid, id1, id2)//выдача предмета игроку
{
	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == 0)
		{
			inv_server_load( playerid, "player", i, id1, id2, playerid )

			return true
		}
	}

	return false
}

function inv_player_delet(playerid, id1, id2)//--удаления предмета игрока
{
	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1 && array_player_2[playerid][i] == id2)
		{
			inv_server_load( playerid, "player", i, 0, 0, playerid )

			return true
		}
	}

	return false
}
///////////////////////////////////////////////////////////////////////////////////////////////////

function setElementData (playerid, key, value) 
{
	element_data[playerid][key] <- value
	print("setElementData["+playerid+"]["+key+"] = "+value)
}

function getElementData (playerid, key) 
{	
	print("getElementData["+playerid+"]["+key+"] = "+element_data[playerid][key])
	return element_data[playerid][key]
}

function element_data_push_client () 
{

}

function house_bussiness_job_pos_load( playerid )
{
	foreach (idx, v in sqlite3( "SELECT * FROM house_db" )) 
	{
		triggerClientEvent( playerid, "event_bussines_house_fun", v["number"], v["x"], v["y"], v["z"], "house", house_bussiness_radius, 0, 0 )
	}
}

addEventHandler( "onScriptInit",
function()
{	
	local house_number = 0
	foreach (idx, value in sqlite3( "SELECT * FROM house_db" )) 
	{
		array_house_1[value["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		array_house_2[value["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

		for (local i = 0; i < max_inv; i++) 
		{
			array_house_1[value["number"]][i] = value["slot_"+i+"_1"]
			array_house_2[value["number"]][i] = value["slot_"+i+"_2"]
		}

		house_number++
	}
	print("[house_number] "+house_number)


	local car_number = 0
	foreach (idx, value in sqlite3( "SELECT * FROM car_db" )) 
	{
		local vehicleid = createVehicle( value["carmodel"], value["x"], value["y"], value["z"] + 1.0, value["rot"], 0.0, 0.0 )
		setVehiclePlateText(vehicleid, value["carnumber"])

		array_car_1[value["carnumber"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		array_car_2[value["carnumber"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

		for (local i = 0; i < max_inv; i++) 
		{
			array_car_1[value["carnumber"]][i] = value["slot_"+i+"_1"]
			array_car_2[value["carnumber"]][i] = value["slot_"+i+"_2"]
		}

		car_number++
	}
	print("[car_number] "+car_number)
})

addEventHandler( "onPlayerConnect",
function( playerid, name, ip, serial )
{
	array_player_1[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	array_player_2[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

	state_inv_gui[playerid] = 0
	logged[playerid] = 0
	//--нужды
	alcohol[playerid] = 0
	satiety[playerid] = 0
	hygiene[playerid] = 0
	sleep[playerid] = 0
	drugs[playerid] = 0

	element_data[playerid] <- {}
})

function playerDisconnect( playerid, reason )
{
	if(logged[playerid] == 1)
	{
		local myPos = getPlayerPosition(playerid)
		local vehicleid = getPlayerVehicle(playerid)
		local heal = getPlayerHealth(playerid)
		local playername = getPlayerName(playerid)

		save_player_action(playerid, "[disconnect] name: "+playername+" [reason - "+reason+", heal - "+heal+"]")
	}
}
addEventHandler( "onPlayerDisconnect", playerDisconnect )

addEventHandler( "onPlayerSpawn",
function( playerid )
{
	if (logged[playerid] == 0) 
	{
		setPlayerPosition( playerid, -198.577,824.401,-20.491 )

		reg_or_login(playerid)
	}
	else 
	{
		setPlayerPosition( playerid, -393.265,905.334,-20.0026 )
	}
})

//----------------------------------Регистрация-Авторизация--------------------------------------------
function reg_or_login(playerid)
{
	local playername = getPlayerName ( playerid )
	local serial = getPlayerSerial(playerid)
	local ip = getPlayerIP(playerid)

	local result = sqlite3( "SELECT COUNT() FROM account WHERE name = '"+playername+"'" )
	if (result[1]["COUNT()"] == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM account WHERE reg_serial = '"+serial+"'" )
		if (result[1]["COUNT()"] == 1) 
		{
			kickPlayer(playerid)
			return
		}
		
		local result = sqlite3( "INSERT INTO account (name, ban, reason, x, y, z, reg_ip, reg_serial, heal, alcohol, satiety, hygiene, sleep, drugs, skin, arrest, crimes, slot_0_1, slot_0_2, slot_1_1, slot_1_2, slot_2_1, slot_2_2, slot_3_1, slot_3_2, slot_4_1, slot_4_2, slot_5_1, slot_5_2, slot_6_1, slot_6_2, slot_7_1, slot_7_2, slot_8_1, slot_8_2, slot_9_1, slot_9_2, slot_10_1, slot_10_2, slot_11_1, slot_11_2, slot_12_1, slot_12_2, slot_13_1, slot_13_2, slot_14_1, slot_14_2, slot_15_1, slot_15_2, slot_16_1, slot_16_2, slot_17_1, slot_17_2, slot_18_1, slot_18_2, slot_19_1, slot_19_2, slot_20_1, slot_20_2, slot_21_1, slot_21_2, slot_22_1, slot_22_2, slot_23_1, slot_23_2) VALUES ('"+playername+"', '0', '0', '0', '0', '0', '"+ip+"', '"+serial+"', '"+max_heal+"', '0', '100', '100', '100', '0', '26', '0', '-1', '1', '500', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0')" )

		local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )
		for (local i = 0; i < max_inv; i++) 
		{
			array_player_1[playerid][i] = result[1]["slot_"+i+"_1"]
			array_player_2[playerid][i] = result[1]["slot_"+i+"_2"]
		}

		logged[playerid] = 1
		alcohol[playerid] = result[1]["alcohol"]
		satiety[playerid] = result[1]["satiety"]
		hygiene[playerid] = result[1]["hygiene"]
		sleep[playerid] = result[1]["sleep"]
		drugs[playerid] = result[1]["drugs"]

		setPlayerHealth( playerid, result[1]["heal"] )

		sendPlayerMessage(playerid, "Вы удачно зарегистрировались!", turquoise[0], turquoise[1], turquoise[2])

		//sqlite_save_player_action( "CREATE TABLE "+playername+" (player_action TEXT)" )

		save_player_action(playerid, "[ACCOUNT REGISTER] "+playername+" [ip - "+ip+", serial - "+serial+"]")

		house_bussiness_job_pos_load( playerid )
	}
	else if (result[1]["COUNT()"] == 1) 
	{
		local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )

		if (result[1]["reg_serial"] != serial) 
		{
			kickPlayer(playerid)
			return
		}

		for (local i = 0; i < max_inv; i++) 
		{
			array_player_1[playerid][i] = result[1]["slot_"+i+"_1"]
			array_player_2[playerid][i] = result[1]["slot_"+i+"_2"]
		}

		logged[playerid] = 1
		//arrest[playerid] = result[1]["arrest"]
		//crimes[playerid] = result[1]["crimes"]
		alcohol[playerid] = result[1]["alcohol"]
		satiety[playerid] = result[1]["satiety"]
		hygiene[playerid] = result[1]["hygiene"]
		sleep[playerid] = result[1]["sleep"]
		drugs[playerid] = result[1]["drugs"]

		/*if (arrest[playername] == 1) {//не удалять
			local randomize = math.random(1,#prison_cell)
			spawnPlayer(playerid, prison_cell[randomize][4], prison_cell[randomize][5], prison_cell[randomize][6], 0, result[1]["skin"], prison_cell[randomize][1], prison_cell[randomize][2])
		} else {
			spawnPlayer(playerid, result[1]["x"], result[1]["y"], result[1]["z"], 0, result[1]["skin"], 0, 0)
		}*/

		setPlayerHealth( playerid, result[1]["heal"] )

		sendPlayerMessage(playerid, "Вы удачно зашли!", turquoise[0], turquoise[1], turquoise[2])

		save_player_action(playerid, "[log_fun] "+playername+" [ip - "+ip+", serial - "+serial+"]")

		house_bussiness_job_pos_load( playerid )
	}
}

function tab_down(playerid)
{	
	local myPos = getPlayerPosition(playerid)
	local vehicleid = getPlayerVehicle(playerid)

	if (state_inv_gui[playerid] == 0)
	{
		for (local id3 = 0; id3 < max_inv; id3++)
		{
			triggerClientEvent( playerid, "event_inv_load", "player", id3, array_player_1[playerid][id3], array_player_2[playerid][id3] )
		}

		if (isPlayerInVehicle(playerid)) 
		{
			local plate = getVehiclePlateText(vehicleid)

			if (plate.tointeger() != 0)
			{
				for (local id3 = 0; id3 < max_inv; id3++)
				{
					triggerClientEvent( playerid, "event_inv_load", "car", id3, array_car_1[plate][id3], array_car_2[plate][id3] )
				}
			}
		}

		foreach (idx, value in sqlite3( "SELECT * FROM house_db" )) 
		{	
			if (isPointInCircle3D( myPos[0], myPos[1], myPos[2], value["x"], value["y"], value["z"], house_bussiness_radius))
			{
				for (local id3 = 0; id3 < max_inv; id3++)
				{
					triggerClientEvent( playerid, "event_inv_load", "house", id3, array_house_1[value["number"]][id3], array_house_2[value["number"]][id3] )
				}

				triggerClientEvent( playerid, "event_tab_load", "house", value["number"] )
			}
		}

		state_inv_gui[playerid] = 1
	}
	else
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )

		state_inv_gui[playerid] = 0
	}

	triggerClientEvent( playerid, "event_tab_down_fun" )
}
addEventHandler ("event_tab_down", tab_down)

//вход в авто
function playerEnteredVehicle( playerid, vehicleid, seat )
{
	local playername = getPlayerName ( playerid )
	local plate = getVehiclePlateText(vehicleid)

	if (seat == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["nalog"] <= 0)
			{
				sendPlayerMessage(playerid, "[ERROR] Т/с арестован за уклонение от уплаты налогов", red[0], red[1], red[2])
				setVehicleFuel(vehicleid, 0.0)
				return
			}

			local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["fuel"] <= 1)
			{
				sendPlayerMessage(playerid, "[ERROR] Бак пуст", red[0], red[1], red[2])
				setVehicleFuel(vehicleid, 0.0)
				return
			}
		}

		if (search_inv_player(playerid, 6, plate.tointeger()) != 0 && search_inv_player(playerid, 2, playername) != 0)
		{
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
				sendPlayerMessage(playerid, "Налог т/с оплачен на "+result[1]["nalog"]+" дней", yellow[0], yellow[1], yellow[2])
			}

			if (plate.tointeger() != 0)
			{
				triggerClientEvent( playerid, "event_tab_load", "car", plate )
			}

			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
				setVehicleFuel(vehicleid, result[1]["fuel"])
			}
		}
		else
		{
			sendPlayerMessage(playerid, "[ERROR] Чтобы завести т/с надо выполнить 2 пункта:", red[0], red[1], red[2])
			sendPlayerMessage(playerid, "[ERROR] 1) нужно иметь ключ от т/с", red[0], red[1], red[2])
			sendPlayerMessage(playerid, "[ERROR] 2) иметь права на свое имя", red[0], red[1], red[2])
			setVehicleFuel(vehicleid, 0.0)
		}
	}
}
addEventHandler ("onPlayerVehicleEnter", playerEnteredVehicle)

//выход из авто
function PlayerVehicleExit( playerid, vehicleid, seat )
{
	local plate = getVehiclePlateText(vehicleid)
	local gas = getVehicleFuel(vehicleid)
	local carpos = getVehiclePosition(vehicleid)
	local carrot = getVehicleRotation(vehicleid)

	if (seat == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{	
			if (gas > 1)
			{
				sqlite3( "UPDATE car_db SET x = '"+carpos[0]+"', y = '"+carpos[1]+"', z = '"+carpos[2]+"', rot = '"+carrot[0]+"', fuel = '"+gas+"' WHERE carnumber = '"+plate+"'")
			}
		}

		triggerClientEvent( playerid, "event_tab_load", "car", "" )
	}
}
addEventHandler ("onPlayerVehicleExit", PlayerVehicleExit)

function inv_server_load (playerid, value, id3, id1, id2, tabpanel)//изменение(сохранение) инв-ря на сервере
{	
	local playername = getPlayerName(playerid)
	local plate = tabpanel
	local h = tabpanel

	if (value == "player")
	{
		array_player_1[playerid][id3] = id1
		array_player_2[playerid][id3] = id2
		sqlite3( "UPDATE account SET slot_"+id3+"_1 = '"+array_player_1[playerid][id3]+"', slot_"+id3+"_2 = '"+array_player_2[playerid][id3]+"' WHERE name = '"+playername+"'")

		triggerClientEvent( playerid, "event_inv_load", value, id3, array_player_1[playerid][id3], array_player_2[playerid][id3] )
	}
	else if (value == "car")
	{
		array_car_1[plate][id3] = id1
		array_car_2[plate][id3] = id2

		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			sqlite3( "UPDATE car_db SET slot_"+id3+"_1 = '"+array_car_1[plate][id3]+"', slot_"+id3+"_2 = '"+array_car_2[plate][id3]+"' WHERE carnumber = '"+plate+"'")
		}

		triggerClientEvent( playerid, "event_inv_load", value, id3, array_car_1[plate][id3], array_car_2[plate][id3] )
	}
	else if (value == "house")
	{
		array_house_1[h][id3] = id1
		array_house_2[h][id3] = id2

		sqlite3( "UPDATE house_db SET slot_"+id3+"_1 = '"+array_house_1[h][id3]+"', slot_"+id3+"_2 = '"+array_house_2[h][id3]+"' WHERE number = '"+h+"'")
		
		triggerClientEvent( playerid, "event_inv_load", value, id3, array_house_1[h][id3], array_house_2[h][id3] )
	}
}
addEventHandler( "event_inv_server_load", inv_server_load )

addCommandHandler("sub",//выдача предмета и кол-во
function(playerid, id1, id2)
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()

	if (inv_player_empty(playerid, val1, val2))
	{
		sendPlayerMessage(playerid, "Вы создали "+val1+", "+val2, 255,255,0)
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Инвентарь полон", 255,0,0)
	}
})

addCommandHandler("subt",//выдача предмета и кол-во
function(playerid, id1, id2)
{
	local val1 = id1.tointeger()
	local val2 = id2.tostring()

	if (inv_player_empty(playerid, val1, val2))
	{
		sendPlayerMessage(playerid, "Вы создали "+val1+", "+val2, 255,255,0)
	}
	else
	{
		sendPlayerMessage(playerid, "[ERROR] Инвентарь полон", 255,0,0)
	}
})

addCommandHandler("v",
function(playerid, id)
{
	local pos = getPlayerPosition( playerid )
	local vehicleid = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 )
	setVehiclePlateText(vehicleid, "0")
})

addCommandHandler( "poz",
function( playerid )
{
	local pos = getPlayerPosition( playerid )
	log("[COORD] "+pos[0]+","+pos[1]+","+pos[2])
})

addCommandHandler( "go",
function( playerid, q, w, e )
{
	if(!isPlayerInVehicle(playerid))
	{
		setPlayerPosition( playerid, q.tofloat(), w.tofloat(), e.tofloat() )
	}
	else
	{
		local vehicleid = getPlayerVehicle(playerid)
		setVehiclePosition( vehicleid, q.tofloat(), w.tofloat(), e.tofloat() )
	}
})

addEventHandler("onConsoleInput",
function(command, params)
{
	log("")
	log( "Commands - " +command )

	if(command == "z")
	{
		local table = {"1":1, "2":2}

		foreach (idx, value in table) {
			print(idx+" "+value)
		}
		print(table)

		/*for (local i = 0; i < 10; i++) 
		{
			setElementData(0, i, i)
		}

		for (local i = 0; i < 10; i++) 
		{
			setElementData(1, i, i*2)
		}*/
	}

	if(command == "x")
	{	
		/*local x = true
		print((x || 0))//true

		local x = false
		print((x || 0))//0*/

		/*for (local i = 0; i < 10; i++) 
		{
			getElementData(0, i)
		}

		for (local i = 0; i < 10; i++) 
		{
			getElementData(1, i)
		}*/
	}
})