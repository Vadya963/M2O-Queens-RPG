local playerid = -1
local screen = getScreenSize()
local width_hd = (screen[0]/1366.0)//--адаптация размеров
local height_hd = (screen[1]/768.0)//--адаптация размеров
local max_inv = 24
local width = 370.0
local height = 250.0
local image_w_h = 50.0
local dxDrawTexture_width_height = 0.78
local pos_x_image = (screen[0]/2)-(width/2)
local pos_y_image = (screen[1]/2)-(height/2)
local time_game = 0//--сколько минут играешь
local element_data = {}
local isCursorShowing = false//+дебагинфа
local blip_data = {//ud блипа[0] x[1] y[2] категория[3] ид[4] радиус[5] отображение[6] //бд блипов
	//[1] = [0, 0,0, 0,1, 5, false]
}
local sync_timer = false
local sync_timer2 = false
local number_business = -1//номер бизнеса
local value_business = -1//тип бизнеса
local width_need = 270.0*width_hd//--ширина нужд
local height_need = 150.0*height_hd//--высота нужд
local zakon_taxation_car = 500
local zakon_taxation_house = 1000
local zakon_taxation_business = 2000
local is_chat_open = 0//чат: 0-закрыт, 1-открыт
local afk = 0//--сколько минут в афк

//---------------------грайдлист-------------------------
local gridlist_table = {
["window"] = {},//таблица созданных окон
["text"] = {},//таблица созданных текстов
}
local gridlist_window = false//окно в котором выделяется текст
local gridlist_lable = false//текст который будет выделяться
local gridlist_row = -1//номер текста который будет выделяться
local gridlist_select = false//выделение текста
local gridlist_button_width_height = [0.0,0.0]//ширина и высота кнопки купить
local max_lable = 30//максимум сообщений на 1 стр
//-------------------------------------------------------

local gui_fon = 0//1 открыт, 0 закрыт
local state_inv_gui = false//инв-рь открыт или закрыт
local gui_selection = false//выделение пнг

local state_inv_player = false//состояние ин-ря игрока
local state_inv_car = false//состояние ин-ря тс
local state_inv_house = false//состояние ин-ря дома
local state_inv_box = false//состояние ин-ря ящика

local info_tab = ""//положение картинки в табе
local info3 = 0//слот
local info1 = 0//пнг
local info2 = 0//число

local plate = ""//если в тс
local house = ""//если около дома
local box = ""//если есть ящик

local no_use_subject = [-1,0,1]//--нельзя использовать
local no_select_subject = [-1,0,1]//--нельзя выделить
local no_change_subject = [-1,1]//--нельзя заменить
local no_throw_earth = []//--нельзя выкинуть

//--перемещение картинки
local lmb = 0//--лкм
local info3_selection_1 = -1// --слот картинки
local info1_selection_1 = -1// --номер картинки
local info2_selection_1 = -1// --значение картинки

local info_png = {
	[0] = ["", ""],
	[1] = ["чековая книжка", "$ в банке"],
	[2] = ["права", "номер"],
	[3] = ["сигареты Big Break Red", "сигарет"],
	[4] = ["аптечка", "шт"],
	[5] = ["канистра с бензином", "лит."],
	[6] = ["ключ от т/с под номером", ""],
	[7] = ["сигареты Big Break Blue", "сигарет"],
	[8] = ["сигареты Big Break White", "сигарет"],
	[9] = ["ПП Томпсона обр. 1928 г.", "боеприпасов"],
	[10] = ["полицейский жетон", "номер"],
	[11] = ["газета", "шт"],
	[12] = ["Револьвер кал. 38", "боеприпасов"],
	[13] = ["Кольт 1911 п/авт.", "боеприпасов"],
	[14] = ["Кольт 1911 особ.", "боеприпасов"],
	[15] = ["Дробовик", "боеприпасов"],
	[16] = ["МП40", "боеприпасов"],
	[17] = ["Маузер C96", "боеприпасов"],
	[18] = ["Магнум", "боеприпасов"],
	[19] = ["М3", "боеприпасов"],
	[20] = ["наркотики", "гр"],
	[21] = ["пиво старый эмпайр", "шт"],
	[22] = ["пиво штольц", "шт"],
	[23] = ["ремонтный набор", "шт"],
	[24] = ["ящик с товаром", "$ за штуку"],
	[25] = ["ключ от дома под номером", ""],
	[26] = ["таблетки от наркозависимости", "шт"],
	[27] = ["одежда", ""],
	[28] = ["наручники", "шт"],
	[29] = ["уголовное дело", "преступлений"],
	[30] = ["лотерейный билет под номером", ""],
	[31] = ["водка сталкер", "шт"],
	[32] = ["документы на дом под номером", ""],
	[33] = ["документы на т/с под номером", ""],
	[34] = ["лицензия на работу", "вид работы"],
	[35] = ["лом", "процентов"],
	[36] = ["документы на бизнес под номером", ""],
	[37] = ["админский жетон", "ранг"],
	[38] = ["риэлторская лицензия", "шт"],
	[39] = ["тушка свиньи", "шт"],
	[40] = ["молоток", "шт"],
	[41] = ["лицензия на оружие", "номер"],
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
	[53] = ["молоко", "$ за бутылку"],
	[54] = ["инкассаторская сумка", "$ в сумке"],
	[55] = ["лист металла", "кг"],
	[56] = ["пила", "шт"],
	[57] = ["шпала", "$ за штуку"],
	[58] = ["колба", "реагент"],
	[59] = ["кирка", "шт"],
	[60] = ["руда", "кг"],
	[61] = ["бочка с нефтью", "$ за штуку"],
	[62] = ["ящик с виски", "$ за штуку"],
	[63] = ["мусор", "кг"],
	[64] = ["антипохмелин", "шт"],
	[65] = ["двигатель", "уровень тюнинга"],
	[66] = ["золотое колье", "$ за штуку"],
	[67] = ["пропуск", "шт"],
	[68] = ["мясо", "$ за штуку"],
	[69] = ["колесо", "марка"],
	[70] = ["банка краски", "цвет"],
	[71] = ["ящик с инструментами", "процентов"],
	[72] = ["виски", "шт"],
	[73] = ["рыба", "кг"],
	[74] = ["удочка", "процентов"],
	[75] = ["#1 маршрутный лист", "ост."],
	[76] = ["динамит", "шт"],
	[77] = ["шнур", "шт"],
	[78] = ["тратил", "гр"],
	[79] = ["отмычка", "процентов"],
	[80] = ["ящик с оружием", "$ за штуку"],
	[81] = ["нож", "процентов"],
	[82] = ["лоток с рыбой", "$ за штуку"],
	[83] = ["ящик с рыбным филе", "$ за штуку"],
	[84] = ["документы на рыбзавод под номером", ""],
	[85] = ["трудовой договор обработчика рыбы на", "рыбзаводе"],
	[86] = ["ордер на обыск", "", "гражданина", "т/с", "дома"],
	[87] = ["стройматериалы", "$ за штуку"],
	[88] = ["банковский чек на", "$"],
	[89] = ["рация", "канал"],
	[90] = ["уголь", "кг"],
	[91] = ["шляпа", "опг"],
	[92] = ["jetpack", "шт"],
	[93] = ["#2 маршрутный лист", "ост."],
	[94] = ["паспорт", "номер"],
	[95] = ["пустой бланк", "шт"],
	[96] = ["заявление на пропажу т/с под номером", ""],
	[97] = ["колода карт", "шт"],
	[98] = ["ящик под номером", ""],
	[99] = ["ключ от ящика под номером", ""],
}

local craft_table = [//--[предмет 0, рецепт 1, предметы для крафта 2, кол-во предметов для крафта 3, предмет который скрафтится 4] //переписать
	["", "", "77,78", "1,100", "76,1"],
	["", "", "58,58", "3,78", "20,1"],
]

