return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ 1. FUNGSI PENCARI REMOTE AMAN ]]
    local function GetGiftingRemote()
        local success, result = pcall(function()
            local index = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
            for _, v in ipairs(index:GetChildren()) do
                if v.Name:find("knit") then
                    local s = v:FindFirstChild("knit") and v.knit:FindFirstChild("Services")
                    if s then
                        local gift = s:FindFirstChild("GiftingService") or s:FindFirstChild("TradeService")
                        if gift and gift:FindFirstChild("RF") then
                            return gift.RF:FindFirstChild("GiftBrainrot") or gift.RF:FindFirstChild("SendGift")
                        end
                    end
                end
            end
        end)
        return success and result or nil
    end

    -- [[ 2. FUNGSI PENCARI DATA PLAYER AMAN ]]
    local function GetPlayerData()
        local success, data = pcall(function()
            -- Mencoba mengambil dari Global Variable atau Require manual
            local RC = _G.ReplicaController
            if not RC then
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v.Name == "ReplicaController" and v:IsA("ModuleScript") then
                        RC = require(v)
                        break
                    end
                end
            end
            return RC and RC.GetPlayerData and RC:GetPlayerData()
        end)
        return success and data or nil
    end

    local TradingSection = Tab:AddSection("Gifting System")

    -- [[ 3. UI COMPONENTS ]]
    local PlayerDropdown = Tab:AddDropdown("TradeTarget", { 
        Title = "Select Target Player", 
        Values = {"None"}, 
        Multi = false, 
        Default = 1 
    })

    local ItemDropdown = Tab:AddDropdown("TradeItems", { 
        Title = "Select Items to Gift", 
        Values = {"None"}, 
        Multi = true, 
        Default = {}, 
    })

    _G.InvMapping = {}

    -- Loop Update List Pemain
    task.spawn(function()
        while true do
            local pList = {"None"}
            for _, p in ipairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer then table.insert(pList, p.Name) end 
            end
            pcall(function() PlayerDropdown:SetValues(pList) end)
            task.wait(5)
        end
    end)

    -- Loop Update List Item (Paling Rawan Error - Dibungkus Pcall)
    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}
            
            local data = GetPlayerData()
            if data and data.Inventory then
                for uuid, item in pairs(data.Inventory) do
                    pcall(function()
                        local inner = item.innerEntity
                        if inner and inner.brainrotType then
                            local name = string.format("[%s] Lvl.%s (%s)", tostring(inner.brainrotType):upper(), tostring(inner.level or 1), uuid:sub(1,5))
                            invList[name] = uuid
                            table.insert(displayNames, name)
                        end
                    end)
                end
            end

            if #displayNames == 0 then table.insert(displayNames, "None") end
            
            pcall(function() 
                ItemDropdown:SetValues(displayNames)
                _G.InvMapping = invList
            end)
            task.wait(5)
        end
    end)

    -- Tombol Kirim
    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local targetName = Options.TradeTarget.Value
            local selectedItems = Options.TradeItems.Value
            local targetP = Players:FindFirstChild(targetName)
            local remote = GetGiftingRemote()

            if not remote then 
                return Fluent:Notify({Title = "Error", Content = "Remote tidak ditemukan!", Duration = 3}) 
            end

            if not targetP or targetName == "None" then 
                return Fluent:Notify({Title = "Error", Content = "Pilih pemain dulu!", Duration = 3}) 
            end

            local hasSelection = false
            for _, v in pairs(selectedItems) do if v then hasSelection = true break end end
            if not hasSelection then return end

            for displayName, isSelected in pairs(selectedItems) do
                if isSelected and _G.InvMapping[displayName] then
                    local uuid = _G.InvMapping[displayName]
                    pcall(function() remote:InvokeServer(uuid, targetP) end)
                    task.wait(0.3)
                end
            end
            Fluent:Notify({Title = "Success", Content = "Transfer Selesai!", Duration = 5})
        end
    })
end
