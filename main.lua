-- [[ RHDXP HUB - FINAL STABLE LOADER ]]
local Username = "dyarXP" -- GANTI DENGAN USERNAME GITHUB ANDA
local Repo = "LC"         -- GANTI DENGAN NAMA REPOSITORY ANDA
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

-- 1. LOAD FLUENT LIBRARY
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. CREATE MAIN WINDOW
local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End
})

-- 3. REGISTER TABS
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm      = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Upgrades  = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell      = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading   = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Events    = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Misc      = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ 4. DASHBOARD CONTENT (Langsung Muncul) ]]
Tabs.Dashboard:AddParagraph({
    Title = "WELCOME TO RHDXP HUB",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\nScript sedang memuat semua fitur...\n\nCONTACT ME ON TIKTOK: @RHDXP7"
})

Tabs.Dashboard:AddButton({
    Title = "Re-check Modules",
    Description = "Klik jika ada tab yang kosong",
    Callback = function()
        Fluent:Notify({Title = "RHDXP Hub", Content = "Checking modules status...", Duration = 2})
    end
})

-- [[ 5. MODULE LOADER ENGINE ]]
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    
    -- Mengambil script dari GitHub
    local success, content = pcall(function() return game:HttpGet(targetURL) end)
    
    if success and content and content ~= "404: Not Found" then
        local func, err = loadstring(content)
        if func then
            -- Jalankan modul dalam thread terpisah agar tidak mengganggu yang lain
            task.spawn(function()
                local s, e = pcall(function() 
                    local moduleInit = func()
                    if type(moduleInit) == "function" then
                        moduleInit(TabObject, Fluent, Window)
                    else
                        warn("Modul [" .. FileName .. "] tidak mengembalikan fungsi!")
                    end
                end)
                if not s then warn("Runtime Error di modul [" .. FileName .. "]: " .. tostring(e)) end
            end)
        else
            warn("Syntax Error di modul [" .. FileName .. "]: " .. tostring(err))
        end
    else
        warn("Gagal mengunduh modul: " .. FileName .. " (Pastikan nama file di GitHub " .. FileName .. ".lua)")
    end
end

-- [[ 6. EXECUTE LOADING ]]
-- Jeda singkat agar UI selesai merender sebelum memuat logika berat
task.spawn(function()
    task.wait(1)
    
    -- Nama file di bawah harus SAMA PERSIS dengan di GitHub (Case Sensitive)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Events", Tabs.Events)
    LoadModule("Misc", Tabs.Misc)
    
    -- Notifikasi Akhir
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Semua modul berhasil dimuat!",
        Duration = 5
    })
end)

-- Pilih tab Dashboard sebagai tampilan awal
Window:SelectTab(1)
