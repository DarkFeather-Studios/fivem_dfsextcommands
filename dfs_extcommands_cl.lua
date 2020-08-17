local IsDebugBuild = false

RegisterCommand("spectate", function (source, args, raw) --BROKEN; Used new ded DFS
	if not exports.db_perms:HasPermission("spectate", 996) then return end
	local PlayerIDToSpectate = tonumber(args[1])
	local ActivePlayerPed = exports.dfs:GetActivePed()
	if ActivePlayerPed ~= PlayerPedId() then
		NetworkSetInSpectatorMode(false, ActivePlayerPed)
		exports.dfs:SetActivePed(PlayerPedId())
	end
	if PlayerIDToSpectate then
		ActivePlayerPed = GetPlayerPed(GetPlayerFromServerId(PlayerIDToSpectate))
		NetworkSetInSpectatorMode(true, ActivePlayerPed)
		exports.dfs:SetActivePed(ActivePlayerPed)
	end

end)

RegisterCommand("setjob", function (source, args, raw)
	if not exports.db_perms:HasPermission("setjob", 997) then return end
	local Target = tonumber(args[1])
	local JobName = args[2]
	local JobGrade = tonumber(args[3])
	if not Target or not JobName or not JobGrade then return end --add alert for failure
	TriggerServerEvent("dfsec:SetJob", Target, JobName, JobGrade)
end)

RegisterCommand("armor", function (source, args, raw)
	if not exports.db_perms:HasPermission("armor", 998) then return end
	SetPedArmour(GetPlayerPed(-1), tonumber(args[1]))
end)

RegisterCommand("roll", function (source, args, raw)
	local diceside = tonumber(args[1]) or 6
	local dicecount= tonumber(args[2]) or 1
	local Roll = math.random(dicecount, diceside*dicecount)

    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank") do
        RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
        Citizen.Wait(0)
	end
	
	TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(1500)
	ClearPedTasks(GetPlayerPed(-1))
	TriggerServerEvent('3dme:shareDisplay', string.format("Rolled a total of %d on %d %d-sided dice.", Roll, dicecount, diceside))
end)

RegisterCommand("tpto", function (source, args, raw)
	if not exports.db_perms:HasPermission("tpto", 996) then return end
	local x,y,z = tonumber(args[1])+0.1, tonumber(args[2])+0.1, tonumber(args[3])+0.1
	if x == nil then x = -1.0 end
	if y == nil then y = -1.0 end
	if z == nil then z = -1.0 end
	SetEntityCoords(GetPlayerPed(-1), x, y, z, true, true, true, true)
end)



RegisterCommand("showjob", function (source, args, raw) TriggerServerEvent("dfsec:GetJob") end)

RegisterCommand("batman", function (source, args, raw) SetNightvision(true) end)
RegisterCommand("unbatman", function (source, args, raw) SetNightvision(false) end)


RegisterCommand("goto", function (source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("goto", 950) then return end
	else
		if not exports.db_perms:HasPermission("goto", 996) then return end
	end
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(args[1]))), true))
	SetEntityCoords(GetPlayerPed(-1), x, y, z, 1, 1, 1, 0)
end)



RegisterCommand("pos", function (source, args, raw)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	local head = GetEntityHeading(GetPlayerPed(-1))
	TriggerEvent("alerts:add", {255, 255, 255}, {40, 183, 40}, "Pos", string.format("Your position is; X:%.2f Y:%.2f, Z:%.2f, Heading:%.0f", x,y,z,head))
end)

