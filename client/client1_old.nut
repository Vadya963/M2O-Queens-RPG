local playerid = -1
local screen = getScreenSize()
local max_inv = 24
local width = 370.0
local height = 250.0
local image_w_h = 50.0
local dxDrawTexture_width_height = 0.78
local pos_x_3d_image = (screen[0]/2)-(width/2)
local pos_y_3d_image = (screen[1]/2)-(height/2)
local time_game = 0//--сколько минут играешь
local element_data = {}
local isCursorShowing = false//+дебагинфа
local blip_data = {//ud блипа[0] x[1] y[2] категория[3] ид[4] радиус[5] отображение[6] //бд блипов
	//[1] = [0, 0,0, 0,1, 5, false]
}
local sync_timer = false
local number_business = -1//номер бизнеса
local value_business = -1//тип бизнеса
local width_need = (screen[0]/5.04)//--ширина нужд 271
local height_need = (screen[1]/5.68)//--высота нужд 135
local screenWidth = screen[0]
local zakon_nalog_car = 500
local zakon_nalog_house = 1000
local zakon_nalog_business = 2000

//---------------------грайдлист-------------------------
local gridlist_table_window = {}//таблица созданных окон
local gridlist_table_text = {}//таблица созданных текстов
local gridlist_window = false//окно в котором выделяется текст
local gridlist_lable = false//текст который будет выделяться
local gridlist_row = -1//номер текста который будет выделяться
local gridlist_select = false//выделение текста
//-------------------------------------------------------

local gui_fon = 0//1 открыт, 0 закрыт
local gui_use = 0//использовать
local gui_drop = 0//выкинуть
local state_inv_gui = false//инв-рь открыт или закрыт
local gui_selection = false//выделение пнг

local state_inv_player = false//состояние ин-ря игрока
local state_inv_car = false//состояние ин-ря тс
local state_inv_house = false//состояние ин-ря дома

local info_tab = ""//положение картинки в табе
local info3 = 0//слот
local info1 = 0//пнг
local info2 = 0//число

local plate = ""//если в тс
local house = ""//если около дома

local no_use_subject = [-1,0,1]

//--перемещение картинки
local lmb = 0//--лкм
local info3_selection_1 = -1// --слот картинки
local info1_selection_1 = -1// --номер картинки
local info2_selection_1 = -1// --значение картинки

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
	[34] = ["лицензия дальнобойщика", "шт"],
	[35] = ["лом", "процентов"],
	[36] = ["документы на", "бизнес"],
	[37] = ["админский жетон", "шт"],
	[38] = ["риэлторская лицензия", "шт"],
	[39] = ["тушка свиньи", "$ за штуку"],
	[40] = ["молоток", "шт"],
	[41] = ["лицензия на оружие", ""],
	[42] = ["бургер", "шт"],
	[43] = ["пицца", "шт"],
	[44] = ["мыло", "процентов"],
	[45] = ["пижама", "процентов"],
	[46] = ["алкотестер", "шт"],
	[47] = ["наркотестер", "шт"],
	[48] = ["квитанция для оплаты дома на", "дней"],
	[49] = ["квитанция для оплаты бизнеса на", "дней"],
	[50] = ["квитанция для оплаты т/с на", "дней"],
	[51] = ["коробка с продуктами", "$ за штуку"],
	[52] = ["компос", "шт"],
	[53] = ["лицензия таксиста", "шт"],
	[54] = ["инкасаторская сумка", "$ в сумке"],
	[55] = ["лицензия инкассатора", "шт"],
	[56] = ["бензопила", "шт"],
	[57] = ["дрова", "кг"],
	[58] = ["пустая коробка", "шт"],
	[59] = ["кирка", "шт"],
	[60] = ["руда", "кг"],
	[61] = ["бочка с нефтью", "$ за штуку"],
	[62] = ["лицензия водителя мусоровоза", "шт"],
	[63] = ["мусор", "кг"],
	[64] = ["антипохмелин", "шт"],
}

//--------------------------------------------грайдлист--------------------------------------------
function guiCreateGridList (x,y, width, height)
{
	local window = guiCreateElement( 5, "", x,y, width, height+4.0, false )

	if (window)
	{
		local table_len = gridlist_table_window.len()

		gridlist_table_window[table_len] <- window
		gridlist_table_text[table_len] <- {}
		return [window,table_len]
	}
	else 
	{
		return false
	}
}

function guiGridListAddRow (window, text)
{
	if (window[0])
	{
		local table_len = gridlist_table_text[ window[1] ].len()
		local guiSize_window = guiGetSize( window[0] )
		local text_gui = guiCreateElement( 6, text, 10.0, (15.0*table_len), guiSize_window[0], 15.0, false, window[0] )

		gridlist_table_text[ window[1] ][ table_len ] <- [text_gui,table_len]
		return true
	}
	else 
	{
		return false
	}
}

function guiGridListGetItemText ()
{
	if (gridlist_lable)
	{
		local text = guiGetText(gridlist_lable)
		return text
	}
	else 
	{
		return false
	}
}