foreach (i,v in craft_table)
{
	craft_table[i][0] = info_png[split(v[4], ",")[0].tointeger()][0]+" "+split(v[4], ",")[1]+" "+info_png[split(v[4], ",")[0].tointeger()][1]
	craft_table[i][1] = info_png[split(v[2], ",")[0].tointeger()][0]+" "+split(v[3], ",")[0]+" "+info_png[split(v[2], ",")[0].tointeger()][1]+" + "+info_png[split(v[2], ",")[1].tointeger()][0]+" "+split(v[3], ",")[1]+" "+info_png[split(v[2], ",")[1].tointeger()][1]
}

local name_mafia = {
	[0] = ["no", [255,255,255], []],
	[1] = ["Bombers", [175,0,255], [39,40,41]],
	[2] = ["Grease", [150,75,0], [123,124,125,126,127]],
	[3] = ["Irishmen", [0,255,0], [24,82,83,84]],
	[4] = ["Triads", [50,50,50], [51,52,54]],
}

//цены автосалона
local motor_show = [
	//[ид(0), цена(1), вместимость бака(2), название(3), кол-во пасс-их мест(4)]
	[0,49950,60,"Ascot Bailey",1],
	[1,50000,90,"Berkley Kingfisher",1],
	[2,0,0,"Trailer_1",0],
	[3,0,200,"GAI 353 Military Truck",1],
	[4,0,200,"Hank B",1],
	[5,0,200,"Hank B Fuel Tank",1],
	[6,70000,70,"Walter Hot Rod",1],
	[7,60000,70,"Smith 34 Hot Rod",1],
	[8,60000,70,"Shubert Pickup Hot Rod",1],
	[9,27400,70,"Houston Wasp",3],
	[10,50000,70,"ISW 508",1],
	[11,0,58,"Walter Military",1],
	[12,9100,58,"Walter Utility",1],
	[13,50000,90,"Jefferson Futura",1],
	[14,32000,70,"Jefferson Provincial",1],
	[15,35000,90,"Lassister Series 69",3],
	[16,0,90,"Lassister Series 69",3],//копия
	[17,0,90,"Lassister Series 75 Hollywood",3],//копия
	[18,51700,90,"Lassister Series 75 Hollywood",3],
	[19,0,80,"Milk Truck",1],
	[20,0,150,"Parry Bus",20],
	[21,0,150,"Parry Bus Prison",20],
	[22,21000,70,"Potomac Indian",3],
	[23,20000,60,"Quicksilver Windsor",3],
	[24,0,60,"Quicksilver Windsor Taxi",3],
	[25,7300,65,"Shubert 38",3],
	[26,0,65,"Shubert 38",3],//копия
	[27,0,100,"Shubert Armored Van",1],
	[28,23000,80,"Shubert Beverly",1],
	[29,35000,70,"Shubert Frigate",1],
	[30,0,65,"Shubert Hearse",1],
	[31,7300,65,"Shubert 38 Panel Truck",1],
	[32,0,65,"Shubert 38 Panel Truck",1],//копия
	[33,0,65,"Shubert 38 Taxi",3],
	[34,0,100,"Shubert Truck",1],
	[35,0,100,"Shubert Truck Flatbed",1],//копия
	[36,0,100,"Shubert Truck Flatbed",1],
	[37,0,100,"Shubert Truck Covered",1],
	[38,0,100,"Shubert Truck Seagift",1],
	[39,0,100,"Shubert Show Plow",1],
	[40,0,80,"Military Truck",1],
	[41,21400,80,"Smith Custom 200",3],
	[42,0,80,"Smith Custom 200 Police Special",3],
	[43,4500,50,"Smith Coupe",1],
	[44,17000,65,"Smith Mainline",1],
	[45,27000,70,"Smith Thunderbolt",1],
	[46,0,80,"Smith Truck",1],
	[47,5300,65,"Smith V8",3],
	[48,15000,50,"Smith Deluxe Station Wagon",3],
	[49,0,0,"Trailer_2",0],
	[50,14750,70,"Culver Empire",3],
	[51,0,70,"Culver Empire Police Special",3],
	[52,24500,80,"Walker Rocket",3],
	[53,7700,40,"Walter Coupe",1]
]

local car_cash_coef = 10
local car_cash_no = [19,20,24,27,35,38,39,42]
for (local i = 0; i < motor_show.len(); i++) 
{
	local count = 0
	foreach (_,v1 in car_cash_no)
	{
		if (motor_show[i][0] != v1)
		{
			count = count+1
		}
	}

	if (count == car_cash_no.len())
	{
		motor_show[i][1] = motor_show[i][1]*car_cash_coef
	}
}

//----цвета----
local color_mes = {
	color_tips = [168,228,160],//бабушкины яблоки
	yellow = [255,255,0],//желтый
	red = [255,0,0],//красный
	red_try = [200,0,0],//красный
	blue = [0,150,255],//синий
	white = [255,255,255],//белый
	green = [0,255,0],//зеленый
	green_try = [0,200,0],//зеленый
	turquoise = [0,255,255],//бирюзовый
	orange = [255,100,0],//оранжевый
	orange_do = [255,150,0],//оранжевый do
	pink = [255,100,255],//розовый
	lyme = [130,255,0],//лайм админский цвет
	svetlo_zolotoy = [255,255,130],//светло-золотой
	crimson = [220,20,60],//малиновый
	purple = [175,0,255],//фиолетовый
	gray = [150,150,150],//серый
	green_rc = [115,180,97],//темно зеленый
}

local color_table = [
	/*[168,228,160],
	[255,255,0],
	[255,0,0],
	[0,150,255],
	[255,255,255],
	[0,255,0],
	[0,255,255],
	[255,100,0],
	[255,150,0],
	[255,100,255],
	[130,255,0],
	[255,255,130],
	[150,0,0],
	[220,20,60],
	[175,0,255],
	[115,180,97],
	[0,0,0],

	[83,104,80],
	[70,128,95],
	[27,76,65],
	[15,32,24],
	[143,137,124],
	[120,111,68],
	[97,46,10],
	[154,154,154],
	[98,26,21],
	[145,114,33],
	[57,84,37],
	[121,113,31],
	[1,17,13],
	[157,143,110],
	[47,95,106],
	[80,80,80],
	[79,72,65],
	[112,104,89],
	[29,4,0],
	[66,0,0],
	[73,75,33],*/

	//color gtasa
	[0,0,0],[245,245,245],[42,119,161],[132,4,16],[38,55,57],[134,68,110],[215,142,16],[76,117,183],[189,190,198],[94,112,114],
	[70,89,122],[101,106,121],[93,126,141],[88,89,90],[214,218,214],[156,161,163],[51,95,63],[115,14,26],[123,10,42],[159,157,148],
	[59,78,120],[115,46,62],[105,30,59],[150,145,140],[81,84,89],[63,62,69],[165,169,167],[99,92,90],[61,74,104],[151,149,146],
	[66,31,33],[95,39,43],[132,148,171],[118,123,124],[100,100,100],[90,87,82],[37,37,39],[45,58,53],[147,163,150],[109,122,136],
	[34,25,24],[111,103,95],[124,28,42],[95,10,21],[25,56,38],[93,27,32],[157,152,114],[122,117,96],[152,149,134],[173,176,176],
	[132,137,136],[48,79,69],[77,98,104],[22,34,72],[39,47,75],[125,98,86],[158,164,171],[156,141,113],[109,24,34],[78,104,129],
	[156,156,152],[145,115,71],[102,28,38],[148,157,159],[164,167,165],[142,140,70],[52,26,30],[106,122,140],[170,173,142],[171,152,143],
	[133,31,46],[111,130,151],[88,88,83],[154,167,144],[96,26,35],[32,32,44],[164,160,150],[170,157,132],[120,34,43],[14,49,109],
	[114,42,63],[123,113,94],[116,29,40],[30,46,50],[77,50,47],[124,27,68],[46,91,32],[57,90,131],[109,40,55],[167,162,143],
	[175,177,177],[54,65,85],[109,108,110],[15,106,137],[32,75,107],[43,62,87],[155,159,157],[108,132,149],[77,93,96],[174,155,127],
	[64,108,143],[31,37,59],[171,146,118],[19,69,115],[150,129,108],[100,104,106],[16,80,130],[161,153,131],[56,86,148],[82,86,97],
	[127,105,86],[140,146,154],[89,110,135],[71,53,50],[68,98,79],[115,10,39],[34,52,87],[100,13,27],[163,173,198],[105,88,83],
	[155,139,128],[98,11,28],[91,93,94],[98,68,40],[115,24,39],[27,55,109],[236,106,174],
]