RegisterCommand("kick", function(source, args, raw)
	if not exports.db_perms:HasPermission("kick", 997) then return end
	if (#args < 2) then 
		TriggerEvent("alerts:add", {255, 255, 255}, {255, 74, 0}, "kick", "Usage: /kick <victim_id (INT)> <reason (STRING >=3)") return
	end

	local ID =tonumber(args[1])
	local reason = ""
	local ind = 0

	for k, v in pairs(args) do
	
		if (ind > 0) then reason = reason .. " " .. v end
		ind = ind+1
	end
	
	if #reason < 3 then
		TriggerEvent("alerts:add", {255, 255, 255}, {255, 74, 0}, "kick", "Must include a reason longer than that!")
		return
	end
	
	TriggerServerEvent("kick", GetPlayerServerId(PlayerId()), ID, reason)
end)


RegisterCommand("lv", function(source, args, raw)
	if not exports.dfs_PoliceJob:IsInSpawnFixArea() and not exports.db_perms:HasPermission("kick", 997) then return end
	if (GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= nil) then SetVehicleLivery(GetVehiclePedIsIn(GetPlayerPed(-1), false), tonumber(args[1])) end 
end)


RegisterCommand("dropdead",function(source, args, raw)
	if exports.dfs_PoliceJob:IsCuffed() and not exports.dfs_deathmanager:IsDead() then
		return
	end
	--SetEntityHealth(GetPlayerPed(-1), 0)
	TriggerEvent('esx_status:set', 'Health', 0)
end)

RegisterCommand("getmoney", function (source, args, raw)
	if not exports.db_perms:HasPermission("getmoney", 998) then return end
	TriggerServerEvent("dfsec:AddCash", tonumber(args[1]), tonumber(args[2]))
end)

RegisterCommand("getitem", function (source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("getitem", 950) then return end
	else
		if not exports.db_perms:HasPermission("getitem", 997) then return end
	end
	local Count = tonumber(args[2]) or 1
	TriggerServerEvent("dfsec:AddItem", args[1], Count)
end)

RegisterCommand("getweapon", function (source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("getweapon", 950) then return end
	else
		if not exports.db_perms:HasPermission("getweapon", 998) then return end
	end
	local weaponname = "WEAPON_" .. string.upper(args[1])
	TriggerServerEvent("dfsec:AddItem", weaponname, 1)
	--GiveDelayedWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponname), ammocount, true)
end)

RegisterCommand("extra", function(source, args, raw)
	if not exports.dfs_PoliceJob:IsInSpawnFixArea() and not exports.db_perms:HasPermission("extra", 997) then return end
	local extra = -1
	local onoff = tonumber(args[2])
	local CurrentVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	if onoff == 1 then onoff = 0
	else onoff = 1 end

	if not CurrentVeh then return end

	if string.lower(tostring(args[1])) == "all" then extra = 255
	else extra = tonumber(args[1]) end

	if extra == -1 then TriggerEvent("alerts:add", {255, 255, 255}, {255, 74, 0}, "extra", "Usage: /extra <str \"all\"||int extra> <bool int onoff>") end

	if extra == 255 then
		while extra > -1 do
			if DoesExtraExist(CurrentVeh, extra) then SetVehicleExtra(CurrentVeh, extra, onoff) end
			extra = extra - 1
		end
	else SetVehicleExtra(CurrentVeh, extra, onoff) end
end)

function advertise (args)
	local BroadcastReason = "No Reason Specifed"
	local MyIdentity = exports.dfs:GetMyIdentity()
    if #args > 0 then
        BroadcastReason = ""
        for k, v in pairs(args) do
            BroadcastReason = BroadcastReason .. v .. " "
        end
	end

	TriggerServerEvent("alerts:sendto", -1, {255, 255, 255}, {219, 177, 70}, string.format("Ad; %s %s [%s]", MyIdentity.FirstName, MyIdentity.LastName, MyIdentity.PhoneNumber), BroadcastReason)
end

RegisterCommand("advertise", function(source, args, raw)
	advertise(args)
end)
RegisterCommand("ad", function(source, args, raw)
	advertise(args)
end)

RegisterCommand("classified", function (source, args, raw)
	local BroadcastReason = "No Reason Specifed"
	local MyIdentity = exports.dfs:GetMyIdentity()
    if #args > 0 then
        BroadcastReason = ""
        for k, v in pairs(args) do
            BroadcastReason = BroadcastReason .. v .. " "
        end
	end
	
	TriggerServerEvent("alerts:sendto", -1, {0, 0, 0}, {221, 226, 142}, string.format("Classified; %s %s [%s]",MyIdentity.FirstName, MyIdentity.LastName, MyIdentity.PhoneNumber), BroadcastReason)
end)

--[[
local function RepairVehicle(vehicle)

    local REPAIR_TIME     = 1000 * 10
    local repair_time_end = REPAIR_TIME + GetGameTimer()
    local player_ped      = GetPlayerPed(-1)
    exports['progressBars']:startUI(REPAIR_TIME, "Reparing")
    while true do

        if GetGameTimer() >= repair_time_end then
            exports['progressBars']:closeUI()
            SetVehiclePetrolTankHealth(vehicle, 1000)
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleFixed(vehicle)
            return
        elseif GetEntitySpeed(vehicle) == 0 and GetVehiclePedIsIn(player_ped) == vehicle then
            Citizen.Wait(10)
        else
            exports['progressBars']:closeUI()
            exports['mythic_notify']:SendAlert('error', 'Reparing stopped', 1000 * 5)
            return
        end

    end

end]]

RegisterCommand('clear', function(source, args)
    TriggerEvent('chat:clear')
end)

function table.Contains(set, item)
    for key, value in pairs(set) do
        if value == item then return true end
    end
    return false
end


RegisterCommand("dv", function (source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("dv", 950) then return end
	else
		if not exports.db_perms:HasPermission("dv", 995) then return end
	end
	local deleteDistance = -1
	if #args == 1 then deleteDistance = tonumber(args[1]) end

	local failed = 0
	local Tried = 0

	if deleteDistance > 0 then
		local pX, pY, pZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		for k, vehicle in pairs(exports.dfs:GetAllVehicles()) do
			local vX, vY, vZ = table.unpack(GetEntityCoords(vehicle))
			local Dist = GetDistanceBetweenCoords(vX, vY, vZ, pX, pY, pZ, true)
			
			if Dist <= deleteDistance then
				exports.dfs:DeleteVehicleAsync(vehicle, function(DidDelete) Tried = Tried + 1; if not DidDelete then failed = failed + 1 end end)
			end
		end

		for k, ped in pairs(exports.dfs:GetAllPeds()) do
			if not IsPedAPlayer(ped) and IsPedDeadOrDying(ped) then
				local vX, vY, vZ = table.unpack(GetEntityCoords(ped))
				local Dist = GetDistanceBetweenCoords(vX, vY, vZ, pX, pY, pZ, true)
				if Dist <= deleteDistance then
					exports.dfs:DeleteVehicleAsync(ped, function(DidDelete) Tried = Tried + 1; if not DidDelete then failed = failed + 1 end end)
				end
			end
		end
		Wait(10000)

		--TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@oh_snap", "oh_snap", 8.0f, 8.0f, -1, 0, 1.0f, false, false, false)

		if failed > 0 then
			TriggerEvent("alerts:add", {255, 255, 255}, {216, 180, 0}, "DV", 
			string.format("Failed to remove %d of %d entities; They are in use by other players!", failed, Tried))
		else
			TriggerEvent("alerts:add", {255, 255, 255}, {40, 183, 40}, "DV", "Removed " .. Tried .. " vehicles.")
		end
	else
		local CurrVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local Success = exports.dfs:DeleteVehicle(CurrVeh)
		if not Success then TriggerEvent("alerts:add", {255, 255, 255}, {40, 183, 40}, "DV", "You are not the driver!") end
	end
end)


RegisterCommand("car", function(source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("car", 950) then return end
	else
		if not exports.db_perms:HasPermission("car", 997) then return end
	end
	Car(args[1], 0, source)
end)

function Car(model, heading, source)
	local model = model or "asea"

	--Citizen.Trace(string.format("CarName:%s Hash:%d IsInGame:%s IsCar:%s", model, hash, tostring(IsModelInCdimage(hash)), tostring(IsModelAVehicle(hash))))
	if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
		TriggerEvent("alerts:add", {255, 255, 255}, {255, 74, 0}, "car", "No such vehicle!")
		return
	end

	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end

	local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	local Heading = GetEntityHeading(GetPlayerPed(-1))
	local NewCar = CreateVehicle(model, px, py, pz, Heading, true, false)
	SetEntityHeading(NewCar, Heading)

	
	SetPedIntoVehicle(GetPlayerPed(-1), NewCar, -1)
	SetEntityAsNoLongerNeeded(NewCar)
	NetworkRegisterEntityAsNetworked(NewCar)
	Wait(0)
	--Citizen.Trace("Networked?; "..tostring(NetworkGetEntityIsNetworked(NewCar)).."\n")

	TriggerEvent("dfscl:GetKeysForCar", GetVehicleNumberPlateText(NewCar))
end

local CanPoof = false
function tpwaypoint()
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("tpwaypoint", 950) then return end
	else
		if not exports.db_perms:HasPermission("tpwaypoint", 996) then return end
	end
	local WP = GetFirstBlipInfoId(8)
	if DoesBlipExist(WP) then
		local x,y,z = table.unpack(GetBlipCoords(WP))
		local GroundZ
		local _z = 2000

		--[[repeat
			RequestCollisionAtCoord(x,y,_z)
            Wait(0)
			GroundZ = GetGroundZFor_3dCoord(x, y, _z, false)
			--Citizen.Trace(tostring(GetGroundZFor_3dCoord(x, y, _z, false)).."\n")
			_z = _z - 100
			if _z < -300 then _z = 2000 end
		until GroundZ]]

		local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
		--TriggerServerEvent("dfsec:StartTeleportSequence", x, y, GroundZ, px, py, pz)
		--while not CanPoof do Wait(0) end
		SetEntityCoords(GetPlayerPed(-1), x,y,2000, false, false, false, true)
		CanPoof = false
		Wait(0)
		local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local _, groundz
		repeat
			SetEntityCoords(GetPlayerPed(-1), px,py,pz, false, false, false, true)
			_, groundz = GetGroundZFor_3dCoord(px,py,pz,false)
			pz = pz - 47
			Wait(0)
		until groundz ~= 0.0 and groundz ~= 0
		SetEntityCoords(GetPlayerPed(-1), px,py,groundz, false, false, false, true)
	end
end

RegisterCommand("tpwaypoint", tpwaypoint)
RegisterCommand("tpm", tpwaypoint)

local Invuln = false
RegisterCommand("godmode", function()
	if not exports.db_perms:HasPermission("godmode", 998) then return end
	SetPlayerInvincible(PlayerId(), not Invuln)
	Invuln = not Invuln
end)

RequestAnimDict("amb@world_human_maid_clean@")
RegisterCommand("clean", function ()
	if exports.dfs_mechjob:IsMechanic() then 
	local CV = exports.dfs:GetVehicleInFrontOfMe()
	if DoesEntityExist(CV) and not IsPedInAnyVehicle(PlayerPedId(), false) then 
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
		--TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_maid_clean@", "base", 8.0, 8.0, 5000, 16, 0.0, false, false, false)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "cleancar",
			duration = 5000,
			label = "Cleaning Car...",
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
		}, function(status) --if cancelled
			ClearPedTasksImmediately(GetPlayerPed(-1))
			if status then  
				return
			end
				SetVehicleDirtLevel(CV, 0.0)
			end)
		end
	end
end)

RegisterCommand("staff", function(source, args, raw)
	if exports.db_perms:HasPermission("staffchat", 996) then
		local message = ""
		for k, v in pairs(args) do
			message = message .. v .. " "
		end
		if #message == 0 then return end
		TriggerServerEvent("alerts:AddByPerms", {0, 0, 0}, {0, 255, 255}, "Staff #"..GetPlayerServerId(PlayerId()), message, 996)
	end
end)

RegisterCommand("admin", function(source, args, raw)
	if exports.db_perms:HasPermission("staffchat", 998) then
		local message = ""
		for k, v in pairs(args) do
			message = message .. v .. " "
		end
		if #message == 0 then return end
		TriggerServerEvent("alerts:AddByPerms", {0, 0, 0}, {255, 0, 255}, "Staff #"..GetPlayerServerId(PlayerId()), message, 998)
	end
end)

RegisterCommand("report", function(source, args, raw)
    local message = ""
    for k, v in pairs(args) do
        message = message .. v .. " "
    end
    if #message == 0 then return end
    TriggerServerEvent("alerts:AddByPerms", {255, 96, 96}, {0, 0, 0}, "^0Report #"..GetPlayerServerId(PlayerId()), "^7" .. message, 996)
    TriggerEvent("alerts:add", {196, 96, 96}, {0, 0, 0}, "^0You Reported", "^7" .. message)
end)

RegisterCommand("reportr", function(source, args, raw)
	local destPlayer = table.remove(args, 1)
	local message = ""
	for k, v in pairs(args) do
        message = message .. v .. " "
	end
	TriggerServerEvent("alerts:AddByPerms", {255, 96, 96}, {0, 0, 0}, "^0" .. GetPlayerServerId(PlayerId()) .. " Responded To ".. tostring(destPlayer), "^7" .. message, 996)
	TriggerServerEvent("alerts:sendto", tonumber(destPlayer), {255, 96, 96}, {0, 0, 0}, "^0Response From "..GetPlayerServerId(PlayerId()), "^7" .. message)
end)

RegisterCommand("sreport", function(source, args, raw)
    local message = ""
    for k, v in pairs(args) do
        message = message .. v .. " "
    end
    if #message == 0 then return end
    TriggerServerEvent("alerts:AddByPerms", {196, 96, 96}, {0, 0, 0}, "Secure Report #"..GetPlayerServerId(PlayerId()), message, 998)
    TriggerEvent("alerts:add", {196, 96, 96}, {0, 0, 0}, "Your Secure Report #"..GetPlayerServerId(PlayerId()), message)
end)

RegisterCommand("slay", function(source, args, raw)
	if not exports.db_perms:HasPermission("heal", 997) then return end
		if #args == 1 then TriggerServerEvent("dfsec:SlayPlayer", tonumber(args[1]) or 0) return
		else if #args == 2 then
			for PlayerId, PlayerNetworkId in pairs(exports.dfs:GetAllPlayers()) do
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(PlayerNetworkId)), GetEntityCoords(PlayerPedId())) < tonumber(args[1]) and PlayerNetworkId ~= PlayerId() then
					TriggerServerEvent("dfsec:SlayPlayer", PlayerId)
				end
			end
		end
	end
