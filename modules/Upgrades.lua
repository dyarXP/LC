return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Fungsi pencari Remote otomatis
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

    local RebSec = Tab:AddSection("Auto Rebirth & Upgrades")

    Tab:AddInput("IMS", {Title = "Amount to Buy", Default = "1", Numeric = true})
    Tab:AddSlider("SMS", {Title = "Upgrade Delay (s)", Default = 1, Min = 0.1, Max = 5, Rounding = 1})

    -- Auto Rebirth
    Tab:AddToggle("AR", {Title = "Auto Rebirth", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AR.Value do 
                local remote = GetRemote("RebirthService", "Rebirth")
                if remote then pcall(function() remote:InvokeServer() end) end
                task.wait(1) 
            end 
        end)
    end)

    -- Auto Speed Upgrade
    Tab:AddToggle("AMS", {Title = "Auto Buy Speed Upgrade", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AMS.Value do 
                local remote = GetRemote("UpgradesService", "Upgrade")
                if remote then 
                    pcall(function() 
                        remote:InvokeServer("MovementSpeed", tonumber(Options.IMS.Value) or 1) 
                    end) 
                end
                task.wait(Options.SMS.Value) 
            end 
        end)
    end)

    -- Auto Container Upgrade
    Tab:AddToggle("AUB", {Title = "Auto Upgrade Base (Container)", Default = false}):OnChanged(function()
        task.spawn(function() 
            while Options.AUB.Value do 
                local remote = GetRemote("ContainerService", "BuyContainer")
                if remote then pcall(function() remote:InvokeServer() end) end
                task.wait(Options.SMS.Value) 
            end 
        end)
    end)
end
