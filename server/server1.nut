local database = sqlite( "ebmp-ver-3.1.db" )//база данных
local element_data = {}
local hour = 0
local minute = 0
local earth = {}//--слоты земли
local max_earth = 0
local me_radius = 10.0//--радиус отображения действий игрока в чате
local max_fuel = 50.0//--объем бака авто
local max_heal = 720.0//--макс здоровье игрока
local house_bussiness_radius = 5.0//--радиус размещения бизнесов и домов
local max_blip = 250.0//--радиус блипов

function sqlite3(text)
{
	local result = database.query(text)
	return result
}

function sendMessage(playerid, text, r, g, b)
{
	local date = split(getDateTime(), ": ")//установка времени
	local chas = date[3].tointeger()
	local min = date[4].tointeger()
	local sec = date[5].tointeger()

	sendPlayerMessage(playerid, "[ "+chas+":"+min+":"+sec+" ] "+text, r, g, b)
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

local info_png = {
	[0] = ["", ""],
	[1] = ["деньги", "$"],
	[2] = ["права", "шт"],
	[3] = ["сигареты Big Break Red", "сигарет в пачке"],
	[4] = ["аптечка", "шт"],
	[5] = ["канистра с", "лит."],
	[6] = ["ключ от автомобиля с номером", ""],
	[7] = ["сигареты Big Break Blue", "сигарет в пачке"],
	[8] = ["сигареты Big Break White", "сигарет в пачке"],
	[9] = ["Thompson 1928", "боеприпасов"],
	[10] = ["полицейский жетон", "шт"],
	[11] = ["газета", "шт"],
	[12] = ["Model 12 Revolver", "боеприпасов"],
	[13] = ["Colt M1911A1", "боеприпасов"],
	[14] = ["Colt M1911 Special", "боеприпасов"],
	[15] = ["Remington Model 870 Field gun", "боеприпасов"],
	[16] = ["MP40", "боеприпасов"],
	[17] = ["Mauser C96", "боеприпасов"],
	[18] = ["Model 19 Revolver", "боеприпасов"],
	[19] = ["M3 Grease Gun", "боеприпасов"],
	[20] = ["наркотики", "гр"],
	[21] = ["пиво старый эмпайр", "шт"],
	[22] = ["пиво штольц", "шт"],
	[23] = ["ремонтный набор", "шт"],
	[24] = ["ящик с товаром", "$ за штуку"],
	[25] = ["ключ от дома с номером", ""],
	[26] = ["таблетки от наркозависимости", "шт"],
	[27] = ["одежда", ""],
	[28] = ["шеврон Офицера", "шт"],
	[29] = ["шеврон Детектива", "шт"],
	[30] = ["шеврон Сержанта", "шт"],
	[31] = ["шеврон Лейтенанта", "шт"],
	[32] = ["шеврон Капитан", "шт"],
	[33] = ["шеврон Шефа полиции", "шт"],
	[34] = ["лицензия дальнобойщика на имя", ""],
}

local pogoda = true//зима(false) или лето(true)
local pogoda_string_true = "DT_RTRclear_day_night"
local weather_server_true = {
	[0] = "DT_RTRclear_day_night",
	[1] = "DT_RTRrainy_day_night",
	[2] = "DT_RTRfoggy_day_night",

	[6] = "DT_RTRclear_day_morning",
	[7] = "DT_RTRrainy_day_morning",
	[8] = "DT_RTRfoggy_day_morning",

	[12] = "DT_RTRclear_day_afternoon",
	[13] = "DT_RTRrainy_day_afternoon",
	[14] = "DT_RTRfoggy_day_afternoon",

	[18] = "DT_RTRclear_day_evening",
	[19] = "DT_RTRrainy_day_evening",
	[20] = "DT_RTRfoggy_day_evening",
}

local pogoda_string_false = "DT04part02"
local weather_server_false = {
	[0] = "DT04part02",
	[1] = "DT02NewStart2",//снег

	[6] = "DT05part01JoesFlat",
	[7] = "DT05part04Distillery",//туман

	[12] = "DT05part03HarrysGunshop",
	[13] = "DT05part05ElGreco",//туман

	[18] = "DT02part02JoesFlat",
	[19] = "DT03part02FreddysBar",//туман
}

local pogoda_leto = [
	["DT_RTRclear_day_night"],
	["DT07part04night_bordel"],
	["DT_RTRrainy_day_night"],
	["DTFreerideNight"],
	["DT10part03Subquest"],
	["DT14part11"],
	["DT_RTRfoggy_day_night"],
	["DT11part05"],
	["DT_RTRclear_day_early_morn1"],
	["DT_RTRfoggy_day_early_morn1"],
	["DT_RTRrainy_day_early_morn"],
	["DT_RTRclear_day_early_morn2"],
	["DT_RTRrainy_day_morning"],
	["DT_RTRclear_day_morning"],
	["DT_RTRfoggy_day_morning"],
	["DT11part01"],
	["DTFreeRideDay"],
	["DT06part03"],
	["DTFreeRideDayRain"],
	["DT_RTRfoggy_day_noon"],
	["DT06part01"],
	["DT07part01fromprison"],
	["DT13part01death"],
	["DT09part1VitosFlat"],
	["DT06part02"],
	["DT11part02"],
	["DT_RTRclear_day_noon"],
	["DT07part02dereksubquest"],
	["DT08part01cigarettesriver"],
	["DT09part2MalteseFalcone"],
	["DT14part1_6"],
	["DT_RTRrainy_day_noon"],
	["DT_RTRfoggy_day_afternoon"],
	["DT_RTRclear_day_afternoon"],
	["DT10part02Roof"],
	["DT09part3SlaughterHouseAfter"],
	["DT10part02bSUNOFF"],
	["DT_RTRrainy_day_afternoon"],
	["DT09part4MalteseFalcone2"],
	["DT15"],
	["DT08part02cigarettesmill"],
	["DT12_part_all"],
	["DT15_interier"],
	["DT15end"],
	["DT13part02"],
	["DT_RTRclear_day_late_afternoon"],
	["DT01part01sicily_svit"],
	["DT_RTRfoggy_day_late_afternoon"],
	["DT_RTRrainy_day_late_afternoon"],
	["DT11part03"],
	["DT08part03crazyhorse"],
	["DT07part03prepadrestaurcie"],
	["DT_RTRrainy_day_evening"],
	["DT05part06Francesca"],
	["DT10part03Evening"],
	["DT14part7_10"],
	["DT_RTRfoggy_day_evening"],
	["DT11part04"],
	["DT_RTRclear_day_evening"],
	["DT08part04subquestwarning"],
	["DT01part02sicily"],
	["DT_RTRclear_day_late_even"],
	["DT_RTRfoggy_day_late_even"],
	["DT_RTRrainy_day_late_even"],
]

local pogoda_zima = [
	["DTFreeRideNightSnow"],
	["DT04part02"],
	["DT05part01JoesFlat"],
	["DT03part01JoesFlat"],
	["DTFreeRideDaySnow"],
	["DT05part02FreddysBar"],
	["DT05part04Distillery"],
	["DT04part01JoesFlat"],
	["DTFreeRideDayWinter"],
	["DT02part01Railwaystation"],
	["DT05part03HarrysGunshop"],
	["DT05part05ElGreco"],
	["DT02part02JoesFlat"],
	["DT03part02FreddysBar"],
	["DT02part04Giuseppe"],
	["DT02part03Charlie"],
	["DT05Distillery_inside"],
	["DT02part05Derek"],
	["DT02NewStart1"],
	["DT03part03MariaAgnelo"],
	["DT02NewStart2"],
	["DT03part04PriceOffice"],
]

local kiosk = [
	[2.48129,714.517,-22.2154],
	[400.47,745.517,-24.6665],
	[164.257,657.558,-21.9641],
	[33.6884,599.201,-19.9273],
	[-121.101,622.605,-19.9023],
	[-378.021,636.731,-10.5905],
	[-502.091,802.291,-19.4324],
	[-615.216,928.722,-18.7638],
	[-728.608,864.547,-18.7325],
	[-656.65,509.887,1.21776],
	[-489.445,465.414,1.16478],
	[-374.126,443.63,-1.07852],
	[-187.223,423.631,-6.13807],
	[29.9201,199.388,-15.8087],
	[436.778,458.533,-23.4465],
	[398.633,205.796,-20.678],
	[-684.184,303.915,0.354372],
	[-720.026,18.0805,1.02313],
	[-504.309,8.96903,-0.348028],
	[-378.354,-194.282,-10.1133],
	[-238.823,-34.79,-11.4141],
	[-65.7549,-309.509,-14.2386],
	[306.183,-304.782,-20.0005],
	[503.665,-295.996,-20.0115],
	[282.229,4.70126,-22.9423],
	[368.481,-301.162,-20.0041],
	[564.192,-555.782,-22.5388],
	[31.9624,-476.895,-19.22],
	[-125.724,-526.665,-16.7269],
	[-1564.69,-188.636,-20.1714],
	[-1343.32,410.58,-23.564],
	[-1601.5,970.578,-5.08525],
	[-1425.34,975.599,-13.4643],
	[-1194.98,1184.57,-13.4075],
	[-1276.81,1337.04,-13.4034],
	[-1115.83,1363.51,-13.371],
	[-377.342,1585.2,-23.4306],
	[-783.837,1517.4,-5.96645],
	[-1576.02,1612.83,-5.91438],
	[-1181.8,1589.17,5.90497],
	[-1046.98,1446.22,-4.30739],
	[229.585,703.815,-23.6116],
	[-50.8092,704.862,-21.9756]
]

local gans = [
	[-592.761,506.872,1.02469],
	[-561.842,310.851,0.186179],
	[-4.65856,739.782,-22.02],
	[404.501,609.636,-24.8944],
	[62.1702,139.456,-14.4132],
	[273.899,-118.779,-12.1976],
	[279.707,-454.18,-20.1616],
	[-323.112,-594.988,-20.1043],
	[-1395.09,-26.8958,-17.8468],
	[-1182.76,1700.38,11.1808],
	[-287.76,1621.72,-23.0972]
]

local fuel = [
	[338.758,875.07,-20.1312],
	[-710.287,1762.62,-14.8309],
	[-1592.31,942.639,-4.02328],
	[-1679.5,-232.035,-19.1619],
	[-629.5,-48.7479,2.22843],
	[-150.096,610.258,-18.9558],
	[112.687,181.302,-18.7977],
	[547.921,2.62598,-17.0294]
]

local ed = [
	[136.28,-433.722,-19.4657],
	[-638.118,1294.83,3.90784],
	[-1588.77,1599.75,-5.26265],
	[-1416.36,954.948,-12.7921],
	[-1584.61,171.068,-12.4761],
	[-1552.83,-169.192,-19.624],
	[-1379.62,471.347,-22.1031],
	[629.515,894.428,-12.0137],
	[-48.3979,728.282,-21.9681],
	[-642.92,357.472,1.34699],
	[29.2695,-66.4476,-16.1665],
	[-1151.57,1580.17,6.27222],
	[240.347,701.693,-24.0321],
	[-561.382,435.897,1.00977],
	[-764.229,-377.074,-20.406]
]

local repair = [
	[-1583.81,68.6026,-13.1081],
	[-1438.92,1379.93,-13.3927],
	[-375.957,1735.39,-22.8601],
	[425.711,780.516,-21.0679],
	[-120.967,529.571,-20.0687],
	[-282.268,701.517,-19.7763],
	[-687.197,188.526,1.18315],
	[-69.189,203.758,-14.3089],
	[285.353,296.706,-21.3649],
	[553.497,-122.346,-20.1382],
	[719.397,-446.142,-19.9979],
	[49.0399,-405.637,-19.9942]
]

local clothing = [
	[-1297.07,1698.45,10.6935],
	[-1417.31,1295.32,-13.7058],
	[-1369.41,384.852,-23.7208],
	[-1534.5,-4.532,-17.8467],
	[-378.296,-456.616,-17.2628],
	[343.258,33.2364,-24.1097],
	[437.402,301.501,-20.1634],
	[-43.1751,381.59,-13.9932],
	[-6.97312,552.727,-19.3915],
	[270.501,767.584,-21.2438],
	[-510.848,870.694,-19.3222],
	[-628.501,283.775,-0.248379],
	[411.157,-298.452,-20.1621]
]

local phohe = [
	[-310.857,1694.88,-22.3773],
	[-1170.57,1578.15,5.84156],
	[-1654.61,1143.06,-7.10691],
	[-1562.38,527.787,-20.1476],
	[-1421.31,-191.48,-20.3052],
	[-147.053,-595.967,-20.1636],
	[283.082,-388.371,-20.1361],
	[747.74,7.80397,-19.4607],
	[-208.633,-45.6014,-12.0168],
	[-584.811,89.4905,-0.21516],
	[250.26,494.087,-20.046],
	[612.189,845.402,-12.6476],
	[112.488,847.435,-19.9109],
	[139.371,1226.68,62.8897],
	[-508.688,910.919,-19.055],
	[-78.6843,233.494,-14.4042]
]

local interior_business = [
	[0, "Магазин оружия", 4],
	[1, "Магазин одежды", 2],
	[2, "Киоск", 13],
	[3, "Заправка", 9],
	[4, "Автомастерская", 14],
	[5, "Закусочная", 1]
]

//-места поднятия предметов
local up_car_subject = [//--{x,y,z, радиус 3, ид пнг 4, ид тс 5, зп 6}
	[-632.282,955.495,-17.7324, 15.0, 24, 37, 50],//--сигаретный завод
]

local up_player_subject = [//--{x,y,z, радиус 3, ид пнг 4, зп 5, скин 6}
	[-427.786,-737.652,-21.7381, 5.0 24, 20, 0],//--порт
]

//--места сброса предметов
local down_car_subject = [//--{x,y,z, радиус 3, ид пнг 4, ид тс 5}
	[-411.778,-827.907,-21.7456, 15.0, 24, 37],//--порт
]

local down_player_subject = [//--{x,y,z, радиус 3, ид пнг 4} также нужно прописать ид пнг в throw_earth_server
	[-411.778,-827.907,-21.7456, 5.0, 24],//--порт
]

local anim_player_subject = [//--{x,y,z, радиус 3, ид пнг1 4, ид пнг2 5, зп 6, время работы анимации 7}
	[-350.47,-726.813,-14.4206, 2.0, 24, 24, 40, 5],//офис дерека
]

//слоты игрока
local max_inv = 24
local array_player_1 = array(getMaxPlayers(), 0)
local array_player_2 = array(getMaxPlayers(), 0)

local state_inv_player = array(getMaxPlayers(), 0)
local logged = array(getMaxPlayers(), 0)
local sead = array(getMaxPlayers(), 0)
local dviglo = array(getMaxPlayers(), 0)
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

	triggerClientEvent(playerid, "event_save_player_action", text)
}

