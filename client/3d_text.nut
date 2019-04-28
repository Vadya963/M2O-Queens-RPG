local text = "��������� �������, ����� �������� ���� �������"
local text2 = "��������� ����, ����� �������� �����"
local text3 = "��������� ����� ������, ����� �������� ������ ������"
local text4 = "����� (���� - X)"
local text5 = "����������� ���� � �������������, ����� �������� �������"
local text6 = "���������� ����� (���� - X)"
local y1 = 0.2

local text_3d = [//--3d text
	//interior_job
	[-378.987,654.699,-11.5013, 5.0, "����������� ����������� (���� - X)"],
	[-115.11,-63.1035,-12.041, 5.0, "����� (���� - X)"],
	[-199.532,838.583,-21.2431, 5.0, "��������� (���� - X)"],
	[-539.082,-91.9283,0.436483, 5.0, "������"],
	[-526.354,-40.6722,1.07341, 5.0, "��������"],
	[-1292.64,1608.78,4.30491, 5.0, "��������� ���������, ����� �������� �������"],
	[-579.186,-175.013,1.03791, 5.0, "����� �������"],
	[-480.222,244.336,3.22333, 5.0, "���"],
	[-165.132,519.097,-19.9438, 5.0, "�������� (���� - X)"],
	[-130.638,1745.93,-18.348, 5.0, "��������� �/�"],
	//������������
	[41.5553,1784.44,-17.8668, 0.5, "����������� �������, ����� �����"],
	[41.5922,1785.13,-17.8401, 0.5, "����������� �������, ����� �����"],
	//�����
	[-554.36,1592.92,-21.8639, 4.0, text4],
	[-1118.99,1376.44,-18.5, 4.0, text4],
	[-1535.55,-231.03,-13.5892, 4.0, text4],
	[-511.412,20.1703,-5.7096, 4.0, text4],
	[-113.792,-481.71,-8.92243, 4.0, text4],
	[234.395,380.914,-9.41271, 4.0, text4],
	[-293.069,568.25,-2.27367, 4.0, text4],

	//��������
	[-310.857,1694.88,-22.3773, 5.0, text5],
	[-1170.57,1578.15,5.84156, 5.0, text5],
	[-1654.61,1143.06,-7.10691, 5.0, text5],
	[-1562.38,527.787,-20.1476, 5.0, text5],
	[-1421.31,-191.48,-20.3052, 5.0, text5],
	[-147.053,-595.967,-20.1636, 5.0, text5],
	[283.082,-388.371,-20.1361, 5.0, text5],
	[747.74,7.80397,-19.4607, 5.0, text5],
	[-208.633,-45.6014,-12.0168, 5.0, text5],
	[-584.811,89.4905,-0.21516, 5.0, text5],
	[250.26,494.087,-20.046, 5.0, text5],
	[612.189,845.402,-12.6476, 5.0, text5],
	[112.488,847.435,-19.9109, 5.0, text5],
	[139.371,1226.68,62.8897, 5.0, text5],
	[-508.688,910.919,-19.055, 5.0, text5],
	[-78.6843,233.494,-14.4042, 5.0, text5],

	[-310.857,1694.88,-22.3773+y1, 5.0, text6],
	[-1170.57,1578.15,5.84156+y1, 5.0, text6],
	[-1654.61,1143.06,-7.10691+y1, 5.0, text6],
	[-1562.38,527.787,-20.1476+y1, 5.0, text6],
	[-1421.31,-191.48,-20.3052+y1, 5.0, text6],
	[-147.053,-595.967,-20.1636+y1, 5.0, text6],
	[283.082,-388.371,-20.1361+y1, 5.0, text6],
	[747.74,7.80397,-19.4607+y1, 5.0, text6],
	[-208.633,-45.6014,-12.0168+y1, 5.0, text6],
	[-584.811,89.4905,-0.21516+y1, 5.0, text6],
	[250.26,494.087,-20.046+y1, 5.0, text6],
	[612.189,845.402,-12.6476+y1, 5.0, text6],
	[112.488,847.435,-19.9109+y1, 5.0, text6],
	[139.371,1226.68,62.8897+y1, 5.0, text6],
	[-508.688,910.919,-19.055+y1, 5.0, text6],
	[-78.6843,233.494,-14.4042+y1, 5.0, text6],

	[566.041,-591.121,-22.7021, 20.0, "����������� ������, ����� �������� ����"],

	//up_car_subject
	[-632.282,955.495,-18.7324, 15.0, "����� ��������� (��������� ����� - E)"],
	[1332.08,1284.72,-0.306898, 15.0, "��������� (��������� ����� - E)"],
	[-217.361,-724.751,-21.4251, 15.0, "�������� ����� ���� (��������� ���� - E)"],//--�������� ����
	[374.967,117.759,-21.0186, 5.0, "�������� ������� ���� (��������� ���� - E)"],//--�������� ���� � ��

	//up_player_subject
	[-427.786,-737.652,-21.7381, 5.0, "������� E, ����� ����� ����"],
	[-85.0723,1736.84,-18.7004, 5.0, "������� E, ����� ����� �������"],//--������ ������
	[826.577,565.208,-11.196, 5.0, "������� E, ����� ����� ����"],//--���� �������
	[26.051,1828.37,-16.9628, 2.0, "������� E, ����� ����� ����� ������"],//--������������

	//down_car_subject
	[-334.529,-786.738,-21.5261, 15.0, "���� (���������� ����� - E)"],
	[1189.65,1146.35,3.06759, 15.0, "������ (���������� ����� - E)"],
	[119.838,-202.878,-20.2502, 15.0, "���� (���������� ������ - E)"],//����
	[-299.495,-734.244,-21.422, 15.0, "��������� ������� ���� (���������� ���� - E)"],//����
	[365.745,117.759,-21.2489, 5.0, "��������� ����� ���� (���������� ���� - E)"],//--��������

	//down_player_subject
	[-411.778,-827.907,-21.6456, 5.0, "��������� ������� � ����������, ����� �������� �������"],
	[-83.0683,1767.58,-18.4006, 5.0, "��������� ���� �������, ����� �������� �������"],//--������ ������
	[843.815,474.489,-12.0816, 5.0, "��������� �����, ����� �������� �������"],//--���� �������
	[1.93655,1825.94,-16.963, 1.0, "��������� ������ ������, ����� �������� �������"],//--������������
	[341.981,99.035,-21.2723, 5.0, "��������� ����, ����� �������� �������"],//--��������

	//anim_player_subject
	//������ ������
	[-100.209,1777.59,-18.7375, 1.0, text],
	[-100.209,1784.23,-18.7375, 1.0, text],
	[-100.209,1791.11,-18.7375, 1.0, text],
	[-100.209,1812.61,-18.7375, 1.0, text],
	[-100.209,1819.64,-18.7375, 1.0, text],
	[-100.209,1826.59,-18.7335, 1.0, text],
	[-74.3066,1823.29,-18.7367, 1.0, text],
	[-74.3065,1816.46,-18.7369, 1.0, text],
	[-74.3066,1809.61,-18.7369, 1.0, text],
	[-74.3065,1780.41,-18.7371, 1.0, text],

	//--���� �������
	[825.124,579.623,-12.0828, 1.0, text2],
	[824.448,582.761,-12.0828, 1.0, text2],
	[824.16,586.458,-12.0828, 1.0, text2],

	//������������
	[1.69235,1822.66,-16.963, 1.0, text3],
	[-0.230181,1822.67,-16.963, 1.0, text3],
	[1.71198,1820.09,-16.963, 1.0, text3],
	[-0.460387,1820.1,-16.963, 1.0, text3],
	[1.75545,1817.91,-16.963, 1.0, text3],
	[-0.415082,1817.96,-16.963, 1.0, text3],
	[-0.203448,1815.39,-16.963, 1.0, text3],
	[1.79924,1815.35,-16.963, 1.0, text3],
]

