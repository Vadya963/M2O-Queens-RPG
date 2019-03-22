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
local gridlist_button_width_height = [0.0,0.0]//ширина и высота кнопки купить
//-------------------------------------------------------

local gui_fon = 0//1 открыт, 0 закрыт
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
	[5] = ["канистра с бензином", "лит."],
	[6] = ["ключ от автомобиля с номером", ""],
	[7] = ["сигареты Big Break Blue", "сигарет в пачке"],
	[8] = ["сигареты Big Break White", "сигарет в пачке"],
	[9] = ["ПП Томпсона обр. 1928 г.", "боеприпасов"],
	[10] = ["полицейский жетон", "шт"],
	[11] = ["газета", "шт"],
	[12] = ["Револьвер кал. 38", "боеприпасов"],
	[13] = ["Кольт 1911 п/авт.", "боеприпасов"],
	[14] = ["Кольт 1911 особ.", "боеприпасов"],
	[15] = ["Дробовик", "боеприпасов"],
	[16] = ["MP40", "боеприпасов"],
	[17] = ["Пистолет C96", "боеприпасов"],
	[18] = ["Магнум", "боеприпасов"],
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
	[39] = ["тушка свиньи", "шт"],
	[40] = ["молоток", "шт"],
	[41] = ["лицензия на оружие", "шт"],
	[42] = ["гамбургер", "шт"],
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
	[55] = ["лист металла", "кг"],
	[56] = ["пила", "шт"],
	[57] = ["шпала", "$ за штуку"],
	[58] = ["пустая коробка", "шт"],
	[59] = ["кирка", "шт"],
	[60] = ["руда", "кг"],
	[61] = ["бочка с нефтью", "$ за штуку"],
	[62] = ["лицензия водителя мусоровоза", "шт"],
	[63] = ["мусор", "кг"],
	[64] = ["антипохмелин", "шт"],
	[65] = ["двигатель", "уровень тюнинга"],
	[66] = ["золотое колье", "$ за штуку"],
	[67] = ["пропуск", "шт"],
	[68] = ["свиной окорок", "$ за штуку"],
	[69] = ["колесо", "марка"],
	[70] = ["банка краски", "цвет"],
	[71] = ["ящик с инструментами", "процентов"],
	[72] = ["лицензия инкассатора", "шт"],
	[73] = ["рыба", "кг"],
	[74] = ["удочка", "процентов"],
	[75] = ["лицензия ремонтника", "шт"],
}