function me_chat(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, text, pink[0], pink[1], pink[2])
		}
	}
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
//-------------------------------------------------------------------------------------------------

//---------------------------------------авто------------------------------------------------------
function search_inv_car( vehicleid, id1, id2 )//--цикл по поиску предмета в инв-ре авто
{
	local val = 0
	local plate = getVehiclePlateText ( vehicleid )

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1 && array_car_2[plate][i] == id2)
		{
			val = val + 1
		}
	}

	return val
}

function search_inv_car_2_parameter(vehicleid, id1)//--вывод 2 параметра предмета в авто
{
	local plate = getVehiclePlateText ( vehicleid )

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1)
		{
			return array_car_2[plate][i]
		}
	}
}

function inv_car_empty(playerid, id1, id2)//--выдача предмета в авто
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local plate = getVehiclePlateText ( vehicleid )

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == 0)
		{
			inv_server_load( playerid, "car", i, id1, id2, plate )

			return true
		}
	}

	return false
}

function inv_car_delet(playerid, id1, id2)//--удаления предмета в авто
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local plate = getVehiclePlateText ( vehicleid )

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1 && array_car_2[plate][i] == id2)
		{
			inv_server_load( playerid, "car", i, 0, 0, plate )

			return true
		}
	}

	return false
}

function getSpeed(playerid)
{
	if (isPlayerInVehicle(playerid))
	{
		local vehicleid = getPlayerVehicle(playerid)
		local velo = getVehicleSpeed(vehicleid)
		local speed = getDistanceBetweenPoints3D(0.0,0.0,0.0, velo[0],velo[1],velo[2])
		return speed*2.27*1.6
	}
	else
	{
		return 0
	}
}
//-------------------------------------------------------------------------------------------------

