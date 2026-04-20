return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ UI SECTION ]]
    local TradingSection = Tab:AddSection("Gifting System")

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

    -- Variabel untuk menyimpan mapping Nama -> ID
    _G.InvMapping = {}

    -- [[ 1. UPDATE PLAYER LIST ]]
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

    -- [[ 2. UPDATE ITEM LIST (BACKPACK + REPLICA) ]]
    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}

            -- A. Cek dari Backpack (Item fisik)
            local function scanContainer(container)
                for _, item in ipairs(container:GetChildren()) do
                    if item:IsA("Tool") then
                        local id = item:GetAttribute("EntityId") or item:GetAttribute("ID")
                        if id then
                            local mutation = item:GetAttribute("Mutation") or "NORMAL"
                            local name = string.format("[%s] %s (%s)", mutation:upper(), item.Name, tostring(id):sub(1,5))
                            invList[name] = id
                        end
                    end
                end
            end

            scanContainer(LocalPlayer.Backpack)
            if LocalPlayer.Character then scanContainer(LocalPlayer.Character) end

            -- B. Cek dari ReplicaController (Data server)
            pcall(function()
                local RC = _G.ReplicaController or (ReplicatedStorage:FindFirstChild("ReplicaController") and require(ReplicatedStorage.ReplicaController))
                if RC and RC.GetPlayerData then
                    local data = RC:GetPlayerData()
                    if data and data.Inventory then
                        for uuid, item in pairs(data.Inventory) do
                            local inner = item.innerEntity
                            if inner then
                                local n = string.format("[DATA] %s Lvl.%s", tostring(inner.brainrotType or "Item"):upper(), tostring(inner.level or 1))
                                if not invList[n] then invList[n] = uuid end
                            end
                        end
                    end
                end
            end)

            -- C. Masukkan ke UI
            for k, _ in pairs(invList) do table.insert(displayNames, k) end
            if #displayNames == 0 then table.insert(displayNames, "None") end
            
            ItemDropdown:SetValues(displayNames)
            _G.InvMapping = invList
            task.wait(5)
        end
    end)

    -- [[ 3. SEND BUTTON ]]
    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local targetName = Options.TradeTarget.Value
            local selectedDisplayNames = Options.TradeItems.Value
            local targetP = Players:FindFirstChild(targetName)

            if not targetP or targetName == "None" then 
                return Fluent:Notify({Title = "Error", Content = "Pilih pemain dulu!", Duration = 3}) 
            end

            -- Cari Remote Gifting secara dinamis
            local GiftingRF
            pcall(function()
                local index = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
                for _, v in ipairs(index:GetChildren()) do
                    if v.Name:find("knit") then
                        GiftingRF = v.knit.Services.GiftingService.RF:FindFirstChild("GiftBrainrot")
                    end
                end
            end)

            if not GiftingRF then 
                return Fluent:Notify({Title = "Error", Content = "Sistem Gifting tidak ditemukan!", Duration = 3}) 
            end

            local count = 0
            for displayName, isSelected in pairs(selectedDisplayNames) do
                if isSelected and _G.InvMapping[displayName] then
                    count = count + 1
                    local uuid = _G.InvMapping[displayName]
                    pcall(function() GiftingRF:InvokeServer(uuid, targetP) end)
                    task.wait(0.3)
                end
            end

            if count > 0 then
                Fluent:Notify({Title = "Success", Content = "Berhasil mengirim "..count.." item!", Duration = 5})
            else
                Fluent:Notify({Title = "Error", Content = "Tidak ada item yang dipilih!", Duration = 3})
            end
        end
    })
end
