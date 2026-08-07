
local a = Instance.new('ScreenGui',game.CoreGui)
-- Farewell Infortality.
-- Version: 2.82
-- Instances:
local GunMods = Instance.new("Frame")
GunMods.Parent = a
local Recoil = Instance.new("TextLabel")
local Frame = Instance.new("Frame")
local TextButton = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local Spread = Instance.new("TextLabel")
local Frame_2 = Instance.new("Frame")
local TextButton_2 = Instance.new("TextButton")
local TextLabel_2 = Instance.new("TextLabel")
local Firerate = Instance.new("TextLabel")
local Frame_3 = Instance.new("Frame")
local TextButton_3 = Instance.new("TextButton")
local TextLabel_3 = Instance.new("TextLabel")
local FULLAUTO = Instance.new("TextButton")
local GunName = Instance.new("TextBox")
local Desc = Instance.new("TextBox")
--Properties:
GunMods.Name = "GunMods"
GunMods.BackgroundColor3 = Color3.new(1, 1, 1)
GunMods.BackgroundTransparency = 1
GunMods.Position = UDim2.new(0.361331224, 0, 0.260080636, 0)
GunMods.Size = UDim2.new(0, 171, 0, 132)

Recoil.Name = "Recoil"
Recoil.Parent = GunMods
Recoil.BackgroundColor3 = Color3.new(1, 1, 1)
Recoil.BackgroundTransparency = 1
Recoil.Position = UDim2.new(-0.00584795326, 0, 0.037878789, 0)
Recoil.Size = UDim2.new(0, 86, 0, 18)
Recoil.Font = Enum.Font.SourceSans
Recoil.Text = "RECOIL: "
Recoil.TextColor3 = Color3.new(1, 1, 1)
Recoil.TextScaled = true
Recoil.TextSize = 14
Recoil.TextWrapped = true
Recoil.TextXAlignment = Enum.TextXAlignment.Right

Frame.Parent = Recoil
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(1.16279066, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 56, 0, 1)

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.new(0.0509804, 0.321569, 0.490196)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0, 0, 0, -3)
TextButton.Size = UDim2.new(0, 6, 0, 6)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = ""
TextButton.TextColor3 = Color3.new(0, 0, 0)
TextButton.TextSize = 14

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(1, 3, 0, -3)
TextLabel.Size = UDim2.new(0, 10, 0, 5)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "0"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14

Spread.Name = "Spread"
Spread.Parent = GunMods
Spread.BackgroundColor3 = Color3.new(1, 1, 1)
Spread.BackgroundTransparency = 1
Spread.Position = UDim2.new(-0.00584795326, 0, 0.174242437, 0)
Spread.Size = UDim2.new(0, 86, 0, 18)
Spread.Font = Enum.Font.SourceSans
Spread.Text = "SPREAD: "
Spread.TextColor3 = Color3.new(1, 1, 1)
Spread.TextScaled = true
Spread.TextSize = 14
Spread.TextWrapped = true
Spread.TextXAlignment = Enum.TextXAlignment.Right

Frame_2.Parent = Spread
Frame_2.BackgroundColor3 = Color3.new(1, 1, 1)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(1.16279066, 0, 0.5, 0)
Frame_2.Size = UDim2.new(0, 56, 0, 1)

TextButton_2.Parent = Frame_2
TextButton_2.BackgroundColor3 = Color3.new(0.0509804, 0.321569, 0.490196)
TextButton_2.BorderSizePixel = 0
TextButton_2.Position = UDim2.new(0, 0, 0, -3)
TextButton_2.Size = UDim2.new(0, 6, 0, 6)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = ""
TextButton_2.TextColor3 = Color3.new(0, 0, 0)
TextButton_2.TextSize = 14

TextLabel_2.Parent = Frame_2
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(1, 3, 0, -3)
TextLabel_2.Size = UDim2.new(0, 10, 0, 5)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "0"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextSize = 14

Firerate.Name = "Firerate"
Firerate.Parent = GunMods
Firerate.BackgroundColor3 = Color3.new(1, 1, 1)
Firerate.BackgroundTransparency = 1
Firerate.Position = UDim2.new(-0.00584795326, 0, 0.310606062, 0)
Firerate.Size = UDim2.new(0, 86, 0, 18)
Firerate.Font = Enum.Font.SourceSans
Firerate.Text = "FIRE RATE: "
Firerate.TextColor3 = Color3.new(1, 1, 1)
Firerate.TextScaled = true
Firerate.TextSize = 14
Firerate.TextWrapped = true
Firerate.TextXAlignment = Enum.TextXAlignment.Right