//цены автосалона
local motor_show = [
	//[ид(0), цена(1), вместимость бака(2), название(3)]
	[0,4995,60,"Ascot Bailey"],
	[1,5000,90,"Berkley Kingfisher"],
	//[2,0,0,"Trailer_1"],
	//[3,0,200,"GAI 353 Military Truck"],
	//[4,0,200,"Hank B"],
	//[5,0,200,"Hank B Fuel Tank"],
	[6,7000,70,"Walter Hot Rod"],
	[7,6000,70,"Smith 34 Hot Rod"],
	[8,6000,70,"Shubert Pickup Hot Rod"],
	[9,2740,70,"Houston Wasp"],
	[10,5000,70,"ISW 508"],
	//[11,910,58,"Walter Military"],
	[12,910,58,"Walter Utility"],
	[13,5000,90,"Jefferson Futura"],
	[14,3200,70,"Jefferson Provincial"],
	[15,3500,90,"Lassister Series 69"],
	//[16,0,90,"Lassister Series 69"],//копия
	//[17,0,90,"Lassister Series 75 Hollywood"],//копия
	[18,5170,90,"Lassister Series 75 Hollywood"],
	//[19,1250,80,"Milk Truck"],
	//[20,0,150,"Parry Bus"],
	//[21,0,150,"Parry Bus Prison"],
	[22,2100,70,"Potomac Indian"],
	[23,2350,60,"Quicksilver Windsor"],
	[24,2350,60,"Quicksilver Windsor Taxi"],
	[25,730,65,"Shubert 38"],
	//[26,0,65,"Shubert 38"],//копия
	[27,4000,100,"Shubert Armored Van"],
	[28,2300,80,"Shubert Beverly"],
	[29,3500,70,"Shubert Frigate"],
	//[30,850,65,"Shubert Hearse"],
	[31,730,65,"Shubert 38 Panel Truck"],
	//[32,0,65,"Shubert 38 Panel Truck"],//копия
	//[33,730,65,"Shubert 38 Taxi"],
	//[34,0,100,"Shubert Truck"],
	[35,3000,100,"Shubert Truck Flatbed"],//копия
	//[36,0,100,"Shubert Truck Flatbed"],
	//[37,3000,100,"Shubert Truck Covered"],
	//[38,0,100,"Shubert Truck"],
	//[39,0,100,"Shubert Show Plow"],
	//[40,0,80,"Military Truck"],
	[41,2140,80,"Smith Custom 200"],
	[42,4280,80,"Smith Custom 200 Police Special"],
	[43,450,50,"Smith Coupe"],
	[44,1700,65,"Smith Mainline"],
	[45,2700,70,"Smith Thunderbolt"],
	//[46,0,80,"Smith Truck"],
	[47,530,65,"Smith V8"],
	[48,1500,50,"Smith Deluxe Station Wagon"],
	//[49,0,0,"Trailer_2"],
	[50,1475,70,"Culver Empire"],
	//[51,2950,70,"Culver Empire Police Special"],
	[52,2450,80,"Walker Rocket"],
	[53,770,40,"Walter Coupe"]
]

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

local color_table = {
	[1] = [168,228,160],
	[2] = [255,255,0],
	[3] = [255,0,0],
	[4] = [0,150,255],
	[5] = [255,255,255],
	[6] = [0,255,0],
	[7] = [0,255,255],
	[8] = [255,100,0],
	[9] = [255,150,0],
	[10] = [255,100,255],
	[11] = [130,255,0],
	[12] = [255,255,130],
	[13] = [150,0,0],
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

		gridlist_table_text[ window[1] ][ table_len ] <- text_gui
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

function guiGetCountGridList (window)
{
	if (window)
	{		
		return gridlist_table_text[ window[1] ].len()
	}
	else 
	{
		return false
	}
}

function guiSetTextGridList (window, slot, text)
{
	if (window)
	{	
		return guiSetText(gridlist_table_text[ window[1] ][ slot ], text )
	}
	else 
	{
		return false
	}
}
//-------------------------------------------------------------------------------------------------

local avto_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(465.0/2), 400.0, 465.0)
foreach (k,v in motor_show)
{
	local text = v[3]+"("+v[0]+") "+(v[1]*10)+"$"
	guiGridListAddRow (avto_menu, text)
}
guiSetVisibleGridList (avto_menu, false)

local craft_table = [//--[предмет 0, рецепт 1, предметы для крафта 2, кол-во предметов для крафта 3, предмет который скрафтится 4]
	[info_png[20][0]+"(1 гр)", info_png[3][0]+"(20 шт) + "+info_png[7][0]+"(20 шт) + "+info_png[8][0]+"(20 шт)", "3,7,8", "20,20,20", "20,1"],
]
local craft_menu = guiCreateGridList((screen[0]/2)-(650.0/2), (screen[1]/2)-(320.0/2), 650.0, 320.0)
foreach (k,v in craft_table)
{
	local text = v[0]+" = "+v[1]
	guiGridListAddRow (craft_menu, text)
}
guiSetVisibleGridList (craft_menu, false)

