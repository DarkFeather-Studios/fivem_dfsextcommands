
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('kick')
AddEventHandler('kick', function(CallerID, VictimID, Reason)
	if not exports.db_perms:HasPermission_sv(source, "kick", 950) then return end
	DropPlayer(VictimID, Reason)
	io.write("User " .. CallerID .. " kicked player " .. VictimID .. " for "..Reason..".")
end)

RegisterNetEvent("dfsec:StartTeleportSequence")
AddEventHandler("dfsec:StartTeleportSequence", function(x, y, z, x2, y2, z2)
	TriggerClientEvent("dfsec:DoTeleportSequence", -1, x, y, z, x2, y2, z2)
end)

RegisterNetEvent("dfsec:GetJob")
AddEventHandler("dfsec:GetJob", function ()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("alerts:add", source, {255, 255, 255}, {255, 0, 0}, "System", "Your job is currently "..xPlayer.getJob().name..", Grade "..xPlayer.getJob().grade..".")
end)

RegisterNetEvent("dfsec:AddCash")
AddEventHandler("dfsec:AddCash", function (Amount, Target)
	local tgt = Target
	if not Target then tgt = source end
	local xPlayer = ESX.GetPlayerFromId(tgt)
	local r = 0
	local g = 255
	if Amount > 0 then xPlayer.addMoney(Amount) 
	else 
		xPlayer.removeMoney(Amount) 
		r,g = g,0
	end
	TriggerClientEvent("alerts:add", tgt, {255, 255, 255}, {r, g, 0}, "System", "Your Cash has been adjusted by $"..Amount)
	if tgt ~= source then TriggerClientEvent("alerts:add", source, {255, 255, 255}, {0, 255, 0}, 
		"System", "You have adjusted "..tgt.."'s cash by $"..Amount) end
end)

RegisterNetEvent("dfsec:AddItem")
AddEventHandler("dfsec:AddItem", function (item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, count)
end)

RegisterNetEvent("dfsec:SetJob")
AddEventHandler("dfsec:SetJob", function (Target, Name, Grade)
	local xPlayer = ESX.GetPlayerFromId(Target)
	xPlayer.setJob(Name, Grade)

	if xPlayer.getJob().name == Name and xPlayer.getJob().grade == Grade then
		TriggerClientEvent("alerts:add", Target, {255, 255, 255}, {0, 255, 0}, "System", string.format("Your job is now %s, grade %d.", Name, Grade))
		TriggerClientEvent("alerts:add", source, {255, 255, 255}, {0, 255, 0}, "System", string.format("Set user %d's job to %s, grade %d.", Target, Name, Grade))
	else
		TriggerClientEvent("alerts:add", source, {255, 255, 255}, {255, 0, 0}, "System", string.format("Failed to set user %d's job to %s, grade %d.", Target, Name, Grade))
	end
end)

RegisterNetEvent("dfsec:HealPlayer")
AddEventHandler("dfsec:HealPlayer", function (Target)
	TriggerClientEvent("dfsec:HealMe", Target)
end)

RegisterCommand("broadcast", function (source, args, raw)
	if not exports.db_perms:HasPermission_sv(source, "broadcast", 996) then return end
	local BroadcastReason = "No Reson Specifed"
    if #args > 0 then
        BroadcastReason = ""
        for k, v in pairs(args) do
            BroadcastReason = BroadcastReason .. v .. " "
        end
	end
	
	TriggerEvent("alerts:sendto", -1, {255, 255, 255}, {180, 7, 255}, "Broadcast", BroadcastReason)
end)

RegisterCommand("restartwarning", function (source, args, raw)
	if not exports.db_perms:HasPermission_sv(source, "restartwarning", 996) then return end
	local BroadcastReason = "No Reason Specifed"
    if #args > 0 then
        BroadcastReason = ""
        for k, v in pairs(args) do
            BroadcastReason = BroadcastReason .. v .. " "
        end
	end
	
	TriggerEvent("alerts:sendto", -1, {255, 255, 255}, {0, 148, 255}, "NOAA", BroadcastReason)
end)


AddEventHandler("onServerResourceStart", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		exports.dfs:RegisterServerCallback("dfsex:FetchPlayer", function(playerId, TargetId, SourceCoords)
			exports.dfs:TriggerClientCallback("dfsex:FetchMe", TargetId, function() end, SourceCoords)
		end)
	end
end)


RegisterNetEvent("dfsec:SlayPlayer")
AddEventHandler("dfsec:SlayPlayer", function(PlayerId)
	TriggerClientEvent("dfsec:Slay", PlayerId)
end)

--                  TriggerEvent("alerts:sendto", -1, {255, 255, 255}, {0, 148, 255}, "NOAA", "Tsunami Warning: "..TimeToKick.." Minutes!")
--					print("Tsunami Warning: "..TimeToKick.." Minutes!")