//------------------------------------Element Data-------------------------------------------------
function setElementData (playerid, key, value) 
{
	element_data[playerid][key] <- value
	//print("setElementData["+playerid+"]["+key+"] = "+value)
}

function getElementData (playerid, key) 
{	
	//print("getElementData["+playerid+"]["+key+"] = "+element_data[playerid][key])
	return element_data[playerid][key]
}

function element_data_push_client () 
{
	foreach (playerid, playername in getPlayers())
	{	
		foreach (key, value in element_data[playerid])
		{
			triggerClientEvent( playerid, "event_element_data_push_client", key, value )
		}
	}
}
//-------------------------------------------------------------------------------------------------

function house_bussiness_job_pos_load( playerid )
{
	foreach (idx, v in sqlite3( "SELECT * FROM house_db" )) 
	{
		triggerClientEvent( playerid, "event_bussines_house_fun", v["number"], v["x"], v["y"], v["z"], "house", house_bussiness_radius, 0, 0 )
	}
}

function info_bisiness( number )
{
	local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
	return "[business "+number+", type "+result[1]["type"]+", price "+result[1]["price"]+", buyprod "+result[1]["buyprod"]+", money "+result[1]["money"]+", warehouse "+result[1]["warehouse"]+"]"
}

function select_sqlite(id1, id2)//--выводит имя владельца любого предмета
{
	for (local i = 0; i < max_inv; i++) 
	{
		local result = sqlite( "SELECT COUNT() FROM account WHERE slot_"+i+"_1 = '"+id1+"' AND slot_"+i+"_2 = '"+id2+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite( "SELECT * FROM account WHERE slot_"+i+"_1 = '"+id1+"' AND slot_"+i+"_2 = '"+id2+"'" )
			return [result[1]["name"], i]
		}
	}

	return [false, 0]
}

function EngineState()//двигатель вкл или выкл
{
	foreach(i, playername in getPlayers()) 
	{
		local vehicleid = getPlayerVehicle(i)
		local plate = getVehiclePlateText(vehicleid)
			
		if( isPlayerInVehicle( i ) )
		{
			if(sead[i] == 0)
			{
				if(dviglo[i] == 1)
				{
					if(getVehicleFuel(vehicleid) < 1)
					{
						setVehicleFuel(vehicleid, 0.0)
					}
					else
					{
						setVehicleFuel(vehicleid, getVehicleFuel(vehicleid))
					}
				}
				else
				{
					setVehicleEngineState(vehicleid, false)
					setVehicleSpeed( vehicleid, 0.0,0.0,0.0 )
				}
			}
		}
	}
}

