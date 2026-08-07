local Players = Require('Players',false)
local Player = Require('Player',false)
local Mouse = Require('Mouse',false)
local Camera = Require('Camera',false)

local Drag = Instance.new('TextButton')
Drag.Size = UDim2.new(0,435,0,17)
Strip(Drag)
Drag.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
Drag.Text = '...'

Drag.Parent = Screen
MakeDraggable(Drag)


--[[
local T = Toggle('Aimbot')
T.Parent = Drag]]