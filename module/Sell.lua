return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Knit = require(ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit)

    Tab:AddSection("Sales Manager")
    Tab:AddToggle("SellToggle", {Title = "Enable Auto Sell", Default = false})
    Tab:AddDropdown("MutationDropdown", { Title = "Filter Mutation", Values = {"NORMAL", "CANDY", "GOLD", "DIAMOND", "VOID"}, Multi = true, Default = {NORMAL = true} })

    task.spawn(function()
        local SellRF = Knit.Services.InventoryService.RF.SellBrainrot
        while true do
            task.wait(2)
            if Options.SellToggle and Options.SellToggle.Value then
                local tools = LocalPlayer.Backpack:GetChildren()
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