function timer_earth_clear()
{
	print("[timer_earth_clear] max_earth "+max_earth)

	earth = {}
	max_earth = 0

	foreach(playerid, playername in getPlayers())
	{
		sendMessage(playerid, "[НОВОСТИ] Улицы очищенны от мусора", green[0], green[1], green[2])
		triggerClientEvent( playerid, "event_earth_load", "nil", 0, 0, 0, 0, 0, 0 )
	}
}

function timer_earth()//--передача слотов земли на клиент
{
	foreach(playerid, playername in getPlayers())
	{
		local playername = getPlayerName ( playerid )
		local myPos = getPlayerPosition(playerid)

		foreach(i, v in earth)
		{
			if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0], v[1], v[2], 20.0)) 
			{
				triggerClientEvent( playerid, "event_earth_load", "", i, v[0], v[1], v[2], v[3], v[4] )
			}
		}
	}
}

function debuginfo () 
{
	foreach (playerid, playername in getPlayers()) 
	{
		triggerClientEvent( playerid, "event_inv_load", "player", 0, array_player_1[playerid][0], array_player_2[playerid][0].tostring() )

		//--элементдата
		setElementData(playerid, "0", "state_inv_player[playerid] "+state_inv_player[playerid])
		setElementData(playerid, "1", "logged[playerid] "+logged[playerid])
		setElementData(playerid, "2", "sead[playerid] "+sead[playerid])
		setElementData(playerid, "3", "dviglo[playerid] "+dviglo[playerid])
		setElementData(playerid, "4", "max_earth "+max_earth)

		setElementData(playerid, "serial", getPlayerSerial(playerid))

		setElementData(playerid, "timeserver", hour+":"+minute)

		/*setElementData(playerid, "alcohol_data", alcohol[playerid])
		setElementData(playerid, "satiety_data", satiety[playerid])
		setElementData(playerid, "hygiene_data", hygiene[playerid])
		setElementData(playerid, "sleep_data", sleep[playerid])
		setElementData(playerid, "drugs_data", drugs[playerid])*/
	}
}

function timeserver()//время сервера
{
	minute++

	if(minute == 60)
	{
		minute = 0
		hour++

		if(hour == 24)
		{
			hour = 0
		}

		random_weather (hour)
	}
}

function random_weather (hour) 
{	
	if (pogoda)
	{
		if (hour == 0)
		{
			local randomize = random(0,2)
			pogoda_string_true = weather_server_true[randomize]
			setWeather( pogoda_string_true )
		}
		else if (hour == 6) 
		{
			local randomize = random(6,8)
			pogoda_string_true = weather_server_true[randomize]
			setWeather( pogoda_string_true )
		}
		else if (hour == 12) 
		{
			local randomize = random(12,14)
			pogoda_string_true = weather_server_true[randomize]
			setWeather( pogoda_string_true )
		}
		else if (hour == 18) 
		{
			local randomize = random(18,20)
			pogoda_string_true = weather_server_true[randomize]
			setWeather( pogoda_string_true )
		}

		//print("pogoda_string_true "+pogoda_string_true)
	}
	else 
	{
		if (hour == 0)
		{
			local randomize = random(0,1)
			pogoda_string_false = weather_server_false[randomize]
			setWeather( pogoda_string_false )
		}
		else if (hour == 6) 
		{
			local randomize = random(6,7)
			pogoda_string_false = weather_server_false[randomize]
			setWeather( pogoda_string_false )
		}
		else if (hour == 12) 
		{
			local randomize = random(12,13)
			pogoda_string_false = weather_server_false[randomize]
			setWeather( pogoda_string_false )
		}
		else if (hour == 18) 
		{
			local randomize = random(18,19)
			pogoda_string_false = weather_server_false[randomize]
			setWeather( pogoda_string_false )
		}

		//print("pogoda_string_false "+pogoda_string_false)
	}
}

addEventHandler( "onScriptInit",
function()
{	
	setSummer(pogoda)

	timer( EngineState, 500, -1 )//двигатель машины
	timer( debuginfo, 1000, -1)//--дебагинфа
	timer( element_data_push_client, 1000, -1)//--элементдата
	timer( timeserver, 1000, -1 )//время сервера 1 игровой час = 1 мин реальных
	timer(timer_earth, 500, -1)//--передача слотов земли на клиент
	timer(timer_earth_clear, (24*60000), -1)//--очистка земли от предметов

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
		local color = toRGBA(value["car_rgb"])
		local vehicleid = createVehicle( value["carmodel"], value["x"], value["y"], value["z"] + 1.0, value["rot"], 0.0, 0.0 )

		setVehiclePlateText(vehicleid, value["carnumber"])
		setVehicleColour(vehicleid, color[0], color[1], color[2], color[0], color[1], color[2])
		setVehicleTuningTable(vehicleid, value["tune"])

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
	element_data[playerid] <- {}

	array_player_1[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	array_player_2[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

	state_inv_player[playerid] = 0
	logged[playerid] = 0
	sead[playerid] = 0
	dviglo[playerid] = 0
	//--нужды
	alcohol[playerid] = 0
	satiety[playerid] = 0
	hygiene[playerid] = 0
	sleep[playerid] = 0
	drugs[playerid] = 0
})

function playerDisconnect( playerid, reason )
{
	if(logged[playerid] == 1)
	{
		local myPos = getPlayerPosition(playerid)
		local vehicleid = getPlayerVehicle(playerid)
		local heal = getPlayerHealth(playerid)
		local playername = getPlayerName(playerid)

		state_inv_player[playerid] = 0
		logged[playerid] = 0
		sead[playerid] = 0
		dviglo[playerid] = 0
		//--нужды
		alcohol[playerid] = 0
		satiety[playerid] = 0
		hygiene[playerid] = 0
		sleep[playerid] = 0
		drugs[playerid] = 0

		if (myPos[0] != 0 && myPos[1] != 0 && myPos[2] != 0)
		{
			sqlite3( "UPDATE account SET x = '"+myPos[0]+"', y = '"+myPos[1]+"', z = '"+myPos[2]+"' WHERE name = '"+playername+"'")
		}

		save_player_action(playerid, "[disconnect] name: "+playername+" [reason - "+reason+", heal - "+heal+"]")
	}
}
addEventHandler( "onPlayerDisconnect", playerDisconnect )

addEventHandler( "onPlayerSpawn",
function( playerid )
{
	if (logged[playerid] == 0) 
	{
		reg_or_login(playerid)

		if (pogoda)
		{
			setWeather( pogoda_string_true )
		}
		else 
		{
			setWeather( pogoda_string_false )
		}

		foreach (k, v in sqlite3( "SELECT * FROM business_db" )) 
		{
			triggerClientEvent( playerid, "event_blip_create", v["x"], v["y"], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v["x"], v["y"], interior_business[v["interior"]][2],0, max_blip )
		}

		foreach (k, v in phohe)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 12,0, max_blip )
		}

		foreach (k, v in down_car_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,1, 5000.0 )
			//triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 12,0, max_blip )
		}

		foreach (k, v in up_car_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,1, 5000.0 )
			//triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 12,0, max_blip )
		}
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
		setPlayerModel(playerid, result[1]["skin"])
		setPlayerPosition( playerid, -393.265,905.334,-20.0026 )

		sendMessage(playerid, "Вы удачно зарегистрировались!", turquoise[0], turquoise[1], turquoise[2])

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

		setPlayerPosition( playerid, result[1]["x"],result[1]["y"],result[1]["z"] )
		setPlayerHealth( playerid, result[1]["heal"] )
		setPlayerModel(playerid, result[1]["skin"])

		sendMessage(playerid, "Вы удачно зашли!", turquoise[0], turquoise[1], turquoise[2])

		save_player_action(playerid, "[log_fun] "+playername+" [ip - "+ip+", serial - "+serial+"]")

		house_bussiness_job_pos_load( playerid )
	}
}

