return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local isEgg = false

    -- [[ 1. UI SECTION ]]
    local EventSec = Tab:AddSection("Event Easter")

    Tab:AddSlider("EggDelay", {
        Title = "Collect Delay (Seconds)",
        Default = 0.1,
        Min = 0.05,
        Max = 5,
        Rounding = 2
    })

    -- [[ 2. LOGIC SECTION ]]
    local function startFullCycle()
        -- Mencari Knit Services secara dinamis (Anti-Update)
        local knitServices
        pcall(function()
            local packages = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
            for _, v in ipairs(packages:GetChildren()) do
                if v.Name:find("knit") then
                    knitServices = v.knit.Services
                    break
                end
            end
        end)

        if not knitServices then
            return Fluent:Notify({Title = "Error", Content = "Knit Services tidak ditemukan!", Duration = 5})
        end

        local runningRF = knitServices:WaitForChild("RunningService"):WaitForChild("RF")
        local eventRF = knitServices:WaitForChild("EventService"):WaitForChild("RF")
        local playerRF = knitServices:WaitForChild("PlayerService"):WaitForChild("RF")

        while isEgg do
            pcall(function()
                -- Memulai Run
                runningRF.StartRun:InvokeServer()
                runningRF.StartMove:InvokeServer()

                -- Collect Egg Loop
                for i = 1, 5 do
                    if not isEgg then break end
                    eventRF.CollectEgg:InvokeServer()
                end

                -- Selesaikan Run & Reset
                local collectArgs = {"10063799192"}
                runningRF.Collected:InvokeServer(unpack(collectArgs))
                playerRF.ReloadCharacter:InvokeServer()
            end)

            -- Menunggu karakter spawn kembali sebelum lanjut loop
            LocalPlayer.CharacterAdded:Wait()
            
            -- Delay agar tidak terkena ban/kick
            local delayTime = (Options.EggDelay and Options.EggDelay.Value) or 0.1
            task.wait(delayTime)
        end
    end

    -- [[ 3. TOGGLE UI ]]
    Tab:AddToggle("AutoEggToggle", { 
        Title = "Auto Collect Egg", 
        Default = false 
    }):OnChanged(function(state)
        isEgg = state
        if state then 
            task.spawn(startFullCycle) 
            Fluent:Notify({Title = "RHDXP Hub", Content = "Auto Egg Started!", Duration = 2})
        end
    end)
end
