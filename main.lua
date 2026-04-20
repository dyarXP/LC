-- [[ RHDXP HUB - MULTI-TAB MASTER LOADER ]]
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

-- [[ FLOATING MINIMIZE SYSTEM ]]
local MiniUI = Instance.new("ScreenGui")
local MiniButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

local ProtectGui = gethui or function() return game:GetService("CoreGui") end
MiniUI.Name = "RHDXP_Minimize"
MiniUI.Parent = ProtectGui()
MiniUI.Enabled = false

MiniButton.Name = "FloatingIcon"
MiniButton.Parent = MiniUI
MiniButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MiniButton.Position = UDim2.new(0.05, 0, 0.4, 0)
MiniButton.Size = UDim2.new(0, 80, 0, 35)
MiniButton.Text = "RHDXP"
MiniButton.TextColor3 = Color3.fromRGB(0, 255, 255)
MiniButton.Font = Enum.Font.Code
MiniButton.TextSize = 18

UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MiniButton
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = MiniButton

MiniButton.MouseButton1Click:Connect(function() 
    MiniUI.Enabled = false 
    if Window.Root then Window.Root.Visible = true end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Window.Root then
            local MainFrame = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
            local isHidden = (Window.Root.Visible == false) or (MainFrame and MainFrame.Visible == false)
            MiniUI.Enabled = isHidden
        end
    end
end)

-- 3. TABS DEFINITION (Semua Tab Terdaftar di Sini)
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Events = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- 4. SECURE MODULE LOADER
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    
    local success, content = pcall(function() 
        return game:HttpGet(targetURL) 
    end)
    
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
                if not s then warn("CRASH DI MODUL [" .. FileName .. "]: " .. tostring(e)) end
            end)
        else
            warn("SYNTAX ERROR DI [" .. FileName .. "]: " .. tostring(err))
        end
    else
        warn("FILE TIDAK ADA DI GITHUB: " .. FileName .. ".lua")
    end
end

-- 5. DASHBOARD SETUP
Tabs.Dashboard:AddParagraph({
    Title = "RHDXP HUB MASTER", 
    Content = "User: " .. game.Players.LocalPlayer.DisplayName .. "\nStatus: Premium Loader Ready"
})

-- 6. LOADING SEMUA MODUL (Sesuai dengan Tab yang dibuat)
task.spawn(function()
    task.wait(1) -- Jeda awal
    
    -- Pastikan nama file di folder 'modules' GitHub kamu sama persis dengan nama di bawah!
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Seluruh tab berhasil dimuat!",
        Duration = 5
    })
end)