Frame_3.Parent = Firerate
Frame_3.BackgroundColor3 = Color3.new(1, 1, 1)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(1.16279066, 0, 0.5, 0)
Frame_3.Size = UDim2.new(0, 56, 0, 1)

TextButton_3.Parent = Frame_3
TextButton_3.BackgroundColor3 = Color3.new(0.0509804, 0.321569, 0.490196)
TextButton_3.BorderSizePixel = 0
TextButton_3.Position = UDim2.new(0, 0, 0, -3)
TextButton_3.Size = UDim2.new(0, 6, 0, 6)
TextButton_3.Font = Enum.Font.SourceSans
TextButton_3.Text = ""
TextButton_3.TextColor3 = Color3.new(0, 0, 0)
TextButton_3.TextSize = 14

TextLabel_3.Parent = Frame_3
TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Position = UDim2.new(1, 3, 0, -3)
TextLabel_3.Size = UDim2.new(0, 10, 0, 5)
TextLabel_3.Font = Enum.Font.SourceSans
TextLabel_3.Text = "0"
TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
TextLabel_3.TextSize = 14

FULLAUTO.Name = "FULL AUTO"
FULLAUTO.Parent = GunMods
FULLAUTO.BackgroundColor3 = Color3.new(1, 1, 1)
FULLAUTO.BackgroundTransparency = 1
FULLAUTO.Position = UDim2.new(-0.00584795326, 0, 0.446969688, 0)
FULLAUTO.Size = UDim2.new(0, 170, 0, 19)
FULLAUTO.Font = Enum.Font.SourceSans
FULLAUTO.Text = "FULL AUTO"
FULLAUTO.TextColor3 = Color3.new(1, 1, 1)
FULLAUTO.TextScaled = true
FULLAUTO.TextSize = 14
FULLAUTO.TextWrapped = true

GunName.Name = "Gun Name"
GunName.Parent = GunMods
GunName.BackgroundColor3 = Color3.new(1, 1, 1)
GunName.BackgroundTransparency = 1
GunName.Position = UDim2.new(-0.00584795326, 0, 0.636363626, 0)
GunName.Size = UDim2.new(0, 170, 0, 17)
GunName.Font = Enum.Font.SourceSans
GunName.PlaceholderText = "Weapon Name"
GunName.Text = ""
GunName.TextColor3 = Color3.new(1, 1, 1)
GunName.TextScaled = true
GunName.TextSize = 14
GunName.TextWrapped = true

Desc.Name = "Desc"
Desc.Parent = GunMods
Desc.BackgroundColor3 = Color3.new(1, 1, 1)
Desc.BackgroundTransparency = 1
Desc.Position = UDim2.new(-0.00584795326, 0, 0.787878811, 0)
Desc.Size = UDim2.new(0, 170, 0, 17)
Desc.Font = Enum.Font.SourceSans
Desc.PlaceholderText = "Weapon Descrition"
Desc.Text = ""
Desc.TextColor3 = Color3.new(1, 1, 1)
Desc.TextScaled = true
Desc.TextSize = 14
Desc.TextWrapped = true
-- Scripts:
function SCRIPT_CUTM76_FAKESCRIPT() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
	    local delta = input.Position - dragStart
	    gui.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X,0,52), 0, -3)
		script.Parent.Parent.TextLabel.Text = math.floor((script.Parent.Position.X.Offset/52)*10)/10
	end
	
	gui.InputBegan:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	        dragging = true
	        dragStart = input.Position
	        startPos = gui.Position
	        
	        input.Changed:Connect(function()
	            if input.UserInputState == Enum.UserInputState.End then
	                dragging = false
	            end
	        end)
	    end
	end)
	
	gui.InputChanged:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
	        dragInput = input
	    end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
	    if input == dragInput and dragging then
	        update(input)
	    end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_CUTM76_FAKESCRIPT))
