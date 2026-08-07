SendMessage = print
local _print = print
print = function(str)
	str = tostring(str)
	if str:lower():find('http') then
		_print'no u'
	else
		_print(str)
	end
end
local _error = error
error = function(str)
	if str:lower():find('http') then
		_print'no u'
	else
		_print(str)
	end
end
local _warn = warn
warn = function(str)
	if str:lower():find('http') then
		_print'no u'
	else
		_print(str)
	end
end


local MouseMoveEquiv
local MouseDownEquiv
local MouseUpEquiv

if leftpress then
	SendMessage('Script ajusted for SirHurt')
	MouseMoveEquiv = mousemoverel
	MouseDownEquiv = leftpress
	MouseUpEquiv = leftrelease
end

if mouse1press and not MouseMoveEquiv then
	SendMessage('Script ajusted for Synapse')
	if mousemoverel then
		MouseMoveEquiv = mousemoverel
	end
	MouseDownEquiv = mouse1press
	MouseUpEquiv = mouse1release
end
if PROTOSMASHER_LOADED and not MouseMoveEquiv then
	SendMessage('Script ajusted for Protosmasher')
	MouseMoveEquiv = Input.MoveMouse
	MouseDownEquiv = function()
		Input.LeftClick(MOUSE_DOWN)
	end
	MouseUpEquiv = function()
		Input.LeftClick(MOUSE_UP)
	end
end



local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera
--// Towlie Hub Write 1 \\--
loadstring(game:GetObjects("rbxassetid://967517547")[1].Source)()
local msg = require(3137247453)
local sg = Instance.new('ScreenGui',game.CoreGui)
sg.Name = math.random(1,99999999)
function Round(ting)
	local round = Instance.new('ImageLabel',ting)
	round.Size = ting.Size
	round.BackgroundTransparency = 1
	round.ImageTransparency = ting.BackgroundTransparency
	round.ImageColor3 = ting.BackgroundColor3
	round.ZIndex = 1
	round.Image = "rbxassetid://2851926732"
	round.ScaleType = 'Slice'
	round.SliceCenter = Rect.new(12,12,12,12)
	ting.BackgroundTransparency = 1
	ting.ZIndex = 2
end
function setup(ting)
	ting.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	ting.BackgroundTransparency = 0
end
function button(ting)
	local ting2 = Instance.new('TextButton',ting)
	ting2.Size = UDim2.new(0,20,0,20)
	ting2.Position = UDim2.new(1,-20,0,0)
	ting2.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Circle(ting2)
	return ting2
end
function Circle(ting)
	ting.Text = ''
	ting.BackgroundColor3 = Color3.fromRGB(52,52,52)
	local round = Instance.new('ImageLabel',ting)
	round.Size = ting.Size
	round.BackgroundTransparency = 1
	round.ImageTransparency = ting.BackgroundTransparency
	round.ImageColor3 = Color3.fromRGB(21, 21, 21)
	round.ZIndex = 3
	round.Image = "rbxassetid://2851923546"
	round.ScaleType = 'Slice'
	round.SliceCenter = Rect.new(20,20,20,20)
	ting.BackgroundTransparency = 1
	ting.ZIndex = 2
	local round2 = Instance.new('ImageLabel',round)
	round2.BackgroundTransparency = 1
	round2.ImageTransparency = 0
	round2.ImageColor3 = Color3.new(1,1,1)
	round2.Size = UDim2.new(.8,0,.8,0)
	round2.Position = UDim2.new(.1,0,.1,0)
	round2.ZIndex = 4
	round2.Name = 'tog'
	round2.Image = "rbxassetid://2851923546"
	round2.ScaleType = 'Slice'
	round2.SliceCenter = Rect.new(20,20,20,20)
	round2.Visible = false
	ting.MouseButton1Down:connect(function()
		round2.Visible = not round2.Visible
	end)
end
function Slider(thing,thing2,x)
	local slider = Instance.new('Frame',thing)
	slider.Size = UDim2.new(0,6,0,6)
	slider.Position = UDim2.new(0,0,0,-3)
	slider.BorderSizePixel = 0
	slider.BackgroundColor3 = Color3.new(1,1,1)
	local UserInputService = game:GetService('UserInputService')
	local gui = slider
	local label = thing2
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(math.clamp(startPos.X.Scale,0,1), math.clamp(startPos.X.Offset + delta.X,0,thing.Size.X.Offset-5), 0, -3)
		local perc = (gui.Position.X.Offset)/(thing.Size.X.Offset-5)
		if perc == 1 then
			label.Text = math.floor((perc*1)*x)
		else
			label.Text = math.floor((perc%1)*x)
		end	
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
function IsEnabled(ting)
	return ting.ImageLabel.tog.Visible
end

local gui = {}
gui.Round = function(Gui)
	local round = Instance.new('ImageLabel',Gui)
	round.Size = Gui.Size
	round.BackgroundTransparency = 1
	round.ImageTransparency = Gui.BackgroundTransparency
	round.ImageColor3 = Gui.BackgroundColor3
	round.ZIndex = 1
	round.Image = "rbxassetid://2851926732"
	round.ScaleType = 'Slice'
	round.SliceCenter = Rect.new(12,12,12,12)
	Gui.BackgroundTransparency = 1
	Gui.ZIndex = Gui.ZIndex +1
	return round
end
gui.Circle = function(Gui)
	local round = Instance.new('ImageLabel',Gui)
	round.Size = Gui.Size
	round.BackgroundTransparency = 1
	round.ImageTransparency = Gui.BackgroundTransparency
	round.ImageColor3 = Gui.BackgroundColor3
	round.ZIndex = Gui.ZIndex + 1
	round.Image = "rbxassetid://2851923546"
	round.ScaleType = 'Slice'
	round.SliceCenter = Rect.new(20,20,20,20)
	Gui.BackgroundTransparency = 1
	return round
end
gui.Button = function(Gui)
	local button = Instance.new('TextButton',Gui)
	button.Size = UDim2.new(0,20,0,20)
	button.Position = UDim2.new(1,-20,0,0)
	button.BackgroundColor3 = Color3.fromRGB(21,21,21)
	button.Text = ''
	gui.Circle(button)
	local toggle = Instance.new('TextButton',button)
	toggle.Size = UDim2.new(0,16,0,16)
	toggle.Position = UDim2.new(0,2,0,2)
	toggle.BackgroundColor3 = Color3.new(1,1,1)
	toggle.Text = ''
	local coon = gui.Circle(toggle)
	toggle.Visible = false
	toggle.ZIndex = 0
	button.ZIndex = 9
	coon.ZIndex = 9
	button.MouseButton1Down:connect(function()
		toggle.Visible = not toggle.Visible
	end)
	return button
