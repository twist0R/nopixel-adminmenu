GEN.Admin.Menu = {}
GEN._Admin.Menu = {}
GEN._Admin.Menu.PlayerOptions = {}
GEN._Admin.Menu.SearchOptions = {
    type = nil,
    data = nil
}
GEN._Admin.Menu.Target = {}

local group = "user"
RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

function GEN.Admin.Menu.Init(self)
    WarMenu.CreateMenu("amenu", "Admin Menu")
    WarMenu.SetSubTitle("amenu", "Options")

    WarMenu.SetMenuWidth("amenu", 0.5)
    WarMenu.SetMenuX("amenu", 0.71)
    WarMenu.SetMenuY("amenu", 0.017)
    WarMenu.SetMenuMaxOptionCountOnScreen("amenu", 30)
    WarMenu.SetTitleColor("amenu", 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor("amenu", 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor("amenu", 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor("amenu", 255, 255, 255, 255)

    local function SetDefaultSubMenuProperties(menu)
        WarMenu.SetMenuWidth(menu, 0.5)
        WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
        WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
        WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
        WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
    end

    WarMenu.CreateSubMenu("aplayers", "amenu", "Player List")
    SetDefaultSubMenuProperties("aplayers")

    WarMenu.CreateSubMenu("adplayers", "amenu", "Disconnected Player List")
    SetDefaultSubMenuProperties("adplayers")

    WarMenu.CreateSubMenu("aplayeropts", "amenu", "Player Info")
    SetDefaultSubMenuProperties("aplayeropts")

    WarMenu.CreateSubMenu("acommands", "amenu", "Commands")
    SetDefaultSubMenuProperties("acommands")

    WarMenu.CreateSubMenu("aDev", "amenu", "Dev Toggle")
    SetDefaultSubMenuProperties("aDev")

    WarMenu.CreateSubMenu("acategories", "amenu", "Categories")
    SetDefaultSubMenuProperties("acategories")

    WarMenu.CreateSubMenu("targetmenu", "amenu", "Available Targets")
    SetDefaultSubMenuProperties("targetmenu")

    WarMenu.CreateSubMenu("ranklist", "amenu", "Ranks")
    SetDefaultSubMenuProperties("ranklist")

    WarMenu.CreateSubMenu("command", "amenu", "Command Options")
    SetDefaultSubMenuProperties("command")
end

function GEN.Admin.Menu.SetSubMenuProperties(self, menu)
    WarMenu.SetMenuWidth(menu, 0.5)
    WarMenu.SetTitleColor(menu, 135, 206, 250, 255)
    WarMenu.SetTitleBackgroundColor(menu, 0 , 0, 0, 150)
    WarMenu.SetMenuBackgroundColor(menu, 0, 0, 0, 100)
    WarMenu.SetMenuSubTextColor(menu, 255, 255, 255, 255)
end

function GEN.Admin.Menu.DrawCommand(self, cmd)
    if not cmd or not GEN.Admin:CommandExists(cmd) then return end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if WarMenu.IsMenuOpened("command") then GEN.Admin:GetCommandData(cmd).drawcommand() else return end
            if WarMenu.MenuButton("Back", "acommands") then return end
        end
    end)
end

function GEN.Admin.Menu.DrawTargets(self, cmd, cb)
    WarMenu.OpenMenu("targetmenu")

    Citizen.CreateThread(function()
        while WarMenu.IsMenuOpened("targetmenu") do
            Citizen.Wait(0)
            for k,v in spairs(GEN._Admin.Players, function(t, a, b) return t[a].src < t[b].src end) do
                if WarMenu.MenuButton("[" .. v.src .. "] " .. v.name, "command") then self:DrawCommand(cmd) cb(v) GEN.Admin:GetCommandData(cmd).drawcommand() return end
            end
            if WarMenu.MenuButton("Back", "command") then self:DrawCommand(cmd) GEN.Admin:GetCommandData(cmd).drawcommand() return end
        end
    end)
end

function GEN.Admin.Menu.DrawTextInput(self, defaultText, cb)
    Citizen.CreateThread(function()
        DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP8", "", "", defaultText and defaultText or "" , "", "", 99)

        while true do
            Citizen.Wait(0)
            DisableAllControlActions(0)

            if UpdateOnscreenKeyboard() == 1 then cb(GetOnscreenKeyboardResult()) return
            elseif UpdateOnscreenKeyboard() == 2 or UpdateOnscreenKeyboard == 3 then return end
        end
    end)
end

local textEntryCb

local function nuiCallBack(data)
    if data.textEntry then
        textEntryCb(data.text and data.text or nil)
    end

    if data.close then
        SetNuiFocus(false, false)
    end

    if data.showcursor or data.showcursor == false then SetNuiFocus(data.showcursor, data.showcursor) end
end

RegisterNUICallback("nuiMessage", nuiCallBack)

function GEN.Admin.Menu.ShowTextEntry(self, title, subMsg, cb)
    SendNUIMessage({open = true, textEntry = true, title = title, submsg = subMsg and subMsg or ""})
    textEntryCb = function(text) cb(text) end
end

function GEN.Admin.Menu.DrawRanks(self, cmd, cb)
    WarMenu.OpenMenu("ranklist")

    Citizen.CreateThread(function()
        while WarMenu.IsMenuOpened("ranklist") do
            Citizen.Wait(0)
            for k,v in spairs(GEN.Admin:GetRanks(), function(t, a, b) return t[a].grant < t[b].grant end) do
                if WarMenu.MenuButton(k, "command") then self:DrawCommand(cmd) cb(k) GEN.Admin:GetCommandData(cmd).drawcommand() return end
            end
            if WarMenu.MenuButton("Back", "command") then self:DrawCommand(cmd) GEN.Admin:GetCommandData(cmd).drawcommand() return end
        end
    end)
end

local viewingIp = false
local viewingLicense = false
local cat = nil

Citizen.CreateThread(function()
    local function DrawMain()
        if WarMenu.Button("Commands") then
            WarMenu.OpenMenu("acategories")
        end

        if WarMenu.Button("Dev Toggle") then
            WarMenu.OpenMenu("aDev")
        end

        if WarMenu.Button("Player List") then
            WarMenu.OpenMenu("aplayers")
        end

        if WarMenu.Button("Close") then
            WarMenu.CloseMenu()
        end
    end

    local function DrawPlayers()        
        for k,v in spairs(GEN._Admin.Players, function(t, a, b) return t[a].src < t[b].src end) do
            if WarMenu.Button("[" .. v.src .. "] " .. v.name .. (v.sessioned and " - SESSIONED?" or ""), v.status, v.sessioned and {r = 255, g = 0, b = 0, a = 255} or nil) then GEN._Admin.Menu.PlayerOptions = v viewingIp = false viewingLicense = false WarMenu.OpenMenu("aplayeropts") end
        end
        if WarMenu.MenuButton("Disconnected Players", "adplayers") then end
        if WarMenu.MenuButton("Back", "amenu") then return end
    end

    local function DrawDiscPlayers()
        for k,v in spairs(GEN._Admin.DiscPlayers, function(t, a, b) return t[a].src < t[b].src end) do
            if WarMenu.MenuButton("[" .. v.src .. "] " .. v.name, "aplayeropts") then GEN._Admin.Menu.PlayerOptions = v viewingIp = false end
        end
        if WarMenu.MenuButton("Back", "aplayers") then return end
    end

    local function DrawPlayerOptions()
        local options = GEN._Admin.Menu.PlayerOptions

        if options then
            for k,v in pairs(options) do
                if not v or v == "" then options[k] = "Unknown" end
            end

            if WarMenu.Button("User:", options.name) then end
            if WarMenu.Button("Source:", options.src) then end
            if WarMenu.Button("Steam ID:", options.steamid) then end
            if WarMenu.Button("Hex ID:", options.comid) then end

            local license = string.gsub(options.license, "license:", "")
            if not viewingLicense then if WarMenu.Button("License:", "Press enter to view") then viewingLicense = true end else if WarMenu.Button("", license) then viewingLicense = false end end

            if GEN.Admin:IsSuperAdmin() then
                if WarMenu.Button("Ping:", options.ping .. " ms") then end
                if not viewingIp then if WarMenu.Button("IP:", "Press enter to view") then viewingIp = true end else if WarMenu.Button("IP:", options.ip) then viewingIp = false end end
            end
            if options.sessioned then if WarMenu.Button("SESSIONED?", nil, {r = 255, g = 0, b = 0, a = 255}) then end end
        end
        if WarMenu.MenuButton("Back", "aplayers") then return end
    end

    local function DrawCommands()
        local userRank = GEN.Admin:GetPlayerRank()

        if cat then
            for k,v in spairs(GEN.Admin:GetCommands(), function(t, a, b) return t[a].title < t[b].title end) do
                if v.category == cat then
                    if GEN.Admin:RankHasCommand(userRank, v.command) then if WarMenu.Button(v.title) then WarMenu.OpenMenu("command") GEN.Admin.Menu:DrawCommand(v.command) end end
                end
            end
        end
        if WarMenu.MenuButton("Back", "acategories") then return end
    end

    local function DrawCategories()
        for k,v in spairs(GEN.Admin:GetCategories(), function(t, a, b) return a < b end) do
            if WarMenu.Button(k) then
                cat = k
                WarMenu.SetSubTitle("acommands", "COMMANDS - " .. cat)
                WarMenu.OpenMenu("acommands")
            end
        end
        if WarMenu.MenuButton("Back", "amenu") then return end
    end

    local function DrawDev()
        local userRank = GEN.Admin:GetPlayerRank()
        if WarMenu.Button("Dev mode: " .. (GEN._Admin.Menu.DevMode and "Disable" or "Enable")) and userRank == "superadmin" then 
            GEN._Admin.Menu.DevMode = not GEN._Admin.Menu.DevMode 
            TriggerEvent("gen-admin:currentDevmode",GEN._Admin.Menu.DevMode)
        end
        if WarMenu.Button("Dev debug: " .. (GEN._Admin.Menu.DevDebug and "Disable" or "Enable")) and userRank == "superadmin" then 
            GEN._Admin.Menu.DevDebug = not GEN._Admin.Menu.DevDebug 
            TriggerEvent("gen-admin:currentDebug",GEN._Admin.Menu.DevDebug)
            TriggerEvent("hud:enabledebug", nil,GEN._Admin.Menu.DevDebug)
        end
        if WarMenu.MenuButton("Back", "amenu") then return end
    end



    GEN._Admin.Menu.Menus = {
        ["amenu"] = DrawMain,
        ["searchopts"] = DrawSearchOptions,
        ["aplayers"] = DrawPlayers,
        ["adplayers"] = DrawDiscPlayers,
        ["aplayeropts"] = DrawPlayerOptions,
        ["acommands"] = DrawCommands,
        ["aDev"] = DrawDev,
        ["acategories"] = DrawCategories,
        ["command"] = false,
        ["targetmenu"] = false,
        ["ranklist"] = false
    }

    while true do
        Citizen.Wait(0)

        for k,v in pairs(GEN._Admin.Menu.Menus) do
            if v ~= false and WarMenu.IsMenuOpened(k) then
                v()
            end
        end

        WarMenu.Display()
    end
end)

RegisterNetEvent("gen-admin:openMenu")
AddEventHandler("gen-admin:openMenu", function()
    WarMenu.OpenMenu("amenu")
end)

RegisterCommand('menu', function()
    if group ~= "user" then
        TriggerEvent('gen-admin:openMenu')
    else
        TriggerEvent('notification', "you are not an admin", 2)
    end
end)