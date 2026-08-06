local StarterGui = game:GetService("StarterGui")

local Notification = {}

function Notification.Send(title, message, duration)
    return pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Vanguard",
            Text = message or "",
            Duration = duration or 4
        })
    end)
end

return Notification