end)

RegisterNetEvent("dfsec:Slay")
AddEventHandler("dfsec:Slay", function()
	--SetEntityHealth(PlayerPedId(), 0)
	TriggerEvent('esx_status:set', 'Health', 0)
end)

RegisterCommand("heal", function (source, args, raw)
	if IsDebugBuild then
		if not exports.db_perms:HasPermission("heal", 950) then return end
	else
		if not exports.db_perms:HasPermission("heal", 998) then return end
	end
	Citizen.Trace("Sent heal request for "..(tonumber(args[1]) or GetPlayerServerId(PlayerId())).."\n")
	TriggerServerEvent("dfsec:HealPlayer", tonumber(args[1]) or GetPlayerServerId(PlayerId()))
end)



RegisterNetEvent("dfsec:HealMe")
AddEventHandler("dfsec:HealMe", function (target)
	if exports.dfs_deathmanager:IsDead() then
		exports.dfs_deathmanager:Respawn(true)
	end
	exports.mythic_hospital:ResetAll()
	exports.dfs_stats:ResetStats()
end)

RegisterCommand("fetch", function(source, args, raw)
	if not exports.db_perms:HasPermission("fetch", 996) then return end
	exports.dfs:TriggerServerCallback("dfsex:FetchPlayer", function() end, tonumber(args[1]), GetEntityCoords(PlayerPedId()))
end)