function guiGridListGetSelectedItem ()
{
	if (gridlist_row != -1)
	{
		return gridlist_row
	}
	else 
	{
		return false
	}
}

function guiSetVisibleGridList (window, bool)
{
	if (window)
	{		
		guiSetVisible( window[0], bool )

		foreach (idx, value in gridlist_table_text[ window[1] ]) 
		{
			guiSetVisible( value[0], bool )
		}

		gridlist_window = false
		gridlist_lable = false
		gridlist_row = -1
		gridlist_select = false

		return true
	}
	else 
	{
		return false
	}
}
//-------------------------------------------------------------------------------------------------


local shop = {
	[3] = [info_png[3][0], 20, 5],
	[4] = [info_png[4][0], 1, 250],
	[7] = [info_png[7][0], 20, 10],
	[8] = [info_png[8][0], 20, 15],
	[11] = [info_png[11][0], 1, 100],
	[26] = [info_png[26][0], 1, 10000],
	[35] = [info_png[35][0], 10, 500],
	[44] = [info_png[44][0], 100, 50],
	[45] = [info_png[45][0], 100, 100],
	[46] = [info_png[46][0], 1, 100],
	[47] = [info_png[47][0], 1, 100],
	[52] = [info_png[52][0], 1, 100],
	[64] = [info_png[64][0], 1, 250],
}
local shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (shop_menu, text)
}
guiSetVisibleGridList (shop_menu, false)

local weapon = {
	[9] = [info_png[9][0], 11, 4700],
	[12] = [info_png[12][0], 2, 630],
	[13] = [info_png[13][0], 4, 1230],
	[14] = [info_png[14][0], 5, 2700],
	[15] = [info_png[15][0], 8, 4000],
	[16] = [info_png[16][0], 10, 2190],
	[17] = [info_png[17][0], 3, 1050],
	[18] = [info_png[18][0], 6, 1500],
	[19] = [info_png[19][0], 9, 1990]
}
local weapon_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in weapon)
{
	local text = v[0]+" 25 "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (weapon_menu, text)
}
guiSetVisibleGridList (weapon_menu, false)

local gas = {
	[5] = [info_png[5][0], 20, 250],
}
local gas_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in gas)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (gas_menu, text)
}
guiSetVisibleGridList (gas_menu, false)

local repair_shop = {
	[23] = [info_png[23][0], 1, 100],
}
local repair_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in repair_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (repair_shop_menu, text)
}
guiSetVisibleGridList (repair_shop_menu, false)

local eda = {
	[21] = [info_png[21][0], 1, 45],
	[22] = [info_png[22][0], 1, 60],
	[42] = [info_png[42][0], 1, 100],
	[43] = [info_png[43][0], 1, 50],
}
local eda_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in eda)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (eda_menu, text)
}
guiSetVisibleGridList (eda_menu, false)

local day_nalog = 7
local mayoralty_shop = {
	[2] = ["права", 1, 1000],
	[41] = ["лицензия на оружие", 1, 10000],
	[53] = ["лицензия таксиста", 1, 5000],
	[55] = ["лицензия инкасатора", 1, 10000],
	[34] = ["лицензия дальнобойщика", 1, 15000],
	[62] = ["лицензия водителя мусоровоза", 1, 20000],
	[48] = ["квитанция для оплаты дома на "+day_nalog+" дней", day_nalog, (zakon_nalog_house*day_nalog)],
	[49] = ["квитанция для оплаты бизнеса на "+day_nalog+" дней", day_nalog, (zakon_nalog_business*day_nalog)],
	[50] = ["квитанция для оплаты т/с на "+day_nalog+" дней", day_nalog, (zakon_nalog_car*day_nalog)],
}
local mayoralty_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in mayoralty_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (mayoralty_shop_menu, text)
}
guiSetVisibleGridList (mayoralty_shop_menu, false)

local shop_menu_button = guiCreateElement( 2, "купить", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2)+4.0, 400.0, 30.0, false )
guiSetVisible( shop_menu_button, false )

function tune_close ()//--закрытие окна
{
	number_business = -1
	value_business = -1

	showCursor( false )
	guiSetVisible( shop_menu_button, false )

	guiSetVisibleGridList (shop_menu, false)
	guiSetVisibleGridList (weapon_menu, false)
	guiSetVisibleGridList (gas_menu, false)
	guiSetVisibleGridList (repair_shop_menu, false)
	guiSetVisibleGridList (eda_menu, false)
	guiSetVisibleGridList (mayoralty_shop_menu, false)
}
addEventHandler ( "event_gui_delet", tune_close )

