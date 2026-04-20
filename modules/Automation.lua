return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    -- Proteksi: Tunggu sampai Knit tersedia di ReplicatedStorage
    local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
    if not Packages then 
        Tab:AddParagraph({Title = "Error", Content = "Folder Packages tidak ditemukan!"})
        return 
    end

    -- Mencari Knit Service secara spesifik
    local Knit = require(Packages:WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))
    local KnitServices = Knit.Services

    -- [[ SECTION ]]
    Tab:AddSection("Farming System")

    -- Gunakan pcall agar jika satu toggle error, yang lain tetap muncul
    pcall(function()
        Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = true })
        
        task.spawn(function()
            while true do
                task.wait(10)
                if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                    pcall(function() KnitServices.PlaytimeRewardService.RF.ClaimReward:InvokeServer(1) end)
                end
            end
        end)
    end)

    pcall(function()
        Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
        
        task.spawn(function()
            while true do
                task.wait(1)
                if Options.AutoCollectMoney and Options.AutoCollectMoney.Value then
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
                end
            end
        end)
    end)

    Tab:AddSection("Brainrot System")

    pcall(function()
        Tab:AddToggle("AutoPickup", { Title = "Auto Pickup All (1-30)", Default = false })
        
        task.spawn(function()
            while true do
                task.wait(1)
                if Options.AutoPickup and Options.AutoPickup.Value then
                    for i = 1, 30 do
                        pcall(function() KnitServices.ContainerService.RF.PickupBrainrot:InvokeServer(tostring(i)) end)
                    end
                end
            end
        end)
    end)
end
