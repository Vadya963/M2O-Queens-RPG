local playerid = getLocalPlayer()
local screen = getScreenSize()

local gridlist_table = {}//таблица созданных окон
local gridlist_window = 0//окно в котором выделяется текст
local gridlist_lable = 0//текст который будет выделяться
local gridlist_select = false//выделение текста

function guiCreateGridList (x,y, width, height)
{
	local window = guiCreateElement( 5, "", x,y, width, height, false )
	gridlist_table[gridlist_table.len()] <- window
	return window
}

function guiGridListAddRow (window, slot, text)
{
	local guiSize_window = guiGetSize( window )
	local text_gui = guiCreateElement( 6, text, 10.0, (15.0*slot)+5.0, guiSize_window[0], 15.0, false, window )
}

function guiGridListGetItemText (element)
{
	local text = guiGetText(element)
	if (text != "")
	{
		return text
	}
	else 
	{
		return "false"
	}
}

addEventHandler( "onClientFrameRender",
function( post )
{	
	if (gridlist_select)
	{
		local guiPos_window = guiGetPosition( gridlist_window )
		local guiSize_window = guiGetSize( gridlist_window )

		local guiPos_lable = guiGetPosition( gridlist_lable )
		local guiSize_lable = guiGetSize( gridlist_lable )

		dxDrawRectangle( guiPos_window[0]+guiPos_lable[0]-10.0, guiPos_window[1]+guiPos_lable[1]+5.0, guiSize_lable[0], guiSize_lable[1], fromRGB( 0, 150, 255, 150 ) )
	}
})

	local mayoralty_shop = {
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

	local test = guiCreateGridList(200.0, 100.0, 300.0, 145.0)

	foreach (k,v in mayoralty_shop)
	{
		guiGridListAddRow (test, k, v)
	}

addEventHandler( "onGuiElementClick",
function( element )
{
	//local element = tostring(element)

	foreach (idx, value in gridlist_table) 
	{	
		if (element != value)
		{
			gridlist_window = value
			gridlist_lable = element
			gridlist_select = true
			break
		}
	}

	//sendMessage(guiGridListGetItemText (element))
})