/*for (local i = 50; i <= 250; i+=50) {
	color_table.push([i,0,0])
}
for (local i = 50; i <= 250; i+=50) {
	color_table.push([250,i,0])
}
for (local i = 200; i >= 0; i-=50) {
	color_table.push([i,250,0])
}
for (local i = 50; i <= 250; i+=50) {
	color_table.push([0,250,i])
}
for (local i = 200; i >= 0; i-=50) {
	color_table.push([0,i,250])
}
for (local i = 50; i <= 250; i+=50) {
	color_table.push([i,0,250])
}
for (local i = 200; i >= 50; i-=50) {
	color_table.push([250,0,i])
}*/

//------------------------------------Element Data-------------------------------------------------
function setElementData (key, value)
{
	triggerServerEvent( "event_setElementData", key, value )
	//print("setElementData["+key+"] = "+value)
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

function element_data_push_client(text)
{
	foreach (k, v in split(text, ";")) 
	{
		local spl = split(v.tostring(), ":")
		element_data[spl[0]] <- spl[1]
	}
	//print("event_element_data_push_client["+key+"] = "+value)
}
addEventHandler ( "event_element_data_push_client", element_data_push_client )
//-------------------------------------------------------------------------------------------------

//--------------------------------------------грайдлист--------------------------------------------
function guiCreateGridList (x,y, width, height)
{
	local window = guiCreateElement( 5, "", x,y, width, height+3.0, false )

	if (window)
	{
		local table_len = gridlist_table["window"].len()

		gridlist_table["window"][table_len] <- window
		gridlist_table["text"][table_len] <- {}
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
		local table_len = gridlist_table["text"][ window[1] ].len()
		local guiSize_window = guiGetSize( window[0] )
		local text_gui = guiCreateElement( 6, text, 10.0, (15.0*table_len), guiSize_window[0], 15.0, false, window[0] )

		gridlist_table["text"][ window[1] ][ table_len ] <- text_gui
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

function guiGetVisibleGridList (window)
{
	if (window)
	{		
		return guiIsVisible( window[0] )
	}
}

function guiGetCountGridList (window)
{
	if (window)
	{		
		return gridlist_table["text"][ window[1] ].len()
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
		return guiSetText(gridlist_table["text"][ window[1] ][ slot ], text )
	}
	else 
	{
		return false
	}
}
//-------------------------------------------------------------------------------------------------

local motor_show_gl = {}
for (local i = 0; i < motor_show.len(); i++) 
{
	if(motor_show[i][1] != 0)
	{
		motor_show_gl[motor_show_gl.len()] <- [i, motor_show[i][1], motor_show[i][2], motor_show[i][3], motor_show[i][4]]
	}
}
local avto_menu_value = 1
local avto_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
for (local i = 0; i <= 29; i++)
{
	motor_show_gl[motor_show_gl.len()] <- [0, 0, 0, "none", 0]
}
foreach (k,v in motor_show_gl)
{
	local text = v[3]+"("+v[0]+") "+v[1]+"$"
	guiGridListAddRow (avto_menu, text)
}
for (local i = max_lable*(avto_menu_value-1); i < max_lable*avto_menu_value; i++)
{
	local text = motor_show_gl[i][3]+"("+motor_show_gl[i][0]+") "+motor_show_gl[i][1]+"$"
	guiSetTextGridList (avto_menu, i-max_lable*(avto_menu_value-1), text)
}
guiSetVisibleGridList (avto_menu, false)

local craft_menu = guiCreateGridList((screen[0]/2)-(650.0/2), (screen[1]/2)-(320.0/2), 650.0, 320.0)
foreach (k,v in craft_table)
{
	local text = v[0]+" = "+v[1]
	guiGridListAddRow (craft_menu, text)
}
guiSetVisibleGridList (craft_menu, false)

local giuseppe = [
	[info_png[34][0]+" Угонщик", 5, 5000, 34],
	[info_png[58][0], 78, 1000, 57],
	[info_png[78][0], 100, 1000, 78],
	[info_png[79][0], 5, 500, 79],
	[info_png[91][0]+" "+name_mafia[1][0], 1, 5000, 91],//4
	[info_png[91][0]+" "+name_mafia[2][0], 2, 5000, 91],
	[info_png[91][0]+" "+name_mafia[3][0], 3, 5000, 91],
	[info_png[91][0]+" "+name_mafia[4][0], 4, 5000, 91],//7
]
local giuseppe_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in giuseppe)
{
	local text = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
	guiGridListAddRow (giuseppe_menu, text)
}
guiSetVisibleGridList (giuseppe_menu, false)

local shop = {
	[3] = [info_png[3][0], 20, 5],
	[4] = [info_png[4][0], 1, 250],
	[7] = [info_png[7][0], 20, 10],
	[8] = [info_png[8][0], 20, 15],
	[11] = [info_png[11][0], 1, 25],
	[26] = [info_png[26][0], 1, 5000],
	[30] = [info_png[30][0], 0, 100],
	[44] = [info_png[44][0], 100, 50],
	[45] = [info_png[45][0], 100, 100],
	[52] = [info_png[52][0], 1, 100],
	[64] = [info_png[64][0], 1, 250],
	[74] = [info_png[74][0], 100, 100],
	[81] = [info_png[81][0], 100, 100],
	[89] = [info_png[89][0], 10, 500],
	[97] = [info_png[97][0], 1, 50],
	[98] = [info_png[98][0], 0, 2500],
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
	[19] = [info_png[19][0], 9, 1990],
}
local weapon_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in weapon)
{
	local text = v[0]+" 25 "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (weapon_menu, text)
}
guiSetVisibleGridList (weapon_menu, false)

local gas = {
	[5] = [info_png[5][0], 25, 250],
	[23] = [info_png[23][0], 1, 100],
}
local gas_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in gas)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (gas_menu, text)
}
guiSetVisibleGridList (gas_menu, false)

local repair_shop_menu_value = 1
local repair_shop = [
	[info_png[23][0], 1, 100, 23],
	[info_png[35][0], 10, 500, 35],
	[info_png[65][0], 0, 5000, 65],
	[info_png[65][0], 1, 10000, 65],
	[info_png[65][0], 2, 20000, 65],
	[info_png[65][0], 3, 30000, 65],
	[info_png[71][0], 100, 50, 71],
]
for (local i = 0; i <= 11; i++)//колеса
{
	repair_shop.push([info_png[69][0], i, 4000, 69])
}
foreach (k, v in color_table)//краска
{
	repair_shop.push([info_png[70][0], k, 500, 70])
}
for (local i = 0; i <= 29; i++) 
{
	repair_shop.push(["none", 0, 0, 0])
}
local repair_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
foreach (k,v in repair_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
	guiGridListAddRow (repair_shop_menu, text)
}
for (local i = max_lable*(repair_shop_menu_value-1); i < max_lable*repair_shop_menu_value; i++)
{
	local text = repair_shop[i][0]+" "+repair_shop[i][1]+" "+info_png[repair_shop[i][3]][1]+" "+repair_shop[i][2]+"$"
	guiSetTextGridList (repair_shop_menu, i-max_lable*(repair_shop_menu_value-1), text)
}
guiSetVisibleGridList (repair_shop_menu, false)

