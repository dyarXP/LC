return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local function GetRemote(serviceName, remoteName)
        for _, v in ipairs(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):GetChildren()) do
            if v.Name:find("sleitnick_knit") then
                local s = v:FindFirstChild("knit") and v.knit:FindFirstChild("Services")
                if s and s:FindFirstChild(serviceName) then
                    return s[serviceName].RF:FindFirstChild(remoteName)
                end
            end
        end
        return nil
    end

    local SellSec = Tab:AddSection("Sales Manager")

    Tab:AddToggle("SellToggle", {Title = "Enable Auto Sell", Default = false})
    Tab:AddDropdown("MutationDropdown", { Title = "Filter Mutation", Values = {"NORMAL", "CANDY", "GOLD", "DIAMOND", "VOID"}, Multi = true, Default = {NORMAL = true} })
    Tab:AddSlider("SellSlider", {Title = "Scan Delay (s)", Default = 2, Min = 0.5, Max = 10, Rounding = 1})

    task.spawn(function()
        while true do
            local delay = (Options.SellSlider and Options.SellSlider.Value) or 2
            task.wait(math.max(delay, 0.5))

            if Options.SellToggle and Options.SellToggle.Value then
                local remote = GetRemote("InventoryService", "SellBrainrot")
                if not remote then continue end

                local tools = {}
                for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do if item:IsA("Tool") then table.insert(tools, item) end end
                if LocalPlayer.Character then for _, item in ipairs(LocalPlayer.Character:GetChildren()) do if item:IsA("Tool") then table.insert(tools, item) end end end

                for _, tool in ipairs(tools) do
                    if not Options.SellToggle.Value then break end
                    local m = tool:GetAttribute("Mutation") or "NORMAL"
                    local id = tool:GetAttribute("EntityId")
                    
                    if id and Options.MutationDropdown.Value[m:upper()] then 
                        pcall(function() remote:InvokeServer(id) end) 
                    end
                end
            end
        end
    end)
end
