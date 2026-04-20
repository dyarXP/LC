return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Ambil Knit Services secara aman
    local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"))
    local KnitServices = Knit.Services

    -- [[ AUTO REBIRTH & UPGRADES SECTION ]]
    local RebSec = Tab:AddSection("Auto Rebirth & Upgrades")

    -- Input & Slider didefinisikan di atas agar nilainya bisa dibaca oleh Toggle
    Tab:AddInput("IMS", {
        Title = "Amount to Buy", 
        Default = "1", 
        Numeric = true,
        Finished = false,
        Callback = function(Value) end
    })

    Tab:AddSlider("SMS", {
        Title = "Upgrade Delay (s)", 
        Default = 1, 
        Min = 0.1, 
        Max = 5, 
        Rounding = 1,
        Callback = function(Value) end
    })

    -- 1. Auto Rebirth
    Tab:AddToggle("AR", {Title = "Auto Rebirth", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AR.Value do 
                pcall(function() 
                    KnitServices.RebirthService.RF.Rebirth:InvokeServer() 
                end) 
                task.wait(1) 
            end 
        end)
    end)

    -- 2. Auto Buy Speed Upgrade
    Tab:AddToggle("AMS", {Title = "Auto Buy Speed Upgrade", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AMS.Value do 
                pcall(function() 
                    local amount = tonumber(Options.IMS.Value) or 1
                    KnitServices.UpgradesService.RF.Upgrade:InvokeServer("MovementSpeed", amount) 
                end) 
                task.wait(Options.SMS.Value) 
            end 
        end)
    end)

    -- 3. Auto Upgrade Base (Container)
    Tab:AddToggle("AUB", {Title = "Auto Upgrade Base (Container)", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AUB.Value do 
                pcall(function() 
                    KnitServices.ContainerService.RF.BuyContainer:InvokeServer() 
                end) 
                task.wait(Options.SMS.Value) 
            end 
        end)
    end)
end
