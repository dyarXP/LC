return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))
    local KnitServices = Knit.Services

    local FarmSection = Tab:AddSection("Farming System")

    -- Auto Claim Playtime
    Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = true })
    task.spawn(function()
        local PlaytimeRF = KnitServices:WaitForChild("PlaytimeRewardService"):WaitForChild("RF"):WaitForChild("ClaimGift")
        while true do
            task.wait(10)
            if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                for i = 1, 12 do pcall(function() PlaytimeRF:InvokeServer(i) end) end
            end
        end
    end)

    -- Auto Collect Money
    Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
    task.spawn(function()
        while true do
            task.wait(1)
            if Options.AutoCollectMoney and Options.AutoCollectMoney.Value then
                local plots = workspace:FindFirstChild("Plots")
                if plots then
                    for i = 1, 30 do
                        local targetPlot = plots:FindFirstChild(tostring(i))
                        if targetPlot then
                            for _, subFolder in ipairs(targetPlot:GetChildren()) do
                                local containers = subFolder:FindFirstChild("Containers")
                                if containers then
                                    for _, group in ipairs(containers:GetChildren()) do
                                        for _, item in ipairs(group:GetChildren()) do
                                            local pad = item:FindFirstChild("Collection") and item.Collection:FindFirstChild("CollectionPad")
                                            if pad and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pad, 0)
                                                task.wait()
                                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, pad, 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
