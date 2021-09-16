ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cmd = {}
cmd = {
    title = "Set Rank",
    command = "setrank",
    concmd = "setrank",
    category = "User Management",
    usage = "setrank <source> <rank>",
    description = "Sets the selected player's rank",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.rank then return end
    TriggerServerEvent('admin:setGroup', caller.target, caller.rank)
    --GEN.Admin:SetRank(caller.target, caller.rank)
end

function cmd.DrawCommand()
        cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
        cmd.vars.rank = cmd.vars.rank ~= nil and cmd.vars.rank or nil

        if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
            cmd.vars.target = _target
        end) end           

        if WarMenu.Button("Select a rank", "Selected: " .. (cmd.vars.rank ~= nil and tostring(cmd.vars.rank) or "None")) then GEN.Admin.Menu:DrawRanks(cmd.command, function(_rank)
            cmd.vars.rank = _rank
        end) end

        local args = {
            target = cmd.vars.target,
            rank = cmd.vars.rank
        }
    
        if args.target and args.rank then if WarMenu.Button("Set " .. args.target.name .. "'s rank to " .. args.rank) then GEN.Admin:GetCommandData(cmd.command).runcommand(args) cmd.vars.target = nil cmd.vars.rank = nil end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Ban Player",
    command = "ban",
    concmd = "ban",
    category = "User Management",
    usage = "ban <source> <time>",
    description = "Bans selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args, source)
    if not caller.target then return end
    if not caller.reason then caller.reason = "No Reason Given" end
    if not caller.time then return end

    if caller.time == "permanent" then
        TriggerServerEvent("EasyAdmin:banPlayer", caller.target.src, caller.reason, false, GetPlayerName(caller.target.src))
    else
        TriggerServerEvent("EasyAdmin:banPlayer", caller.target.src, caller.reason, caller.time, GetPlayerName(caller.target.src))
    end

    TriggerClientEvent('notification', source, 'Player : ' .. caller.target.steamid .. " banned for time : " .. caller.time .. " | Reason : " .. caller.reason, 1)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil
    cmd.vars.time = cmd.vars.time ~= nil and cmd.vars.time or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Enter a ban length", "Length: " .. (cmd.vars.time and cmd.vars.time or "No Time Given")) then
        GEN.Admin.Menu:DrawTextInput(cmd.vars.time and cmd.vars.time or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end

                local timeTable, timeSum, addedTime = GEN.Admin:GetBanTimeFromString(result)
                if not timeTable and not timeSum then result = nil end
            end
            local timeTable, timeSum, addedTime = GEN.Admin:GetBanTimeFromString(result)
            if timeSum >= 9999999999 then
                cmd.vars.time = "permanent"
            else
                cmd.vars.time = timeSum
            end
        end)
    end

    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        GEN.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.reason = result
        end)
    end

    if cmd.vars.target and cmd.vars.time then if WarMenu.Button("Ban " .. cmd.vars.target.name) then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, reason = cmd.vars.reason, time = cmd.vars.time}) cmd.vars.target = nil cmd.vars.reason = nil cmd.vars.time = nil end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Unban Player",
    command = "unban",
    concmd = "unban",
    category = "User Management",
    usage = "unban <steamid>",
    description = "Unbans entered steamid",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand( caller, args, source)

    TriggerServerEvent('EasyAdmin:unbanIdent', caller.steamid)
    TriggerClientEvent('notification', source, 'Player with hex : ' .. caller.steamid .. " unbanned from server")
end

