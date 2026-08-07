-- Credits MG Plays#4084
local LT2Gui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Open = Instance.new("TextButton")
local Main = Instance.new("Frame")
local Credits = Instance.new("TextLabel")
local JamesGui = Instance.new("TextButton")
local EEVNXXGUI = Instance.new("TextButton")
local LT2Ferry = Instance.new("TextButton")
local Close = Instance.new("TextButton")
 
LT2Gui.Name = "LT2 Gui"
LT2Gui.Parent = game.CoreGui
LT2Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 
Frame.Parent = LT2Gui
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.Position = UDim2.new(0, 0, 0.484227121, 0)
Frame.Size = UDim2.new(0, 88, 0, 37)
 
Open.Name = "Open"
Open.Parent = Frame
Open.BackgroundColor3 = Color3.new(1, 1, 1)
Open.Position = UDim2.new(0, 0, 0.108108111, 0)
Open.Size = UDim2.new(0, 83, 0, 28)
Open.Font = Enum.Font.SourceSans
Open.Text = "Open"
Open.TextColor3 = Color3.new(0, 0, 0)
Open.TextSize = 14
Open.MouseButton1Down:connect(function()
	Frame.Visible = false
	Main.Visible = true
end)
 
Main.Name = "Main"
Main.Parent = LT2Gui
Main.Active = true
Main.Visible = false
Main.BackgroundColor3 = Color3.new(1, 1, 1)
Main.Position = UDim2.new(0.0984962508, 0, 0.38643533, 0)
Main.Size = UDim2.new(0, 277, 0, 367)
Main.Active = true
Main.Draggable = true
 
Credits.Name = "Credits"
Credits.Parent = Main
Credits.BackgroundColor3 = Color3.new(1, 1, 1)
Credits.BorderColor3 = Color3.new(1, 1, 1)
Credits.Position = UDim2.new(0.0252707582, 0, 0.923705697, 0)
Credits.Size = UDim2.new(0, 262, 0, 20)
Credits.Font = Enum.Font.SourceSans
Credits.Text = "By: MG Plays#4084"
Credits.TextColor3 = Color3.new(0, 0, 0)
Credits.TextSize = 14
 
JamesGui.Name = "JamesGui"
JamesGui.Parent = Main
JamesGui.BackgroundColor3 = Color3.new(1, 1, 1)
JamesGui.Position = UDim2.new(0.137184113, 0, 0.141689375, 0)
JamesGui.Size = UDim2.new(0, 200, 0, 50)
JamesGui.Font = Enum.Font.SourceSans
JamesGui.Text = "JamesGui"
JamesGui.TextColor3 = Color3.new(0, 0, 0)
JamesGui.TextSize = 14
JamesGui.MouseButton1Down:connect(function()
	loadstring(game:HttpGet('https://pastebin.com/raw/eYSYPjvp',true))()
end)
 
EEVNXXGUI.Name = "EEVNXX GUI"
EEVNXXGUI.Parent = Main
EEVNXXGUI.BackgroundColor3 = Color3.new(1, 1, 1)
EEVNXXGUI.Position = UDim2.new(0.137184113, 0, 0.373297006, 0)
EEVNXXGUI.Size = UDim2.new(0, 200, 0, 50)
EEVNXXGUI.Font = Enum.Font.SourceSans
EEVNXXGUI.Text = "EEVNXX GUI"
EEVNXXGUI.TextColor3 = Color3.new(0, 0, 0)
EEVNXXGUI.TextSize = 14
EEVNXXGUI.MouseButton1Down:connect(function()
	loadstring(game:HttpGet('https://nto.darkdevs.pro/uploads/EevnxxLT2.lua',true))()
end)
 
LT2Ferry.Name = "LT2 Ferry"
LT2Ferry.Parent = Main
LT2Ferry.BackgroundColor3 = Color3.new(1, 1, 1)
LT2Ferry.Position = UDim2.new(0.137184113, 0, 0.613079011, 0)
LT2Ferry.Size = UDim2.new(0, 200, 0, 50)
LT2Ferry.Font = Enum.Font.SourceSans
LT2Ferry.Text = "LT2 Ferry"
LT2Ferry.TextColor3 = Color3.new(0, 0, 0)
LT2Ferry.TextSize = 14
LT2Ferry.MouseButton1Down:connect(function()
	loadstring(game:HttpGet('https://ferrysyloit2.glitch.me/lt-2-ferry.txt',true))()
end)
 
Close.Name = "Close"
Close.Parent = Main
Close.BackgroundColor3 = Color3.new(1, 1, 1)
Close.Position = UDim2.new(0.884476542, 0, 0, 0)
Close.Size = UDim2.new(0, 32, 0, 27)
Close.Font = Enum.Font.SourceSans
Close.Text = "X"
Close.TextColor3 = Color3.new(0, 0, 0)
Close.TextSize = 14
Close.MouseButton1Down:connect(function()
	Frame.Visible = true
	Main.Visible = false
end)