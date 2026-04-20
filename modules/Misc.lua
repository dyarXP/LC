return function(Tab, Fluent, Window)
    local Options = Fluent.Options

    Tab:AddSection("Performance & Comfort")

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

    Tab:AddToggle("DisableSound", { Title = "Disable Game Sounds", Default = false }):OnChanged(function()
        task.spawn(function()
            while Options.DisableSound.Value do
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Sound") then v:Stop() end
                end
                task.wait(2)
            end
        end)
    end)

    Tab:AddButton({
        Title = "Destroy UI",
        Callback = function() Window:Destroy() end
    })
end