local shop = {
	[3] = [info_png[3][0], 20, 5],
	[4] = [info_png[4][0], 1, 250],
	[7] = [info_png[7][0], 20, 10],
	[8] = [info_png[8][0], 20, 15],
	[11] = [info_png[11][0], 1, 100],
	[26] = [info_png[26][0], 1, 5000],
	[44] = [info_png[44][0], 100, 50],
	[45] = [info_png[45][0], 100, 100],
	[46] = [info_png[46][0], 1, 100],
	[47] = [info_png[47][0], 1, 100],
	[52] = [info_png[52][0], 1, 100],
	[64] = [info_png[64][0], 1, 250],
	[74] = [info_png[74][0], 100, 100],
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

local repair_shop = [
	[info_png[23][0], 1, 100, 23],
	[info_png[35][0], 10, 500, 35],
	[info_png[65][0], 3, 15000, 65],
	[info_png[71][0], 100, 50, 71],
]
for (local i = 1; i <= 11; i++)//колеса
{
	repair_shop.push([info_png[69][0], i, 1000, 69])
}
foreach (k, v in color_table)//краска
{
	repair_shop.push([info_png[70][0]+" (RGB: "+v[0]+","+v[1]+","+v[2]+")", k, 50, 70])
}
local repair_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
foreach (k,v in repair_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
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
	[2] = [info_png[2][0], 1, 1000],
	[41] = [info_png[41][0], 1, 10000],
	[53] = [info_png[53][0], 1, 5000],
	[34] = [info_png[34][0], 1, 5000],
	[62] = [info_png[62][0], 1, 5000],
	[67] = [info_png[67][0], 1, 10],
	[72] = [info_png[72][0], 1, 5000],
	[75] = [info_png[75][0], 1, 1000],
	[48] = ["квитанция для оплаты дома на", day_nalog, (zakon_nalog_house*day_nalog)],
	[49] = ["квитанция для оплаты бизнеса на", day_nalog, (zakon_nalog_business*day_nalog)],
	[50] = ["квитанция для оплаты т/с на", day_nalog, (zakon_nalog_car*day_nalog)],
}
local mayoralty_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in mayoralty_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (mayoralty_shop_menu, text)
}
guiSetVisibleGridList (mayoralty_shop_menu, false)

local sub_cops = {
	[10] = [info_png[10][0]],
	[28] = [info_png[28][0]],
	[29] = [info_png[29][0]],
	[30] = [info_png[30][0]],
	[31] = [info_png[31][0]],
	[32] = [info_png[32][0]],
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
local sub_cops_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in sub_cops)
{
	local text = v[0]
	guiGridListAddRow (sub_cops_menu, text)
}
guiSetVisibleGridList (sub_cops_menu, false)

local clothing_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
for (local i = 0; i <= 29; i++) 
{
	guiGridListAddRow (clothing_menu, i.tostring())
}
guiSetVisibleGridList (clothing_menu, false)

local station = [
	[-554.36,1592.92,-21.8639, 4.0, "Диптон"],
	[-1118.99,1376.44,-18.5, 4.0, "Кингстон"],
	[-1535.55,-231.03,-13.5892, 4.0, "Сэнд-Айленд"],
	[-511.412,20.1703,-5.7096, 4.0, "Вест-Сайд"],
	[-113.792,-481.71,-8.92243, 4.0, "Сауспорт"],
	[234.395,380.914,-9.41271, 4.0, "Китайский квартал"],
	[-293.069,568.25,-2.27367, 4.0, "Аптаун"],
]
local station_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in station)
{
	local text = v[4]
	guiGridListAddRow (station_menu, text)
}
guiSetVisibleGridList (station_menu, false)

local shop_menu_button = guiCreateElement( 2, "купить", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2), 400.0, 30.0, false )
guiSetVisible( shop_menu_button, false )

