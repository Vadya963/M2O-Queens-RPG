print("SCRIPT CUSTOM_EVENTS LOADED")

local event_t = {}

function _addEventHandler (eventName, attachedTo, handlerFunction, getPropagated = true)//string eventName, id,ud or "root" attachedTo, function handlerFunction, bool getPropagated = true
{
	print("_addEventHandler "+eventName+" "+attachedTo+" "+getPropagated)
	if (type(attachedTo) == "integer") 
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
	else if (type(attachedTo) == "userdata") 
	{
		if (!event_t.rawin(eventName))
		{
			event_t[eventName] <- {}
		}

		if (!event_t[eventName].rawin(attachedTo))
		{
			event_t[eventName][attachedTo] <- []
		}

		event_t[eventName][attachedTo.tostring()].push([handlerFunction,getPropagated])//попробовать без tostring
	}
	else if (type(attachedTo) == "string" && attachedTo == "root" ) 
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
}

function _removeEventHandler (eventName, attachedTo, handlerFunction)//string eventName, element attachedTo, function handlerFunction
{
	print("_removeEventHandler "+eventName+" "+attachedTo)
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
	//вызываются все евенты которые getPropagated true, если false то те которые baseElement == attachedTo, добавить проверку на getPropagated где не root
	if (!event_t.rawin(eventName))
	{
		return
	}

	print("triggerEvent "+eventName+" "+baseElement)

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

	print("triggerEventM2O "+eventName)

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

	if (eventName.find("onPlayer") == 0)
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
	else if (eventName.find("onVehicle") == 0)
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

addEventHandler ("onPlayerConnect", 
function (playerid, name, ip, serial) 
{
	triggerEventM2O ("onPlayerConnect", playerid, name, ip, serial)
	print("triggerEventM2O onPlayerConnect m2o ")
	triggerEvent ("PlayerConnect", "root")
	print("triggerEvent PlayerConnect m2o ")
})

addEventHandler ("onPlayerDisconnect", 
function (playerid, reason) 
{
	triggerEventM2O ("onPlayerDisconnect", playerid, reason)
})

addEventHandler ("onPlayerSpawn", 
function (playerid) 
{
	triggerEventM2O ("onPlayerSpawn", playerid)
})

addEventHandler ("onPlayerDeath", 
function (playerid, killerid) 
{
	triggerEventM2O ("onPlayerDeath", playerid, killerid)
})

addEventHandler ("onPlayerVehicleEnter", 
function (playerid, vehicleid, seat) 
{
	triggerEventM2O ("onPlayerVehicleEnter", playerid, vehicleid, seat)
})

addEventHandler ("onPlayerChat", 
function (playerid, chattext) 
{
	triggerEventM2O ("onPlayerChat", playerid, chattext)
})

addEventHandler ("onScriptInit", 
function () 
{
	triggerEventM2O ("onScriptInit")
	print("triggerEventM2O onScriptInit m2o ")
})