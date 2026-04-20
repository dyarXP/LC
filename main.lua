-- [[ RHDXP HUB - STABLE DASHBOARD ]]
local Username = "dyarXP" 
local Repo = "LC" 
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

-- 1. LOAD LIBRARY
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ 4. ISI DASHBOARD (DIBUAT SECEPAT MUNGKIN) ]]
-- Bagian ini harus di luar task.spawn agar langsung muncul saat script dijalankan
Tabs.Dashboard:AddParagraph({
    Title = "WELCOME TO RHDXP HUB",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\nScript sedang memuat modul lainnya...\nTikTok: @RHDXP7"
})

Tabs.Dashboard:AddButton({
    Title = "Re-load All Tabs",
    Description = "Klik jika tab lain tidak muncul",
    Callback = function()
        Window:SelectTab(1)
        Fluent:Notify({Title = "RHDXP", Content = "Refreshing modules...", Duration = 2})
    end
})

-- [[ 5. SECURE MODULE LOADER ]]
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
                if not s then warn("Crash di modul [" .. FileName .. "]: " .. tostring(e)) end
            end)
        else
            warn("Syntax Error [" .. FileName .. "]: " .. tostring(err))
        end
    else
        warn("Gagal download: " .. FileName)
    end
end

-- [[ 6. LOADING MODUL (DI BELAKANG LAYAR) ]]
task.spawn(function()
    task.wait(1)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Misc", Tabs.Misc)
    
    -- Notifikasi Sukses
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Semua fitur telah siap digunakan!",
        Duration = 5
    })
end)
