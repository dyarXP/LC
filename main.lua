-- [[ RHDXP HUB - MASTER LOADER FINAL ]]
-- DEVELOPER: RHDXP (@RHDXP7)
-- REPO: dyarXP/LC
-- STATUS: STABLE & MODULAR

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

-- Proteksi GUI agar aman dari deteksi dasar executor
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

-- Draggable Logic (Sistem Seret Tombol agar bisa dipindah)
local dragging, dragStart, startPos
MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true 
        dragStart = input.Position 
        startPos = MiniButton.Position
        input.Changed:Connect(function() 
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
            end 
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MiniButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Click Logic: Membuka kembali menu utama saat Logo diklik
MiniButton.MouseButton1Click:Connect(function() 
    MiniUI.Enabled = false 
    if Window.Root then
        Window.Root.Visible = true
        -- Memastikan Frame utama Fluent muncul kembali
        local MainFrame = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
        if MainFrame then MainFrame.Visible = true end
    end
end)

-- Auto Detect Logic: Mendeteksi status minimize menu utama
task.spawn(function()
    while task.wait(0.3) do
        if Window.Root then
            local MainFrame = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
            -- Cek apakah root atau main frame sedang disembunyikan
            local isHidden = (Window.Root.Visible == false) or (MainFrame and MainFrame.Visible == false)
            
            if isHidden then
                if not MiniUI.Enabled then MiniUI.Enabled = true end
            else
                if MiniUI.Enabled then MiniUI.Enabled = false end
            end
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
            if not moduleStatus then warn("Error in module " .. FileName .. ": " .. tostring(moduleErr)) end
        else
            warn("Syntax Error in " .. FileName .. ": " .. tostring(err))
        end
    else
        warn("Gagal mendownload modul: " .. FileName)
    end
end

-- [[ 6. DASHBOARD INFO ]]
Tabs.Dashboard:AddParagraph({
    Title = "RHDXP HUB ONLINE",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\n\nTekan tombol 'End' untuk Minimize menu.\nKlik logo RHDXP yang muncul di layar untuk membuka kembali menu utama."
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
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Script berhasil dimuat sepenuhnya!",
        Duration = 5
    })
end)
