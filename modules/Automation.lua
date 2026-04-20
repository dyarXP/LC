return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Fungsi untuk mencari Remote tanpa bikin script mati kalau gagal
    local function SafeRemote(serviceName, remoteName)
        local path = ReplicatedStorage:FindFirstChild("Packages")
        if path then
            path = path:FindFirstChild("_Index")
            if path then
                for _, v in ipairs(path:GetChildren()) do
                    if v.Name:find("sleitnick_knit") then
                        local remote = v:FindFirstChild("knit") and v.knit:FindFirstChild("Services")
                        if remote and remote:FindFirstChild(serviceName) then
                            return remote[serviceName].RF:FindFirstChild(remoteName)
                        end
                    end
                end
            end
        end
        return nil
    end

    Tab:AddSection("Farming System")

    -- 1. Auto Claim Playtime
    Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = false })
    task.spawn(function()
        while task.wait(10) do
            if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                local remote = SafeRemote("PlaytimeRewardService", "ClaimReward")
                if remote then pcall(function() remote:InvokeServer(1) end) end
            end
        end
    end)

    -- 2. Auto Collect Money (Plot 1-30)
    Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
    task.spawn(function()
        while task.wait(1) do
            if Options.AutoCollectMoney and Options.AutoCollectMoney.Value then
                pcall(function()
                    local plots = workspace:FindFirstChild("Plots")
                    if plots then
                        for i = 1, 30 do
                            local plot = plots:FindFirstChild(tostring(i))
                            if plot then
                                for _, v in ipairs(plot:GetDescendants()) do
                                    if v.Name == "CollectionPad" then
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    Tab:AddSection("Brainrot & Lucky Block")

    -- 3. Auto Pickup
    Tab:AddToggle("AutoPickup", { Title = "Auto Pickup All (1-30)", Default = false })
    task.spawn(function()
        while task.wait(1) do
            if Options.AutoPickup and Options.AutoPickup.Value then
                local remote = SafeRemote("ContainerService", "PickupBrainrot")
                if remote then
                    for i = 1, 30 do pcall(function() remote:InvokeServer(tostring(i)) end) end
                end
            end
        end
    end)

    -- 4. Auto Place Best
    Tab:AddToggle("AutoPlaceBest", { Title = "Auto Place Best Brainrot", Default = false })
    task.spawn(function()
        while task.wait(2) do
            if Options.AutoPlaceBest and Options.AutoPlaceBest.Value then
                local remote = SafeRemote("ContainerService", "PlaceBest")
                if remote then pcall(function() remote:InvokeServer() end) end
            end
        end
    end)
end
