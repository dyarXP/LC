-- [[ RHDXP HUB - STABLE FINAL LOADER ]]
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

-- [[ REGISTER TABS - Urutan menentukan posisi di GUI ]]
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm      = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Upgrades  = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell      = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading   = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Events    = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Misc      = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ DASHBOARD CONTENT ]]
Tabs.Dashboard:AddParagraph({
    Title = "WELCOME TO RHDXP HUB",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\nSemua modul sedang dimuat secara aman.\n\nTikTok: @RHDXP7"
})

-- [[ SECURE MODULE LOADER ENGINE ]]
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)
    
    if success and content and content ~= "404: Not Found" then
        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                local s, e = pcall(function() 
                    local moduleInit = func()
                    if type(moduleInit) == "function" then
                        moduleInit(TabObject, Fluent, Window)
                    end
                end)
                if not s then warn("Crash di modul [" .. FileName .. "]: " .. e) end
            end)
        else
            warn("Syntax Error [" .. FileName .. "]: " .. err)
        end
    else
        warn("Gagal download modul: " .. FileName)
    end
end

-- [[ START LOADING ALL MODULES ]]
task.spawn(function()
    task.wait(1)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Events", Tabs.Events)
    LoadModule("Misc", Tabs.Misc)
    
    Fluent:Notify({Title = "RHDXP HUB", Content = "Semua fitur berhasil dimuat!", Duration = 5})
end)

Window:SelectTab(1)