AddEventHandler("onClientResourceStart", function (resourceName)
	if GetCurrentResourceName() == resourceName then
		IsDebugBuild = exports.dfs:DevelopmentBuild()

		exports.dfs:RegisterClientCallback("dfsex:FetchMe", function(TargetCoords)
			DoScreenFadeOut(500)
			NetworkFadeOutEntity(PlayerPedId(), true, false)
			Wait(500)
			if IsEntityInWater(PlayerPedId()) then
				exports.dfs_deathmanager:ForceStopPedRagdoll()
				Wait(3333)
			end
			SetEntityCoords(PlayerPedId(), TargetCoords)
			DoScreenFadeIn(500)
			NetworkFadeInEntity(PlayerPedId(), 0)
		end)
	end
end)

TriggerEvent("chat:addSuggestion", "/repair", 		"DEV: Repairs your current vehicle"											)

TriggerEvent("chat:addSuggestion", "/setjob", 	"ADMIN: Sets another player's job", 										{
	{name="TargetPlayerID <int>", 			help="Player ServerID to change the job of" },
	{name="JobName <string>", 				help="Job name to set them to" },
	{name= "JobRank <int>", 				help="Rank within the job to set them to"}
																															})


TriggerEvent("chat:addSuggestion", "/tpto", 	"DEV: Teleport to the specific coords specified", 							{
	{name="X <int>", 						help="X position to teleport to"},
	{name="Y <int>", 						help="Y position to teleport to"},
	{name="Z <int>", 						help="Z position to teleport to"}
																															})

