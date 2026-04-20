return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ 1. BUAT UI DULU (AGAR TIDAK KOSONG) ]]
    local TradingSection = Tab:AddSection("Gifting System")

    local PlayerDropdown = Tab:AddDropdown("TradeTarget", { 
        Title = "Select Target Player", 
        Values = {"None"}, 
        Multi = false, 
        Default = 1 
    })

    local ItemDropdown = Tab:AddDropdown("TradeItems", { 
        Title = "Select Items to Gift (Auto Update)", 
        Values = {"None"}, 
        Multi = true, 
        Default = {}, 
    })

    local SendBtn = Tab:AddButton({
        Title = "SEND SELECTED ITEMS",
        Description = "Kirim item yang dipilih ke pemain target",
        Callback = function()
            -- Logic Send akan kita panggil di bawah
        end
    })

    -- [[ 2. LOGIC PENCARIAN DATA (DIISOLASI AGAR TIDAK CRASH) ]]
    _G.InvMapping = {}

    -- Fungsi Cari Remote
    local function GetGiftRemote()
        local r = pcall(function()
            local index = ReplicatedStorage:FindFirstChild("Packages"):FindFirstChild("_Index")
            for _, v in ipairs(index:GetChildren()) do
                if v.Name:find("knit") then
                    return v.knit.Services.GiftingService.RF:FindFirstChild("GiftBrainrot")
                end
            end
        end)
        return r and _G.GiftRemote or nil
    end

    -- Loop Update Player
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

    -- Loop Update Inventory (Safe Mode)
    task.spawn(function()
        while true do
            local invList = {}
            local displayNames = {}
            
            local success, err = pcall(function()
                -- Cari ReplicaController secara paksa
                local RC = _G.ReplicaController
                if not RC then
                    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                        if v.Name == "ReplicaController" and v:IsA("ModuleScript") then
                            RC = require(v)
                            _G.ReplicaController = RC
                            break
                        end
                    end
                end

                if RC then
                    local data = RC:GetPlayerData()
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
            end)

            if #displayNames == 0 then table.insert(displayNames, "None") end
            
            pcall(function() 
                ItemDropdown:SetValues(displayNames)
                _G.InvMapping = invList
            end)
            task.wait(7)
        end
    end)

    -- [[ 3. UPDATE CALLBACK TOMBOL ]]
    SendBtn.Callback = function()
        local targetName = Options.TradeTarget.Value
        local selectedItems = Options.TradeItems.Value
        local targetP = Players:FindFirstChild(targetName)
        
        -- Cari remote saat tombol diklik
        local remote = GetGiftRemote()

        if not remote then 
            return Fluent:Notify({Title = "Error", Content = "Gifting Remote tidak ditemukan!", Duration = 3}) 
        end

        if not targetP or targetName == "None" then 
            return Fluent:Notify({Title = "Error", Content = "Pilih player target dulu!", Duration = 3}) 
        end

        for displayName, isSelected in pairs(selectedItems) do
            if isSelected and _G.InvMapping[displayName] then
                pcall(function() 
                    remote:InvokeServer(_G.InvMapping[displayName], targetP) 
                end)
                task.wait(0.3)
            end
        end
        Fluent:Notify({Title = "Success", Content = "Proses Gifting Selesai!", Duration = 5})
    end
end
