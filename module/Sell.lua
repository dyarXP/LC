return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Knit = require(ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit)

    Tab:AddSection("Sales Manager")
    Tab:AddToggle("SellToggle", {Title = "Enable Auto Sell", Default = false})
    Tab:AddDropdown("MutationDropdown", { Title = "Filter Mutation", Values = {"NORMAL", "CANDY", "GOLD", "DIAMOND", "VOID"}, Multi = true, Default = {NORMAL = true} })
    Tab:AddSlider("SellSlider", {Title = "Scan Delay (s)", Default = 2, Min = 0.5, Max = 10, Rounding = 1})

    task.spawn(function()
        local SellRF = Knit.Services.InventoryService.RF.SellBrainrot
        while true do
            task.wait(math.max(Options.SellSlider.Value, 0.5))
            if Options.SellToggle.Value then
                local tools = {}
                for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do if item:IsA("Tool") then table.insert(tools, item) end end
                if LocalPlayer.Character then for _, item in ipairs(LocalPlayer.Character:GetChildren()) do if item:IsA("Tool") then table.insert(tools, item) end end end
                
                for _, tool in ipairs(tools) do
                    local m = tool:GetAttribute("Mutation") or "NORMAL"
                    if Options.MutationDropdown.Value[m:upper()] then
                        pcall(function() SellRF:InvokeServer(tool:GetAttribute("EntityId")) end)
                    end
                end
            end
        end
    end)
end
