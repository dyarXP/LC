return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local VirtualUser = game:GetService("VirtualUser")

    Tab:AddSection("Performance & Anti-AFK")

    Tab:AddToggle("DisableVFX", { Title = "Disable VFX (Boost FPS)", Default = false }):OnChanged(function()
        task.spawn(function()
            while Options.DisableVFX.Value do
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false end
                end
                task.wait(5)
            end
        end)
    end)

    -- Anti-Idle Logic
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
    
    Fluent:Notify({Title = "Anti-AFK", Content = "Anti-AFK is always active in background", Duration = 3})
end
