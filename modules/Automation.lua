return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))

    local Section = Tab:AddSection("Farming System")

    Tab:AddToggle("AutoClaimPlaytime", { Title = "Auto Claim Playtime Rewards", Default = true })
    
    task.spawn(function()
        local PlaytimeRF = Knit.Services.PlaytimeRewardService.RF.ClaimGift
        while true do
            task.wait(10)
            if Options.AutoClaimPlaytime and Options.AutoClaimPlaytime.Value then
                for i = 1, 12 do pcall(function() PlaytimeRF:InvokeServer(i) end) end
            end
        end
    end)

    Tab:AddToggle("AutoCollectMoney", { Title = "Auto Collect Money (Plot 1-30)", Default = false })
    -- Logika firetouchinterest kamu di sini...
end
