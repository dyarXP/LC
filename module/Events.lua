return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    Tab:AddSection("Event Easter")
    Tab:AddSlider("EggDelay", { Title = "Collect Delay (s)", Default = 0.1, Min = 0.05, Max = 5, Rounding = 2 })

    local function startFullCycle()
        local knitServices = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services
        while Options.AutoEggToggle.Value do
            pcall(function()
                knitServices.RunningService.RF.StartRun:InvokeServer()
                knitServices.RunningService.RF.StartMove:InvokeServer()
                for i = 1, 5 do knitServices.EventService.RF.CollectEgg:InvokeServer() end
                knitServices.RunningService.Collected:InvokeServer("10063799192")
                knitServices.PlayerService.RF.ReloadCharacter:InvokeServer()
            end)
            LocalPlayer.CharacterAdded:Wait()
            task.wait(Options.EggDelay.Value)
        end
    end

    Tab:AddToggle("AutoEggToggle", { Title = "Auto Collect Egg", Default = false }):OnChanged(function(state)
        if state then task.spawn(startFullCycle) end
    end)
end
