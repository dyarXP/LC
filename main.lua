-- [[ RHDXP HUB - LC VERSION ]]
local Username = "dyarXP" 
local Repo = "LC" -- Nama repository baru kamu
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block (LC Edition)",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End
})

-- Bagian Tabs dan Loader tetap sama
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Events = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

local function LoadModule(FileName, TabObject)
    local success, moduleFunc = pcall(function()
        -- Link ini akan otomatis mengambil dari dyarXP/LC/main/modules/FileName.lua
        return loadstring(game:HttpGet(BaseURL .. "modules/" .. FileName .. ".lua"))()
    end)
    if success and type(moduleFunc) == "function" then
        moduleFunc(TabObject, Fluent, Window)
    else
        warn("RHDXP Error: Module " .. FileName .. " tidak ditemukan di repo LC")
    end
end

-- Menjalankan Loading Modul
task.spawn(function()
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({ Title = "RHDXP HUB", Content = "Loaded from LC Repository", Duration = 5 })
end)