end
gui.SetButton = function(Gui,size)
	Gui.TextColor3 = Color3.new(1,1,1)
	Gui.Size = UDim2.new(0,size,0,20)
	Gui.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	gui.Round(Gui)
	
end
gui.SetTitle = function(Gui,size)
	Gui.TextColor3 = Color3.new(1,1,1)
	Gui.Size = UDim2.new(0,size,0,20)
	Gui.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	local nig = gui.Round(Gui)
	Gui.Draggable = true
	Gui.TextXAlignment = 'Left'
	Gui.ZIndex = 7
	nig.ZIndex = 6
end
gui.Background = function(Gui)
	Gui.ZIndex = 0
	Gui.BackgroundColor3=Color3.fromRGB(34, 34, 34)
	gui.Round(Gui)
end
gui.Combine = function(Gui)
	gui.Round(Gui)
	return gui.Button(Gui)
end
sg = Instance.new('ScreenGui',game.CoreGui)
local tit = Instance.new('TextButton',sg)
gui.SetTitle(tit,279)
tit.Position = UDim2.new(0.5,-130,0.5,-50)
tit.Text = '  Towlie-Hub Login'
local b = Instance.new('Frame',tit)
b.Size = UDim2.new(1,0,0,198)
gui.Background(b)
local user = Instance.new('TextBox',b)
user.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
user.Size = UDim2.new(0,261,0,20)
user.Position = UDim2.new(0.032,0,0,30)
user.TextColor3 = Color3.new(1,1,1)
user.Text = 'Username'
gui.Round(user)
local pw = Instance.new('TextBox',b)
pw.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
pw.Size = UDim2.new(0,261,0,20)
pw.Position = UDim2.new(0.032,0,0,55)
pw.TextColor3 = Color3.new(1,1,1)
pw.Text = 'Password'
p1 = Instance.new('TextLabel',pw)
p1.Size = UDim2.new(1,0,1,0)
p1.ZIndex = 3
p1.BackgroundTransparency = 1
p1.TextColor3 = Color3.new(1,1,1)
p1.Text = ''
p1.TextSize = 12
pw.Focused:connect(function()
	pw.TextTransparency = 1
end)

pw.Changed:connect(function()
	pw.TextTransparency = 1
	if p1 then
		p1.Text = string.rep('*',string.len(pw.Text))
	end
end)
gui.Round(pw)
local a = Instance.new('TextLabel',b)
a.Text = '    Auto-Login'
a.Position = UDim2.new(0.032,0,0,80)
gui.SetButton(a,94)
local AutoLogin = gui.Combine(a)
AutoLogin.Position = UDim2.new(0,0,0,0)
local Login = Instance.new('TextButton',b)
Login.Text = 'Login'
Login.Position = UDim2.new(0,110,0,80)
gui.SetButton(Login,158)
local Notes = Instance.new('Frame',b)
Notes.Size = UDim2.new(0.94,0,0,80)
Notes.Position = UDim2.new(0.03,0,0,110)
Notes.BackgroundColor3=Color3.fromRGB(34, 34, 34)
Notes.BorderColor3 = Color3.new(1,1,1)
local Note = Instance.new('TextLabel',Notes)
Note.Text = [[
	v1.0.3 Patch Notes:
	Strucid Optimization
	------------------
	v1.0.2 Patch Notes:
	Added Games
]]
Note.TextColor3 = Color3.new(1,1,1)
Note.TextXAlignment = 'Left'
Note.TextYAlignment = 'Top'
local Confirmation = false
local twofa = false
Login.MouseButton1Down:connect(function()
a = game:HttpGet('https://basehosting.xyz/whitelist.php?user='..user.Text..'&password='..pw.Text)
local stat = string.split(a,'.')

if stat[1] == 'Whitelisted' and stat[2]:len() ~= 20 then
	while true do end
else
	Confirmation = true
end
local ret_user = stat[3]
local ret_password = stat[4]
if ret_user == user.Text and ret_password == pw.Text then
twofa = true
else
print'wtf'
end
print(a)
print(tostring(twofa)..':'..tostring(Confirmation))
end)
repeat wait() until Confirmation
repeat wait() until twofa

tit:Destroy()

print'User Authenticated!'

--[[if IsEnabled(AutoLogin) then
	writefile('AutoLogin',"return {'"..Username.Text.."','"..Password.Text.."'}")
end--]]
msg.new('Towlie Hub','Sucessfully Authenticated.')
local fovting = Instance.new('Frame',sg)
fovting.BackgroundTransparency = .6
fovting.BorderSizePixel = 0
fovting.Size = UDim2.new(0,0,0,0)
fovting.Position = UDim2.new(0.5,0,.5,0)
local Settings = Instance.new('TextButton',sg)
Settings.Size = UDim2.new(0,142,0,20)
Settings.Position = UDim2.new(0,0,0.5,-50)
setup(Settings)
Settings.TextColor3 = Color3.new(1,1,1)
Settings.Text = 'Settings'
Settings.Draggable = true
Round(Settings)
local SClose = Instance.new('TextButton',Settings)
SClose.Position = UDim2.new(1,-20,0,0)
SClose.Size = UDim2.new(0,20,0,20)
SClose.BackgroundColor3 = Color3.fromRGB(52,52,52)
Circle(SClose)
local Sback = Instance.new('Frame',Settings)
SClose.MouseButton1Down:connect(function()
	Sback.Visible = not IsEnabled(SClose)
end)
Sback.Size = UDim2.new(1,0,0,120)
setup(Sback)
Sback.Visible = false
Round(Sback)
local sa = Instance.new('TextButton',Sback)
sa.Size = UDim2.new(1,0,0,20)
sa.Position = UDim2.new(0,0,0,20)
sa.Text = 'Aimbot Menu'
sa.TextColor3 = Color3.new(1,1,1)
setup(sa)
AT = button(sa)
Round(sa)
local se = Instance.new('TextButton',Sback)
se.Size = UDim2.new(1,0,0,20)
se.Position = UDim2.new(0,0,0,40)
se.Text = 'ESP Menu'
se.TextColor3 = Color3.new(1,1,1)
setup(se)
ET = button(se)
Round(se)
local sc = Instance.new('TextButton',Sback)
sc.Size = UDim2.new(1,0,0,20)
sc.Position = UDim2.new(0,0,0,60)
sc.Text = 'Colors Menu'
sc.TextColor3 = Color3.new(1,1,1)
setup(sc)
button(sc)
Round(sc)
local sga = Instance.new('TextButton',Sback)
sga.Size = UDim2.new(1,0,0,20)
sga.Position = UDim2.new(0,0,0,80)
sga.Text = 'Game List'
sga.TextColor3 = Color3.new(1,1,1)
setup(sga)
local listgames = button(sga)
Round(sga)
local cg = Instance.new('TextButton',Sback)
cg.Size = UDim2.new(1,0,0,20)
cg.Position = UDim2.new(0,0,0,100)
cg.Text = '%current game%'
cg.TextColor3 = Color3.new(1,1,1)
setup(cg)
local CurGame = button(cg)
Round(cg)

