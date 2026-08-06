Settings = {Esp = true}
local func = 'function() Settings.Esp = not Settings.Esp print(Settings.Esp) end'
local Players = game.Players
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
if not _G.Theme then
	_G.Theme = {
		TextColor = Color3.new(1,1,1),
		TextSize = 12,
		TextFont = 'GothamBold',
		HoverColor = Color3.fromRGB(50,50,50),
		ClickColor = Color3.fromRGB(0,100,100),
		BackgroundColor = Color3.fromRGB(33,33,33),
		SliderColor = Color3.new(1,0,0),--Color3.new(0,.5,.5),
		InfoColor = Color3.fromRGB(33,33,33),
		InfoTextSize = 12,
		InfoTextColor = Color3.new(1,1,1),
		InfoTextFont = 'GothamBold',
		ToggledColor = Color3.new(1,0,0),
		CheckBoxColor = Color3.fromRGB(44,44,44),
		CheckBoxTextSize = 12,
		SliderButtonColor = Color3.new(1,1,1),
		FovColor = Color3.new(1,0,0),
		FovTransparency = .4
	}
end
local function ColorAdd(a,b)
	r,g,b = a.R+b.R,a.G+b.G,a.B+b.B
	return Color3.fromRGB(r,g,b)
end
local g = setmetatable({},{__metatable = 'This metatable is locked.'})
g.Guis = {}
g.Parent = Instance.new('ScreenGui',game.CoreGui)