local eda = {
	[21] = [info_png[21][0], 1, 45],
	[22] = [info_png[22][0], 1, 60],
	[31] = [info_png[31][0], 1, 250],
	[42] = [info_png[42][0], 1, 100],
	[43] = [info_png[43][0], 1, 50],
	[72] = [info_png[72][0], 1, 500],
}
local eda_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in eda)
{
	local text = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
	guiGridListAddRow (eda_menu, text)
}
guiSetVisibleGridList (eda_menu, false)

local day_taxation = 7
local mayoralty_shop = [
	[info_png[2][0], 1, 1000, 2],
	[info_png[10][0], 1, 50000, 10],
	[info_png[41][0], 1, 10000, 41],
	[info_png[34][0]+" Таксист", 1, 5000, 34],
	[info_png[34][0]+" Мусоровозчик", 2, 5000, 34],
	[info_png[34][0]+" Инкассатор", 3, 5000, 34],
	[info_png[34][0]+" Связист", 4, 1000, 34],
	[info_png[34][0]+" Дальнобойщик", 6, 5000, 34],
	[info_png[34][0]+" Молочник", 7, 5000, 34],
	[info_png[34][0]+" Развозчик алкоголя", 8, 5000, 34],
	[info_png[34][0]+" Водитель автобуса", 9, 5000, 34],
	[info_png[34][0]+" Перевозчик оружия", 10, 5000, 34],
	[info_png[34][0]+" Развозчик угля", 11, 5000, 34],
	[info_png[34][0]+" Уборщик снега ЭБ", 12, 5000, 34],
	[info_png[34][0]+" Транспортный детектив", 13, 5000, 34],
	[info_png[67][0], 1, 10, 67],
	["квитанция для оплаты дома на", day_taxation, (zakon_taxation_house*day_taxation), 48],
	["квитанция для оплаты бизнеса на", day_taxation, (zakon_taxation_business*day_taxation), 49],
	["квитанция для оплаты т/с на", day_taxation, (zakon_taxation_car*day_taxation), 50],
]
local mayoralty_shop_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in mayoralty_shop)
{
	local text = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
	guiGridListAddRow (mayoralty_shop_menu, text)
}
guiSetVisibleGridList (mayoralty_shop_menu, false)

local sub_cops = [
	[info_png[46][0], 1, 46],
	[info_png[47][0], 1, 47],
	[info_png[9][0], 11, 4700, 9],
	[info_png[12][0], 2, 630, 12],
	[info_png[13][0], 4, 1230, 13],
	[info_png[14][0], 5, 2700, 14],
	[info_png[15][0], 8, 4000, 15],
	[info_png[16][0], 10, 2190, 16],
	[info_png[17][0], 3, 1050, 17],
	[info_png[18][0], 6, 1500, 18],
	[info_png[19][0], 9, 1990, 19],
	[info_png[95][0], 1, 95],
]
local sub_cops_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in sub_cops)
{
	local text = v[0]
	guiGridListAddRow (sub_cops_menu, text)
}
guiSetVisibleGridList (sub_cops_menu, false)

local clothing_menu_value = 1
local clothing = []
for (local i = 0; i <= 179; i++) 
{
	clothing.push([i.tostring()])
}
local clothing_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
foreach (k,v in clothing)
{
	local text = v[0]
	guiGridListAddRow (clothing_menu, text)
}
for (local i = max_lable*(clothing_menu_value-1); i < max_lable*clothing_menu_value; i++)
{
	guiSetTextGridList (clothing_menu, i-max_lable*(clothing_menu_value-1), i.tostring())
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

local phone_stats = [
	["Штрафстоянка"],
	["Аукцион"],
	["Рыбзавод"],
]
local phone_stats_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(320.0/2), 400.0, 320.0)
foreach (k,v in phone_stats)
{
	local text = v[0]
	guiGridListAddRow (phone_stats_menu, text)
}
guiSetVisibleGridList (phone_stats_menu, false)

local player_menu_value = 1
local player_table = {}
for (local i = 0; i < getMaxPlayers(); i++)
{	
	if(getPlayerName(i))
	{
		player_table[i] <- getPlayerName(i)+" (ОП - 0)"
	}
	else
	{
		player_table[i] <- ""
	}
}
for (local i = getMaxPlayers(); i < getMaxPlayers()+30; i++)
{
	player_table[i] <- ""
}
local player_menu = guiCreateGridList((screen[0]/2)-(400.0/2), (screen[1]/2)-(450.0/2), 400.0, 450.0)
foreach (k,v in player_table)
{
	local text = k+" "+v
	guiGridListAddRow (player_menu, text)
}
guiSetVisibleGridList (player_menu, false)

local shop_menu_button = guiCreateElement( 2, "купить", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2), 400.0, 30.0, false )
guiSetVisible( shop_menu_button, false )

