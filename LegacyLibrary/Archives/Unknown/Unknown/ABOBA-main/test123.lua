MainSection:NewButton("GET VIDEO LINK", "PASTE LINK TO GOOGLE", function()
local CoreGui = game:GetService("StarterGui") -- Variable of StarterGui
	CoreGui:SetCore("SendNotification", {
		-- Customizable
		Title = "Paste To Google",
		Text = "Copied To Clipboard",
		Duration = 7, -- Set the duration to how much you want this to stay
		-- More code in part 2
	})
    setclipboard("https://www.youtube.com/watch?v=VAd-fOAWdvI")
	toclipboard("https://www.youtube.com/watch?v=VAd-fOAWdvI")
            end)
            
