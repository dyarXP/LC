return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Ambil Knit Services secara aman
    local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))
    local KnitServices = Knit.Services

    -- [[ SALES MANAGER SECTION ]]
    local SellSec = Tab:AddSection("Sales Manager")

    -- 1. Setup UI Components
    Tab:AddToggle("SellToggle", {
        Title = "Enable Auto Sell", 
        Default = false
    })

    Tab:AddDropdown("MutationDropdown", { 
        Title = "Filter Mutation", 
        Values = {"NORMAL", "CANDY", "GOLD", "DIAMOND", "VOID"}, 
        Multi = true, 
        Default = {NORMAL = true} 
    })

    Tab:AddSlider("SellSlider", {
        Title = "Scan Delay (s)", 
        Default = 2, 
        Min = 0.5, 
        Max = 10, 
        Rounding = 1
    })

    -- 2. Auto Sell Logic (Looping)
    task.spawn(function()
        while true do
            -- Menggunakan delay dari slider, minimal 0.5 detik agar tidak lag
            local delayTime = (Options.SellSlider and Options.SellSlider.Value) or 2
            task.wait(math.max(delayTime, 0.5))

            if Options.SellToggle and Options.SellToggle.Value then
                local tools = {}
                
                -- Cek item di Backpack
                for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do 
                    if item:IsA("Tool") then table.insert(tools, item) end 
                end
                
                -- Cek item yang sedang dipegang (Character)
                if LocalPlayer.Character then 
                    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do 
                        if item:IsA("Tool") then table.insert(tools, item) end 
                    end 
                end

                -- Proses Penjualan berdasarkan Filter Mutation
                for _, tool in ipairs(tools) do
                    if not Options.SellToggle.Value then break end -- Berhenti jika toggle dimatikan di tengah jalan

                    local m = tool:GetAttribute("Mutation") or "NORMAL"
                    local entityId = tool:GetAttribute("EntityId")

                    -- Jika mutasi alat ada di dalam daftar filter yang dipilih (Dropdown)
                    if entityId and Options.MutationDropdown.Value[m:upper()] then 
                        pcall(function() 
                            KnitServices.InventoryService.RF.SellBrainrot:InvokeServer(entityId) 
                        end) 
                    end
                end
            end
        end
    end)
end
