local database = sqlite( "ebmp-ver-3.1.db" )//база данных
function sqlite3(text)
{
	local result = database.query(text)

	if(text.find("U") == 0 || text.find("I") == 0 || text.find("D") == 0)
	{
		local posfile = file("resources/inventory/scriptfiles/save_sqlite.sql", "a")

		local date = split(getDateTime(), ": ")//установка времени
		local month = date[1].tostring()
		local day = date[2].tostring()
		local chas = date[3].tostring()
		local min = date[4].tostring()
		local sec = date[5].tostring()
		local year = date[6].tointeger()

		local say = "["+day+" "+month+" "+year+" "+chas+":"+min+":"+sec+"] "+text
		for (local i = 0; i < say.len(); i++) 
		{
			posfile.writen(say[i], 'b')
		}
		
		posfile.writen('\n', 'b')
		posfile.close()
	}

	return result
}
function random(min=0, max=RAND_MAX)
{
	srand(getTickCount() * rand())
	return (rand() % ((max + 1) - min)) + min//функция для получения рандомных чисел
}
local element_data = {}
local pogoda = false //зима(false) или лето(true)
local hour = 6
local minute = 0
local earth = {//--слоты земли
	[-1] = [0.0,0.0,0.0, 0,0]
}
local max_earth = 0//мак-ое кол-во выброшенных предметов на землю
local me_radius = 10.0//--радиус отображения действий игрока в чате
local max_fuel = 50.0//--объем бака авто
local max_heal = 720.0//--макс здоровье игрока
local house_bussiness_radius = 1.0//--радиус размещения бизнесов и домов
local max_blip = 250.0//--радиус блипов
local price_hotel = 100//цена за отель
local max_text_len = 90//макс длина сообщения
local car_number = 0//count car
local car_theft_time = 10//время для угона
local crimes_giuseppe = 25//прес-ия для джузеппе
local crimes_capture = crimes_giuseppe*2//--прес-ия для захвата
local business_pos = {}//--позиции бизнесов
local house_pos = {}//--позиции домов
local day_nalog = 7//кол-во дней для оплаты налога
local no_use_wheel_and_engine = [20,27,35,37,38,39]
local police_chanel = 1//канал копов
local admin_chanel = 2//--канал админов
local loto = [0, [], false]//--лотерея
local no_throw_earth = []//--нельзя продать
//нужды
local max_alcohol = 500
local max_satiety = 100
local max_hygiene = 100
local max_sleep = 100
local max_drugs = 100
//законы
local zakon_alcohol = 1
local zakon_alcohol_crimes = 1
local zakon_drugs = 10
local zakon_drugs_crimes = 1
local zakon_kill_crimes = 1
local zakon_robbery_crimes = 1
local zakon_54_crimes = 1
local zakon_80_crimes = 1
local zakon_car_theft_crimes = 1
local zakon_nalog_car = 500
local zakon_nalog_house = 1000
local zakon_nalog_business = 2000
local zakon_price_house = 300000
local zakon_price_business = 300000
//зп
local zp_player_taxi = 2500
local zp_player_busdriver = 24000
local zp_player_fish = 50
local zp_player_phone = 500
local zp_player_show = 24000
local money_guns_zone = 5000
local money_guns_zone_business = 1000
local zp_player_police_car = 5000
local zp_loto = 10000
//вместимость складов бизнесов
local max_business = 100
local max_sg = 1000

//капты-----------------------------------------------------------------------------------------------------------
local point_guns_zone = [0,0, 0,0, 0,0]//0-идет ли захват, 1-номер зоны, 2-атакующие, 3-очки захвата, 4-защищающие, 5-очки захвата
local time_gz = 1*60
local time_guns_zone = time_gz
local name_mafia = {
	[0] = ["no", [255,255,255], []],
	[1] = ["Bombers", [255,255,0], [39,40,41]],
	[2] = ["Grease", [50,50,50], [123,124,125,126,127]],
	[3] = ["Irishmen", [150,75,0], [24,82,83,84]],
	[4] = ["Triads", [255,0,0], [51,52,54]],
}
local guns_zone = {}
//----------------------------------------------------------------------------------------------------------------

//----цвета----
local color_tips = [168,228,160]//--бабушкины яблоки
local yellow = [255,255,0]//--желтый
local red = [255,0,0]//--красный
local red_try = [200,0,0]//--красный
local blue = [0,150,255]//--синий
local white = [255,255,255]//--белый
local green = [0,255,0]//--зеленый
local green_try = [0,200,0]//--зеленый
local turquoise = [0,255,255]//--бирюзовый
local orange = [255,100,0]//--оранжевый
local orange_do = [255,150,0]//--оранжевый do
local pink = [255,100,255]//--розовый
local lyme = [130,255,0]//--лайм админский цвет
local svetlo_zolotoy = [255,255,130]//--светло-золотой
local crimson = [220,20,60]//--малиновый
local purple = [175,0,255]//--фиолетовый
local gray = [150,150,150]//--серый
local green_rc = [115,180,97]//--темно зеленый

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

local info_png = {
	[0] = ["", ""],
	[1] = ["чековая книжка", "$ в банке"],
	[2] = ["права", "шт"],
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

local quest_table = {//--0 название, 1 описание, 2 кол-во, 4 предмет засчитывания, 5 награда $, 6 награда предметом, 7 массив имен кто выполнил квест
	[1] = ["Мясник", "Обработать ", random(5,10), " кусков мяса", 68, random(1000,5000), [88,10000], []],
	[2] = ["Рудокоп", "Добыть ", random(5,10), " раз железную руду", 60, random(1000,5000), [0,0], []],
	[3] = ["Нефтебарон", "Перевезти ", random(1,2), " раз бочки с нефтью", 61, random(1000,5000), [5,25], []],
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
	[19,20000,80,"Milk Truck",1],
	[20,20000,150,"Parry Bus",20],
	[21,0,150,"Parry Bus Prison",20],
	[22,21000,70,"Potomac Indian",3],
	[23,20000,60,"Quicksilver Windsor",3],
	[24,23500,60,"Quicksilver Windsor Taxi",3],
	[25,7300,65,"Shubert 38",3],
	[26,0,65,"Shubert 38",3],//копия
	[27,40000,100,"Shubert Armored Van",1],
	[28,23000,80,"Shubert Beverly",1],
	[29,35000,70,"Shubert Frigate",1],
	[30,0,65,"Shubert Hearse",1],
	[31,7300,65,"Shubert 38 Panel Truck",1],
	[32,0,65,"Shubert 38 Panel Truck",1],//копия
	[33,0,65,"Shubert 38 Taxi",3],
	[34,0,100,"Shubert Truck",1],
	[35,30000,100,"Shubert Truck Flatbed",1],//копия
	[36,0,100,"Shubert Truck Flatbed",1],
	[37,0,100,"Shubert Truck Covered",1],
	[38,20000,100,"Shubert Truck Seagift",1],
	[39,20000,100,"Shubert Show Plow",1],
	[40,0,80,"Military Truck",1],
	[41,21400,80,"Smith Custom 200",3],
	[42,25000,80,"Smith Custom 200 Police Special",3],
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

local pogoda_string_true = [1,1]
local weather_server_true = {
	[1] =["DT_RTRclear_day_night", "DT_RTRclear_day_morning", "DT_RTRclear_day_afternoon", "DT_RTRclear_day_evening"],
	[2] =["DT_RTRrainy_day_night", "DT_RTRrainy_day_morning", "DT_RTRrainy_day_afternoon", "DT_RTRrainy_day_evening"],
	[3] =["DT_RTRfoggy_day_night", "DT_RTRfoggy_day_morning", "DT_RTRfoggy_day_afternoon", "DT_RTRfoggy_day_evening"],
}

local pogoda_string_false = [1,1]
local weather_server_false = {
	[1] =["DT04part02", "DT05part01JoesFlat", "DT05part03HarrysGunshop", "DT02part02JoesFlat"],
	[2] =["DT02NewStart2", "DT05part04Distillery", "DT05part05ElGreco", "DT03part02FreddysBar"],
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
	[-50.8092,704.862,-21.9756],
	[-336.345,568.842,1.03808]
]

local guns = [
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

local fuel_gas = [
	[338.758,875.07,-21.1312],
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

local station = [
	[-554.36,1592.92,-21.8639, 4.0, "Диптон"],
	[-1118.99,1376.44,-18.5, 4.0, "Кингстон"],
	[-1535.55,-231.03,-13.5892, 4.0, "Сэнд-Айленд"],
	[-511.412,20.1703,-5.7096, 4.0, "Вест-Сайд"],
	[-113.792,-481.71,-8.92243, 4.0, "Сауспорт"],
	[234.395,380.914,-9.41271, 4.0, "Китайский квартал"],
	[-293.069,568.25,-2.27367, 4.0, "Аптаун"],
]

local sell_car_theft = [
	[-130.638,1745.93,-18.348],
]

local table_sg_pos = [
	[385.372,126.822,-20.2027],
	[374.982,132.089,-20.2027],
	[362.548,135.839,-20.2027],
]

local busdriver_pos = [
	[-377.247,467.86,-1.1542],
	[-471.443,8.72486,-1.25911],
	[-429.84,-299.925,-11.6514],
	[-139.438,-472.443,-15.243],
	[296.425,-314.303,-20.0969],
	[274.915,357.74,-21.4706],
	[475.727,736.809,-21.1842],
	[162.779,832.845,-19.5612],
	[-579.48,1601.35,-16.3978],
	[ -1150.22,1483.88,-3.32825],
	[ -1667.73,1094.03,-6.92672],
	[ -1599.38,-192.854,-20.2267],
	[ -1561.77,106.105,-13.2248],
	[ -1347.41,420.672,-23.6699],
	[ -1615.43,995.021,-5.83024],
	[ -1066.34,1460.33,-3.84283],
	[ -568.908,1582.26,-16.3778],
	[ -171.018,726.083,-20.4468],
	[ -102.617,374.2,-13.9325],
	[-422.731,479.451,0.1],
]

local coal_pos = [
	[-1285.74,1600.94,3.75443],
	[-1145.61,1189.81,-21.7018],
	[-839.285,1421.56,-8.95012],
	[-619.004,1521.83,-14.0474],
	[-326.743,1781.94,-23.5438],
	[-329.761,1729.01,-22.7633],
	[49.5566,874.461,-19.3668],
	[755.486,932.826,-11.9139],
	[514.073,758.171,-21.2519],
	[354.157,731.62,-24.889],
	[206.186,288.341,-19.8485],
	[474.607,258.013,-19.8618],
	[389.525,-282.05,-19.8376],
	[642.575,-295.493,-19.9856],
	[725.876,-397.762,-20.1147],
	[-6.67647,-404.954,-20.0042],
	[-497.981,-441.141,-14.1712],
	[-1682.4,285.108,-19.2365],
	[-1055.03,1669.61,10.7557],
	[-758.935,1642.93,-14.4585],
	[-726.526,1822.71,-14.5112],
	[-730.131,786.25,-18.9143],
	[-668.467,901.199,-18.4088],
	[-535.229,354.225,1.43243],
	[-698.885,7.73414,1.14508],
	[-51.4879,202.96,-14.3421],
	[91.7778,141.146,-19.903],
	[89.9749,192.24,-20.0298],
	[199.126,-149.583,-19.4556],
	[-391.621,-748.271,-21.5819],
	[-280.0,769.465,-19.5924],
	[264.435,-420.828,-19.2624],
]

local taxi_pos = {}//--места для таксистов
local collector_pos = {}//позции для инкассатора
local milk_pos = {}//молочник

local interior_business = [
	[0, "Магазин оружия", 4],
	[1, "Магазин одежды", 2],
	[2, "Киоск", 13],
	[3, "Заправка", 9],
	[4, "Автомастерская", 14],
	[5, "Закусочная", 1]
]

//--здания для работ и фракций
local interior_job = [
//	 0              1                 2       3      4        5    6    7   8
	[0, "Полицейский департамент", -378.987,654.699,-11.5013, 24, "0", 5.0, 0],
	[1, "Мэрия", -115.11,-63.1035,-12.041, 23, "0", 5.0, 0],
	[2, "Автосалон", -199.532,838.583,-21.2431, 21, "0", 5.0, 0],
	[3, "Казино", -539.082,-91.9283,0.436483, 0, "0", 5.0, 9],
	[4, "Ювелирка", -526.354,-40.6722,1.07341, 0, "0", 5.0, 7],
	[5, "Отель Титания", -579.186,-175.013,1.03791, 25, "0", 5.0, 0],
	[6, "Пристань", 566.041,-591.121,-22.7021, 0, "0", 20.0, 2],
	[7, "Суд", -480.222,244.336,3.22333, 0, "0", 5.0, 5],
	[8, "Джузеппе", -165.132,519.097,-19.9438, 26, "0", 5.0, 0],
	[9, "Банк", 67.2002,-202.94,-20.2324, 0, "0", 10.0, 5]
]

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

local eda = {
	[21] = [info_png[21][0], 1, 45],
	[22] = [info_png[22][0], 1, 60],
	[31] = [info_png[31][0], 1, 250],
	[42] = [info_png[42][0], 1, 100],
	[43] = [info_png[43][0], 1, 50],
	[72] = [info_png[72][0], 1, 500],
}

local gas = {
	[5] = [info_png[5][0], 25, 250],
	[23] = [info_png[23][0], 1, 100],
}

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
	["квитанция для оплаты дома на", day_nalog, (zakon_nalog_house*day_nalog), 48],
	["квитанция для оплаты бизнеса на", day_nalog, (zakon_nalog_business*day_nalog), 49],
	["квитанция для оплаты т/с на", day_nalog, (zakon_nalog_car*day_nalog), 50],
]

local sub_cops = [
	[info_png[46][0], 1, 46],
	[info_png[47][0], 1, 47],
	[info_png[95][0], 1, 95],
]

local weapon_cops = {
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

//-места поднятия предметов
local up_car_subject = [//--{x,y,z, радиус 3, ид пнг 4, ид тс 5, зп 6}
	[-632.282,955.495,-17.7324, 15.0, 24, 35, 100],//--склад продуктов
	[1332.08,1284.72,-0.306898, 10.0, 61, 35, 200],//--нефтебаза
	[-1671.4,-300.838,-20.38, 15.0, 87, 35, 200],//стройматериалы
	[374.967,117.759,-21.0186, 5.0, 83, 38, 200],//--погрузка рыбы с рз
	[-217.361,-724.751,-21.4251, 15.0, 82, 38, 50],//--погрузка рыбы для рз
	[650.084,-415.088,-20.1636, 15.0, 53, 19, 200],//молокозавод
	[-1547.07,-108.065,-18.4974, 15.0, 62, 35, 200],//алко склад
	[-266.696,-723.971,-21.5144, 15.0, 80, 27, 200],//склад оружия
	[1318.41,1301.02,0.0099332, 10.0, 90, 35, 200],//склад угля
]

local up_player_subject = [//--{x,y,z, радиус 3, ид пнг 4, зп 5, скин 6}
	[-427.786,-737.652,-21.7381, 5.0, 51, 100, 63],//--порт
	[-85.0723,1736.84,-18.7004, 5.0, 40, 1, 0],//--свалка бруски
	[826.577,565.208,-11.196, 5.0, 56, 1, 62],//--банк металла
	[26.051,1828.37,-16.9628, 2.0, 39, 1, 131],//--мясокомбинат
	[1234.46,1188.59,0.489151, 5.0, 59, 1, 134],//--рудокоп
	[-422.731,485.439,0.10922, 5.0, 75, 1, 171],//автобусное депо
	[-422.731,473.258,0.109216, 5.0, 93, 1, 0],//автобусное депо уборка снега
]

//--места сброса предметов
local down_car_subject = [//--{x,y,z, радиус 3, ид пнг 4, ид тс 5}
	[-334.529,-786.738,-21.5261, 15.0, 24, 35],//--порт
	[-334.529,-786.738,-21.5261, 15.0, 61, 35],//--порт
	[-299.495,-734.244,-21.422, 15.0, 83, 38],//порт
	[365.745,116.044,-21.2489, 5.0, 82, 38],//--рыбзавод
	[18.5541,1195.61,66.7179, 15.0, 87, 35],//--стройплощадка
]

//--места разгрузки
local down_car_subject_pos = [//--{x,y,z, радиус 3, ид пнг 4, ид тс 5, зп 6}
	[1189.65,1146.35,3.06759, 15.0, 63, 35, 200],//--свалка
	[119.838,-202.878,-20.2502, 15.0, 54, 27, 200],//банк
]

local down_player_subject = [//--{x,y,z, радиус 3, ид пнг 4}
	[-411.778,-827.907,-21.7456, 5.0, 51],//--порт
	[-83.0683,1767.58,-18.4006, 5.0, 55],//--свалка бруски
	[843.815,474.489,-12.0816, 5.0, 57],//--банк металла
	[-1292.64,1608.78,4.30491, 5.0, 66],//--гарри
	[1.93655,1825.94,-16.963, 1.0, 68],//--мясокомбинат
	[341.981,99.035,-21.2723, 5.0, 73],//--рз рыба
	[1235.09,1208.75,1.15567, 5.0, 60],//--склад руды
]

local anim_player_subject = [//--{x,y,z, радиус 3, ид пнг1 4, ид пнг2 5, зп 6, время работы анимации 7}
	
	//свалка бруски
	[-100.209,1777.59,-18.7375, 1.0, 40, 55, 1, 5],
	[-100.209,1784.23,-18.7375, 1.0, 40, 55, 1, 5],
	[-100.209,1791.11,-18.7375, 1.0, 40, 55, 1, 5],
	[-100.209,1812.61,-18.7375, 1.0, 40, 55, 1, 5],
	[-100.209,1819.64,-18.7375, 1.0, 40, 55, 1, 5],
	[-100.209,1826.59,-18.7335, 1.0, 40, 55, 1, 5],
	[-74.3066,1823.29,-18.7367, 1.0, 40, 55, 1, 5],
	[-74.3065,1816.46,-18.7369, 1.0, 40, 55, 1, 5],
	[-74.3066,1809.61,-18.7369, 1.0, 40, 55, 1, 5],
	[-74.3065,1780.41,-18.7371, 1.0, 40, 55, 1, 5],

	//--банк металла
	[825.124,579.623,-12.0828, 1.0, 56, 57, 1, 5],
	[824.448,582.761,-12.0828, 1.0, 56, 57, 1, 5],
	[824.16,586.458,-12.0828, 1.0, 56, 57, 1, 5],

	//мясокомбинат
	[1.69235,1822.66,-16.963, 1.0, 39, 68, 1, 5],
	[-0.230181,1822.67,-16.963, 1.0, 39, 68, 1, 5],
	[1.71198,1820.09,-16.963, 1.0, 39, 68, 1, 5],
	[-0.460387,1820.1,-16.963, 1.0, 39, 68, 1, 5],
	[1.75545,1817.91,-16.963, 1.0, 39, 68, 1, 5],
	[-0.415082,1817.96,-16.963, 1.0, 39, 68, 1, 5],
	[-0.203448,1815.39,-16.963, 1.0, 39, 68, 1, 5],
	[1.79924,1815.35,-16.963, 1.0, 39, 68, 1, 5],

	//рудокоп
	[1256.68,1226.0,4.1122, 10.0, 59, 60, 1, 5],
	[1257.59,1207.59,4.00177, 8.0, 59, 60, 1, 5],
]

for (local i = 0; i <= 9; i++)
{
	anim_player_subject[i][6] = 50
	anim_player_subject[i][7] = 10
}

for (local i = 10; i <= 12; i++)
{
	anim_player_subject[i][6] = 100
	anim_player_subject[i][7] = 10
}

for (local i = 13; i <= 20; i++)
{
	anim_player_subject[i][6] = 100
	anim_player_subject[i][7] = 10
}

for (local i = 21; i <= 22; i++)
{
	anim_player_subject[i][6] = 100
	anim_player_subject[i][7] = 10
}

//слоты игрока
local max_inv = 24
local max_inv_additional = 1//--дополнительные слоты
local array_player_1 = array((getMaxPlayers()), 0)
local array_player_2 = array((getMaxPlayers()), 0)

local state_inv_player = array(getMaxPlayers(), 0)//состояние инв-ря игрока 0-выкл, 1-вкл
local state_gui_window = array(getMaxPlayers(), 0)//--состояние гуи окна 0-выкл, 1-вкл
local logged = array(getMaxPlayers(), 0)//0-не вошел, 1-вошел
local sead = array(getMaxPlayers(), 0)//место в тс
local sead_custom = array(getMaxPlayers(), 0)//кастомное место в тс
local crimes = array(getMaxPlayers(), 0)//преступления
local enter_house = array(getMaxPlayers(), 0)//0-не вошел, 1-вошел (не удалять)
local enter_job = array(getMaxPlayers(), 0)//0-не вошел, 1-вошел (не удалять)
local health = array(getMaxPlayers(), 0)//здоровье
local arrest = array(getMaxPlayers(), 0)//арест игрока, 0-нет, 1-да, 2-да админом
//--нужды
local alcohol = array(getMaxPlayers(), 0)
local satiety = array(getMaxPlayers(), 0)
local hygiene = array(getMaxPlayers(), 0)
local sleep = array(getMaxPlayers(), 0)
local drugs = array(getMaxPlayers(), 0)
//
local robbery_player = array(getMaxPlayers(), 0)//ограбление, 0-нет, 1-да
local robbery_timer = array(getMaxPlayers(), 0)//таймер ограбления
local gps_device = array(getMaxPlayers(), 0)//отображение координат игрока, 0-выкл, 1-вкл
local job = array(getMaxPlayers(), 0)//переменная работ
local job_pos = array(getMaxPlayers(), 0)//позиция места назначения
local job_call = array(getMaxPlayers(), 0)//переменная для работ
local job_vehicleid = array(getMaxPlayers(), 0)//позиция авто
local job_timer = array(getMaxPlayers(), 0)//таймер угона
local car_27 = array(getMaxPlayers(), 0)//переменная для 27 тс
local tp_player_lh = array(getMaxPlayers(), 0)//таймер перелета из еб в лх
local admin_tp = array(getMaxPlayers(), 0)//админ тп
local skin_timer = array(getMaxPlayers(), 0)//смена скина
local timer_job = array(getMaxPlayers(), 0)//таймер работ
local frozen_player = array(getMaxPlayers(), 0)//элементы управления
local game = array(getMaxPlayers(), 0)//--карты игрока
local accept_player = array(getMaxPlayers(), 0)//--переменная игры

//для истории сообщений
local max_message = 15//максимально отображаемое число сообщений
local max_chat = array(getMaxPlayers(), max_message)
local min_chat = array(getMaxPlayers(), 0)
local message = {}//сообщения

//слоты тс
local array_car_1 = {}
local array_car_2 = {}
local fuel = {}//--топливный бак
local dviglo = {}//--двигло вкл или выкл
local probeg = {}//пробег

//слоты дома
local array_house_1 = {}
local array_house_2 = {}

//слоты ящика
local array_box_1 = {}
local array_box_2 = {}

function debuginfo () 
{
	local text_earth = ""
	foreach(i, v in earth)
	{
		text_earth = text_earth + v[0]+"/"+v[1]+"/"+v[2]+"/"+v[3]+"/"+v[4]+"|"
	}

	local text_guns_zone = ""
	foreach(i, v in guns_zone)
	{
		text_guns_zone = text_guns_zone + v[0]+"/"+v[1]+"/"+v[2]+"/"+v[3]+"/"+name_mafia[v[4]][0]+"/"+i+"|"
	}

	local text_guns_zone2 = point_guns_zone[0]+"/"+point_guns_zone[1]+"/"+name_mafia[point_guns_zone[2]][0]+"/"+point_guns_zone[3]+"/"+name_mafia[point_guns_zone[4]][0]+"/"+point_guns_zone[5]+"/"+time_guns_zone

	if(point_guns_zone[0] == 1)
	{
		time_guns_zone = time_guns_zone-1

		if(time_guns_zone == 0)
		{
			time_guns_zone = time_gz

			if(point_guns_zone[3] > point_guns_zone[5])
			{
				guns_zone[point_guns_zone[1]][4] = point_guns_zone[2]

				sendMessageAll(0, "[НОВОСТИ] "+name_mafia[point_guns_zone[2]][0]+" захватила Guns Zone #"+point_guns_zone[1], green)

				sqlite3( "UPDATE guns_zone SET mafia = '"+point_guns_zone[2]+"' WHERE number = '"+point_guns_zone[1]+"'")
			}
			else
			{
				guns_zone[point_guns_zone[1]][4] = point_guns_zone[4]

				sendMessageAll(0, "[НОВОСТИ] "+name_mafia[point_guns_zone[4]][0]+" удержала Guns Zone #"+point_guns_zone[1], green)
			}

			point_guns_zone[0] = 0
			point_guns_zone[1] = 0//gz

			point_guns_zone[2] = 0//mafia A
			point_guns_zone[3] = 0//points

			point_guns_zone[4] = 0//mafia D
			point_guns_zone[5] = 0//points
		}
	}

	foreach (playerid, playername in getPlayers())
	{
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]

		if(point_guns_zone[0] == 1)
		{
			points_add_in_gz(playerid, 1)
		}

		setElementData(playerid, "serial", getPlayerSerial(playerid))
		setElementData(playerid, "alcohol_data", alcohol[playerid])
		setElementData(playerid, "satiety_data", satiety[playerid])
		setElementData(playerid, "hygiene_data", hygiene[playerid])
		setElementData(playerid, "sleep_data", sleep[playerid])
		setElementData(playerid, "drugs_data", drugs[playerid])
		//setElementData(playerid, "fuel_data", 0)
		setElementData(playerid, "probeg_data", 0)
		setElementData(playerid, "gps_device_data", gps_device[playerid])
		setElementData(playerid, "zakon_alcohol", zakon_alcohol)
		setElementData(playerid, "zakon_drugs", zakon_drugs)
		setElementData(playerid, "earth", text_earth)
		setElementData(playerid, "guns_zone", text_guns_zone)
		
		if (search_inv_player_2_parameter(playerid, 91) != 0)
		{
			setElementData(playerid, "guns_zone2", text_guns_zone2)
		}
		else
		{
			setElementData(playerid, "guns_zone2", "0/0/0/0/0/0/0")
		}

		if (minute < 10)
		{
			setElementData(playerid, "timeserver", hour+"-0"+minute)
		}
		else
		{
			setElementData(playerid, "timeserver", hour+"-"+minute)
		}

		for (local i = 0; i < getMaxPlayers(); i++) 
		{	
			if (isPlayerConnected(i))
			{
				setElementData(playerid, "drugs["+i+"]", drugs[i])
				setElementData(playerid, "alcohol["+i+"]", alcohol[i])
				setElementData(playerid, "crimes["+i+"]", crimes[i])
				setElementData(playerid, "is_chat_open["+i+"]", getElementData(i, "is_chat_open"))
				setElementData(playerid, "afk["+i+"]", getElementData(i, "afk"))
			}
		}

		local vehicleid = getPlayerVehicle(playerid)
		if (isPlayerInVehicle(playerid))
		{
			local plate = getVehiclePlateText(vehicleid)
			//setElementData(playerid, "fuel_data", fuel[plate])
			setElementData(playerid, "probeg_data", probeg[plate])
		}

		if (crimes[playerid] != 0 && search_inv_player_2_parameter(playerid, 10) != 0)
		{
			if (inv_player_delet(playerid, 10, search_inv_player_2_parameter(playerid, 10), true, false))
			{
				sendMessage(playerid, "Вы больше не полицейский", yellow)

				if (job[playerid] == 13)
				{
					job_0( playerid )
				}
			}
		}

		setPlayerHealth(playerid, health[playerid].tofloat())
	}
}

local table_job = {
	[1] = function (playerid,playername) {//--работа таксиста
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == 24)
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,taxi_pos.len()-1)

								sendMessage(playerid, "Езжайте на вызов", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [taxi_pos[randomize][0],taxi_pos[randomize][1],taxi_pos[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 40.0))
								{
									local randomize = random(0,taxi_pos.len()-1)

									sendMessage(playerid, "Отвезите клиента", yellow)

									job_call[playerid] = 2
									job_pos[playerid] = [taxi_pos[randomize][0],taxi_pos[randomize][1],taxi_pos[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
								}
							}
							else if (job_call[playerid] == 2) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 40.0))
								{
									local randomize = random(zp_player_taxi/2,zp_player_taxi)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

									sendMessage(playerid, "Вы получили "+randomize+"$", green)

									triggerClientEvent(playerid, "removegps")
									
									job_pos[playerid] = 0
									job_call[playerid] = 0
								}
							}
						}
					}
				}
	},

	[2] = function (playerid,playername) {//--работа водителя мусоровоза
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == down_car_subject_pos[0][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,taxi_pos.len()-1)

								sendMessage(playerid, "Соберите мусор, потом доставьте его на свалку (около заброшенной литейной фабрики)", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [taxi_pos[randomize][0],taxi_pos[randomize][1],taxi_pos[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 40.0))
								{
									local randomize = random(0,taxi_pos.len()-1)
									local randomize_zp = random(down_car_subject_pos[0][6]/2,down_car_subject_pos[0][6])

									give_subject( playerid, "car", down_car_subject_pos[0][4], randomize_zp, false )

									job_pos[playerid] = [taxi_pos[randomize][0],taxi_pos[randomize][1],taxi_pos[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
								}
							}

							if (isPointInCircle3D(x,y,z, down_car_subject_pos[0][0],down_car_subject_pos[0][1],down_car_subject_pos[0][2], down_car_subject_pos[0][3]) && amount_inv_car_1_parameter(vehicleid, down_car_subject_pos[0][4]) != 0)
							{
								local randomize = amount_inv_car_2_parameter(vehicleid, down_car_subject_pos[0][4])

								inv_car_delet_1_parameter(playerid, down_car_subject_pos[0][4], true)

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

								sendMessage(playerid, "Вы получили "+randomize+"$", green)

								triggerClientEvent(playerid, "removegps")
									
								job_pos[playerid] = 0
								job_call[playerid] = 0
							}
						}
					}
				}
	},

	[3] = function (playerid,playername) {//--работа инкассатора
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid) && crimes[playerid] == 0)
				{
					if (getVehicleModel(vehicleid) == down_car_subject_pos[1][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,collector_pos.len()-1)

								sendMessage(playerid, "Соберите деньги, потом доставьте их в банк в Мидтауне", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [collector_pos[randomize][0],collector_pos[randomize][1],collector_pos[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 40.0))
								{
									local randomize = random(0,collector_pos.len()-1)
									local randomize_zp = random(down_car_subject_pos[1][6]/2,down_car_subject_pos[1][6])

									give_subject( playerid, "car", down_car_subject_pos[1][4], randomize_zp, false )

									job_pos[playerid] = [collector_pos[randomize][0],collector_pos[randomize][1],collector_pos[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
								}
							}

							if (isPointInCircle3D(x,y,z, down_car_subject_pos[1][0],down_car_subject_pos[1][1],down_car_subject_pos[1][2], down_car_subject_pos[1][3]) && amount_inv_car_1_parameter(vehicleid, down_car_subject_pos[1][4]) != 0)
							{
								local randomize = amount_inv_car_2_parameter(vehicleid, down_car_subject_pos[1][4])

								inv_car_delet_1_parameter(playerid, down_car_subject_pos[1][4], true)

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

								sendMessage(playerid, "Вы получили "+randomize+"$", green)

								triggerClientEvent(playerid, "removegps")
									
								job_pos[playerid] = 0
								job_call[playerid] = 0
							}
						}
					}
				}
	},

	[4] = function (playerid,playername) {//--работа по починке тел будок
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (getPlayerModel(playerid) == 12)
				{
					if (job_call[playerid] == 0) 
					{
						local randomize = random(0,phohe.len()-1)

						sendMessage(playerid, "Езжайте к телефонной будки", yellow)

						job_call[playerid] = 1
						job_pos[playerid] = [phohe[randomize][0],phohe[randomize][1],phohe[randomize][2]]

						triggerClientEvent(playerid, "removegps")
						triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
					}
				}
	},

	[5] = function (playerid,playername) {//--работа Угонщик
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (crimes[playerid] >= crimes_giuseppe)
				{
					if (job_call[playerid] == 0) 
					{
						local vehicleid = player_car_theft()
						if(vehicleid != false)
						{
							local pos = getVehiclePosition(vehicleid)
							local rot = getVehicleRotation(vehicleid)

							job_call[playerid] = 1
							job_pos[playerid] = [pos[0],pos[1],pos[2]]

							job_vehicleid[playerid] = [vehicleid,pos[0],pos[1],pos[2],rot[0]]
							job_timer[playerid] = timer(car_theft_fun, (car_theft_time*60000), 1, playerid, false)

							sendMessage(playerid, "Угоните т/с гос.номер "+getVehiclePlateText(job_vehicleid[playerid][0])+", у вас есть "+car_theft_time+" мин", yellow)

							triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							triggerClientEvent( playerid, "createHudTimer", (60*car_theft_time).tofloat() )
						}
					}
					else if (job_call[playerid] == 1)
					{
						if (job_vehicleid[playerid][0] == vehicleid)
						{
							local pos = player_position( playerid )
							local x1 = pos[0]
							local y1 = pos[1]

							job_call[playerid] = 2

							local randomize = random(0,sell_car_theft.len()-1)

							sendMessage(playerid, "Езжайте на свалку Майка Бруски", yellow)

							police_chat(playerid, "[ДИСПЕТЧЕР] Угон "+motor_show[getVehicleModel(vehicleid)][3]+" гос.номер "+getVehiclePlateText(vehicleid)+", координаты [X  "+x1+", Y  "+y1+"], подозреваемый "+playername)

							job_pos[playerid] = [sell_car_theft[randomize][0],sell_car_theft[randomize][1],sell_car_theft[randomize][2]]

							triggerClientEvent(playerid, "removegps")
							triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])

							addcrimes(playerid, zakon_car_theft_crimes)
						}
					}
					else if (job_call[playerid] == 2) 
					{
						if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 5.0) && job_vehicleid[playerid][0] == vehicleid)
						{
							if (getSpeed(vehicleid) < 1)
							{
								local randomize = motor_show[getVehicleModel(vehicleid)][1]*0.05

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

								sendMessage(playerid, "Вы получили "+randomize+"$", green)

								job_pos[playerid] = 0
								job_call[playerid] = 3

								car_theft_fun(playerid, true)
							}
						}
					}
				}
	},

	[6] = function (playerid,playername) {//--ор на рз
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (getPlayerModel(playerid) == 133)
				{
					if (job_call[playerid] == 0) 
					{
						local randomize = random(0,table_sg_pos.len()-1)

						sendMessage(playerid, "Идите к столу", yellow)

						job_call[playerid] = 1
						job_pos[playerid] = [table_sg_pos[randomize][0],table_sg_pos[randomize][1],table_sg_pos[randomize][2]]

						triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
					}
					else if (job_call[playerid] >= 1 && job_call[playerid] <= 11)
					{
						if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 5.0))
						{
							job_call[playerid]++
						}
					}
					else if (job_call[playerid] == 12)
					{
						local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, 85)+"'" )
						if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 5.0) && result[1]["COUNT()"] == 1)
						{
							result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, 85)+"'" )

							local id2 = search_inv_player_2_parameter(playerid, 81)

							if (result[1]["warehouse"] < max_sg && result[1]["money"] >= result[1]["price"] && result[1]["nalog"] != 0 && result[1]["prod"] != 0 && id2 != 0)
							{
								local randomize = result[1]["price"]

								inv_player_delet(playerid, 81, id2, true, false)

								id2 = id2 - 1

								inv_player_empty(playerid, 81, id2)

								if (id2 == 0)
								{
									inv_player_delet(playerid, 81, id2, true, false)
								}

								sqlite3( "UPDATE seagift_db SET warehouse = warehouse + '1', prod = prod - '1', money = money - '"+randomize+"' WHERE number = '"+search_inv_player_2_parameter(playerid, 85)+"'" )

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

								sendMessage(playerid, "Вы получили "+randomize+"$", green)
													
								job_call[playerid] = 0

								triggerClientEvent(playerid, "removegps")
							}
						}
					}
				}
	},

	[7] = function (playerid,playername) {//--молочник
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == up_car_subject[5][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,milk_pos.len()-1)

								sendMessage(playerid, "Езжайте на молокозавод в Южный Милвилл чтобы загрузить молоко, а потом развезите его по домам и бизнесам", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [milk_pos[randomize][0],milk_pos[randomize][1],milk_pos[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], up_car_subject[5][3]) && amount_inv_car_1_parameter(vehicleid, up_car_subject[5][4]) != 0)
								{
									local sic2p = search_inv_car_2_parameter(vehicleid, up_car_subject[5][4])
									local randomize = random(0,milk_pos.len()-1)

									job_pos[playerid] = [milk_pos[randomize][0],milk_pos[randomize][1],milk_pos[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])

									inv_car_delet(playerid, up_car_subject[5][4], sic2p, true, false, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+sic2p, playername )

									sendMessage(playerid, "Вы получили "+sic2p+"$", green)
								}
							}
						}
					}
				}
	},

	[8] = function (playerid,playername) {//--алкоперевозчик
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == up_car_subject[6][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,ed.len()-1)

								sendMessage(playerid, "Езжайте на cпиртзавод в Сэнд-Айленд чтобы загрузить ящики с виски, а потом развезите их по бизнесам", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [ed[randomize][0],ed[randomize][1],ed[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], up_car_subject[6][3]) && amount_inv_car_1_parameter(vehicleid, up_car_subject[6][4]) != 0)
								{
									local sic2p = search_inv_car_2_parameter(vehicleid, up_car_subject[6][4])
									local randomize = random(0,ed.len()-1)

									job_pos[playerid] = [ed[randomize][0],ed[randomize][1],ed[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])

									inv_car_delet(playerid, up_car_subject[6][4], sic2p, true, false, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+sic2p, playername )

									sendMessage(playerid, "Вы получили "+sic2p+"$", green)
								}
							}
						}
					}
				}
	},

	[9] = function (playerid,playername) {//--автобусник
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == 20 && getPlayerModel(playerid) == 171)
					{
						if (getSpeed(vehicleid) < 1 && search_inv_player_2_parameter(playerid, up_player_subject[5][4]) != 0)
						{
							if (job_call[playerid] == 0) 
							{
								sendMessage(playerid, "Езжайте по маршруту", yellow)

								job_call[playerid] = search_inv_player_2_parameter(playerid, up_player_subject[5][4])
								job_pos[playerid] = [busdriver_pos[ job_call[playerid]-1 ][0],busdriver_pos[ job_call[playerid]-1 ][1],busdriver_pos[ job_call[playerid]-1 ][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] >= 1 && job_call[playerid] <= 19) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 10.0))
								{
									inv_player_delet(playerid, up_player_subject[5][4], job_call[playerid], true, false)

									job_call[playerid] = job_call[playerid]+1

									inv_player_empty(playerid, up_player_subject[5][4], job_call[playerid])

									job_pos[playerid] = [busdriver_pos[ job_call[playerid]-1 ][0],busdriver_pos[ job_call[playerid]-1 ][1],busdriver_pos[ job_call[playerid]-1 ][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
								}
							}
							else if (job_call[playerid] == 20) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 15.0))
								{
									local randomize = random(zp_player_busdriver/2,zp_player_busdriver)

									inv_player_delet(playerid, up_player_subject[5][4], job_call[playerid], true, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

									sendMessage(playerid, "Вы получили за маршрут "+randomize+"$", green)

									triggerClientEvent(playerid, "removegps")
										
									job_pos[playerid] = 0
									job_call[playerid] = 0
								}
							}
						}
					}
				}
	},

	[10] = function (playerid,playername) {//--перевозчик оружия
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid) && crimes[playerid] == 0)
				{
					if (getVehicleModel(vehicleid) == up_car_subject[7][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,guns.len()-1)

								sendMessage(playerid, "Езжайте на cклад в Порт чтобы загрузить ящики с оружием, а потом развезите их по аммунациям", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [guns[randomize][0],guns[randomize][1],guns[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], up_car_subject[7][3]) && amount_inv_car_1_parameter(vehicleid, up_car_subject[7][4]) != 0)
								{
									local sic2p = search_inv_car_2_parameter(vehicleid, up_car_subject[7][4])
									local randomize = random(0,guns.len()-1)

									job_pos[playerid] = [guns[randomize][0],guns[randomize][1],guns[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])

									inv_car_delet(playerid, up_car_subject[7][4], sic2p, true, false, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+sic2p, playername )

									sendMessage(playerid, "Вы получили "+sic2p+"$", green)
								}
							}
						}
					}
				}
	},

	[11] = function (playerid,playername) {//--перевозчик угля
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == up_car_subject[8][5])
					{
						if (getSpeed(vehicleid) < 1)
						{
							if (job_call[playerid] == 0) 
							{
								local randomize = random(0,coal_pos.len()-1)

								sendMessage(playerid, "Езжайте в Северный Милвилл чтобы загрузить уголь, а потом доставьте его по адресу", yellow)

								job_call[playerid] = 1
								job_pos[playerid] = [coal_pos[randomize][0],coal_pos[randomize][1],coal_pos[randomize][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] == 1) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], up_car_subject[8][3]) && amount_inv_car_1_parameter(vehicleid, up_car_subject[8][4]) != 0)
								{
									local sic2p = search_inv_car_2_parameter(vehicleid, up_car_subject[8][4])
									local randomize = random(0,coal_pos.len()-1)

									job_pos[playerid] = [coal_pos[randomize][0],coal_pos[randomize][1],coal_pos[randomize][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])

									inv_car_delet(playerid, up_car_subject[8][4], sic2p, true, false, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+sic2p, playername )

									sendMessage(playerid, "Вы получили "+sic2p+"$", green)
								}
							}
						}
					}
				}
	},

	[12] = function (playerid,playername) {//--уборка снега
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if (isPlayerInVehicle(playerid))
				{
					if (getVehicleModel(vehicleid) == 39)
					{
						if (getSpeed(vehicleid) < 41*1.6 && search_inv_player_2_parameter(playerid, up_player_subject[6][4]) != 0)
						{
							if (job_call[playerid] == 0) 
							{
								sendMessage(playerid, "Езжайте по маршруту", yellow)

								job_call[playerid] = search_inv_player_2_parameter(playerid, up_player_subject[6][4])
								job_pos[playerid] = [busdriver_pos[ job_call[playerid]-1 ][0],busdriver_pos[ job_call[playerid]-1 ][1],busdriver_pos[ job_call[playerid]-1 ][2]]

								triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
							}
							else if (job_call[playerid] >= 1 && job_call[playerid] <= 19) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 10.0))
								{
									inv_player_delet(playerid, up_player_subject[6][4], job_call[playerid], true, false)

									job_call[playerid] = job_call[playerid]+1

									inv_player_empty(playerid, up_player_subject[6][4], job_call[playerid])

									job_pos[playerid] = [busdriver_pos[ job_call[playerid]-1 ][0],busdriver_pos[ job_call[playerid]-1 ][1],busdriver_pos[ job_call[playerid]-1 ][2]]

									triggerClientEvent(playerid, "removegps")
									triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
								}
							}
							else if (job_call[playerid] == 20) 
							{
								if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 15.0))
								{
									local randomize = random(zp_player_show/2,zp_player_show)

									inv_player_delet(playerid, up_player_subject[6][4], job_call[playerid], true, false)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

									sendMessage(playerid, "Вы получили за маршрут "+randomize+"$", green)

									triggerClientEvent(playerid, "removegps")
										
									job_pos[playerid] = 0
									job_call[playerid] = 0
								}
							}
						}
					}
				}
	},

	[13] = function (playerid,playername) {//--работа транспортный детектив
		local vehicleid = getPlayerVehicle(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]
		if ((getPlayerModel(playerid) == 76) && search_inv_player_2_parameter(playerid, 10) != 0 && crimes[playerid] == 0 && search_inv_player_2_parameter(playerid, 96) != 0)
				{
					if (job_call[playerid] == 0)
					{
						local plate = search_inv_player_2_parameter(playerid, 96)//player_car_police()

						if (plate)
						{
							local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )
							local pos = [result[1]["x"],result[1]["y"],result[1]["z"]]

							job_call[playerid] = [1,plate]
							job_pos[playerid] = [pos[0],pos[1],pos[2]]

							sendMessage(playerid, "Найдите т/с гос.номер "+job_call[playerid][1], yellow)

							triggerClientEvent(playerid, "job_gps", job_pos[playerid][0],job_pos[playerid][1])
						}
					}
					else if (job_call[playerid][0] == 1)
					{
						if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 5.0))
						{
							local randomize = random(zp_player_police_car/2,zp_player_police_car)

							inv_player_delet(playerid, 96, job_call[playerid][1], true, false)

							sqlite3( "UPDATE car_db SET theft = '0' WHERE number = '"+job_call[playerid][1]+"'")

							car_spawn(job_call[playerid][1].tostring())

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

							sendMessage(playerid, "Вы получили "+randomize+"$", green)

							triggerClientEvent(playerid, "removegps")
										
							job_pos[playerid] = 0
							job_call[playerid] = 0
						}
					}
				}
	},
}

