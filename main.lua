-- [[ RHDXP HUB - MASTER LOADER FINAL ]]
-- REPOSITORY: dyarXP/LC
-- VERSION: 2.0 (MODULAR)

local Username = "dyarXP" 
local Repo = "LC" 
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

-- 1. LOAD LIBRARY
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- 2. CREATE WINDOW
local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End
})

-- 3. TABS DEFINITION
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Events = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- 4. MODULE LOADER ENGINE
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    
    local success, content = pcall(function() 
        return game:HttpGet(targetURL) 
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            local moduleStatus, moduleErr = pcall(function()
                -- Menjalankan modul dan mengirimkan Tab, Fluent, dan Window
                local moduleInit = func()
                if type(moduleInit) == "function" then
                    moduleInit(TabObject, Fluent, Window)
                else
                    warn("Modul " .. FileName .. " tidak mengembalikan fungsi!")
                end
            end)
            if not moduleStatus then 
                warn("Runtime Error di modul " .. FileName .. ": " .. tostring(moduleErr)) 
            end
        else
            warn("Syntax Error di modul " .. FileName .. ": " .. tostring(err))
        end
    else
        warn("Gagal mengambil modul " .. FileName .. " dari GitHub.")
    end
end

-- 5. DASHBOARD SETUP
Tabs.Dashboard:AddParagraph({
    Title = "USER PROFILE",
    Content = string.format("DISPLAY NAME: %s\nUSERNAME: @%s\nUSER ID: %d", 
        game.Players.LocalPlayer.DisplayName, 
        game.Players.LocalPlayer.Name, 
        game.Players.LocalPlayer.UserId)
})

Tabs.Dashboard:AddParagraph({
    Title = "DEVELOPER",
    Content = "Developed by: RHDXP\nTikTok: @RHDXP7"
})

-- 6. INITIALIZE MODULES
-- Memuat setiap fitur dari folder /modules/ secara asinkron
task.spawn(function()
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Misc", Tabs.Misc)
    
    -- Notifikasi Selesai
    Window:SelectTab(1)
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Welcome back, " .. game.Players.LocalPlayer.DisplayName .. "! Semua fitur berhasil dimuat.",
        Duration = 5
    })
end)

-- 7. CONFIG & INTERFACE MANAGER
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

SaveManager:LoadAutoloadConfig()