function SCRIPT_XXXQ82_FAKESCRIPT() -- TextLabel.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextLabel
	local old = {}
	for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
		old[v.Name]= require(v['Recoil Data'])
	end
	script.Parent:GetPropertyChangedSignal('Text'):connect(function()
		for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
			local mod = require(v['Recoil Data'])
			mod.SpreadAddFPSZoom = old[v.Name].SpreadAddFPSZoom - old[v.Name].SpreadAddFPSZoom * script.Parent.Text
			mod.SpreadAddFPSHip = old[v.Name].SpreadAddFPSHip - old[v.Name].SpreadAddFPSHip * script.Parent.Text
			mod.SpreadAddTPSZoom = old[v.Name].SpreadAddTPSZoom - old[v.Name].SpreadAddTPSZoom * script.Parent.Text
			mod.SpreadAddTPSHip = old[v.Name].SpreadAddTPSHip - old[v.Name].SpreadAddTPSHip * script.Parent.Text
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_XXXQ82_FAKESCRIPT))
function SCRIPT_BRPS84_FAKESCRIPT() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_2
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
	    local delta = input.Position - dragStart
	    gui.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X,0,52), 0, -3)
		script.Parent.Parent.TextLabel.Text = math.floor((script.Parent.Position.X.Offset/52)*10)/10
	end
	
	gui.InputBegan:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	        dragging = true
	        dragStart = input.Position
	        startPos = gui.Position
	        
	        input.Changed:Connect(function()
	            if input.UserInputState == Enum.UserInputState.End then
	                dragging = false
	            end
	        end)
	    end
	end)
	
	gui.InputChanged:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
	        dragInput = input
	    end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
	    if input == dragInput and dragging then
	        update(input)
	    end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_BRPS84_FAKESCRIPT))
function SCRIPT_WHEM69_FAKESCRIPT() -- TextLabel_2.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextLabel_2
	local old = {}
	for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
		old[v.Name]= require(v['Recoil Data'])
	end
	script.Parent:GetPropertyChangedSignal('Text'):connect(function()
		for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
			local mod = require(v['Recoil Data'])
			mod.KickUpForce = old[v.Name].KickUpForce - old[v.Name].KickUpForce * script.Parent.Text
			mod.ShiftCameraInfluence = old[v.Name].ShiftCameraInfluence - old[v.Name].ShiftCameraInfluence * script.Parent.Text
			mod.ShiftGunInfluence = old[v.Name].ShiftGunInfluence - old[v.Name].ShiftGunInfluence * script.Parent.Text
			mod.RaiseForce = old[v.Name].RaiseForce - old[v.Name].RaiseForce * script.Parent.Text
			mod.RaiseSpeed = old[v.Name].RaiseSpeed - old[v.Name].RaiseSpeed * script.Parent.Text
			mod.RaiseBounce = old[v.Name].RaiseBounce - old[v.Name].RaiseBounce * script.Parent.Text
			mod.RaiseInfluence = old[v.Name].RaiseInfluence - old[v.Name].RaiseInfluence * script.Parent.Text
			
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_WHEM69_FAKESCRIPT))
function SCRIPT_VQLM88_FAKESCRIPT() -- TextButton_3.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_3
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
	    local delta = input.Position - dragStart
	    gui.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X,0,52), 0, -3)
		script.Parent.Parent.TextLabel.Text = math.floor((script.Parent.Position.X.Offset/52)*10)/10
	end
	
	gui.InputBegan:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	        dragging = true
	        dragStart = input.Position
	        startPos = gui.Position
	        
	        input.Changed:Connect(function()
	            if input.UserInputState == Enum.UserInputState.End then
	                dragging = false
	            end
	        end)
	    end
	end)
	
	gui.InputChanged:Connect(function(input)
	    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
	        dragInput = input
	    end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
	    if input == dragInput and dragging then
	        update(input)
	    end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_VQLM88_FAKESCRIPT))
function SCRIPT_HJYF90_FAKESCRIPT() -- TextLabel_3.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextLabel_3
	local old = {}
	for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
		old[v.Name]= require(v['Recoil Data'])
	end
	script.Parent:GetPropertyChangedSignal('Text'):connect(function()
		for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
			local mod = require(v['Recoil Data'])
			mod.FireRate = 9000
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_HJYF90_FAKESCRIPT))
function SCRIPT_KKFJ89_FAKESCRIPT() -- FULLAUTO.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = FULLAUTO
	script.Parent.MouseButton1Down:connect(function()
	for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
		local mod = require(v)
		mod.FireModes = {'Automatic'}
	end
end)

	

end
coroutine.resume(coroutine.create(SCRIPT_KKFJ89_FAKESCRIPT))
function SCRIPT_CKLC66_FAKESCRIPT() -- GunName.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = GunName
	script.Parent.FocusLost:connect(function(a)
		if a then
			for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
				local c = require(v)
				c.DisplayName = script.Parent.Text
			end
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_CKLC66_FAKESCRIPT))
function SCRIPT_ARQM74_FAKESCRIPT() -- Desc.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = Desc
	script.Parent.FocusLost:connect(function(a)
		if a then
			for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
				local c = require(v)
				c.Description = script.Parent.Text
			end
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_ARQM74_FAKESCRIPT))

