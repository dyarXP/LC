-- [[ RHDXP HUB - MASTER LOADER ]]
local Username = "dyarXP" 
local Repo = "LC" 
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
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- Fungsi Loader yang lebih kuat
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)

    if success then
        local func, err = loadstring(content)
        if func then
            -- Menjalankan fungsi yang di-return oleh module
            local status, moduleErr = pcall(function()
                func()(TabObject, Fluent, Window)
            end)
            if not status then warn("Runtime Error di " .. FileName .. ": " .. tostring(moduleErr)) end
        else
            warn("Syntax Error di " .. FileName .. ": " .. tostring(err))
        end
    else
        warn("Gagal mendownload module: " .. FileName)
    end
end

-- Load semua modul
task.spawn(function()
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({ Title = "RHDXP HUB", Content = "Semua fitur telah dimuat!", Duration = 5 })
end)
