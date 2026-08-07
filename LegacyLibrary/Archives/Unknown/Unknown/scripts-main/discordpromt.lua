local Join = loadstring(game:HttpGet"https://raw.githubusercontent.com/Voxel0/scripts/main/discord.lua")() 
local Code = game:HttpGet("https://raw.githubusercontent.com/Voxel0/scripts/main/discordcode")
local GUI = game:GetService("StarterGui")
local cb = Instance.new("BindableFunction")
cb.OnInvoke = function(res)
    if res == "Yes" then
        coroutine.wrap(function() Join(Code) end)()
        pcall(function() setclipboard("https://discord.gg/" .. Code) end)
    	GUI:SetCore("SendNotification", {
            Title = "Discord",
            Text = "Attempted to join you into the server, we also set the invite to your clipboard!",
            Duration = 5
        })
    end
end

GUI:SetCore("SendNotification", {
	Title = "Discord",
	Text = "Would you like to join our discord?",
	Duration = 9e9,
	Callback = cb,
	Button1 = "Yes",
	Button2 = "No"
})
