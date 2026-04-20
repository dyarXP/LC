return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    
    Tab:AddSection("Performance")
    Tab:AddToggle("DisableVFX", { Title = "Disable VFX (Boost FPS)", Default = false })

    Tab:AddButton({
        Title = "Destroy GUI",
        Callback = function() Window:Destroy() end
    })
    
    -- Anti-Idle Background
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