function cmd.DrawCommand()
    cmd.vars.steamid = cmd.vars.steamid ~= nil and cmd.vars.steamid or nil

    if WarMenu.Button("Enter a Steam ID", "Entered: " .. (cmd.vars.steamid and cmd.vars.steamid or "None")) then 
        GEN.Admin.Menu:ShowTextEntry("Enter a Steam ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.steamid = result
        end)
    end

    if cmd.vars.steamid then if WarMenu.Button("Unban " .. cmd.vars.steamid) then GEN.Admin:GetCommandData(cmd.command).runcommand({steamid = cmd.vars.steamid}) cmd.vars.steamid = nil end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Kick",
    command = "kick",
    concmd = "kick",
    category = "User Management",
    usage = "kick <source>",
    description = "Kicks selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
    if not caller.reason then caller.reason = "No Reason Given" end

    DropPlayer(caller.target.src, "You were kicked | Reason: " .. caller.reason)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil
    cmd.vars.reason = cmd.vars.reason ~= nil and cmd.vars.reason or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Enter a reason", "Reason: " .. (cmd.vars.reason and cmd.vars.reason or "No Reason Given")) then
        GEN.Admin.Menu:DrawTextInput(cmd.vars.reason and cmd.vars.reason or "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.reason = result
        end)
    end

    if cmd.vars.target then if WarMenu.Button("Kick " .. cmd.vars.target.name) then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, reason = cmd.vars.reason}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "God",
    command = "god",
    concmd = "god",
    category = "Player",
    usage = "god",
    description = "Enables god mode",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if IsDuplicityVersion() then return end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local playerName = GetPlayerName(PlayerId())
            TriggerServerEvent('adminmenu', playerName .. " turned on godmode through the adminmenu.")
            if cmd.vars.toggle then
                SetPlayerInvincible(PlayerId(), true)
            elseif not cmd.vars.toggle then
                SetPlayerInvincible(PlayerId(), false)
                return
            end
        end
    end)
end

function cmd.Init()
end

function cmd.RunClCommand(args)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil         
    if WarMenu.Button("God Mode: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Noclip",
    command = "noclip",
    concmd = "noclip",
    category = "Player",
    usage = "noclip",
    description = "Enables noclip",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if IsDuplicityVersion() then return end
    local isFlying = false
    RegisterNetEvent("admin:isFlying")
    AddEventHandler("admin:isFlying", function(state)
        isFlying = state
    end)

    Citizen.CreateThread(function()
        local speed = 0.5
        TriggerEvent("admin:isFlying",cmd.vars.toggle)
        while true do
            Citizen.Wait(0)
            if cmd.vars.toggle then
                cmd.vars.heading = cmd.vars.heading == nil and GetEntityHeading(PlayerPedId()) or cmd.vars.heading
                cmd.vars.noclip_pos = cmd.vars.noclip_pos == nil and GetEntityCoords(PlayerPedId(), false) or cmd.vars.noclip_pos

                SetPlayerInvincible(PlayerId(), true)

                SetEntityCoordsNoOffset(PlayerPedId(),  cmd.vars.noclip_pos.x,  cmd.vars.noclip_pos.y,  cmd.vars.noclip_pos.z,  0, 0, 0)
    
                if IsControlPressed(1, 34) then
                    cmd.vars.heading = cmd.vars.heading + 1.5
                    if cmd.vars.heading > 360 then
                        cmd.vars.heading = 0
                    end
                    SetEntityHeading(PlayerPedId(),  cmd.vars.heading)
                end

                if IsControlPressed(1, 9) then
                    cmd.vars.heading = cmd.vars.heading - 1.5
                    if cmd.vars.heading < 0 then
                        cmd.vars.heading = 360
                    end
                    SetEntityHeading(PlayerPedId(),  cmd.vars.heading)
                end

                if IsControlPressed(0, 8) then
                    cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, speed, 0.0)
                end

                if IsControlPressed(0, 32) then
                    cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -speed, 0.0)
                end
    
                if IsControlPressed(0, 22) then
                    cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, speed)
                end
                if IsControlPressed(0, 73) then
                    cmd.vars.noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -speed)
                end

                if IsControlJustPressed(0, 131) then
                    if speed >= 6.5 then speed = 0.5 else speed = speed + 1.0 end
                end
            end
        end
    end)
end

function cmd.Init()
end

function cmd.RunClCommand(args)
    cmd.vars.enable = args.toggle
    if not args.toggle then cmd.vars.heading = nil cmd.vars.noclip_pos = nil SetPlayerInvincible(PlayerId(), false) end
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Noclip: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Marker Teleport",
    command = "marker",
    concmd = "marker",
    category = "Teleport Options",
    usage = "marker",
    description = "Teleport To marker",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    GEN.Admin.teleportMarker()
end

function cmd.RunClCommand(args)
end