local clothing_menu_value = 1
local shop_menu_button2 = guiCreateElement( 2, "<", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button2, false )
local shop_menu_button3 = guiCreateElement( 2, ">", (screen[0]/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button3, false )

function tune_close ()//--закрытие окна
{
	number_business = -1
	value_business = -1

	showCursor( false )
	guiSetVisible( shop_menu_button, false )
	guiSetVisible( shop_menu_button2, false )
	guiSetVisible( shop_menu_button3, false )

	guiSetVisibleGridList (shop_menu, false)
	guiSetVisibleGridList (weapon_menu, false)
	guiSetVisibleGridList (gas_menu, false)
	guiSetVisibleGridList (repair_shop_menu, false)
	guiSetVisibleGridList (eda_menu, false)
	guiSetVisibleGridList (mayoralty_shop_menu, false)
	guiSetVisibleGridList (sub_cops_menu, false)
	guiSetVisibleGridList (avto_menu, false)
	guiSetVisibleGridList (craft_menu, false)
	guiSetVisibleGridList (clothing_menu, false)
	guiSetVisibleGridList (station_menu, false)
}
addEventHandler ( "event_gui_delet", tune_close )

function shop_menu_fun(number, value)//--создание окна магазина
{
	number_business = number
	value_business = value

	showCursor( true )

	if (value_business == 0)
	{
		guiSetVisibleGridList (weapon_menu, true)
		local pos = guiGetSize( weapon_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	if (value_business == 1)
	{
		guiSetVisibleGridList (clothing_menu, true)
		local pos = guiGetSize( clothing_menu[0] )
		gridlist_button_width_height =[pos[0],pos[1]+60.0]
		guiSetText(shop_menu_button, "Купить")

		guiSetPosition(shop_menu_button2, (screen[0]/2)-(400.0/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button2, true )

		guiSetPosition(shop_menu_button3, (screen[0]/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button3, true )
	}
	else if (value_business == 2)
	{
		guiSetVisibleGridList (shop_menu, true)
		local pos = guiGetSize( shop_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == 3)
	{
		guiSetVisibleGridList (gas_menu, true)
		local pos = guiGetSize( gas_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == 4)
	{
		guiSetVisibleGridList (repair_shop_menu, true)
		local pos = guiGetSize( repair_shop_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == 5)
	{
		guiSetVisibleGridList (eda_menu, true)
		local pos = guiGetSize( eda_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == "pd")
	{
		guiSetVisibleGridList (sub_cops_menu, true)
		local pos = guiGetSize( sub_cops_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Получить")
	}
	else if (value_business == "mer")
	{
		guiSetVisibleGridList (mayoralty_shop_menu, true)
		local pos = guiGetSize( mayoralty_shop_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == "dm")
	{
		guiSetVisibleGridList (avto_menu, true)
		local pos = guiGetSize( avto_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == "craft")
	{
		guiSetVisibleGridList (craft_menu, true)
		local pos = guiGetSize( craft_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Изготовить")
	}
	else if (value_business == "subway")
	{
		guiSetVisibleGridList (station_menu, true)
		local pos = guiGetSize( station_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Отправиться")
	}

	guiSetPosition(shop_menu_button, (screen[0]/2)-(400.0/2), (screen[1]/2)+(gridlist_button_width_height[1]/2), false)
	guiSetVisible( shop_menu_button, true )

	/*guiSetVisible( shop_menu_button, true )
	guiSetPosition(shop_menu_button, (screen[0]/2)-(gridlist_button_width_height[0]/2), (screen[1]/2)+(gridlist_button_width_height[1]/2), false)
	local x = guiSetSize(shop_menu_button, 650.0, 30.0)
	local z = guiGetSize(shop_menu_button)
	print(x.tostring()+" "+z[0]+" "+z[1]+" "+type(shop_menu_button))*/
}
addEventHandler ( "event_shop_menu_fun", shop_menu_fun )


//загрузка картинок для отображения на земле
local image = array(info_png.len(),0)

for (local i = 0; i < image.len(); i++)
{
	image[i] = dxLoadTexture(i+".png")
}

local mouse = dxLoadTexture("mouse.png")

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
	[1,70.0,10.0],
	[2,130.0,10.0],
	[3,190.0,10.0],
	[4,250.0,10.0],
	[5,310.0,10.0],

	[6,10.0,70.0],
	[7,70.0,70.0],
	[8,130.0,70.0],
	[9,190.0,70.0],
	[10,250.0,70.0],
	[11,310.0,70.0],

	[12,10.0,130.0],
	[13,70.0,130.0],
	[14,130.0,130.0],
	[15,190.0,130.0],
	[16,250.0,130.0],
	[17,310.0,130.0],

	[18,10.0,190.0],
	[19,70.0,190.0],
	[20,130.0,190.0],
	[21,190.0,190.0],
	[22,250.0,190.0],
	[23,310.0,190.0]
]

local button_pos = [//позиция кнопок
	[0,"PLAYER",10.0,15.0],
	[1,"CAR",70.0,15.0],
	[2,"HOUSE",130.0,15.0]
]

gui_fon = guiCreateElement( 2, "фон", 0.0, 0.0, screen[0], screen[1], false )//фон для гуи
guiSetAlpha(gui_fon, 0.0)

guiSetVisible( gui_fon, false )


local health_gui = guiCreateElement( 13, "health.png", screen[0]-30.0, height_need-7.5, 30.0, 30.0, false )
local alcohol_gui = guiCreateElement( 13, "alcohol.png", screen[0]-30.0, height_need-7.5+(20+7.5)*1, 30.0, 30.0, false )
local drugs_gui = guiCreateElement( 13, "drugs.png", screen[0]-30.0, height_need-7.5+(20+7.5)*2, 30.0, 30.0, false )
local satiety_gui = guiCreateElement( 13, "satiety.png", screen[0]-30.0, height_need-7.5+(20+7.5)*3, 30.0, 30.0, false )
local hygiene_gui = guiCreateElement( 13, "hygiene.png", screen[0]-30.0, height_need-7.5+(20+7.5)*4, 30.0, 30.0, false )
local sleep_gui = guiCreateElement( 13, "sleep.png", screen[0]-30.0, height_need-7.5+(20+7.5)*5, 30.0, 30.0, false )

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
	bindKey( "f2", "down", f2_down )
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
		[17] = "clothing_menu_value "+clothing_menu_value,
	}

	playerid = getLocalPlayer()

	local myPos = getPlayerPosition(playerid)
	local myRot = getPlayerRotation(playerid)

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
		local text = "FPS: "+FPS+" | Ping: "+getPlayerPing(playerid)+" | ID: "+playerid+" | Players online: "+(getPlayerCount()+1)+" | Minute in game: "+time_game+" | Time: "+getElementData("timeserver")+" | "+client_time
		dxdrawtext ( text, 2.0, 0.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )

		if (getPlayerVehicle(playerid) != -1)
		{
			local speed_vehicle = "plate "+plate+" | fuel "+getElementData("fuel_data")
			dxdrawtext ( speed_vehicle, 2.0, screen[1]-16.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		}

		if (getElementData("gps_device_data") == 1)
		{
			local coords = getScreenFromWorld( myPos[0], myPos[1], myPos[2]+1 )
			local x_table = split(myPos[0].tostring(), ".")
			local y_table = split(myPos[1].tostring(), ".")
			local dimensions = dxGetTextDimensions( "[X  "+x_table[0]+", Y  "+y_table[0]+"]", 1.0, "tahoma-bold" )

			dxdrawtext ( "[X  "+x_table[0]+", Y  "+y_table[0]+"]", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
		
		if (isCursorShowing)
		{
			local pos = getMousePosition()
			dxdrawtext ( pos[0]+", "+pos[1], pos[0]+15.0, pos[1], fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		
			for (local i = 0; i <= 17; i++) 
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

			dxdrawtext ( myPos[0]+" "+myPos[1]+" "+myPos[2], 300.0, 40.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
			dxdrawtext ( myRot[0]+" "+myRot[1]+" "+myRot[2], 300.0, 55.0, fromRGB ( white[0], white[1], white[2], 255 ), true, "tahoma-bold", 1.0 )
		}

		dxDrawRectangle( screenWidth-width_need-30, height_need, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ) )
		dxDrawRectangle( screenWidth-width_need-30, height_need, (width_need/720)*heal_player[0].tofloat(), 15.0, fromRGB ( 90, 151, 107, 255 ) )

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

		simpleShake(1.0, (alcohol/100).tofloat(), 1.0)
	}


	if (state_inv_gui)//инв-рь
	{
		//dxDrawRectangle( pos_x_3d_image, (pos_y_3d_image-(10.0+button_pos[0][3])), width, (10.0+button_pos[0][3]), fromRGB( 0, 0, 0, 255 ) )
		dxDrawRectangle( pos_x_3d_image, (pos_y_3d_image-(10.0+button_pos[0][3])), width, height+(10.0+button_pos[0][3]), fromRGB( 0, 0, 0, 255 ) )

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

function tab_down_fun(value)//инв-рь игрока
{
	if (value == 0)
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
	}
	else if (value == 1)
	{
		state_inv_gui = true
		state_inv_player = true
		showCursor( true )

		guiSetVisible( gui_fon, true )
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
	local pos = getMousePosition()
	//sendMessage("pos[0] "+pos[0]+" | pos[1] "+pos[1], 255, 255, 255)

	if (state_inv_gui)
	{
		for (local i = 0; i < max_inv; i++) 
		{
			if ( ((inv_pos[i][1]+pos_x_3d_image)) < pos[0] && ((inv_pos[i][1]+pos_x_3d_image)+image_w_h) > pos[0] && ((inv_pos[i][2]+pos_y_3d_image)) < pos[1] && ((inv_pos[i][2]+pos_y_3d_image)+image_w_h) > pos[1] )
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

			}
		}

		if ( ((button_pos[0][2]+pos_x_3d_image)) < pos[0] && ((button_pos[0][2]+pos_x_3d_image)+image_w_h) > pos[0] && ((pos_y_3d_image-button_pos[0][3])) < pos[1] && ((pos_y_3d_image-button_pos[0][3])+button_pos[0][3]) > pos[1] )
		{
			state_inv_player = true
			state_inv_car = false
			state_inv_house = false
		}
		else if ( plate != "" && ((button_pos[1][2]+pos_x_3d_image)) < pos[0] && ((button_pos[1][2]+pos_x_3d_image)+image_w_h) > pos[0] && ((pos_y_3d_image-button_pos[1][3])) < pos[1] && ((pos_y_3d_image-button_pos[1][3])+button_pos[1][3]) > pos[1] )
		{
			state_inv_player = false
			state_inv_car = true
			state_inv_house = false
		}
		else if ( house != "" && ((button_pos[2][2]+pos_x_3d_image)) < pos[0] && ((button_pos[2][2]+pos_x_3d_image)+image_w_h) > pos[0] && ((pos_y_3d_image-button_pos[2][3])) < pos[1] && ((pos_y_3d_image-button_pos[2][3])+button_pos[2][3]) > pos[1] )
		{
			state_inv_player = false
			state_inv_car = false
			state_inv_house = true
		}

		if ( 0.0 < pos[0] && pos_x_3d_image > pos[0] )//использовать предмет
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
		else if ( (screen[0]-pos_x_3d_image) < pos[0] && (screen[0]+pos_x_3d_image) > pos[0] )//выкинуть предмет
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
	}


	foreach (idx, value in gridlist_table_window) 
	{	
		foreach (idx2, value2 in gridlist_table_text[idx])
		{	
			if (element == value2)
			{
				gridlist_window = gridlist_table_window[idx]
				gridlist_lable = element
				gridlist_row = idx2
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

			//print("shop_menu_button - "+guiGetCountGridList (avto_menu))
		}
	}
	else if (element == shop_menu_button2)
	{	
		clothing_menu_value--

		if (clothing_menu_value <= 0)
		{
			clothing_menu_value = 1
			return
		}

		if (clothing_menu_value == 1)
		{
			for (local i = guiGetCountGridList(clothing_menu)*0; i < guiGetCountGridList(clothing_menu)*1; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*0, i.tostring())
			}
		}
		else if (clothing_menu_value == 2)
		{
			for (local i = guiGetCountGridList(clothing_menu)*1; i < guiGetCountGridList(clothing_menu)*2; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*1, i.tostring())
			}
		}
		else if (clothing_menu_value == 3)
		{
			for (local i = guiGetCountGridList(clothing_menu)*2; i < guiGetCountGridList(clothing_menu)*3; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*2, i.tostring())
			}
		}
		else if (clothing_menu_value == 4)
		{
			for (local i = guiGetCountGridList(clothing_menu)*3; i < guiGetCountGridList(clothing_menu)*4; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*3, i.tostring())
			}
		}
		else if (clothing_menu_value == 5)
		{
			for (local i = guiGetCountGridList(clothing_menu)*4; i < guiGetCountGridList(clothing_menu)*5; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*4, i.tostring())
			}
		}
	}
	else if (element == shop_menu_button3)
	{	
		clothing_menu_value++

		if (clothing_menu_value >= 7)
		{
			clothing_menu_value = 6
			return
		}

		if (clothing_menu_value == 1)
		{
			for (local i = guiGetCountGridList(clothing_menu)*0; i < guiGetCountGridList(clothing_menu)*1; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*0, i.tostring())
			}
		}
		else if (clothing_menu_value == 2)
		{
			for (local i = guiGetCountGridList(clothing_menu)*1; i < guiGetCountGridList(clothing_menu)*2; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*1, i.tostring())
			}
		}
		else if (clothing_menu_value == 3)
		{
			for (local i = guiGetCountGridList(clothing_menu)*2; i < guiGetCountGridList(clothing_menu)*3; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*2, i.tostring())
			}
		}
		else if (clothing_menu_value == 4)
		{
			for (local i = guiGetCountGridList(clothing_menu)*3; i < guiGetCountGridList(clothing_menu)*4; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*3, i.tostring())
			}
		}
		else if (clothing_menu_value == 5)
		{
			for (local i = guiGetCountGridList(clothing_menu)*4; i < guiGetCountGridList(clothing_menu)*5; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*4, i.tostring())
			}
		}
		else if (clothing_menu_value == 6)
		{
			for (local i = guiGetCountGridList(clothing_menu)*5; i < guiGetCountGridList(clothing_menu)*6; i++)
			{
				guiSetTextGridList (clothing_menu, i-guiGetCountGridList(clothing_menu)*5, i.tostring())
			}
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
			}
			else 
			{
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
			}
			else 
			{
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
	if(isMainMenuShowing())
	{
		return
	}

	showCursor( !isCursorShowing )
	isCursorShowing = !isCursorShowing
}

function f2_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	sync_timer = !sync_timer
	showChat( sync_timer )

	guiSetVisible(health_gui, sync_timer)
	guiSetVisible(alcohol_gui, sync_timer)
	guiSetVisible(drugs_gui, sync_timer)
	guiSetVisible(satiety_gui, sync_timer)
	guiSetVisible(hygiene_gui, sync_timer)
	guiSetVisible(sleep_gui, sync_timer)
}

addEventHandler( "job_gps",
function( id1, id2 )
{
	setGPSTarget(id1.tofloat(),id2.tofloat())
})

addEventHandler( "removegps",
function(  )
{
	removeGPSTarget()
})

addEventHandler( "createHudTimer",
function( id1 )
{
	createHudTimer(id1*0.7, true, true)
})

addEventHandler( "destroyHudTimer",
function()
{
	destroyHudTimer()
})

/*addCommandHandler("shake",
function (playerid, i1, i2) 
{
	//simpleShake(i1.tofloat(), i2.tofloat(), i3.tofloat())

	local x = guiSetSize(shop_menu_button, i1.tofloat(), i2.tofloat())
	print(x.tostring())
})*/


//-------------------------------------тестирование разных функций---------------------------------
/* local mayoralty_shop = {
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