TriggerEvent("chat:addSuggestion", "/goto", 	"DEV: Teleport to a specific player via ID", 								{
	{name='ID <int>',						help = "DEV: Teleport to a specific player via ID"}
																															})

TriggerEvent("chat:addSuggestion", "/pos", 		"Shows your current in-game corods.")

TriggerEvent("chat:addSuggestion", "/lv", "Changes your current vehicles livery", 											{
	{ name="LiveryID <int>", 				help="Livery ID to change to" }
																															})

TriggerEvent("chat:addSuggestion", "/dropdead", "Knocks down your character"												)

TriggerEvent("chat:addSuggestion", "/getweapon", "ADMIN: Gives you a weapon", 												{
	{ name="Weapon <string>", 				help="Weapon name excluding 'WEAPON_'" },
	{ name="Ammo <int>", 					help="Ammo to attach" }
																															})

TriggerEvent("chat:addSuggestion", "/extra", 	"Changes your vehicles extras", 											{
	{ name="Extra <int> | <string: ALL>", 	help="Extra ID" },
	{ name="OnOff <int>", 					help="0 for off, 1 for on" }
																															})

TriggerEvent("chat:addSuggestion", "/kick", 	"MOD: Kicks a player from the server.", 									{
	{ name="ID <int>", 						help="Victim Server ID" },
    { name="Reason <string>", 				help="Reason for the kick" }
																															})