function cmd.DrawCommand()      
    if WarMenu.Button("Teleport to marker") then GEN.Admin:GetCommandData(cmd.command).runcommand({}) end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Cloak",
    command = "cloak",
    concmd = "cloak",
    category = "Player",
    usage = "cloak",
    description = "Turn your self invisible",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local src = GetPlayerServerId(PlayerId())
    if caller.toggle == true then cmd.vars.cloaked[src] = true else cmd.vars.cloaked[src] = nil end
    TriggerServerEvent('gen-admin:Cloak', src, caller.toggle)
end

function cmd.Init()
    cmd.vars.cloaked = {}
    cmd.vars.cloakedVeh = {}

    if IsDuplicityVersion() then 
        AddEventHandler("playerDropped", function()
            local src = source
            if cmd.vars.cloaked[src] then
                TriggerServerEvent('gen-admin:Cloak', src, false)
                cmd.vars.cloaked[src] = nil
            end
        end)

        return
    end

    RegisterNetEvent("gen-admin:CloakRemote")
    AddEventHandler("gen-admin:CloakRemote", function()
        if GEN.Admin:GetPlayerRank() == "dev" then
            cmd.vars.toggle = not cmd.vars.toggle
            GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle})
        end
    end)

    RegisterNetEvent("gen-admin:Cloak")
    AddEventHandler("gen-admin:Cloak", function(player, toggle)
        if type(player) == "table" then
            cmd.vars.cloaked = player
            TriggerEvent("hud:HidePlayer", player)
        else
            cmd.vars.cloaked[player] = toggle
            TriggerEvent("hud:HidePlayer", player, toggle)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k,v in pairs(cmd.vars.cloaked) do
                local playerId = GetPlayerFromServerId(k)
                local ped = GetPlayerPed(playerId)
                local isInVehicle = IsPedInAnyVehicle(ped, true)
                local vehicle = cmd.vars.cloakedVeh[k]

                local function uncloakCar(vehicle)
                    NetworkFadeInEntity(vehicle, 0)
                    SetEntityCanBeDamaged(vehicle, true)
                    SetEntityInvincible(vehicle, false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, true)
                    SetVehicleStrong(vehicle, false)
                    SetVehicleSilent(vehicle, false)
                    SetEntityAlpha(vehicle, 255, false)
                    SetEntityLocallyVisible(vehicle)
                    cmd.vars.cloakedVeh[k] = nil
                end

                if not v then
                    NetworkFadeInEntity(ped, 0)
                    SetEntityLocallyVisible(ped)
                    SetPlayerVisibleLocally(playerId, true)
                    SetPedConfigFlag(ped, 52, false)
                    SetPlayerInvincible(playerId, false)
                    SetPedCanBeTargettedByPlayer(ped, playerId, true)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, false)
                    SetPlayerCanBeHassledByGangs(playerId, true)
                    SetEntityAlpha(ped, 255, false)
                    SetPedCanRagdoll(ped, true)
                    if vehicle then uncloakCar(vehicle) end
                    cmd.vars.cloaked[k] = nil
                else
                    if ped == PlayerPedId() then
                        SetEntityAlpha(ped, 100, false)
                    else
                        SetEntityAlpha(ped, 0, false)
                        SetEntityLocallyInvisible(ped)
                        SetPlayerInvisibleLocally(playerId, true)
                        NetworkFadeOutEntity(ped, true, false)
                    end

                    SetPedCanRagdoll(ped, false)
                    SetPedConfigFlag(ped, 52, true)
                    SetPlayerCanBeHassledByGangs(playerId, false)
                    SetIgnoreLowPriorityShockingEvents(playerId, true)
                    SetPedCanBeTargettedByPlayer(ped, playerId, false)
                    SetPedCanBeTargetted(ped, false)
                    SetEveryoneIgnorePlayer(playerId, true)
                    SetPlayerInvincible(playerId, true)

                    if vehicle then
                        if not IsPedInAnyVehicle(ped, true) then
                            uncloakCar(vehicle)
                        else
                            if ped == GetPedInVehicleSeat(vehicle, -1) then
                                if ped == PlayerPedId() then
                                    SetEntityAlpha(vehicle, 100, false)
                                else
                                    NetworkFadeOutEntity(vehicle, true, false)
                                    SetEntityAlpha(vehicle, 0, false)
                                    SetEntityLocallyInvisible(vehicle)
                                end
                                SetVehicleSilent(vehicle, true)
                                SetEntityCanBeDamaged(vehicle, false)
                                SetEntityInvincible(vehicle, true)
                                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                                SetVehicleStrong(vehicle, true)
                            else
                                uncloakCar(vehicle)
                            end
                        end
                    else
                        if IsPedInAnyVehicle(ped, true) then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if vehicle and vehicle ~= 0 then
                                if GetPedInVehicleSeat(vehicle, -1) == ped then
                                    cmd.vars.cloakedVeh[k] = vehicle
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Cloak: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Revive/Heal",
    command = "revive",
    concmd = "revive",
    category = "Player",
    usage = "revive <source>",
    description = "revives/heals selected player",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
    TriggerServerEvent('admin:revivePlayer', caller.target.src)
    TriggerServerEvent('admin:healPlayer', caller.target.src)
	TriggerEvent('krp-hospital:client:RemoveBleed', caller.target.src) 
	TriggerEvent('krp-hospital:client:ResetLimbs', caller.target.src)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if WarMenu.Button("Revive in Distance") then 
        TriggerEvent("gen-admin:ReviveInDistance")
    end


    if cmd.vars.target then if WarMenu.Button("Revive and Heal " .. cmd.vars.target.name) then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, runontarget = true}) end end
