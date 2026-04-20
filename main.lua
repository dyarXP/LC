-- [[ RHDXP HUB ULTIMATE - MAIN LOADER ]]
-- DEVELOPER: RHDXP (@RHDXP7)

local Username = "dyarXP" 
local Repo = "RHDXP-Library"
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Events = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

local function LoadModule(FileName, TabObject)
    local success, moduleFunc = pcall(function()
        return loadstring(game:HttpGet(BaseURL .. "modules/" .. FileName .. ".lua"))()
    end)
    if success and type(moduleFunc) == "function" then
        moduleFunc(TabObject, Fluent, Window)
    else
        warn("RHDXP Error: Gagal muat module " .. FileName .. " -> " .. tostring(moduleFunc))
    end
end

-- Dashboard Info
Tabs.Dashboard:AddParagraph({
    Title = "USER PROFILE",
    Content = string.format("DISPLAY NAME: %s\nUSERNAME: @%s", game.Players.LocalPlayer.DisplayName, game.Players.LocalPlayer.Name)
})

-- Load Modules
task.spawn(function()
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({ Title = "RHDXP HUB", Content = "Semua modul berhasil dimuat!", Duration = 5 })
end)