--//  Aimbot Menu  \\--

local aim = Instance.new('TextButton',sg)
aim.Visible = false
aim.Size = UDim2.new(0,297,0,20)
aim.Position = UDim2.new(0,150,0.5,-50)
AT.MouseButton1Down:connect(function()
	aim.Visible = not aim.Visible
end)
aim.Text = 'Aimbot'
aim.Draggable = true
aim.TextColor3 = Color3.new(1,1,1)
aim.BackgroundColor3 = Color3.fromRGB(27,27,27)
aim.ZIndex = 5
local close = button(aim)
local back = Instance.new('Frame',aim)
back.Size = UDim2.new(1,0,0,145)
back.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
back.BackgroundTransparency = 0
Round(back)
Round(aim)
close.MouseButton1Down:connect(function()
	back.Visible = not back.Visible
end)
close.ImageLabel.tog.Visible = true
local a = Instance.new('Frame',back)
a.Size = UDim2.new(0,167,0,40)
a.Position = UDim2.new(0,0,0,20)
a.BackgroundColor3 = Color3.fromRGB(44,44,44)
a.BackgroundTransparency = .5
setup(a)
Round(a)
local b = Instance.new('TextLabel',a)
b.Size = UDim2.new(1,0,0,20)
b.BackgroundTransparency = 1
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'FOV: '
local Fov = Instance.new('TextLabel',a)
Fov.Size = UDim2.new(0,20,0,20)
Fov.Position = UDim2.new(1,-25,1,-20)
Fov.Text = 0
Fov.TextColor3 = Color3.new(1,1,1)
Fov.BackgroundTransparency = 1
local b = Instance.new('Frame',a)
b.Size = UDim2.new(0,130,0,1)
b.Position = UDim2.new(0,10,0.5,10)
b.BackgroundColor3 = Color3.new(1,1,1)
b.BorderSizePixel = 0
Slider(b,Fov,180)
local b = Instance.new('TextLabel',back)
b.Position = UDim2.new(0,0,0,60)
b.Size = UDim2.new(0,167,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Draw FOV'
setup(b)
Round(b)
local Draw = button(b)
local b = Instance.new('TextLabel',back)
b.Position = UDim2.new(0,0,0,80)
b.Size = UDim2.new(0,167,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Free for All'
setup(b)
Round(b)
local AFFA = button(b)
local b = Instance.new('TextLabel',back)
b.Position = UDim2.new(0,0,0,100)
b.Size = UDim2.new(0,167,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Visible Only'
setup(b)
Round(b)
local AVis = button(b)
local b = Instance.new('TextLabel',back)
b.Position = UDim2.new(0,0,0,120)
b.Size = UDim2.new(0,167,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Hitscan'
setup(b)
Round(b)
local AHit = button(b)
local b = Instance.new('TextLabel',back)
b.Position = UDim2.new(0,167,0,60)
b.Size = UDim2.new(0,130,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Prediction'
setup(b)
Round(b)
local APred = button(b)
local b = Instance.new('Frame',back)
b.Position = UDim2.new(0,167,0,20)
b.Size = UDim2.new(0,130,0,40)
setup(b)
Round(b)
local c = Instance.new('TextLabel',b)
c.Size = UDim2.new(1,0,0,20)
c.TextColor3 = Color3.new(1,1,1)
c.Text = 'Smooth:'
c.BackgroundTransparency = 1
local Smooth = Instance.new('TextLabel',b)
Smooth.Size = UDim2.new(0,20,0,20)
Smooth.Position = UDim2.new(0,110,0.5,0)
Smooth.BackgroundTransparency = 1
Smooth.TextColor3 = Color3.new(1,1,1)
Smooth.Text = '0'
local c = Instance.new('Frame',b)
c.Size = UDim2.new(0,100,0,1)
c.Position = UDim2.new(0,10,0.5,10)
c.BorderSizePixel = 0
c.BackgroundColor3 = Color3.new(1,1,1)
Slider(c,Smooth,10)


local esp = Instance.new('TextButton',sg)
esp.Size = UDim2.new(0,130,0,20)
esp.Position = UDim2.new(0,450,0.5,-50)
esp.Visible = false
esp.Text = 'Esp'
esp.Draggable = true
esp.TextColor3 = Color3.new(1,1,1)
esp.BackgroundColor3 = Color3.fromRGB(27,27,27)
esp.ZIndex = 5
Round(esp)
local back = Instance.new('Frame',esp)
back.Size = UDim2.new(1,0,0,160)
back.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
back.BackgroundTransparency = 0
Round(back)
local Close = button(esp)
Close.ImageLabel.tog.Visible = true
Close.MouseButton1Down:connect(function()
	back.Visible = not IsEnabled(Close)
end)
local a = Instance.new('Frame',back)
a.Size = UDim2.new(1,0,0,40)
a.Position = UDim2.new(0,0,0,20)
setup(a)
Round(a)
local b = Instance.new('TextLabel',a)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.BackgroundTransparency = 1
b.Text = 'Max Distance'
local EDistance = Instance.new('TextLabel',a)
EDistance.Size = UDim2.new(0,20,0,20)
EDistance.Position = UDim2.new(1,-20,1,-20)
EDistance.Text = '0'
EDistance.TextColor3 = Color3.new(1,1,1)
EDistance.BackgroundTransparency = 1
local c = Instance.new('Frame',a)
c.Size = UDim2.new(0,100,0,1)
c.BackgroundColor3 = Color3.new(1,1,1)
c.Position = UDim2.new(0,10,0.5,10)
Slider(c,EDistance,10000)
local b = Instance.new('TextLabel',a)
b.Position = UDim2.new(0,0,0,40)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Free for All'
setup(b)
Round(b)
local effa = button(b)
local b = Instance.new('TextLabel',a)
b.Position = UDim2.new(0,0,0,60)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Chams'
setup(b)
Round(b)
local chams = button(b)
local b = Instance.new('TextLabel',a)
b.Position = UDim2.new(0,0,0,80)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'Hitbox'
setup(b)
Round(b)
local hitbox = button(b)
local b = Instance.new('TextLabel',a)
b.Position = UDim2.new(0,0,0,100)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = '2d Box'
setup(b)
Round(b)
local Dynamic = button(b)
local b = Instance.new('TextLabel',a)
b.Position = UDim2.new(0,0,0,120)
b.Size = UDim2.new(1,0,0,20)
b.TextColor3 = Color3.new(1,1,1)
b.Text = 'XRay'
setup(b)
Round(b)
local xray = button(b)
local niggerfaggot = Instance.new('TextButton',sg)
local back = Instance.new('Frame',niggerfaggot)
back.Size = UDim2.new(1,0,0,150)
back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
gui.SetTitle(niggerfaggot,100)
niggerfaggot.Position = UDim2.new(0,0,0.5,150)
niggerfaggot.Text = 'Games List'
niggerfaggot.Visible = false
listgames.MouseButton1Down:connect(function()
	niggerfaggot.Visible = not niggerfaggot.Visible
end)
local close = gui.Button(niggerfaggot)
gui.Round(back)
close.MouseButton1Down:connect(function()
	back.Visible = not back.Visible
end)
-- // Other Locals \\ --
local Target;
local UserSetting = UserSettings():GetService'UserGameSettings'
local uip = game:GetService('UserInputService')
-- // Settings \\ --
local Esp = {
	['ffa'] = false,
	['chams'] = false,
	['hitbox'] = false,
	['dynamic'] = false,
}
local aimbot = {
	['fov'] = 0,
	['smooth'] = 0,
	['ffa'] = false,
	['visible'] = false,
	['hitscan'] = false,
	['prediction'] = false,
	['draw'] = false,
}

-- // Functions \\ --

function ID(a)
	local Max = tonumber(EDistance.Text)
	if a.Character and a.Character.PrimaryPart and a ~= Player then
		return (a.Character.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude < Max
	else
		return false
	end
	
end
local hooked = {}
function Chams(p)
	for i,v in pairs(hooked) do
		if v.Adornee == nil then
			v:Destroy()
		end
	end
	if not Esp['ffa'] and p.Team == Player.Team then return false end
	if p.Character and Esp['chams'] and ID(p) then
		for i,v in pairs(p.Character:GetChildren()) do
			if v:IsA'BasePart' then
				local cham = Instance.new('BoxHandleAdornment',game.CoreGui)
				cham.Size = v.Size
				cham.Adornee = v
				cham.AlwaysOnTop = true
				cham.Color3 = Color3.new(1,0,0)
				cham.ZIndex = 5
				cham.Transparency = .4
				v.Parent.Humanoid.Died:connect(function()
					cham:Destroy()
				end)
				table.insert(hooked,cham)
			end
		end
	end
end
function Hitbox(p)
	for i,v in pairs(hooked) do
		if v.Adornee == nil then
			v:Destroy()
		end
	end
	if not Esp['ffa'] and p.Team == Player.Team then return false end
	if p.Character and Esp['hitbox'] and ID(p) then
		for i,v in pairs(p.Character:GetChildren()) do
			if v:IsA'BasePart' then
				local cham = Instance.new('SelectionBox',game.CoreGui)
				cham.Adornee = v
				cham.Color3 = Color3.new(0,0,1)
				v.Parent.Humanoid.Died:connect(function()
					cham:Destroy()
				end)
				table.insert(hooked,cham)
			end
		end
	end
end
function dynamic(p)
	for i,v in pairs(hooked) do
		if v.Adornee == nil then
			v:Destroy()
		end
	end
	if not Esp['ffa'] and p.Team == Player.Team then return false end
	if p.Character and Esp['dynamic'] and ID(p) then
		if p.Character.Head then
			print(p.Name)
			local bill = Instance.new('BillboardGui')
			bill.Size = UDim2.new(4,0,7,0)
			bill.Parent = p.Character:FindFirstChild'Torso' or p.Character:FindFirstChild'UpperTorso'
			bill.Adornee = bill.Parent
			bill.AlwaysOnTop = true
			local frame = Instance.new('Frame',bill)
			frame.BackgroundTransparency = .4
			frame.BorderColor3 = Color3.new(1,1,1)
			frame.BackgroundColor3 = Color3.new(1,0,0)
			frame.Size = UDim2.new(1,0,1,0)
			table.insert(hooked,bill)
		end
	end
end
function Refresh()
	for i,v in pairs(hooked) do
		v:Destroy()
	end
	for i,v in pairs(Players:GetChildren()) do
		if v.Character then
			Chams(v)
			Hitbox(v)
			dynamic(v)
		end
	end
end
local update=false
EDistance.Changed:connect(function(property)
	if update ~= true then
		update=true
	end
end)
function EspStart()
	for i,v in pairs(Players:GetChildren()) do
		v.CharacterAdded:connect(function()
			repeat wait() until v.Character.PrimaryPart
			Chams(v)
			Hitbox(v)
			dynamic(v)
		end)
	end
	Players.PlayerAdded:connect(function(v)
		v.CharacterAdded:connect(function()
			repeat wait() until v.Character.PrimaryPart
			Chams(v)
			Hitbox(v)
			dynamic(v)
		end)
	end)
end
function IsOnScreen(part)
	if part then
		local z,b = Camera:WorldToScreenPoint(part.Position)
		return z.Z > 0
	else
		return false
	end
end
function CursorDist(part)
	if part then
		local X = Mouse.X
		local Y = Mouse.Y
		local x = Camera:WorldToScreenPoint(part.Position)
		return (X-x.X + Y-x.Y)
	else
		return (math.huge)
	end
end
function IsVisible(Part)
	if Part then
		local ScreenPos = Camera:WorldToScreenPoint(Part.Position)
		local unitRay = Camera:ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
		local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
		local Ignore = Player.Character:GetChildren()
		for i,v in pairs(Camera:GetChildren()) do
			table.insert(Ignore,v)
		end
		local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
		local ShouldReturn
		pcall(function()
			ShouldReturn = (Hit == Part or Hit.Parent.Name == Part.Parent.Name or Hit.Parent.Parent.Name == Part.Parent.Name or Hit.Parent.Parent.Parent.Name == Part.Parent.Name)
		end)
		return (ShouldReturn or false)
	else
		return false
	end
end
function IsInFov(part)
	if part and IsOnScreen(part) then
		local fovsize = aimbot['fov']/180
		local ScreenPos = Camera:WorldToScreenPoint(part.Position)
		local x = Mouse.ViewSizeX/2
		local y = Mouse.ViewSizeY/2
		local minx = x-(fovsize*Mouse.ViewSizeX)/2
		local miny = y-(fovsize*Mouse.ViewSizeY)/2
		local maxx = y+(fovsize*Mouse.ViewSizeY)/2
		local maxy = x+(fovsize*Mouse.ViewSizeX)/2
		if ScreenPos.Y > miny and ScreenPos.Y < maxy and ScreenPos.X > minx and ScreenPos.X < maxx then
			return true
		else
			return false
		end
	else
		return false
	end
end
function GetTarget(Player)
	if Player and Player.Character then
		if aimbot['hitscan'] then
			if Player.Character:FindFirstChild'Head' then
				return Player.Character:FindFirstChild'Head'
			end
			for i,v in pairs(Player.Character:GetChildren()) do
				if v:IsA'BasePart' then
					return v
				end
			end
		else
			return Player.Character:FindFirstChild'Head'
		end
	else
		return nil;
	end
end
function ByFov()
	local dist = {}
	local pliar = {}
	if Target and not IsInFov(Target) or not IsOnScreen(Target) then
		Target = nil
	end
	if Target then
		if aimbot['visible'] then
			if not IsVisible(Target) then
				Target = nil
			end
		end
	end
	if not Target then
		for i,v in pairs(Players:GetChildren()) do--
			if v.Character and GetTarget(v) and v ~= Player and v.Character:FindFirstChild'Humanoid' and v.Character.Humanoid.Health > 0 then
				if IsInFov(GetTarget(v)) then
					if aimbot['ffa'] then
						table.insert(pliar,v)
					elseif v.Team ~= Player.Team then
						table.insert(pliar,v)
					end
				end
			end
		end
		for i,v in pairs(pliar) do
			if GetTarget(v) then
				table.insert(dist,math.abs(CursorDist(GetTarget(v))))
			end
		end
		for i,v in pairs(dist) do
			if v == math.min(unpack(dist)) then
				if aimbot['visible'] then
					if IsVisible(GetTarget(pliar[i])) then
						Target = GetTarget(pliar[i])
						return
					end
				else
					Target = GetTarget(pliar[i])
					return
				end
			end
		end
	end
end

local aim = false
spawn(function()
	while wait() do 
		if uip:IsKeyDown(Enum.KeyCode.LeftShift) then
			aim = true
		else
			aim = false
		end
	end
end)
function SetAim(part)--
	if part and aim then
		local dist = (GetTarget(Player).Position - part.Position).Magnitude
		local newpos = part.Position
		if aimbot['prediction'] then
			newpos = part.Position + (part.Parent.PrimaryPart.Velocity*(1* (dist/1000)))
		end
		local AimPos = Camera:WorldToScreenPoint(newpos)
		local moveto = AimPos
		if aimbot['smooth'] == 0 then
			aimbot['smooth'] = 1
		end
		if UserSetting.MouseSensitivity >= 1 then
			moveto = Vector2.new((((AimPos.X-Mouse.X))/UserSetting.MouseSensitivity)/aimbot['smooth'],(((AimPos.Y-Mouse.Y))/UserSetting.MouseSensitivity))/aimbot['smooth']
		else
			moveto = Vector2.new((((AimPos.X-Mouse.X))*UserSetting.MouseSensitivity)/aimbot['smooth'],(((AimPos.Y-Mouse.Y))*UserSetting.MouseSensitivity))/aimbot['smooth']
		end
		MouseMoveEquiv(moveto.X,moveto.Y)
	end
end


 -- // GUI toggles \\ -- 
ET.MouseButton1Down:connect(function()
	esp.Visible = not IsEnabled(ET)
end)
effa.MouseButton1Down:connect(function()
	for i,v in pairs(hooked) do
		v:Destroy()
	end
	Esp['ffa'] = not Esp['ffa']
	Refresh()
end)
chams.MouseButton1Down:connect(function()
	Esp['chams'] = not Esp['chams']
	if Esp['chams'] == false then
		for i,v in pairs(hooked) do
			if v:IsA'BoxHandleAdornment' then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(Players:GetChildren()) do
			Chams(v)
		end
	end
end)
hitbox.MouseButton1Down:connect(function()
	Esp['hitbox'] = not IsEnabled(hitbox)
	if Esp['hitbox'] == false then
		for i,v in pairs(hooked) do
			if v:IsA'SelectionBox' then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(Players:GetChildren()) do
			Hitbox(v)
		end
	end
end)
Dynamic.MouseButton1Down:connect(function()
	Esp['dynamic'] = not IsEnabled(Dynamic)
	if Esp['dynamic'] == false then
		for i,v in pairs(hooked) do
			if v:IsA'BillboardGui' then
				v:Destroy()
			end
		end
	else
		for i,v in pairs(Players:GetChildren()) do
			dynamic(v)
		end
	end
end)
Fov.Changed:connect(function()
	aimbot['fov'] = tonumber(Fov.Text)
end)
Smooth.Changed:connect(function()
	aimbot['smooth'] = tonumber(Smooth.Text)
end)
AFFA.MouseButton1Down:connect(function()
	aimbot['ffa'] = not aimbot['ffa']
end)
AVis.MouseButton1Down:connect(function()
	aimbot['visible'] = not aimbot['visible']
end)
AHit.MouseButton1Down:connect(function()
	aimbot['hitscan'] = not aimbot['hitscan']
end)
APred.MouseButton1Down:connect(function()
	aimbot['prediction'] = not aimbot['prediction']
end)
Draw.MouseButton1Down:connect(function()
	aimbot['draw'] = not aimbot['draw']
end)
xray.MouseButton1Down:connect(function()
	if not IsEnabled(xray) then
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA'BasePart' and not v.Parent:FindFirstChild'Humanoid' then
				v.Transparency = .5
			end
		end
	else
		for i,v in pairs(workspace:GetDescendants()) do
			if v:IsA'BasePart' and not v.Parent:FindFirstChild'Humanoid' then
				v.Transparency = 0
			end
		end
	end
end)

if game.PlaceId == 2765907688 then -- Heros Havoc
	spawn(function()
		local gs = {
			['auto'] = false,
			['collect'] = false,
			['esp'] = false
		}
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'Hero Havoc'
		gui.SetTitle(GameD,130)
		GameD.Text = '     Hero Havoc'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,80)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local mesp = Instance.new('TextLabel',back)
		mesp.Position = UDim2.new(0,0,0,20)
		mesp.Text = 'Mob Stats'
		gui.SetButton(mesp,130)
		local mespt = gui.Button(mesp)
		mespt.MouseButton1Down:connect(function()
			gs['esp'] = not gs['esp']
		end)
		local mauto = Instance.new('TextLabel',back)
		mauto.Position = UDim2.new(0,0,0,40)
		mauto.Text = 'Auto Attack'
		gui.SetButton(mauto,130)
		local mautot = gui.Button(mauto)
		mautot.MouseButton1Down:connect(function()
			gs['auto'] = not gs['auto']
		end)
		local mcol = Instance.new('TextLabel',back)
		mcol.Position = UDim2.new(0,0,0,60)
		mcol.Text = 'Auto Collect'
		gui.SetButton(mcol,130)
		local mmcolt = gui.Button(mcol)
		mautot.MouseButton1Down:connect(function()
			gs['collect'] = not gs['collect']
		end)
		base = [[
		  Name: nam
		  Level: laval
		  HP: heachp
		]]
		function SetBase(name,level,hp)
			local a = base
			local b = a:gsub('nam',name)
			local c = b:gsub('laval',level)
			local d = c:gsub('heachp',hp)
			return d
		end
		function Esp(Part)
			if gs['esp'] then
			local bill = Instance.new('BillboardGui',Part)
			bill.Size = UDim2.new(0,104,0,46)
			bill.AlwaysOnTop = true
			bill.Adornee = Part
			bill.Name = "Kike, Don't look at this :("
			local txt = Instance.new('TextLabel',bill)
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.TextColor3 = Color3.new(1,1,1)
			txt.TextSize = 9
			txt.TextXAlignment = 'Left'
			txt.TextYAlignment = 'Top'
			txt.Text = [[
		  Name: 
		  Level: 
		  HP: 
			]]
			txt.ZIndex = 2
			local round = Instance.new('ImageLabel',txt)
			round.Size = UDim2.new(1,0,1,0)
			round.BackgroundTransparency = 1
			round.Image = "rbxassetid://2851926732"
			round.ImageColor3 = Color3.fromRGB(44,44,44)
			round.ImageTransparency = 0.3
			round.ScaleType = 'Slice'
			round.SliceCenter = Rect.new(12,12,12,12)
			round.SliceScale = 1
			return txt
			end
		end
		BattleArea = game.Workspace.EnemyModels
		local AttackRemote = game.ReplicatedStorage.RemoteEvents.BattleEvents.BattleClick;
		function GetEnemies()
			if not game.ReplicatedStorage.PlayerFolder[game.Players.LocalPlayer.Name]:FindFirstChild'CurrentBattle' then
				return nil
			end
			local tbl = {}
			for i,v in pairs(game.ReplicatedStorage.PlayerFolder[game.Players.LocalPlayer.Name].CurrentBattle:GetChildren()) do
				if v.Name:lower():find'enemy' and v:WaitForChild'Health'.Value > 0 then
				if BattleArea:FindFirstChild(v.Name) then
					if gs['esp'] then
						local nigger = BattleArea:FindFirstChild(v.Name)
						if nigger:FindFirstChildWhichIsA("BasePart"):FindFirstChild"Kike, Don't look at this :(" then
							local nigger2 = nigger:FindFirstChildWhichIsA("BasePart"):FindFirstChild"Kike, Don't look at this :(" 
							nigger2.TextLabel.Text = SetBase(v.CharName.Value,v.Level.Value,v.Health.Value)
						else
							if nigger:FindFirstChildWhichIsA("BasePart") then
								local nigger2 = Esp(nigger:FindFirstChildWhichIsA("BasePart"))
								nigger2.Text = SetBase(v.CharName.Value,v.Level.Value,v.Health.Value)
							end
						end
					end	
				end
				table.insert(tbl,v)
				end
			end
			return tbl[1]
		end
		local function AttackEnemy()
			if BattleArea:FindFirstChild'SoulessKnowledge' then
				if GetEnemies() then
					AttackRemote:InvokeServer(GetEnemies())
				end
			end
		end
		
		local mouse = game:GetService'Players'.LocalPlayer:GetMouse()
		while wait() do 
			if gs['auto'] then
				AttackEnemy()
			end
			if gs['collect'] then
				if BattleArea:FindFirstChild'Drops' then 
					for i,v in pairs(BattleArea.Drops:GetChildren()) do 
						local part = v.PrimaryPart
						part.Position = mouse.Hit.p
					end
				end
			end
		end
	end)
elseif game.PlaceId == 550571085 then -- Deadmist
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'Deadmist 2'
		gui.SetTitle(GameD,130)
		GameD.Text = '     Deadmist'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,60)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local inp = Instance.new('TextBox',back)
		inp.Text = 'Type item then press space'
		inp.Position = UDim2.new(0,0,0,20)
		gui.SetButton(inp,130)
		local SpawnItem = function(ItemName)
		    local item;
		    for i,v in pairs(game.ReplicatedStorage.Game_Data:GetChildren()) do
		        if v.Name ~= 'Sounds' then
		            for _,k in pairs(v:GetChildren()) do
		                if k.Name:lower():find(ItemName) then
		                    item = k.Name
		                end
		            end
		        end
		    end
		    if item then
		        local Remote;
		        for i,v in pairs(workspace.Water:GetChildren()) do
		            if i == 29 then
		                Remote = v    
		            end
		        end
		        Remote:FireServer({item,100},game:GetService'Players'.LocalPlayer.Character.PrimaryPart.Position,game.Workspace.conf.Value)
		    end
		end
		inp.FocusLost:connect(function(enter)
			if enter then
				SpawnItem(inp.Text)
			end
		end)
		local remt = Instance.new('TextLabel',back)
		remt.Position = UDim2.new(0,0,0,40)
		gui.SetButton(remt,130)
		local button = gui.Button(remt)
		remt.Text = 'Remove Trees'
		button.MouseButton1Down:connect(function()
			for i,v in pairs(workspace.CHUNKS:GetChildren()) do 
				for _,k in pairs(v:GetChildren()) do 
					if k.Name == 'Trees' then 
						k:Destroy()
					end
		
				end
			end
			for i,v in pairs(workspace:GetChildren()) do 
				if v.Name == 'TreeHolder' then 
					v:Destroy()
				end
			end
		end)
elseif game.PlaceId == 2978696440 or game.PlaceId == 3165900886 then -- World Zero
	spawn(function()
		local gs = {
			['auto'] = false,
		}
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'World//Zero'
		gui.SetTitle(GameD,130)
		GameD.Text = '     World // Zero'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,100)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local auto = Instance.new('TextLabel',back)
		auto.Position = UDim2.new(0,0,0,20)
		auto.Text = 'Auto Attack'
		gui.SetButton(auto,130) 
		local ddicks = gui.Button(auto)
		ddicks.MouseButton1Down:connect(function()
			local mod = require(game.ReplicatedStorage.Shared.Combat)
			mod.RenderDamageNumber = function()
			end
			gs['auto'] = not gs['auto']
		end)
		function Attack(mob,pos)
			local args = {
				[1] = {
					[1] = mob,
				},
				[2] = {
					[1] = pos,
				},
				[3] = 'DualWield1'
			}
			local function atak(skil)
				args[3] = skil
				game.ReplicatedStorage.Shared.Combat.AttackTarget:FireServer(unpack(args))
			end
			for i=1,5 do
				atak('DualWield'..i)
				atak('WhirlwindSpin'..i)
			end
			atak('Leap1')
			atak('Leap2')
		end
			
		function GetTarget()
		    for i,v in pairs(workspace.Mobs:GetChildren()) do
		        if v:FindFirstChild'Model' and (v.Model.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < 25 and v.HealthProperties.Health.Value > 0 then
		            return v
		        end
		    end
		end
		spawn(function()
			while wait() do 
				if gs['auto'] then
					local mob = GetTarget()
					if mob then 
						Attack(mob,mob.Model.PrimaryPart.Position)
					end
				end
			end
		end)
		local trails = Instance.new('TextLabel',back)
		trails.Position = UDim2.new(0,0,0,40)
		gui.SetButton(trails,130)
		trails.Text = 'Weapon Trails'
		local trail = gui.Button(trails)
		gs['trails'] = false
		trail.MouseButton1Down:connect(function()
			gs['trails'] = not gs['trails']
			game.ReplicatedStorage.Shared.Combat['SetTrails']:FireServer(gs['trails'])
		end)
		local mana = Instance.new('TextLabel',back)
		mana.Position = UDim2.new(0,0,0,60)
		local chests = Instance.new('TextLabel',back)
		chests.Text = 'Open Chests'
		local chest = gui.Button(chests)
		chest.MouseButton1Down:connect(function()
			for i,v in pairs(workspace.ChestSpawns:GetChildren()) do 
				game.ReplicatedStorage.Shared.Chests['OpenChest']:InvokeServer(v)
			end
		end)
		chests.Position = UDim2.new(0,0,0,80)
		gui.SetButton(chests,130)
		gui.SetButton(mana,130)
		mana.Text = 'Inf mana'
		local manas = gui.Button(mana)
		manas.MouseButton1Down:connect(function()
			local mod = require(game.ReplicatedStorage.Shared.Mana)
			mod.ConsumeMP = function()
				return true
			end
			mod.GetMana = function()
				return 1000
			end
			game:GetService'RunService'.RenderStepped:connect(function()
				game.Players.LocalPlayer.Character.ManaProperties.MaxMana.Value = 1000
				game.Players.LocalPlayer.Character.ManaProperties.Mana.Value = 1000
				--print(game.Players.LocalPlayer.Character.ManaProperties.MaxMana.Value)
			end)
			end)
		end)
	
elseif game.PlaceId == 2295122555 then -- Project Jojo
	spawn(function()
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'Proj. JoJo'
		gui.SetTitle(GameD,130)
		GameD.Text = '     Project JoJo'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,40)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local kill = Instance.new('TextLabel',back)
		kill.Position = UDim2.new(0,0,0,20)
		kill.Text = 'Kill NPCs'
		gui.SetButton(kill,130)
		local toggle = gui.Button(kill)
		toggle.MouseButton1Down:connect(function()
			local function attack(plr)
				local part = plr:FindFirstChild'Head' or plr.PrimaryPart
				game:GetService("ReplicatedStorage").Logic.hitbox:InvokeServer(0, game.Players.LocalPlayer.Character["Right Arm"], part.CFrame, 2 * 9000, game.Players.LocalPlayer.Character.Torso.voiceline, plr.Humanoid)
			end
			
			for i,v in pairs(workspace:GetChildren()) do
				if v.Name:find'Dummy' then
					attack(v)
				end
			end
		end)
	end)
elseif game.PlaceId == 2969874963 then -- Paper Ball
	spawn(function()
		local gs = {
			['auto'] = false
		}
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'Paper Ball'
		gui.SetTitle(GameD,130)
		GameD.Text = '     Paper Ball Simulator'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,40)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local auto = Instance.new('TextLabel',back)
		auto.Position = UDim2.new(0,0,0,20)
		auto.Text = 'Auto Ball'
		gui.SetButton(auto,130)
		local tog = gui.Button(auto)
		tog.MouseButton1Down:connect(function()
			gs['auto'] = not gs['auto']
		end)
		function GetTool(plr)
			if plr.Character then
				for i,v in pairs(plr.Character:GetChildren()) do
					if v:IsA'Tool' or v.ClassName == 'Tool' then
						return v
					end
				end
			else
				return nil
			end
			return nil
		end
		spawn(function()
			while wait() do
				if gs['auto'] then
					local tbl_main = {
						Vector3.new(0,0,0),
						GetTool(Player)
					}
					game:GetService("ReplicatedStorage").Resources.RemoteEvents.FireEvent:FireServer(unpack(tbl_main))
				end
			end
		end)
	end)
elseif game.PlaceId == 2377868063 then -- strucid
	spawn(function()
		local gs = {
			['silent'] = false,
		}
		local GameD = Instance.new('TextButton',sg)
		GameD.Visible = false
		local close = gui.Button(GameD)
		CurGame.MouseButton1Down:connect(function()
			GameD.Visible = not GameD.Visible
		end)
		CurGame.Parent.Text = 'Strucid'
		gui.SetTitle(GameD,130)
		GameD.Text = '     Strucid'
		GameD.Position = UDim2.new(0,590,0.5,-50)
		local back = Instance.new('Frame',GameD)
		back.Size = UDim2.new(1,0,0,60)
		back.Visible = true
		back.BackgroundColor3=Color3.fromRGB(34, 34, 34)
		gui.Round(back)
		close.MouseButton1Down:connect(function()
			back.Visible = not back.Visible
		end)
		local sa = Instance.new('TextLabel',back)
		sa.Position = UDim2.new(0,0,0,20)
		gui.SetButton(sa,130)
		sa.Text = 'Silent Aim'
		local button = gui.Button(sa)
		button.MouseButton1Down:connect(function()
			gs['silent'] = not gs['silent']
		end)
		local sw = Instance.new('TextLabel',back)
		sw.Position = UDim2.new(0,0,0,40)
		gui.SetButton(sw,130)
		sw.Text = 'Delete Map'
		local button = gui.Button(sw)
		button.MouseButton1Down:connect(function()
			local map = {}
			local toggle = true
			for i,v in pairs(workspace.Map:GetChildren()) do 
			    if v.Name ~= 'Terrain' then 
			    v.Parent = game.Lighting    
			    table.insert(map,v)
			    end
			end
			for i,v in pairs(workspace.BuildStuff:GetChildren()) do 
			    v.Parent = game.Lighting    
			    table.insert(map,v)
			end
			function clear() 
			    for i,v in pairs(workspace.BuildStuff:GetChildren()) do 
			        v.Parent = game.Lighting    
			        table.insert(map,v)
			    end
			end
			workspace.BuildStuff.ChildAdded:connect(clear)
		end)
		local function IsVisible(Part)
		    if Part then
		        local ScreenPos = Camera:WorldToScreenPoint(Part.Position)
		        local unitRay = Camera:ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
		        local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
		        local Ignore = Player.Character:GetChildren()
		        for i,v in pairs(Camera:GetChildren()) do
		            table.insert(Ignore,v)
		        end
		        for i,v in pairs(Part.Parent:GetChildren()) do
		            if not v:IsA'BasePart' then
		                table.insert(Ignore,v)
		            end
		        end
		        for i,v in pairs(workspace.IgnoreThese:GetChildren()) do
		            table.insert(Ignore,v)
		        end
		        local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
		        local ShouldReturn
		        pcall(function()
		            ShouldReturn = (Hit:IsDescendantOf(Part.Parent))
		        end)
		        return (ShouldReturn or false)
		    end
		end
		
		local function GetDistAwayFromCursor(Part)
			if Part then
				local X = Mouse.X
				local Y = Mouse.Y
				local x = Camera:WorldToScreenPoint(Part.Position)
				return(math.abs(X-x.X + Y-x.Y))
			else
				return math.huge
			end
		end
		local lastpart;
		local function GetRandomPart(char)
		    local ran = {}
		    math.randomseed(os.time())
		    for i,v in pairs(char:GetChildren()) do
		        if v:IsA'BasePart' and v.Name ~= 'lastpart' then
		            if v.Name == 'Head' and lastpart ~= 'Head' then
		            end
					for i=1,10 do
		     	       table.insert(ran,v)
					end
		        end
		    end
			if #ran > 0 then
				math.randomseed(tick())
				local num = math.random(1,#ran)
				local a = ran[num]
				if a.Name == lastpart then
					math.randomseed(os.time())
					a = ran[math.random(1,#ran)]
				end
				lastpart = a.Name
				return a
			else 
				return nil
			end
			
		end
		function GetTarg()
			local thing = {}
			local thing2 = {}
			local typ = Player.PlayerGui.MenuGUI:WaitForChild'RoundInfoFrame':FindFirstChild'RoundType'
			if typ.Text == 'Dom' or typ.Text == 'TDM' or typ.Text == 'CTF' then
				gs['team'] = true
			else
				gs['team'] = false
			end
			for i,v in pairs(Players:GetChildren()) do
				if v.Character and v.Character:FindFirstChild'Humanoid' and v.Character.Humanoid.Health > 0 then
					if gs['team'] and v.Team ~= Player.Team then
						if IsVisible(GetRandomPart(v.Character)) then
							table.insert(thing2,GetRandomPart(v.Character))
							table.insert(thing,GetDistAwayFromCursor(GetRandomPart(v.Character)))
						end
					elseif not gs['team'] then
						if IsVisible(GetRandomPart(v.Character)) then
							table.insert(thing2,GetRandomPart(v.Character))
							table.insert(thing,GetDistAwayFromCursor(GetRandomPart(v.Character)))
						end
					end
				end	
			end
			if #thing > 0 then
				for i,v in pairs(thing) do
					if v == math.min(unpack(thing)) then
						return thing2[i].Position
					end
				end
			else
				return nil
			end
		end

		local COF = require(game.ReplicatedStorage.GlobalStuff)
		COF.ConeOfFire = function(Start, End, Inaccuracy)
		    local target = GetTarg()
		    if target then
		        return (target)
			else
		    	return (game.Players.LocalPlayer:GetMouse().Hit.p)
			end
		end
	end)
	
	
	
end


EspStart()

-- // Loops \\ --

game:GetService('RunService').RenderStepped:connect(function()
	ByFov()
	if Target then
		SetAim(Target)
	end
	local fovsize = (aimbot['fov']/180)
	if aimbot['draw'] then
		fovting.Size = UDim2.new(0,fovsize*Mouse.ViewSizeX,0,fovsize*Mouse.ViewSizeY)
	else
		fovting.Size = UDim2.new(0,0,0,0)
	end
	fovting.Position = UDim2.new(0.5,-fovsize*Mouse.ViewSizeX/2,.5,-fovsize*Mouse.ViewSizeY/2)
end)
spawn(function()
	while wait(1) do
		if update then
			Refresh()
			update=false
		end
	end
end)
local rainbow = 0
while wait() do
	--SetAim(game.Players.LocalPlayer.Character.Head)
	rainbow = rainbow + .01
	if rainbow > 1 then
		rainbow = 0
	end
	for i,v in pairs(hooked) do
		if v:IsA'SelectionBox' or v:IsA'BoxHandleAdornment' then
			v.Color3 = Color3.fromHSV(rainbow,1,1)
		end
	end
end