function job_timer2 (playerid)
{
	local playername = getPlayerName(playerid)

	timer_job[playerid] = timer(table_job[job[playerid]], 1000, -1, playerid,playername)
}

function sendMessage(playerid, text, color)
{
	local date = split(getDateTime(), ": ")//установка времени
	local chas = date[3]
	local min = date[4]
	local sec = date[5]

	for (local i = min_chat[playerid]; i < message[playerid].len(); i++) 
	{
		sendPlayerMessage(playerid, message[playerid][i][0], message[playerid][i][1],message[playerid][i][2], message[playerid][i][3] )
	}

	sendPlayerMessage(playerid, "["+chas+":"+min+":"+sec+"] "+text, color[0], color[1], color[2])
	message_chat(playerid, "["+chas+":"+min+":"+sec+"] "+text, color[0], color[1], color[2])

	max_chat[playerid] = message[playerid].len()
	min_chat[playerid] = max_chat[playerid] - max_message
}

function sendMessageAll (playerid, text, color) 
{
	foreach (player, playername in getPlayers())
	{
		sendMessage(player, text, color)
	}
}

function sendMessage_log(playerid, text, r, g, b)
{
	sendPlayerMessage(playerid, text, r, g, b)
}

function me_chat(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, text, pink)
		}
	}
}

function me_chat_player(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, "[ME] "+text, pink)
		}
	}
}

function do_chat(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, text, orange_do)
		}
	}
}

function do_chat_player(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, "[DO] "+text, orange_do)
		}
	}
}

function b_chat_player(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, text, gray)
		}
	}
}

function try_chat_player(playerid, text)
{
	local myPos = getPlayerPosition(playerid)
	local randomize = random(0,1)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			if(randomize)
			{
				sendMessage(player, "[TRY] "+text+" [УДАЧНО]", green_try)
			}
			else
			{
				sendMessage(player, "[TRY] "+text+" [НЕУДАЧНО]", red_try)
			}
		}
	}

	return randomize
}

function ic_chat(playerid, text)
{
	local myPos = getPlayerPosition(playerid)

	foreach (player, playername in getPlayers())
	{
		local Pos = getPlayerPosition(player)

		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ))
		{
			sendMessage(player, text, white)
		}
	}
}

function message_chat(playerid, say, r,g,b) 
{
	local table_len = message[playerid].len()
	message[playerid][table_len] <- [say, r,g,b]
}

//чат
addEventHandler("onPlayerChat",
function(playerid, text)
{
	if(logged[playerid] == 0 || arrest[playerid] != 0)
	{
		return
	}
	else if (text.len() > max_text_len)
	{
		sendMessage(playerid, "[ERROR] Максимальная длина сообщения "+max_text_len+" символов", red)
		return
	}

	local count = 0
	local say = "(Всем OOC) "+getPlayerName( playerid )+" ["+playerid+"]: " + text
	local say_10_r = "(Ближний IC) "+getPlayerName( playerid )+" ["+playerid+"]: " + text

	foreach(i, playername in getPlayers())
	{
		local myPos = getPlayerPosition(playerid)
		local Pos = getPlayerPosition(i)

		if(logged[i] == 1 && isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], me_radius ) && i != playerid)
		{
			count = count + 1
		}
	}
	
	if (count == 0)
	{
		sendMessageAll( playerid, say, gray )

		print("[CHAT] "+say)
	}
	else 
	{
		ic_chat( playerid, say_10_r )
		print("[CHAT] "+say_10_r)
	}
})

addEventHandler("up_chat",
function(playerid)
{
	local count = 5

	if(min_chat[playerid]-count < 0)
	{
		return
	}

	max_chat[playerid] -= count
	min_chat[playerid] -= count

	for (local i = min_chat[playerid]; i < max_chat[playerid]; i++)
	{
		sendMessage_log( playerid, message[playerid][i][0], message[playerid][i][1],message[playerid][i][2], message[playerid][i][3] )
	}
})

addEventHandler("down_chat",
function(playerid)
{
	local count = 5

	if(max_chat[playerid]+count > message[playerid].len())
	{
		return
	}
		
	max_chat[playerid] += count
	min_chat[playerid] += count

	for (local i = min_chat[playerid]; i < max_chat[playerid]; i++)
	{
		sendMessage_log( playerid, message[playerid][i][0], message[playerid][i][1],message[playerid][i][2], message[playerid][i][3] )
	}
})

function load_inv(val, value, text)
{
	if (value == "player")
	{	
		foreach (k, v in split(text, ",")) 
		{
			local spl = split(v, ":")
			array_player_1[val][k] = spl[0].tointeger()
			array_player_2[val][k] = spl[1].tointeger()
		}
	}
	else if( value == "car")
	{
		foreach (k, v in split(text, ",")) 
		{
			local spl = split(v, ":")
			array_car_1[val][k] = spl[0].tointeger()
			array_car_2[val][k] = spl[1].tointeger()
		}
	}
	else if( value == "house")
	{
		foreach (k, v in split(text, ",")) 
		{
			local spl = split(v, ":")
			array_house_1[val][k] = spl[0].tointeger()
			array_house_2[val][k] = spl[1].tointeger()
		}
	}
	else if( value == "box")
	{
		foreach (k, v in split(text, ",")) 
		{
			local spl = split(v, ":")
			array_box_1[val][k] = spl[0].tointeger()
			array_box_2[val][k] = spl[1].tointeger()
		}
	}
}

function save_inv(val, value)
{
	if (value == "player")
	{
		local text = ""
		for (local i = 0; i < max_inv+max_inv_additional; i++) 
		{
			text = text+array_player_1[val][i]+":"+array_player_2[val][i]+","
		}
		return text
	}
	else if (value == "car")
	{
		local text = ""
		for (local i = 0; i < max_inv; i++) 
		{
			text = text+array_car_1[val][i]+":"+array_car_2[val][i]+","
		}
		return text
	}
	else if (value == "house")
	{
		local text = ""
		for (local i = 0; i < max_inv; i++) 
		{
			text = text+array_house_1[val][i]+":"+array_house_2[val][i]+","
		}
		return text
	}
	else if (value == "box")
	{
		local text = ""
		for (local i = 0; i < max_inv; i++) 
		{
			text = text+array_box_1[val][i]+":"+array_box_2[val][i]+","
		}
		return text
	}
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

function search_inv_player_police( playerid, id )//--цикл по выводу предметов игрока
{
	local playername = getPlayerName(playerid)

	for (local i = 1; i < max_inv; i++) 
	{
		if(array_player_1[id][i] != 0)
		{
			do_chat(playerid, info_png[ array_player_1[id][i] ][0]+" "+array_player_2[id][i]+" "+info_png[ array_player_1[id][i] ][1]+" - "+playername)
		}
	}
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

	return 0
}

function amount_inv_player_1_parameter(playerid, id1)//--выводит коли-во предметов
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1)
		{
			val = val + 1
		}
	}

	return val
}

function amount_inv_player_2_parameter(playerid, id1)//--выводит сумму всех 2-ых параметров предмета
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1)
		{
			val = val + array_player_2[playerid][i]
		}
	}

	return val
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

function inv_player_delet(playerid, id1, id2, delet_inv, quest_bool)//--удаления предмета игрока
{
	if(delet_inv)
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )

		state_inv_player[playerid] = 0
		enter_house[playerid] = [0,0]
		enter_job[playerid] = 0

		triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
	}

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_player_1[playerid][i] == id1 && array_player_2[playerid][i] == id2)
		{
			inv_server_load( playerid, "player", i, 0, 0, playerid )

			if (quest_bool)
			{
				quest_player(playerid, id1)
			}

			return true
		}
	}

	return false
}

function setplayerhealth (playerid, id) 
{	
	if (id < 720)
	{
		health[playerid] = id
	}
	else 
	{
		health[playerid] = max_heal
	}
}

function getplayerhealth (playerid) 
{
	return health[playerid]
}

function takeAllWeapons (playerid) 
{
	removePlayerWeapon(playerid, 2, 0)
	removePlayerWeapon(playerid, 3, 0)
	removePlayerWeapon(playerid, 4, 0)
	removePlayerWeapon(playerid, 5, 0)
	removePlayerWeapon(playerid, 6, 0)
	removePlayerWeapon(playerid, 8, 0)
	removePlayerWeapon(playerid, 9, 0)
	removePlayerWeapon(playerid, 10, 0)
	removePlayerWeapon(playerid, 11, 0)
	removePlayerWeapon(playerid, 12, 0)
	removePlayerWeapon(playerid, 13, 0)
	removePlayerWeapon(playerid, 14, 0)
	removePlayerWeapon(playerid, 15, 0)
	removePlayerWeapon(playerid, 17, 0)
}

function setPlayerFrozen (playerid, value) 
{
	togglePlayerControls(playerid, value)
	frozen_player[playerid] = value
}

function player_position( playerid )
{
	local myPos = getPlayerPosition(playerid)
	local x_table = split(myPos[0].tostring(), ".")
	local y_table = split(myPos[1].tostring(), ".")

	return [x_table[0].tofloat(),y_table[0].tofloat()]
}

function admin_chat(playerid, text)
{
	foreach (player, value in getPlayers()) 
	{
		local playername = getPlayerName(player)

		if (search_inv_player_2_parameter(player, 37) != 0 && search_inv_player(player, 89, admin_chanel) != 0)
		{
			sendMessage(player, text, lyme)
		}
	}
}

function police_chat(playerid, text)
{
	foreach (player, value in getPlayers()) 
	{
		local playername = getPlayerName(player)

		if (search_inv_player_2_parameter(player, 10) != 0 && search_inv_player(player, 89, police_chanel) != 0)
		{
			sendMessage(player, text, blue)
		}
	}
}

function radio_chat(playerid, text, color)
{
	foreach (player, value in getPlayers()) 
	{
		local playername = getPlayerName(player)

		if (search_inv_player(player, 89, search_inv_player_2_parameter(playerid, 89)) != 0)
		{
			sendMessage(player, text, color)
		}
	}
}

function robbery(playerid, zakon, money, x1,y1,z1, radius, text)
{
	if (logged[playerid] == 1)
	{	
		if (robbery_player[playerid] == 1)
		{
			local myPos = getPlayerPosition(playerid)
			local x = myPos[0]
			local y = myPos[1]
			local z = myPos[2]
			local playername = getPlayerName ( playerid )
			local cash = random(money/2,money)

			if (isPointInCircle3D(x1,y1,z1, x,y,z, radius))
			{	
				if (text == "Arcade")
				{	
					local id1 = 66
					if (inv_player_empty(playerid, id1, cash))
					{
						addcrimes(playerid, zakon)

						sendMessage(playerid, "Вы получили "+info_png[id1][0]+" "+cash+" "+info_png[id1][1], svetlo_zolotoy)

						sendMessage(playerid, "[TIPS] Отвезите украшения в Кингстон к Гарри", color_tips)
					}
					else 
					{
						sendMessage(playerid, "[ERROR] Инвентарь полон", red)
					}
				}
				else 
				{
					addcrimes(playerid, zakon)

					sendMessage(playerid, "Вы унесли "+cash+"$", green)

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+cash, playername )
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы покинули место ограбления", red)
			}

			robbery_kill( playerid )
		}
	}
}

function robbery_kill( playerid )
{
	if (robbery_player[playerid] == 1)
	{
		robbery_player[playerid] = 0

		if (robbery_timer[playerid] != 0)
		{
			robbery_timer[playerid].Kill()
		}

		robbery_timer[playerid] = 0
	}
}

function player_hotel (playerid, id) 
{
	local playername = getPlayerName(playerid)

	if ((price_hotel) <= array_player_2[playerid][0])
	{
		local sleep_hygiene_plus = 100

		if (id == 44)
		{
			hygiene[playerid] = sleep_hygiene_plus
			sendMessage(playerid, "+"+sleep_hygiene_plus+" ед. чистоплотности", yellow)
			me_chat(playerid, playername+" помылся(ась)")
		}
		else if (id == 45)
		{
			sleep[playerid] = sleep_hygiene_plus
			sendMessage(playerid, "+"+sleep_hygiene_plus+" ед. сна", yellow)
			me_chat(playerid, playername+" вздремнул(а)")
		}

		sendMessage(playerid, "Вы заплатили "+(price_hotel)+"$", orange )

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(price_hotel), playerid )
					
		return true
	}
	else 
	{
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		return false
	}
}

function random_sub (playerid, id)//выпадение предметов
{
	local random_sub_array = [
		[51, [ [77,1,20] ]],
		[39, [ [58,3,20] ]],
	]

	local playername = getPlayerName ( playerid )
	local randomize1 = -1
	local randomize2 = random(1,100)
	foreach (k, v in random_sub_array) 
	{
		if (id == v[0])
		{
			randomize1 = random(0,v[1].len()-1)
			if (randomize2 <= v[1][randomize1][2])
			{
				local id1 = v[1][randomize1][0]
				local id2 = v[1][randomize1][1]
				if (inv_player_empty(playerid, id1, id2)) 
				{
					sendMessage(playerid, "Вы получили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], svetlo_zolotoy)
				}
			}
			break
		}
	}
}

function points_add_in_gz(playerid, value) 
{
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	foreach (k, v in guns_zone)
	{	
		if(isPointInRectangle2D(x,y, v[0],v[1],v[2],v[3]) && k == point_guns_zone[1])
		{
			if (search_inv_player_2_parameter(playerid, 91) != 0 && search_inv_player_2_parameter(playerid, 91) == point_guns_zone[2])
			{
				point_guns_zone[3] = point_guns_zone[3]+1*value
			}
			else if(search_inv_player_2_parameter(playerid, 91) != 0 && search_inv_player_2_parameter(playerid, 91) == point_guns_zone[4])
			{
				point_guns_zone[5] = point_guns_zone[5]+1*value
			}
		}
	}
}

function setPlayerColour_fun(playerid) 
{
	if (search_inv_player_2_parameter(playerid, 37) != 0)
	{
		setPlayerColour(playerid, fromRGB(lyme[0],lyme[1],lyme[2]))
	}
	else if (search_inv_player(playerid, 38, 1) != 0)
	{
		setPlayerColour(playerid, fromRGB(green[0],green[1],green[2]))
	}
	else if (search_inv_player_2_parameter(playerid, 10) != 0)
	{
		setPlayerColour(playerid, fromRGB(blue[0],blue[1],blue[2]))
	}
	else if (search_inv_player_2_parameter(playerid, 91) != 0)
	{
		setPlayerColour(playerid, fromRGB(name_mafia[search_inv_player_2_parameter(playerid, 91)][1][0],name_mafia[search_inv_player_2_parameter(playerid, 91)][1][1],name_mafia[search_inv_player_2_parameter(playerid, 91)][1][2]))
	}
	else 
	{
		setPlayerColour(playerid, fromRGB(white[0],white[1],white[2]))
	}
}

function quest_player(playerid, id)
{
	local playername = getPlayerName(playerid)

	if (getElementData(playerid, "quest_select") != "0:0")
	{
		local spl = split(getElementData(playerid, "quest_select"), ":")
		local quest = spl[0].tointeger()
		local quest_progress = spl[1].tointeger()

		if (1 <= quest && quest <= 3)
		{
			if (id == quest_table[quest][4])
			{
				quest_progress = quest_progress+1
				setElementData(playerid, "quest_select", quest+":"+quest_progress)
			}
			
			if (quest_table[quest][2] <= quest_progress)
			{
				if (quest_table[quest][6][0] != 0)
				{
					if (!inv_player_empty(playerid, quest_table[quest][6][0], quest_table[quest][6][1]))
					{
						sendMessage(playerid, "[ERROR] Для завершения квеста освободите инвентарь", red)
						return
					}
					else
					{
						sendMessage(playerid, "[QUEST] Вы получили "+info_png[quest_table[quest][6][0]][0]+" "+quest_table[quest][6][1]+" "+info_png[quest_table[quest][6][0]][1], svetlo_zolotoy)
					}
				}

				setElementData(playerid, "quest_select", "0:0")

				inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+quest_table[quest][5], playername )

				sendMessage(playerid, "[QUEST] Вы получили "+quest_table[quest][5]+"$", green)

				quest_table[quest][7].push(playername)
			}
		}
	}
}

function addcrimes(playerid, value)
{
	local crimes_plus = value
	local playername = getPlayerName(playerid)
	crimes[playerid] = crimes[playerid]+crimes_plus
	sendMessage(playerid, "+"+crimes_plus+" преступление, всего преступлений "+crimes[playerid], blue)
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

function search_inv_car_police( playerid, id )//--цикл по выводу предметов
{
	local playername = getPlayerName(playerid)

	for (local i = 0; i < max_inv; i++) 
	{
		if(array_car_1[id][i] != 0)
		{
			do_chat(playerid, info_png[ array_car_1[id][i] ][0]+" "+array_car_2[id][i]+" "+info_png[ array_car_1[id][i] ][1]+" - "+playername)
		}
	}
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

	return 0
}

function amount_inv_car_1_parameter(vehicleid, id1)//--выводит коли-во предметов
{
	local plate = getVehiclePlateText ( vehicleid )
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1)
		{
			val = val + 1
		}
	}

	return val
}

function amount_inv_car_2_parameter(vehicleid, id1)//--выводит сумму всех 2-ых параметров предмета
{
	local plate = getVehiclePlateText ( vehicleid )
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1)
		{
			val = val + array_car_2[plate][i]
		}
	}

	return val
}

function inv_car_empty(playerid, id1, id2, load_value)//--выдача предмета в авто
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local plate = getVehiclePlateText ( vehicleid )
	local count = 0

	if(load_value)
	{
		for (local i = 0; i < max_inv; i++) 
		{
			if (array_car_1[plate][i] == 0)
			{
				array_car_1[plate][i] = id1
				array_car_2[plate][i] = id2

				triggerClientEvent( playerid, "event_inv_load", "car", i, array_car_1[plate][i].tofloat(), array_car_2[plate][i].tofloat() )

				count = count+1
			}
		}
	}
	else
	{
		for (local i = 0; i < max_inv; i++) 
		{
			if (array_car_1[plate][i] == 0)
			{
				array_car_1[plate][i] = id1
				array_car_2[plate][i] = id2

				triggerClientEvent( playerid, "event_inv_load", "car", i, array_car_1[plate][i].tofloat(), array_car_2[plate][i].tofloat() )

				count = count+1
				break
			}
		}
	}

	if (count != 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			sqlite3( "UPDATE car_db SET inventory = '"+save_inv(plate, "car")+"' WHERE number = '"+plate+"'")
		}
	}

	return count
}