function tab_down(playerid)
{	
	local myPos = getPlayerPosition(playerid)
	local vehicleid = getPlayerVehicle(playerid)

	if (state_inv_player[playerid] == 0)
	{
		for (local id3 = 1; id3 < max_inv; id3++)
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

				break
			}
		}

		state_inv_player[playerid] = 1
	}
	else
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )

		state_inv_player[playerid] = 0
	}

	triggerClientEvent( playerid, "event_tab_down_fun" )
}
addEventHandler ("event_tab_down", tab_down)

//вход в авто
function playerEnteredVehicle( playerid, vehicleid, seat )
{
	local playername = getPlayerName ( playerid )
	local plate = getVehiclePlateText(vehicleid)
	sead[playerid] = seat

	if (seat == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["nalog"] <= 0)
			{
				sendMessage(playerid, "[ERROR] Т/с арестован за уклонение от уплаты налогов", red[0], red[1], red[2])
				dviglo[playerid] = 0
				return
			}

			local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["fuel"] <= 1)
			{
				sendMessage(playerid, "[ERROR] Бак пуст", red[0], red[1], red[2])
				dviglo[playerid] = 0
				return
			}
		}

		if (search_inv_player(playerid, 6, plate.tointeger()) != 0 && search_inv_player(playerid, 2, 1) != 0)
		{
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				local result = sqlite3( "SELECT * FROM car_db WHERE carnumber = '"+plate+"'" )
				sendMessage(playerid, "Налог т/с оплачен на "+result[1]["nalog"]+" дней", yellow[0], yellow[1], yellow[2])
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
				dviglo[playerid] = 1
			}
			else 
			{
				setVehicleFuel(vehicleid, 50.0)
				dviglo[playerid] = 1
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Чтобы завести т/с надо выполнить 2 пункта:", red[0], red[1], red[2])
			sendMessage(playerid, "[ERROR] 1) нужно иметь ключ от т/с", red[0], red[1], red[2])
			sendMessage(playerid, "[ERROR] 2) иметь права", red[0], red[1], red[2])
			dviglo[playerid] = 0
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
		if (result[1]["COUNT()"] == 1 && search_inv_player(playerid, 6, plate.tointeger()) != 0)
		{	
			if (gas > max_fuel)
			{
				sqlite3( "UPDATE car_db SET x = '"+carpos[0]+"', y = '"+carpos[1]+"', z = '"+carpos[2]+"', rot = '"+carrot[0]+"', fuel = '"+(max_fuel/2)+"' WHERE carnumber = '"+plate+"'")
			}
			else
			{
				sqlite3( "UPDATE car_db SET x = '"+carpos[0]+"', y = '"+carpos[1]+"', z = '"+carpos[2]+"', rot = '"+carrot[0]+"', fuel = '"+gas+"' WHERE carnumber = '"+plate+"'")
			}
		}

		triggerClientEvent( playerid, "event_tab_load", "car", "" )

		dviglo[playerid] = 0
	}
}
addEventHandler ("onPlayerVehicleExit", PlayerVehicleExit)

