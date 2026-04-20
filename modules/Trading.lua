return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local TradingSection = Tab:AddSection("Gifting System")

    -- [[ 1. UI COMPONENTS ]]
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

    -- [[ 2. FUNGSI SCANNING UTAMA ]]
    local function RefreshInventory()
        local invList = {}
        local displayNames = {}

        -- A. SCAN BACKPACK & CHARACTER (Item Fisik)
        local function scanContainer(container)
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    -- Cek semua kemungkinan nama Attribute ID
                    local id = item:GetAttribute("EntityId") or item:GetAttribute("ID") or item:GetAttribute("uuid")
                    if id then
                        local mutation = item:GetAttribute("Mutation") or "NORMAL"
                        local name = string.format("[%s] %s (%s)", mutation:upper(), item.Name, tostring(id):sub(1,5))
                        invList[name] = id
                        table.insert(displayNames, name)
                    end
                end
            end
        end

        scanContainer(LocalPlayer.Backpack)
        if LocalPlayer.Character then scanContainer(LocalPlayer.Character) end

        -- B. SCAN REPLICA DATA (Data Server)
        pcall(function()
            local RC = _G.ReplicaController
            if not RC then
                -- Cari ulang ReplicaController jika belum ada
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v.Name == "ReplicaController" and v:IsA("ModuleScript") then
                        RC = require(v)
                        _G.ReplicaController = RC
                        break
                    end
                end
            end

            if RC and RC.GetPlayerData then
                local data = RC:GetPlayerData()
                if data and data.Inventory then
                    for uuid, item in pairs(data.Inventory) do
                        local inner = item.innerEntity
                        if inner then
                            local n = string.format("[DATA] %s Lvl.%s", tostring(inner.brainrotType or "ITEM"):upper(), tostring(inner.level or 1))
                            -- Masukkan jika belum ada di list backpack
                            if not invList[n] then 
                                invList[n] = uuid 
                                table.insert(displayNames, n)
                            end
                        end
                    end
                end
            end
        end)

        -- C. UPDATE UI
        if #displayNames == 0 then table.insert(displayNames, "None") end
        ItemDropdown:SetValues(displayNames)
        _G.InvMapping = invList
        
        Fluent:Notify({Title = "Inventory", Content = "Daftar item telah diperbarui!", Duration = 2})
    end

    -- [[ 3. TOMBOL REFRESH MANUAL ]]
    Tab:AddButton({
        Title = "REFRESH ITEM LIST",
        Description = "Klik jika item di tas tidak muncul",
        Callback = RefreshInventory
    })

    -- [[ 4. AUTOMATIC UPDATES (Loop) ]]
    task.spawn(function()
        while true do
            -- Update Player List
            local pList = {"None"}
            for _, p in ipairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer then table.insert(pList, p.Name) end 
            end
            pcall(function() PlayerDropdown:SetValues(pList) end)
            
            -- Auto Refresh Item setiap 15 detik (biar tidak lag)
            RefreshInventory()
            task.wait(15)
        end
    end)

    -- [[ 5. SEND BUTTON ]]
    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local targetName = Options.TradeTarget.Value
            local selectedItems = Options.TradeItems.Value
            local targetP = Players:FindFirstChild(targetName)
            
            if not targetP or targetName == "None" then return end

            -- Cari Remote
            local GiftingRF
            pcall(function()
                local index = ReplicatedStorage.Packages._Index
                for _, v in ipairs(index:GetChildren()) do
                    if v.Name:find("knit") then
                        GiftingRF = v.knit.Services.GiftingService.RF:FindFirstChild("GiftBrainrot")
                    end
                end
            end)

            if not GiftingRF then return end

            for displayName, isSelected in pairs(selectedItems) do
                if isSelected and _G.InvMapping[displayName] then
                    pcall(function() GiftingRF:InvokeServer(_G.InvMapping[displayName], targetP) end)
                    task.wait(0.3)
                end
            end
            Fluent:Notify({Title = "Success", Content = "Gifting Selesai!", Duration = 5})
        end
    })
end
