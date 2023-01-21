print("CLIENT SCRIPTS LOADED")

local event_t = {}

function _addEventHandler (eventName, attachedTo, handlerFunction, getPropagated = true)//string eventName, id,ud or "root" attachedTo, function handlerFunction, bool getPropagated = true
{
	if (!event_t.rawin(eventName))
	{
		event_t[eventName] <- {}
	}

	if (!event_t[eventName].rawin(attachedTo))
	{
		event_t[eventName][attachedTo] <- []
	}

	event_t[eventName][attachedTo].push([handlerFunction,getPropagated])
}

function _removeEventHandler (eventName, attachedTo, handlerFunction)//string eventName, element attachedTo, function handlerFunction
{
	if (event_t.rawin(eventName) && event_t[eventName].rawin(attachedTo))
	{
		foreach (idx, v in event_t[eventName][attachedTo]) 
		{
			if (v[0] == handlerFunction)
			{
				event_t[eventName][attachedTo].remove(idx)
				return
			}
		}
	}
}

function triggerEvent (eventName, baseElement, ...)//string eventName, id,ud or "root" baseElement, [ var argument1, ... ]
{
	//если вызвать эвент с root, сработают все функции добавлянные в root и те которые были добавленны к эвенту который был указан при триггере
	//вызываются все евенты которые getPropagated true, если false то те которые baseElement == attachedTo
	if (!event_t.rawin(eventName))
	{
		return
	}

	if (baseElement == "root" && event_t[eventName].rawin("root"))
	{
		foreach (idx, v in event_t[eventName]["root"]) 
		{
			if (vargv.len() == 0)
			{
				v[0]()
			}
			else if (vargv.len() == 1)
			{
				v[0](vargv[0])
			}
			else if (vargv.len() == 2) 
			{
				v[0](vargv[0],vargv[1])
			}
			else if (vargv.len() == 3) 
			{
				v[0](vargv[0],vargv[1],vargv[2])
			}
			else if (vargv.len() == 4) 
			{
				v[0](vargv[0],vargv[1],vargv[2],vargv[3])
			}
			else if (vargv.len() == 5) 
			{
				v[0](vargv[0],vargv[1],vargv[2],vargv[3],vargv[4])
			}
		}

		foreach (idx, value in event_t[eventName]) 
		{
			if (idx != "root")
			{
				foreach (idx, v in event_t[eventName][idx]) 
				{
					if (vargv.len() == 0)
					{
						if (v[1])
						{
							v[0]()
						}
					}
					else if (vargv.len() == 1)
					{
						if (v[1])
						{
							v[0](vargv[0])
						}
					}
					else if (vargv.len() == 2) 
					{
						if (v[1])
						{
							v[0](vargv[0],vargv[1])
						}
					}
					else if (vargv.len() == 3) 
					{
						if (v[1])
						{
							v[0](vargv[0],vargv[1],vargv[2])
						}
					}
					else if (vargv.len() == 4) 
					{
						if (v[1])
						{
							v[0](vargv[0],vargv[1],vargv[2],vargv[3])
						}
					}
					else if (vargv.len() == 5) 
					{
						if (v[1])
						{
							v[0](vargv[0],vargv[1],vargv[2],vargv[3],vargv[4])
						}
					}
				}
			}
		}

		return
	}
	
	if (event_t[eventName].rawin(baseElement))
	{
		foreach (idx, v in event_t[eventName][baseElement]) 
		{
			if (vargv.len() == 0)
			{
				v[0]()
			}
			else if (vargv.len() == 1)
			{
				v[0](vargv[0])
			}
			else if (vargv.len() == 2) 
			{
				v[0](vargv[0],vargv[1])
			}
			else if (vargv.len() == 3) 
			{
				v[0](vargv[0],vargv[1],vargv[2])
			}
			else if (vargv.len() == 4) 
			{
				v[0](vargv[0],vargv[1],vargv[2],vargv[3])
			}
			else if (vargv.len() == 5) 
			{
				v[0](vargv[0],vargv[1],vargv[2],vargv[3],vargv[4])
			}
		}
	}
}

function triggerEventM2O (eventName, ...)//максимум 5 аргументов
{
	if (!event_t.rawin(eventName))
	{
		return
	}

	if (event_t[eventName].rawin("root"))
	{
		foreach (idx, v in event_t[eventName]["root"]) 
		{
			if (vargv.len() == 0)
			{
				if (v[1])
				{
					v[0]()
				}
			}
			else if (vargv.len() == 1)
			{
				if (v[1])
				{
					v[0](vargv[0])
				}
			}
			else if (vargv.len() == 2) 
			{
				if (v[1])
				{
					v[0](vargv[0],vargv[1])
				}
			}
			else if (vargv.len() == 3) 
			{
				if (v[1])
				{
					v[0](vargv[0],vargv[1],vargv[2])
				}
			}
			else if (vargv.len() == 4) 
			{
				if (v[1])
				{
					v[0](vargv[0],vargv[1],vargv[2],vargv[3])
				}
			}
			else if (vargv.len() == 5) 
			{
				if (v[1])
				{
					v[0](vargv[0],vargv[1],vargv[2],vargv[3],vargv[4])
				}
			}
		}
	}

	if (eventName.find("onGui") == 0)
	{
		if (event_t[eventName].rawin(vargv[0]))
		{
			foreach (idx, v in event_t[eventName][vargv[0]]) 
			{
				if (vargv.len() == 0)
				{
					v[0]()
				}
				else if (vargv.len() == 1)
				{
					v[0](vargv[0])
				}
				else if (vargv.len() == 2) 
				{
					v[0](vargv[0],vargv[1])
				}
				else if (vargv.len() == 3) 
				{
					v[0](vargv[0],vargv[1],vargv[2])
				}
				else if (vargv.len() == 4) 
				{
					v[0](vargv[0],vargv[1],vargv[2],vargv[3])
				}
				else if (vargv.len() == 5) 
				{
					v[0](vargv[0],vargv[1],vargv[2],vargv[3],vargv[4])
				}
			}
		}
	}
}

