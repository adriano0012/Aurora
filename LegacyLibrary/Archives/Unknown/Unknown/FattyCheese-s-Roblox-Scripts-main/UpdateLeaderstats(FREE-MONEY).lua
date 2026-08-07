--ONLY WORKS ON MOST GAMES WHILE YOU ARE IN THE GAME (MAY NOT WORK AT ALL IN SOME GAMES)

local Username = windows_user3 --change "windows_user3" to your username
local Leaderstat = Money --change "Money" to the currency or any other number related value on the leaderboard
local Amount = 12345 --change "12345" to the ammount of the currency you want

game.Players.Username.leaderstats.Leaderstat.Value = Amount

--IGNORE ANYTHING BELOW THIS (ITS JUST THE "MADE BY FATTYCHEESE")

-- Create a new ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestMessageGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a new TextLabel for the message
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 300, 0, 50)  -- Set the size of the label (width: 300px, height: 50px)
textLabel.Position = UDim2.new(0.5, -150, 0, 30)  -- Align at the top center (0.5 is center for X, 0 for Y)
textLabel.Text = "Made By FattyCheese"  --Adds text
textLabel.TextColor3 = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255))  -- White text color
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black background
textLabel.TextScaled = true  -- Scales the text to fit the label
textLabel.Parent = screenGui