function throw_earth_server (playerid, value, id3, id1, id2, tabpanel)//--выброс предмета
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local vehicleid = getPlayerVehicle(playerid)

	if (value == "player")
	{
		foreach (k, v in down_player_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]) && id1 == v[4])//--получение прибыли за предметы
			{
				inv_server_load( playerid, value, id3, 0, 0, tabpanel )
				inv_server_load( playerid, value, 0, 1, array_player_2[playerid][0]+id2, tabpanel )

				sendMessage(playerid, "Вы выбросили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], yellow[0], yellow[1], yellow[2])

				save_player_action(playerid, "[throw_earth_job] "+playername+" [+"+id2+"$, "+array_player_2[playerid][0]+"$] ["+info_png[id1][0]+", "+id2+"]")

				return
			}
		}

		foreach (k, v in anim_player_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]) && id1 == v[4] && !isPlayerInVehicle(playerid))//--обработка предметов
			{
				local randomize = random(1,v[6])

				inv_server_load( playerid, value, id3, 0, 0, tabpanel )

				inv_server_load( playerid, value, id3, v[5], randomize, tabpanel )

				sendMessage(playerid, "Вы получили "+info_png[v[5]][0]+" "+randomize+" "+info_png[v[5]][1], svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2])

				/*if id1 == 67 then--предмет для работы
					object_attach(playerid, 341, 12, 0,0,0, 0,-90,0, (v[12]*1000))
				elseif id1 == 70 then
					object_attach(playerid, 337, 12, 0,0,0, 0,-90,0, (v[12]*1000))
				end*/

				togglePlayerControls( playerid, true )

				sendMessage(playerid, "[TIPS] Не открывайте чат", color_tips[0], color_tips[1], color_tips[2])

				timer(function ()
				{
					togglePlayerControls( playerid, false )
				}, (v[7]*1000), 1)

				return
			}
		}
	}

	max_earth = max_earth+1
	local j = max_earth
	earth[j] <- [myPos[0],myPos[1],myPos[2],id1,id2]

	if (search_inv_player(playerid, 25, id2) != 0 && id1 == 25) {//--когда выбрасываешь ключ в инв-ре исчезают картинки
		triggerClientEvent( playerid, "event_tab_load", "house", "" )
	}

	if (isPlayerInVehicle(playerid)) 
	{
		local plate = getVehiclePlateText ( vehicleid )

		if (sead[playerid] == 0 && id2 == plate.tointeger() && id1 == 6) {//--когда выбрасываешь ключ в инв-ре исчезают картинки
			triggerClientEvent( playerid, "event_tab_load", "car", "" )
		}
	}

	inv_server_load( playerid, value, id3, 0, 0, tabpanel )

	sendMessage(playerid, "Вы выбросили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1],  yellow[0], yellow[1], yellow[2])

	save_player_action(playerid, "[throw_earth] "+playername+" [value - "+value+", x - "+myPos[0]+", y - "+myPos[1]+", z - "+myPos[2]+"] ["+info_png[ id1 ][0]+", "+id2+"]")
}
addEventHandler ( "event_throw_earth_server", throw_earth_server )

function e_down (playerid)//--подбор предметов с земли
{
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	
	if (logged[playerid] == 0) {
		return
	}

		foreach (k, v in up_car_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))
			{
				if (isPlayerInVehicle(playerid)) 
				{
					if (getVehicleModel(vehicleid) != v[5])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в "+"getVehicleNameFromModel ( v[5] )"+"("+v[5]+")", red[0], red[1], red[2])
						return
					}
				}

				give_subject(playerid, "car", v[4], random(1,v[6]))
			}
		}

		foreach (k, v in up_player_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))
			{
				if (v[6] != 0)
				{
					if (getPlayerModel(playerid) != v[6])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в одежде "+v[6], red[0], red[1], red[2])
						return
					}
				}

				give_subject(playerid, "player", v[4], random(1,v[5]))
			}
		}

		foreach (k, v in sqlite3( "SELECT * FROM business_db" )) 
		{
			if (isPointInCircle3D(x,y,z, v["x"],v["y"],v["z"], house_bussiness_radius))
			{
				if (isPlayerInVehicle(playerid)) 
				{
					if (getVehicleModel(vehicleid) != down_car_subject[0][5])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в "+"getVehicleNameFromModel ( down_car_subject[0][5] )"+"("+down_car_subject[0][5]+")", red[0], red[1], red[2])
						return
					}
				}

				delet_subject(playerid, 24)
			}
		}

		foreach (k, v in down_car_subject)
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))
			{
				if (isPlayerInVehicle(playerid)) 
				{
					if (getVehicleModel(vehicleid) != v[5])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в "+"getVehicleNameFromModel ( v[5] )"+"("+v[5]+")", red[0], red[1], red[2])
						return
					}
				}

				delet_subject(playerid, v[4])
			}
		}

	foreach (i, v in earth)
	{
		local area = isPointInCircle3D( myPos[0],myPos[1],myPos[2], v[0], v[1], v[2], 20.0 )

		if (area) 
		{
			if ((v[3] == 24) && search_inv_player(playerid, v[3], search_inv_player_2_parameter(playerid, v[3])) >= 1) {
				sendMessage(playerid, "[ERROR] Можно переносить только один предмет", red[0], red[1], red[2])
				return
			}

			if (inv_player_empty(playerid, v[3], v[4])) 
			{
				sendMessage(playerid, "Вы подняли "+info_png[ v[3] ][0]+" "+v[4]+" "+info_png[ v[3] ][1], svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2])

				save_player_action(playerid, "[e_down] "+playername+" [x - "+v[0]+", y - "+v[1]+", z - "+v[2]+"] ["+info_png[ v[3] ][0]+", "+v[4]+"]")

				delete earth[i]

				foreach(playerid, playername in getPlayers())
				{
					triggerClientEvent( playerid, "event_earth_load", "nil", 0, 0, 0, 0, 0, 0 )
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Инвентарь полон", red[0], red[1], red[2])
			}

			return
		}
	}
}
addEventHandler ( "event_e_down", e_down )

function give_subject( playerid, value, id1, id2 )//--выдача предметов игроку или авто
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local vehicleid = getPlayerVehicle(playerid)
	local count2 = 0

	if (value == "player") {

		if (search_inv_player(playerid, id1, search_inv_player_2_parameter(playerid, id1)) >= 1) {
			sendMessage(playerid, "[ERROR] Можно переносить только один предмет", red[0], red[1], red[2])
			return
		}

		if (inv_player_empty(playerid, id1, id2)) {

			sendMessage(playerid, "Вы получили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2])

			save_player_action(playerid, "[give_subject] "+playername+" [value - "+value+"] ["+info_png[id1][0]+", "+id2+"]")
		}
		else
		{
			sendMessage(playerid, "[ERROR] Инвентарь полон", red[0], red[1], red[2])
		}
	}
	else if (value == "car") {//--для работ по перевозке ящиков

		if (isPlayerInVehicle(playerid)) {
			if (sead[playerid] != 0) {
				return
			}
			else if (id1 == 65) {
				if (search_inv_player(playerid, 66, playername) == 0) {
					sendMessage(playerid, "[ERROR] Вы не инкасатор", red[0], red[1], red[2])
					return
				}
			}
			else if (id1 == 24) {
				if (search_inv_player(playerid, 34, 1) == 0) {
					sendMessage(playerid, "[ERROR] Вы не дальнобойщик", red[0], red[1], red[2])
					return
				}
			}
			else if (id1 == 75) {
				if (search_inv_player(playerid, 74, playername) == 0) {
					sendMessage(playerid, "[ERROR] Вы не водитель мусоровоза", red[0], red[1], red[2])
					return
				}
			}

			for (local i = 0; i < max_inv; i++) 
			{
				if (inv_car_empty(playerid, id1, id2)) {
					count2 = count2 + 1
				}
			}

			if (count2 != 0) {
				local count = search_inv_car(vehicleid, id1, id2)

				sendMessage(playerid, "Вы загрузили в т/с "+info_png[id1][0]+" "+count+" шт за "+id2+"$", svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2])
				
				if (id1 == 24) {
					sendMessage(playerid, "[TIPS] Езжайте в порт или в любой бизнес, чтобы разгрузиться", color_tips[0], color_tips[1], color_tips[2])
				}
				else if (id1 == 65) {
					sendMessage(playerid, "[TIPS] Езжайте в казино Калигула, чтобы разгрузиться", color_tips[0], color_tips[1], color_tips[2])
				}
				else if (id1 == 73) {
					sendMessage(playerid, "[TIPS] Езжайте в порт, чтобы разгрузиться", color_tips[0], color_tips[1], color_tips[2])
				}
				else if (id1 == 75) {
					sendMessage(playerid, "[TIPS] Езжайте на свалку, чтобы разгрузиться", color_tips[0], color_tips[1], color_tips[2])
				}

				save_player_action(playerid, "[give_subject] "+playername+" [value - "+value+", count - "+count+"] ["+info_png[id1][0]+", "+id2+"]")
			}
			else
			{
				sendMessage(playerid, "[ERROR] Багажник заполнен", red[0], red[1], red[2])
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Вы не в т/с", red[0], red[1], red[2])
		}
	}

}