function inv_car_delet(playerid, id1, id2, delet_inv, unload_value, quest_bool)//--удаления предмета в авто
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local plate = getVehiclePlateText ( vehicleid )

	if(delet_inv)
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )

		state_inv_player[playerid] = 0
		enter_house[playerid] = [0,0]
		enter_job[playerid] = 0

		triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
	}

	if(unload_value)
	{
		local count = 0
		for (local i = 0; i < max_inv; i++) 
		{
			if (array_car_1[plate][i] == id1 && array_car_2[plate][i] == id2)
			{
				array_car_1[plate][i] = 0
				array_car_2[plate][i] = 0
				count = count+1

				triggerClientEvent( playerid, "event_inv_load", "car", i, array_car_1[plate][i].tofloat(), array_car_2[plate][i].tofloat() )
			}
		}

		if (count >= 20)
		{
			if (quest_bool)
			{
				quest_player(playerid, id1)
			}
		}
	}
	else
	{
		for (local i = 0; i < max_inv; i++) 
		{
			if (array_car_1[plate][i] == id1 && array_car_2[plate][i] == id2)
			{
				array_car_1[plate][i] = 0
				array_car_2[plate][i] = 0

				if (quest_bool)
				{
					quest_player(playerid, id1)
				}

				triggerClientEvent( playerid, "event_inv_load", "car", i, array_car_1[plate][i].tofloat(), array_car_2[plate][i].tofloat() )
				break
			}
		}
	}

	local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
	if (result[1]["COUNT()"] == 1)
	{
		sqlite3( "UPDATE car_db SET inventory = '"+save_inv(plate, "car")+"' WHERE number = '"+plate+"'")
	}
}

function inv_car_delet_1_parameter(playerid, id1, delet_inv)//--удаление всех предметов по ид
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local plate = getVehiclePlateText ( vehicleid )

	if(delet_inv)
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )

		state_inv_player[playerid] = 0
		enter_house[playerid] = [0,0]
		enter_job[playerid] = 0

		triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
	}

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1)
		{
			array_car_1[plate][i] = 0
			array_car_2[plate][i] = 0

			triggerClientEvent( playerid, "event_inv_load", "car", i, array_car_1[plate][i].tofloat(), array_car_2[plate][i].tofloat() )
		}
	}

	local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
	if (result[1]["COUNT()"] == 1)
	{
		sqlite3( "UPDATE car_db SET inventory = '"+save_inv(plate, "car")+"' WHERE number = '"+plate+"'")
	}
}

function inv_car_throw_earth(vehicleid, id1, id2)//--выброс предмета из авто на землю
{
	local plate = getVehiclePlateText ( vehicleid )
	local pos = getVehiclePosition(vehicleid)
	local count = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_car_1[plate][i] == id1 && array_car_2[plate][i] == id2)
		{
			array_car_1[plate][i] = 0
			array_car_2[plate][i] = 0

			count = count+1

			max_earth = max_earth+1
			earth[max_earth] <- [pos[0],pos[1],pos[2],id1,id2]
		}
	}

	if (count != 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			sqlite3( "UPDATE car_db SET inventory = '"+save_inv(plate, "car")+"' WHERE number = '"+plate+"'")
		}
	}
}

function getSpeed(vehicleid)
{
	local velo = getVehicleSpeed(vehicleid)
	local speed = getDistanceBetweenPoints3D(0.0,0.0,0.0, velo[0],velo[1],velo[2])
	return speed*2.27*1.6
}

function setVehiclePartOpen_fun(playerid, value)
{
	local vehicleid = getPlayerVehicle(playerid)

	if(vehicleid != -1)
	{
		if(value == "true")
		{
			setVehiclePartOpen( vehicleid, VEHICLE_PART_TRUNK, true )
		}
		else
		{
			setVehiclePartOpen( vehicleid, VEHICLE_PART_TRUNK, false )
		}
	}
}
addEventHandler("event_setVehiclePartOpen_fun", setVehiclePartOpen_fun)
//-------------------------------------------------------------------------------------------------

//---------------------------------------дом-------------------------------------------------------------
function search_inv_house( house, id1, id2 )//--цикл по поиску предмета в инв-ре
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_house_1[house][i] == id1 && array_house_2[house][i] == id2)
		{
			val = val + 1
		}
	}

	return val
}

function search_inv_house_police( playerid, id )//--цикл по выводу предметов
{
	local playername = getPlayerName(playerid)

	for (local i = 0; i < max_inv; i++) 
	{
		if(array_house_1[id][i] != 0)
		{
			do_chat(playerid, info_png[ array_house_1[id][i] ][0]+" "+array_house_2[id][i]+" "+info_png[ array_house_1[id][i] ][1]+" - "+playername)
		}
	}
}

function search_inv_house_2_parameter(house, id1)//--вывод 2 параметра предмета
{
	for (local i = 0; i < max_inv; i++) 
	{
		if (array_house_1[house][i] == id1)
		{
			return array_house_2[house][i]
		}
	}

	return 0
}

function amount_inv_house_1_parameter(house, id1)//--выводит коли-во предметов
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_house_1[house][i] == id1)
		{
			val = val + 1
		}
	}

	return val
}

function amount_inv_house_2_parameter(house, id1)//--выводит сумму всех 2-ых параметров предмета
{
	local val = 0

	for (local i = 0; i < max_inv; i++) 
	{
		if (array_house_1[house][i] == id1)
		{
			val = val + array_house_2[house][i]
		}
	}

	return val
}
//--------------------------------------------------------------------------------------------------------

//------------------------------------Element Data-------------------------------------------------
function setElementData (playerid, key, value) 
{
	element_data[playerid][key] <- value
	//print("setElementData["+playerid+"]["+key+"] = "+value)
}
addEventHandler("event_setElementData", setElementData)

function getElementData (playerid, key) 
{	
	//print("getElementData["+playerid+"]["+key+"] = "+element_data[playerid][key])
	return element_data[playerid][key]
}

function element_data_push_client () 
{
	foreach (playerid, playername in getPlayers())
	{	
		local text = ""
		foreach (k, v in element_data[playerid])
		{
			text = text + k+":"+v+";"
		}

		triggerClientEvent(playerid, "event_element_data_push_client", text)
	}
}
//-------------------------------------------------------------------------------------------------

function house_bussiness_job_pos_load( playerid )
{
	foreach (k, v in house_pos) 
	{
		triggerClientEvent( playerid, "event_bussines_house_fun", k, v[0], v[1], v[2], "house", house_bussiness_radius )
	}

	foreach (k, v in business_pos)
	{
		triggerClientEvent( playerid, "event_bussines_house_fun", k, v[0], v[1], v[2], "biz", house_bussiness_radius )
	}
}

function info_bisiness( number )
{
	local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
	return "[business "+number+", type "+result[1]["type"]+", price "+result[1]["price"]+", money "+result[1]["money"]+", warehouse "+result[1]["warehouse"]+"]"
}

function select_sqlite(id1, id2)//--выводит имя владельца любого предмета
{
	foreach (k, result in sqlite3( "SELECT * FROM account" )) 
	{	
		foreach (k, v in split(result["inventory"], ","))
		{
			local spl = split(v, ":")
			if (spl[0].tointeger() == id1 && spl[1].tointeger() == id2)
			{
				return result["name"]
			}
		}
	}

	return false
}

function select_sqlite_t(id1, id2)//--выводит таблицу имен владельцев любого предмета
{
	local table_name = []

	foreach (k, result in sqlite3( "SELECT * FROM account" ))
	{
		foreach (k, v in split(result["inventory"], ","))
		{
			local spl = split(v, ":")
			if (spl[0].tointeger() == id1 && spl[1].tointeger() == id2)
			{
				table_name.push(result["name"])
			}
		}
	}

	if (table_name.len() != 0)
	{
		return table_name
	}
	else
	{
		return false
	}
}

function buy_subject_fun( playerid, text, number, value )
{
	local playername = getPlayerName(playerid)
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	if ( value == "pd" )//пд
	{
		foreach (k, v in sub_cops)
		{
			local text1 = v[0]
			if (text1 == text)
			{
				if (inv_player_empty(playerid, v[2], v[1]))
				{
					sendMessage(playerid, "Вы получили "+text, orange)
				}
				else
				{
					sendMessage(playerid, "[ERROR] Инвентарь полон", red)
				}
				return
			}
		}

		if (search_inv_player(playerid, 41, 1) == 0)
		{
			sendMessage(playerid, "[ERROR] У вас нет лицензии на оружие, приобрести её можно в Мэрии", red)
			return
		}

		foreach (k, v in weapon_cops)
		{
			local text1 = v[0]
			if (text1 == text)
			{
				if (inv_player_empty(playerid, k, 25))
				{
					sendMessage(playerid, "Вы получили "+text, orange)
				}
				else
				{
					sendMessage(playerid, "[ERROR] Инвентарь полон", red)
				}
			}
		}

		return
	}
	else if (value == "mer")//Мэрия
	{
		foreach (k, v in mayoralty_shop)
		{
			local text1 = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
			if (text1 == text)
			{
				if (v[2] <= array_player_2[playerid][0])
				{
					if(v[3] == 10)
					{
						if (inv_player_empty(playerid, v[3], playerid+1))
						{
							sendMessage(playerid, "Вы купили "+text+" за "+v[2]+"$", orange)

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(v[2]), playername )
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else 
					{
						if (inv_player_empty(playerid, v[3], v[1]))
						{
							sendMessage(playerid, "Вы купили "+text+" за "+v[2]+"$", orange)

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(v[2]), playername )
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
				}
			}
		}

		return
	}
	else if (value == "dm")//автосалон
	{
		local police_car = [42,51]

		local playername = getPlayerName ( playerid )
		local x1 = myPos[0]
		local y1 = myPos[1]
		local z1 = myPos[2]
		local car_pos = [0,0,0,0]
		local id = 0

		foreach (k, v in motor_show)
		{
			local text1 = v[3]+"("+v[0]+") "+v[1]+"$"
			if (text1 == text)
			{
				local number1 = 0
				local randomize = random(1,999999)
				local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+randomize+"'" )

				while (true)
				{
					if (result[1]["COUNT()"] == 0)
					{
						number1 = randomize
						break
					}
					else
					{
						randomize = random(1,999999)
						result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+randomize+"'" )
					}
				}

				local val1 = 6
				local val2 = number1
				id = v[0]

				if (isPointInCircle3D(x1,y1,z1, interior_job[2][2],interior_job[2][3],interior_job[2][4], interior_job[2][7]))
				{
					foreach (k1, v1 in police_car) 
					{
						if (v1 == id && search_inv_player_2_parameter(playerid, 10) == 0)
						{
							sendMessage(playerid, "[ERROR] Вы не полицейский", red)
							return
						}
					}

					if (v[1] > array_player_2[playerid][0])
					{
						sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						return
					}

					if (inv_player_empty(playerid, val1, val2))
					{
					}
					else
					{
						sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						return
					}

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-v[1], playername )

					sendMessage(playerid, "Вы купили транспортное средство за "+v[1]+"$", orange)

					if(id == 20)
					{
						car_pos = [-204.662,832.921,-20.6805, 160.0]
					}
					else
					{
						car_pos = [-205.534, 835.04, -20.9558, 160.0]
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Найдите место продажи т/с", red)
					return
				}

				local carcolor = fromRGB(255,255,255)

				local nalog_start = 5

				sendMessage(playerid, "Вы получили "+info_png[val1][0]+" "+val2, orange)

				sqlite3( "INSERT INTO car_db (number, model, nalog, frozen, x, y, z, rot, fuel, car_rgb, tune, wheel, probeg, theft, inventory) VALUES ('"+val2+"', '"+id+"', '"+nalog_start+"', '0', '"+car_pos[0]+"', '"+car_pos[1]+"', '"+car_pos[2]+"', '"+car_pos[3]+"', '"+max_fuel+"', '"+carcolor+"', '0', '0', '0', '0', '33:"+val2+",0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,')" )

				car_spawn(val2.tostring())
				return
			}
		}

		return
	}
	else if (value == "craft")
	{
		craft_fun( playerid, text )

		return
	}
	else if (value == "subway")
	{
		foreach (k, v in station) 
		{
			if (text == v[4])
			{
				setPlayerPosition(playerid, v[0],v[1],v[2])
				return
			}
		}

		return
	}
	else if (value == "giuseppe")
	{
		foreach (k, v in giuseppe)
		{
			local text1 = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
			if (text1 == text)
			{	
				if (k >= 4 && k <= 7)
				{
					local count = false
					local name_mafia_skin = ""
					foreach (k,j in name_mafia[v[1]][2])
					{
						name_mafia_skin = name_mafia_skin+j+","
						if (getPlayerModel(playerid) == j)
						{
							count = true
							if (v[2] <= array_player_2[playerid][0])
							{
								if (inv_player_empty(playerid, v[3], v[1]))
								{
									sendMessage(playerid, "Вы купили "+text+" за "+v[2]+"$", orange)

									inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(v[2]), playername )
								}
								else
								{
									sendMessage(playerid, "[ERROR] Инвентарь полон", red)
								}
							}
							else
							{
								sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
							}
						}
					}

					if (!count)
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в одежде "+name_mafia_skin, red)
					}
				}
				else
				{
					if (v[2] <= array_player_2[playerid][0])
					{
						if (inv_player_empty(playerid, v[3], v[1]))
						{
							sendMessage(playerid, "Вы купили "+text+" за "+v[2]+"$", orange)

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(v[2]), playername )
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
					}
				}

				return
			}
		}

		return
	}
	else if (value == "phone")
	{
		if ("Штрафстоянка" == text)
		{
			sendMessage(playerid, "====[ ШТРАФСТОЯНКА ]====", blue)
			sendMessage(playerid, "Номера т/с", blue)

			foreach (k, v in sqlite3( "SELECT * FROM car_db WHERE nalog = '0'" ))
			{
				sendMessage(playerid, v["number"], blue)
			}
		}
		else if ("Аукцион" == text)
		{
			sendMessage(playerid, "====[ АУКЦИОН ]====", yellow)
			sendMessage(playerid, "[ номер лота - имя продавца - предмет - стоимость - имя покупателя ]", yellow)

			foreach (k, v in sqlite3( "SELECT * FROM auction" ))
			{
				sendMessage(playerid, "[ "+v["i"]+" - "+v["name_sell"]+" - "+info_png[v["id1"]][0]+" "+v["id2"]+" "+info_png[v["id1"]][1]+" - "+v["money"]+"$ - "+v["name_buy"]+" ]", yellow)
			}
		}
		else if ("Рыбзавод" == text)
		{
			sendMessage(playerid, "====[ РЫБЗАВОД ]====", yellow)
			sendMessage(playerid, "[ номер рыбзавода - зарплата - доход от продаж ]", yellow)

			foreach (k, v in sqlite3( "SELECT * FROM seagift_db" ))
			{
				sendMessage(playerid, "[ "+v["number"]+" - "+v["price"]+"$ - "+v["coef"]+" процентов ]", yellow)
			}
		}

		return
	}

	local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
	local prod = 1
	local cash = result[1]["price"]

	if (prod <= result[1]["warehouse"])
	{
		if (cash == 0)
		{
			sendMessage(playerid, "[ERROR] Не установлена стоимость товара (надбавка в N раз)", red)
			return
		}

		if (result[1]["nalog"] <= 0)
		{
			sendMessage(playerid, "[ERROR] Бизнес арестован за уклонение от уплаты налогов", red)
			return
		}

			if (value == 0)
			{
				if (search_inv_player(playerid, 41, 1) == 0)
				{
					sendMessage(playerid, "[ERROR] У вас нет лицензии на оружие, приобрести её можно в Мэрии", red)
					return
				}

				foreach (k, v in weapon)
				{
					local text1 = v[0]+" 25 "+info_png[k][1]+" "+v[2]+"$"
					if (text1 == text)
					{
						if (cash*v[2] <= array_player_2[playerid][0])
						{
							if (inv_player_empty(playerid, k, 25))
							{
								sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

								sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
							}
							else
							{
								sendMessage(playerid, "[ERROR] Инвентарь полон", red)
							}
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						}
					}
				}
			}
			else if (value == 1)
			{	
				if (text.tointeger() >= 0 && text.tointeger() <= 171)
				{
					//нельзя купить
					local no_skin = [0,3,11,14,15,16,21,23,25,26,29,30,31,33,34,36,82,128,136,155,156,157,158,159,160,161,165,166,167,168,169,170]
					foreach (k, v in no_skin) 
					{
						if (v == text.tointeger())
						{
							sendMessage(playerid, "[ERROR] Эта одежда не продается", red)
							return
						}
					}

					if (cash <= array_player_2[playerid][0])
					{
						if (inv_player_empty(playerid, 27, text.tointeger()))
						{
							sendMessage(playerid, "Вы купили "+text+" скин за "+cash+"$", orange)

							sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash+"' WHERE number = '"+number+"'")

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playername )
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] От 0 до 171", red)
				}
			}
			else if (value == 2)
			{
				local v = [shop[30][0], shop[30][1], shop[30][2]]//--покупка лото
				local k = 30
				local randomize = random(1,1000)
				local count = false

				while (true)
				{
					foreach(k,v in loto[1])
					{
						if (v == randomize)
						{
							count = true
						}
					}

					if (!count)
					{
						break
					}
					else
					{
						randomize = random(1,1000)
						count = false
					}
				}

				local text1 = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
				if (text1 == text)
				{
					if (cash*v[2] <= array_player_2[playerid][0])
					{
						if (inv_player_empty(playerid, k, randomize))
						{
							sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

							sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )

							loto[1].push(randomize)
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
					}
					return
				}

				local v = [shop[98][0], shop[98][1], shop[98][2]]//--покупка ящика
				local k = 98
				local key = 99
				local result = sqlite3( "SELECT COUNT() FROM box_db")
				local text1 = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
				if (text1 == text)
				{
					if (cash*v[2] <= array_player_2[playerid][0])
					{
						if (search_inv_player(playerid, 0, 0) >= 2)
						{
							local b = result[1]["COUNT()"]+1

							inv_player_empty(playerid, k, b)
							inv_player_empty(playerid, key, b)

							array_box_1[b] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
							array_box_2[b] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

							sqlite3( "INSERT INTO box_db (number, inventory) VALUES ('"+b+"', '0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,')" )

							sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)
							sendMessage(playerid, "Вы получили "+info_png[key][0]+" "+b, orange)

							sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
					}
					return
				}

				foreach (k, v in shop)
				{
					local text1 = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
					if (text1 == text)
					{
						if (cash*v[2] <= array_player_2[playerid][0])
						{
							if (inv_player_empty(playerid, k, v[1]))
							{
								sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

								sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
							}
							else
							{
								sendMessage(playerid, "[ERROR] Инвентарь полон", red)
							}
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						}
					}
				}
			}
			else if (value == 3)
			{
				foreach (k, v in gas)
				{
					local text1 = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
					if (text1 == text)
					{
						if (cash*v[2] <= array_player_2[playerid][0])
						{
							if (inv_player_empty(playerid, k, v[1]))
							{
								sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

								sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
							}
							else
							{
								sendMessage(playerid, "[ERROR] Инвентарь полон", red)
							}
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						}
					}
				}
			}
			else if (value == 4)
			{
				foreach (k, v in repair_shop)
				{
					local text1 = v[0]+" "+v[1]+" "+info_png[v[3]][1]+" "+v[2]+"$"
					if (text1 == text)
					{
						if (cash*v[2] <= array_player_2[playerid][0])
						{
							if (inv_player_empty(playerid, v[3], v[1]))
							{
								sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

								sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
							}
							else
							{
								sendMessage(playerid, "[ERROR] Инвентарь полон", red)
							}
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						}
					}
				}
			}
			else if (value == 5)
			{
				foreach (k, v in eda)
				{
					local text1 = v[0]+" "+v[1]+" "+info_png[k][1]+" "+v[2]+"$"
					if (text1 == text)
					{
						if (cash*v[2] <= array_player_2[playerid][0])
						{
							if (inv_player_empty(playerid, k, v[1]))
							{
								sendMessage(playerid, "Вы купили "+text+" за "+cash*v[2]+"$", orange)

								sqlite3( "UPDATE business_db SET warehouse = warehouse - '"+prod+"', money = money + '"+cash*v[2]+"' WHERE number = '"+number+"'")

								inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*v[2]), playername )
							}
							else
							{
								sendMessage(playerid, "[ERROR] Инвентарь полон", red)
							}
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
						}
					}
				}
			}

	}
	else
	{
		sendMessage(playerid, "[ERROR] На складе недостаточно товаров", red)
	}
}
addEventHandler ( "event_buy_subject_fun", buy_subject_fun )

//--------------------------эвент по кассе для бизнесов-------------------------------------------------------
function till_fun( playerid, number, money, value )
{
	local playername = getPlayerName(playerid)

	if (value == "withdraw")
	{
		local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
		if (money <= result[1]["money"])
		{
			sqlite3( "UPDATE business_db SET money = money - '"+money+"' WHERE number = '"+number+"'")

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

			sendMessage(playerid, "Вы забрали из кассы "+money+"$", green)
		}
		else
		{
			sendMessage(playerid, "[ERROR] В кассе недостаточно средств", red)
		}
	}
	else if (value == "deposit")
	{
		local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
		if (money <= array_player_2[playerid][0])
		{
			sqlite3( "UPDATE business_db SET money = money + '"+money+"' WHERE number = '"+number+"'")

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-money, playername )

			sendMessage(playerid, "Вы положили в кассу "+money+"$", orange)
		}
		else
		{
			sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		}
	}
	else if (value == "price")
	{
		local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )

		sqlite3( "UPDATE business_db SET price = '"+money+"' WHERE number = '"+number+"'")

		sendMessage(playerid, "Вы установили стоимость товара "+money+"$", yellow)
	}
}

//----------------------------------крафт предметов -----------------------------------------------------------
function craft_fun( playerid, text )
{
	local playername = getPlayerName(playerid)
	local check_house = 0
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

		foreach (k, v in sqlite3("SELECT * FROM house_db")) 
		{
			if (isPointInCircle3D(x,y,z, v["x"],v["y"],v["z"], house_bussiness_radius) && search_inv_player(playerid, 25, v["number"]) != 0)
			{
				check_house = 1
				break
			}
		}

		if(check_house == 0)
		{
			sendMessage(playerid, "[ERROR] Вы не около дома или не его владелец", red)
			return
		}

			foreach (k, v in craft_table) 
			{
				local text1 = v[0]+" = "+v[1]
				if (text == text1)
				{
					local split_sub = split(v[2], ",")
					local split_res = split(v[3], ",")
					local split_sub_create = split(v[4], ",")
					local len = split_sub.len()
					local count = 0

					for (local i = 0; i < len; i++) 
					{
						if (search_inv_player(playerid, split_sub[i].tointeger(), split_res[i].tointeger()) >= 1)
						{
							count = count + 1
						}
					}
					
					if (count == len)
					{
						if ( inv_player_empty(playerid, split_sub_create[0].tointeger(), split_sub_create[1].tointeger()) )
						{
							for (local i = 0; i < len; i++) 
							{
								if ( inv_player_delet(playerid, split_sub[i].tointeger(), split_res[i].tointeger(), false, false) )
								{
								}
							}

							sendMessage(playerid, "Вы создали "+v[0], orange)
						}
						else
						{
							sendMessage(playerid, "[ERROR] Инвентарь полон", red)
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] Недостаточно ресурсов", red)
					}
				}
			}
}
addEventHandler ( "event_craft_fun", craft_fun )

function auction_buy_sell(playerid, value, i, id1, id2, money, name_buy)//--продажа покупка вещей
{
	local playername = getPlayerName ( playerid )
	local randomize = random(1,99999)
	local count = 0

	if (value == "sell")
	{
		if (inv_player_delet(playerid, id1, id2, true, false))
		{
			while (true)
			{
				local result = sqlite3( "SELECT COUNT() FROM auction WHERE i = '"+randomize+"'" )
				if (result[1]["COUNT()"] == 0)
				{
					break
				}
				else
				{
					randomize = random(1,99999)
				}
			}

			sendMessage(playerid, "Вы выставили на аукцион "+info_png[id1][0]+" "+id2+" "+info_png[id1][1]+" за "+money+"$", green)

			sqlite3( "INSERT INTO auction (i, name_sell, id1, id2, money, name_buy) VALUES ('"+randomize+"', '"+playername+"', '"+id1+"', '"+id2+"', '"+money+"', '"+name_buy+"')" )
		}
		else
		{
			sendMessage(playerid, "[ERROR] У вас нет такого предмета", red)
		}
	}
	else if (value == "buy")
	{
		local result = sqlite3( "SELECT COUNT() FROM auction WHERE i = '"+i+"'" )

		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM auction WHERE i = '"+i+"'" )

			if (result[1]["name_buy"] != playername && result[1]["name_buy"] != "all")
			{
				sendMessage(playerid, "[ERROR] Вы не можете купить этот предмет", red)
				return
			}

			if (array_player_2[playerid][0] >= result[1]["money"])
			{
				if (inv_player_empty(playerid, result[1]["id1"], result[1]["id2"]))
				{
					sendMessage(playerid, "Вы купили у "+result[1]["name_sell"]+" "+info_png[result[1]["id1"]][0]+" "+result[1]["id2"]+" "+info_png[result[1]["id1"]][1]+" за "+result[1]["money"]+"$", orange)

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-result[1]["money"], playername )

					foreach (playerid, v in getPlayers())
					{
						if (v == result[1]["name_sell"])
						{
							sendMessage(playerid, playername+" купил у вас "+info_png[result[1]["id1"]][0]+" "+result[1]["id2"]+" "+info_png[result[1]["id1"]][1]+" за "+result[1]["money"]+"$", green)
							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+result[1]["money"], playerid )
							count = count+1
							break
						}
					}

					if (count == 0)
					{
						local result_sell = sqlite3( "SELECT COUNT() FROM account WHERE name = '"+result[1]["name_sell"]+"'" )
						if (result_sell[1]["COUNT()"] == 1)
						{
							local id = getMaxPlayers()
							array_player_1[id] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
							array_player_2[id] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

							local result_sell = sqlite3( "SELECT * FROM account WHERE name = '"+result[1]["name_sell"]+"'" )
							load_inv(id, "player", result_sell[1]["inventory"])

							array_player_2[id][0] = array_player_2[id][0]+result[1]["money"]

							sqlite3( "UPDATE account SET inventory = '"+save_inv(id, "player")+"' WHERE name = '"+result[1]["name_sell"]+"'")
						}
					}

					sqlite3( "DELETE FROM auction WHERE i = '"+i+"'" )
				}
				else
				{
					sendMessage(playerid, "[ERROR] Инвентарь полон", red)
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Лот не найден", red)
		}
	}
	else if (value == "return")
	{
		local result = sqlite3( "SELECT COUNT() FROM auction WHERE i = '"+i+"'" )

		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM auction WHERE i = '"+i+"'" )

			if (playername == result[1]["name_sell"])
			{
				if (inv_player_empty(playerid, result[1]["id1"], result[1]["id2"]))
				{
					sendMessage(playerid, "Вы забрали "+info_png[result[1]["id1"]][0]+" "+result[1]["id2"]+" "+info_png[result[1]["id1"]][1], orange)

					sqlite3( "DELETE FROM auction WHERE i = '"+i+"'" )
				}
				else
				{
					sendMessage(playerid, "[ERROR] Инвентарь полон", red)
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Имена не совпадают", red)
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Лот не найден", red)
		}
	}
}
addEventHandler ( "event_auction_buy_sell", auction_buy_sell )

//----------------------------------------------рыбзавод-----------------------------------------------------
function cow_farms(playerid, value, val1, val2)
{
	local playername = getPlayerName(playerid)
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local cash = 50000
	local doc = 84
	local lic = 85

	if (value == "buy") {
		local result = sqlite3( "SELECT COUNT() FROM seagift_db" )
		result = result[1]["COUNT()"]+1
		if (cash*result > array_player_2[playerid][0]) {
			sendMessage(playerid, "[ERROR] У вас недостаточно средств, необходимо "+(cash*result)+"$", red)
			return
		}

		if (inv_player_empty(playerid, doc, result)) {
			sqlite3( "INSERT INTO seagift_db (number, price, coef, money, nalog, warehouse, prod) VALUES ('"+result+"', '0', '50', '0', '5', '0', '0')" )

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash*result, playername )

			sendMessage(playerid, "Вы купили рыбзавод за "+(cash*result)+"$", orange)

			sendMessage(playerid, "Вы получили "+info_png[doc][0]+" "+result+" "+info_png[doc][1], svetlo_zolotoy)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Инвентарь полон", red)
		}
	}
	else if ( value == "menu") 
	{

		if (val1 == "pay") {
			if (val2 < 1) {
				return
			}

			local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			if (result[1]["COUNT()"] == 0) {
				return
			}

			result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			sqlite3( "UPDATE seagift_db SET price = '"+val2+"' WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			sendMessage(playerid, "Вы установили зарплату "+val2+"$", yellow)
		}
		else if ( val1 == "coef") {
			if (val2 < 1 || val2 > 100) {
				return
			}

			local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			if (result[1]["COUNT()"] == 0) {
				return
			}

			sqlite3( "UPDATE seagift_db SET coef = '"+val2+"' WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			sendMessage(playerid, "Вы установили доход от продаж "+val2+" процентов", yellow)
		}
		else if ( val1 == "balance") {
			if (val2 == 0) {
				return
			}

			if (val2 < 1) {
				local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

				if (result[1]["COUNT()"] == 0) {
					return
				}

				result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

				if ((val2*-1) <= result[1]["money"]) {
					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+(val2*-1), playername )

					sqlite3( "UPDATE seagift_db SET money = money - '"+(val2*-1)+"' WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

					sendMessage(playerid, "Вы забрали из кассы "+(val2*-1)+"$", green)
				}
				else
				{
					sendMessage(playerid, "[ERROR] Недостаточно средств на балансе бизнеса", red)
				}
			}
			else
			{
				if (val2 <= array_player_2[playerid][0]) {
					local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

					if (result[1]["COUNT()"] == 0) {
						return
					}

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-val2, playername )

					sqlite3( "UPDATE seagift_db SET money = money + '"+val2+"' WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

					sendMessage(playerid, "Вы положили в кассу "+val2+"$", orange)
				}
				else
				{
					sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
				}
			}
		}
		else if ( val1 == "tax") {
			local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			if (result[1]["COUNT()"] == 0) {
				return
			}

			result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'" )

			if (search_inv_player(playerid, 49, 7) != 0) {
				if (inv_player_delet(playerid, 49, 7, true, false)) {
					sqlite3( "UPDATE seagift_db SET nalog = nalog + '7' WHERE number = '"+search_inv_player_2_parameter(playerid, doc)+"'")

					sendMessage(playerid, "Вы оплатили налог "+search_inv_player_2_parameter(playerid, doc)+" рыбзавода", yellow)
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] У вас нет "+info_png[49][0]+" 7 "+info_png[49][1], red)
			}
		}
	}
	else if ( value == "job") {
		give_subject(playerid, "player", lic, val1, true)
	}
	else if ( value == "load") {
		local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )

		if (result[1]["COUNT()"] == 0) {
			return false
		}

		result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )
		if ( result[1]["warehouse"]-val1 < 0) {
			sendMessage(playerid, "[ERROR] Склад пуст", red)
			return false
		}

		sqlite3( "UPDATE seagift_db SET warehouse = warehouse - '"+val1+"' WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'")

		return true
	}
	else if ( value == "unload") {
		local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )

		if ( !isPointInCircle3D(x,y,z, down_car_subject[2][0], down_car_subject[2][1],down_car_subject[2][2], down_car_subject[2][3])) {
			return false
		}
		
		if (result[1]["COUNT()"] == 0) {
			return true
		}

		result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )

		inv_car_delet(playerid, 83, val2, true, true, false)

		local money = val1*val2

		local cash2 = money*(100-result[1]["coef"])/100
		local cash = money*result[1]["coef"]/100

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+cash, playername )

		sendMessage(playerid, "Вы разгрузили из т/с "+info_png[83][0]+" "+val1+" шт за "+cash+"$", green)

		sqlite3( "UPDATE seagift_db SET money = money + '"+cash2+"' WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'")

		local result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )

		return true
	}
	else if ( value == "unload_prod") {
		local money = val1*val2
		local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )

		if ( !isPointInCircle3D(x,y,z, down_car_subject[3][0], down_car_subject[3][1],down_car_subject[3][2], down_car_subject[3][3])) {
			return false
		}

		if (result[1]["COUNT()"] == 0) {
			return true
		}

		result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'" )
		if ( result[1]["money"] < money) {
			sendMessage(playerid, "[ERROR] Недостаточно средств на балансе бизнеса", red)
			return true
		}
		else if ( result[1]["prod"] >= max_sg) {
			sendMessage(playerid, "[ERROR] Склад полон", red)
			return true
		}

		inv_car_delet(playerid, 82, val2, true, true, false)

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

		sendMessage(playerid, "Вы разгрузили из т/с "+info_png[82][0]+" "+val1+" шт за "+money+"$", green)

		sqlite3( "UPDATE seagift_db SET money = money - '"+money+"', prod = prod + '"+val1+"' WHERE number = '"+search_inv_player_2_parameter(playerid, lic)+"'")

		return true
	}
}
addEventHandler ( "event_cow_farms", cow_farms )
//-------------------------------------------------------------------------------------------------

