return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ DYNAMIC REMOTE & REPLICA DETECTION ]]
    -- Kita cari Gifting Service secara dinamis agar tidak crash jika game update
    local function GetGiftingRemote()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        if not packages then return nil end
        local index = packages:FindFirstChild("_Index")
        if not index then return nil end

        for _, v in ipairs(index:GetChildren()) do
            if v.Name:find("knit") then
                local services = v:FindFirstChild("knit") and v.knit:FindFirstChild("Services")
                if services then
                    local giftService = services:FindFirstChild("GiftingService") or services:FindFirstChild("TradeService")
                    if giftService and giftService:FindFirstChild("RF") then
                        return giftService.RF:FindFirstChild("GiftBrainrot") or giftService.RF:FindFirstChild("SendGift")
                    end
                end
            end
        end
        return nil
    end

    -- Simulasi atau pemanggilan ReplicaController (Pastikan script utama kamu sudah meload ReplicaController)
    local ReplicaController = _G.ReplicaController or (pcall(function() return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ReplicaController")) end) and require(ReplicatedStorage.Modules.ReplicaController))

    local TradingSection = Tab:AddSection("Gifting System")

    -- 1. Player Selection Dropdown
    local PlayerDropdown = Tab:AddDropdown("TradeTarget", { 
        Title = "Select Target Player", 
        Values = {"None"}, 
        Multi = false, 
        Default = 1 
    })

    task.spawn(function()
        while true do
            local pList = {"None"}
            for _, p in ipairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer then table.insert(pList, p.Name) end 
            end
            PlayerDropdown:SetValues(pList)
            task.wait(5)
        end
    end)

    -- 2. Item Selection Dropdown
    local ItemDropdown = Tab:AddDropdown("TradeItems", { 
        Title = "Select Items to Gift", 
        Values = {"None"}, 
        Multi = true, 
        Default = {}, 
    })

    _G.InvMapping = {}

    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}
            
            -- Cek apakah ReplicaController tersedia
            if ReplicaController and ReplicaController.GetPlayerData then
                local data = ReplicaController:GetPlayerData()
                if data and data.Inventory then
                    for uuid, item in pairs(data.Inventory) do
                        local inner = item.innerEntity
                        if inner and inner.brainrotType then
                            local name = string.format("[%s] Lvl.%s (%s)", tostring(inner.brainrotType):upper(), tostring(inner.level or 1), uuid:sub(1,5))
                            invList[name] = uuid
                            table.insert(displayNames, name)
                        end
                    end
                end
            end

            if #displayNames == 0 then table.insert(displayNames, "None") end
            
            ItemDropdown:SetValues(displayNames)
            _G.InvMapping = invList
            task.wait(5)
        end
    end)

    -- 3. Send Button
    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local targetName = Options.TradeTarget.Value
            local selectedDisplayNames = Options.TradeItems.Value
            local targetP = Players:FindFirstChild(targetName)
            local GiftingRF = GetGiftingRemote()

            if not GiftingRF then 
                return Fluent:Notify({Title = "Error", Content = "Gifting Remote not found!", Duration = 3}) 
            end

            if not targetP or targetName == "None" then 
                return Fluent:Notify({Title = "Error", Content = "Please select a valid player!", Duration = 3}) 
            end

            local count = 0
            for _, isSelected in pairs(selectedDisplayNames) do 
                if isSelected then count = count + 1 end 
            end

            if count == 0 then 
                return Fluent:Notify({Title = "Error", Content = "No items selected!", Duration = 3}) 
            end

            for displayName, isSelected in pairs(selectedDisplayNames) do
                if isSelected and _G.InvMapping[displayName] then
                    local uuid = _G.InvMapping[displayName]
                    pcall(function() 
                        GiftingRF:InvokeServer(uuid, targetP) 
                    end)
                    task.wait(0.3) -- Jeda antar pengiriman agar tidak dianggap spam
                end
            end

            Fluent:Notify({Title = "Success", Content = "Transfer Complete!", Duration = 5})
        end
    })
end
