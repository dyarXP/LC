return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local workspace = game:GetService("Workspace")

    -- [[ DEFINISI SERVICES ]]
    -- Mengambil service Knit secara dinamis untuk menghindari error loadstring
    local KnitPath = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
    local KnitServices = KnitPath:WaitForChild("Services")
    
    local PlaytimeRF = KnitServices:WaitForChild("PlaytimeRewardService"):WaitForChild("RF"):WaitForChild("ClaimReward")
    local ContainerRF = KnitServices:WaitForChild("ContainerService"):WaitForChild("RF")
    local LuckyBlockRF = KnitServices:WaitForChild("LuckyBlockService"):WaitForChild("RF")

    -- Variabel Config sederhana untuk Lucky Block
    local LuckyBlockConfig = { ["Lucky Block"] = true, ["Super Lucky Block"] = true }

    -- [[ SECTION: FARMING SYSTEM ]]
    local FarmSection = Tab:AddSection("Farming System")

    -- 1. Auto Claim Playtime
    Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = true })
    task.spawn(function()
        while true do
            task.wait(10)
            if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                for i = 1, 12 do
                    if not Options.AutoClaimPlaytime.Value then break end
                    pcall(function() PlaytimeRF:InvokeServer(i) end)
                end
            end
        end
    end)

    -- 2. Auto Collect Money
    Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
    task.spawn(function()
        while true do
            task.wait(1)
            if Options.AutoCollectMoney and Options.AutoCollectMoney.Value then
                local plots = workspace:FindFirstChild("Plots")
                if plots then
                    for i = 1, 30 do
                        if not Options.AutoCollectMoney.Value then break end
                        local targetPlot = plots:FindFirstChild(tostring(i))
                        if targetPlot then
                            for _, subFolder in ipairs(targetPlot:GetChildren()) do
                                local containers = subFolder:FindFirstChild("Containers")
                                if containers then
                                    for _, group in ipairs(containers:GetChildren()) do
                                        for _, item in ipairs(group:GetChildren()) do
                                            local collection = item:FindFirstChild("Collection")
                                            local pad = collection and collection:FindFirstChild("CollectionPad")
                                            if pad and pad:IsA("BasePart") then
                                                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                                if root then
                                                    firetouchinterest(root, pad, 0)
                                                    task.wait()
                                                    firetouchinterest(root, pad, 1)
                                                    task.wait(0.1)
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
        end
    end)

    -- 3. Auto Farm Event (Priority)
    local running = false
    local AutoFarmToggle = Tab:AddToggle("AutoFarmToggle", { Title = "Auto Farm (Event Priority)", Default = false })
    AutoFarmToggle:OnChanged(function(state)
        running = state
        if state then
            task.spawn(function()
                while running do
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    local userId = player.UserId
                    local modelsFolder = workspace:WaitForChild("RunningModels")
                    local collectZones = workspace:WaitForChild("CollectZones")
                    
                    local target = collectZones:WaitForChild("base15")
                    local priorityList = {"ZEUS", "DEVIL", "CIRCUS", "FLAPPY", "INK", "1X"}
                    for _, eventName in ipairs(priorityList) do
                        local eventZone = collectZones:FindFirstChild(eventName)
                        if eventZone then target = eventZone break end
                    end

                    root.CFrame = CFrame.new(715, 39, -2122)
                    task.wait(0.1)
                    root.CFrame = CFrame.new(710, 39, -2122)

                    local ownedModel = nil
                    repeat
                        task.wait(0.1)
                        for _, obj in ipairs(modelsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj:GetAttribute("OwnerId") == userId then ownedModel = obj break end
                        end
                    until ownedModel ~= nil or not running

                    if not running then break end

                    if ownedModel.PrimaryPart then ownedModel:SetPrimaryPartCFrame(target.CFrame) end
                    task.wait(0.2)
                    if ownedModel and ownedModel.Parent == modelsFolder then
                        local targetPos = target.CFrame * CFrame.new(0, -5, 0)
                        if ownedModel.PrimaryPart then ownedModel:SetPrimaryPartCFrame(targetPos) end
                    end

                    repeat task.wait(0.1) until not running or (ownedModel == nil or ownedModel.Parent ~= modelsFolder)
                    
                    if not running then break end

                    local oldCharacter = player.Character
                    repeat task.wait(0.1) until not running or (player.Character ~= oldCharacter and player.Character ~= nil)
                    
                    if not running then break end
                    task.wait(0.2)
                    local newRoot = player.Character:WaitForChild("HumanoidRootPart")
                    newRoot.CFrame = CFrame.new(737, 39, -2118)
                    task.wait(1.5)
                end
            end)
        end
    end)

    -- [[ SECTION: BRAINROT & LUCKY BLOCK ]]
    local ManageSection = Tab:AddSection("Brainrot & Lucky Block")

    -- 4. Auto Pickup
    Tab:AddToggle("AutoPickup", { Title = "Auto Pickup All (1-30)", Default = false })
    task.spawn(function()
        local pickupRemote = ContainerRF:WaitForChild("PickupBrainrot")
        while true do
            task.wait(1) 
            if Options.AutoPickup and Options.AutoPickup.Value then
                for i = 1, 30 do
                    if not Options.AutoPickup.Value then break end
                    pcall(function() pickupRemote:InvokeServer(tostring(i)) end)
                    task.wait(0.02)
                end
            end
        end
    end)

    -- 5. Auto Place Best
    Tab:AddToggle("AutoPlaceBest", { Title = "Auto Place Best Brainrot", Default = false })
    task.spawn(function()
        local placeBestRemote = ContainerRF:WaitForChild("PlaceBest")
        while true do
            task.wait(1.5)
            if Options.AutoPlaceBest and Options.AutoPlaceBest.Value then pcall(function() placeBestRemote:InvokeServer() end) end
        end
    end)

    -- 6. Lucky Block Selector
    local LuckyDropdown = Tab:AddDropdown("SelectedLucky", { Title = "Select Lucky Block to Open", Values = {"None"}, Multi = false, Default = 1 })
    task.spawn(function()
        while true do
            local availableBlocks = {}
            local found = false
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (LuckyBlockConfig[item.Name] or item.Name:lower():find("block")) then
                        if not table.find(availableBlocks, item.Name) then table.insert(availableBlocks, item.Name) found = true end
                    end
                end
            end
            if not found then table.insert(availableBlocks, "None") end
            LuckyDropdown:SetValues(availableBlocks)
            task.wait(3)
        end
    end)

    -- 7. Auto Open Lucky Block
    Tab:AddToggle("AutoLucky", { Title = "Auto Open Selected (Plot 1)", Default = false })
    task.spawn(function()
        while true do
            task.wait(1.2)
            if Options.AutoLucky and Options.AutoLucky.Value then
                local selectedName = Options.SelectedLucky.Value
                if selectedName and selectedName ~= "None" then
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    local character = LocalPlayer.Character
                    local targetTool = (character and character:FindFirstChild(selectedName)) or (backpack and backpack:FindFirstChild(selectedName))
                    if targetTool then
                        local uuid = targetTool:GetAttribute("EntityId")
                        if uuid then
                            pcall(function()
                                ContainerRF.PickupBrainrot:InvokeServer("1")
                                task.wait(0.2)
                                ContainerRF.Place:InvokeServer(uuid, "1")
                                task.wait(0.2)
                                LuckyBlockRF.Open:InvokeServer(uuid)
                            end)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end