function EngineState()//двигатель вкл или выкл
{
	foreach(i, vehicleid in getVehicles()) 
	{
		local plate = getVehiclePlateText(vehicleid)
			
		if(dviglo[plate] == 1)
		{
			setVehicleFuel(vehicleid, (motor_show[getVehicleModel(vehicleid)][2]/max_fuel)*fuel[plate])
		}
		else
		{
			setVehicleFuel(vehicleid, 0.0)
			//setVehicleSpeed( vehicleid, 0.0,0.0,0.0 )
		}
	}
}

function custom_seat_car()//кастомная синхра пасс-их мест
{
	foreach(playerid, playername in getPlayers()) 
	{
		if(sead_custom[playerid][0] != -1)
		{
			local pos = getVehiclePosition(sead_custom[playerid][0])
			setPlayerPosition(playerid, pos[0],pos[1],pos[2]+sead_custom[playerid][1]*3)
		}
	}
}

function fuel_down()//--система топлива авто
{
	foreach(i, vehicleid in getVehicles()) 
	{
		local plate = getVehiclePlateText(vehicleid)
		local fuel_down_number = 0.0002
		local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )

		if (dviglo[plate] == 1 && plate != "0")
		{
			if (fuel[plate] <= 0)
			{
				dviglo[plate] <- 0
			}
			else
			{
				if (getSpeed(vehicleid) == 0)
				{
					fuel[plate] <- fuel[plate] - fuel_down_number
				}
				else
				{
					fuel[plate] <- fuel[plate] - (fuel_down_number*getSpeed(vehicleid))
					probeg[plate] <- probeg[plate] + (getSpeed(vehicleid)/3600)
				}
			}
		}

		setVehicleDirtLevel(vehicleid, 0.0)

		if (result.len() != 0)
		{
			local count = 0
			foreach(i, v1 in no_use_wheel_and_engine) 
			{
				if(getVehicleModel(vehicleid) != v1)
				{
					count++
				}
			}

			if (count == no_use_wheel_and_engine.len())
			{
				setVehicleWheelTexture(vehicleid, 0, result[1]["wheel"])
				setVehicleWheelTexture(vehicleid, 1, result[1]["wheel"])
			}
		}
	}
}

function timer_earth_clear()
{	
	if (hour == 0)
	{
		local count_earth = -1

		foreach (k, v in earth) 
		{
			count_earth = count_earth+1
		}

		print("[timer_earth_clear] max_earth "+max_earth+", count_earth "+count_earth)

		earth = {
			[-1] = [0.0,0.0,0.0, 0,0]
		}
		max_earth = 0

		foreach(playerid, playername in getPlayers())
		{
			sendMessage(playerid, "[НОВОСТИ] Улицы очищенны от мусора", green)
		}
	}
}

function job_0( playerid )
{
	if (timer_job[playerid] != 0)
	{
		timer_job[playerid].Kill()
	}

	triggerClientEvent(playerid, "removegps")

	job[playerid] = 0
	job_pos[playerid] = 0
	job_call[playerid] = 0
	timer_job[playerid] = 0
}

function car_theft_fun(playerid, car_theft_win) 
{
	if(job_vehicleid[playerid] != 0)
	{
		foreach (k, v in getPlayers())
		{
			if(getPlayerVehicle(k) == job_vehicleid[playerid][0])
			{
				removePlayerFromVehicle(k)
			}
		}

		timer(function() {
			setVehiclePosition(job_vehicleid[playerid][0],job_vehicleid[playerid][1],job_vehicleid[playerid][2],job_vehicleid[playerid][3])
			setVehicleRotation(job_vehicleid[playerid][0],job_vehicleid[playerid][4], 0.0, 0.0)

			local plate = getVehiclePlateText(job_vehicleid[playerid][0])
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				sqlite3( "UPDATE car_db SET x = '"+job_vehicleid[playerid][1]+"', y = '"+job_vehicleid[playerid][2]+"', z = '"+job_vehicleid[playerid][3]+"', rot = '"+job_vehicleid[playerid][4]+"', fuel = '"+fuel[plate]+"', probeg = '"+probeg[plate]+"' WHERE number = '"+plate+"'")
			}

			if (car_theft_win)
			{
				sqlite3( "UPDATE car_db SET theft = '1' WHERE number = '"+plate+"'")
				destroyVehicle(job_vehicleid[playerid][0])
			}

			job_vehicleid[playerid] = 0
			job_call[playerid] = 0
		}, 1000, 1)

		if(job_timer[playerid] != 0)
		{
			job_timer[playerid].Kill()
		}

		job_timer[playerid] = 0

		triggerClientEvent( playerid, "destroyHudTimer" )
		triggerClientEvent(playerid, "removegps")
	}
}

function player_car_theft()
{
	local car_theft_table = []

	foreach (idx, v in getVehicles()) 
	{
		if(getVehicleModel(v) != 27)
		{
			car_theft_table.push(v)
		}
	}

	if (car_theft_table.len() > 0)
	{
		local vehicleid = random(0,car_theft_table.len()-1)
		return car_theft_table[vehicleid]
	}
	else
	{
		return false
	}
}

function player_car_police()
{
	local car_theft_table = []

	foreach (k,v in sqlite3( "SELECT * FROM car_db WHERE theft = '1'" ))
	{
		car_theft_table.push(v["number"])
	}

	if (car_theft_table.len() > 0)
	{
		local vehicleid = random(0,car_theft_table.len()-1)
		return car_theft_table[vehicleid]
	}
	else
	{
		return false
	}
}

function player_in_car_theft(plate) 
{
	local count = 0

	foreach (k, v in getPlayers()) 
	{
		if(job_vehicleid[k] != 0)
		{
			if( getVehiclePlateText(job_vehicleid[k][0]) == plate )
			{
				count = count+1
			}
		}
	}

	return count
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

			if (pogoda)
			{
				pogoda_string_true[0] = pogoda_string_true[1]
				pogoda_string_true[1] = random(1,3)

				print("[timeserver] pogoda_string_true "+pogoda_string_true[1])
			}
			else 
			{
				pogoda_string_false[0] = pogoda_string_false[1]
				pogoda_string_false[1] = random(1,2)

				print("[timeserver] pogoda_string_false "+pogoda_string_false[1])
			}

			loto[0] = random(1,1000)
			loto[2] = true
			print("[loto] "+loto[0])

			sendMessageAll(null, "[НОВОСТИ] Лотерея объявляется открытой, быстрее трите свои билеты", green)

			timer_earth_clear()//--очистка земли от предметов
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
			setWeather( weather_server_true[pogoda_string_true[0]][0] )
		}
		else if (hour == 6) 
		{
			setWeather( weather_server_true[pogoda_string_true[0]][1] )
		}
		else if (hour == 12) 
		{
			setWeather( weather_server_true[pogoda_string_true[0]][2] )
		}
		else if (hour == 18) 
		{
			setWeather( weather_server_true[pogoda_string_true[0]][3] )
		}
	}
	else 
	{
		if (hour == 0)
		{
			setWeather( weather_server_false[pogoda_string_false[0]][0] )
		}
		else if (hour == 6) 
		{
			setWeather( weather_server_false[pogoda_string_false[0]][1] )
		}
		else if (hour == 12) 
		{
			setWeather( weather_server_false[pogoda_string_false[0]][2] )
		}
		else if (hour == 18) 
		{
			setWeather( weather_server_false[pogoda_string_false[0]][3] )
		}
	}
}

function spawn_weather (hour) 
{	
	if (pogoda)
	{
		if (hour >= 0 && hour <= 5)
		{
			setWeather( weather_server_true[pogoda_string_true[0]][0] )
		}
		else if (hour >= 6 && hour <= 11)
		{
			setWeather( weather_server_true[pogoda_string_true[0]][1] )
		}
		else if (hour >= 12 && hour <= 17)
		{
			setWeather( weather_server_true[pogoda_string_true[0]][2] )
		}
		else if (hour >= 18 && hour <= 23)
		{
			setWeather( weather_server_true[pogoda_string_true[0]][3] )
		}
	}
	else 
	{
		if (hour >= 0 && hour <= 5)
		{
			setWeather( weather_server_false[pogoda_string_false[0]][0] )
		}
		else if (hour >= 6 && hour <= 11)
		{
			setWeather( weather_server_false[pogoda_string_false[0]][1] )
		}
		else if (hour >= 12 && hour <= 17)
		{
			setWeather( weather_server_false[pogoda_string_false[0]][2] )
		}
		else if (hour >= 18 && hour <= 23)
		{
			setWeather( weather_server_false[pogoda_string_false[0]][3] )
		}
	}
}

function need_1 (playerid, value)//смена скина на бомжа
{
	if (value != "stop")
	{
		skin_timer[playerid] = timer(function () {
			local playername = getPlayerName(playerid)
			local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )

			//--нужды
			if (hygiene[playerid] == 0 && getPlayerModel(playerid) != 153)
			{
				setPlayerModel(playerid, 153)
			}
			else if (hygiene[playerid] > 0 && getPlayerModel(playerid) != result[1]["skin"])
			{
				setPlayerModel(playerid, result[1]["skin"])
			}
		}, 10000, -1)
	}
	else
	{	
		if(skin_timer[playerid] != 0)
		{
			skin_timer[playerid].Kill()
		}
		skin_timer[playerid] = 0
	}
}

function need()//--нужды
{
	foreach (playerid, playername in getPlayers()) 
	{
		local playername = getPlayerName(playerid)

		if (logged[playerid] == 1)
		{
			if (alcohol[playerid] == 500)
			{
				local hygiene_minys = 25
				local hp = getplayerhealth(playerid)-100.0

				setplayerhealth( playerid, hp )

				sendMessage(playerid, "-100 хп", yellow)

				if (hygiene[playerid]-hygiene_minys >= 0)
				{
					hygiene[playerid] = hygiene[playerid]-hygiene_minys
					sendMessage(playerid, "-"+hygiene_minys+" ед. чистоплотности", yellow)
				}

				me_chat(playerid, playername+" стошнило")
			}


			if (drugs[playerid] == 100)
			{
				local hp = getplayerhealth(playerid)-max_heal

				setplayerhealth( playerid, hp )
				sendMessage(playerid, "-720 хп", yellow)
			}


			if (alcohol[playerid] != 0)
			{
				alcohol[playerid] = alcohol[playerid]-10
			}


			if (drugs[playerid]-0.1 >= 0)
			{
				drugs[playerid] = drugs[playerid]-0.1
			}
			else
			{
				drugs[playerid] = 0				
			}


			if (satiety[playerid] == 0)
			{
				local hp = getplayerhealth(playerid)-1.0
				
				setplayerhealth( playerid, hp )
			}
			else
			{
				satiety[playerid] = satiety[playerid]-1
			}


			if (hygiene[playerid] == 0)
			{
			}
			else
			{
				hygiene[playerid] = hygiene[playerid]-1
			}


			if (sleep[playerid] == 0)
			{
				local hp = getplayerhealth(playerid)-1.0
				
				setplayerhealth( playerid, hp )
			}
			else
			{
				sleep[playerid] = sleep[playerid]-1
			}
		}
	}
}

function pay_nalog()
{
	local date = split(getDateTime(), ": ")//установка времени
	local chas = date[3].tointeger()
	local min = date[4].tointeger()
	local sec = date[5].tointeger()

	if (chas == 12 && min == 0)
	{
		local result = sqlite3( "SELECT * FROM car_db" )
		foreach (k, v in result) 
		{
			if (v["nalog"] > 0)
			{
				sqlite3( "UPDATE car_db SET nalog = nalog - '1' WHERE number = '"+v["number"]+"'")
			}
		}

		local result = sqlite3( "SELECT * FROM house_db" )
		foreach (k, v in result) 
		{
			if (v["nalog"] > 0)
			{
				sqlite3( "UPDATE house_db SET nalog = nalog - '1' WHERE number = '"+v["number"]+"'")
			}
		}

		local result = sqlite3( "SELECT * FROM business_db" )
		foreach (k, v in result) 
		{
			if (v["nalog"] > 0)
			{
				sqlite3( "UPDATE business_db SET nalog = nalog - '1' WHERE number = '"+v["number"]+"'")
			}
		}

		local result = sqlite3( "SELECT * FROM seagift_db" )
		foreach (k, v in result) 
		{
			if (v["nalog"] > 0)
			{
				sqlite3( "UPDATE seagift_db SET nalog = nalog - '1' WHERE number = '"+v["number"]+"'")
			}
		}

		print("[pay_nalog]")
	}

	if(min == 0)
	{
		pay_money_gz()

		print("[pay_money_gz]")
	}
}

function pay_money_gz()
{
	foreach (k1,v1 in name_mafia)
	{
		if (k1 != 0)
		{
			local count = 0
			local count2 = 0
			local count_mafia = select_sqlite_t(91, k1)

			if (count_mafia)
			{
				foreach (k,v in guns_zone)
				{
					if(v[4] == k1)
					{
						count = count+1

						foreach (k1,v1 in sqlite3( "SELECT * FROM business_db" ))
						{	
							if(isPointInRectangle2D(v1["x"],v1["y"], v[0],v[1],v[2],v[3]))
							{
								count2 = count2+1
							}
						}
					}
				}

				local money_gz = split((money_guns_zone*count/count_mafia.len()).tostring(), ".")[0].tointeger()
				local money_gzb = split((money_guns_zone_business*count2/count_mafia.len()).tostring(), ".")[0].tointeger()

				foreach (k,v in count_mafia)
				{
					local playerid = getPlayerIdFromName(v)
					local playername = v

					if (playerid != -1 && logged[playerid] == 1)
					{
						sendMessage(playerid, "Вы получили "+money_gz+"$ за удержание территорий", green)
						inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money_gz, playername )

						sendMessage(playerid, "Вы получили "+money_gzb+"$ за крышивание бизнесов", green)
						inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money_gzb, playername )
					}
				}
			}
		}
	}
}

function prison_timer()//--античит если не в тюрьме
{
	foreach (playerid, playername in getPlayers()) 
	{
		local playername = getPlayerName(playerid)
		local myPos = getPlayerPosition(playerid)
		local x = myPos[0]
		local y = myPos[1]
		local z = myPos[2]

		if (arrest[playerid] != 0)
		{
			if (!isPointInCircle3D(x,y,z, -1030.42,1712.74,10.3595, 10.0))
			{
				if (isPlayerInVehicle(playerid))
				{
					removePlayerFromVehicle( playerid )
				}

				state_inv_player[playerid] = 0
				state_gui_window[playerid] = 0
				enter_house[playerid] = [0,0]
				enter_job[playerid] = 0

				takeAllWeapons ( playerid )
				job_0(playerid)
				car_theft_fun(playerid, false)
				robbery_kill( playerid )

				setPlayerPosition( playerid, -1030.42,1712.74,10.3595 )

				triggerClientEvent( playerid, "event_gui_delet" )
				triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
			}
		}
	}
}

function prison()//--таймер заключения
{
	foreach (playerid, playername in getPlayers()) 
	{
		local playername = getPlayerName(playerid)

		if (arrest[playerid] == 1)
		{
			if (crimes[playerid] == 1)
			{
				arrest[playerid] = 0
				crimes[playerid] = 0

				setPlayerPosition( playerid, interior_job[0][2],interior_job[0][3],interior_job[0][4] )

				sendMessage(playerid, "Вы свободны, больше не нарушайте", yellow)
			}
			else if (crimes[playerid] > 1)
			{
				crimes[playerid] = crimes[playerid]-1

				sendMessage(playerid, "Вам сидеть ещё "+(crimes[playerid])+" мин", yellow)
			}
		}
		else if (arrest[playerid] == 2)
		{
			if (array_player_2[playerid][24] == 1)
			{
				arrest[playerid] = 0

				setPlayerPosition( playerid, interior_job[0][2],interior_job[0][3],interior_job[0][4] )

				sendMessage(playerid, "Вы свободны, больше не нарушайте", yellow)

				inv_server_load(playerid, "player", 24, 0, 0, playername)
			}
			else if (array_player_2[playerid][24] > 1)
			{
				array_player_2[playerid][24] = array_player_2[playerid][24]-1

				sendMessage(playerid, "Вам сидеть ещё "+array_player_2[playerid][24]+" мин", yellow)

				inv_server_load(playerid, "player", 24, 28, array_player_2[playerid][24], playername)
			}
		}
	}
}

addEventHandler( "onScriptInit",
function()
{	
	setSummer(pogoda)
	setGameModeText( "discord.gg/000000" )//ссылка на дискорд

	timer( EngineState, 1000, -1 )//двигатель машины
	timer( fuel_down, 1000, -1 )//система топлива
	timer( debuginfo, 1000, -1)//--дебагинфа
	timer( element_data_push_client, 1000, -1)//--элементдата
	timer( timeserver, 1000, -1 )//время сервера 1 игровой час = 1 мин реальных
	timer(need, 60000, -1)//--уменьшение потребностей
	timer(pay_nalog, 60000, -1)//--списание налогов
	timer(prison, 60000, -1)//--таймер заключения в тюрьме
	timer(prison_timer, 1000, -1)//--античит если не в тюрьме
	timer(custom_seat_car, 500, -1)//--синхра пасс-их мест


	local result = sqlite3( "SELECT COUNT() FROM account" )
	print("[account] "+result[1]["COUNT()"])


	local house_number = 0
	foreach (idx, v in sqlite3( "SELECT * FROM house_db" )) 
	{
		array_house_1[v["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		array_house_2[v["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

		load_inv(v["number"], "house", v["inventory"])

		house_pos[v["number"]] <- [v["x"], v["y"], v["z"]]

		house_number++
	}
	print("[house_number] "+house_number)


	local box_number = 0
	foreach (idx, v in sqlite3( "SELECT * FROM box_db" )) 
	{
		array_box_1[v["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		array_box_2[v["number"]] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

		load_inv(v["number"], "box", v["inventory"])

		box_number++
	}
	print("[box_number] "+box_number)


	local business_number = 0
	foreach (idx, v in sqlite3( "SELECT * FROM business_db" )) 
	{
		business_pos[v["number"]] <- [v["x"], v["y"], v["z"]]

		business_number++
	}
	print("[business_number] "+business_number)


	local cow_farms_db_number = 0
	foreach (idx, value in sqlite3( "SELECT * FROM seagift_db" )) 
	{
		cow_farms_db_number++
	}
	print("[seagift_db] "+cow_farms_db_number)


	foreach (idx, value in sqlite3( "SELECT * FROM car_db" )) 
	{	
		car_spawn(value["number"])
	}
	print("[car_number] "+car_number)


	foreach (idx, value in sqlite3( "SELECT * FROM guns_zone" )) 
	{	
		guns_zone[value["number"]] <- [value["x1"],value["y1"],value["x2"],value["y2"],value["mafia"]]
	}


	//загрузка позиций для работ
	foreach (k, v in house_pos) 
	{
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		milk_pos[milk_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in repair) 
	{
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		collector_pos[collector_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in guns) 
	{	
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		collector_pos[collector_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in fuel_gas) 
	{
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		collector_pos[collector_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in clothing) 
	{
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		collector_pos[collector_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in ed) 
	{
		taxi_pos[taxi_pos.len()] <- [v[0],v[1],v[2]]
		collector_pos[collector_pos.len()] <- [v[0],v[1],v[2]]
		milk_pos[milk_pos.len()] <- [v[0],v[1],v[2]]
	}

	foreach (k, v in interior_job)
	{
		taxi_pos[taxi_pos.len()] <- [v[2],v[3],v[4]]
	}
})

function car_spawn(number)
{
	local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+number+"'" )
	if (result[1]["nalog"] != 0 && result[1]["theft"] == 0)
	{
		local color = toRGBA(result[1]["car_rgb"])
		local vehicleid = createVehicle( result[1]["model"], result[1]["x"], result[1]["y"], result[1]["z"] + 0.0, result[1]["rot"], 0.0, 0.0 )

		setVehiclePlateText(vehicleid, number)
		setVehicleColour(vehicleid, color[0], color[1], color[2], color[0], color[1], color[2])
		setVehicleTuningTable(vehicleid, result[1]["tune"])

		array_car_1[number] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		array_car_2[number] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

		fuel[number] <- result[1]["fuel"]
		dviglo[number] <- 0
		probeg[number] <- result[1]["probeg"]

		load_inv(number, "car", result[1]["inventory"])

		car_number++
	}
}

addEventHandler( "onPlayerConnect",
function( playerid, name, ip, serial )
{
	local playername = getPlayerName(playerid)

	element_data[playerid] <- {}
	message[playerid] <- {}

	for (local i = 0; i < 15; i++)//заполнение 15 пустых строк
	{
		message_chat(playerid, "", 0,0,0)
	}

	array_player_1[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	array_player_2[playerid] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

	state_inv_player[playerid] = 0
	state_gui_window[playerid] = 0
	logged[playerid] = 0
	sead[playerid] = -1
	sead_custom[playerid] = [-1/*car id*/, 0/*sead 1,2,3*/]
	crimes[playerid] = 0
	enter_house[playerid] = [0,0]
	enter_job[playerid] = 0
	health[playerid] = max_heal
	arrest[playerid] = 0
	robbery_player[playerid] = 0
	robbery_timer[playerid] = 0
	gps_device[playerid] = 0
	job[playerid] = 0
	job_pos[playerid] = 0
	job_call[playerid] = 0
	car_27[playerid] = false
	job_vehicleid[playerid] = 0
	job_timer[playerid] = 0
	tp_player_lh[playerid] = 0
	admin_tp[playerid] = [0,0]
	skin_timer[playerid] = 0
	timer_job[playerid] = 0
	frozen_player[playerid] = false
	game[playerid] = []
	accept_player[playerid] = [false,false,false,false]

	//--нужды
	alcohol[playerid] = 0
	satiety[playerid] = 0
	hygiene[playerid] = 0
	sleep[playerid] = 0
	drugs[playerid] = 0

	setElementData(playerid, "is_chat_open", 0)
	setElementData(playerid, "afk", "0")
	setElementData(playerid, "quest_select", "0:0")

	timer(function () {
		local result = sqlite3( "SELECT COUNT() FROM account WHERE name = '"+playername+"'" )
		if (result[1]["COUNT()"] == 1 && logged[playerid] == 1)
		{
			local myPos = getPlayerPosition(playerid)
			if (myPos[0] == 0 && myPos[1] == 0 && myPos[2] == 0)
			{
				local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )
				setPlayerPosition(playerid, result[1]["x"],result[1]["y"],result[1]["z"])
			}
		}
	}, 10000, 3)//спавн если х и у = 0

	print("[serial] "+getPlayerSerial(playerid))
})

function playerDisconnect( playerid, reason )
{
	if(logged[playerid] == 1)
	{
		local myPos = getPlayerPosition(playerid)
		local vehicleid = getPlayerVehicle(playerid)
		local heal = getplayerhealth(playerid)
		local playername = getPlayerName(playerid)

		if(isPlayerInVehicle(playerid))
		{
			local pos = getVehiclePosition(vehicleid)
			myPos = [pos[0]+2,pos[1]+2,pos[2]]
		}

		local pass = search_inv_player_2_parameter(playerid, 94)
		if (pass != 0 && playerid+1 != pass)
		{
			inv_player_delet(playerid, 94, pass, false, false)
		}

		local policetoken = search_inv_player_2_parameter(playerid, 10)
		if (policetoken != 0 && playerid+1 != policetoken)
		{
			inv_player_delet(playerid, 10, policetoken, false, false)
		}

		if (myPos[0] != 0 && myPos[1] != 0 && myPos[2] != 0)
		{
			sqlite3( "UPDATE account SET x = '"+myPos[0]+"', y = '"+myPos[1]+"', z = '"+myPos[2]+"', heal = '"+heal+"', arrest = '"+arrest[playerid]+"', crimes = '"+crimes[playerid]+"', alcohol = '"+alcohol[playerid]+"', satiety = '"+satiety[playerid]+"', hygiene = '"+hygiene[playerid]+"', sleep = '"+sleep[playerid]+"', drugs = '"+drugs[playerid]+"' WHERE name = '"+playername+"'")
		}

		if(tp_player_lh[playerid] != 0)
		{
			tp_player_lh[playerid].Kill()
			tp_player_lh[playerid] = 0
			print("[playerDisconnect] tp_player_lh["+playerid+"] = "+tp_player_lh[playerid])
		}

		robbery_kill(playerid)
		job_0(playerid)
		car_theft_fun(playerid, false)
		tp_player(playerid, "kill")
		need_1(playerid, "stop")

		logged[playerid] = 0
	}
}
addEventHandler( "onPlayerDisconnect", playerDisconnect )

addEventHandler( "onPlayerChangeHealth",
function (playerid, newhealth, oldhealth)
{	
	if (logged[playerid] == 1) 
	{
		health[playerid] = newhealth
		//print("newhealth "+newhealth)
	}
})

function nickNameChanged( playerid, newNickname, oldNickname )
{
	print("[onPlayerChangeNick] "+getPlayerName(playerid))
	kickPlayer( playerid )
}
addEventHandler ( "onPlayerChangeNick", nickNameChanged )

function playerDeath( playerid, attacker )
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local playername_a = false
	local reason = "т/с"
	local cash = 100

	if( attacker != INVALID_ENTITY_ID )
	{
		playername_a = getPlayerName ( attacker )
		local myPos_a = getPlayerPosition(attacker)

		if (getPlayerWeapon(attacker))
		{	
			foreach (k, v in weapon) 
			{
				if (v[1] == getPlayerWeapon(attacker))
				{
					reason = v[0]
					break
				}
			}
		}

		if (search_inv_player_2_parameter(attacker, 10) == 0)
		{
			addcrimes(attacker, zakon_kill_crimes)
		}
		else
		{
			if (crimes[playerid] != 0)
			{
				arrest[playerid] = 1

				sendMessage(attacker, "Вы получили премию "+(cash*(crimes[playerid]))+"$", green )

				inv_server_load( attacker, "player", 0, 1, array_player_2[attacker][0]+(cash*(crimes[playerid])), attacker )
			}
			else 
			{
				addcrimes(attacker, zakon_kill_crimes)
			}
		}

		if(point_guns_zone[0] == 1 && search_inv_player_2_parameter(playerid, 91) != 0 && search_inv_player_2_parameter(attacker, 91) != 0)
		{
			foreach (k, v in guns_zone)
			{	
				if(isPointInRectangle2D(myPos[0],myPos[1], v[0],v[1],v[2],v[3]) && k == point_guns_zone[1])
				{
					if(search_inv_player_2_parameter(playerid, 91) == point_guns_zone[4] && search_inv_player_2_parameter(attacker, 91) != point_guns_zone[4])
					{
						points_add_in_gz(attacker, 2)
					}
				}
			}
		}
	}

	/*if (!playername_a)
	{
		sendMessageAll(playerid, "[НОВОСТИ] "+playername+" умер", green)
	}
	else
	{
		sendMessageAll(playerid, "[НОВОСТИ] "+playername_a+" убил "+playername+" Причина: "+reason.tostring(), green)
	}*/

	print("[onPlayerDeath] "+playername+" [attacker - "+playername_a.tostring()+", reason - "+reason.tostring()+"]")

	robbery_kill(playerid)
	job_0( playerid )
	car_theft_fun(playerid, false)
	tp_player(playerid, "kill")
}
addEventHandler( "onPlayerDeath", playerDeath )

addEventHandler( "onPlayerSpawn",
function( playerid )
{
	if (logged[playerid] == 0)
	{
		sendMessage(playerid, "[TIPS] F2 - скрыть или показать худ", color_tips)
		sendMessage(playerid, "[TIPS] F3 - скрыть или показать список игроков", color_tips)
		sendMessage(playerid, "[TIPS] TAB - открыть инвентарь, левая часть экрана - использовать предмет, правая - выкинуть", color_tips)
		sendMessage(playerid, "[TIPS] X - крафт предметов", color_tips)
		sendMessage(playerid, "[TIPS] Листать чат page up и page down", color_tips)
		sendMessage(playerid, "[TIPS] /cmd - команды сервера", color_tips)
		sendMessage(playerid, "[TIPS] Первоначальная работа находится на свалке у Майка Бруски", color_tips)
		sendMessage(playerid, "[TIPS] Граждане не имеющий дом, могут помыться и выспаться в отеле Титания", color_tips)
		sendMessage(playerid, "[TIPS] Права можно получить в Мэрии (зеленый пятиугольник)", color_tips)
		sendMessage(playerid, "[WARNING] Если у вас нету счетчика FPS или 3D текстов, перезайдите!", red)

		reg_or_login(playerid)

		spawn_weather (hour)

		triggerClientEvent( playerid, "destroyHudTimer" )

		foreach (k, v in sqlite3( "SELECT * FROM house_db" )) 
		{
			triggerClientEvent( playerid, "event_blip_create", v["x"], v["y"], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v["x"], v["y"], 6,0, max_blip )
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

		foreach (k, v in station)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,12, max_blip )
		}

		foreach (k, v in down_car_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 10,0, max_blip )
		}

		foreach (k, v in down_car_subject_pos)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 10,0, max_blip )
		}

		foreach (k, v in down_player_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,4, max_blip )
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 10,0, max_blip )
		}

		foreach (k, v in up_car_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,3, max_blip )
		}

		foreach (k, v in up_player_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,3, max_blip )
		}

		foreach (k, v in anim_player_subject)
		{
			triggerClientEvent( playerid, "event_blip_create", v[0], v[1], 0,2, max_blip )
		}

		foreach (k, v in interior_job)
		{
			triggerClientEvent( playerid, "event_blip_create", v[2], v[3], v[5],v[8], max_blip )
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
		if (result[1]["COUNT()"] >= 1) 
		{	
			local result = sqlite3( "SELECT * FROM account WHERE reg_serial = '"+serial+"'" )
			sendMessage(playerid, "[ERROR] Регистрация твинков запрещена, вас кикнет через 10 сек", red)
			setPlayerFrozen(playerid, true)
			timer(function () 
			{	
				if (logged[playerid] == 0)
				{
					kickPlayer(playerid)
				}
			}, 10000, 1)
			return
		}
		
		local result = sqlite3( "INSERT INTO account (name, ban, reason, x, y, z, reg_ip, reg_serial, heal, alcohol, satiety, hygiene, sleep, drugs, skin, arrest, crimes, inventory) VALUES ('"+playername+"', '0', '0', '0', '0', '0', '"+ip+"', '"+serial+"', '"+max_heal+"', '0', '100', '100', '100', '0', '81', '0', '0', '0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,')" )

		local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )

		load_inv(playerid, "player", result[1]["inventory"])
		inv_player_empty(playerid, 1, 500)
		inv_player_empty(playerid, 94, playerid+1)

		logged[playerid] = 1
		alcohol[playerid] = result[1]["alcohol"]
		satiety[playerid] = result[1]["satiety"]
		hygiene[playerid] = result[1]["hygiene"]
		sleep[playerid] = result[1]["sleep"]
		drugs[playerid] = result[1]["drugs"]

		setplayerhealth( playerid, result[1]["heal"] )
		setPlayerModel(playerid, result[1]["skin"])
		setPlayerPosition( playerid, -575.101,1622.8,-15.6957 )

		sendMessage(playerid, "Вы удачно зарегистрировались!", turquoise)

		//sqlite_save_player_action( "CREATE TABLE "+playername+" (player_action TEXT)" )

		print("[ACCOUNT REGISTER] "+playername+" [ip - "+ip+", serial - "+serial+"]")

		house_bussiness_job_pos_load( playerid )
	}
	else if (result[1]["COUNT()"] == 1) 
	{
		local result = sqlite3( "SELECT * FROM account WHERE name = '"+playername+"'" )

		if (result[1]["reg_serial"] != serial)
		{
			sendMessage(playerid, "[ERROR] Вы не владелец аккаунта, вас кикнет через 10 сек", red)
			setPlayerFrozen(playerid, true)
			timer(function () 
			{
				if (logged[playerid] == 0)
				{
					kickPlayer(playerid)
				}
			}, 10000, 1)
			return
		}

		load_inv(playerid, "player", result[1]["inventory"])

		if (inv_player_delet(playerid, 94, search_inv_player_2_parameter(playerid, 94), false, false))
		{
			inv_player_empty(playerid, 94, playerid+1)
		}

		if (inv_player_delet(playerid, 10, search_inv_player_2_parameter(playerid, 10), false, false))
		{
			inv_player_empty(playerid, 10, playerid+1)
		}

		logged[playerid] = 1
		arrest[playerid] = result[1]["arrest"]
		crimes[playerid] = result[1]["crimes"]
		alcohol[playerid] = result[1]["alcohol"]
		satiety[playerid] = result[1]["satiety"]
		hygiene[playerid] = result[1]["hygiene"]
		sleep[playerid] = result[1]["sleep"]
		drugs[playerid] = result[1]["drugs"]

		setPlayerPosition( playerid, result[1]["x"],result[1]["y"],result[1]["z"] )
		setplayerhealth( playerid, result[1]["heal"] )
		setPlayerModel(playerid, result[1]["skin"])

		sendMessage(playerid, "Вы удачно зашли!", turquoise)

		house_bussiness_job_pos_load( playerid )

		if (result[1]["y"] < -1050.0)
		{
			//setPlayerFrozen(playerid, true)
			setPlayerPosition( playerid, -1310.0,-222.0,-23.0 )
			/*sendMessage(playerid, "[TIPS] Вы заморожены, не открывайте чат", color_tips)

			tp_player_lh[playerid] = timer(function () 
			{	
				if(logged[playerid] == 1)
				{
					local myPos = getPlayerPosition(playerid)

					setPlayerPosition( playerid, myPos[0],myPos[1]-1000.0,myPos[2] )
					print(myPos[0]+" "+myPos[1]+" "+myPos[2])

					if((myPos[1]*-1+result[1]["y"]) > -500.0)
					{
						sendMessage(playerid, "[TIPS] Прилетели, можно двигаться, спасибо что воспользовались нашими услугами :)", color_tips)
						//setPlayerFrozen(playerid, false)
						setPlayerPosition( playerid, result[1]["x"],result[1]["y"],result[1]["z"] )
						print(result[1]["x"]+" "+result[1]["y"]+" "+result[1]["z"])

						tp_player_lh[playerid].Kill()
						tp_player_lh[playerid] = 0

						print("tp_player_lh["+playerid+"] = "+tp_player_lh[playerid])
					}
				}
			}, 5000, -1)*/
		}
	}

	need_1(playerid, "start")
	setPlayerColour_fun(playerid)
}

