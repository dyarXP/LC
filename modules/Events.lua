return function(Tab, Fluent, Window)
    local Options = Fluent.Options -- Pastikan ini ada agar tidak error 'Expected identifier'
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    
    local isEgg = false
    Tab:AddSection("Event Easter")

    Tab:AddSlider("EggDelay", {
        Title = "Collect Delay (Seconds)",
        Default = 0.1,
        Min = 0.05,
        Max = 5,
        Rounding = 2
    })

    local function startFullCycle()
        -- Mengambil path Knit secara dinamis di dalam fungsi agar aman
        local knitPath = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")
        local knitServices = knitPath:WaitForChild("Services")
        
        local runningRF = knitServices:WaitForChild("RunningService"):WaitForChild("RF")
        local eventRF = knitServices:WaitForChild("EventService"):WaitForChild("RF")
        local playerRF = knitServices:WaitForChild("PlayerService"):WaitForChild("RF")

        while isEgg do
            pcall(function()
                runningRF.StartRun:InvokeServer()
                runningRF.StartMove:InvokeServer()

                for i = 1, 5 do
                    if not isEgg then break end
                    eventRF.CollectEgg:InvokeServer()
                end

                local collectArgs = {"10063799192"}
                runningRF.Collected:InvokeServer(unpack(collectArgs))
                playerRF.ReloadCharacter:InvokeServer()
            end)
            
            -- Menunggu character baru muncul sebelum lanjut loop
            LocalPlayer.CharacterAdded:Wait()
            
            -- Menggunakan task.wait yang aman dari slider
            task.wait(Options.EggDelay.Value)
        end
    end

    Tab:AddToggle("AutoEggToggle", { 
        Title = "Auto Collect Egg", 
        Default = false 
    }):OnChanged(function(state)
        isEgg = state
        if state then 
            task.spawn(startFullCycle) 
        end
    end)
end
