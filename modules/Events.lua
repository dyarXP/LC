return function(Tab, Fluent, Window)
    local Options = Fluent.Options
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- [[ UI SECTION ]]
    local EventSec = Tab:AddSection("Event Manager")

    Tab:AddParagraph({
        Title = "Event Status",
        Content = "Mencari event aktif di server..."
    })

    Tab:AddToggle("AutoClaimEv", {
        Title = "Auto Claim Event Rewards",
        Default = false
    })

    Tab:AddToggle("AutoCollectEv", {
        Title = "Auto Collect Drops",
        Default = false
    })

    -- [[ LOGIC SECTION ]]
    local function GetRemote(name)
        local success, res = pcall(function()
            local index = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
            for _, v in ipairs(index:GetChildren()) do
                if v.Name:find("knit") then
                    local services = v.knit.Services
                    local s = services:FindFirstChild("EventService") or services:FindFirstChild("SeasonService")
                    return s and s.RF:FindFirstChild(name)
                end
            end
        end)
        return success and res or nil
    end

    task.spawn(function()
        while true do
            task.wait(5)
            if not Options.AutoClaimEv then break end

            if Options.AutoClaimEv.Value then
                local remote = GetRemote("ClaimReward") or GetRemote("Claim")
                if remote then pcall(function() remote:InvokeServer() end) end
            end
        end
    end)
end
