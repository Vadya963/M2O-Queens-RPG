local playerid = getLocalPlayer()
local screen = getScreenSize()
local max_inv = 24
local width = 370.0
local height = 250.0
local dxDrawTexture_width_height = 0.78
local pos_x_3d_image = (screen[0]/2)-(width/2)
local pos_y_3d_image = (screen[1]/2)-(height/2)

local gui_earth = 0//1 ������, 0 ������
local state_inv_gui = false//���-�� ������ ��� ������
local gui_select = false//��������� ���

local state_inv_player = false//��������� ��-�� ������
local state_inv_car = false//��������� ��-�� ��
local state_inv_house = false//��������� ��-�� ����

local info_tab = ""//��������� �������� � ����
local info3 = 0//����
local info1 = 0//���
local info2 = 0//�����

local plate = ""//���� � ��
local house = ""//���� ����� ����

local no_use_subject = [-1,0,1]

//--����������� ��������
local lmb = 0//--���
local info3_selection_1 = -1// --���� ��������
local info1_selection_1 = -1// --����� ��������
local info2_selection_1 = -1// --�������� ��������

//�������� �������� ��� ����������� �� �����
local image = array(33+1,0)

for (local i = 0; i < image.len(); i++)
{
	image[i] = dxLoadTexture(i+".png")
}

local mouse = dxLoadTexture("mouse.png")

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

