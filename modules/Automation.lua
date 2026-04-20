return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    -- Knit Setup
    local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))
    local KnitServices = Knit.Services
    local PlaytimeRF = KnitServices.PlaytimeRewardService.RF.ClaimReward

    Tab:AddSection("Farming System")

    Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = true })
    task.spawn(function()
        while true do
            task.wait(10)
            if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                for i = 1, 12 do pcall(function() PlaytimeRF:InvokeServer(i) end) end
            end
        end
    end)

    Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
    task.spawn(function()
        while true do
            task.wait(1)
            if Options.AutoCollectMoney and Options.AutoCollectMoney.Value then
                pcall(function()
                    for i = 1, 30 do
                        local plot = workspace.Plots:FindFirstChild(tostring(i))
                        if plot then
                            for _, v in ipairs(plot:GetDescendants()) do
                                if v.Name == "CollectionPad" then
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    Tab:AddSection("Brainrot & Lucky Block")

    Tab:AddToggle("AutoPickup", { Title = "Auto Pickup All (1-30)", Default = false })
    task.spawn(function()
        while true do
            task.wait(1)
            if Options.AutoPickup and Options.AutoPickup.Value then
                for i = 1, 30 do pcall(function() KnitServices.ContainerService.RF.PickupBrainrot:InvokeServer(tostring(i)) end) end
            end
        end
    end)

    Tab:AddToggle("AutoPlaceBest", { Title = "Auto Place Best Brainrot", Default = false })
    task.spawn(function()
        while true do
            task.wait(2)
            if Options.AutoPlaceBest and Options.AutoPlaceBest.Value then 
                pcall(function() KnitServices.ContainerService.RF.PlaceBest:InvokeServer() end) 
            end
        end
    end)
end
