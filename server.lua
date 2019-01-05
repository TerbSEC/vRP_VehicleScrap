local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local scrapprices = {
	{id = 0, price = 3600}, --compacts
	{id = 1, price = 4000}, --sedans
	{id = 2, price = 5200}, --SUV's
	{id = 3, price = 6400}, --coupes
	{id = 4, price = 5000}, --muscle
	{id = 5, price = 6500}, --sport classic
	{id = 6, price = 7200}, --sport
	{id = 7, price = 11000}, --super
	{id = 8, price = 2200}, --motorcycle
	{id = 9, price = 3800}, --offroad
	{id = 10, price = 4400}, --industrial
	{id = 11, price = 3400}, --utility
	{id = 12, price = 3400}, --vans
	{id = 13, price = 400}, --bicycles
	{id = 14, price = 2000}, --boats
	{id = 15, price = 8200}, --helicopter
	{id = 16, price = 9000}, --plane
	{id = 17, price = 2900}, --service
	{id = 18, price = 5000}, --emergency
	{id = 19, price = 6200}, --military
	{id = 20, price = 3400} --commercial
}



-- GROUPS
-- WHO HAVE ACCESS TO SCRAP VEHICLES
local groups = {"Mechanic"};


RegisterServerEvent("vRP_VehicleScrap:getVehPrice")
AddEventHandler("vRP_VehicleScrap:getVehPrice", function(class)
	for k, price in pairs(scrapprices) do
		if class == price.id then
			vehPrice = price.price
			TriggerClientEvent("setVehPrice", -1, vehPrice)
		end
	end
end)

RegisterServerEvent("vRP_VehicleScrap:SellVehicle")
AddEventHandler("vRP_VehicleScrap:SellVehicle", function(vehPrice)
	local user_id = vRP.getUserId({source})
    vRP.giveBankMoney({user_id,vehPrice})
end)

RegisterServerEvent('vRP_VehicleScrap:Mechanic')
AddEventHandler('vRP_VehicleScrap:Mechanic', function(triggerevent)
	local source = source
    local user_id = vRP.getUserId({source})
    for k,v in ipairs(groups) do
		if vRP.hasGroup({user_id,v}) then
      		TriggerClientEvent(triggerevent, source)
    	else
     		TriggerClientEvent("pNotify:SendNotification", source,{text = "You are not a Mechanic", type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
     	end
    end
end)