local inv_slot_player = [//���-�� ������ {��� �������� 0, �������� 1}
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

local inv_slot_car = [//���-�� ������ {��� �������� 0, �������� 1}
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

local inv_slot_house = [//���-�� ������ {��� �������� 0, �������� 1}
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

local inv_pos = [//������� ������ {���� 0, ������� � 1, ������� � 2}
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

local button_pos = [//������� ������
	[0,"�����",10.0,15.0],
	[0,"����",70.0,15.0],
	[0,"���",130.0,15.0]
]

gui_earth = guiCreateElement( 2, "", 0.0, 0.0, screen[0], screen[1], false )//��� ����� �������� �������
guiSetAlpha(gui_earth, 0.0)

//�������� ���-�� � ������
for (local i = 0; i < max_inv; i++) 
{
	inv_pos[i][0] = guiCreateElement( 2, "", (inv_pos[i][1]+pos_x_3d_image), (inv_pos[i][2]+pos_y_3d_image), 50.0, 50.0, false, gui_earth )
	guiSetVisible( inv_pos[i][0], false )
}

for (local i = 0; i < button_pos.len(); i++)
{
	button_pos[i][0] = guiCreateElement( 2, "", (button_pos[i][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[i][3]), 50.0, button_pos[i][3], false, gui_earth )
	guiSetVisible( button_pos[i][0], false )
}

guiSetVisible( gui_earth, false )

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

function getFuel()
{
	if (isPlayerInVehicle(playerid))
	{
		local vehicleid = getPlayerVehicle(playerid)
		local gas = getVehicleFuel(vehicleid)
		return gas
	}
	else
	{
		return 0
	}
}

local house_bussiness_radius = 0//--������ ���������� �������� � �����
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

addEventHandler("onClientScriptInit", 
function() 
{
	bindKey( "tab", "down", tab_down )
})

function zamena_img()
{
//--------------------------------------------------------------������ ���� ����� 1 ���----------------------------------------------------------------------------
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

addEventHandler( "onClientFrameRender",
function( post )
{
	local myPos = getPlayerPosition(playerid)

	dxdrawtext( "gui_earth "+gui_earth, 10.0, 15.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "state_inv_gui "+state_inv_gui, 10.0, 30.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "gui_select "+gui_select, 10.0, 45.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )

	dxdrawtext( "state_inv_player "+state_inv_player, 10.0, 60.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "state_inv_car "+state_inv_car, 10.0, 75.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "state_inv_house "+state_inv_house, 10.0, 90.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )

	dxdrawtext( "info_tab "+info_tab, 10.0, 105.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "info3 "+info3, 10.0, 120.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "info1 "+info1, 10.0, 135.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "info2 "+info2, 10.0, 150.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )

	dxdrawtext( "plate "+plate, 10.0, 165.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "house "+house, 10.0, 180.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )

	dxdrawtext( "info3_selection_1 "+info3_selection_1, 10.0, 195.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "info1_selection_1 "+info1_selection_1, 10.0, 210.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )
	dxdrawtext( "info2_selection_1 "+info2_selection_1, 10.0, 225.0, fromRGB( 255, 255, 255 ), true, "tahoma-bold", 1.0 )


	foreach (k, v in house_pos)
	{
		if (isPointInCircle3D(myPos[0],myPos[1],myPos[2], v[0],v[1],v[2], house_bussiness_radius))
		{
			local coords = getScreenFromWorld( v[0], v[1], v[2]+1.0 )
			local dimensions = dxGetTextDimensions ( "��� #"+k+"", 1.0, "tahoma-bold" )
			dxdrawtext ( "��� #"+k+"", coords[0]-(dimensions[0]/2), coords[1], fromRGB ( svetlo_zolotoy[0], svetlo_zolotoy[1], svetlo_zolotoy[2], 255 ), true, "tahoma-bold", 1.0 )
		}
	}


	if (state_inv_gui)//���-��
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


		if (gui_select)//��������� ���
		{
			if (info_tab == "player" && state_inv_player || info_tab == "car" && state_inv_car || info_tab == "house" && state_inv_house)
			{
				dxDrawRectangle( (inv_pos[info3][1]+pos_x_3d_image), (inv_pos[info3][2]+pos_y_3d_image), 50.0, 50.0, fromRGB( 255, 255, 130, 100 ) )
			}
		}


		//dxDrawRectangle( (button_pos[0][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[0][3]), 50.0, button_pos[0][3], fromRGB( 50, 50, 50, 200 ) )
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
			//dxDrawRectangle( (button_pos[1][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[1][3]), 50.0, button_pos[1][3], fromRGB( 50, 50, 50, 200 ) )
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
			//dxDrawRectangle( (button_pos[2][2]+pos_x_3d_image), (pos_y_3d_image-button_pos[2][3]), 50.0, button_pos[2][3], fromRGB( 50, 50, 50, 200 ) )
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
})

function tab_down_fun()//���-�� ������
{
	if (state_inv_gui)
	{
		state_inv_gui = false
		state_inv_player = false
		state_inv_car = false
		state_inv_house = false
		gui_select = false
		info3 = 0
		info1 = 0
		info2 = 0
		info_tab = ""
		info3_selection_1 = -1
		info1_selection_1 = -1
		info2_selection_1 = -1
		showCursor( false )

		guiSetVisible( gui_earth, false )
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

		guiSetVisible( gui_earth, true )
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

function tab_down()//���-�� ������
{
	if(isMainMenuShowing())
	{
		return
	}

	triggerServerEvent( "event_tab_down" )
}

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
							gui_select = false
							return
						}
					}

					gui_select = true
					info_tab = "player"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------������ ���� ����� 2 ���----------------------------------------------------------------------------
					if (inv_slot_player[info3][0] != 0)
					{
						foreach (idx, v in no_use_subject)
						{
							if (v == info1)
							{
								lmb = 0
								gui_select = false
								return
							}
						}

						info_tab = "player"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}

					triggerServerEvent( "event_inv_server_load", "player", info3, info1_selection_1, info2_selection_1, playerid )

					zamena_img()

					gui_select = false
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
							gui_select = false
							return
						}
					}

					gui_select = true
					info_tab = "car"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------������ ���� ����� 2 ���----------------------------------------------------------------------------
					if (inv_slot_car[info3][0] != 0)
					{
						foreach (idx, v in no_use_subject)
						{
							if (v == info1)
							{
								lmb = 0
								gui_select = false
								return
							}
						}

						info_tab = "car"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}

					triggerServerEvent( "event_inv_server_load", "car", info3, info1_selection_1, info2_selection_1, plate )

					zamena_img()

					gui_select = false
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
							gui_select = false
							return
						}
					}

					gui_select = true
					info_tab = "house"
					info3_selection_1 = info3
					info1_selection_1 = info1
					info2_selection_1 = info2
					lmb = 1
				}
				else
				{
					//--------------------------------------------------------------������ ���� ����� 2 ���----------------------------------------------------------------------------
					if (inv_slot_house[info3][0] != 0)
					{
						foreach (idx, v in no_use_subject)
						{
							if (v == info1)
							{
								lmb = 0
								gui_select = false
								return
							}
						}

						info_tab = "house"
						info3_selection_1 = info3
						info1_selection_1 = info1
						info2_selection_1 = info2
						return
					}

					triggerServerEvent( "event_inv_server_load", "house", info3, info1_selection_1, info2_selection_1, house )

					zamena_img()

					gui_select = false
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

function tab_load (value, text)//�������� �������� � ����
{
	if (value == "car")
	{
		plate = text
	}
	else if (value == "house")
	{
		house = text
	}
}
addEventHandler ( "event_tab_load", tab_load )