TriggerEvent("chat:addSuggestion", "/dv", 		"DEV: Deletes your vehicle, or, all vehicles in the specified area.",		{
    { name="Distance <int>", 				help="(OPTIONAL) Distance to delete vehicles in." }
																															})

TriggerEvent("chat:addSuggestion", "/car", 		"DEV: Spawns a car", 														{
    { name="ModelName <string>", 			help="The modelname of the car" }
																															})

TriggerEvent("chat:addSuggestion", "/addmoney", 		"ADMIN: Adds or removes money from your person", 					{
	{ name="amount <int>", 					help="The amount to add or remove" },
	{ name="TargetUser <OPTIONAL int>", 	help="Who to give it to. Leave blank for yourself." }
																															})

TriggerEvent("chat:addSuggestion", "/additem", 		"DEV: Adds Item", 														{
	{ name="ItemName <string>", 			help="The name of the item to add" },
	{ name="ItemCount <int>", 				help="The amount of the item to add" }
																															})

																															
TriggerEvent("chat:addSuggestion", "/roll", 		"Roll some dice", 														{
	{ name="SidesPerDie <string>", 			help="The amount of sides per die to roll" },
	{ name="DiceToRoll 	<int>", 			help="The amount of dies to roll" }
																															})

TriggerEvent("chat:addSuggestion", "/reportr", 		"Respond to a report", 														{
	{ name="playerID <int>", 			help="The player to respond to" },
	{ name="message <string>", 			help="The response" }
																															})																			
