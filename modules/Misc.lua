return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local VirtualUser = game:GetService("VirtualUser")

    -- [[ PERFORMANCE & COMFORT SECTION ]]
    local MiscSection = Tab:AddSection("Performance & Comfort")

    -- Toggle Disable VFX
    Tab:AddToggle("DisableVFX", { Title = "Disable VFX (Boost FPS)", Default = false }):OnChanged(function(state)
        task.spawn(function()
            while Options.DisableVFX.Value do
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        v.Enabled = false
                    end
                end
                task.wait(5)
            end
        end)
    end)

    -- Toggle Disable Sound
    Tab:AddToggle("DisableSound", { Title = "Disable Game Sounds", Default = false }):OnChanged(function(state)
        task.spawn(function()
            while Options.DisableSound.Value do
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Sound") then
                        v:Stop()
                    end
                end
                task.wait(2)
            end
        end)
    end)

    -- [[ ANTI-AFK SYSTEM ]]
    -- Berjalan otomatis di background tanpa toggle agar akun tetap aman
    local function AntiIdle()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end

    LocalPlayer.Idled:Connect(AntiIdle)

    -- [[ UI BUTTONS ]]
    Tab:AddSection("Menu Settings")

    Tab:AddButton({
        Title = "Destroy GUI",
        Description = "Menghapus menu RHDXP dari layar",
        Callback = function()
            Window:Destroy()
        end
    })

    Tab:AddButton({
        Title = "Copy Discord Link",
        Description = "Salin link komunitas RHDXP",
        Callback = function()
            setclipboard("https://discord.gg/rhdxp") -- Ganti dengan linkmu
            Fluent:Notify({
                Title = "RHDXP HUB",
                Content = "Link Discord berhasil disalin!",
                Duration = 3
            })
        end
    })

end
