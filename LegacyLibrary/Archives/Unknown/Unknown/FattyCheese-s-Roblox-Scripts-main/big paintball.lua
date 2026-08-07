--Setting it to OFF will kill you. This is because dying resets the invisibility
--Scripted by FattyCheese & WetCheezit

local player = game.Players.LocalPlayer
local character = player.Character
local camera = workspace.CurrentCamera

local ON = true
local OFF = false

local AutoKill = ON --change ON to OFF to turn off the cheat (and vice versa)(must be all caps)

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


getgenv().Enabled = AutoKill

loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Releases/main/Big-Paintball/KillAll.lua"))()