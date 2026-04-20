return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ AUTO-PATH FINDER ]]
    local function GetSellRemote()
        -- Mencari folder Knit secara dinamis
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        if not packages then return nil end
        
        local index = packages:FindFirstChild("_Index")
        if not index then return nil end

        for _, v in ipairs(index:GetChildren()) do
            if v.Name:find("knit") then
                local services = v:FindFirstChild("knit") and v.knit:FindFirstChild("Services")
                if services then
                    -- Cek InventoryService atau BrainrotService (tergantung update game)
                    local inv = services:FindFirstChild("InventoryService") or services:FindFirstChild("BrainrotService")
                    if inv and inv:FindFirstChild("RF") then
                        return inv.RF:FindFirstChild("SellBrainrot") or inv.RF:FindFirstChild("Sell")
                    end
                end
            end
        end
        return nil
    end

    local SellSec = Tab:AddSection("Sales Manager")

    Tab:AddToggle("SellToggle", {Title = "Enable Auto Sell", Default = false})
    Tab:AddDropdown("MutationDropdown", { 
        Title = "Filter Mutation", 
        Values = {"NORMAL", "CANDY", "GOLD", "DIAMOND", "VOID"}, 
        Multi = true, 
        Default = {NORMAL = true} 
    })
    Tab:AddSlider("SellSlider", {Title = "Scan Delay (s)", Default = 2, Min = 0.5, Max = 10, Rounding = 1})

    task.spawn(function()
        while true do
            local delay = (Options.SellSlider and Options.SellSlider.Value) or 2
            task.wait(math.max(delay, 0.5))

            if Options.SellToggle and Options.SellToggle.Value then
                local remote = GetSellRemote()
                
                if not remote then
                    -- Kalau remote tidak ketemu, kasih tau lewat notifikasi (hanya sekali)
                    Fluent:Notify({
                        Title = "RHDXP Hub Error",
                        Content = "Remote Sell tidak ditemukan! Game mungkin update.",
                        Duration = 3
                    })
                    task.wait(5) -- Jeda lebih lama agar tidak spam notif
                    continue
                end

                -- Ambil semua item
                local tools = {}
                for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do 
                    if item:IsA("Tool") then table.insert(tools, item) end 
                end
                if LocalPlayer.Character then 
                    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do 
                        if item:IsA("Tool") then table.insert(tools, item) end 
                    end 
                end

                -- Proses Jual
                for _, tool in ipairs(tools) do
                    if not Options.SellToggle.Value then break end
                    
                    -- Deteksi Mutasi & ID
                    local mutation = tool:GetAttribute("Mutation") or "NORMAL"
                    local entityId = tool:GetAttribute("EntityId") or tool:GetAttribute("ID")
                    
                    if entityId and Options.MutationDropdown.Value[mutation:upper()] then 
                        pcall(function() 
                            remote:InvokeServer(entityId) 
                        end) 
                    end
                end
            end
        end
    end)
end