g.new = function(self,text,Comment,TitleText)
	text = ' '..text
	local new = {}
	new.Children = {}
	new.FadeOut = function()
		for i,v in pairs(new.Children) do
			spawn(function()
				for i=1,10 do
					v.BackgroundTransparency = i/10
					wait()
				end
				v.Visible = false
			end)
		end
	end
	new.FadeIn = function()
		for i,v in pairs(new.Children) do
			spawn(function()
				v.Visible = true
				for i=1,10 do
					v.BackgroundTransparency = 1-(i/10)
					wait()
				end
			end)
		end
	end
	
	local toggled = false
	self.Guis[text] = new
	local Gui = Instance.new('TextButton',self.Parent)
	new.Gui = Gui
	Gui.Text = text
	Gui.Size = UDim2.new(0,200,0,30)
	Gui.TextColor3 = _G.Theme.TextColor
	Gui.BackgroundColor3 = _G.Theme.BackgroundColor
	Gui.TextSize = _G.Theme.TextSize
	Gui.Font = _G.Theme.TextFont
	Gui.BorderSizePixel = 0
	Gui.Draggable = true
	Gui.AutoButtonColor = false
	Gui.Position = UDim2.new(0,60,0,#g.Parent:GetChildren()*35)
	Gui.TextXAlignment = 'Left'
	local slider = Instance.new('Frame',Gui)
	slider.Size = UDim2.new(0,0,0,2)
	slider.Position = UDim2.new(.5,0,1,-2)
	slider.BorderSizePixel = 0
	slider.BackgroundColor3 = _G.Theme.SliderColor
	local info = Instance.new('TextLabel',Gui)
	info.Size = UDim2.new(0,0,1,0)
	info.Text = Comment
	info.BackgroundColor3 = _G.Theme.InfoColor
	info.TextSize = _G.Theme.InfoTextSize
	info.Position = UDim2.new(1,5,0,0)
	info.TextColor3 = _G.Theme.InfoTextColor
	info.ClipsDescendants = true
	info.Font = _G.Theme.InfoTextFont
	info.BorderSizePixel = 0
	
	local infobar = Instance.new('Frame',info)
	infobar.Size = UDim2.new(1,0,0,2)
	infobar.Position = UDim2.new(0,0,1,-2)
	infobar.BackgroundColor3 = _G.Theme.SliderColor
	infobar.BorderSizePixel = 0
	
	local Title = Instance.new('TextLabel',Gui)
	Title.Text = TitleText
	Title.Size = UDim2.new(1,0,1,0)
	Title.TextSize = _G.Theme.TextSize
	Title.Font = _G.Theme.TextFont
	Title.TextColor3 = _G.Theme.TextColor
	Title.BackgroundColor3 = _G.Theme.BackgroundColor
	Title.Visible = false
	Title.BackgroundTransparency = 1
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(1,5,0,0)
	
	local infobar = Instance.new('Frame',Title)
	infobar.Size = UDim2.new(1,0,0,2)
	infobar.Position = UDim2.new(0,0,1,-2)
	infobar.BackgroundColor3 = _G.Theme.ToggledColor
	infobar.BorderSizePixel = 0
	
	table.insert(new.Children,Title)
	new.AddTab = function(Text)
		local a = Instance.new('TextLabel',Title)
		a.Position = UDim2.new(0,0,0,(#Title:GetChildren()-1)*30)
		a.Size = UDim2.new(1,0,1,0)
		a.Text = Text
		a.BackgroundColor3 = _G.Theme.BackgroundColor
		a.TextColor3 = _G.Theme.TextColor
		a.BorderSizePixel = 0
		
		local b = Instance.new('Frame',a)
		b.Size = UDim2.new(1,0,0,2)
		b.Position = UDim2.new(0,0,1,-2)
		b.BorderSizePixel = 0
		b.BackgroundColor3 = _G.Theme.ToggledColor
		table.insert(new.Children,a)
		table.insert(new.Children,b)
	end
	new.AddButton = function(Text)
		Text = ' '..Text
		local a = Instance.new('TextButton',Title);
		a.Size = UDim2.new(1,0,1,0)
		a.Position = UDim2.new(0,0,0,(#Title:GetChildren()-1)*30)
		a.Text = Text
		a.BackgroundColor3 = _G.Theme.BackgroundColor
		a.TextColor3 = _G.Theme.TextColor
		a.BorderSizePixel = 0
		a.TextXAlignment = 'Left'
		table.insert(new.Children,a)
	end
	new.AddSelection = function(Text,Preset,table)
		local a = Instance.new('TextLabel',Title)
		--table.insert(new.Children,a)
		a.Size = UDim2.new(1,0,1,0)
		a.Position = UDim2.new(0,0,0,(#Title:GetChildren()-1)*30)
		a.Text = Preset
		a.BackgroundColor3 = _G.Theme.BackgroundColor
		a.TextColor3 = _G.Theme.TextColor
		a.BorderSizePixel = 0
		a.TextXAlignment = 'Left'
		new.Children[#new.Children+1] = a
		local b = Instance.new('TextButton',a)
		b.Size = UDim2.new(0,30,0,30)
		b.BackgroundTransparency = 1
		b.TextColor3 = _G.Theme.TextColor
		b.Text = '>'
		b.Position = UDim2.new(1,-30,0,0)
		local niggers = {}
		
		--table.insert(new.Children,b)
		b.MouseButton1Click:connect(function()
			a.Text = Text
			if b.Text == '>' then
				b.Text = '<'
				for i,v in pairs(table) do
					if not niggers[v] then
						local x = Instance.new('TextButton',b)
						x.Size = UDim2.new(0,200,0,30)
						x.BackgroundColor3 = _G.Theme.BackgroundColor
						x.Text = ' '..v
						x.Position = UDim2.new(1,0,0,30*(i-1))
						niggers[v] = x
						x.TextColor3 = _G.Theme.TextColor
						x.BorderSizePixel = 0
						x.MouseButton1Click:connect(function()
							a.Text = v
							for i,v in pairs(niggers) do
								v.Visible = false
							end
							b.Text = '>'
						end)
					else
						niggers[v].Visible = true
					end
				end
			else
				a.Text = Preset
				b.Text = '>'
				for i,v in pairs(niggers) do
					v.Visible = false
				end
			end
		end)
		return a
	end
	new.AddCheckButton = function(Text)
		Text = ' '..Text
		local toggle = false
		local a = Instance.new('TextLabel',Title);
		a.Size = UDim2.new(1,0,1,0)
		a.Position = UDim2.new(0,0,0,(#Title:GetChildren()-1)*30)
		a.Text = Text
		a.TextXAlignment = 'Left'
		a.BackgroundColor3 = _G.Theme.BackgroundColor
		a.TextColor3 = _G.Theme.TextColor
		a.BorderSizePixel = 0
		a.Name = Text
		local b = Instance.new('TextButton',a)
		b.Position = UDim2.new(1,-30,0,0)
		b.Size = UDim2.new(0,30,0,30)
		b.TextColor3 = _G.Theme.TextColor
		b.BackgroundColor3 = _G.Theme.CheckBoxColor
		b.BorderSizePixel = 0
		b.Text = ''
		b.TextSize = _G.Theme.CheckBoxTextSize
		b.Font = _G.Theme.TextFont
		b.Name = 'Holder'
		b.AutoButtonColor = false
		local c = Instance.new('Frame',b)
		c.Size = UDim2.new(.8,0,.8,0)
		c.Position = UDim2.new(.1,0,.1,0)
		c.BackgroundColor3 = Color3.new(1,1,1)
		c.BackgroundTransparency = .3
		c.BorderSizePixel = 0
		c.Visible = false
		c.Name = 'Toggle'
		b.MouseButton1Click:connect(function()
			toggle = not toggle
			c.Visible = toggle
		end)
		table.insert(new.Children,a)
		table.insert(new.Children,b)
		--table.insert(new.Children,c)
		return c
	end
	new.AddSlider = function(Text,max)
		Text = ' '..Text
		local a = Instance.new('TextLabel',Title)
		a.Size = UDim2.new(1,0,1,0)
		a.Position = UDim2.new(0,0,0,(#Title:GetChildren()-1)*30)
		a.Text = Text
		a.TextXAlignment = 'Left'
		a.BackgroundColor3 = _G.Theme.BackgroundColor
		a.BorderSizePixel = 0
		a.TextColor3 = _G.Theme.TextColor
		local b = Instance.new('TextButton',a)
		b.Size = UDim2.new(.55,0,0,2)
		b.Position = UDim2.new(.30,0,.5,-1)
		b.BackgroundColor3 = _G.Theme.SliderColor
		b.BorderSizePixel = 0
		b.AutoButtonColor = false
		b.Text = ''
		local c = Instance.new('TextButton',b)
		c.Size = UDim2.new(0,4,0,8)
		c.Position = UDim2.new(0,0,.5,-4)
		c.Text = ''
		c.BackgroundColor3 = _G.Theme.SliderButtonColor
		c.BorderSizePixel = 0
		local val = Instance.new('TextLabel',b)
		val.Size = UDim2.new(0,30,0,30)
		val.Text = 0
		val.TextColor3 = _G.Theme.TextColor
		val.BackgroundTransparency = 1
		val.Position = UDim2.new(1,0,0,-15)
		table.insert(new.Children,a)
		table.insert(new.Children,b)
		table.insert(new.Children,c)
		local UserInputService = game:GetService("UserInputService")
	
		local gui = c
		
		local dragging
		local dragInput
		local dragStart
		local startPos
		
		b.MouseButton1Down:connect(function()
			c.Position = UDim2.new(0,math.clamp(Mouse.X-b.AbsolutePosition.X,0,b.AbsoluteSize.X-2),0,-4)
			local perc = (b.AbsoluteSize.X-2)/gui.Position.X.Offset
			val.Text = math.floor(max/perc)
		end)
		
		local function update(input)
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X,0,b.AbsoluteSize.X-2), 0, -4)
			local perc = (b.AbsoluteSize.X-2)/gui.Position.X.Offset
			val.Text = math.floor(max/perc)
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
		return val
	end
	new.AddColorSelection = function(Text)
	
	end
	
	local Tween = game:GetService'TweenService'
	local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back)
	local spare = Instance.new('Frame',Gui)
	spare.BackgroundTransparency = 1
	spare.Size = UDim2.new(1,0,1,0)
	spare.ClipsDescendants = true
	Gui.MouseEnter:connect(function()
		slider:TweenSize(UDim2.new(1,0,0,2),'Out','Sine',.3,true)
		slider:TweenPosition(UDim2.new(0,0,1,-2),'Out','Sine',.3,true)
		if not toggled then
			info:TweenSize(UDim2.new(1,0,1,0),'Out','Sine',.5,true)
		end	
		local tween = Tween:Create(Gui,TweenInfo,{BackgroundColor3 = _G.Theme.HoverColor})
		tween:Play()
	end)
	Gui.MouseLeave:connect(function()
		slider:TweenSize(UDim2.new(0,0,0,2),'Out','Sine',.3,true)
		slider:TweenPosition(UDim2.new(.5,0,1,-2),'Out','Sine',.3,true)
		info:TweenSize(UDim2.new(0,0,1,0),'Out','Sine',.5,true)
		local tween = Tween:Create(Gui,TweenInfo,{BackgroundColor3 = _G.Theme.BackgroundColor})
		tween:Play()
	end)
	Gui.MouseButton1Click:connect(function()
		--info:TweenSize(UDim2.new(0,0,1,0),'Out','Sine',.2,true)
		info.Size = UDim2.new(0,0,1,0)
		spawn(function()
			local x = Instance.new('ImageLabel',spare)
			x.Size = UDim2.new(0,5,0,5)
			x.Position = UDim2.new(0,Mouse.X-Gui.AbsolutePosition.X,0,Mouse.Y-Gui.AbsolutePosition.Y)
			x.Image = "rbxassetid://63379753"
			x.ImageTransparency = .1
			x.ImageColor3 = _G.Theme.ClickColor
			x.BackgroundTransparency = 1
			x.BorderSizePixel = 0
			x:TweenSizeAndPosition(UDim2.new(0,300,0,300),UDim2.new(0,x.Position.X.Offset-150,0,x.Position.Y.Offset-150),'Out','Sine',1)
			for i=0.1,1,.05 do
				x.ImageTransparency = i+.1
				wait()
			end	
			x:Destroy()
		end)
		toggled = not toggled
		if toggled then
			new.FadeIn()
		else
			new.FadeOut()
		end
	end)
	return new
end
--[[
local a = g:new('Aimbot',"Settings for Aimbot","Settings")
a.AddCheckButton('Enabled')
a.AddTab('Toggles')
a.AddCheckButton('Team Check')
a.AddCheckButton('Visibility Check')
a.AddCheckButton('Draw FOV')
--a.AddButton('Button Test')
a.AddTab('Selection')
a.AddSelection('Aim Type','Cursor',{'Cursor','Camera'})
a.AddTab('Sliders')
a.AddSlider('Fov',100)
a.AddSlider('Smooth',10)
local b = g:new('Esp',"Settings for ESP","Settings")
b.AddCheckButton('Enabled')
b.AddTab('Toggles')
b.AddCheckButton('Team Check')
b.AddCheckButton('Name')
b.AddCheckButton('Health')
b.AddCheckButton('Distance')
b.AddCheckButton('Chams')--]]
local BadBusiness = g:new('BadBusiness','a game for noobs','Aimbot Settings')
local Enabled = BadBusiness.AddCheckButton('Aimbot Enabled')
BadBusiness.AddTab'Aim Options'
--local AimType = BadBusiness.AddSelection('Aim Type','Silent',{'Silent','Mouse'})
local Visible = BadBusiness.AddCheckButton('Shoot through Walls')
local DrB = BadBusiness.AddCheckButton('Draw Bullet Pos')
local DrawFov = BadBusiness.AddCheckButton('Draw FOV')
BadBusiness.AddTab'Sliders'
local SliderVal = BadBusiness.AddSlider('Fov',400)

local modulefolder;
local ProjectileModule;
local CharacterModule;
local TeamModule;
for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
    if #v.Name < 2 then 
        modulefolder = v
    end
end

for i,v in pairs(modulefolder:GetChildren()) do
	if require(v).FireProjectile then
		ProjectileModule = require(v)
	elseif require(v).GetPlayerFromCharacter then
		CharacterModule = require(v)
	elseif require(v).GetPlayerTeam then
		TeamModule = require(v)
	end
end

Camera = function() return workspace.CurrentCamera end
Character = function() return CharacterModule:GetCharacter(game.Players.LocalPlayer) end

function IsVisible(Part)
	if Part then
		local ScreenPos = Camera():WorldToScreenPoint(Part.Position)
		local unitRay = Camera():ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
		local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
		local Ignore = Character():GetChildren()
		
		for i,v in pairs(Camera():GetChildren()) do
			table.insert(Ignore,v)
		end
		local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
		local ShouldReturn
		pcall(function()
			ShouldReturn = Hit:IsDescendantOf(Part.Parent.Parent)
		end)
		return (ShouldReturn or false)
	end
end

function IsOnScreen(part)
	local vector, onscreen = Camera():WorldToScreenPoint(part.Position)
	return(vector.Z > 0)
end

function IsInFov(Part)
	if IsOnScreen(Part) then
		local Mouse = game.Players.LocalPlayer:GetMouse()
		local X = Mouse.X
		local Y = Mouse.Y
		local MinX = X-(240)
		local MaxX = X+(240)
		local MinY = Y-(240)
		local MaxY = Y+(240)
		if Part then
			local ScreenPos = Camera():WorldToScreenPoint(Part.Position)
			if ScreenPos.Y > MinY and ScreenPos.Y < MaxY and ScreenPos.X > MinX and ScreenPos.X < MaxX then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end
GetHead = function()
	local ShouldReturn;
	local team = TeamModule:GetPlayerTeam(game.Players.LocalPlayer)
	for i,v in pairs(game.Players:GetChildren()) do
		pcall(function()
			team = TeamModule:GetPlayerTeam(game.Players.LocalPlayer)
			if TeamModule:GetPlayerTeam(v) ~= team and CharacterModule:GetCharacter(v) and IsInFov(CharacterModule:GetCharacter(v).Hitbox.Head) then
				ShouldReturn = CharacterModule:GetCharacter(v).Hitbox.Head
				return CharacterModule:GetCharacter(v).Hitbox.Head
			end
		end)
	end
	return ShouldReturn or false
end

function GetDistAwayFromCursor(Part)
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local X = Mouse.X
	local Y = Mouse.Y
	local x = Camera():WorldToViewportPoint(Part.Position)
	return(X-x.X + Y-x.Y)
end

function GetTargetByFov()
	team = TeamModule:GetPlayerTeam(game.Players.LocalPlayer)
	local shouldreturn;
	pcall(function()
	local dist = {}
	local pliar = {}
	for i,v in pairs(game.Players:GetChildren()) do
		if CharacterModule:GetCharacter(v) and CharacterModule:GetCharacter(v).Hitbox.Head and TeamModule:GetPlayerTeam(v) ~= team then
			if IsInFov(CharacterModule:GetCharacter(v).Hitbox.Head) then
				if not Visible.Visible then
					if IsVisible(CharacterModule:GetCharacter(v).Hitbox.Head) then
						table.insert(pliar,v)
					end
				else
					table.insert(pliar,v)
				end
			end
		end
	end
	for i,v in pairs(pliar) do
		if CharacterModule:GetCharacter(v).Hitbox.Head and TeamModule:GetPlayerTeam(v) ~= team then
			table.insert(dist, math.abs(GetDistAwayFromCursor(CharacterModule:GetCharacter(v).Hitbox.Head)))
		end
	end
	for i,v in pairs(dist) do
		if v == math.min(unpack(dist)) then
			shouldreturn = CharacterModule:GetCharacter(pliar[i]).Hitbox.Head
			return CharacterModule:GetCharacter(pliar[i]).Hitbox.Head
		end
	end
	end)
	return (shouldreturn or false)
end


gay = ProjectileModule.FireProjectile
ProjectileModule.FireProjectile = function(name,BulletType,Position,Direction,PlayerWhoShot,PlayersBulletsShot,weapon)
	syn.set_thread_identity(6)
	if PlayerWhoShot == game.Players.LocalPlayer and Enabled.Visible then
		local Target = GetTargetByFov()
		if Target then
			--Position = (Target.CFrame * CFrame.new(Direction.X,Direction.Y,Direction.Z)).Position
			Direction = (Target.Position-Position).unit
			if Visible.Visible then
				Position = (Target.Parent.Parent.Body.Head.Position - Direction)
			end
			if DrB.Visible then
				spawn(function()
					local x = Instance.new('Part',workspace)
					x.Size = Vector3.new(1,1,1)
					x.Anchored = true
					x.Position = Position
					x.CanCollide = false
					x.Transparency = 1
					local y = Instance.new('BoxHandleAdornment',x)
					y.AlwaysOnTop = true
					y.Size = x.Size
					y.Adornee = x
					y.ZIndex = 6
					y.Color3 = Color3.new(1,0,0)
					y.Transparency = .3
					wait(5)
					x:Destroy()
				end)
			end
		else
			Direction = (game.Players.LocalPlayer:GetMouse().Hit.p-CharacterModule:GetCharacter(game.Players.LocalPlayer).Body.Head.Position).unit
		end
	end
	gay(name,BulletType,Position,Direction,PlayerWhoShot,PlayersBulletsShot,weapon)
end

game:GetService'RunService'.RenderStepped:connect(function()
	if not Settings['FoV'] then
		Settings['FoV'] = Instance.new('Frame',g.Parent)
	end
	if DrawFov.Visible then
		Settings['FoV'].Visible = true
		Settings['FoV'].Size = UDim2.new(0,SliderVal.Text,0,SliderVal.Text)
		Settings['FoV'].Position = UDim2.new(.5,-SliderVal.Text/2,.5,-SliderVal.Text/2)
		Settings['FoV'].BackgroundColor3 = _G.Theme.FovColor
		Settings['FoV'].BackgroundTransparency = _G.Theme.FovTransparency
		Settings['FoV'].BorderSizePixel = 0
	else
		Settings['FoV'].Visible = false
	end
end)
