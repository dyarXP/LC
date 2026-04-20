-- [[ RHDXP HUB - FULL FIX LOADER ]]
local Username = "dyarXP" 
local Repo = "LC" 
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 1. CREATE WINDOW
local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End -- Gunakan tombol 'End' untuk minimize cepat
})

-- 2. MINIMIZE BUTTON SYSTEM (FIXED)
local MiniUI = Instance.new("ScreenGui")
local MiniButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

MiniUI.Name = "RHDXP_Mini"
MiniUI.Parent = (gethui or function() return game:GetService("CoreGui") end)()
MiniUI.DisplayOrder = 999
MiniUI.Enabled = false

MiniButton.Name = "FloatingIcon"
MiniButton.Parent = MiniUI
MiniButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniButton.Position = UDim2.new(0.02, 0, 0.4, 0)
MiniButton.Size = UDim2.new(0, 55, 0, 55)
MiniButton.Text = "RHDXP"
MiniButton.TextColor3 = Color3.fromRGB(0, 255, 255)
MiniButton.Font = Enum.Font.Code
MiniButton.TextSize = 12

UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MiniButton
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MiniButton

-- Klik tombol kecil untuk buka GUI
MiniButton.MouseButton1Click:Connect(function()
    if Window then
        Window:Minimize() -- Memanggil toggle minimize bawaan Fluent
    end
end)

-- Loop Monitor Status GUI (PENTING: Agar tombol Sinkron)
task.spawn(function()
    while task.wait(0.5) do
        if Window and Window.Root then
            local MainFrame = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
            if MainFrame then
                -- Jika GUI utama sembunyi (Visible false), maka tombol mini muncul (Enabled true)
                MiniUI.Enabled = not MainFrame.Visible
            end
        end
    end
end)

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

-- 4. DASHBOARD CONTENT
Tabs.Dashboard:AddParagraph({
    Title = "WELCOME TO RHDXP HUB",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\nScript berjalan optimal.\n\nTikTok: @RHDXP7"
})

-- 5. SECURE MODULE LOADER
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)
    
    if success and content and content ~= "404: Not Found" then
        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                local s, e = pcall(function() 
                    local init = func()
                    if type(init) == "function" then
                        init(TabObject, Fluent, Window)
                    end
                end)
                if not s then warn("Crash di modul [" .. FileName .. "]: " .. e) end
            end)
        end
    end
end

-- 6. START LOADING
task.spawn(function()
    task.wait(1)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Events", Tabs.Events)
    LoadModule("Misc", Tabs.Misc)
    
    Fluent:Notify({Title = "RHDXP HUB", Content = "Semua modul berhasil dimuat!", Duration = 5})
end)

Window:SelectTab(1)