addEventHandler ("onClientPlayerConnect", 
function (playerid, nickname) 
{
	triggerEventM2O ("onClientPlayerConnect", playerid, nickname)
})

addEventHandler ("onClientPlayerDisconnect", 
function (playerid) 
{
	triggerEventM2O ("onClientPlayerDisconnect", playerid)
})

addEventHandler ("onClientPlayerMoveStateChange", 
function (playerid, oldMoveState, newMoveState) 
{
	triggerEventM2O ("onClientPlayerMoveStateChange", playerid, oldMoveState, newMoveState)
})

addEventHandler ("onClientPlayerDeath", 
function (playerid) 
{
	triggerEventM2O ("onClientPlayerDeath", playerid)
})

/*addEventHandler ("onClientChat", //перестают работать серверные команды
function (text, isCommand) 
{
	triggerEventM2O ("onClientChat", text, isCommand)
})*/

/*addEventHandler ("onTakeDamage", //игрок перестаёт получать урон
function () 
{
	triggerEventM2O ("onTakeDamage")
})*/

addEventHandler ("onClientVehicleRespawn", 
function (vehicleid) 
{
	triggerEventM2O ("onClientVehicleRespawn", vehicleid)
})

addEventHandler ("onClientProcess", 
function () 
{
	triggerEventM2O ("onClientProcess")
})

addEventHandler ("onClientChangeNick", 
function (newNickname, oldNickname) 
{
	triggerEventM2O ("onClientChangeNick", newNickname, oldNickname)
})

addEventHandler ("onClientScreenshot", 
function (name, path) 
{
	triggerEventM2O ("onClientScreenshot", name, path)
})

addEventHandler ("onClientDeviceReset", 
function () 
{
	triggerEventM2O ("onClientDeviceReset")
})

addEventHandler ("onClientFocusChange", 
function (lost) 
{
	triggerEventM2O ("onClientFocusChange", lost)
})

/*addEventHandler ("onClientFramePreRender", 
function () 
{
	triggerEventM2O ("onClientFramePreRender")
})*/

/*addEventHandler ("onClientFrameRender", вызывает проблемы squirrel
function (post) 
{
	triggerEventM2O ("onClientFrameRender", post)
})*/

/*addEventHandler ("onClientOpenMap",
function () 
{
	triggerEventM2O ("onClientOpenMap")
	openMap()//если не добавить перестанет открываться карта
})

addEventHandler ("onClientCloseMap", 
function () 
{
	triggerEventM2O ("onClientCloseMap")
})*/

addEventHandler ("onClientScriptExit", 
function () 
{
	triggerEventM2O ("onClientScriptExit")
})

addEventHandler ("onClientScriptInit", 
function () 
{
	triggerEventM2O ("onClientScriptInit")
})

addEventHandler ("onGuiElementClick", 
function (element) 
{
	triggerEventM2O ("onGuiElementClick", element)
})

addEventHandler ("onGuiElementMouseEnter", 
function (element) 
{
	triggerEventM2O ("onGuiElementMouseEnter", element)
})

addEventHandler ("onGuiElementMouseLeave", 
function (element) 
{
	triggerEventM2O ("onGuiElementMouseLeave", element)
})

addEventHandler ("onGuiElementMove", 
function (element) 
{
	triggerEventM2O ("onGuiElementMove", element)
})

addEventHandler ("onGuiElementResize", 
function (element) 
{
	triggerEventM2O ("onGuiElementResize", element)
})

addEventHandler ("onGuiElementSelectionChange", 
function (element) 
{
	triggerEventM2O ("onGuiElementSelectionChange", element)
})

addEventHandler ("onGuiElementSortColumn", 
function (element) 
{
	triggerEventM2O ("onGuiElementSortColumn", element)
})

addEventHandler ("onGuiElementTabChange", 
function (element) 
{
	triggerEventM2O ("onGuiElementTabChange", element)
})

addEventHandler ("onGuiElementTextAccept", 
function (element) 
{
	triggerEventM2O ("onGuiElementTextAccept", element)
})

addEventHandler ("onGuiElementTextChange", 
function (element) 
{
	triggerEventM2O ("onGuiElementTextChange", element)
})

addEventHandler ("onGuiElementDoubleClick", 
function (element) 
{
	triggerEventM2O ("onGuiElementDoubleClick", element)
})

addEventHandler ("onHudTimerComplete", 
function () 
{
	triggerEventM2O ("onHudTimerComplete")
})