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

-- [[ 3. MINIMIZE SYSTEM (FLOATING BUTTON) ]]
local UserInputService = game:GetService("UserInputService")
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

-- Draggable Logic
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

MiniButton.MouseButton1Click:Connect(function() 
    MiniUI.Enabled = false 
    if Window.Root then Window.Root.Visible = true end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Window.Root then
            local MainFrame = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
            local isHidden = (Window.Root.Visible == false) or (MainFrame and MainFrame.Visible == false)
            if isHidden then MiniUI.Enabled = true else MiniUI.Enabled = false end
        end
    end
end)

-- [[ TABS DEFINITION ]]
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Misc = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ MODULE LOADER ENGINE ]]
local function LoadModule(FileName, TabObject)
    local targetURL = BaseURL .. "modules/" .. FileName .. ".lua"
    local success, content = pcall(function() return game:HttpGet(targetURL) end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            local moduleStatus, moduleErr = pcall(function()
                -- Mengirimkan variabel penting ke dalam modul
                func()(TabObject, Fluent, Window)
            end)
            if not moduleStatus then warn("Runtime Error in " .. FileName .. ": " .. tostring(moduleErr)) end
        else
            warn("Syntax Error in " .. FileName .. ": " .. tostring(err))
        end
    else
        warn("Failed to download module: " .. FileName)
    end
end

-- [[ DASHBOARD INFO ]]
Tabs.Dashboard:AddParagraph({
    Title = "RHDXP HUB ONLINE",
    Content = "User: " .. game.Players.LocalPlayer.DisplayName .. "\nStatus: Premium\n\nSelamat menggunakan!"
})

-- [[ START LOADING ]]
task.spawn(function()
    task.wait(0.5) -- Safety delay agar Fluent siap
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Misc", Tabs.Misc)
    
    Window:SelectTab(1)
    Fluent:Notify({ Title = "RHDXP HUB", Content = "Semua modul berhasil dimuat!", Duration = 5 })
end)
