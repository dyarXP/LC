-- [[ RHDXP HUB - FINAL STABLE INTEGRATED ]]
local Username = "dyarXP" 
local Repo = "LC" 
local Branch = "main"
local BaseURL = "https://raw.githubusercontent.com/"..Username.."/"..Repo.."/"..Branch.."/"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local UserInputService = game:GetService("UserInputService")

-- [[ 1. CREATE WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "RHDXP HUB",
    SubTitle = "Be A Lucky Block",
    TabWidth = 170,
    Size = UDim2.fromOffset(600, 480),
    MinimizeKey = Enum.KeyCode.End -- Tombol keyboard untuk sembunyikan GUI
})

-- [[ 2. FLOATING LOGO SYSTEM (FORCE ENABLED & DRAGGABLE) ]]
local MiniUI = Instance.new("ScreenGui")
local MiniButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

MiniUI.Name = "RHDXP_RECOVERY_UI"
MiniUI.Parent = (gethui or function() return game:GetService("CoreGui") end)()
MiniUI.Enabled = false 
MiniUI.DisplayOrder = 9999

MiniButton.Name = "FloatingIcon"
MiniButton.Parent = MiniUI
MiniButton.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MiniButton.Position = UDim2.new(0.05, 0, 0.4, 0)
MiniButton.Size = UDim2.new(0, 75, 0, 30)
MiniButton.Text = "RHDXP"
MiniButton.TextColor3 = Color3.fromRGB(0, 255, 255)
MiniButton.Font = Enum.Font.Code
MiniButton.TextSize = 15
MiniButton.ZIndex = 10000

UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MiniButton
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MiniButton

-- Fungsi Drag Logo
local dragging, dragStart, startPos
MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true 
        dragStart = input.Position 
        startPos = MiniButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MiniButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MiniButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Klik Logo untuk Buka Kembali
MiniButton.MouseButton1Click:Connect(function() 
    if Window then 
        Window:Minimize() 
    end 
end)

-- LOGIKA MONITORING AGRESSIVE (Deteksi jika GUI utama sembunyi)
task.spawn(function()
    while true do
        task.wait(0.3)
        local shouldShowLogo = false
        
        pcall(function()
            if Window and Window.Root then
                local Main = Window.Root:FindFirstChild("Main") or Window.Root:FindFirstChildOfClass("Frame")
                
                -- Jika Main Frame tidak terlihat atau dibuang ke bawah layar (Minimize)
                if Main then
                    if Main.Visible == false or Main.AbsolutePosition.Y > 2000 then
                        shouldShowLogo = true
                    end
                end
            end
            
            -- Tampilkan/Sembunyikan Logo
            MiniUI.Enabled = shouldShowLogo
            
            -- Proteksi Parent agar tidak dihapus sistem
            local target = (gethui or function() return game:GetService("CoreGui") end)()
            if MiniUI.Parent ~= target then MiniUI.Parent = target end
        end)
    end
end)

-- [[ 3. REGISTER TABS ]]
local Tabs = {
    Dashboard = Window:AddTab({ Title = "DASHBOARD", Icon = "layout-grid" }),
    Farm      = Window:AddTab({ Title = "AUTOMATION", Icon = "cpu" }),
    Upgrades  = Window:AddTab({ Title = "UPGRADES", Icon = "trending-up" }),
    Sell      = Window:AddTab({ Title = "AUTO SELL", Icon = "dollar-sign" }),
    Trading   = Window:AddTab({ Title = "TRADING", Icon = "arrow-left-right" }),
    Events    = Window:AddTab({ Title = "EVENTS", Icon = "calendar" }),
    Misc      = Window:AddTab({ Title = "MISC", Icon = "settings" })
}

-- [[ 4. DASHBOARD ]]
Tabs.Dashboard:AddParagraph({
    Title = "RHDXP HUB",
    Content = "Halo, " .. game.Players.LocalPlayer.DisplayName .. "!\nInterface dibersihkan untuk fungsi Minimize yang lebih stabil.\n\nTikTok: @RHDXP7"
})

-- [[ 5. MODULE LOADER ENGINE ]]
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
                if not s then warn("Error Modul [" .. FileName .. "]: " .. e) end
            end)
        end
    end
end

-- [[ 6. EXECUTE LOADING ]]
task.spawn(function()
    task.wait(1)
    LoadModule("Automation", Tabs.Farm)
    LoadModule("Upgrades", Tabs.Upgrades)
    LoadModule("Sell", Tabs.Sell)
    LoadModule("Trading", Tabs.Trading)
    LoadModule("Events", Tabs.Events)
    LoadModule("Misc", Tabs.Misc)
    
    Fluent:Notify({
        Title = "RHDXP HUB",
        Content = "Semua modul berhasil dimuat!",
        Duration = 5
    })
end)

Window:SelectTab(1)