function delet_subject(playerid, id)//--удаление предметов из авто, для работ по перевозке ящиков
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local money = 0
		
	if (isPlayerInVehicle(playerid)) 
	{
		if (sead[playerid] != 0) 
		{
			return
		}

		local sic2p = search_inv_car_2_parameter(vehicleid, id)
		local count = search_inv_car(vehicleid, id, sic2p)

		if (count != 0) 
		{
			foreach (k, v in sqlite3( "SELECT * FROM business_db" ))
			{
				if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius)) 
				{
					if (id != 24)
					{
						sendMessage(playerid, "[ERROR] Нужен только "+info_png[24][0], red[0], red[1], red[2])
						return
					}

					if (v["buyprod"] == 0) 
					{
						sendMessage(playerid, "[ERROR] Цена покупки не указана", red[0], red[1], red[2])
						return
					}

					money = count*v["buyprod"]

					if (v["money"] < money) 
					{
						sendMessage(playerid, "[ERROR] Недостаточно средств на балансе бизнеса", red[0], red[1], red[2])
						return
					}

					for (local i = 0; i < max_inv; i++) 
					{
						if (inv_car_delet(playerid, id, sic2p)) 
						{
						}
					}

					sqlite3( "UPDATE business_db SET warehouse = warehouse + '"+count+"', money = money - '"+money+"' WHERE number = '"+v["number"]+"'")

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

					sendMessage(playerid, "Вы разгрузили из т/с "+info_png[id][0]+" "+count+" шт ("+v["buyprod"]+"$ за 1 шт) за "+money+"$", green[0], green[1], green[2])

					save_player_action(playerid, "[delet_subject_business] "+playername+" [count - "+count+"], [+"+money+"$, "+array_player_2[playerid][1]+"$], "+info_bisiness(v["number"]))
					return
				}
			}

			foreach (k, v in down_car_subject) 
			{
				if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3])) {//--места разгрузки
					for (local i = 0; i < max_inv; i++) 
					{
						if (inv_car_delet(playerid, id, sic2p)) 
						{
						}
					}

					money = count*sic2p

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

					sendMessage(playerid, "Вы разгрузили из т/с "+info_png[id][0]+" "+count+" шт ("+sic2p+"$ за 1 шт) за "+money+"$", green[0], green[1], green[2])

					save_player_action(playerid, "[delet_subject_job] "+playername+" [count - "+count+", price - "+sic2p+"], [+"+money+"$, "+array_player_2[playerid][0]+"$]")
					return
				}
			}
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не в т/с", red[0], red[1], red[2])
	}
}

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

function use_inv (playerid, value, id3, id_1, id_2 )//--использование предметов
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local myPos = getPlayerPosition(playerid)
	local id1 = id_1
	local id2 = id_2

	if (value == "player")
	{
		if (id1 == 6 || id1 == 2 || id1 == 25 || id1 == 34)//--ключ авто, права, ключ дома
		{
			me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])
			return
		}
		else if (id1 == 5) 
		{
			if (isPlayerInVehicle(playerid))
			{
				local plate = getVehiclePlateText ( vehicleid )
				local gas = getVehicleFuel(vehicleid)

				if (getSpeed(playerid) < 5)
				{
					if (gas+id2 <= max_fuel)
					{
						setVehicleFuel(vehicleid, (gas+id2))

						sqlite3( "UPDATE car_db SET fuel = '"+(gas+id2)+"' WHERE carnumber = '"+plate+"'")

						me_chat(playerid, playername+" заправил(а) машину из канистры")
						id2 = 0
					}
					else
					{
						sendMessage(playerid, "[ERROR] Максимальная вместимость бака "+max_fuel+" литров", red[0], red[1], red[2])
						return
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red[0], red[1], red[2])
					return
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red[0], red[1], red[2])
				return
			}
		}
		else 
		{
			return
		}

		//--------------------------------------------------------------------------------------------------------------------------------
		save_player_action(playerid, "[use_inv] "+playername+" [value - "+value+"] ["+info_png[id1][0]+", "+id2+"("+id_2+")]")

		if (id2 == 0)
		{
			id1 = 0
			id2 = 0
		}

		inv_server_load( playerid, "player", id3, id1, id2, playername )
	}
}
addEventHandler( "event_use_inv", use_inv )

addCommandHandler( "sms",//смс
function( playerid, id, ...)
{
	local playername = getPlayerName ( playerid )
	local id = id.tointeger()

	if(logged[playerid] == 0)
	{
		return
	}

	if(logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red[0], red[1], red[2])
		return
	}
	
	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	local player_name = getPlayerName ( id )

	sendMessage(playerid, "[SMS TO] "+player_name+" ["+playerid+"]: "+text, yellow[0], yellow[1], yellow[2])
	sendMessage(id, "[SMS FROM] "+playername+" ["+id+"]: "+text, yellow[0], yellow[1], yellow[2])
})

