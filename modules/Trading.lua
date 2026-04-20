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

    -- [[ 2. LOGIC UPDATE PEMAIN ]]
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

    -- [[ 3. LOGIC SCAN ITEM (BACKPACK + DATA) ]]
    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}

            -- CARA A: Scan langsung dari Backpack (Tool yang sedang dibawa)
            local tools = {}
            for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") and v:GetAttribute("EntityId") then
                    table.insert(tools, v)
                end
            end
            if LocalPlayer.Character then
                for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") and v:GetAttribute("EntityId") then
                        table.insert(tools, v)
                    end
                end
            end

            for _, tool in ipairs(tools) do
                local id = tool:GetAttribute("EntityId")
                local m = tool:GetAttribute("Mutation") or "NORMAL"
                local name = string.format("[%s] %s (%s)", m:upper(), tool.Name, tostring(id):sub(1,5))
                
                invList[name] = id
                table.insert(displayNames, name)
            end

            -- CARA B: Sinkronisasi dengan ReplicaController (Jika ada)
            pcall(function()
                local RC = _G.ReplicaController
                if RC and RC.GetPlayerData then
                    local data = RC:GetPlayerData()
                    if data and data.Inventory then
                        for uuid, item in pairs(data.Inventory) do
                            local inner = item.innerEntity
                            if inner then
                                local n = string.format("[%s] Lvl.%s (Data)", tostring(inner.brainrotType or "ITEM"):upper(), tostring(inner.level or 1))
                                if not invList[n] then -- Hindari duplikat
                                    invList[n] = uuid
                                    table.insert(displayNames, n)
                                end
                            end
                        end
                    end
                end
            end)

            if #displayNames == 0 then table.insert(displayNames, "None") end
            
            pcall(function() 
                ItemDropdown:SetValues(displayNames)
                _G.InvMapping = invList
            end)
            task.wait(5)
        end
    end)

    -- [[ 4. SEND BUTTON ]]
    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local targetName = Options.TradeTarget.Value
            local selectedItems = Options.TradeItems.Value
            local targetP = Players:FindFirstChild(targetName)
            
            -- Cari Remote Gifting
            local remote
            pcall(function()
                local index = ReplicatedStorage.Packages._Index
                for _, v in ipairs(index:GetChildren()) do
                    if v.Name:find("knit") then
                        remote = v.knit.Services.GiftingService.RF:FindFirstChild("GiftBrainrot")
                    end
                end
            end)

            if not remote then return Fluent:Notify({Title = "Error", Content = "Gifting Remote Not Found", Duration = 3}) end
            if not targetP or targetName == "None" then return end

            for displayName, isSelected in pairs(selectedItems) do
                if isSelected and _G.InvMapping[displayName] then
                    pcall(function() 
                        remote:InvokeServer(_G.InvMapping[displayName], targetP) 
                    end)
                    task.wait(0.3)
                end
            end
            Fluent:Notify({Title = "Success", Content = "Gift Sent!", Duration = 3})
        end
    })
end