//вход в авто
function playerEnteredVehicle( playerid, vehicleid, seat )
{
	local playername = getPlayerName ( playerid )
	local plate = getVehiclePlateText(vehicleid)
	sead[playerid] = seat

	need_1(playerid, "stop")

	if (seat == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )
			if (result[1]["nalog"] <= 0)
			{
				sendMessage(playerid, "[ERROR] Т/с арестован за уклонение от уплаты налогов", red)
				dviglo[plate] <- 0
				return
			}
		}

		if (car_27[playerid])
		{
			dviglo[plate] <- 0
			return
		}

		if (search_inv_player(playerid, 6, plate.tointeger()) != 0 && search_inv_player(playerid, 2, 1) != 0)
		{
			if (plate.tointeger() != 0)
			{
				for (local id3 = 0; id3 < max_inv; id3++)
				{
					triggerClientEvent( playerid, "event_inv_load", "car", id3, array_car_1[plate][id3].tofloat(), array_car_2[plate][id3].tostring() )
				}
				
				triggerClientEvent( playerid, "event_tab_load", "car", plate )
			}

			if (fuel[plate] <= 1)
			{
				sendMessage(playerid, "[ERROR] Бак пуст", red)
				dviglo[plate] <- 0
				return
			}

			dviglo[plate] <- 1
		}
		else
		{
			sendMessage(playerid, "[ERROR] Чтобы завести т/с надо иметь ключ от т/с и права (можно купить в Мэрии)", red)
			dviglo[plate] <- 0
		}
	}
}
addEventHandler ("onPlayerVehicleEnter", playerEnteredVehicle)

//выход из авто
function PlayerVehicleExit( playerid, vehicleid, seat )
{
	local plate = getVehiclePlateText(vehicleid)
	local carpos = getVehiclePosition(vehicleid)
	local carrot = getVehicleRotation(vehicleid)
	sead[playerid] = -1

	need_1(playerid, "start")

	if (seat == 0)
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{	
			sqlite3( "UPDATE car_db SET x = '"+carpos[0]+"', y = '"+carpos[1]+"', z = '"+carpos[2]+"', rot = '"+carrot[0]+"', fuel = '"+fuel[plate]+"', probeg = '"+probeg[plate]+"' WHERE number = '"+plate+"'")
		}

		triggerClientEvent( playerid, "event_tab_load", "car", "" )

		dviglo[plate] <- 0
		car_27[playerid] = false
	}
}
addEventHandler ("onPlayerVehicleExit", PlayerVehicleExit)

function explode_car(vehicleid)
{
	foreach (player, v in getPlayers()) 
	{
		if (vehicleid == getPlayerVehicle(player))
		{
			removePlayerFromVehicle( player )//антибаг
			setplayerhealth(player, 0.0)
		}
	}

	if (getVehicleModel(vehicleid) == 27)
	{
		for (local i = 0; i < max_inv; i++) 
		{
			local sic2p = search_inv_car_2_parameter(vehicleid, 54)
			inv_car_throw_earth(vehicleid, 54, sic2p)
		}

		for (local i = 0; i < max_inv; i++) 
		{
			local sic2p = search_inv_car_2_parameter(vehicleid, 80)
			inv_car_throw_earth(vehicleid, 80, sic2p)
		}
	}

	explodeVehicle(vehicleid)
}
addEventHandler("onVehicleExplode", explode_car)

function tab_down(playerid)
{	
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local vehicleid = getPlayerVehicle(playerid)

	if (state_gui_window[playerid] == 1)
	{
		return
	}

	if (state_inv_player[playerid] == 0 && arrest[playerid] == 0)
	{
		for (local id3 = 0; id3 < max_inv; id3++)
		{
			triggerClientEvent( playerid, "event_inv_load", "player", id3, array_player_1[playerid][id3].tofloat(), array_player_2[playerid][id3].tostring() )
		}

		if (isPlayerInVehicle(playerid)) 
		{
			local plate = getVehiclePlateText(vehicleid)
		}

		foreach (idx, value in sqlite3( "SELECT * FROM house_db" )) 
		{	
			if (isPointInCircle3D( myPos[0], myPos[1], myPos[2], value["x"], value["y"], value["z"], house_bussiness_radius))
			{	
				local count = 0
				foreach (k, v in getPlayers()) 
				{
					if(enter_house[k][1] == value["number"])
					{
						count = 1
						break
					}
				}

				if (value["nalog"] <= 0)
				{
					sendMessage(playerid, "[ERROR] Дом арестован за уклонение от уплаты налогов", red)
				}
				else if (value["door"] == 0)
				{
					sendMessage(playerid, "[ERROR] Дверь закрыта", red)
				}
				else if (count != 0)
				{

				}
				else 
				{
					for (local id3 = 0; id3 < max_inv; id3++)
					{
						triggerClientEvent( playerid, "event_inv_load", "house", id3, array_house_1[value["number"]][id3].tofloat(), array_house_2[value["number"]][id3].tostring() )
					}

					triggerClientEvent( playerid, "event_tab_load", "house", value["number"] )

					enter_house[playerid] = [1,value["number"]]
				}

				break
			}
		}

		local sic2p = search_inv_player_2_parameter(playerid, 99)
		if (search_inv_player(playerid, 98, sic2p) != 0)
		{
			for (local i = 0; i < max_inv; i++)
			{
				triggerClientEvent( playerid, "event_inv_load", "box", i, array_box_1[sic2p][i], array_box_2[sic2p][i] )
			}

			triggerClientEvent( playerid, "event_tab_load", "box", sic2p )
		}

		if (isPointInCircle3D( x, y, z, interior_job[5][2],interior_job[5][3],interior_job[5][4], interior_job[5][7]))
		{
			enter_job[playerid] = 1
		}

		state_inv_player[playerid] = 1

		triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
	}
	else if (state_inv_player[playerid] == 1)
	{
		triggerClientEvent( playerid, "event_tab_load", "house", "" )
		triggerClientEvent( playerid, "event_tab_load", "box", "" )

		state_inv_player[playerid] = 0
		enter_house[playerid] = [0,0]
		enter_job[playerid] = 0

		triggerClientEvent( playerid, "event_tab_down_fun", state_inv_player[playerid] )
	}
}
addEventHandler ("event_tab_down", tab_down)

function throw_earth_server (playerid, value, id3, id1, id2, tabpanel)//--выброс предмета
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local id1 = id1.tointeger()
	local id2 = id2.tointeger()
	local vehicleid = getPlayerVehicle(playerid)

	if (value == "player")
	{
		foreach (k, v in down_player_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]) && id1 == v[4])//--получение прибыли за предметы
			{
				inv_player_delet( playerid, id1, id2, false, true )
				inv_server_load( playerid, value, 0, 1, array_player_2[playerid][0]+id2, tabpanel )

				sendMessage(playerid, "Вы выбросили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], yellow)

				return
			}
		}

		foreach (k, v in anim_player_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]) && id1 == v[4] && !isPlayerInVehicle(playerid) && !frozen_player[playerid])//--обработка предметов
			{
				local randomize = random(1,v[6])

				inv_player_delet( playerid, id1, id2, true, false )
				inv_player_empty( playerid, v[5], randomize )

				sendMessage(playerid, "Вы получили "+info_png[v[5]][0]+" "+randomize+" "+info_png[v[5]][1], svetlo_zolotoy)

				setPlayerFrozen( playerid, true )

				sendMessage(playerid, "[TIPS] Вы заморожены, не открывайте чат", color_tips)

				triggerClientEvent( playerid, "createHudTimer", (v[7]*1).tofloat() )

				timer(function ()
				{
					if (logged[playerid] == 1)
					{
						setPlayerFrozen(playerid, false)

						sendMessage(playerid, "[TIPS] Можно двигаться", color_tips)
					}
				}, (v[7]*1000), 1)

				return
			}
		}
	}

	max_earth = max_earth+1
	earth[max_earth] <- [myPos[0],myPos[1],myPos[2],id1,id2]

	/*if (enter_house[playerid][1] == id2 && id1 == 25) {//--когда выбрасываешь ключ в инв-ре исчезают картинки(выкл из-за фичи)
		triggerClientEvent( playerid, "event_tab_load", "house", "" )
	}*/

	if (id1 == 98 || id1 == 99) //--когда выбрасываешь ключ в инв-ре исчезают картинки
	{
		triggerClientEvent( playerid, "event_tab_load", "box", "" )
	}

	if (isPlayerInVehicle(playerid)) 
	{
		local plate = getVehiclePlateText ( vehicleid )

		if (sead[playerid] == 0 && id2 == plate.tointeger() && id1 == 6) {//--когда выбрасываешь ключ в инв-ре исчезают картинки
			triggerClientEvent( playerid, "event_tab_load", "car", "" )
		}
	}

	inv_server_load( playerid, value, id3, 0, 0, tabpanel )

	me_chat(playerid, playername+" выбросил(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])
	//sendMessage(playerid, "Вы выбросили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], yellow)
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

		foreach (k, v in down_car_subject)
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))
			{
				if (isPlayerInVehicle(playerid)) 
				{
					if (getVehicleModel(vehicleid) != v[5])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в "+motor_show[v[5]][3]+"("+v[5]+")", red)
						return
					}
				}

				delet_subject(playerid, v[4])
			}
		}

		foreach (k, v in up_car_subject) 
		{
			if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))
			{
				if (isPlayerInVehicle(playerid)) 
				{
					if (getVehicleModel(vehicleid) != v[5])
					{
						sendMessage(playerid, "[ERROR] Вы должны быть в "+motor_show[v[5]][3]+"("+v[5]+")", red)
						return
					}
				}

				give_subject(playerid, "car", v[4], random(v[6]/2,v[6]), true)
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
						sendMessage(playerid, "[ERROR] Вы должны быть в одежде "+v[6], red)
						return
					}
				}

				give_subject(playerid, "player", v[4], random(1,v[5]), true)
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
						sendMessage(playerid, "[ERROR] Вы должны быть в "+motor_show[ down_car_subject[0][5] ][3]+"("+down_car_subject[0][5]+")", red)
						return
					}
				}

				delet_subject(playerid, 24)
			}
		}
		

	foreach (i, v in earth)
	{
		local area = isPointInCircle3D( myPos[0],myPos[1],myPos[2], v[0], v[1], v[2], 10.0 )

		if (area && v[3] != 0)
		{
			local count = false
			foreach (i, v1 in up_player_subject)
			{
				if(v[3] == v1[4])
				{
					count = true
					break	
				}
			}

			if (count && search_inv_player(playerid, v[3], search_inv_player_2_parameter(playerid, v[3])) >= 1) {
				sendMessage(playerid, "[ERROR] Можно переносить только один предмет", red)
				return
			}

			if (inv_player_empty(playerid, v[3], v[4])) 
			{			
				me_chat(playerid, playername+" поднял(а) "+info_png[ v[3] ][0]+" "+v[4]+" "+info_png[ v[3] ][1])
				//sendMessage(playerid, "Вы подняли "+info_png[ v[3] ][0]+" "+v[4]+" "+info_png[ v[3] ][1], svetlo_zolotoy)

				delete earth[i]

				foreach(playerid, playername in getPlayers())
				{
					triggerClientEvent( playerid, "event_earth_load", "nil", 0, 0, 0, 0, 0, 0 )
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Инвентарь полон", red)
			}

			return
		}
	}
}
addEventHandler ( "event_e_down", e_down )

function business_info (playerid, number)
{
	local result = sqlite3( "SELECT * FROM business_db WHERE number = '"+number+"'" )
	sendMessage(playerid, " ", yellow)
	local s_sql = select_sqlite(36, result[1]["number"])

	if (s_sql)
	{
		sendMessage(playerid, "Владелец бизнеса "+s_sql, yellow)
	}
	else
	{
		sendMessage(playerid, "Владелец бизнеса нету", yellow)
	}

	sendMessage(playerid, "Тип "+result[1]["type"], yellow)
	sendMessage(playerid, "Товаров на складе "+result[1]["warehouse"]+" шт", yellow)
	sendMessage(playerid, "Стоимость товара (надбавка в N раз) "+result[1]["price"]+"$", green)

	if (search_inv_player(playerid, 36, result[1]["number"]) != 0)
	{
		sendMessage(playerid, "Состояние кассы "+split(result[1]["money"].tostring(),".")[0]+"$", green)
		sendMessage(playerid, "Налог бизнеса оплачен на "+result[1]["nalog"]+" дней", yellow)
	}
}

function x_down (playerid)
{	
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0) {
		return
	}

	if (state_inv_player[playerid] == 0)//--инв-рь игрока
	{
		if (state_gui_window[playerid] == 0)
		{
			foreach (k, v in sqlite3( "SELECT * FROM business_db" ))//--бизнесы
			{
				if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[0][1])//оружие
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 0 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
				if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[1][1])//одежда
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 1 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
				else if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[2][1])//киоск
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 2 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
				else if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[3][1])//заправка
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 3 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
				else if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[4][1])//автомастерская
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 4 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
				else if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && v["type"] == interior_business[5][1])//еда
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", v["number"], 5 )
					state_gui_window[playerid] = 1
					business_info (playerid, v["number"])
					return
				}
			}

			if ( isPointInCircle3D(x,y,z, interior_job[0][2],interior_job[0][3],interior_job[0][4], interior_job[0][7]) )//пд
			{
				if (search_inv_player_2_parameter(playerid, 10) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не полицейский", red)
					return
				}

				triggerClientEvent( playerid, "event_shop_menu_fun", -1, "pd" )
				state_gui_window[playerid] = 1
				return
			}
			else if ( isPointInCircle3D(x,y,z, interior_job[1][2],interior_job[1][3],interior_job[1][4], interior_job[1][7]) )//Мэрия
			{
				triggerClientEvent( playerid, "event_shop_menu_fun", -1, "mer" )
				state_gui_window[playerid] = 1
				return
			}
			else if ( isPointInCircle3D(x,y,z, interior_job[2][2],interior_job[2][3],interior_job[2][4], interior_job[2][7]) )//автосалон
			{
				triggerClientEvent( playerid, "event_shop_menu_fun", -1, "dm" )
				state_gui_window[playerid] = 1
				return
			}
			else if ( isPointInCircle3D(x,y,z, interior_job[8][2],interior_job[8][3],interior_job[8][4], interior_job[8][7]) )//джузеппе
			{
				if (crimes[playerid] >= crimes_giuseppe)
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", -1, "giuseppe" )
					state_gui_window[playerid] = 1
				}
				else
				{
					sendMessage(playerid, "[ERROR] Нужно иметь "+crimes_giuseppe+" преступлений", red)					
				}
				return
			}

			foreach (k, v in station) 
			{
				if ( isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]) )//subway
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", -1, "subway" )
					state_gui_window[playerid] = 1
					return
				}
			}

			foreach (k, v in phohe) 
			{
				if ( isPointInCircle3D(x,y,z, v[0],v[1],v[2], 5.0) )//phone
				{
					triggerClientEvent( playerid, "event_shop_menu_fun", -1, "phone" )
					state_gui_window[playerid] = 1
					return
				}
			}

			triggerClientEvent( playerid, "event_shop_menu_fun", -1, "craft" )
			state_gui_window[playerid] = 1
		}
		else
		{
			triggerClientEvent( playerid, "event_gui_delet" )
			state_gui_window[playerid] = 0
		}
	}
}
addEventHandler ( "event_x_down", x_down )

function give_subject( playerid, value, id1, id2, load_value )//--выдача предметов игроку или авто
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local vehicleid = getPlayerVehicle(playerid)
	local count2 = 0

	if (value == "player") 
	{
		if (search_inv_player(playerid, id1, search_inv_player_2_parameter(playerid, id1)) >= 1) 
		{
			sendMessage(playerid, "[ERROR] Можно переносить только один предмет", red)
			return
		}

		if (inv_player_empty(playerid, id1, id2)) 
		{
			sendMessage(playerid, "Вы получили "+info_png[id1][0]+" "+id2+" "+info_png[id1][1], svetlo_zolotoy)

			random_sub (playerid, id1)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Инвентарь полон", red)
		}
	}
	else if (value == "car")//--для работ по перевозке ящиков
	{
		if (isPlayerInVehicle(playerid)) 
		{
			count2 = amount_inv_car_1_parameter(vehicleid, 0)

			if (sead[playerid] != 0) 
			{
				return
			}
			else if(count2 == 0)
			{
				sendMessage(playerid, "[ERROR] Багажник заполнен", red)
				return
			}
			else if (id1 == 24 || id1 == 61 || id1 == 87)
			{
				if (search_inv_player(playerid, 34, 6) == 0) 
				{
					sendMessage(playerid, "[ERROR] Вы не дальнобойщик", red)
					return
				}
			}
			else if (id1 == 53) 
			{
				if (search_inv_player(playerid, 34, 7) == 0) 
				{
					sendMessage(playerid, "[ERROR] Вы не молочник", red)
					return
				}
			}
			else if (id1 == 62) 
			{
				if (search_inv_player(playerid, 34, 8) == 0) 
				{
					sendMessage(playerid, "[ERROR] Вы не развозчик алкоголя", red)
					return
				}
			}
			else if (id1 == 63) 
			{
				if (search_inv_player(playerid, 34, 2) == 0) 
				{
					sendMessage(playerid, "[ERROR] Вы не водитель мусоровоза", red)
					return
				}
			}
			else if (id1 == 54) 
			{
				if (search_inv_player(playerid, 34, 3) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не инкассатор", red)
					return
				}
			}
			else if (id1 == 80) 
			{
				if (search_inv_player(playerid, 34, 10) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не перевозчик оружия", red)
					return
				}
			}
			else if (id1 == 83)
			{
				if (search_inv_player(playerid, 34, 6) == 0) 
				{
					sendMessage(playerid, "[ERROR] Вы не дальнобойщик", red)
					return
				}
				else if (search_inv_player(playerid, 85, search_inv_player_2_parameter(playerid, 85)) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не работаете на рыбзаводе", red)
					return
				}
				else if (!cow_farms(playerid, "load", count2, 0))
				{
					return
				}
			}
			else if (id1 == 82)
			{
				if (search_inv_player(playerid, 34, 6) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не дальнобойщик", red)
					return
				}
				else if (search_inv_player(playerid, 85, search_inv_player_2_parameter(playerid, 85)) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не работаете на рыбзаводе", red)
					return
				}
			}
			else if (id1 == 90)
			{
				if (search_inv_player(playerid, 34, 11) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не развозчик угля", red)
					return
				}
				else if (pogoda)
				{
					sendMessage(playerid, "[ERROR] Работа доступна зимой", red)
					return
				}
			}


			inv_car_empty(playerid, id1, id2, load_value)

			sendMessage(playerid, "Вы загрузили в т/с "+info_png[id1][0]+" за "+id2+"$", svetlo_zolotoy)
				
			if (id1 == 24) 
			{
				sendMessage(playerid, "[TIPS] Езжайте в порт или в любой бизнес, чтобы разгрузиться", color_tips)
			}
			else if (id1 == 61) 
			{
				sendMessage(playerid, "[TIPS] Езжайте в порт, чтобы разгрузиться", color_tips)
			}
			else if (id1 == 82) 
			{
				sendMessage(playerid, "[TIPS] Езжайте на рыбзавод, чтобы разгрузиться", color_tips)
			}
			else if (id1 == 83) 
			{
				sendMessage(playerid, "[TIPS] Езжайте в порт, чтобы разгрузиться", color_tips)
			}
			else if (id1 == 87) 
			{
				sendMessage(playerid, "[TIPS] Езжайте на стройплощадку в Хилвуд, чтобы разгрузиться", color_tips)
			}
			else if (id1 == 90)
			{
				sendMessage(playerid, "[TIPS] Езжайте на место, чтобы разгрузиться", color_tips)
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Вы не в т/с", red)
		}
	}
}
addEventHandler ( "event_give_subject", give_subject )

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
						sendMessage(playerid, "[ERROR] Нужен только "+info_png[24][0], red)
						return
					}

					if (v["warehouse"] >= max_business) 
					{
						sendMessage(playerid, "[ERROR] Склад полон", red)
						return
					}

					money = count*sic2p

					if (v["money"] < money) 
					{
						sendMessage(playerid, "[ERROR] Недостаточно средств на балансе бизнеса", red)
						return
					}

					inv_car_delet(playerid, id, sic2p, true, true, true)

					sqlite3( "UPDATE business_db SET warehouse = warehouse + '"+count+"', money = money - '"+money+"' WHERE number = '"+v["number"]+"'")

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

					sendMessage(playerid, "Вы разгрузили из т/с "+info_png[id][0]+" "+count+" шт за "+money+"$", green)

					return
				}
			}

			foreach (k, v in down_car_subject) 
			{
				if (isPointInCircle3D(x,y,z, v[0],v[1],v[2], v[3]))//--места разгрузки
				{
					if (!cow_farms(playerid, "unload", count, sic2p) && !cow_farms(playerid, "unload_prod", count, sic2p))
					{
						inv_car_delet(playerid, id, sic2p, true, true, true)

						money = count*sic2p

						inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )

						sendMessage(playerid, "Вы разгрузили из т/с "+info_png[id][0]+" "+count+" шт за "+money+"$", green)

						return
					}
				}
			}
		}
		else 
		{
			//sendMessage(playerid, "[ERROR] Багажник пуст", red)
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не в т/с", red)
	}
}

function inv_server_load (playerid, value, id3, id1, id2, tabpanel)//изменение(сохранение) инв-ря на сервере
{	
	local playername = getPlayerName(playerid)
	local plate = tabpanel
	local h = tabpanel
	local b = tabpanel
	local id1 = id1.tointeger()
	local id2 = id2.tointeger()

	if (value == "player")
	{
		array_player_1[playerid][id3] = id1
		array_player_2[playerid][id3] = id2

		if(id3 < max_inv)
		{
			setPlayerColour_fun(playerid)
			
			triggerClientEvent( playerid, "event_inv_load", value, id3, array_player_1[playerid][id3].tofloat(), array_player_2[playerid][id3].tofloat() )
		}

		sqlite3( "UPDATE account SET inventory = '"+save_inv(playerid, "player")+"' WHERE name = '"+playername+"'")
	}
	else if (value == "car")
	{
		array_car_1[plate][id3] = id1
		array_car_2[plate][id3] = id2

		triggerClientEvent( playerid, "event_inv_load", value, id3, array_car_1[plate][id3].tofloat(), array_car_2[plate][id3].tofloat() )

		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			sqlite3( "UPDATE car_db SET inventory = '"+save_inv(plate, "car")+"' WHERE number = '"+plate+"'")
		}
	}
	else if (value == "house")
	{
		array_house_1[h][id3] = id1
		array_house_2[h][id3] = id2

		triggerClientEvent( playerid, "event_inv_load", value, id3, array_house_1[h][id3].tofloat(), array_house_2[h][id3].tofloat() )

		sqlite3( "UPDATE house_db SET inventory = '"+save_inv(h, "house")+"' WHERE number = '"+h+"'")
	}
	else if (value == "box")
	{
		array_box_1[b][id3] = id1
		array_box_2[b][id3] = id2

		triggerClientEvent( playerid, "event_inv_load", value, id3, array_box_1[b][id3].tofloat(), array_box_2[b][id3].tofloat() )

		sqlite3( "UPDATE box_db SET inventory = '"+save_inv(b, "box")+"' WHERE number = '"+b+"'")
	}
}
addEventHandler( "event_inv_server_load", inv_server_load )