addCommandHandler("pay",//--передача денег
function (playerid, id, cash)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local cash = cash.tointeger()
	local id = id.tointeger()

	if (logged[playerid] == 0) 
	{
		return
	}

	if (cash < 1)
	{
		return
	}

	if (cash > array_player_2[playerid][0])
	{
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red[0], red[1], red[2])
		return
	}

	if (logged[id] == 1)
	{
		local player_name = getPlayerName ( id )
		local Pos = getPlayerPosition(id)
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], 10.0))
		{
			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playerid )

			inv_server_load( id, "player", 0, 1, array_player_2[id][0]+cash, id )

			me_chat(playerid, playername+" передал(а) "+player_name+" "+cash+"$")

			save_player_action(playerid, "[pay] "+playername+" give money "+player_name+" [-"+cash+"$, "+array_player_2[playerid][0]+"$]")
			save_player_action(id, "[pay] "+playername+" give money "+player_name+" [+"+cash+"$, "+array_player_2[id][0]+"$]")
		}
		else
		{
			sendMessage(playerid, "[ERROR] Игрок далеко", red[0], red[1], red[2])
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red[0], red[1], red[2])
	}
})

addCommandHandler("evacuationcar",//-эвакуция авто
function (playerid, id)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local id = id.tointeger()
	local cash = 100

	if (logged[playerid] == 0) 
	{
		return
	}

	if (cash <= array_player_2[playerid][0]) 
	{
		foreach (k, vehicleid in getVehicles())
		{
			local plate = getVehiclePlateText(vehicleid)
			if (id == plate.tointeger())
			{
				local result = sqlite3( "SELECT COUNT() FROM car_db WHERE carnumber = '"+plate+"'" )
				if (result[1]["COUNT()"] == 1) 
				{
					if (result[1]["frozen"] == 0)
					{
						if (search_inv_player(playerid, 6, id) != 0) 
						{
							foreach (player, playername in getPlayers())
							{
								local vehicle = getPlayerVehicle(player)
								if (vehicle == vehicleid)
								{
									removePlayerFromVehicle ( player )
								}
							}

							setVehiclePosition(vehicleid, myPos[0]+5, myPos[1], myPos[2]+1)
							setVehicleRotation(vehicleid, 0.0, 0.0, 0.0)

							sqlite3( "UPDATE car_db SET x = '"+(myPos[0]+5)+"', y = '"+myPos[1]+"', z = '"+(myPos[2]+1)+"' WHERE carnumber = '"+plate+"'")

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playerid )

							sendMessage(playerid, "Вы эвакуировали т/с за "+cash+"$", orange[0], orange[1], orange[2])

							save_player_action(playerid, "[evacuationcar] "+playername+" [-"+cash+"$, "+array_player_2[playerid][0]+"$]")
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас нет ключей от этого т/с", red[0], red[1], red[2])
						}
					}
					else 
					{
						sendMessage(playerid, "[ERROR] Т/с на штрафстоянке", red[0], red[1], red[2])
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Т/с не найдено", red[0], red[1], red[2])
				}

				return
			}
		}

		sendMessage(playerid, "[ERROR] Т/с не найдено", red[0], red[1], red[2])
	}
	else
	{
		sendMessage(playerid, "[ERROR] Нужно иметь "+cash+"$", red[0], red[1], red[2])
	}
})

addCommandHandler("sub",//выдача предмета и кол-во
function(playerid, id1, id2)
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()

	if (inv_player_empty(playerid, val1, val2))
	{
		sendMessage(playerid, "Вы создали "+info_png[val1][0]+" "+val2+" "+info_png[val1][1], lyme[0], lyme[1], lyme[2])
	}
	else
	{
		sendMessage(playerid, "[ERROR] Инвентарь полон", red[0], red[1], red[2])
	}
})

addCommandHandler ( "subcar",//--выдача предметов с числом
function (playerid, id1, id2 )
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle ( playerid )

	if (logged[playerid] == 0)
	{
		return
	}

	if (val1 > info_png.len() || val1 < 2)
	{
		sendMessage(playerid, "[ERROR] от 2 до "+info_png.len(), red[0], red[1], red[2])
		return
	}

	if (!isPlayerInVehicle(playerid)) 
	{
		sendMessage(playerid, "[ERROR] Вы не в т/с", red[0], red[1], red[2])
		return
	}

	give_subject(playerid, "car", val1, val2)

	sendMessage(playerid, "Вы создали "+info_png[val1][0]+" "+val2+" "+info_png[val1][1], lyme[0], lyme[1], lyme[2])

	//save_admin_action(playerid, "[admin_subcar] "+playername+" ["+val1+", "+val2+"]")
})

addCommandHandler("v",
function(playerid, id)
{
	local pos = getPlayerPosition( playerid )
	local vehicleid = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 )
	setVehiclePlateText(vehicleid, "0")
})

addCommandHandler("flip",
function(playerid)
{	
	if (isPlayerInVehicle(playerid))
	{
		local vehicleid = getPlayerVehicle(playerid)
		local rot = getVehicleRotation(vehicleid)
		setVehicleRotation(vehicleid, rot[0], 0.0, 0.0)
	}
})

addCommandHandler("p",
function(playerid, id)
{	
	if (pogoda)
	{
		setWeather(pogoda_leto[id.tointeger()][0])
		sendMessage(playerid, pogoda_leto[id.tointeger()][0])
	}
	else 
	{
		setWeather(pogoda_zima[id.tointeger()][0])
		sendMessage(playerid, pogoda_zima[id.tointeger()][0])
	}
})

addCommandHandler ( "pos",
function ( playerid, ... )
{
	local playername = getPlayerName ( playerid )
	local pos = getPlayerPosition( playerid )
	local text = ""

	if (logged[playername] == 0)
	{
		return
	}

	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	local result = sqlite3( "INSERT INTO position (description, pos) VALUES ('"+text+"', '"+pos[0]+","+pos[1]+","+pos[2]+"')" )
	sendMessage(playerid, "save pos "+text, lyme[0], lyme[1], lyme[2])
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
		/*local table = {}

		table[1] <- 145
		foreach (idx, value in table) {
			print(value)
		}

		//delete table[1]
		foreach (idx, value in table) {
			print(value)
		}/*

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