local shop_menu_button2 = guiCreateElement( 2, "<--", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button2, false )
local shop_menu_button3 = guiCreateElement( 2, "-->", (screen[0]/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button3, false )

local shop_menu_button4 = guiCreateElement( 2, "<--", (screen[0]/2)-(400.0/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button4, false )
local shop_menu_button5 = guiCreateElement( 2, "-->", (screen[0]/2), (screen[1]/2)+(320.0/2), 200.0, 30.0, false )
guiSetVisible( shop_menu_button5, false )

function tune_close ()//--закрытие окна
{
	number_business = -1
	value_business = -1

	showcursor( false )
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
	guiSetVisibleGridList (giuseppe_menu, false)
	guiSetVisibleGridList (phone_stats_menu, false)
}
addEventHandler ( "event_gui_delet", tune_close )

function shop_menu_fun(number, value)//--создание окна магазина
{
	number_business = number
	value_business = value

	showcursor( true )

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
		gridlist_button_width_height = [pos[0],pos[1]+60.0]
		guiSetText(shop_menu_button, "Купить")

		guiSetPosition(shop_menu_button2, (screen[0]/2)-(400.0/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button2, true )

		guiSetPosition(shop_menu_button3, (screen[0]/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button3, true )
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
		gridlist_button_width_height = [pos[0],pos[1]+60.0]
		guiSetText(shop_menu_button, "Купить")

		guiSetPosition(shop_menu_button2, (screen[0]/2)-(400.0/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button2, true )

		guiSetPosition(shop_menu_button3, (screen[0]/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetVisible( shop_menu_button3, true )
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
	else if (value_business == "giuseppe")
	{
		guiSetVisibleGridList (giuseppe_menu, true)
		local pos = guiGetSize( giuseppe_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Купить")
	}
	else if (value_business == "phone")
	{
		guiSetVisibleGridList (phone_stats_menu, true)
		local pos = guiGetSize( phone_stats_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]]
		guiSetText(shop_menu_button, "Позвонить")
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
local alcohol_png = dxLoadTexture("alcohol.png")
local drugs_png = dxLoadTexture("drugs.png")
local satiety_png = dxLoadTexture("satiety.png")
local hygiene_png = dxLoadTexture("hygiene.png")
local sleep_png = dxLoadTexture("sleep.png")

//---------------------таймеры-------------------------------------------------------------
timer(function () {
	time_game = time_game+1
}, 60000, -1)

timer(function () {
	sync_timer = true
	sync_timer2 = true

	/*timer(function () {
		for (local i = 0; i <= 22; i++)
		{	
			print ( getElementData(i.tostring()) )
		}
	}, 5000, -1)*/
}, 5000, 1)

timer(function () {
	local myPos = getPlayerPosition(getLocalPlayer())

	foreach (k, v in blip_data) 
	{	
		if ( isPointInCircle2D(myPos[0], myPos[1], v[1], v[2], v[5]) )
		{	
			if (!v[6])
			{
				blip_data[k][0] = createBlip(v[1], v[2], v[3], v[4])
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

timer(function () {
	is_chat_open = isInputVisible().tointeger()
	setElementData("is_chat_open", is_chat_open)
}, 500, -1)

timer(function () {
	if (isMainMenuShowing())
	{
		afk = afk+1
		setElementData("afk", afk.tostring())
	}
	else
	{
		afk = 0
		setElementData("afk", afk.tostring())
	}
}, 1000, -1)
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

local inv_slot_box = [//инв-рь игрока {пнг картинка 0, значение 1}
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
	[2,"HOUSE",130.0,15.0],
	[3,"BOX",190.0,15.0]
]

gui_fon = guiCreateElement( 2, "фон", 0.0, 0.0, screen[0], screen[1], false )//фон для гуи
guiSetAlpha(gui_fon, 0.0)

guiSetVisible( gui_fon, false )

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

function isPointInRectangle2D(x, y, x1, y1, x2, y2) 
{
	if( x1 <= x && x <= x2 && y1 >= y && y >= y2 )
	{
		return true
	}
	else
	{
		return false
	}
}

function blip_create(x, y, lib, icon, r)
{
	blip_data[ blip_data.len() ] <- [0, x, y, lib, icon, r, false]
}
addEventHandler ( "event_blip_create", blip_create )

function showcursor (bool) {
	showCursor(bool)
	isCursorShowing = bool
}

function isInSlot(dX, dY, dSZ, dM)
{
	if (isCursorShowing)
	{
		local pos = getMousePosition()
		if(pos[0] >= dX && pos[0] <= dX+dSZ && pos[1] >= dY && pos[1] <= dY+dM)
		{
			return [true, pos[0], pos[1]]
		}
		else
		{
			return false
		}
	}
}

//-----------эвенты------------------------------------------------------------------------
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

	if(sync_timer)
	{
		showChat( true )
	}
	else
	{
		showChat( false )
	}
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

function f1_down()
{
	if(isMainMenuShowing())
	{
		return
	}

	showcursor( !isCursorShowing )
}

function f2_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	sync_timer = !sync_timer
	showChat( sync_timer )
	toggleHud( sync_timer )
}

function f3_down()
{
	if(isMainMenuShowing())
	{
		return
	}

	if(guiGetVisibleGridList(player_menu))
	{
		showcursor( false )
		guiSetVisibleGridList (player_menu, false)
		guiSetVisible( shop_menu_button4, false )
		guiSetVisible( shop_menu_button5, false )
	}
	else
	{
		showcursor( true )

		local pos = guiGetSize( player_menu[0] )
		gridlist_button_width_height = [pos[0],pos[1]+60.0]

		guiSetPosition(shop_menu_button4, (screen[0]/2)-(400.0/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)
		guiSetPosition(shop_menu_button5, (screen[0]/2), (screen[1]/2)+((gridlist_button_width_height[1]-60.0)/2), false)

		guiSetVisibleGridList (player_menu, true)
		guiSetVisible( shop_menu_button4, true )
		guiSetVisible( shop_menu_button5, true )
	}
}

function w_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "w" )	
}

function s_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "s" )	
}

function a_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "a" )	
}

function d_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "d" )	
}

function q_down()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "q" )	
}

function key_up()
{
	if(isMainMenuShowing())
	{
		return
	}
	
	triggerServerEvent( "event_tp_player", "kill" )	
}

addEventHandler("onClientScriptInit", 
function() 
{
	bindKey( "tab", "down", tab_down )
	bindKey( "f1", "down", f1_down )
	bindKey( "m", "down", fone1 )
	bindKey( "m", "up", fone2 )
	bindKey( "w", "down", w_down )
	bindKey( "w", "up", key_up )
	bindKey( "s", "down", s_down )
	bindKey( "s", "up", key_up )
	bindKey( "a", "down", a_down )
	bindKey( "a", "up", key_up )
	bindKey( "d", "down", d_down )
	bindKey( "d", "up", key_up )
	bindKey( "e", "down", e_down )
	bindKey( "e", "up", key_up )
	bindKey( "q", "down", q_down )
	bindKey( "q", "up", key_up )
	bindKey( "x", "down", x_down )
	bindKey( "page_up", "down", up_down )
	bindKey( "page_down", "down", down_down )
	bindKey( "f2", "down", f2_down )
	bindKey( "f3", "down", f3_down )

	setRenderNametags(false)
	setRenderHealthbar(false)
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
	else if (info_tab == "box")
	{
		triggerServerEvent( "event_inv_server_load", "box", info3_selection_1, info1, info2, box )
	}
}

local lastTick = getTickCount()
local framesRendered = 0
local FPS = 0
addEventHandler( "onClientFrameRender",
function( post )
{
	playerid = getLocalPlayer()

	local myPos = getPlayerPosition(playerid)
	local myRot = getPlayerRotation(playerid)

	local pos = getMousePosition()
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
		local timeserver = split(getElementData("timeserver"), "-")
		local client_time = getDateTime()
		local text = "FPS: "+FPS+" | Ping: "+getPlayerPing(playerid)+" | ID: "+playerid+" | Players online: "+(getPlayerCount()+1)+" | Minute in game: "+time_game+" | Time: "+timeserver[0]+":"+timeserver[1]+" | "+client_time
		local spl_gz = split(getElementData("guns_zone2"), "/")

		local dgs = [
		[false, (screen[0]/2)-(dxGetTextDimensions("test dgss", 1.0, "tahoma-bold" )[0]/2),(screen[1]/2)-(10.0/2), dxGetTextDimensions("test dgss", 1.0, "tahoma-bold" )[0],10.0 fromRGB(0,0,0,255), "rectangle"],
		[false, "test dgss", (screen[0]/2)-(dxGetTextDimensions("test dgss", 1.0, "tahoma-bold" )[0]/2),(screen[1]/2)-(15.0/2), fromRGB(255,0,0,255), true, "tahoma-bold", 1.0, "text"],
		[true, alcohol_png, screen[0]-30.0, height_need-7.5+(20+7.5)*0, 0.93,0.93, 0.0,0.0,0.0, 255, "texture"],
		[true, drugs_png, screen[0]-30.0, height_need-7.5+(20+7.5)*1, 0.93,0.93, 0.0,0.0,0.0, 255, "texture"],
		[true, satiety_png, screen[0]-30.0, height_need-7.5+(20+7.5)*2, 0.93,0.93, 0.0,0.0,0.0, 255, "texture"],
		[true, hygiene_png, screen[0]-30.0, height_need-7.5+(20+7.5)*3, 0.93,0.93, 0.0,0.0,0.0, 255, "texture"],
		[true, sleep_png, screen[0]-30.0, height_need-7.5+(20+7.5)*4, 0.93,0.93, 0.0,0.0,0.0, 255, "texture"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*0, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*0, ((width_need/500.0)*alcohol), 15.0, fromRGB ( 90, 151, 107, 255 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*1, width_need, 15.0 fromRGB ( 0, 0, 0, 200 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*1, ((width_need/100.0)*drugs), 15.0, fromRGB ( 90, 151, 107, 255 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*2, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*2,( (width_need/100.0)*satiety), 15.0, fromRGB ( 90, 151, 107, 255 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*3, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*3, ((width_need/100.0)*hygiene), 15.0, fromRGB ( 90, 151, 107, 255 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*4, width_need, 15.0, fromRGB ( 0, 0, 0, 200 ), "rectangle"],
		[true, screen[0]-width_need-30, height_need+(20+7.5)*4, ((width_need/100.0)*sleep), 15.0, fromRGB ( 90, 151, 107, 255 ), "rectangle"],
		[true, text, 2.0, 0.0, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[getPlayerVehicle(playerid) != -1 || false, "plate "+plate+" | kilometrage "+split(getElementData("kilometrage_data"), ".")[0], 2.0, screen[1]-16.0, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[getElementData("gps_device_data").tointeger() == 1 || false, "[X  "+split(myPos[0].tostring(), ".")[0]+", Y  "+split(myPos[1].tostring(), ".")[0]+"]", getScreenFromWorld( myPos[0], myPos[1], myPos[2]+1 )[0]-(dxGetTextDimensions( "[X  "+split(myPos[0].tostring(), ".")[0]+", Y  "+split(myPos[1].tostring(), ".")[0]+"]", 1.0, "tahoma-bold" )[0]/2), getScreenFromWorld( myPos[0], myPos[1], myPos[2]+1 )[1], fromRGB ( color_mes.svetlo_zolotoy[0], color_mes.svetlo_zolotoy[1], color_mes.svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[spl_gz[0].tointeger() == 1 || false, 0.0, screen[1]-16.0*6, 250.0, 16.0*3, fromRGB( 0, 0, 0, 150 ), "rectangle"],
		[spl_gz[0].tointeger() == 1 || false, "Time: "+spl_gz[6]+" sec | Guns Zone #"+spl_gz[1], 2.0, screen[1]-16*6, fromRGB( color_mes.white[0], color_mes.white[1], color_mes.white[2] ), false, "tahoma-bold", 1.0, "text"],
		[spl_gz[0].tointeger() == 1 || false, "Attack "+spl_gz[2]+": "+spl_gz[3]+" points", 2.0, screen[1]-16*5, fromRGB( 255,0,50 ), false, "tahoma-bold", 1.0, "text"],
		[spl_gz[0].tointeger() == 1 || false, "Defense "+spl_gz[4]+": "+spl_gz[5]+" points", 2.0, screen[1]-16*4, fromRGB( 0,50,255 ), false, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, pos[0]+", "+pos[1], pos[0]+15.0, pos[1], fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, (alcohol/100).tostring(), screen[0]-width_need-30-30, height_need+(20+7.5)*0, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, drugs.tostring(), screen[0]-width_need-30-30, height_need+(20+7.5)*1, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, satiety.tostring(), screen[0]-width_need-30-30, height_need+(20+7.5)*2, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, hygiene.tostring(), screen[0]-width_need-30-30, height_need+(20+7.5)*3, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, sleep.tostring(), screen[0]-width_need-30-30, height_need+(20+7.5)*4, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, myPos[0]+" "+myPos[1]+" "+myPos[2], 300.0, 40.0, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		[isCursorShowing, myRot[0]+" "+myRot[1]+" "+myRot[2], 300.0, 55.0, fromRGB ( color_mes.white[0], color_mes.white[1], color_mes.white[2], 255 ), true, "tahoma-bold", 1.0, "text"],
		]

		foreach (k, v in split(getElementData("guns_zone"), "|"))//--отображение guns_zone
		{
			local spl = split(v.tostring(), "/")
			if (isPointInRectangle2D( myPos[0], myPos[1], spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat(), spl[3].tofloat() ))
			{
				dgs.push([true, "Guns Zone #"+spl[5]+" - "+spl[4], 2.0, screen[1]-16*2, fromRGB( color_mes.green[0], color_mes.green[1], color_mes.green[2] ), true, "tahoma-bold", 1.0, "text"])
			}
		}

		foreach (k, v in dgs) 
		{	
			if(v[0] && v[6] == "rectangle")
			{
				dxDrawRectangle( v[1], v[2], v[3], v[4], v[5] )
			}
			else if(v[0] && v[8] == "text")
			{
				dxdrawtext( v[1], v[2], v[3], v[4], v[5], v[6], v[7] )
			}
			else if(v[0] && v[10] == "texture")
			{
				dxDrawTexture(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
			}
		}
	}


	if (state_inv_gui)//инв-рь
	{
		dxDrawRectangle( pos_x_image, (pos_y_image-(10.0+button_pos[0][3])), width, height+(10.0+button_pos[0][3]), fromRGB( 0, 0, 0, 255 ) )

		if (state_inv_player)
		{
			for (local i = 0; i < max_inv; i++)
			{
				dxDrawTexture(image[inv_slot_player[i][0]], (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( split(inv_slot_player[i][1].tostring(),".")[0], (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image+35), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
			}
		}

		if (state_inv_car) 
		{
			for (local i = 0; i < max_inv; i++)
			{
				dxDrawTexture(image[inv_slot_car[i][0]], (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_car[i][1].tostring(), (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image+35), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
			}
		}

		if (state_inv_house) 
		{
			for (local i = 0; i < max_inv; i++)
			{
				dxDrawTexture(image[inv_slot_house[i][0]], (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_house[i][1].tostring(), (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image+35), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
			}
		}

		if (state_inv_box)
		{
			for (local i = 0; i < max_inv; i++)
			{
				dxDrawTexture(image[inv_slot_box[i][0]], (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image), dxDrawTexture_width_height, dxDrawTexture_width_height, 0.0, 0.0, 0.0, 255)
				dxdrawtext( inv_slot_box[i][1].tostring(), (inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image+35), fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
			}
		}


		if (gui_selection)//выделение пнг
		{
			if (info_tab == "player" && state_inv_player || info_tab == "car" && state_inv_car || info_tab == "house" && state_inv_house || info_tab == "box" && state_inv_box)
			{
				dxDrawRectangle( (inv_pos[info3][1]+pos_x_image), (inv_pos[info3][2]+pos_y_image), image_w_h, image_w_h, fromRGB( 255, 255, 130, 100 ) )
			}
		}


		if (state_inv_player)
		{
			dxdrawtext( button_pos[0][1].tostring(), (button_pos[0][2]+pos_x_image), (pos_y_image-button_pos[0][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
		}
		else
		{
			dxdrawtext( button_pos[0][1].tostring(), (button_pos[0][2]+pos_x_image), (pos_y_image-button_pos[0][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
		}

		if (plate != "")
		{
			if (state_inv_car)
			{
				dxdrawtext( button_pos[1][1].tostring()+" "+plate, (button_pos[1][2]+pos_x_image), (pos_y_image-button_pos[1][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
			}
			else
			{
				dxdrawtext( button_pos[1][1].tostring()+" "+plate, (button_pos[1][2]+pos_x_image), (pos_y_image-button_pos[1][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

		if (house != "")
		{
			if (state_inv_house)
			{
				dxdrawtext( button_pos[2][1].tostring()+" "+house, (button_pos[2][2]+pos_x_image), (pos_y_image-button_pos[2][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
			}
			else
			{
				dxdrawtext( button_pos[2][1].tostring()+" "+house, (button_pos[2][2]+pos_x_image), (pos_y_image-button_pos[2][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

		if (box != "")
		{
			if (state_inv_box)
			{
				dxdrawtext( button_pos[3][1].tostring()+" "+box, (button_pos[3][2]+pos_x_image), (pos_y_image-button_pos[3][3]), fromRGB( 255, 255, 130 ), false, "tahoma-bold", 1.0 )
			}
			else
			{
				dxdrawtext( button_pos[3][1].tostring()+" "+box, (button_pos[3][2]+pos_x_image), (pos_y_image-button_pos[3][3]), fromRGB( 255, 255, 255 ), false, "tahoma-bold", 1.0 )
			}
		}

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


	if(sync_timer2)
	{
		simpleShake(1.0, (getElementData ( "alcohol_data" ).tofloat()/100).tofloat(), 1.0)

		for (local i = 0; i < getMaxPlayers(); i++) 
		{
			if (isPlayerConnected(i) && i != playerid)
			{	
				local Pos = getPlayerPosition(i)
				local coords = getScreenFromWorld( Pos[0], Pos[1], Pos[2]+2.0 )

				local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 10.0 )
				if (area && getElementData("drugs["+i+"]").tofloat() >= getElementData("zakon_drugs").tofloat())
				{
					local dimensions = dxGetTextDimensions( "*effect of drugs*", 1.0, "tahoma-bold" )
					dxdrawtext( "*effect of drugs*", coords[0]-(dimensions[0]/2), coords[1]-60.0, fromRGB( color_mes.svetlo_zolotoy[0], color_mes.svetlo_zolotoy[1], color_mes.svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0 )
				}

				local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 10.0 )
				if (area && (getElementData("alcohol["+i+"]").tofloat()/100) >= getElementData("zakon_alcohol").tofloat())
				{
					local dimensions = dxGetTextDimensions( "*effect of alcohol*", 1.0, "tahoma-bold" )
					dxdrawtext( "*effect of alcohol*", coords[0]-(dimensions[0]/2), coords[1]-45.0, fromRGB( color_mes.svetlo_zolotoy[0], color_mes.svetlo_zolotoy[1], color_mes.svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0 )
				}

				local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 10.0 )
				if (area && getElementData("is_chat_open["+i+"]").tointeger() == 1)
				{
					local dimensions = dxGetTextDimensions( "prints...", 1.0, "tahoma-bold" )
					dxdrawtext( "prints...", coords[0]-(dimensions[0]/2), coords[1]-30.0, fromRGB( color_mes.svetlo_zolotoy[0], color_mes.svetlo_zolotoy[1], color_mes.svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0 )
				}

				local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 10.0 )
				if (area && getElementData("afk["+i+"]") != "0")
				{
					local dimensions = dxGetTextDimensions( "[AFK] "+getElementData("afk["+i+"]")+" sec", 1.0, "tahoma-bold" )
					dxdrawtext( "[AFK] "+getElementData("afk["+i+"]")+" sec", coords[0]-(dimensions[0]/2), coords[1]-30.0, fromRGB( color_mes.purple[0], color_mes.purple[1], color_mes.purple[2] ), true, "tahoma-bold", 1.0 )
				}

				local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 35.0 )
				if (area && getElementData("crimes["+i+"]") != "0")
				{
					local dimensions = dxGetTextDimensions( "WANTED", 1.0, "tahoma-bold" )
					dxdrawtext( "WANTED", coords[0]-(dimensions[0]/2), coords[1]-15.0, fromRGB( color_mes.red[0], color_mes.red[1], color_mes.red[2] ), true, "tahoma-bold", 1.0 )
				}
			}
		}

		foreach (k, v in split(getElementData("earth"), "|"))//--отображение предметов на земле
		{
			local spl = split(v.tostring(), "/")
			local dist = getDistanceBetweenPoints3D(spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat(), myPos[0], myPos[1], myPos[2])
			if (isPointInCircle3D( myPos[0], myPos[1], myPos[2], spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat(), 20.0 ))
			{
				local coords = getScreenFromWorld( spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat() )
				dxDrawTexture(image[spl[3].tofloat()], coords[0]-((57-dist*2.85)/2), coords[1], 0.88-dist*0.044, 0.88-dist*0.044, 0.0, 0.0, 0.0, 255-dist*12.75)
			}

			if (isPointInCircle3D( myPos[0], myPos[1], myPos[2], spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat(), 10.0 ))
			{
				local coords = getScreenFromWorld( spl[0].tofloat(), spl[1].tofloat(), spl[2].tofloat()+0.2 )
				local dimensions = dxGetTextDimensions("Press E", 1.0-dist*0.05, "tahoma-bold" )
				dxdrawtext ( "Press E", coords[0]-(dimensions[0]/2), coords[1], fromRGB( color_mes.svetlo_zolotoy[0], color_mes.svetlo_zolotoy[1], color_mes.svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0-dist*0.05 )
			}
		}
	}


	/*for (local i = 0; i < getMaxPlayers(); i++)//кастомная полоска хп
	{
		if (isPlayerConnected(i))
		{	
			local Pos = getPlayerPosition(i)
			local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], Pos[0], Pos[1], Pos[2], 35.0 )
			local health = getPlayerHealth(i)
			local coords = getScreenFromWorld( Pos[0], Pos[1], Pos[2]+2.0 )

			if (area)
			{
				dxDrawRectangle( coords[0]-(72.0/2), coords[1]+16.0, 72.0, 10.0, fromRGB( 0, 110, 0, 150 ) )

				if (health >= 500)
				{
					dxDrawRectangle( coords[0]-(72.0/2), coords[1]+16.0, (health/10), 10.0, fromRGB( 0, 255, 0, 150 ) )
				}
				else if (health >= 250)
				{
					dxDrawRectangle( coords[0]-(72.0/2), coords[1]+16.0, (health/10), 10.0, fromRGB( 255, 255, 0, 150 ) )
				}
				else 
				{
					dxDrawRectangle( coords[0]-(72.0/2), coords[1]+16.0, (health/10), 10.0, fromRGB( 255, 0, 0, 150 ) )
				}
			}
		}
	}*/
})

function tab_down_fun(value)//инв-рь игрока
{
	if (value == 0)
	{
		state_inv_gui = false
		state_inv_player = false
		state_inv_car = false
		state_inv_house = false
		state_inv_box = false
		gui_selection = false
		info3 = 0
		info1 = 0
		info2 = 0
		info_tab = ""
		info3_selection_1 = -1
		info1_selection_1 = -1
		info2_selection_1 = -1
		lmb = 0
		showcursor( false )

		guiSetVisible( gui_fon, false )

		triggerServerEvent("event_setVehiclePartOpen_fun", "false")
	}
	else if (value == 1)
	{
		state_inv_gui = true
		state_inv_player = true
		showcursor( true )

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
	triggerServerEvent( "event_tp_player", "e" )
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
			if ( isInSlot((inv_pos[i][1]+pos_x_image), (inv_pos[i][2]+pos_y_image), image_w_h, image_w_h) )
			{
				info3 = i

				if (state_inv_player)
				{
					info1 = inv_slot_player[info3][0]
					info2 = inv_slot_player[info3][1]

					if (lmb == 0)
					{
						foreach (idx, v in no_select_subject)
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

							foreach (idx, v in no_change_subject)
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

						foreach (idx, v in no_throw_earth)
						{
							if (v == info1)
							{
								gui_selection = false
								info_tab = ""
								lmb = 0
								return
							}
						}

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
						foreach (idx, v in no_select_subject)
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

							foreach (idx, v in no_change_subject)
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

						foreach (idx, v in no_throw_earth)
						{
							if (v == info1_selection_1)
							{
								gui_selection = false
								info_tab = ""
								lmb = 0
								return
							}
						}

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
						foreach (idx, v in no_select_subject)
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

							foreach (idx, v in no_change_subject)
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

						foreach (idx, v in no_throw_earth)
						{
							if (v == info1_selection_1)
							{
								gui_selection = false
								info_tab = ""
								lmb = 0
								return
							}
						}

						triggerServerEvent( "event_inv_server_load", "house", info3, info1_selection_1, info2_selection_1, house )

						zamena_img()

						gui_selection = false
						info_tab = ""
						lmb = 0
					}
				}
				else if (state_inv_box)
				{
					info1 = inv_slot_box[info3][0]
					info2 = inv_slot_box[info3][1]
					
					if (lmb == 0)
					{
						foreach (idx, v in no_select_subject)
						{
							if (v == info1)
							{
								lmb = 0
								gui_selection = false
								return
							}
						}

						gui_selection = true
						info_tab = "box"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						lmb = 1
					}
					else
					{
						//--------------------------------------------------------------замена куда нажал 2 раз----------------------------------------------------------------------------
						/*if (inv_slot_box[info3][0] != 0)
						{*/

							foreach (idx, v in no_change_subject)
							{
								if (v == info1)
								{
									lmb = 0
									gui_selection = false
									return
								}
							}

							/*info_tab = "box"
							info3_selection_1 = info3
							info1_selection_1 = info1
							info2_selection_1 = info2
							return
						}*/

						foreach (idx, v in no_throw_earth)
						{
							if (v == info1_selection_1)
							{
								gui_selection = false
								info_tab = ""
								lmb = 0
								return
							}
						}

						triggerServerEvent( "event_inv_server_load", "box", info3, info1_selection_1, info2_selection_1, box )

						zamena_img()

						gui_selection = false
						info_tab = ""
						lmb = 0
					}
				}

			}
		}

		if ( isInSlot((button_pos[0][2]+pos_x_image), (pos_y_image-button_pos[0][3]), image_w_h, button_pos[0][3]) )
		{
			state_inv_player = true
			state_inv_car = false
			state_inv_house = false
			state_inv_box = false
		}
		else if ( plate != "" && isInSlot((button_pos[1][2]+pos_x_image), (pos_y_image-button_pos[1][3]), image_w_h, button_pos[1][3]) )
		{
			state_inv_player = false
			state_inv_car = true
			state_inv_house = false
			state_inv_box = false

			triggerServerEvent("event_setVehiclePartOpen_fun", "true")
		}
		else if ( house != "" && isInSlot((button_pos[2][2]+pos_x_image), (pos_y_image-button_pos[2][3]), image_w_h, button_pos[2][3]) )
		{
			state_inv_player = false
			state_inv_car = false
			state_inv_house = true
			state_inv_box = false
		}
		else if ( box != "" && isInSlot((button_pos[3][2]+pos_x_image), (pos_y_image-button_pos[3][3]), image_w_h, button_pos[3][3]) )
		{
			state_inv_player = false
			state_inv_car = false
			state_inv_house = false
			state_inv_box = true
		}

		if ( isInSlot(0.0, 0.0, pos_x_image, screen[1]) )//использовать предмет
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
		else if ( isInSlot((screen[0]-pos_x_image), 0.0, screen[0], screen[1]) )//выкинуть предмет
		{
			if (lmb == 1)
			{
				foreach (idx, v in no_throw_earth)
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
				else if (info_tab == "box" && state_inv_box)
				{
					triggerServerEvent( "event_throw_earth_server", "box", info3, info1, info2, box )
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


	foreach (idx, value in gridlist_table["window"]) 
	{	
		foreach (idx2, value2 in gridlist_table["text"][idx])
		{	
			if (element == value2)
			{
				gridlist_window = gridlist_table["window"][idx]
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
		if (guiGetVisibleGridList(clothing_menu))
		{
			clothing_menu_value--

			if (clothing_menu_value <= 0)
			{
				clothing_menu_value = 1
				return
			}

			for (local i = max_lable*(clothing_menu_value-1); i < max_lable*clothing_menu_value; i++)
			{
				guiSetTextGridList (clothing_menu, i-max_lable*(clothing_menu_value-1), i.tostring())
			}
		}
		else if (guiGetVisibleGridList(repair_shop_menu))
		{
			repair_shop_menu_value--

			if (repair_shop_menu_value <= 0)
			{
				repair_shop_menu_value = 1
				return
			}

			for (local i = max_lable*(repair_shop_menu_value-1); i < max_lable*repair_shop_menu_value; i++)
			{
				local text = repair_shop[i][0]+" "+repair_shop[i][1]+" "+info_png[repair_shop[i][3]][1]+" "+repair_shop[i][2]+"$"
				guiSetTextGridList (repair_shop_menu, i-max_lable*(repair_shop_menu_value-1), text)
			}
		}
		else if (guiGetVisibleGridList(avto_menu))
		{
			avto_menu_value--

			if (avto_menu_value <= 0)
			{
				avto_menu_value = 1
				return
			}

			for (local i = max_lable*(avto_menu_value-1); i < max_lable*avto_menu_value; i++)
			{
				local text = motor_show_gl[i][3]+"("+motor_show_gl[i][0]+") "+motor_show_gl[i][1]+"$"
				guiSetTextGridList (avto_menu, i-max_lable*(avto_menu_value-1), text)
			}
		}
	}
	else if (element == shop_menu_button3)
	{	
		if (guiGetVisibleGridList(clothing_menu))
		{
			clothing_menu_value++
			
			if (clothing_menu_value > (guiGetCountGridList(clothing_menu)/max_lable).tointeger())
			{
				clothing_menu_value = (guiGetCountGridList(clothing_menu)/max_lable).tointeger()
				return
			}

			for (local i = max_lable*(clothing_menu_value-1); i < max_lable*clothing_menu_value; i++)
			{
				guiSetTextGridList (clothing_menu, i-max_lable*(clothing_menu_value-1), i.tostring())
			}
		}
		else if (guiGetVisibleGridList(repair_shop_menu))
		{
			repair_shop_menu_value++
			
			if (repair_shop_menu_value > (guiGetCountGridList(repair_shop_menu)/max_lable).tointeger())
			{
				repair_shop_menu_value = (guiGetCountGridList(repair_shop_menu)/max_lable).tointeger()
				return
			}

			for (local i = max_lable*(repair_shop_menu_value-1); i < max_lable*repair_shop_menu_value; i++)
			{
				local text = repair_shop[i][0]+" "+repair_shop[i][1]+" "+info_png[repair_shop[i][3]][1]+" "+repair_shop[i][2]+"$"
				guiSetTextGridList (repair_shop_menu, i-max_lable*(repair_shop_menu_value-1), text)
			}
		}
		else if (guiGetVisibleGridList(avto_menu))
		{
			avto_menu_value++
			
			if (avto_menu_value > (guiGetCountGridList(avto_menu)/max_lable).tointeger())
			{
				avto_menu_value = (guiGetCountGridList(avto_menu)/max_lable).tointeger()
				return
			}

			for (local i = max_lable*(avto_menu_value-1); i < max_lable*avto_menu_value; i++)
			{
				local text = motor_show_gl[i][3]+"("+motor_show_gl[i][0]+") "+motor_show_gl[i][1]+"$"
				guiSetTextGridList (avto_menu, i-max_lable*(avto_menu_value-1), text)
			}
		}
	}

	//список игроков
	else if (element == shop_menu_button4)
	{
		if (guiGetVisibleGridList(player_menu))
		{
			player_menu_value--

			if (player_menu_value <= 0)
			{
				player_menu_value = 1
				return
			}

			for (local i = max_lable*(player_menu_value-1); i < max_lable*player_menu_value; i++)
			{
				if(getPlayerName(i))
				{
					local text = i+" "+getPlayerName(i)+" (ОП - "+getElementData("crimes["+i+"]")+")"
					guiSetTextGridList (player_menu, i-max_lable*(player_menu_value-1), text)
				}
				else
				{
					local text = i+" "
					guiSetTextGridList (player_menu, i-max_lable*(player_menu_value-1), text)
				}
			}
		}
	}
	else if (element == shop_menu_button5)
	{
		if (guiGetVisibleGridList(player_menu))
		{
			player_menu_value++
			
			if (player_menu_value > (guiGetCountGridList(player_menu)/max_lable).tointeger())
			{
				player_menu_value = (guiGetCountGridList(player_menu)/max_lable).tointeger()
				return
			}

			for (local i = max_lable*(player_menu_value-1); i < max_lable*player_menu_value; i++)
			{
				if(getPlayerName(i))
				{
					local text = i+" "+getPlayerName(i)+" (ОП - "+getElementData("crimes["+i+"]")+")"
					guiSetTextGridList (player_menu, i-max_lable*(player_menu_value-1), text)
				}
				else
				{
					local text = i+" "
					guiSetTextGridList (player_menu, i-max_lable*(player_menu_value-1), text)
				}
			}
		}
	}


//-------------------------------------тестирование разных функций---------------------------------

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
	else if (value == "box")
	{
		inv_slot_box[id3][0] = id1
		inv_slot_box[id3][1] = id2
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
	else if (value == "box")
	{
		box = text

		if (state_inv_gui)
		{
			if (box != "") 
			{
			}
			else 
			{
				state_inv_player = true
				state_inv_box = false
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

local addCommandHandler_marker = 0
addCommandHandler ( "marker",
function ( playerid, x,y )
{
	local playername = getPlayerName ( playerid )
	local x = x.tofloat()
	local y = y.tofloat()

	if (addCommandHandler_marker == 0)
	{
		addCommandHandler_marker = createBlip(x,y, 17, 0)
	}
	else
	{
		destroyBlip(addCommandHandler_marker)
		addCommandHandler_marker = 0
	}
})

/*addCommandHandler("shake",
function (playerid, i1, i2) 
{
	//simpleShake(i1.tofloat(), i2.tofloat(), i3.tofloat())

	local x = guiSetSize(shop_menu_button, i1.tofloat(), i2.tofloat())
	print(x.tostring())
})*/


//-------------------------------------тестирование разных функций---------------------------------
