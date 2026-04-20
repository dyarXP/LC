-- [[ RHDXP HUB - MASTER LOADER FINAL ]]
-- DEVELOPER: RHDXP (@RHDXP7)
-- REPO: dyarXP/LC

local Username = "dyarXP" 
local Repo = "LC" 
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

-- [[ 1. LOAD LIBRARY ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ 2. CREATE WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Rose", 
    MinimizeKey = Enum.KeyCode.End
})

-- [[ 3. MINIMIZE SYSTEM (FLOATING BUTTON) ]]
local UserInputService = game:GetService("UserInputService")
local MiniUI = Instance.new("ScreenGui")
local MiniButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

MiniUI.Name = "RHDXP_Minimize"
MiniUI.Parent = game:GetService("CoreGui")
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

-- Draggable Logic for Minimize Button
local dragging, dragStart, startPos
MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MiniButton.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MiniButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Click Logic: Membuka Kembali Window
MiniButton.MouseButton1Click:Connect(function() 
    MiniUI.Enabled = false 
    Window:Minimize() 
end)

-- Auto Detect Window State
task.spawn(function()
    while task.wait(0.5) do
        if Window.Root and Window.Root.Visible == false then
            if not MiniUI.Enabled then MiniUI.Enabled = true end
        else
            MiniUI.Enabled = false
        end
    end
end)

-- [[ 4. TABS DEFINITION ]]
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Events = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ 5. MODULE LOADER ENGINE ]]
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            local moduleStatus, moduleErr = pcall(function()
                local moduleInit = func()
                if type(moduleInit) == "function" then
                    moduleInit(TabObject, Fluent, Window)
                end
            end)
            if not moduleStatus then warn("Error in " .. FileName .. ": " .. tostring(moduleErr)) end
        else
            warn("Syntax Error in " .. FileName .. ": " .. tostring(err))
        end
    end
end

-- [[ 6. DASHBOARD INFO ]]
Tabs.Dashboard:AddParagraph({
    Title = "WELCOME TO RHDXP HUB",
    Content = "User: " .. game.Players.LocalPlayer.DisplayName .. "\nStatus: Premium / Free\n\nFollow TikTok: @RHDXP7"
})

-- [[ 7. INITIALIZE ALL MODULES ]]
task.spawn(function()
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Events", Tabs.Events)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({ Title = "RHDXP HUB", Content = "Semua modul berhasil dimuat!", Duration = 5 })
end)
