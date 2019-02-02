local text_3d = [//--3d text
	//up_car_subject
	[-632.282,955.495,-18.7324, 15.0, "Склад продуктов (Загрузить ящики - E)"],

	//up_player_subject
	[-427.786,-737.652,-21.7381, 5.0, "Нажмите E, чтобы взять ящик"],

	//down_car_subject
	[-411.778,-827.907,-21.7456, 15.0, "Порт (Разгрузить товар - E)"],

	//down_player_subject
	[-411.778,-827.907,-21.6456, 5.0, "Выбросите ящик, чтобы получить прибыль"],
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

local house_bussiness_radius = 0//--радиус размещения бизнесов и домов
local house_pos = {}
local business_pos = {}
local job_pos = {}
function bussines_house_fun (i, x,y,z, value, radius, text, radius1)
{
	if (value == "biz")
	{
		business_pos[i] <- [x,y,z]
	}
	else if (value == "house")
	{
		house_pos[i] <- [x,y,z]
	}
	else if (value == "job")
	{
		job_pos[i] <- [x,y,z, text, radius1]
	}

	house_bussiness_radius = radius
}
addEventHandler ( "event_bussines_house_fun", bussines_house_fun )

addEventHandler( "onClientFrameRender",
function( post )
{
	local myPos = getPlayerPosition(getLocalPlayer())
	
	foreach (k, v in text_3d)
	{
		local area = isPointInCircle3D( myPos[0], myPos[1], myPos[2], v[0], v[1], v[2], v[3] )

		if (area)
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1 )
			local dimensions = dxGetTextDimensions(v[4], 1.0, "tahoma-bold" )
			dxdrawtext ( v[4], coords[0]-(dimensions[0]/2), coords[1], fromRGB( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2] ), true, "tahoma-bold", 1.0 )
		}
	}


	foreach (k, v in house_pos)
	{
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0],v[1],v[2], house_bussiness_radius))
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1.0 )
			local dimensions = dxGetTextDimensions ( "Дом #"+k+"", 1.0, "tahoma-bold" )
			dxdrawtext ( "Дом #"+k+"", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}


	foreach (k, v in business_pos)
	{
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0],v[1],v[2], house_bussiness_radius))
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1.0 )
			local dimensions = dxGetTextDimensions ( "Бизнес #"+k+"", 1.0, "tahoma-bold" )
			dxdrawtext ( "Бизнес #"+k+"", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )

			local dimensions = dxGetTextDimensions ( "(Разгрузить товар - E, Меню - X)", 1.0, "tahoma-bold" )
			dxdrawtext ( "(Разгрузить товар - E, Меню - X)", coords[0]-(dimensions[0]/2), coords[1]+15.0, fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}

	foreach (k, v in job_pos)
	{
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0],v[1],v[2], v[4]))
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1.0 )
			local dimensions = dxGetTextDimensions ( "Здание", 1.0, "tahoma-bold" )
			dxdrawtext ( "Здание", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )

			local dimensions = dxGetTextDimensions ( "(Меню - X)", 1.0, "tahoma-bold" )
			dxdrawtext ( "(Меню - X)", coords[0]-(dimensions[0]/2), coords[1]+15.0, fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}
})