function use_inv (playerid, value, id3, id_1, id_2 )//--использование предметов
{
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle(playerid)
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local id1 = id_1.tointeger()
	local id2 = id_2.tointeger()

	if (value == "player")
	{
		//-----------------------------------------------------------------------------------------
		if (id1 == 3 || id1 == 7 || id1 == 8)//--сигареты
		{
			local satiety_plus = 5

			if (getplayerhealth(playerid) == max_heal)
			{
				sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
				return
			}

			id2 = id2 - 1

			if (id1 == 3)
			{
				local hp = max_heal*0.05
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)
			}
			else if (id1 == 7)
			{
				local hp = max_heal*0.10
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)
			}
			else if (id1 == 8)
			{
				local hp = max_heal*0.15
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)
			}

			if (satiety[playerid]+satiety_plus <= max_satiety)
			{
				satiety[playerid] = satiety[playerid]+satiety_plus
				sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
			}

			me_chat(playerid, playername+" выкурил(а) сигарету")
		}
		else if (id1 == 4)//--аптечка
		{
			if (getplayerhealth(playerid) == max_heal)
			{
				sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
				return
			}

			id2 = id2 - 1

			setplayerhealth(playerid, max_heal)
			sendMessage(playerid, "+"+max_heal+" хп", yellow)

			me_chat(playerid, playername+" использовал(а) аптечку")
		}
		else if (id1 == 20)//--нарко
		{
			local satiety_plus = 20
			local sleep_plus = 20
			local drugs_plus = 1

			if (getplayerhealth(playerid) == max_heal)
			{
				sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
				return
			}
			else if (drugs[playerid]+drugs_plus > max_drugs)
			{
				sendMessage(playerid, "[ERROR] У вас сильная наркозависимость", red)
				return
			}

			id2 = id2 - 1

			local hp = max_heal*0.50
			setplayerhealth(playerid, getplayerhealth(playerid)+hp)
			sendMessage(playerid, "+"+hp+" хп",  yellow)

			drugs[playerid] = drugs[playerid]+drugs_plus
			sendMessage(playerid, "+"+drugs_plus+" ед. наркозависимости",  yellow)

			if (satiety[playerid]+satiety_plus <= max_satiety)
			{
				satiety[playerid] = satiety[playerid]+satiety_plus
				sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
			}

			if (sleep[playerid]+sleep_plus <= max_sleep)
			{
				sleep[playerid] = sleep[playerid]+sleep_plus
				sendMessage(playerid, "+"+sleep_plus+" ед. сна", yellow)
			}

			me_chat(playerid, playername+" употребил(а) наркотики")
		}
		else if (id1 == 21 || id1 == 22) //--пиво
		{
			local alcohol_plus = 10.0
			local hygiene_minys = 5

			if (getplayerhealth(playerid) == max_heal)
			{
				sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
				return
			}
			else if (alcohol[playerid]+alcohol_plus > max_alcohol)
			{
				sendMessage(playerid, "[ERROR] Вы сильно пьяны", red)
				return
			}

			id2 = id2 - 1

			if (id1 == 21)
			{
				local satiety_plus = 10
				local hp = max_heal*0.20
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)

				if (satiety[playerid]+satiety_plus <= max_satiety)
				{
					satiety[playerid] = satiety[playerid]+satiety_plus
					sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				}
			}
			else if (id1 == 22)
			{
				local satiety_plus = 5
				local hp = max_heal*0.25
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)

				if (satiety[playerid]+satiety_plus <= max_satiety)
				{
					satiety[playerid] = satiety[playerid]+satiety_plus
					sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				}
			}

			alcohol[playerid] = alcohol[playerid]+alcohol_plus
			sendMessage(playerid, "+"+(alcohol_plus/100.0)+" промилле", yellow)

			if (hygiene[playerid]-hygiene_minys >= 0)
			{
				hygiene[playerid] = hygiene[playerid]-hygiene_minys
				sendMessage(playerid, "-"+hygiene_minys+" ед. чистоплотности", yellow)
			}

			me_chat(playerid, playername+" выпил(а) "+info_png[id1][0])
		}
		else if (id1 == 72 || id1 == 31)//виски,водка
		{
			if (id1 == 72)
			{
				local alcohol_plus = 100.0
				local hygiene_minys = 10

				if (getplayerhealth(playerid) == max_heal)
				{
					sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
					return
				}
				else if (alcohol[playerid]+alcohol_plus > max_alcohol)
				{
					sendMessage(playerid, "[ERROR] Вы сильно пьяны", red)
					return
				}

				id2 = id2 - 1

				local satiety_plus = 10
				local hp = max_heal*0.50
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)

				if (satiety[playerid]+satiety_plus <= max_satiety)
				{
					satiety[playerid] = satiety[playerid]+satiety_plus
					sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				}

				alcohol[playerid] = alcohol[playerid]+alcohol_plus
				sendMessage(playerid, "+"+(alcohol_plus/100.0)+" промилле", yellow)

				if (hygiene[playerid]-hygiene_minys >= 0)
				{
					hygiene[playerid] = hygiene[playerid]-hygiene_minys
					sendMessage(playerid, "-"+hygiene_minys+" ед. чистоплотности", yellow)
				}

				me_chat(playerid, playername+" выпил(а) "+info_png[id1][0])
			}
			else if (id1 == 31)
			{
				local alcohol_plus = 50.0
				local hygiene_minys = 10

				if (getplayerhealth(playerid) == max_heal)
				{
					sendMessage(playerid, "[ERROR] У вас полное здоровье", red)
					return
				}
				else if (alcohol[playerid]+alcohol_plus > max_alcohol)
				{
					sendMessage(playerid, "[ERROR] Вы сильно пьяны", red)
					return
				}

				id2 = id2 - 1

				local satiety_plus = 10
				local hp = max_heal*0.40
				setplayerhealth(playerid, getplayerhealth(playerid)+hp)
				sendMessage(playerid, "+"+hp+" хп", yellow)

				if (satiety[playerid]+satiety_plus <= max_satiety)
				{
					satiety[playerid] = satiety[playerid]+satiety_plus
					sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				}

				alcohol[playerid] = alcohol[playerid]+alcohol_plus
				sendMessage(playerid, "+"+(alcohol_plus/100.0)+" промилле", yellow)

				if (hygiene[playerid]-hygiene_minys >= 0)
				{
					hygiene[playerid] = hygiene[playerid]-hygiene_minys
					sendMessage(playerid, "-"+hygiene_minys+" ед. чистоплотности", yellow)
				}

				me_chat(playerid, playername+" выпил(а) "+info_png[id1][0])
			}
		}
		else if (id1 == 42 || id1 == 43)//--бургер, пицца
		{
			id2 = id2 - 1

			if (id1 == 42)
			{
				local satiety_plus = 50

				if (satiety[playerid]+satiety_plus > max_satiety)
				{
					sendMessage(playerid, "[ERROR] Вы не голодны", red)
					return
				}

				satiety[playerid] = satiety[playerid]+satiety_plus
				sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				me_chat(playerid, playername+" съел(а) "+info_png[id1][0])
			}
			else if (id1 == 43)
			{
				local satiety_plus = 25

				if (satiety[playerid]+satiety_plus > max_satiety)
				{
					sendMessage(playerid, "[ERROR] Вы не голодны", red)
					return
				}

				satiety[playerid] = satiety[playerid]+satiety_plus
				sendMessage(playerid, "+"+satiety_plus+" ед. сытости", yellow)
				me_chat(playerid, playername+" съел(а) "+info_png[id1][0])
			}
		}
		else if (id1 == 44 || id1 == 45)//--мыло, пижама
		{
			if (isPlayerInVehicle(playerid))
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}
			
			if (id1 == 44)
			{
				local sleep_hygiene_plus = 50

				if (hygiene[playerid]+sleep_hygiene_plus > max_hygiene)
				{
					sendMessage(playerid, "[ERROR] Вы чисты", red)
					return
				}

				if (enter_house[playerid][0] == 1)
				{
					id2 = id2 - 1
					hygiene[playerid] = hygiene[playerid]+sleep_hygiene_plus
					sendMessage(playerid, "+"+sleep_hygiene_plus+" ед. чистоплотности", yellow)
					me_chat(playerid, playername+" помылся(ась)")
				}
				else if (enter_job[playerid] == 1)
				{
					if (player_hotel(playerid, 44))
					{
						id2 = id2 - 1
					}
					else 
					{
						return
					}
				}
				else 
				{
					sendMessage(playerid, "[ERROR] Вы не в доме и не в отеле", red)
					return
				}
			}
			else if (id1 == 45)
			{
				local sleep_hygiene_plus = 50

				if (sleep[playerid]+sleep_hygiene_plus > max_sleep)
				{
					sendMessage(playerid, "[ERROR] Вы бодры", red)
					return
				}

				if (enter_house[playerid][0] == 1)
				{
					id2 = id2 - 1
					sleep[playerid] = sleep[playerid]+sleep_hygiene_plus
					sendMessage(playerid, "+"+sleep_hygiene_plus+" ед. сна", yellow)
					me_chat(playerid, playername+" вздремнул(а)")
				}
				else if (enter_job[playerid] == 1)
				{
					if (player_hotel(playerid, 45))
					{
						id2 = id2 - 1
					}
					else 
					{
						return
					}
				}
				else 
				{
					sendMessage(playerid, "[ERROR] Вы не в доме и не в отеле", red)
					return
				}
			}
		}
		else if (id1 == 26)//--лекарство от наркозависимости
		{
			id2 = id2 - 1

			local drugs_minys = 10

			if (drugs[playerid]-drugs_minys < 0)
			{
				sendMessage(playerid, "[ERROR] У вас нет наркозависимости", red)
				return
			}

			drugs[playerid] = drugs[playerid]-drugs_minys
			sendMessage(playerid, "-"+drugs_minys+" ед. наркозависимости", yellow)
			me_chat(playerid, playername+" выпил(а) "+info_png[id1][0])
		}
		else if (id1 == 64)//--антипохмелин
		{
			id2 = id2 - 1

			local alcohol_minys = 50.0

			if (alcohol[playerid]-alcohol_minys < 0)
			{
				sendMessage(playerid, "[ERROR] Вы не пьяны", red)
				return
			}

			alcohol[playerid] = alcohol[playerid]-alcohol_minys
			sendMessage(playerid, "-"+(alcohol_minys/100.0)+" промилле", yellow)
			me_chat(playerid, playername+" выпил(а) "+info_png[id1][0])
		}
		//-----------------------------------------------------------------------------------------
		else if (id1 == 9 || id1 == 12 || id1 == 13 || id1 == 14 || id1 == 15 || id1 == 16 || id1 == 17 || id1 == 18 || id1 == 19)//оружие
		{
			givePlayerWeapon(playerid, weapon[id1][1], id2)
			me_chat(playerid, playername+" взял(а) в руку "+weapon[id1][0])
			id2 = 0
		}
		else if (id1 == 5)//канистра
		{
			if (isPlayerInVehicle(playerid))
			{
				local plate = getVehiclePlateText ( vehicleid )

				if (getSpeed(vehicleid) < 5)
				{
					if (fuel[plate]+id2 <= max_fuel)
					{
						fuel[plate] <- fuel[plate]+id2
						me_chat(playerid, playername+" заправил(а) т/с из канистры")
						id2 = 0

						sqlite3( "UPDATE car_db SET fuel = '"+fuel[plate]+"' WHERE number = '"+plate+"'")

						local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
						if (result[1]["COUNT()"] == 1)
						{
							local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )
							if (result[1]["nalog"] != 0 && search_inv_player(playerid, 6, plate.tointeger()) != 0 && search_inv_player(playerid, 2, 1) != 0 && sead[playerid] == 0)
							{
								dviglo[plate] <- 1
							}
						}
					}
					else
					{
						sendMessage(playerid, "[ERROR] Максимальная вместимость бака "+max_fuel+" литров", red)
						return
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red)
					return
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 6)//--ключ авто
		{
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+id2+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				result = sqlite3( "SELECT * FROM car_db WHERE number = '"+id2+"'" )
				
				foreach (k, v in getVehicles()) 
				{
					local pos = getVehiclePosition(v)

					if (isPointInCircle3D(x,y,z, pos[0], pos[1], pos[2], 10.0) && getVehicleModel(v) == 27 && getVehiclePlateText(v).tointeger() == id2 )
					{
						putPlayerInVehicle( playerid, v, 0 )
						sendMessage(playerid, "[ERROR] Перезайдите в т/с", red)
						car_27[playerid] = true
						return
					}
				}
			}

			me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2)

			return
		}
		else if (id1 == 10 || id1 == 94) //--документы копа, паспорт
		{	
			local id = getPlayerName(id2-1)
			if (id)
			{
				me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" на имя "+id)
			}
			else 
			{
				me_chat(playerid, playername+" показал(а) чужой "+info_png[id1][0])
			}
			return
		}
		else if (id1 == 11)//--газета
		{
			if (pogoda)
			{
				if (pogoda_string_true[1] == 1)
				{
					sendMessage(playerid, "[ПОГОДА] Завтра обещают солнечный день", yellow)
				}
				else if (pogoda_string_true[1] == 2) 
				{
					sendMessage(playerid, "[ПОГОДА] Завтра обещают дождливый день", yellow)
				}
				else if (pogoda_string_true[1] == 3) 
				{
					sendMessage(playerid, "[ПОГОДА] Завтра обещают туманный день", yellow)
				}
			}
			else 
			{
				if (pogoda_string_false[1] == 1)
				{
					sendMessage(playerid, "[ПОГОДА] Завтра обещают солнечный день", yellow)
				}
				else if (pogoda_string_false[1] == 2) 
				{
					sendMessage(playerid, "[ПОГОДА] Завтра обещают туманный день", yellow)
				}
			}

			me_chat(playerid, playername+" прочитал(а) газету")
			return
		}
		else if (id1 == 23)//--ремонтный набор
		{
			if (isPlayerInVehicle(playerid))
			{
				if (getSpeed(vehicleid) > 5)
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red)
					return
				}

				id2 = id2 - 1

				repairVehicle ( vehicleid )

				me_chat(playerid, playername+" починил(а) т/с")
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 25)//--ключ дома
		{
			local h = id2
			local result = sqlite3( "SELECT COUNT() FROM house_db WHERE number = '"+h+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				local result = sqlite3( "SELECT * FROM house_db WHERE number = '"+h+"'" )
				if (isPointInCircle3D(result[1]["x"],result[1]["y"],result[1]["z"], x,y,z, house_bussiness_radius))
				{
					local house_door = result[1]["door"]

					if (house_door == 0)
					{
						house_door = 1
						me_chat(playerid, playername+" открыл(а) дверь дома")
					}
					else
					{
						house_door = 0
						me_chat(playerid, playername+" закрыл(а) дверь дома")
					}

					sqlite3( "UPDATE house_db SET door = '"+house_door+"' WHERE number = '"+h+"'")
				}
				else 
				{
					me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2)
				}
			}
			return
		}
		else if (id1 == 27)//--одежда
		{	
			if (!isPlayerInVehicle(playerid))
			{
				local skin = getPlayerModel(playerid)

				setPlayerModel(playerid, id2)

				sqlite3( "UPDATE account SET skin = '"+id2+"' WHERE name = '"+playername+"'")

				id2 = skin

				me_chat(playerid, playername+" переоделся(ась)")
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}
		}
		else if(id1 == 29)//оп
		{
			addcrimes(playerid, id2)
			me_chat(playerid, playername+" прочитал(а) "+info_png[id1][0])
			id2 = 0
		}
		else if (id1 == 30)//лотерея
		{
			if (loto[2])
			{
				me_chat(playerid, playername+" потер(ла) лотерейный билет")

				if (loto[0] == id2)
				{
					local randomize = random(zp_loto/2,zp_loto)
					loto[2] = false

					inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )
					sendMessageAll(playerid, "[НОВОСТИ] Лотерея объявляется закрытой, победителем стал "+playername+", выигрыш составил "+randomize+"$", green)
				}

				id2 = 0
			}
			else
			{
				sendMessage(playerid, "[ERROR] Лотерея закончилась", red)
				return
			}
		}
		else if(id1 == 32)//документы дома
		{
			local result = sqlite3( "SELECT COUNT() FROM house_db WHERE number = '"+id2+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				local result = sqlite3( "SELECT * FROM house_db WHERE number = '"+id2+"'" )

				me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2)

				do_chat(playerid, "Налог дома оплачен на "+result[1]["nalog"]+" дней - "+playername)
			}
			return
		}
		else if(id1 == 33)//документы тс
		{
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+id2+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				result = sqlite3( "SELECT * FROM car_db WHERE number = '"+id2+"'" )

				me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2)

				do_chat(playerid, "Налог т/с оплачен на "+result[1]["nalog"]+" дней - "+playername)
				do_chat(playerid, "Установлен "+result[1]["tune"]+" уровень тюнинга - "+playername)
			}
			return
		}
		else if (id1 == 34)//лицензии
		{
			if(id2 == 1)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 1

					me_chat(playerid, playername+" вышел(ла) на работу Таксист")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 2)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 2

					me_chat(playerid, playername+" вышел(ла) на работу Мусоровозчик")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 3)
			{
				if (crimes[playerid] != 0)
				{
					sendMessage(playerid, "[ERROR] У вас плохая репутация", red)
					return
				}

				if (job[playerid] == 0)
				{
					job[playerid] = 3

					me_chat(playerid, playername+" вышел(ла) на работу Инкассатор")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 4)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 4

					me_chat(playerid, playername+" вышел(ла) на работу Связист")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 5)
			{
				if (crimes[playerid] < crimes_giuseppe)
				{
					sendMessage(playerid, "[ERROR] Нужно иметь "+crimes_giuseppe+" преступлений", red)
					return
				}

				if (job[playerid] == 0)
				{
					job[playerid] = 5

					me_chat(playerid, playername+" вышел(ла) на работу Угонщик")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 7)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 7

					me_chat(playerid, playername+" вышел(ла) на работу Молочник")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 8)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 8

					me_chat(playerid, playername+" вышел(ла) на работу Развозчик алкоголя")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 9)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 9

					me_chat(playerid, playername+" вышел(ла) на работу Водитель автобуса")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 10)
			{
				if (crimes[playerid] != 0)
				{
					sendMessage(playerid, "[ERROR] У вас плохая репутация", red)
					return
				}

				if (job[playerid] == 0)
				{
					job[playerid] = 10

					me_chat(playerid, playername+" вышел(ла) на работу Перевозчик оружия")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 11)
			{
				if (job[playerid] == 0)
				{
					job[playerid] = 11

					me_chat(playerid, playername+" вышел(ла) на работу Развозчик угля")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if(id2 == 12)
			{
				if (pogoda)
				{
					sendMessage(playerid, "[ERROR] Работа доступна зимой", red)
					return
				}

				if (job[playerid] == 0)
				{
					job[playerid] = 12

					me_chat(playerid, playername+" вышел(ла) на работу Уборщик снега ЭБ")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}
			else if (id2 == 13)
			{
				if (crimes[playerid] != 0)
				{
					sendMessage(playerid, "[ERROR] У вас плохая репутация", red)
					return
				}
				else if (getPlayerModel(playerid) != 76)
				{
					sendMessage(playerid, "[ERROR] Вы должны быть в одежде 76", red)
					return
				}
				else if (search_inv_player_2_parameter(playerid, 10) == 0)
				{
					sendMessage(playerid, "[ERROR] Вы не детектив полиции", red)
					return
				}

				if (job[playerid] == 0)
				{
					job[playerid] = 13

					me_chat(playerid, playername+" вышел(ла) на работу Транспортный детектив")
				}
				else
				{
					job[playerid] = 0

					me_chat(playerid, playername+" закончил(а) работу")
				}
			}

			if(job[playerid] == 0)
			{
				job_0(playerid)
				car_theft_fun(playerid, false)
			}
			else if (job[playerid] != 0)
			{
				job_timer2(playerid)
			}

			return
		}
		else if (id1 == 35)//--лом
		{
			local count = 0
			local pos = player_position( playerid )
			local x1 = pos[0]
			local y1 = pos[1]

			if (isPlayerInVehicle(playerid))
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}

			if (hour >= 0 && hour <= 5)
			{
				foreach (k, v in sqlite3( "SELECT * FROM house_db" ))
				{
					if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && robbery_player[playerid] == 0)
					{
						local time_rob = 1//--время для ограбления

						id2 = id2 - 1

						count = count+1

						robbery_player[playerid] = 1

						me_chat(playerid, playername+" взломал(а) дверь")

						sendMessage(playerid, "Вы начали взлом", yellow)
						sendMessage(playerid, "[TIPS] Не покидайте место ограбления "+time_rob+" мин", color_tips)

						police_chat(playerid, "[ДИСПЕТЧЕР] Ограбление "+v["number"]+" дома, координаты [X  "+x1+", Y  "+y1+"], подозреваемый "+playername)

						robbery_timer[playerid] = timer(robbery, (time_rob*10000), 1, playerid, zakon_robbery_crimes, 1000, v["x"],v["y"],v["z"], house_bussiness_radius, "house - "+v["number"])

						triggerClientEvent( playerid, "createHudTimer", (time_rob*10).tofloat() )

						break
					}
				}

				foreach (k, v in sqlite3( "SELECT * FROM business_db" ))
				{
					if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius) && robbery_player[playerid] == 0)
					{
						local time_rob = 1//--время для ограбления

						id2 = id2 - 1

						count = count+1

						robbery_player[playerid] = 1

						me_chat(playerid, playername+" взломал(а) дверь")

						sendMessage(playerid, "Вы начали взлом", yellow)
						sendMessage(playerid, "[TIPS] Не покидайте место ограбления "+time_rob+" мин", color_tips)

						police_chat(playerid, "[ДИСПЕТЧЕР] Ограбление "+v["number"]+" бизнеса, координаты [X  "+x1+", Y  "+y1+"], подозреваемый "+playername)

						robbery_timer[playerid] = timer(robbery, (time_rob*10000), 1, playerid, zakon_robbery_crimes, 1000, v["x"],v["y"],v["z"], house_bussiness_radius, "business - "+v["number"])

						triggerClientEvent( playerid, "createHudTimer", (time_rob*10).tofloat() )

						break
					}
				}

				if (isPointInCircle3D(x,y,z, interior_job[4][2],interior_job[4][3],interior_job[4][4], interior_job[4][7]) && robbery_player[playerid] == 0)
				{
					local time_rob = 1//--время для ограбления

					id2 = id2 - 1

					count = count+1

					robbery_player[playerid] = 1

					me_chat(playerid, playername+" взломал(а) дверь")

					sendMessage(playerid, "Вы начали взлом", yellow)
					sendMessage(playerid, "[TIPS] Не покидайте место ограбления "+time_rob+" мин", color_tips)

					police_chat(playerid, "[ДИСПЕТЧЕР] Ограбление Ювелирки в Аркадии, подозреваемый "+playername)

					robbery_timer[playerid] = timer(robbery, (time_rob*10000), 1, playerid, zakon_robbery_crimes, 2000, interior_job[4][2],interior_job[4][3],interior_job[4][4], interior_job[4][7], "Arcade")

					triggerClientEvent( playerid, "createHudTimer", (time_rob*10).tofloat() )
				}

				if (count == 0)
				{
					sendMessage(playerid, "[ERROR] Нужно быть около дома, бизнеса или ювелирки; Вы уже начали ограбление", red)
					return
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Ограбление доступно с 0 до 6 часов игрового времени", red)
				return
			}
		}
		else if (id1 == 46)//--алкостестер
		{
			id2 = 0
			local alcohol_test = alcohol[playerid]/100.0
			
			me_chat(playerid, playername+" смочил(а) слюной палочку")
			do_chat(playerid, info_png[id1][0]+" показал "+alcohol_test+" промилле - "+playername)

			if (alcohol_test >= zakon_alcohol)
			{
				addcrimes(playerid, zakon_alcohol_crimes)
			}
		}
		else if (id1 == 47)//--наркостестер
		{
			id2 = 0
			local drugs_test = drugs[playerid]
			
			me_chat(playerid, playername+" смочил(а) слюной палочку")
			do_chat(playerid, info_png[id1][0]+" показал "+drugs_test+" процентов зависимости - "+playername)

			if (drugs_test >= zakon_drugs)
			{
				addcrimes(playerid, zakon_drugs_crimes)
			}
		}
		else if (id1 == 48)//--налог дома
		{
			local count = 0
			foreach (k, v in sqlite3( "SELECT * FROM house_db" ))
			{
				if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius))
				{
					sqlite3( "UPDATE house_db SET nalog = nalog + '"+id2+"' WHERE number = '"+v["number"]+"'")
					
					me_chat(playerid, playername+" использовал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1]+" и оплатил(а) "+v["number"]+" дом")

					id2 = 0
					count = 1
					break
				}
			}

			if (count == 0)
			{
				sendMessage(playerid, "[ERROR] Вы должны быть около дома", red)
				return
			}
		}
		else if (id1 == 49)//--налог бизнеса
		{
			local count = 0
			foreach (k, v in sqlite3( "SELECT * FROM business_db" ))
			{
				if (isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius))
				{
					sqlite3( "UPDATE business_db SET nalog = nalog + '"+id2+"' WHERE number = '"+v["number"]+"'")
					
					me_chat(playerid, playername+" использовал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1]+" и оплатил(а) "+v["number"]+" бизнес")

					id2 = 0
					count = 1
					break
				}
			}

			if (count == 0)
			{
				sendMessage(playerid, "[ERROR] Вы должны быть около бизнеса", red)
				return
			}
		}
		else if (id1 == 50)//--налог авто
		{
			if (isPlayerInVehicle(playerid))
			{
				local plate = getVehiclePlateText(vehicleid)
				local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
				if (result[1]["COUNT()"] == 1)
				{
					sqlite3( "UPDATE car_db SET nalog = nalog + '"+id2+"' WHERE number = '"+plate+"'")

					me_chat(playerid, playername+" использовал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1]+" и оплатил(а) "+plate+" авто")

					id2 = 0
				}
				else
				{
					sendMessage(playerid, "[ERROR] Т/с не найдено", red)
					return
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 52) //--gps навигатор
		{
			if (gps_device[playerid] == 0)
			{
				gps_device[playerid] = 1

				me_chat(playerid, playername+" достал(а) "+info_png[id1][0])
			}
			else
			{
				gps_device[playerid] = 0

				me_chat(playerid, playername+" убрал(а) "+info_png[id1][0])
			}
			return
		}
		else if (id1 == 54) //--инкассаторский сумка
		{
			local randomize = id2

			id2 = 0

			me_chat(playerid, playername+" открыл(а) "+info_png[id1][0])

			sendMessage(playerid, "Вы получили "+randomize+"$", green)

			addcrimes(playerid, zakon_54_crimes)

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )
		}
		else if (id1 == 65) //--двигло
		{
			if (isPlayerInVehicle(playerid))
			{
				if (getSpeed(vehicleid) > 5)
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red)
					return
				}

				local count = false
				foreach (i, v1 in no_use_wheel_and_engine)
				{
					if(getVehicleModel(vehicleid) == v1)
					{
						count = true
						break	
					}
				}

				foreach (i, v1 in car_cash_no)
				{
					if(getVehicleModel(vehicleid) == v1)
					{
						count = true
						break	
					}
				}

				if (count)
				{
					sendMessage(playerid, "[ERROR] На это т/с нельзя установить двигатель", red)
					return
				}
				
				local plate = getVehiclePlateText(vehicleid)

				setVehicleTuningTable(vehicleid, id2)

				sqlite3( "UPDATE car_db SET tune = '"+id2+"' WHERE number = '"+plate+"'")

				me_chat(playerid, playername+" установил(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])

				id2 = 0
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 67)//пропуск
		{
			if (isPlayerInVehicle(playerid))
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}

			if (isPointInCircle3D(x,y,z, 41.5553,1784.44,-17.8668, 0.5))
			{
				setPlayerPosition(playerid, 41.5922,1785.13,-17.8401)
			}
			else if (isPointInCircle3D(x,y,z, 41.5922,1785.13,-17.8401, 0.5))
			{
				setPlayerPosition(playerid, 41.5553,1784.44,-17.8668)
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы должны быть около ворот мясокомбината", red)
			}

			return
		}
		else if (id1 == 69)//--колеса
		{
			if (isPlayerInVehicle(playerid))
			{
				if (getSpeed(vehicleid) > 5)
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red)
					return
				}

				local count = false
				foreach (i, v1 in no_use_wheel_and_engine)
				{
					if(getVehicleModel(vehicleid) == v1)
					{
						count = true
						break	
					}
				}

				if (count)
				{
					sendMessage(playerid, "[ERROR] На это т/с нельзя установить колеса", red)
					return
				}
				
				local plate = getVehiclePlateText(vehicleid)
				local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )

				setVehicleWheelTexture(vehicleid, 0, id2)
				setVehicleWheelTexture(vehicleid, 1, id2)

				sqlite3( "UPDATE car_db SET wheel = '"+id2+"' WHERE number = '"+plate+"'")

				me_chat(playerid, playername+" установил(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])

				id2 = 0
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 70)//--краска
		{
			if (isPlayerInVehicle(playerid))
			{
				if (getSpeed(vehicleid) > 5)
				{
					sendMessage(playerid, "[ERROR] Остановите т/с", red)
					return
				}
				
				local plate = getVehiclePlateText(vehicleid)
				local color = fromRGB(color_table[id2][0], color_table[id2][1], color_table[id2][2])

				setVehicleColour(vehicleid, color_table[id2][0], color_table[id2][1], color_table[id2][2], color_table[id2][0], color_table[id2][1], color_table[id2][2])

				sqlite3( "UPDATE car_db SET car_rgb = '"+color+"' WHERE number = '"+plate+"'")

				me_chat(playerid, playername+" использовал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])

				id2 = 0
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 71) //--рем ящик
		{
			if(job[playerid] != 4)
			{
				sendMessage(playerid, "[ERROR] Вы не Связист", red)
				return
			}

			if(job_pos[playerid] == 0 || getPlayerModel(playerid) != 12 || job_call[playerid] != 1)
			{
				sendMessage(playerid, "[ERROR] Вы должны быть в одежде 12", red)
				return
			}

			if(isPlayerInVehicle(playerid))
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}

			if (isPointInCircle3D(x,y,z, job_pos[playerid][0],job_pos[playerid][1],job_pos[playerid][2], 5.0))
			{
				local randomize = random(zp_player_phone/2,zp_player_phone)

				inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )

				sendMessage(playerid, "Вы получили "+randomize+"$", green)
									
				job_call[playerid] = 0

				id2 = id2 - 1
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы должны быть около телефонной будки", red)
				return
			}
		}
		else if (id1 == 74)//--удочка
		{
			if (isPlayerInVehicle(playerid))
			{
				sendMessage(playerid, "[ERROR] Вы в т/с", red)
				return
			}
			
			if (isPointInCircle3D(x,y,z, interior_job[6][2],interior_job[6][3],interior_job[6][4], interior_job[6][7]))
			{
				local randomize = random(1,zp_player_fish)

				if ( inv_player_empty(playerid, 73, randomize) )
				{
					me_chat(playerid, playername+" поймал(а) "+info_png[73][0]+" "+randomize+" "+info_png[73][1])
					id2 = id2 - 1
				}
				else
				{
					sendMessage(playerid, "[ERROR] Инвентарь полон", red)
					return
				}
			}
			else 
			{
				sendMessage(playerid, "[ERROR] Вы должны быть около места ловли рыбы", red)
				return
			}
		}
		else if (id1 == 76)//динамит
		{
			local count = false
			foreach (k, vehicleid in getVehicles()) 
			{
				local posv = getVehiclePosition(vehicleid)
				if (isPointInCircle3D(x,y,z, posv[0],posv[1],posv[2], 5.0) && getVehicleModel(vehicleid) == 27)
				{
					timer(function( vehicleid )
					{
						explode_car(vehicleid)
					}, 5000, 1, vehicleid)

					me_chat(playerid, playername+" установил(а) "+info_png[id1][0])
					count = true
					id2 = id2 -1
					break

				}
			}

			if (!count)
			{
				sendMessage(playerid, "[ERROR] Рядом нет инкассаторской машины", red)
				return
			}
		}
		else if (id1 == 79) //--отмычка
		{
			if(isPlayerInVehicle(playerid))
			{
				if(job[playerid] == 5)
				{
					if(job_vehicleid[playerid][0] == vehicleid)
					{
						id2 = id2-1

						dviglo[getVehiclePlateText(vehicleid)] <- 1

						me_chat(playerid, playername+" использовал(а) "+info_png[id1][0])
					}
					else
					{
						sendMessage(playerid, "[ERROR] Это не тот т/с", red)
						return
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Вы не Угонщик", red)
					return
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] Вы не в т/с", red)
				return
			}
		}
		else if (id1 == 80)//--ящик с оружием
		{
			local array_weapon = [9,12,13,14,15,16,17,18,19]

			local randomize = random(0,array_weapon.len()-1)

			me_chat(playerid, playername+" открыл(а) "+info_png[id1][0])

			inv_player_delet(playerid, id1, id2, false, false)
			inv_player_empty(playerid, array_weapon[randomize], 25)

			addcrimes(playerid, zakon_80_crimes)

			return
		}
		else if (id1 == 84)//документы на рыбзавод
		{
			local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+id2+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+id2+"'" )
				local farms = [
					[result[1]["number"], "Зарплата", result[1]["price"]+"$"],
					[result[1]["number"], "Баланс", split(result[1]["money"].tostring(),".")[0]+"$"],
					[result[1]["number"], "Доход от продаж", result[1]["coef"]+" процентов"],
					[result[1]["number"], "Налог", result[1]["nalog"]+" дней"],
					[result[1]["number"], "Склад", result[1]["warehouse"]+" ящиков с рыбным филе"],
					[result[1]["number"], "Склад", result[1]["prod"]+" свежей рыбы"],
				]
					
				sendMessage(playerid, "====[ ИНФО "+id2+" РЫБЗАВОДА ]====", yellow)

				foreach (k, v in farms) {
					sendMessage(playerid, v[1]+" "+v[2], yellow)
				}
			}
			return
		}
		else if (id1 == 85)// лиц обр рыбы
		{
			if(getPlayerModel(playerid) != 133)
			{
				sendMessage(playerid, "[ERROR] Вы должны быть в одежде 133", red)
				return
			}

			local result = sqlite3( "SELECT COUNT() FROM seagift_db WHERE number = '"+id2+"'" )
			if (result[1]["COUNT()"] == 1)
			{
				result = sqlite3( "SELECT * FROM seagift_db WHERE number = '"+id2+"'" )
				local farms = [
					[result[1]["number"], "Зарплата", result[1]["price"]+"$"],
					[result[1]["number"], "Доход от продаж", result[1]["coef"]+" процентов"],
				]
					
				sendMessage(playerid, "====[ ИНФО "+id2+" РЫБЗАВОДА ]====", yellow)

				foreach (k, v in farms) {
					sendMessage(playerid, v[1]+" "+v[2], yellow)
				}
			}

			if (job[playerid] == 0)
			{
				job[playerid] = 6

				me_chat(playerid, playername+" вышел(ла) на работу Обработчик рыбы на "+id2+" рыбзаводе")
			}
			else
			{
				job[playerid] = 0

				car_theft_fun(playerid, false)

				me_chat(playerid, playername+" закончил(а) работу")
			}
			return
		}
		else if(id1 == 86)//ордер
		{
			me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+info_png[id1][id2+1])
			return
		}
		else if (id1 == 88) //чек
		{
			if (!isPointInCircle3D(myPos[0],myPos[1],myPos[2], interior_job[9][2],interior_job[9][3],interior_job[9][4], interior_job[9][7]))
			{
				sendMessage(playerid, "[ERROR] Вы не около банка", red)
				return
			}

			local randomize = id2

			id2 = 0

			me_chat(playerid, playername+" обналичил(а) "+info_png[id1][0]+" "+randomize+" "+info_png[id1][1])

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+randomize, playername )
		}
		else if(id1 == 91)//шляпа
		{
			local count = 0
			local count2 = 0
			do_chat(playerid, "на голове "+info_png[id1][0]+" "+name_mafia[id2][0]+" - "+playername)

			sendMessage(playerid, "====[ ПОД КОНТРОЛЕМ "+name_mafia[id2][0]+" ]====", yellow)

			foreach(k,v in guns_zone)
			{
				if(v[4] == id2)
				{
					count = count+1

					foreach (k1, v1 in sqlite3( "SELECT * FROM business_db" )) 
					{
						if(isPointInRectangle2D(v1["x"],v1["y"], v[0],v[1],v[2],v[3]))
						{
							count2 = count2+1
						}
					}
				}
			}

			sendMessage(playerid, "Территорий: "+count+", Доход: "+(count*money_guns_zone)+"$", yellow)
			sendMessage(playerid, "Бизнесов: "+count2+", Доход: "+(count2*money_guns_zone_business)+"$", yellow)
			return
		}
		else if (id1 == 92) //--адм
		{
			if (admin_tp[playerid][0] == 0)
			{
				admin_tp[playerid][0] = 1

				sendMessage(playerid, "перемещение ON", lyme)
			}
			else
			{
				admin_tp[playerid][0] = 0

				sendMessage(playerid, "перемещение OFF", lyme)
			}
			return
		}
		else 
		{
			me_chat(playerid, playername+" показал(а) "+info_png[id1][0]+" "+id2+" "+info_png[id1][1])
			return
		}

		//--------------------------------------------------------------------------------------------------------------------------------
		if (id2 == 0)
		{
			id1 = 0
			id2 = 0
		}

		inv_server_load( playerid, "player", id3, id1, id2, playername )
	}
}
addEventHandler( "event_use_inv", use_inv )