function shop_menu_fun(number, value)//--создание окна магазина
{
	number_business = number
	value_business = value

	showCursor( true )
	guiSetVisible( shop_menu_button, true )

	if (value_business == 0)
	{
		guiSetVisibleGridList (weapon_menu, true)
	}
	else if (value_business == 2)
	{
		guiSetVisibleGridList (shop_menu, true)
	}
	else if (value_business == 3)
	{
		guiSetVisibleGridList (gas_menu, true)
	}
	else if (value_business == 4)
	{
		guiSetVisibleGridList (repair_shop_menu, true)
	}
	else if (value_business == 5)
	{
		guiSetVisibleGridList (eda_menu, true)
	}
	else if (value_business == "pd")
	{
		guiSetVisibleGridList (weapon_menu, true)
	}
	else if (value_business == "mer")
	{
		guiSetVisibleGridList (mayoralty_shop_menu, true)
	}
}
addEventHandler ( "event_shop_menu_fun", shop_menu_fun )


//загрузка картинок для отображения на земле
local image = array(info_png.len(),0)

for (local i = 0; i < image.len(); i++)
{
	image[i] = dxLoadTexture(i+".png")
}

local mouse = dxLoadTexture("mouse.png")

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

//---------------------таймеры-------------------------------------------------------------
timer(function () {
	time_game = time_game+1
}, 60000, -1)

timer(function () {
	sync_timer = true
}, 2000, 1)

timer(function () {
	local myPos = getPlayerPosition(playerid)

	foreach (k, v in blip_data) 
	{	
		if ( isPointInCircle2D(myPos[0], myPos[1], v[1].tofloat(), v[2].tofloat(), v[5].tofloat()) )
		{	
			if (!v[6])
			{
				blip_data[k][0] = createBlip(v[1].tofloat(), v[2].tofloat(), v[3], v[4])
				blip_data[k][6] = true
			}
		}
		else 
		{
			if (v[6])
			{
				destroyBlip(v[0])
				blip_data[k][6] = false
			}
		}
	}

}, 500, -1)
//-----------------------------------------------------------------------------------------

local inv_slot_player = [//инв-рь игрока {пнг картинка 0, значение 1}
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0]
]

local inv_slot_car = [//инв-рь игрока {пнг картинка 0, значение 1}
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0]
]

local inv_slot_house = [//инв-рь игрока {пнг картинка 0, значение 1}
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0],
	[0,0]
]

local inv_pos = [//позиция слотов {слот 0, позиция х 1, позиция у 2}
	[0,10.0,10.0],
	[0,70.0,10.0],
	[0,130.0,10.0],
	[0,190.0,10.0],
	[0,250.0,10.0],
	[0,310.0,10.0],

	[0,10.0,70.0],
	[0,70.0,70.0],
	[0,130.0,70.0],
	[0,190.0,70.0],
	[0,250.0,70.0],
	[0,310.0,70.0],

	[0,10.0,130.0],
	[0,70.0,130.0],
	[0,130.0,130.0],
	[0,190.0,130.0],
	[0,250.0,130.0],
	[0,310.0,130.0],

	[0,10.0,190.0],
	[0,70.0,190.0],
	[0,130.0,190.0],
	[0,190.0,190.0],
	[0,250.0,190.0],
	[0,310.0,190.0]
]

local button_pos = [//позиция кнопок
	[0,"PLAYER",10.0,15.0],
	[0,"CAR",70.0,15.0],
	[0,"HOUSE",130.0,15.0]
]

gui_fon = guiCreateElement( 13, "low_fon1.png", 0.0, 0.0, screen[0], screen[1], false )//фон для гуи
guiSetAlpha(gui_fon, 0.0)

gui_use = guiCreateElement( 2, "", 0.0, 0.0, pos_x_3d_image, screen[1], false, gui_fon )//использовать предмет
gui_drop = guiCreateElement( 2, "", (screen[0]-pos_x_3d_image), 0.0, pos_x_3d_image, screen[1], false, gui_fon )//выкинуть предмет

//создание инв-ря и кнопок
for (local i = 0; i < max_inv; i++) 
{
	inv_pos[i][0] = guiCreateElement( 2, "", (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image), image_w_h, image_w_h, false, gui_fon )
	guiSetVisible( inv_pos[i][0], false )
}

