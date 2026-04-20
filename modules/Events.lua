return function(Tab, Fluent, Window)
local isEgg = false
Tabs.Events:AddSection("Event Easter")

Tabs.Events:AddSlider("EggDelay", {
    Title = "Collect Delay (Seconds)",
    Default = 0.1,
    Min = 0.05,
    Max = 5,
    Rounding = 2
})

local function startFullCycle()
    local knitServices = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services")
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
        LocalPlayer.CharacterAdded:Wait()
        task.wait(Options.EggDelay.Value)
    end
end

Tabs.Events:AddToggle("AutoEggToggle", { Title = "Auto Collect Egg", Default = false }):OnChanged(function(state)
    isEgg = state
    if state then task.spawn(startFullCycle) end
end)