addCommandHandler ( "sellhouse",//--команда для риэлторов
function (playerid)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local house_count = 0
	local business_count = 0
	local job_count = 0

	if (logged[playerid] == 0)
	{
		return
	}

	if (search_inv_player(playerid, 38, 1) == 0)
	{
		sendMessage(playerid, "[ERROR] Вы не риэлтор", red)
		return
	}

	if(array_player_2[playerid][0] < zakon_price_house)
	{
		sendMessage(playerid, "[ERROR] Стоимость домов составляет "+zakon_price_house+"$", red)
		return
	}

	local result = sqlite3( "SELECT COUNT() FROM house_db" )
	local house_number = result[1]["COUNT()"]
	foreach (k, v in sqlite3( "SELECT * FROM house_db" )) 
	{
		if (!isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius*2))
		{
			house_count = house_count+1
		}
	}

	local result = sqlite3( "SELECT COUNT() FROM business_db" )
	local business_number = result[1]["COUNT()"]
	foreach (k, v in sqlite3( "SELECT * FROM business_db" )) 
	{
		if (!isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius*2))
		{
			business_count = business_count+1
		}
	}

	local job_number = interior_job.len()
	foreach (k, v in interior_job) 
	{
		if (!isPointInCircle3D(x,y,z, v[2],v[3],v[4], v[7]))
		{
			job_count = job_count+1
		}
	}

	if (business_count == business_number && house_count == house_number && job_count == job_number)
	{
		local dim = house_number+1

		if (inv_player_empty(playerid, 25, dim))
		{
			array_house_1[dim] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			array_house_2[dim] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

			foreach (playerid, v in getPlayers()) 
			{
				triggerClientEvent( playerid, "event_blip_create", x, y, 0,4, max_blip )
				triggerClientEvent( playerid, "event_blip_create", x, y, 6,0, max_blip )
				triggerClientEvent( playerid, "event_bussines_house_fun", dim, x, y, z, "house", house_bussiness_radius )
			}

			house_pos[dim] <- [x, y, z]
			taxi_pos[taxi_pos.len()] <- [x, y, z]
			milk_pos[milk_pos.len()] <- [x, y, z]

			sqlite3( "INSERT INTO house_db (number, door, nalog, x, y, z, inventory) VALUES ('"+dim+"', '0', '5', '"+x+"', '"+y+"', '"+z+"', '32:"+dim+",0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,0:0,')" )

			sendMessage(playerid, "Вы получили "+info_png[25][0]+" "+dim+" "+info_png[25][1], orange)

			inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-zakon_price_house, playername )
		}
		else
		{
			sendMessage(playerid, "[ERROR] Инвентарь полон", red)
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Рядом есть бизнес, дом или гос. здание", red)
	}
})

addCommandHandler ( "sellbusiness",//--команда для риэлторов
function (playerid, id)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local business_count = 0
	local house_count = 0
	local job_count = 0
	local id = id.tointeger()

	if (logged[playerid] == 0)
	{
		return
	}

	if(array_player_2[playerid][0] < zakon_price_business)
	{
		sendMessage(playerid, "[ERROR] Стоимость бизнеса составляет "+zakon_price_house+"$", red)
		return
	}

	if (id >= 0 && id <= interior_business.len()-1)
	{
		if (search_inv_player(playerid, 38, 1) == 0)
		{
			sendMessage(playerid, "[ERROR] Вы не риэлтор", red)
			return
		}

		local result = sqlite3( "SELECT COUNT() FROM house_db" )
		local house_number = result[1]["COUNT()"]
		foreach (k, v in sqlite3( "SELECT * FROM house_db" )) 
		{
			if (!isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius*2))
			{
				house_count = house_count+1
			}
		}

		local result = sqlite3( "SELECT COUNT() FROM business_db" )
		local business_number = result[1]["COUNT()"]
		foreach (k, v in sqlite3( "SELECT * FROM business_db" )) 
		{
			if (!isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius*2))
			{
				business_count = business_count+1
			}
		}

		local job_number = interior_job.len()
		foreach (k, v in interior_job) 
		{
			if (!isPointInCircle3D(x,y,z, v[2],v[3],v[4], v[7]))
			{
				job_count = job_count+1
			}
		}

		if (business_count == business_number && house_count == house_number && job_count == job_number)
		{
			local dim = business_number+1

			if (inv_player_empty(playerid, 36, dim))
			{	
				foreach (playerid, v in getPlayers()) 
				{
					triggerClientEvent( playerid, "event_blip_create", x, y, 0,4, max_blip )
					triggerClientEvent( playerid, "event_blip_create", x, y, interior_business[id][2],0, max_blip )
					triggerClientEvent( playerid, "event_bussines_house_fun", dim, x, y, z, "biz", house_bussiness_radius )
				}

				business_pos[dim] <- [x, y, z]

				sqlite3( "INSERT INTO business_db (number, type, price, money, nalog, warehouse, x, y, z, interior) VALUES ('"+dim+"', '"+interior_business[id][1]+"', '0', '0', '5', '0', '"+x+"', '"+y+"', '"+z+"', '"+id+"')" )

				sendMessage(playerid, "Вы получили "+info_png[36][0]+" "+dim+" "+info_png[36][1], orange)

				inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-zakon_price_business, playername )
			}
			else
			{
				sendMessage(playerid, "[ERROR] Инвентарь полон", red)
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Рядом есть бизнес, дом или гос. здание", red)
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] от 0 до "+(interior_business.len()-1), red)
	}
})

local Red = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]
local Black = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35]
local to1 = [1,4,7,10,13,16,19,22,25,28,31,34]
local to2 = [2,5,8,11,14,17,20,23,26,29,32,35]
local to3 = [3,6,9,12,15,18,21,24,27,30,33,36]

function roulette(playerid, randomize)
{
	foreach (k, v in Red) 
	{
		if (randomize == v)
		{
			sendMessage(playerid, "====[ РУЛЕТКА ]====", yellow)
			sendMessage(playerid, "Выпало "+randomize+" красное", yellow)
			return
		}
	}

	foreach (k, v in Black) 
	{
		if (randomize == v)
		{
			sendMessage(playerid, "====[ РУЛЕТКА ]====", yellow)
			sendMessage(playerid, "Выпало "+randomize+" черное", yellow)
			return
		}
	}

	if (randomize == 0)
	{
		sendMessage(playerid, "====[ РУЛЕТКА ]====", yellow)
		sendMessage(playerid, "Выпало ZERO", yellow)
		return
	}
}

function win_roulette( playerid, cash, ratio )
{
	local playername = getPlayerName ( playerid )
	local money = cash*ratio

	sendMessage(playerid, "Вы заработали "+money+"$ X"+ratio, green)

	inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+money, playername )
}

addCommandHandler ( "roulette",//--играть в рулетку
function (playerid, id, cash)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local id = id.tostring()
	local cash = cash.tointeger()
	local randomize = random(0,36)
	local roulette_game = ["красное","черное","четное","нечетное","1-18","19-36","1-12","13-24","25-36","3-1","3-2","3-3"]

	for (local i = 0; i < 36; i++)
	{
		roulette_game.push(i.tostring())
	}

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
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		return
	}

	if (isPointInCircle3D( x, y, z, interior_job[3][2],interior_job[3][3],interior_job[3][4], interior_job[3][7] ))
	{
		foreach (k, v in roulette_game)
		{
			if (v == id)
			{
				roulette(playerid, randomize)

				inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playername )

				if (id == "красное")
				{
					foreach (k, v in Red) 
					{
						if (randomize == v)
						{
							win_roulette(playerid, cash, 2)
							return
						}
					}
				}
				else if (id == "черное")
				{
					foreach (k, v in Black) 
					{
						if (randomize == v)
						{
							win_roulette(playerid, cash, 2)
							return
						}
					}
				}
				else if (id == "четное" && randomize%2 == 0)
				{
					win_roulette(playerid, cash, 2)
					return
				}
				else if (id == "нечетное" && randomize%2 == 1)
				{
					win_roulette(playerid, cash, 2)
					return
				}
				else if (id == "1-18" && randomize >= 1 && randomize <= 18)
				{
					win_roulette(playerid, cash, 2)
					return
				}
				else if (id == "19-36" && randomize >= 19 && randomize <= 36)
				{
					win_roulette(playerid, cash, 2)
					return
				}
				else if (id == "1-12" && randomize >= 1 && randomize <= 12)
				{
					win_roulette(playerid, cash, 3)
					return
				}
				else if (id == "13-24" && randomize >= 13 && randomize <= 24)
				{
					win_roulette(playerid, cash, 3)
					return
				}
				else if (id == "25-36" && randomize >= 25 && randomize <= 36)
				{
					win_roulette(playerid, cash, 3)
					return
				}
				else if( id == "3-1")
				{
					foreach (k, v in to1) 
					{
						if (randomize == v)
						{
							win_roulette(playerid, cash, 3)
							return
						}
					}
				}
				else if( id == "3-2")
				{
					foreach (k, v in to2) 
					{
						if (randomize == v)
						{
							win_roulette(playerid, cash, 3)
							return
						}
					}
				}
				else if( id == "3-3")
				{
					foreach (k, v in to3) 
					{
						if (randomize == v)
						{
							win_roulette(playerid, cash, 3)
							return
						}
					}
				}
				else
				{
					id = id.tointeger()

					if (id && id >= 0 && id <= 36)
					{
						if (randomize == id)
						{
							win_roulette(playerid, cash, 36)
							return
						}
					}
				}

				return
			}
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не в казино(кубок на карте)", red)
	}
})

addCommandHandler ( "fortune",
function (playerid, value, cash)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local cash = cash.tointeger()
	local value = value.tointeger()
	local wheel_fortune = [40,1,2,1,5,1,2,1,5,1,2,1,10,1,20,1,5,1,2,1,5,2,1,2,1,2,40,1,2,1,5,1,2,1,10,5,2,1,20,1,2,5,1,2,1,10,2,1,5,1,2,1,10,2]
	local randomize = random(0,wheel_fortune.len()-1)

	if (logged[playerid] == 0)
	{
		return
	}

	if (!isPointInCircle3D( x, y, z, interior_job[3][2],interior_job[3][3],interior_job[3][4], interior_job[3][7] ))
	{
		sendMessage(playerid, "[ERROR] Вы не в казино(кубок на карте)", red)
		return
	}

	if (cash < 1)
	{
		return
	}

	if (cash > array_player_2[playerid][0])
	{
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		return
	}

	if(value == 1 || value == 2 || value == 5 || value == 10 || value == 20 || value == 40)
	{
		sendMessage(playerid, "====[ КОЛЕСО УДАЧИ ]====", yellow)
		sendMessage(playerid, "Выпало "+wheel_fortune[randomize], yellow)

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playername )

		if (value == wheel_fortune[randomize])
		{
			win_roulette( playerid, cash, wheel_fortune[randomize] )
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Выберите число из предложенных 1,2,5,10,20,40", red)
	}
})

local blackjack_card = ["2:2", "3:3", "4:4", "5:5", "6:6", "7:7", "8:8", "9:9", "10:10", "В:10", "Д:10", "К:10", "Т:11"]
function blackjack (playerid, value, ...)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	if (logged[playerid] == 0)
	{
		return
	}
	else if (search_inv_player(playerid, 97, 1) == 0)
	{
		sendMessage(playerid, "[ERROR] У вас нет "+info_png[97][0], red)
		return
	}

	if (value == "invite")
	{
		local id = vargv[0].tointeger()
		local cash = vargv[1].tointeger()

		if (cash < 1)
		{
			return
		}

		if (cash > array_player_2[playerid][0])
		{
			sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
			return
		}
			
		if (logged[id] == 1)
		{
			local myPos1 = getPlayerPosition(id)
			local x1 = myPos1[0]
			local y1 = myPos1[1]
			local z1 = myPos1[2]
			if (isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
			{
				if (arrest[id] != 0)
				{
					sendMessage(playerid, "[ERROR] Игрок в тюрьме", red)
					return
				}
				else if (accept_player[id][0] == true)
				{
					sendMessage(playerid, "[ERROR] Игрок играет", red)
					return
				}
				else if (accept_player[playerid][0] == true)
				{
					sendMessage(playerid, "[ERROR] Вы играете", red)
					return
				}
				else if (cash > array_player_2[id][0])
				{
					sendMessage(playerid, "[ERROR] У игрока недостаточно средств", red)
					return
				}
				else if (playerid == id)
				{
					sendMessage(playerid, "[ERROR] На столько всё плохо?", red)
					return
				}

				accept_player[id] = [false, playerid, cash, false]
				accept_player[playerid] = [false, id, cash, false]

				me_chat(playerid, playername+" предложил(а) "+getPlayerName(id)+" сыграть в блэкджек на сумму "+cash+"$")
				sendMessage(id, "/accept yes - согласиться", yellow)
				sendMessage(id, "/accept no - отказаться", yellow)
			}
			else
			{
				sendMessage(playerid, "[ERROR] Игрок далеко", red)
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		}
	}
	else if (value == "take")
	{
		if (accept_player[playerid][0] == false)
		{
			sendMessage(playerid, "[ERROR] Вы не играете", red)
			return
		}
		else if (accept_player[playerid][3] == true)
		{
			sendMessage(playerid, "[ERROR] Вы готовы вскрыть карты", red)
			return
		}
		else if (game[playerid].len() == 5)
		{
			sendMessage(playerid, "[ERROR] У вас 5 карт", red)
			return
		}

		if (logged[accept_player[playerid][1]] == 1)
		{
			local myPos1 = getPlayerPosition(accept_player[playerid][1])
			local x1 = myPos1[0]
			local y1 = myPos1[1]
			local z1 = myPos1[2]
			if (!isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
			{
				sendMessage(playerid, "[ERROR] Игрок далеко", red)
				return
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Игрок далеко", red)
			return
		}

		me_chat(playerid, playername+" взял(а) карту")

		local randomize = random(0,blackjack_card.len()-1)
		local spl = blackjack_card[randomize]

		/*while (true) // --не оригинал
		{
			local count = 0
			foreach (k,v in game[playerid])
			{
				if (split(v, ":")[0] == split(spl, ":")[0])
				{
					count = count + 1
				}
			}

			if (count < 4)
			{
				break
			}
			else
			{
				randomize = random(0,blackjack_card.len()-1)
				spl = blackjack_card[randomize]
			}
		}*/

		game[playerid].push(blackjack_card[randomize])

		local point = 0
		foreach (k,v in game[playerid])
		{
			point = point+split(v, ":")[1].tointeger()
		}

		sendMessage(playerid, "Вы взяли "+split(spl, ":")[0]+", у вас "+point+" очков", yellow)

		if (point >= 21)
		{
			blackjack(playerid, "open")
		}
	}
	else if (value == "open")
	{
		if (accept_player[playerid][0] == false)
		{
			sendMessage(playerid, "[ERROR] Вы не играете", red)
			return
		}

		if (logged[accept_player[playerid][1]] == 1)
		{
			local myPos1 = getPlayerPosition(accept_player[playerid][1])
			local x1 = myPos1[0]
			local y1 = myPos1[1]
			local z1 = myPos1[2]
			if (!isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
			{
				sendMessage(playerid, "[ERROR] Игрок далеко", red)
				return
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Игрок далеко", red)
			return
		}

		if (accept_player[accept_player[playerid][1]][3] == false)
		{
			me_chat(playerid, playername+" готов(а) вскрыть карты")

			accept_player[playerid][3] = true
		}
		else
		{
			me_chat(playerid, playername+" вскрывает карты")

			accept_player[playerid][3] = true

			local point = 0
			foreach (k,v in game[playerid])
			{
				point = point+split(v, ":")[1].tointeger()
			}

			local point2 = 0
			foreach (k,v in game[accept_player[playerid][1]])
			{
				point2 = point2+split(v, ":")[1].tointeger()
			}

			do_chat(playerid, point+" очков - "+playername)
			do_chat(playerid, point2+" очков - "+getPlayerName(accept_player[playerid][1]))

			if (point == point2)
			{
			}
			else if (point < point2 && point2 <= 21 || point2 == 21)
			{
				inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-accept_player[playerid][2], playername )

				win_roulette(accept_player[playerid][1], accept_player[playerid][2], 1)
			}
			else if (point > point2 && point <= 21 || point == 21)
			{
				inv_server_load( accept_player[playerid][1], "player", 0, 1, array_player_2[accept_player[playerid][1]][0]-accept_player[playerid][2], playername )

				win_roulette(playerid, accept_player[playerid][2], 1)
			}
			else
			{
			}

			game[accept_player[playerid][1]] = []
			game[playerid] = []
			accept_player[accept_player[playerid][1]] = [false,false,false,false]
			accept_player[playerid] = [false,false,false,false]
		}
	}
}
addCommandHandler ( "blackjack", blackjack)

function accept (playerid, value)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	if (logged[playerid] == 0)
	{
		return
	}
	else if (accept_player[playerid][1] == false)
	{
		sendMessage(playerid, "[ERROR] У вас нет предложений", red)
		return
	}

	if (value == "yes")
	{
		if (accept_player[playerid][0] == true)
		{
			sendMessage(playerid, "[ERROR] Вы играете", red)
			return
		}

		accept_player[playerid][0] = true
		accept_player[accept_player[playerid][1]][0] = true

		me_chat(playerid, playername+" согласился(ась) с "+getPlayerName(accept_player[playerid][1])+" сыграть в блэкджек на сумму "+accept_player[playerid][2]+"$")

		sendMessage(playerid, "/blackjack take - взять карту", yellow)
		sendMessage(playerid, "/blackjack open - вскрыть карты", yellow)
	}
	else if (value == "no")
	{
		me_chat(playerid, playername+" отказался(ась) от предложения "+getPlayerName(accept_player[playerid][1])+" сыграть в блэкджек на сумму "+accept_player[playerid][2]+"$")

		game[playerid] = []
		accept_player[playerid] = [false,false,false,false]
	}
}
addCommandHandler ( "accept", accept)

addCommandHandler ( "slots",
function (playerid, cash)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local cash = cash.tointeger()
	local randomize1 = random(1,6)
	local randomize2 = random(1,6)
	local randomize3 = random(1,6)

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
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		return
	}

	if (isPointInCircle3D( x, y, z, interior_job[3][2],interior_job[3][3],interior_job[3][4], interior_job[3][7] ))
	{
		sendMessage(playerid, "====[ ОДНОРУКИЙ БАНДИТ ]====", yellow)
		sendMessage(playerid, "Выпало "+randomize1+" - "+randomize2+" - "+randomize3, yellow)

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playername )

		if(randomize1 == randomize2 && randomize1 == randomize3)
		{
			win_roulette( playerid, cash, 25 )
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не в казино(кубок на карте)", red)
	}
})

addCommandHandler ( "prison",//--команда для копов (посадить игрока в тюрьму)
function (playerid, id)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local cash = 100
	local id = id.tointeger()

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0)
	{
		return
	}
	else if(logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}

	if (search_inv_player_2_parameter(playerid, 10) == 0)
	{
		sendMessage(playerid, "[ERROR] Вы не полицейский", red)
		return
	}

	local myPos1 = getPlayerPosition(id)
	local x1 = myPos1[0]
	local y1 = myPos1[1]
	local z1 = myPos1[2]

	if (isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
	{
		if (crimes[id] == 0)
		{
			sendMessage(playerid, "[ERROR] Гражданин чист перед законом", red)
			return
		}

		if (arrest[id] != 0)
		{
			sendMessage(playerid, "[ERROR] Игрок в тюрьме", red)
			return
		}

		me_chat(playerid, playername+" посадил(а) "+getPlayerName ( id )+" в камеру на "+(crimes[id])+" мин")

		arrest[id] = 1

		sendMessage(playerid, "Вы получили премию "+(cash*(crimes[id]))+"$", green)

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]+(cash*(crimes[id])), playername )
	}
	else
	{
		sendMessage(playerid, "[ERROR] Игрок далеко", red)
	}
})

addCommandHandler ( "lawyer",//--выйти из тюряги за деньги
function (playerid, id)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local cash = 1000
	local id = id.tointeger()

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0)
	{
		return
	}
	else if(logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}

	local myPos1 = getPlayerPosition(id)
	local x1 = myPos1[0]
	local y1 = myPos1[1]
	local z1 = myPos1[2]

	if (isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
	{
		if (cash*crimes[id] > array_player_2[playerid][0])
		{
			sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
			return
		}

		if (arrest[id] == 0 || arrest[id] == 2)
		{
			sendMessage(playerid, "[ERROR] Игрок не в тюрьме", red)
			return
		}
		else if (crimes[id] == 1)
		{
			sendMessage(playerid, "[ERROR] Маленький срок заключения", red)
			return
		}

		me_chat(playerid, playername+" заплатил(а) залог за "+getPlayerName(id)+" в размере "+(cash*(crimes[id]))+"$")

		sendMessage(id, "Ждите освобождения", yellow)

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-(cash*(crimes[id])), playername )
	
		crimes[id] = 1
	}
	else
	{
		sendMessage(playerid, "[ERROR] Игрок далеко", red)
	}
})

addCommandHandler ( "search",//--команда для копов (обыскать игрока)
function (playerid, value, id)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local id = id.tointeger()
	local value = value.tostring()

	if (logged[playerid] == 0)
	{
		return
	}

	if (search_inv_player_2_parameter(playerid, 10) == 0)
	{
		sendMessage(playerid, "[ERROR] Вы не полицейский", red)
		return
	}

	if (value == "player")
	{
		if (id < 0 || id >= getMaxPlayers()) 
		{
			return
		}
		else if(logged[id] == 0)
		{
			sendMessage(playerid, "[ERROR] Такого игрока нет", red)
			return
		}

		local myPos1 = getPlayerPosition(id)
		local x1 = myPos1[0]
		local y1 = myPos1[1]
		local z1 = myPos1[2]

		if (isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
		{
			me_chat(playerid, playername+" обыскал(а) "+getPlayerName ( id ))

			search_inv_player_police( playerid, id )
		}
		else
		{
			sendMessage(playerid, "[ERROR] Игрок далеко", red)
		}
	}
	else if (value == "car")
	{
		foreach (k, vehicleid in getVehicles()) 
		{
			local plate = getVehiclePlateText(vehicleid)
			local myPos1 = getVehiclePosition(vehicleid)
			local x1 = myPos1[0]
			local y1 = myPos1[1]
			local z1 = myPos1[2]

			if (plate.tointeger() == id)
			{
				if (isPointInCircle3D(x,y,z, x1,y1,z1, 10.0))
				{
					me_chat(playerid, playername+" обыскал(а) т/с под номером "+id)

					search_inv_car_police( playerid, id.tostring() )
				}
				else
				{
					sendMessage(playerid, "[ERROR] Т/с далеко", red)
				}

				return
			}
		}

		sendMessage(playerid, "[ERROR] Т/с не найдено", red)
	}
	else if (value == "house")
	{
		foreach (k, v in sqlite3( "SELECT * FROM house_db" )) 
		{
			if (v["number"] == id)
			{
				if (isPointInCircle3D(x,y,z, v["x"],v["y"],v["z"], 10.0))
				{
					me_chat(playerid, playername+" обыскал(а) дом под номером "+id)

					search_inv_house_police( playerid, id )
				}
				else
				{
					sendMessage(playerid, "[ERROR] Дом далеко", red)
				}

				return
			}
		}

		sendMessage(playerid, "[ERROR] Дом не найден", red)
	}
})

addCommandHandler ( "enshot",//--выстрелить в двигатель
function (playerid, id)
{
	local playername = getPlayerName ( playerid )
	local id = id.tointeger()
	local myPos = getPlayerPosition(playerid)

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0)
	{
		return
	}

	if (search_inv_player_2_parameter(playerid, 10) != 0)
	{
		if (logged[id] == 0 || !isPlayerInVehicle(id))
		{
			sendMessage(playerid, "[ERROR] Игрок не в т/с", red)
			return
		}

		local Pos = getPlayerPosition(id)
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], 10.0))
		{
			if(try_chat_player(playerid, playername+" попытался(ась) выстрелить в двигатель"))
			{
				dviglo[getVehiclePlateText(getPlayerVehicle(id))] <- 0
			}
		}
		else
		{
			sendMessage(playerid, "[ERROR] Игрок далеко", red)
		}
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не полицейский", red)
	}
})

addCommandHandler( "setchanel",//сменить канал в рации
function( playerid, id )
{
	local playername = getPlayerName ( playerid )
	local id = id.tointeger()

	if (id <= 0)
	{
		return
	}
	else if (logged[playerid] == 0)
	{
		return
	}
	else if (amount_inv_player_1_parameter(playerid, 89) == 0)
	{
		sendMessage(playerid, "[ERROR] У вас нет рации", red)
		return
	}

	inv_player_delet(playerid, 89, search_inv_player_2_parameter(playerid, 89), true, false)

	inv_player_empty(playerid, 89, id)

	me_chat(playerid, playername+" сменил(а) канал в рации на "+id)
})

addCommandHandler ( "r",//рация
function (playerid, ...)
{
	local playername = getPlayerName ( playerid )
	local text = ""

	if (logged[playerid] == 0)
	{
		return
	}
	else if (amount_inv_player_1_parameter(playerid, 89) == 0)
	{
		sendMessage(playerid, "[ERROR] У вас нет рации", red)
		return
	}

	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	if (text.len() > max_text_len)
	{
		sendMessage(playerid, "[ERROR] Максимальная длина сообщения "+max_text_len+" символов", red)
		return
	}

	local radio_chanel = search_inv_player_2_parameter(playerid, 89)

	if(radio_chanel == police_chanel)
	{
		if (search_inv_player_2_parameter(playerid, 10) != 0)
		{
			police_chat(playerid, "[РАЦИЯ "+radio_chanel+" K] "+playername+" ["+playerid+"]: "+text)
		}
	}
	else if (radio_chanel == admin_chanel)
	{
		if (search_inv_player_2_parameter(playerid, 37) != 0)
		{
			admin_chat(playerid, "[РАЦИЯ "+radio_chanel+" K] Админ "+search_inv_player_2_parameter(playerid, 37)+" "+info_png[37][1]+" "+playername+" ["+playerid+"]: "+text)
		}
	}
	else
	{
		radio_chat(playerid, "[РАЦИЯ "+radio_chanel+" K] "+playername+" ["+playerid+"]: "+text, green_rc)	
	}
})

function message_player( playerid, id, ...)
{
	local playername = getPlayerName ( playerid )
	local id = id.tointeger()

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0)
	{
		return
	}

	if(logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}
	
	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	if (text.len() > max_text_len)
	{
		sendMessage(playerid, "[ERROR] Максимальная длина сообщения "+max_text_len+" символов", red)
		return
	}

	local player_name = getPlayerName ( id )

	sendMessage(playerid, "[LETTER TO] "+player_name+" ["+id+"]: "+text, yellow)
	sendMessage(id, "[LETTER FROM] "+playername+" ["+playerid+"]: "+text, yellow)
}
addCommandHandler( "msg", message_player)//смс

addCommandHandler("wc",//выдача чека
function(playerid, id)
{
	local id = id.tointeger()
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)

	if (logged[playerid] == 0 || id < 1 || arrest[playerid] != 0)
	{
		return
	}

	if (id > array_player_2[playerid][0])
	{
		sendMessage(playerid, "[ERROR] У вас недостаточно средств", red)
		return
	}

	if(inv_player_empty(playerid, 88, id))
	{
		me_chat(playerid, playername+" выписал(а) "+info_png[88][0]+" "+id+" "+info_png[88][1])

		inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-id, playername )
	}
	else
	{
		sendMessage(playerid, "[ERROR] Инвентарь полон", red)
	}
})

addCommandHandler("searchcar",//--заявление на поиск тс
function (playerid, plate)
{
	local playername = getPlayerName ( playerid )
	local plate = plate.tointeger()

	local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )
	local result_count = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )

	if (logged[playerid] == 0) 
	{
		return
	}
	else if (result_count[1]["COUNT()"] == 0)
	{
		sendMessage(playerid, "[ERROR] Т/с не найдено", red)
		return
	}
	else if (result[1]["theft"] == 0)
	{
		sendMessage(playerid, "[ERROR] Т/с не в угоне", red)
		return
	}

	if(inv_player_delet(playerid, 95, 1, true, false))
	{
		inv_player_empty(playerid, 96, plate)

		me_chat(playerid, playername+" написал(а) "+info_png[96][0]+" "+plate)
	}
	else
	{
		sendMessage(playerid, "[ERROR] У вас нет "+info_png[95][0], red)
	}
})