for (local i = 0; i < button_pos.len(); i++)
{
	button_pos[i][0] = guiCreateElement( 2, "", (button_pos[i][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[i][3]), 50.0, button_pos[i][3], false, gui_fon )
	guiSetVisible( button_pos[i][0], false )
}

guiSetVisible( gui_fon, false )


guiCreateElement( 13, "health.png", screen[0]-30.0, height_need-7.5, 30.0, 30.0, false )
guiCreateElement( 13, "alcohol.png", screen[0]-30.0, height_need-7.5+(20+7.5)*1, 30.0, 30.0, false )
guiCreateElement( 13, "drugs.png", screen[0]-30.0, height_need-7.5+(20+7.5)*2, 30.0, 30.0, false )
guiCreateElement( 13, "satiety.png", screen[0]-30.0, height_need-7.5+(20+7.5)*3, 30.0, 30.0, false )
guiCreateElement( 13, "hygiene.png", screen[0]-30.0, height_need-7.5+(20+7.5)*4, 30.0, 30.0, false )
guiCreateElement( 13, "sleep.png", screen[0]-30.0, height_need-7.5+(20+7.5)*5, 30.0, 30.0, false )

function dxdrawtext(text, x, y, color, shadow, font, scale)
{	
	if (shadow)
	{
		dxDrawText ( text, x+1, y+1, fromRGB ( 0, 0, 0 ), false, font, scale )

		dxDrawText ( text, x, y, color, false, font, scale )
	}
	else
	{
		dxDrawText ( text, x, y, color, false, font, scale )
	}
}

function dxdrawline_h (x1,y1, x2,y2, color, scale)
{
	for (local i = 0; i <= scale; i++) 
	{
		local j = i/2
		dxDrawLine(x1,y1-j, x2,y2-j, color)
		dxDrawLine(x1,y1+j, x2,y2+j, color)
	}
}

function dxdrawline_w (x1,y1, x2,y2, color, scale)
{
	for (local i = 0; i <= scale; i++) 
	{
		local j = i/2
		dxDrawLine(x1-j,y1, x2-j,y2, color)
		dxDrawLine(x1+j,y1, x2+j,y2, color)
	}
}

function getSpeed()
{
	local velo = getVehicleSpeed(vehicleid)
	local speed = getDistanceBetweenPoints3D(0.0,0.0,0.0, velo[0],velo[1],velo[2])
	return speed*2.27*1.6
}

function getElementData (key)
{	
	if (element_data[key])
	{
		//print("getElementData["+key+"] = "+element_data[playerid][key])
		return element_data[key]
	}
	else 
	{
		return "0"
	}
}

function element_data_push_client(key, value)
{
	element_data[key] <- value
	//print("event_element_data_push_client["+key+"] = "+value)
}
addEventHandler ( "event_element_data_push_client", element_data_push_client )

function blip_create(x, y, lib, icon, r)
{
	blip_data[ blip_data.len() ] <- [0, x, y, lib, icon, r, false]
}
addEventHandler ( "event_blip_create", blip_create )

local earth = {}//--слоты земли
//-----------эвенты------------------------------------------------------------------------
function earth_load (value, i, x, y, z, id1, id2)//--изменения слотов земли
{
	if (value != "nil")
	{
		earth[i] <- [x,y,z,id1,id2]
	}
	else
	{
		earth = {}
	}
}
addEventHandler ( "event_earth_load", earth_load )

//сохранение действий игрока
function save_player_action (text)
{
	print(text)
}
addEventHandler ( "event_save_player_action", save_player_action )

function fone1() 
{
	if(isMainMenuShowing())
	{
		return
	}

	openMap()
}

function fone2() 
{
	if(isMainMenuShowing())
	{
		return
	}
	
	showChat( true )
}

function down_down() 
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "down_chat" )
}

function up_down() 
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "up_chat" )
}

addEventHandler("onClientScriptInit", 
function() 
{
	bindKey( "tab", "down", tab_down )
	bindKey( "f1", "down", f1_down )
	bindKey( "m", "down", fone1 )
	bindKey( "m", "up", fone2 )
	bindKey( "e", "down", e_down )
	bindKey( "x", "down", x_down )
	bindKey( "page_up", "down", up_down )
	bindKey( "page_down", "down", down_down )
})

function zamena_img()
{
//--------------------------------------------------------------замена куда нажал 1 раз----------------------------------------------------------------------------
	if (info_tab == "player")
	{
		triggerServerEvent( "event_inv_server_load", "player", info3_selection_1, info1, info2, playerid )
	}
	else if (info_tab == "car")
	{
		triggerServerEvent( "event_inv_server_load", "car", info3_selection_1, info1, info2, plate )
	}
	else if (info_tab == "house")
	{
		triggerServerEvent( "event_inv_server_load", "house", info3_selection_1, info1, info2, house )
	}
}

