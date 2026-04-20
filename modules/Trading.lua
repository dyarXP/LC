return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    Tab:AddSection("Gifting System")

    local PlayerDropdown = Tab:AddDropdown("TradeTarget", { Title = "Select Target Player", Values = {"None"}, Multi = false, Default = 1 })
    local ItemDropdown = Tab:AddDropdown("TradeItems", { Title = "Select Items to Gift", Values = {"None"}, Multi = true, Default = {} })

    _G.InvMapping = {}

    -- Player Update
    task.spawn(function()
        while true do
            local pList = {"None"}
            for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pList, p.Name) end end
            pcall(function() PlayerDropdown:SetValues(pList) end)
            task.wait(5)
        end
    end)

    -- Item Update
    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}
            pcall(function()
                local RC = _G.ReplicaController or (game:GetService("ReplicatedStorage"):FindFirstChild("ReplicaController") and require(game:GetService("ReplicatedStorage").ReplicaController))
                if RC then
                    local data = RC:GetPlayerData()
                    if data and data.Inventory then
                        for uuid, item in pairs(data.Inventory) do
                            local name = "["..tostring(item.innerEntity.brainrotType or "Item").."] " .. uuid:sub(1,5)
                            invList[name] = uuid
                            table.insert(displayNames, name)
                        end
                    end
                end
            end)
            if #displayNames == 0 then table.insert(displayNames, "None") end
            ItemDropdown:SetValues(displayNames)
            _G.InvMapping = invList
            task.wait(10)
        end
    end)

    Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Callback = function()
            local target = Players:FindFirstChild(Options.TradeTarget.Value)
            if not target then return end
            for name, isSelected in pairs(Options.TradeItems.Value) do
                if isSelected and _G.InvMapping[name] then
                    pcall(function() 
                        -- Mencari Remote secara manual agar tidak crash
                        local r = ReplicatedStorage.Packages._Index:FindFirstChildOfClass("Folder"):FindFirstChild("knit").Services.GiftingService.RF.GiftBrainrot
                        r:InvokeServer(_G.InvMapping[name], target) 
                    end)
                    task.wait(0.5)
                end
            end
        end
    })
end