addCommandHandler("ec",//-эвакуция авто
function (playerid, id)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local id = id.tointeger()
	local cash = 500

	if (logged[playerid] == 0) 
	{
		return
	}

	if (arrest[playerid] != 0) 
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
				local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+plate+"'" )
				if (result[1]["COUNT()"] == 1) 
				{
					local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+plate+"'" )
					if (result[1]["frozen"] == 0)
					{
						if (search_inv_player(playerid, 6, id) != 0) 
						{
							if (player_in_car_theft(id.tostring()) != 0)
							{
								sendMessage(playerid, "[ERROR] Т/с угнали", red)
								return
							}

							foreach (player, playername in getPlayers())
							{
								local vehicle = getPlayerVehicle(player)
								if (vehicle == vehicleid)
								{
									removePlayerFromVehicle ( player )
								}
							}

							setVehiclePosition(vehicleid, myPos[0]+2, myPos[1], myPos[2]+0.5)
							setVehicleRotation(vehicleid, 0.0, 0.0, 0.0)

							if(getVehicleModel(vehicleid) == 27)
							{
								repairVehicle(vehicleid)
							}

							sqlite3( "UPDATE car_db SET x = '"+(myPos[0]+2)+"', y = '"+myPos[1]+"', z = '"+(myPos[2]+0.5)+"' WHERE number = '"+plate+"'")

							inv_server_load( playerid, "player", 0, 1, array_player_2[playerid][0]-cash, playerid )

							sendMessage(playerid, "Вы эвакуировали т/с за "+cash+"$", orange)
						}
						else
						{
							sendMessage(playerid, "[ERROR] У вас нет ключа от этого т/с", red)
						}
					}
					else 
					{
						sendMessage(playerid, "[ERROR] Т/с оштрафовали", red)
					}
				}
				else
				{
					sendMessage(playerid, "[ERROR] Т/с не найдено", red)
				}

				return
			}
		}

		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			result = sqlite3( "SELECT * FROM car_db WHERE number = '"+id+"'" )
			if (result[1]["theft"] == 1)
			{
				sendMessage(playerid, "[ERROR] Т/с в угоне", red)
				return
			}
		}

		sendMessage(playerid, "[ERROR] Т/с не найдено", red)
	}
	else
	{
		sendMessage(playerid, "[ERROR] Нужно иметь "+cash+"$", red)
	}
})

function getVehicleIdFromPlate( number )
{
	local number = number.tostring()

	foreach(vehicleid,v in getVehicles())
	{
		local plate = getVehiclePlateText(vehicleid)
		if (number == plate)
		{
			return vehicleid
		}
	}

	return -1
}

addCommandHandler( "cseat",//сесть в тс
function( playerid, plate, seat)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local vehicleid = getVehicleIdFromPlate( plate )
	local seat = seat.tointeger()

	if (logged[playerid] == 0)
	{
		return
	}
	else if (seat <= 0 || seat >= 21)
	{
		sendMessage(playerid, "[ERROR] От 1 до 20", red)
		return
	}

	if(vehicleid != -1)
	{		
		local model = getVehicleModel(vehicleid)
		if(motor_show[model][4] < seat || motor_show[model][4] == 0)
		{
			sendMessage(playerid, "[ERROR] Неверное место", red)
			return
		}

		local Pos = getVehiclePosition(vehicleid)
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], Pos[0],Pos[1],Pos[2], 5.0))
		{
			sead_custom[playerid][0] = vehicleid
			sead_custom[playerid][1] = seat

			me_chat(playerid, playername+" сел(а) в машину")
		}
		else
		{
			sendMessage(playerid, "[ERROR] Т/с далеко", red)
		}		
	}
	else
	{
		sendMessage(playerid, "[ERROR] Т/с не найдено", red)
	}
})

addCommandHandler( "cexit",//выйти из тс
function( playerid )
{
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0)
	{
		return
	}

	if(sead_custom[playerid][0] != -1)
	{
		local vehicleid = sead_custom[playerid][0]

		sead_custom[playerid] = [-1,0]

		local Pos = getVehiclePosition(vehicleid)
		setPlayerPosition(playerid, Pos[0]+2,Pos[1]+2,Pos[2])

		me_chat(playerid, playername+" вышел(ла) из машины")
	}
	else
	{
		sendMessage(playerid, "[ERROR] Вы не в т/с", red)
	}
})

addCommandHandler("till",//положить, снять и установить сумму
function (playerid, value, money)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local money = money.tointeger()

	if (logged[playerid] == 0) 
	{
		return
	}

	if (money < 1)
	{
		return
	}

	foreach (k, v in sqlite3( "SELECT * FROM business_db" ))//--бизнесы
	{
		if ( isPointInCircle3D(v["x"],v["y"],v["z"], x,y,z, house_bussiness_radius*2) && search_inv_player(playerid, 36, v["number"]) != 0 )
		{
			till_fun(playerid, v["number"], money, value)
			return
		}
	}
})

addCommandHandler("auc",//купить, продать и вернуть предмет
function (playerid, value, ...)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local name_buy = "all"

	if (logged[playerid] == 0) 
	{
		return
	}

	local auc_text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		auc_text = auc_text+vargv[i]+" "
	}

	local spl = split(auc_text, " ")

	foreach (k, v in phohe)
	{
		if ( isPointInCircle3D(v[0],v[1],v[2], x,y,z, 5.0) )
		{
			if (value == "buy" || value == "return")
			{
				auction_buy_sell(playerid, value, spl[0].tointeger(), 0, 0, 0, 0)
			}
			else if (value == "sell")
			{
				if (spl[2].tointeger() < 1)
				{
					return
				}

				if(spl.len() <= 3)
				{
				}
				else
				{
					name_buy = spl[3].tostring()
				}

				if(spl[0].tointeger() >= 2 && spl[0].tointeger() <= (info_png.len()-1))
				{
					foreach (idx, v in no_throw_earth)
					{
						if (v == spl[0].tointeger())
						{
							sendMessage(playerid, "[ERROR] Этот предмет не продается", red)
							return
						}
					}

					auction_buy_sell(playerid, "sell", 0, spl[0].tointeger(), spl[1].tointeger(), spl[2].tointeger(), name_buy)
				}
				else
				{
					sendMessage(playerid, "[ERROR] от 2 до "+(info_png.len()-1), red)
				}
			}
			return
		}
	}

	sendMessage(playerid, "[ERROR] Вы должны быть около телефонной будки", red)
})

addCommandHandler("takecar",//забрать тачку со штрафстоянки
function (playerid, plate)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	if (logged[playerid] == 0) 
	{
		return
	}

	foreach (k, v in phohe)
	{
		if ( isPointInCircle3D(v[0],v[1],v[2], x,y,z, 5.0) )
		{
			local count = 0
			local result = sqlite3( "SELECT COUNT() FROM car_db WHERE nalog = '0' AND number = '"+plate+"'" )

			foreach(vehicleid, v in getVehicles())
			{
				if (getVehiclePlateText(vehicleid) == plate)
				{
					count = 1
					break
				}
			}

			if (count == 1 || result[1]["COUNT()"] == 0)
			{
				sendMessage(playerid, "[ERROR] Т/с в городе", red)
				return
			}

			if (search_inv_player(playerid, 50, 7) != 0)
			{
				if (inv_player_delet(playerid, 50, 7, true, false))
				{
					sqlite3( "UPDATE car_db SET nalog = '7' WHERE number = '"+plate+"'")
					car_spawn(plate)

					sendMessage(playerid, "Вы забрали т/с под номером "+plate, yellow)
				}
			}
			else
			{
				sendMessage(playerid, "[ERROR] У вас нет "+info_png[50][0]+" 7 "+info_png[50][1], red)
			}
			return
		}
	}

	sendMessage(playerid, "[ERROR] Вы должны быть около телефонной будки", red)
})

addCommandHandler("sg",//меню рыбзавода
function (playerid, value, ...)
{
	local playername = getPlayerName( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]

	if (logged[playerid] == 0) 
	{
		return
	}

	local factory_text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		factory_text = factory_text+vargv[i]+" "
	}

	local spl = split(factory_text, " ")

	if (value == "menu")
	{	
		if (spl[0].tostring() == "pay" || spl[0].tostring() == "coef" || spl[0].tostring() == "balance")
		{
			cow_farms(playerid, value, spl[0].tostring(), spl[1].tointeger())
		}
		else if (spl[0].tostring() == "tax")
		{
			cow_farms(playerid, value, spl[0].tostring(), 0)
		}
	}
	else if (value == "buy")
	{
		cow_farms(playerid, value, 0, 0)
	}
	else if (value == "job")
	{
		cow_farms(playerid, value, spl[0].tointeger(), 0)
	}
})

addCommandHandler("capture",//--захват территории
function (playerid)
{
	local playername = getPlayerName ( playerid )
	local myPos = getPlayerPosition(playerid)
	local x = myPos[0]
	local y = myPos[1]
	local z = myPos[2]
	local mafia = search_inv_player_2_parameter(playerid, 91)

	if (logged[playerid] == 0)
	{
		return
	}
	else if(mafia == 0)
	{
		sendMessage(playerid, "[ERROR] Вы не состоите в мафии", red)
		return
	}
	else if(point_guns_zone[0] == 1)
	{
		sendMessage(playerid, "[ERROR] Идет захват территории", red)
		return
	}
	else if(crimes[playerid] < crimes_capture)
	{
		sendMessage(playerid, "[ERROR] Нужно иметь "+crimes_capture+" преступлений", red)
		return
	}
	
	local skin = false
	foreach (k,v in name_mafia[mafia][2])
	{
		if (v == getPlayerModel(playerid))
		{
			skin = true
			break
		}
	}

	if (!skin)
	{
		sendMessage(playerid, "[ERROR] Вы должны быть в одежде своей банды", red)
		return
	}

	foreach (k, v in guns_zone)
	{
		if (isPointInRectangle2D(x,y, v[0],v[1],v[2],v[3]) && search_inv_player_2_parameter(playerid, 91) != v[4])
		{
			point_guns_zone[0] = 1
			point_guns_zone[1] = k

			point_guns_zone[2] = search_inv_player_2_parameter(playerid, 91)
			point_guns_zone[3] = 0

			point_guns_zone[4] = v[4]
			point_guns_zone[5] = 0

			sendMessageAll(playerid, "[НОВОСТИ] "+playername+" из "+name_mafia[search_inv_player_2_parameter(playerid, 91)][0]+" захватывает Guns Zone #"+k+" - "+name_mafia[v[4]][0], green)
			return
		}
	}
})

addCommandHandler("idpng",
function (playerid)
{
	if (logged[playerid] == 0) 
	{
		return
	}

	sendMessage(playerid, "====[ ПРЕДМЕТЫ ]====", white)

	for (local i = 1; i < info_png.len(); i++) 
	{
		sendMessage(playerid, "["+i+"] "+info_png[i][0]+" 0 "+info_png[i][1], white)
	}
})

addCommandHandler("cc",//clear chat
function (playerid)
{
	if (logged[playerid] == 0) 
	{
		return
	}

	message[playerid] <- {}
	max_chat[playerid] = 15
	min_chat[playerid] = 0

	for (local i = 0; i < 15; i++)//заполнение 15 пустых строк
	{
		message_chat(playerid, "", 0,0,0)
		sendMessage_log(playerid, "", 0,0,0)
	}
})

addCommandHandler("me",
function (playerid, ...)
{
	local playername = getPlayerName( playerid )

	if (logged[playerid] == 0) 
	{
		return
	}

	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	me_chat_player(playerid, playername+" "+text)
})

addCommandHandler("do",
function (playerid, ...)
{
	local playername = getPlayerName( playerid )

	if (logged[playerid] == 0) 
	{
		return
	}

	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	do_chat_player(playerid, text+"- "+playername)
})

addCommandHandler("try",
function (playerid, ...)
{
	local playername = getPlayerName( playerid )

	if (logged[playerid] == 0) 
	{
		return
	}

	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	try_chat_player(playerid, playername+" "+text)
})

addCommandHandler("b",
function (playerid, ...)
{
	local playername = getPlayerName( playerid )

	if (logged[playerid] == 0) 
	{
		return
	}

	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	b_chat_player(playerid, "(Ближний OOC) "+getPlayerName( playerid )+" ["+playerid+"]: " + text)
})

addCommandHandler("quest",//квесты
function (playerid, ...)
{
	if (logged[playerid] == 0) 
	{
		return
	}

	local text = ""
	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	if(text != "" && split(text, " ")[0] == "select")
	{
		local id = split(text, " ")[1].tointeger()
		if(1 <= id && id <= quest_table.len())
		{
			foreach (k,v in quest_table[id][7])
			{
				if (v == getPlayerName(playerid))
				{
					sendMessage(playerid, "[ERROR] Вы выполнили этот квест", red)
					return
				}
			}

			sendMessage(playerid, "Вы взяли квест "+quest_table[id][0], yellow)

			setElementData(playerid, "quest_select", id+":0")
		}
	}
	else
	{
		sendMessage(playerid, "====[ КВЕСТЫ ]====", yellow)

		foreach (k, v in quest_table) 
		{
			local count = 0
			foreach (k,v in v[7])
			{
				if (v != getPlayerName(playerid))
				{
					count = count+1
				}
			}

			if (count == v[7].len())
			{
				if (split(getElementData(playerid, "quest_select"), ":")[0].tointeger() == k)
				{
					sendMessage(playerid, "[ "+k+" - "+v[0]+" - "+v[1]+v[2]+v[3]+" - "+split(getElementData(playerid, "quest_select"), ":")[1]+"/"+v[2]+" - "+v[5]+"$ - "+info_png[ v[6][0] ][0]+" "+v[6][1]+" "+info_png[ v[6][0] ][1]+" ]", green)
				}
				else
				{
					sendMessage(playerid, "[ "+k+" - "+v[0]+" - "+v[1]+v[2]+v[3]+" - 0/"+v[2]+" - "+v[5]+"$ - "+info_png[ v[6][0] ][0]+" "+v[6][1]+" "+info_png[ v[6][0] ][1]+" ]", yellow)
				}
			}
		}
	}
})

addCommandHandler("cmd",//все команды
function (playerid)
{
	if (logged[playerid] == 0) 
	{
		return
	}

	local commands = [
		"/roulette [режим игры (красное, черное, четное, нечетное, 1-18, 19-36, 1-12, 13-24, 25-36, 3-1, 3-2, 3-3, число от 0 до 36)] [сумма] - игра рулетка",
		"/slots [сумма] - сыграть в однорукого бандита",
		"/prison [ИД игрока] - посадить игрока в тюрьму (для полицейских)",
		"/r [текст] - рация",
		"/setchanel [канал] - сменить канал в рации",
		"/msg [ИД игрока] [текст] - отправить сообщение игроку",
		"/ec [номер т/с] - эвакуция т/с",
		"/cseat [номер т/с] [место от 1 до 20] - сесть на пассажирское место",
		"/cexit - выйти из т/с",
		"/till [withdraw, deposit, price] [сумма] - установить цены в бизнесе",
		"/search [player | car | house] [ИД игрока | номер т/с | номер дома] - обыскать игрока, т/с или дом (для полицейских)",
		"/searchcar [номер т/с] - написать заявление о пропаже т/с",
		"/sellhouse - создать дом (для риэлторов)",
		"/sellbusiness [номер бизнеса от 0 до 5] - создать бизнес (для риэлторов)",
		"/auc sell [ид предмета] [кол-во предмета] [сумма] [имя покупателя, если нету ничего не пишите] - выставить предмет на аукцион",
		"/auc [buy | return] [номер слота] - купить или забрать предмет с аукциона",
		"/takecar [номер т/с] - забрать т/с со штрафстоянки",
		"/lawyer [ИД игрока] - заплатить залог за игрока",
		"/enshot [ИД игрока] - выстрелить в двигатель (для полицейских)",
		"/wc [сумма] - выписать чек",
		"/sg buy - купить рыбзавод",
		"/sg job [номер рыбзавода] - устроиться на рыбзавод",
		"/sg menu [pay | coef] [сумма] - установить зарплату или доход от продаж",
		"/sg menu tax - оплатить налог",
		"/sg menu balance [знак - или + и сумма] - снять или положить деньги на баланс рыбзавода",
		"/capture - захват территории (для мафий)",
		"/me [текст] - описание действия от 1 лица",
		"/do [текст] - описание от 3 лица",
		"/try [текст] - попытка действия",
		"/b [текст] - ближний OOC чат",
		"/сс - очистить чат",
		"/marker [x координата] [y координата] - поставить маркер",
		"/idpng - ид предметов сервера",
		"/fortune [выбрать число 1,2,5,10,20,40] [сумма] - игра колесо удачи",
		"/blackjack invite [ИД игрока] [сумма] - игра блэкджек",
		"/quest - посмотреть список квестов",
		"/quest select [номер квеста] - выбрать квест",
		"/cmdadm - команды админа",
	]

	sendMessage(playerid, "====[ КОМАНДЫ ]====", white)

	foreach (idx, value in commands) 
	{
		sendMessage(playerid, value, white)
	}
})

addCommandHandler("cmdadm",//все команды
function (playerid)
{
	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0) 
	{
		return
	}

	local commands = [
		"/sub [ИД игрока] [ид предмета] [количество] - выдать себе предмет",
		"/subdel [ИД игрока] [ид предмета] [количество] - удалить предмет",
		"/subcar [ид предмета] [количество] - выдать предмет в тс",
		"/subearth [ид предмета] [количество] [количество на земле] - выдать предмет на землю",
		"/go [и 3 координаты] - тп на заданные координаты",
		"/pos [текст] - сохранить позицию в бд",
		"/global [текст] - глобальный чат",
		"/stime [часов] [минут] - установить время",
		"/inv [player | car | house] [имя игрока | номер т/с | номер дома] - чекнуть инв-рь",
		"/prisonplayer [ИД игрока] [время] [причина] - посадить игрока в тюрьму",
		"/v [ид т/с] - создать тс",
		"/delv - удалить тс созданные через /v",
	]

	sendMessage(playerid, "====[ КОМАНДЫ ]====", white)

	foreach (idx, value in commands) 
	{
		sendMessage(playerid, value, white)
	}
})

//--------------------------------------------админские команды--------------------------------------------
addCommandHandler("sub",//выдача предмета и кол-во
function(playerid, id, id1, id2)
{
	local id = id.tointeger()
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()
	local playername = getPlayerName ( playerid )

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}
	else if (logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}

	if (val1 > (info_png.len()-1) || val1 < 2)
	{
		sendMessage(playerid, "[ERROR] от 2 до "+(info_png.len()-1), red)
		return
	}

	if (inv_player_empty(id, val1, val2))
	{
		admin_chat(playerid, playername+" ["+playerid+"] выдал "+getPlayerName ( id )+" ["+id+"] "+info_png[val1][0]+" "+val2+" "+info_png[val1][1])
	}
	else
	{
		sendMessage(playerid, "[ERROR] Инвентарь полон", red)
	}
})

addCommandHandler("subdel",//удаление предмета
function(playerid, id, id1, id2)
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()
	local id = id.tointeger()
	local playername = getPlayerName ( playerid )

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}
	else if (logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}

	if (val1 > (info_png.len()-1) || val1 < 2)
	{
		sendMessage(playerid, "[ERROR] от 2 до "+(info_png.len()-1), red)
		return
	}

	if (inv_player_delet(id, val1, val2, true, false))
	{
		admin_chat(playerid, playername+" ["+playerid+"] удалил у "+getPlayerName ( id )+" ["+id+"] "+info_png[val1][0]+" "+val2+" "+info_png[val1][1])
	}
	else
	{
		sendMessage(playerid, "[ERROR] Предмет не найден", red)
	}
})

addCommandHandler ( "subcar",//--выдача предметов в тс
function (playerid, id1, id2 )
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle ( playerid )

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (val1 > (info_png.len()-1) || val1 < 2)
	{
		sendMessage(playerid, "[ERROR] от 2 до "+(info_png.len()-1), red)
		return
	}

	if (!isPlayerInVehicle(playerid)) 
	{
		sendMessage(playerid, "[ERROR] Вы не в т/с", red)
		return
	}

	if (inv_car_empty(playerid, val1, val2, true))
	{
		admin_chat(playerid, playername+" ["+playerid+"] создал для "+getVehiclePlateText(vehicleid)+" "+info_png[val1][0]+" "+val2+" "+info_png[val1][1])
	}
	else
	{
		sendMessage(playerid, "[ERROR] Инвентарь полон", red)
	}
})

addCommandHandler ( "subearth",//--выдача предметов с числом
function (playerid, id1, id2, count )
{
	local val1 = id1.tointeger()
	local val2 = id2.tointeger()
	local count = count.tointeger()
	local playername = getPlayerName ( playerid )
	local vehicleid = getPlayerVehicle ( playerid )
	local pos = getPlayerPosition(playerid)

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (val1 > (info_png.len()-1) || val1 < 2)
	{
		sendMessage(playerid, "[ERROR] от 2 до "+(info_png.len()-1), red)
		return
	}

	for (local i = 0; i < count; i++) 
	{
		max_earth = max_earth+1
		earth[max_earth] <- [pos[0],pos[1],pos[2],val1,val2]
	}

	admin_chat(playerid, playername+" ["+playerid+"] создал "+info_png[val1][0]+" "+val2+" "+info_png[val1][1]+" "+count+" шт")
})

addCommandHandler ( "prisonplayer",//--(посадить игрока в тюрьму)
function (playerid, id, time, ...)
{
	local playername = getPlayerName ( playerid )
	local reason = ""
	local time = time.tointeger()
	local id = id.tointeger()

	for(local i = 0; i < vargv.len(); i++)
	{
		reason = reason+vargv[i]+" "
	}

	if (id < 0 || id >= getMaxPlayers()) 
	{
		return
	}
	else if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (time < 1)
	{
		return
	}

	if (logged[id] == 0)
	{
		sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		return
	}

	sendMessageAll(playerid, "Администратор "+playername+" посадил в тюрьму "+getPlayerName ( id )+" на "+time+" мин. Причина: "+reason, lyme)

	arrest[id] = 2
	inv_server_load (playerid, "player", 24, 28, time, playername)
})

addCommandHandler("v",
function(playerid, id)
{
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	local pos = getPlayerPosition( playerid )
	local vehicleid = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 )
	setVehiclePlateText(vehicleid, "0")
	fuel["0"] <- max_fuel
	dviglo["0"] <- 0
	probeg["0"] <- 0
	array_car_1["0"] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	array_car_2["0"] <- [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	/*local blipid = createBlip( -300.0, 120.0, 0, 1 )
	attachBlipToVehicle(blipid, vehicleid)*/
	admin_chat(playerid, playername+" ["+playerid+"] создал т/с")
})

addCommandHandler ( "delv",//--удаление авто для админов
function ( playerid )
{
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0) 
	{
		return
	}

	local count = 0
	foreach (k,v in getVehicles())
	{
		if ("0" == getVehiclePlateText(v))
		{
			destroyVehicle(v)
			count = count+1
		}
	}

	admin_chat(playerid, playername+" ["+playerid+"] удалил "+count+" т/с")
})

addCommandHandler("stime",
function(playerid, id1, id2)
{	
	local playername = getPlayerName ( playerid )
	local id1 = id1.tointeger()
	local id2 = id2.tointeger()

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (id1 >= 0 && id1 <= 23 && id2 >= 0 && id2 <= 59)
	{
		hour = id1
		minute = id2

		admin_chat(playerid, playername+" ["+playerid+"] stime "+hour+":"+minute)
	}
	else
	{
		sendMessage(playerid, "[ERROR] Часы от 0 до 23, Минуты от 0 до 59", red)
	}
})

addCommandHandler ( "pos",
function ( playerid, ... )
{
	local playername = getPlayerName ( playerid )
	local pos = getPlayerPosition( playerid )
	local text = ""

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	local result = sqlite3( "INSERT INTO position (description, pos) VALUES ('"+text+"', '["+pos[0]+","+pos[1]+","+pos[2]+"],')" )
	admin_chat(playerid, playername+" ["+playerid+"] save pos "+text)
})

addCommandHandler ( "global",
function ( playerid, ... )
{
	local playername = getPlayerName ( playerid )
	local text = ""

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	for(local i = 0; i < vargv.len(); i++)
	{
		text = text+vargv[i]+" "
	}

	sendMessageAll(0, "[ADMIN] "+playername+": "+text, lyme)
})

addCommandHandler ( "hp",
function ( playerid, id, id2 )
{
	local playername = getPlayerName ( playerid )
	local text = ""

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	setPlayerHealth(id.tointeger(), id2.tofloat())
})

addCommandHandler( "go",
function( playerid, q, w, e )
{
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

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

function tp_player(playerid, value) {
	local vehicleid = getPlayerVehicle(playerid)
	local count = 10

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0 || admin_tp[playerid][0] == 0 || isPlayerInVehicle(playerid))
	{
		return
	}
	else if(value == "kill")
	{	
		if(admin_tp[playerid][1] != 0)
		{
			admin_tp[playerid][1].Kill()
		}
		admin_tp[playerid][1] = 0
		setPlayerFrozen(playerid, false)
		return
	}

	setPlayerFrozen(playerid, true)

	admin_tp[playerid][1] = timer(function() {
		if(value == "w")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0], pos[1]+count, pos[2] )
		}
		else if(value == "s")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0], pos[1]-count, pos[2] )
		}
		else if(value == "a")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0]-count, pos[1], pos[2] )
		}
		else if(value == "d")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0]+count, pos[1], pos[2] )
		}
		else if(value == "q")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0], pos[1], pos[2]-count )
		}
		else if(value == "e")
		{
			local pos = getPlayerPosition(playerid)
			setPlayerPosition( playerid, pos[0], pos[1], pos[2]+count )
		}
	}, 500, -1)
}
addEventHandler( "event_tp_player", tp_player )

addCommandHandler ( "inv",//--чекнуть инв-рь игрока
function (playerid, value, id)
{
	local playername = getPlayerName ( playerid )

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (value == "player")
	{
		local result = sqlite3( "SELECT COUNT() FROM account WHERE name = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM account WHERE name = '"+id+"'" )
			local text = ""

			triggerClientEvent(playerid, "event_save_player_action", value+"-"+id)

			foreach (k,v in split(result[1]["inventory"], ","))
			{
				local spl = split(v, ":")
				text = info_png[spl[0].tointeger()][0]+" "+spl[1]+" "+info_png[spl[0].tointeger()][1]

				triggerClientEvent(playerid, "event_save_player_action", text)
			}

			sendMessage(playerid, "Инвентарь "+value+"-"+id+" загружен и сохранен в core.log", lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		}
	}
	else if (value == "car")
	{
		local result = sqlite3( "SELECT COUNT() FROM car_db WHERE number = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM car_db WHERE number = '"+id+"'" )
			local text = ""

			triggerClientEvent(playerid, "event_save_player_action", value+"-"+id)

			foreach (k,v in split(result[1]["inventory"], ","))
			{
				local spl = split(v, ":")
				text = info_png[spl[0].tointeger()][0]+" "+spl[1]+" "+info_png[spl[0].tointeger()][1]

				triggerClientEvent(playerid, "event_save_player_action", text)
			}

			sendMessage(playerid, "Инвентарь "+value+"-"+id+" загружен и сохранен в core.log", lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого т/с нет", red)
		}
	}
	else if (value == "house")
	{
		local result = sqlite3( "SELECT COUNT() FROM house_db WHERE number = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			local result = sqlite3( "SELECT * FROM house_db WHERE number = '"+id+"'" )
			local text = ""

			triggerClientEvent(playerid, "event_save_player_action", value+"-"+id)

			foreach (k,v in split(result[1]["inventory"], ","))
			{
				local spl = split(v, ":")
				text = info_png[spl[0].tointeger()][0]+" "+spl[1]+" "+info_png[spl[0].tointeger()][1]

				triggerClientEvent(playerid, "event_save_player_action", text)
			}

			sendMessage(playerid, "Инвентарь "+value+"-"+id+" загружен и сохранен в core.log", lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого дома нет", red)
		}
	}
})

addCommandHandler ( "tp",//--телепорт
function (playerid, value, id)
{
	local playername = getPlayerName ( playerid )
	local id = id.tointeger()

	if (logged[playerid] == 0 || search_inv_player(playerid, 37, 1) == 0)
	{
		return
	}

	if (value == "player")
	{
		if (logged[id] == 1)
		{
			local pos = getPlayerPosition(id)
			setPlayerPosition(playerid, pos[0],pos[1],pos[2])

			admin_chat(playerid, getPlayerName(playerid)+" ["+playerid+"] телепортировался к "+getPlayerName(id)+" ["+id+"]")
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого игрока нет", red)
		}
	}
	else if (value == "business")
	{
		local result = sqlite3( "SELECT COUNT() FROM business_db WHERE number = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			result = sqlite3( "SELECT * FROM business_db WHERE number = '"+id+"'" )

			setPlayerPosition(playerid, result[1]["x"],result[1]["y"],result[1]["z"])

			sendMessage(playerid, "Вы телепортировались к "+id+" бизнесу", lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого бизнеса нет", red)
		}
	}
	else if (value == "house")
	{
		local result = sqlite3( "SELECT COUNT() FROM house_db WHERE number = '"+id+"'" )
		if (result[1]["COUNT()"] == 1)
		{
			result = sqlite3( "SELECT * FROM house_db WHERE number = '"+id+"'" )

			setPlayerPosition(playerid, result[1]["x"],result[1]["y"],result[1]["z"])

			sendMessage(playerid, "Вы телепортировались к "+id+" дому", lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого дома нет", red)
		}
	}
	else if (value == "interior")
	{
		if (0 <= id && id <= interior_job.len()-1)
		{
			setPlayerPosition(playerid, interior_job[id][2],interior_job[id][3],interior_job[id][4])

			sendMessage(playerid, "Вы телепортировались к "+interior_job[id][1], lyme)
		}
		else
		{
			sendMessage(playerid, "[ERROR] Такого здания нет", red)
		}
	}
})

function chat(mess) 
{
	local ansi = ["а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я"]
	local utf8 = ["f", ",", "d", "u", "l", "t", "`", ";", "p", "b", "q", "r", "k", "v", "y", "j", "g", "h", "c", "n", "e", "a", "[", "w", "x", "i", "o", "]", "s", "m", "'", ".", "z"]

	for (local i = 0; i < 33; i++)
	{
		if(mess == utf8[i])
		{
			return ansi[i]
		}
	}

	return mess
}
local md5_table = {}
addEventHandler("onConsoleInput",
function(command, params)
{
	log("")
	log( "Commands - " +command )

	if(command == "z")
	{
		/*foreach(k,v in getWhoWas())
		{	
			print("----"+k+"----")
			foreach(k1,v1 in v)
			{
				print(k1+" "+v1)
			}
		}

		for (local i = 1; i <= 14; i++) {
			sqlite3( "INSERT INTO guns_zone (number, x1, y1, x2, y2, mafia) VALUES ('"+i+"', '"+(-1965+((i-1)*250))+"', '2000', '"+(-1965+(i*250))+"', '-1000', '0')" )
		}

		print("getWhoWasCount "+getWhoWasCount())*/
	}

	if(command == "x")
	{

	}

	if(command == "a")//админский чат
	{	
		local text = ""//готовое сообщение
		local q = params//начальное сообщение

		for (local i = 0; i < q.len(); i++)//кодирование
		{
			text += chat(q.slice( (0+(i*1)), (1+(i*1)) ))
		}
		sendMessageAll(0, "[ADMIN] "+text, lyme)
	}
})