vRP = Proxy.getInterface("vRP")


-- PLEASE DO NOT CHANGE
local vehPrice = nil
local modPrice = vehPrice

-- CAN BE CHANGES
local key = 38 -- E (SELL BUTTON >> https://docs.fivem.net/game-references/controls/)

-- SCRAP LOCATIONS
scrapyards = {
	{-457.43835449219,-1714.2873535156,17.820441894531},
	{1091.9002685547,3588.9992675781,32.7793995513916},
	{-128.37242126465,6214.96484375,30.209449249268}
}


--------------------------------------------------------------------
      -- >> DRAWMARKER AND THINGS LIKE THAT FUNCTION
--------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i = 1, #scrapyards do
			scrapCoords2 = scrapyards[i] --
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), scrapCoords2[1], scrapCoords2[2], scrapCoords2[3], true ) < 40 then
	   			if IsPedSittingInAnyVehicle(PlayerPedId()) then
					DrawMarker(27, scrapCoords2[1], scrapCoords2[2], scrapCoords2[3], 0, 0, 0, 0, 0, 0, 5.75, 5.75, 5.75, 53, 146, 0, 100, 0, 0, 0, 1)
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), scrapCoords2[1], scrapCoords2[2], scrapCoords2[3], true ) < 3 then
						drawTxt("Press ~g~E~s~ to scratch your vehicle",0,1,0.5,0.95,0.6,255,255,255,255)
						if IsControlJustPressed(1, key) then
							local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
							if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
								local plate = GetVehicleNumberPlateText(veh)
								if string.sub(plate, 1, 8) == "P " .. vRP.getRegistrationNumber({}) then
									TriggerEvent("pNotify:SendNotification",{text = "You can not scratch your own vehicle!",type = "error",timeout = (1500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
								else
									if vehPrice ~= nil then
										local health = GetEntityHealth(GetVehiclePedIsIn(PlayerPedId()))
										local modifier = health/1000
										modPrice = math.floor((modifier * vehPrice), 0)
									else
										local class = GetVehicleClass(veh)
										TriggerServerEvent("vRP_VehicleScrap:getVehPrice", class)
									end

									if string.sub(plate, 1, 2) == "P " then
										TriggerServerEvent('vRP_VehicleScrap:Mechanic', "vRP_VehicleScrap:Success") -- PLAYER VEHICLE
									else
										TriggerServerEvent('vRP_VehicleScrap:Mechanic', "vRP_VehicleScrap:SuccessNPC") -- NPC VEHICLE
									end
								end
							else
								TriggerEvent("pNotify:SendNotification",{text = "You need to be the driver of the vehicle!",type = "error",timeout = (1500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
							end
						end
					end
	   			end
	  		end
		end
  	end
end)

--------------------------------------------------------------------
--------------------------------------------------------------------




--------------------------------------------------------------------
      -- >> SELL FUNCTION
--------------------------------------------------------------------

RegisterNetEvent("vRP_VehicleScrap:SuccessNPC")
AddEventHandler("vRP_VehicleScrap:SuccessNPC", function() -- NPC VEHICLE
	TriggerEvent("pNotify:SendNotification",{text = "You have scrapped the vehicle for 1000$",type = "success",timeout = (3500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
	TriggerServerEvent("scrap:SellVehicle", 1000)
	local vehicle = SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1)), true, true)
	DeleteEntity(vehicle)
end)

RegisterNetEvent("vRP_VehicleScrap:Success")
AddEventHandler("vRP_VehicleScrap:Success", function() -- PLAYER VEHICLE
	if vehPrice == nil then
		TriggerEvent("pNotify:SendNotification",{text = "You can not sell this vehicle",type = "success",timeout = (3000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
	else
		TriggerEvent("pNotify:SendNotification",{text = "You have scrapped the vehicle for "..modPrice.."$",type = "success",timeout = (3500),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		TriggerServerEvent("vRP_VehicleScrap:SellVehicle", modPrice)
		local vehicle = SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1)), true, true)
		DeleteEntity(vehicle)
		vehPrice = nil
	end
end)

RegisterNetEvent("setVehPrice")
AddEventHandler("setVehPrice", function(price)
	vehPrice = price
end)

--------------------------------------------------------------------
--------------------------------------------------------------------




--------------------------------------------------------------------
      -- >> BLIPS
--------------------------------------------------------------------


local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		for i = 1, #scrapyards do
			garageCoords = scrapyards[i]
			stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
			SetBlipSprite(stationBlip, 467)
			SetBlipDisplay(stationBlip, 2)
			SetBlipScale(stationBlip, 1.0)
			SetBlipColour(stationBlip, 69)
			SetBlipAlpha(stationBlip, 255)
			SetBlipAsShortRange(stationBlip, true)
			BeginTextCommandSetBlipName("String")
			AddTextComponentString("Scrap")
			EndTextCommandSetBlipName(stationBlip)
			firstspawn = 1
		end
	end
end)

--------------------------------------------------------------------
--------------------------------------------------------------------




--------------------------------------------------------------------
      -- >> DRAW FUNCTION
--------------------------------------------------------------------

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(6)
	SetTextProportional(6)
	SetTextScale(scale/1.0, scale/1.0)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--------------------------------------------------------------------
--------------------------------------------------------------------
