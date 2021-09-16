ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
GEN = GEN or {}
GEN.Admin = GEN.Admin or {}
GEN._Admin = GEN._Admin or {}
GEN._Admin.Players = {}
GEN._Admin.DiscPlayers = {}

RegisterServerEvent('admin:setGroup')
AddEventHandler('admin:setGroup', function(target, rank)
    local source = source
    TriggerEvent("es:setPlayerData", target.src, "group", rank, function(response, success)
        TriggerClientEvent('es_admin:setGroup', target.src, rank)
        TriggerClientEvent('notification', source, "Set " .. target.src .. "'s rank to " .. rank .. "!")
    end)
end)

RegisterServerEvent('gen-admin:Cloak')
AddEventHandler('gen-admin:Cloak', function(src, toggle)
    TriggerClientEvent("gen-admin:Cloak", -1, src, toggle)
end)

RegisterServerEvent('admin:addChatMessage')
AddEventHandler('admin:addChatMessage', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(168, 70, 50, 0.85); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;"><b> {0}</b> {1}</div>',
		args = {'Admin: ', message},
	})
end)

RegisterServerEvent('admin:addChatAnnounce')
AddEventHandler('admin:addChatAnnounce', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding: 0.475vw; padding-left: 0.8vw; padding-right: 0.7vw; margin: 0.1vw; background-color: rgba(168, 147, 50, 0.85); border-radius: 10px 10px 10px 10px;"><span style="font-weight: bold;"><b> {0}</b> {1}</div>',
		args = {'Console: ', message},
	})
end)

RegisterServerEvent('gen-admin:RaveMode')
AddEventHandler('gen-admin:RaveMode', function(toggle)
    local source = source
    TriggerClientEvent('gen-admin:toggleRave', -1, toggle)
end)

RegisterServerEvent('gen-admin:AddPlayer')
AddEventHandler("gen-admin:AddPlayer", function()
    local licenses
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            licenses = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local licenseid = licenses:gsub("license:", "")
    local ping = GetPlayerPing(source)
    local data = { src = source, steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping}

    TriggerClientEvent("gen-admin:AddPlayer", -1, data )
    GEN.Admin.AddAllPlayers()
end)

RegisterServerEvent('admin:bringPlayer')
AddEventHandler('admin:bringPlayer', function(target)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('es_admin:teleportUser', target, coords.x, coords.y, coords.z)
    TriggerClientEvent('notification', source, 'You brought this player.')
end)

function GEN.Admin.AddAllPlayers(self)
    local xPlayers   = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        
        local licenses
        local identifiers, steamIdentifier = GetPlayerIdentifiers(xPlayers[i])
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end
        for _, v in pairs(identifiers) do
            if string.find(v, "license") then
                licenses = v
                break
            end
        end
        local ip = GetPlayerEndpoint(xPlayers[i])
        local licenseid = licenses:gsub("license:", "")
        local ping = GetPlayerPing(xPlayers[i])
        local stid = HexIdToSteamId(steamIdentifier)
        local ply = GetPlayerName(xPlayers[i])
        local scomid = steamIdentifier:gsub("steam:", "")
        local data = { src = xPlayers[i], steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping }

        TriggerClientEvent("gen-admin:AddAllPlayers", source, data)

    end
end

function GEN.Admin.AddPlayerS(self, data)
    GEN._Admin.Players[data.src] = data
end

AddEventHandler("playerDropped", function()
	local licenses
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            licenses = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local licenseid = licenses:gsub("license:", "")
    local ping = GetPlayerPing(source)
    local data = { src = source, steamid = stid, comid = scomid, name = ply, ip = ip, license = licenseid, ping = ping}

    TriggerClientEvent("gen-admin:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("gen-admin:RemoveRecent", -1, data)
end)



function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end








