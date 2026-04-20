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

-- [[ TAB: DASHBOARD ]]
Tabs.Dashboard:AddParagraph({
    Title = "USER PROFILE",
    Content = string.format("DISPLAY NAME: %s\nUSERNAME: @%s\nUSER ID: %d", LocalPlayer.DisplayName, LocalPlayer.Name, LocalPlayer.UserId)
})

Tabs.Dashboard:AddParagraph({
    Title = "DEVELOPER DETAILS",
    Content = "Developed by: RHDXP\nTikTok: https://tiktok.com/@rhdxp7"
})

-- [[ ANTI-IDLE LOGIC ]]
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

task.spawn(function()
    while true do
        task.wait(100)
        pcall(function()
            if not game:GetService("UserInputService"):GetFocusedTextBox() then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0,0))
            end
        end)
    end
end)

-- [[ MINIMIZE BUTTON ]]
local MiniUI = Instance.new("ScreenGui")
local MiniButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

MiniUI.Name = "RHDXP_Minimize"
MiniUI.Parent = (gethui or function() return game:GetService("CoreGui") end)()
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

-- [[ TABS ]]
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Upgrades = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ CLEAN LOADER ]]
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)
    
    if success and content then
        local func, err = loadstring(content)
        if func then
            local s, e = pcall(function() func()(TabObject, Fluent, Window) end)
            if not s then warn("Runtime Error " .. FileName .. ": " .. tostring(e)) end
        else
            warn("Syntax Error " .. FileName .. ": " .. tostring(err))
        end
    end
end

-- [[ START LOADING ]]
task.spawn(function()
    task.wait(1)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Misc", Tabs.Misc)
    Window:SelectTab(1)
end)