end

GEN.Admin:AddCommand(cmd)



local cmd = {}
cmd = {
    title = "Teleport Coord",
    command = "tcoords",
    concmd = "tcoords",
    category = "Teleport Options",
    usage = "tcoords",
    description = "Teleport To Coords",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if caller.x ~= nil and caller.y ~= nil and caller.z ~= nil then
        local pos = vector3(caller.x,caller.y,caller.z)
        local ped = PlayerPedId()

        Citizen.CreateThread(function()
            RequestCollisionAtCoord(pos)
            SetPedCoordsKeepVehicle(ped, pos)
            FreezeEntityPosition(ped, true)
            SetPlayerInvincible(PlayerId(), true)

            local startedCollision = GetGameTimer()

            while not HasCollisionLoadedAroundEntity(ped) do
                if GetGameTimer() - startedCollision > 5000 then break end
                Citizen.Wait(0)
            end

            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(PlayerId(), false)
        end)

    end 
end

function cmd.RunClCommand(args)

end

function cmd.DrawCommand()      
    cmd.vars.x = cmd.vars.x ~= nil and cmd.vars.x or nil
    cmd.vars.y = cmd.vars.y ~= nil and cmd.vars.y or nil
    cmd.vars.z = cmd.vars.z ~= nil and cmd.vars.z or nil
    if WarMenu.Button("Enter x", "x: " .. (cmd.vars.x and cmd.vars.x or "0.0")) then
        GEN.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            if string.find(result, ",") then
                local resultSplit = GEN.Admin.split(result, ',')
                local x = tonumber(resultSplit[1]) 
                local y = tonumber(resultSplit[2]) 
                local z = tonumber(resultSplit[3]) 

                if x ~= nil and y ~= nil and z ~= nil then
                    cmd.vars.x = x +0.0
                    cmd.vars.y = y +0.0
                    cmd.vars.z = z +0.0
                end
            else
                local x = tonumber(result)
                if x ~= nil then
                    cmd.vars.x = x +0.0
                end
            end
        end)
    end

    if WarMenu.Button("Enter y", "y: " .. (cmd.vars.y and cmd.vars.y or "0.0")) then
        GEN.Admin.Menu:ShowTextEntry("Enter y", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local y = tonumber(result)
            if y ~= nil then
                cmd.vars.y = y +0.0
            end
        end)
    end

    if WarMenu.Button("Enter z", "z: " .. (cmd.vars.z and cmd.vars.z or "0.0")) then
        GEN.Admin.Menu:ShowTextEntry("Enter z", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local z = tonumber(result)
            if z ~= nil then
                cmd.vars.z = z +0.0
            end
        end)
    end

    if cmd.vars.x and cmd.vars.y and cmd.vars.z then if WarMenu.Button("Teleport to: " .. "X:["..cmd.vars.x.."] Y:["..cmd.vars.y.."] Z:["..cmd.vars.z.."]") then GEN.Admin:GetCommandData(cmd.command).runcommand({x = cmd.vars.x,y = cmd.vars.y,z = cmd.vars.z}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Csay",
    command = "csay",
    concmd = "csay",
    category = "Utility",
    usage = "csay <message>",
    description = "Sends a serverwide chat message",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerServerEvent('admin:addChatMessage', caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a message", "Message: " .. (cmd.vars.message and cmd.vars.message or "No Message")) then
        GEN.Admin.Menu:ShowTextEntry("Enter a Message", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Send Message: " .. cmd.vars.message) then GEN.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Announcement",
    command = "announcement",
    concmd = "announcement",
    category = "Utility",
    usage = "announcement <message>",
    description = "Sends a serverwide chat message",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    TriggerServerEvent('admin:addChatAnnounce', caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a message", "Message: " .. (cmd.vars.message and cmd.vars.message or "No Message")) then
        GEN.Admin.Menu:ShowTextEntry("Enter a Message", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Send Message: " .. cmd.vars.message) then GEN.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Spawn Car",
    command = "scar",
    concmd = "scar",
    category = "Utility",
    usage = "scar <model>",
    description = "spawn's you a car",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    local src = source
    TriggerEvent("gen-admin:runSpawnCommand", caller.message)
    local playerName = GetPlayerName(PlayerId())
    TriggerServerEvent('adminmenu', playerName .. " has spawned a vehicle ".. caller.message)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil

    if WarMenu.Button("Enter a model", "Model: " .. (cmd.vars.message and cmd.vars.message or "No model")) then
        GEN.Admin.Menu:ShowTextEntry("Enter a model", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
        end)
    end
    if cmd.vars.message then 
        if WarMenu.Button("Spawn model: " .. cmd.vars.message) then 
            GEN.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message}) 
        end 
    end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Spawn Item",
    command = "stim",
    concmd = "stim",
    category = "Utility",
    usage = "stim <name>",
    description = "Gives you an item",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.message then return end
    if not caller.amount then caller.amount = 1 end
    local src = source
    local playerName = GetPlayerName(PlayerId())
    TriggerEvent('player:receiveItem', caller.message, caller.amount)
    TriggerServerEvent('adminmenu', playerName .. " has spawned ".. caller.message .." in the amount of ".. caller.amount)
end

function cmd.DrawCommand()
    cmd.vars.message = cmd.vars.message ~= nil and cmd.vars.message or nil
    cmd.vars.amount = cmd.vars.amount ~= nil and cmd.vars.amount or nil
    if WarMenu.Button("Enter a item name", "Model: " .. (cmd.vars.message and cmd.vars.message or "No item")) then
        GEN.Admin.Menu:ShowTextEntry("Enter Item", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            cmd.vars.message = result
            if cmd.vars.amount == nil then cmd.vars.amount = 1 end
        end)
    end

    if WarMenu.Button("Enter Amount", "Amount: " .. (cmd.vars.amount and cmd.vars.amount or "1")) then
        GEN.Admin.Menu:ShowTextEntry("Enter Amount", "", function(result)
            print(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
            end

            local amount = tonumber(result)
            if amount == nil or amount <= 0 or amount >= 51 then amount = 1 end
            cmd.vars.amount = amount
        end)
    end

    if cmd.vars.message then if WarMenu.Button("Spawn Item: " .. cmd.vars.message.." | "..cmd.vars.amount) then GEN.Admin:GetCommandData(cmd.command).runcommand({message = cmd.vars.message,amount = cmd.vars.amount}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Bring",
    command = "bring",
    concmd = "bring",
    category = "Player",
    usage = "bring <source>",
    description = "Brings targeted player to you.",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
    TriggerServerEvent('admin:bringPlayer', caller.target.src)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Bring " .. cmd.vars.target.name .. " to you.") then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, retn = false}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Teleport",
    command = "teleport",
    concmd = "teleport",
    category = "Player",
    usage = "teleport <source>",
    description = "Teleports to selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local playerCoords = cmd.vars.lastPos
    if not caller.target then SetEntityCoordsNoOffset(PlayerPedId(), playerCoords, 0, 0, 2.0); return end
    local ped = PlayerPedId()
    local targId = not caller.retn and GetPlayerFromServerId(caller.target.src)
    local targPed = not caller.retn and GetPlayerPed(targId)
    local targPos = caller.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)

    if caller.retn then cmd.vars.lastPos = nil else cmd.vars.lastPos = GetEntityCoords(ped) end

    Citizen.CreateThread(function()
        RequestCollisionAtCoord(targPos)
        SetEntityCoordsNoOffset(PlayerPedId(), targPos, 0, 0, 2.0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)

        local startedCollision = GetGameTimer()

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            if GetGameTimer() - startedCollision > 5000 then break end
            Citizen.Wait(0)
        end

        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end)
end

function cmd.RunClCommand(args)    
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Teleport to " .. cmd.vars.target.name .. "'s position") then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, retn = false}) end end
    if cmd.vars.lastPos then if WarMenu.Button("Return to your last position") then GEN.Admin:GetCommandData(cmd.command).runcommand({target = false, retn = true}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Bring",
    command = "bring",
    concmd = "bring",
    category = "Player",
    usage = "bring <source>",
    description = "Brings targeted player to you.",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not args.target then return end
    local log = string.format("%s [%s] teleported : %s : to them self", caller:getVar("name"), caller:getVar("steamid"), args.target:getVar("name"), args.target:getVar("steamid"))
    GEN.Admin:Log(log, caller)
    GEN.Admin:Bring(caller,args.target.source)
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    if cmd.vars.target then if WarMenu.Button("Bring " .. cmd.vars.target.name .. " to you.") then GEN.Admin:GetCommandData(cmd.command).runcommand({target = cmd.vars.target, retn = false}) end end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Attach",
    command = "attach",
    concmd = "attach",
    category = "Player",
    usage = "attach <source>",
    description = "Attaches to selected target",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.target then return end
end

function cmd.RunClCommand(args)
    if args.target == nil then return end 
    local ped = PlayerPedId()
    local targId = not args.retn and GetPlayerFromServerId(args.target.source)
    local targPed = not args.retn and GetPlayerPed(targId)
    local targPos = args.retn and cmd.vars.lastPos or GetEntityCoords(targPed, false)

    Citizen.CreateThread(function()
        if args.toggle == true and ped ~= targPed then 
            RequestCollisionAtCoord(targPos)
            SetEntityCoordsNoOffset(PlayerPedId(), targPos, 0, 0, 4.0)
            
            local startedCollision = GetGameTimer()

            SetEntityCollision(ped,false,false)


            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                if GetGameTimer() - startedCollision > 5000 then break end
                Citizen.Wait(0)
            end

            AttachEntityToEntity(ped, targPed, 11816, 0.0, -1.48, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            
        else
            DetachEntity(ped,true,true)
            SetEntityCollision(ped,true,true)
        end
    end)    
end

function cmd.DrawCommand()
    cmd.vars.target = cmd.vars.target ~= nil and cmd.vars.target or nil

    if WarMenu.Button("Select a target", "Selected: " .. (cmd.vars.target and cmd.vars.target.name or "None")) then GEN.Admin.Menu:DrawTargets(cmd.command, function(_target)
        cmd.vars.target = _target
    end) end

    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Attach: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle,target = cmd.vars.target}) end
end


GEN.Admin:AddCommand(cmd)

local colorsss = {255, 255, 255}
local particles = {}
local toggles
function StartRaveMode()
    Citizen.CreateThread(function()
        local particleDict = "core"
        local particleName = "ent_amb_wind_grass_dir"

        RequestNamedPtfxAsset(particleDict)

        while not HasNamedPtfxAssetLoaded(particleDict) do Citizen.Wait(0) end

        UseParticleFxAssetNextCall(particleDict)

        for i = 0, 255 do
            if IsPlayerPlaying(i) then
                local particle = StartParticleFxLoopedOnPedBone(particleName, GetPlayerPed(i), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 31086, 0.5, 0.0, 0.0, 0.0)
                particles[#particles+1]= particle
            end
        end

        while true do
            Citizen.Wait(200)
            colorsss = {GetRandomIntInRange(1, 255), GetRandomIntInRange(1, 255),GetRandomIntInRange(1, 255)}
            if not toggles then return end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for i = 0, 255 do
                if IsPlayerPlaying(i) then
                    local coords = GetEntityCoords(GetPlayerPed(i), false)
                    DrawLightWithRange(coords.x, coords.y, coords.z + 5.0, colorsss[1], colorsss[2], colorsss[3], 999999999999.0, 9999.0)
                end
                NetworkOverrideClockTime(23, 12, 23)
            end
            if not toggles then 
                for i = 0, 255 do
                    for k,v in pairs(particles) do
                        RemoveParticleFx(v, true)
                    end
                end
                return
            end
        end
    end)
end

RegisterNetEvent('gen-admin:toggleRave')
AddEventHandler('gen-admin:toggleRave', function(toggle)
    toggles = toggle
    if toggles == true then
        StartRaveMode()
    end
end)

local cmd = {}
cmd = {
    title = "Player Blips",
    command = "playerblips",
    concmd = "playerblips",
    category = "Utility",
    usage = "playerblips",
    description = "Enables player blips",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
end

function cmd.Init()
    if IsDuplicityVersion() then return end

    cmd.vars.blips = {}
    cmd.vars.toggle = false

    Citizen.CreateThread(function()
        local function CreateBlip(playerId)
            local playerPed = GetPlayerPed(playerId)
            local blip = AddBlipForEntity(playerPed)
    
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Player")
            EndTextCommandSetBlipName(blip)
            
            ShowNumberOnBlip(blip,GetPlayerServerId(playerId))
            SetBlipCategory(blip, 2)
            SetBlipAsShortRange(blip, false)
            SetBlipColour(blip, 1)
            SetBlipNameToPlayerName(blip, playerId)
            SetBlipScale(blip, 1.0)
    
            cmd.vars.blips[playerId] = blip
        end

        local function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
            local onScreen, _x, _y = World3dToScreen2d(x , y, z)
            local px, py, pz = table.unpack(GetGameplayCamCoords())
            local dist = #(vector3(px, py, pz) - vector3(x, y, z))
            
            if onScreen then
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 1.0)
                SetTextColour(255, 0, 0, 255)
                SetTextDropshadow(0, 0, 0, 0, 55)
                SetTextEdge(2, 0, 0, 0, 150)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                SetTextCentre(1)
                AddTextComponentString(text)
                DrawText(_x, _y)
            end
        end

        while true do
            Citizen.Wait(0)

            for i = 0, 255 do
                if cmd.vars.toggle and NetworkIsPlayerActive(i) and IsPlayerPlaying(i) then

                    if not cmd.vars.blips[i] then CreateBlip(i) end

                    local pCoords = GetEntityCoords(GetPlayerPed(i), false)
                    local lCoords = GetEntityCoords(PlayerPedId(), false)
                    local dist = Vdist2(pCoords, lCoords)

                    if dist <= 100.0 then
                        DrawText3D(pCoords.x, pCoords.y, pCoords.z + 1.15, string.format("[%d] - %s", GetPlayerServerId(i), GetPlayerName(i)))
                    end
                end

                if not cmd.vars.toggle and cmd.vars.blips[i] then RemoveBlip(cmd.vars.blips[i]) cmd.vars.blips[i] = nil end
            end
        end
    end)
end

function cmd.RunClCommand(args)
    cmd.vars.toggle = args.toggle
end

function cmd.DrawCommand()
    cmd.vars.toggle = cmd.vars.toggle ~= nil and cmd.vars.toggle or nil
    if WarMenu.Button("Player Blips: " .. (cmd.vars.toggle and "Disable" or "Enable")) then cmd.vars.toggle = not cmd.vars.toggle GEN.Admin:GetCommandData(cmd.command).runcommand({toggle = cmd.vars.toggle}) end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Fix Car",
    command = "fixc",
    concmd = "fixc",
    category = "Player",
    usage = "fixc <source>",
    description = "Fixes the car the selected target is in",
    ranks = {"admin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    local ped = PlayerPedId()

    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then return end

    local playerName = GetPlayerName(PlayerId())
    local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver ~= ped then return end
    TriggerServerEvent('adminmenu', playerName .. " has fixed there vehicle through the adminmenu.")
    SetVehicleFixed(vehicle)
end

function cmd.RunClCommand(args)
end

function cmd.DrawCommand()

    if WarMenu.Button("Fix Current Vehicle") then 

        GEN.Admin:GetCommandData(cmd.command).runcommand()
    end
end

GEN.Admin:AddCommand(cmd)

local cmd = {}
cmd = {
    title = "Delete Entity",
    command = "deleteent",
    concmd = "deleteent",
    category = "Utility",
    usage = "deleteent <entid>",
    description = "Deletes selected entities",
    ranks = {"superadmin"},
    vars = {}
}

function cmd.RunCommand(caller, args)
    if not caller.ent then return end
    if not DoesEntityExist(caller.ent) then return end

    Citizen.CreateThread(function()
        local timeout = 0

        while true do
            if timeout >= 3000 then return end
            timeout = timeout + 1

            NetworkRequestControlOfEntity(caller.ent)

            local nTimeout = 0

            while not NetworkHasControlOfEntity(caller.ent) and nTimeout < 1000 do
                nTimeout = nTimeout + 1
                NetworkRequestControlOfEntity(caller.ent)
                Citizen.Wait(0)
            end

            SetEntityAsMissionEntity(caller.ent, true, true)

            DeleteEntity(caller.ent)
            if GetEntityType(caller.ent) == 2 then DeleteVehicle(caller.ent) end

            if not DoesEntityExist(caller.ent) then cmd.vars.ent = nil return end

            Citizen.Wait(0)
        end
    end)
end

function cmd.RunClCommand(args)
end

function cmd.DrawCommand()
    cmd.vars.ent = cmd.vars.ent or nil

    if WarMenu.Button("Enter an entity ID") then 
        GEN.Admin.Menu:ShowTextEntry("Enter an entity ID", "", function(result)
            if result then
                if string.gsub(result, " ", "") == "" or result == "" then result = nil end
                result = tonumber(result)
                if not result then result = nil end
            end

            cmd.vars.ent = result
        end)
    end

    if WarMenu.Button("Select Entity Infront") then
        local coordA = GetEntityCoords(PlayerPedId(), false)
		local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)

        local offset = 0
        local rayHandle
        local entity

        for i = 0, 100 do
            rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z + offset, 10, PlayerPedId(), -1)	
            a, b, c, d, entity = GetRaycastResult(rayHandle)
            offset = offset - 1
            if entity and Vdist(GetEntityCoords(entity, false), coordA) < 150 then break end
        end

        if entity then cmd.vars.ent = entity end
    end

    if cmd.vars.ent and DoesEntityExist(cmd.vars.ent) then
        x, y, z = table.unpack(GetEntityCoords(cmd.vars.ent, true))
        SetDrawOrigin(x, y, z, 0)
        RequestStreamedTextureDict("helicopterhud", false)
        DrawSprite("helicopterhud", "hud_corner", -0.01, -0.01, 0.05, 0.05, 0.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, -0.01, 0.05, 0.05, 90.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", -0.01, 0.01, 0.05, 0.05, 270.0, 0, 255, 0, 200)
        DrawSprite("helicopterhud", "hud_corner", 0.01, 0.01, 0.05, 0.05, 180.0, 0, 255, 0, 200)
        ClearDrawOrigin()
    end

    if cmd.vars.ent then if WarMenu.Button("Delete Entity", "Entity: " .. (cmd.vars.ent or "none")) then
        GEN.Admin:GetCommandData(cmd.command).runcommand({ent = cmd.vars.ent})
    end end
end

GEN.Admin:AddCommand(cmd)

--[[
    function cmd.ChatCommand(args)
        local cmd = args[1] and args[1] or false
        local target = args[2] and args[2] or false
        local rank = args[3] and args[3] or false

        if not cmd or not target or not rank then return end

        if not GEN.Admin:RankExists(rank) then return end
        if not GEN.Admin:IsValidUser(target) then return end

        local args = {
            target = exports["np-base"]:getModule("Player"):getUser(target),
            rank = rank
        }

        return args
    end
]]