local lastTick = getTickCount()
local framesRendered = 0
local FPS = 0
addEventHandler( "onClientFrameRender",
function( post )
{
	local local_param = {
		[0] = "state_inv_gui "+state_inv_gui,
		[1] = "gui_selection "+gui_selection,
		[2] = "state_inv_player "+state_inv_player,
		[3] = "state_inv_car "+state_inv_car,
		[4] = "state_inv_house "+state_inv_house,
		[5] = "info_tab "+info_tab,
		[6] = "info3 "+info3,
		[7] = "info1 "+info1,
		[8] = "info2 "+info2,
		[9] = "plate "+plate,
		[10] = "house "+house,
		[11] = "lmb "+lmb,
		[12] = "info3_selection_1 "+info3_selection_1,
		[13] = "info1_selection_1 "+info1_selection_1,
		[14] = "info2_selection_1 "+info2_selection_1,
		[15] = "number_business "+number_business,
		[16] = "value_business "+value_business,
	}

	playerid = getLocalPlayer()

	local myPos = getPlayerPosition(playerid)

	local currentTick = getTickCount()
	local elapsedTime = currentTick - lastTick

	if (elapsedTime >= 500)
	{
		FPS = framesRendered
		lastTick = currentTick
		framesRendered = 0
	}
	else
	{
		framesRendered++
	}

	if (sync_timer)
	{
		local alcohol = getElementData ( "alcohol_data" ).tofloat()//--макс 500
		local satiety = getElementData ( "satiety_data" ).tofloat()//--макс 100
		local hygiene = getElementData ( "hygiene_data" ).tofloat()//--макс 100
		local sleep = getElementData ( "sleep_data" ).tofloat()//--макс 100
		local drugs = getElementData ( "drugs_data" ).tofloat()//--макс 100
		local heal_player = split(getPlayerHealth(playerid).tostring(), ".")

		local client_time = getDateTime()
		local text = "FPS: "+FPS+" | Ping: "+getPlayerPing(playerid)+" | ID: "+playerid+" | Serial: "+getElementData("serial")+" | Players online: "+(getPlayerCount()+1)+" | Minute in game: "+time_game+" | Time: "+getElementData("timeserver")+" | "+client_time
		dxdrawtext ( text, 2.0, 0.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )

		if (getPlayerVehicle(playerid) != -1)
		{
			local speed_vehicle = "plate "+plate+" | fuel "+getElementData("fuel_data")
			dxdrawtext ( speed_vehicle, 2.0, screen[1]-16.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		}
		
		if (isCursorShowing)
		{
			local pos = getMousePosition()
			dxdrawtext ( pos[0]+", "+pos[1], pos[0]+15.0, pos[1], fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		
			for (local i = 0; i < 9; i++) 
			{	
				dxdrawtext ( getElementData(i.tostring()), 10.0, 280.0+(15.0*i), fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			}

			for (local i = 0; i < local_param.len(); i++) 
			{	
				dxdrawtext ( local_param[i], 610.0, 280.0+(15.0*i), fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			}

			dxdrawtext ( heal_player[0], screenWidth-width_need-30-30, height_need, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( (alcohol/100).tostring(), screenWidth-width_need-30-30, height_need+(20+7.5)*1, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( drugs.tostring(), screenWidth-width_need-30-30, height_need+(20+7.5)*2, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( satiety.tostring(), screenWidth-width_need-30-30, height_need+(20+7.5)*3, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( hygiene.tostring(), screenWidth-width_need-30-30, height_need+(20+7.5)*4, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( sleep.tostring(), screenWidth-width_need-30-30, height_need+(20+7.5)*5, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		}

		dxDrawRectangle( screenWidth-width_need-30, height_need, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need, (width_need/720)*getPlayerHealth(playerid), 15.0, fromRGB ( 90, 151, 107, 255 ) )

		//--нужды
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*1, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*1, ((width_need/500.0)*alcohol), 15.0, fromRGB ( 90, 151, 107, 255 ) )

		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*2, width_need, 15.0 fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*2, ((width_need/100.0)*drugs), 15.0, fromRGB ( 90, 151, 107, 255 ) )

		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*3, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*3,( (width_need/100.0)*satiety), 15.0, fromRGB ( 90, 151, 107, 255 ) )

		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*4, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*4, ((width_need/100.0)*hygiene), 15.0, fromRGB ( 90, 151, 107, 255 ) )

		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*5, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need+(20+7.5)*5, ((width_need/100.0)*sleep), 15.0, fromRGB ( 90, 151, 107, 255 ) )
	}


	if (state_inv_gui)//инв-рь
	{
		dxDrawRectangle( pos_x_3d_image, (pos_y_3d_image-(10.0+button_pos[0][3])), width, (10.0+button_pos[0][3]), fromRGB( 0, 0, 0, 255 ) )
		dxDrawRectangle( pos_x_3d_image, pos_y_3d_image, width, height, fromRGB( 0, 0, 0, 255 ) )

		if (state_inv_player)
		{
			for (local i = 0; i < max_inv; i++)
			{
				local dimensions = dxGetTextDimensions( inv_slot_player[i][1].tostring(), 1.0, "tahoma-bold" )
				dxDrawTexture(image[inv_slot_player[i][0]], (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_player[i][1].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+35), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			
				/*local scale = 1.0
				local formyla = (image_w_h/dimensions[0])

				if ( formyla <= scale )
				{
					scale = formyla
					local slp = split(inv_slot_player[i][1].tostring(), "_")
					dxdrawtext( slp[0].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+20), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
					dxdrawtext( slp[1].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+35), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
				}
				else 
				{
					dxdrawtext( inv_slot_player[i][1].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+35), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
				}*/
			}
		}

		if (state_inv_car) 
		{
			for (local i = 0; i < max_inv; i++)
			{
				local dimensions = dxGetTextDimensions( inv_slot_car[i][1].tostring(), 1.0, "tahoma-bold" )
				dxDrawTexture(image[inv_slot_car[i][0]], (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_car[i][1].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+35), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

		if (state_inv_house) 
		{
			for (local i = 0; i < max_inv; i++)
			{
				local dimensions = dxGetTextDimensions( inv_slot_house[i][1].tostring(), 1.0, "tahoma-bold" )
				dxDrawTexture(image[inv_slot_house[i][0]], (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_house[i][1].tostring(), (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image+35), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}


		if (gui_selection)//выделение пнг
		{
			if (info_tab == "player" && state_inv_player || info_tab == "car" && state_inv_car || info_tab == "house" && state_inv_house)
			{
				dxDrawRectangle( (inv_pos[info3][1]+pos_x_3d_image), (inv_pos[info3][2]+pos_y_3d_image), image_w_h, image_w_h, fromRGB( 255, 255, 130, 100 ) )
			}
		}


		//dxDrawRectangle( (button_pos[0][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[0][3]), image_w_h, button_pos[0][3], fromRGB( 50, 50, 50, 200 ) )
		if (state_inv_player)
		{
			dxdrawtext( button_pos[0][1].tostring(), (button_pos[0][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[0][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
		}
		else
		{
			dxdrawtext( button_pos[0][1].tostring(), (button_pos[0][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[0][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
		}

		if (plate != "")
		{
			//dxDrawRectangle( (button_pos[1][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[1][3]), image_w_h, button_pos[1][3], fromRGB( 50, 50, 50, 200 ) )
			if (state_inv_car)
			{
				dxdrawtext( button_pos[1][1].tostring(), (button_pos[1][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[1][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
			}
			else
			{
				dxdrawtext( button_pos[1][1].tostring(), (button_pos[1][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[1][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

		if (house != "")
		{
			//dxDrawRectangle( (button_pos[2][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[2][3]), image_w_h, button_pos[2][3], fromRGB( 50, 50, 50, 200 ) )
			if (state_inv_house)
			{
				dxdrawtext( button_pos[2][1].tostring(), (button_pos[2][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[2][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
			}
			else
			{
				dxdrawtext( button_pos[2][1].tostring(), (button_pos[2][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[2][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

		local pos = getMousePosition()
		dxDrawTexture(mouse, pos[0], pos[1], 0.73, 1.0, 0.0, 0.0, 0.0, 255)
	}


	if (gridlist_select)
	{
		local guiPos_window = guiGetPosition( gridlist_window )
		local guiSize_window = guiGetSize( gridlist_window )

		local guiPos_lable = guiGetPosition( gridlist_lable )
		local guiSize_lable = guiGetSize( gridlist_lable )

		dxDrawRectangle( guiPos_window[0]+guiPos_lable[0]-10.0, guiPos_window[1]+guiPos_lable[1]+2.0, guiSize_lable[0], guiSize_lable[1], fromRGB( 81, 101, 204, 150 ) )
	}

	foreach (k, v in earth)//--отображение предметов на земле
	{
		local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], v[0], v[1], v[2], 20.0 )

		if (area)
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2] )
			dxDrawTexture(image[v[3]], coords[0]-(57/2), coords[1], 0.88, 0.88, 0.0, 0.0, 0.0, 255)

			local coords = getScreenFromWorld( v[0], v[1], v[2]+0.2 )
			local dimensions = dxGetTextDimensions("Press E", 1.0, "tahoma-bold" )
			dxdrawtext ( "Press E", coords[0]-(dimensions[0]/2), coords[1], fromRGB( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0 )
		}
	}
})

function tab_down_fun()//инв-рь игрока
{
	if (state_inv_gui)
	{
		state_inv_gui = false
		state_inv_player = false
		state_inv_car = false
		state_inv_house = false
		gui_selection = false
		info3 = 0
		info1 = 0
		info2 = 0
		info_tab = ""
		info3_selection_1 = -1
		info1_selection_1 = -1
		info2_selection_1 = -1
		lmb = 0
		showCursor( false )

		guiSetVisible( gui_fon, false )
		guiSetVisible( button_pos[0][0], false )

		for (local i = 0; i < max_inv; i++) 
		{
			guiSetVisible( inv_pos[i][0], false )
		}

		if (plate != "") 
		{
			guiSetVisible( button_pos[1][0], false )
		}

		if (house != "") 
		{
			guiSetVisible( button_pos[2][0], false )
		}
	}
	else
	{
		state_inv_gui = true
		state_inv_player = true
		showCursor( true )

		guiSetVisible( gui_fon, true )
		guiSetVisible( button_pos[0][0], true )

		for (local i = 0; i < max_inv; i++) 
		{
			guiSetVisible( inv_pos[i][0], true )
		}

		if (plate != "") 
		{
			guiSetVisible( button_pos[1][0], true )
		}

		if (house != "") 
		{
			guiSetVisible( button_pos[2][0], true )
		}
	}
}
addEventHandler( "event_tab_down_fun", tab_down_fun)

function tab_down()//инв-рь игрока
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "event_tab_down" )
}

function e_down()//поднять предмет
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "event_e_down" )
}

function x_down()//меню магазинов и зданий
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "event_x_down" )
}

local test_button = 0
local test_button2 = 0
local test_button3 = 0
local test = 0

local test_button11 = 0
local test_button22 = 0
local test_button33 = 0
local test1 = 0

addEventHandler( "onGuiElementClick",
function( element )
{
	for (local i = 0; i < max_inv; i++) 
	{
		if (inv_pos[i][0] == element)
		{
			info3 = i

			if (state_inv_player)
			{
				info1 = inv_slot_player[info3][0]
				info2 = inv_slot_player[info3][1]

				if (lmb == 0)
				{
					foreach (idx, v in no_use_subject)
					{
						if (v == info1)
						{
							lmb = 0
							gui_selection = false
							return
						}
					}

					gui_selection = true
					info_tab = "player"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------замена куда нажал 2 раз----------------------------------------------------------------------------
					/*if (inv_slot_player[info3][0] != 0)
					{*/
						local no_use_subject_1 = [-1,1]
						foreach (idx, v in no_use_subject_1)
						{
							if (v == info1)
							{
								lmb = 0
								gui_selection = false
								return
							}
						}

						/*info_tab = "player"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}*/

					triggerServerEvent( "event_inv_server_load", "player", info3, info1_selection_1, info2_selection_1, playerid )

					zamena_img()

					gui_selection = false
					info_tab = ""
					lmb = 0
				}
			}
			else if (state_inv_car)
			{
				info1 = inv_slot_car[info3][0]
				info2 = inv_slot_car[info3][1]
				
				if (lmb == 0)
				{
					foreach (idx, v in no_use_subject)
					{
						if (v == info1)
						{
							lmb = 0
							gui_selection = false
							return
						}
					}

					gui_selection = true
					info_tab = "car"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------замена куда нажал 2 раз----------------------------------------------------------------------------
					/*if (inv_slot_car[info3][0] != 0)
					{*/
						local no_use_subject_1 = [-1,1]
						foreach (idx, v in no_use_subject_1)
						{
							if (v == info1)
							{
								lmb = 0
								gui_selection = false
								return
							}
						}

						/*info_tab = "car"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}*/

					triggerServerEvent( "event_inv_server_load", "car", info3, info1_selection_1, info2_selection_1, plate )

					zamena_img()

					gui_selection = false
					info_tab = ""
					lmb = 0
				}
			}
			else if (state_inv_house)
			{
				info1 = inv_slot_house[info3][0]
				info2 = inv_slot_house[info3][1]
				
				if (lmb == 0)
				{
					foreach (idx, v in no_use_subject)
					{
						if (v == info1)
						{
							lmb = 0
							gui_selection = false
							return
						}
					}

					gui_selection = true
					info_tab = "house"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------замена куда нажал 2 раз----------------------------------------------------------------------------
					/*if (inv_slot_house[info3][0] != 0)
					{*/
						local no_use_subject_1 = [-1,1]
						foreach (idx, v in no_use_subject_1)
						{
							if (v == info1)
							{
								lmb = 0
								gui_selection = false
								return
							}
						}

						/*info_tab = "house"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}*/

					triggerServerEvent( "event_inv_server_load", "house", info3, info1_selection_1, info2_selection_1, house )

					zamena_img()

					gui_selection = false
					info_tab = ""
					lmb = 0
				}
			}

			return
		}
	}


	if (button_pos[0][0] == element)
	{
		state_inv_player = true
		state_inv_car = false
		state_inv_house = false
	}
	else if (button_pos[1][0] == element)
	{
		state_inv_player = false
		state_inv_car = true
		state_inv_house = false
	}
	else if (button_pos[2][0] == element)
	{
		state_inv_player = false
		state_inv_car = false
		state_inv_house = true
	}

	if (gui_use == element)
	{
		if (lmb == 1)
		{
			foreach (k, v in no_use_subject) 
			{
				if (v == info1)
				{
					return
				}
			}

			if (info_tab == "player" && state_inv_player)
			{
				triggerServerEvent( "event_use_inv", "player", info3, info1, info2 )
			}

			gui_selection = false
			info_tab = ""
			info1 = -1
			info2 = -1
			info3 = -1
			lmb = 0
		}
	}
	else if (gui_drop == element) 
	{
		if (lmb == 1)
		{
			foreach (k, v in no_use_subject) 
			{
				if (v == info1)
				{
					return
				}
			}

			if (info_tab == "player" && state_inv_player)
			{
				triggerServerEvent( "event_throw_earth_server", "player", info3, info1, info2, playerid )
			}
			else if (info_tab == "car" && state_inv_car)
			{
				if (isPlayerInVehicle(playerid))
				{
					triggerServerEvent( "event_throw_earth_server", "car", info3, info1, info2, plate )
				}
			}
			else if (info_tab == "house" && state_inv_house)
			{
				triggerServerEvent( "event_throw_earth_server", "house", info3, info1, info2, house )
			}

			gui_selection = false
			info_tab = ""
			info1 = -1
			info2 = -1
			info3 = -1
			lmb = 0
		}
	}


	foreach (idx, value in gridlist_table_window) 
	{	
		foreach (idx2, value2 in gridlist_table_text[idx])
		{	
			if (element == value2[0])
			{
				gridlist_window = gridlist_table_window[idx]
				gridlist_lable = element
				gridlist_row = value2[1]
				gridlist_select = true
				break
			}
		}
	}


	if (element == shop_menu_button)
	{	
		if (guiGridListGetItemText())
		{
			triggerServerEvent( "event_buy_subject_fun", guiGridListGetItemText(), number_business, value_business )

			//sendMessage("shop_menu_button - "+guiGridListGetItemText().tostring())
		}
	}


//-------------------------------------тестирование разных функций---------------------------------
	if (element == test_button)
	{
		sendMessage("test_button - "+guiGridListGetSelectedItem().tostring())
	}
	if (element == test_button2)
	{
		sendMessage("test_button2 - "+guiSetVisibleGridList (test, false).tostring())
	}
	if (element == test_button3)
	{
		sendMessage("test_button3 - "+guiSetVisibleGridList (test, true).tostring())
	}

	if (element == test_button11)
	{
		sendMessage("test_button11 - "+guiGridListGetItemText().tostring())
	}
	if (element == test_button22)
	{
		sendMessage("test_button22 - "+guiSetVisibleGridList (test1, false).tostring())
	}
	if (element == test_button33)
	{
		sendMessage("test_button33 - "+guiSetVisibleGridList (test1, true).tostring())
	}
})

addEventHandler( "onGuiElementMouseEnter",
function( element )
{
	

})

addEventHandler( "onGuiElementMouseLeave",
function( element )
{
	
})

addEventHandler( "event_inv_load",
function( value, id3, id1, id2 )
{
	if (value == "player")
	{
		inv_slot_player[id3][0] = id1
		inv_slot_player[id3][1] = id2
	}
	else if (value == "car")
	{
		inv_slot_car[id3][0] = id1
		inv_slot_car[id3][1] = id2
	}
	else if (value == "house")
	{
		inv_slot_house[id3][0] = id1
		inv_slot_house[id3][1] = id2
	}
})

function tab_load (value, text)//загрузка надписей в табе
{
	if (value == "car")
	{
		plate = text

		if (state_inv_gui)
		{
			if (plate != "") 
			{
				guiSetVisible( button_pos[1][0], true )
			}
			else 
			{
				guiSetVisible( button_pos[1][0], false )

				state_inv_player = true
				state_inv_car = false
				gui_selection = false
				info_tab = ""
				info1 = -1
				info2 = -1
				info3 = -1
				lmb = 0
			}
		}
	}
	else if (value == "house")
	{
		house = text

		if (state_inv_gui)
		{
			if (house != "") 
			{
				guiSetVisible( button_pos[2][0], true )
			}
			else 
			{
				guiSetVisible( button_pos[2][0], false )

				state_inv_player = true
				state_inv_house = false
				gui_selection = false
				info_tab = ""
				info1 = -1
				info2 = -1
				info3 = -1
				lmb = 0
			}
		}
	}
}
addEventHandler ( "event_tab_load", tab_load )

function f1_down()
{
	showCursor( !isCursorShowing )
	isCursorShowing = !isCursorShowing
}


//-------------------------------------тестирование разных функций---------------------------------
/*local mayoralty_shop = {
		[0] = "права",
		[1] = "лицензия на оружие", 
		[2] = "лицензия таксиста",
		[3] = "лицензия инкасатора", 
		[4] = "лицензия дальнобойщика",
		[5] = "лицензия водителя мусоровоза",
		[6] = "квитанция для оплаты дома на ",
		[7] = "квитанция для оплаты бизнеса на",
		[8] = "квитанция для оплаты т/с на "
	}

	test = guiCreateGridList(200.0, 100.0, 300.0, 135.0)

	foreach (k,v in mayoralty_shop)
	{
		guiGridListAddRow (test, v)
	}

	test_button = guiCreateElement( 2, "вывод", 200.0, 100.0+140.0, 50.0, 50.0, false )
	test_button2 = guiCreateElement( 2, "скрыть", 250.0, 100.0+140.0, 50.0, 50.0, false )
	test_button3 = guiCreateElement( 2, "показать", 300.0, 100.0+140.0, 50.0, 50.0, false )

local mayoralty_shop = {
		[0] = "день",
		[1] = "деньги",
		[2] = "права на имя",
		[3] = "сигареты Big Break Red",
		[4] = "аптечка",
		[5] = "канистра с"
	}

	test1 = guiCreateGridList(550.0, 100.0, 300.0, 135.0)

	foreach (k,v in mayoralty_shop)
	{
		guiGridListAddRow (test1, v)
	}

	test_button11 = guiCreateElement( 2, "вывод", 550.0, 100.0+140.0, 50.0, 50.0, false )
	test_button22 = guiCreateElement( 2, "скрыть", 600.0, 100.0+140.0, 50.0, 50.0, false )
	test_button33 = guiCreateElement( 2, "показать", 650.0, 100.0+140.0, 50.0, 50.0, false )*/