//----�����----
local color_tips = [168,228,160]//--��������� ������
local yellow = [255,255,0]//--������
local red = [255,0,0]//--�������
local blue = [0,150,255]//--�����
local white = [255,255,255]//--�����
local green = [0,255,0]//--�������
local turquoise = [0,255,255]//--���������
local orange = [255,100,0]//--���������
local orange_do = [255,150,0]//--��������� do
local pink = [255,100,255]//--�������
local lyme = [130,255,0]//--���� ��������� ����
local svetlo_zolotoy = [255,255,130]//--������-�������

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

local house_bussiness_radius = 0//--������ ���������� �������� � �����
local house_pos = {}
local business_pos = {}
function bussines_house_fun (i, x,y,z, value, radius)
{
	if (value == "biz")
	{
		business_pos[i] <- [x,y,z]
	}
	else if (value == "house")
	{
		house_pos[i] <- [x,y,z]
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
			local dimensions = dxGetTextDimensions ( "��� #"+k+"", 1.0, "tahoma-bold" )
			dxdrawtext ( "��� #"+k+"", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}


	foreach (k, v in business_pos)
	{
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0],v[1],v[2], house_bussiness_radius))
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1.0 )
			local dimensions = dxGetTextDimensions ( "������ #"+k+"", 1.0, "tahoma-bold" )
			dxdrawtext ( "������ #"+k+"", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )

			local dimensions = dxGetTextDimensions ( "(���������� ����� - E, ���� - X)", 1.0, "tahoma-bold" )
			dxdrawtext ( "(���������� ����� - E, ���� - X)", coords[0]-(dimensions[0]/2), coords[1]+15.0, fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}
})