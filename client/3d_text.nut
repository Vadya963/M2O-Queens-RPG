local text_3d = [//--3d text
	//up_car_subject
	[-632.282,955.495,-17.7324, 15.0, "����� ��������� (��������� ����� - E)"],

	//up_player_subject
	[-427.786,-737.652,-21.7381, 5.0, "������� E, ����� ����� ����"],

	//down_car_subject
	[-411.778,-827.907,-21.7456, 15.0, "���� (���������� ����� - E)"],

	//down_player_subject
	[-411.778,-827.907,-21.6456, 5.0, "��������� ����, ����� �������� �������"],
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
})