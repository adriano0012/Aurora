repeat wait() until workspace.CurrentCamera
local Version = Instance.new('TextLabel',Instance.new('ScreenGui',game.CoreGui))
Version.TextColor3 = Color3.new(1,1,1)
Version.Size = UDim2.new(0,100,0,20)
Version.BackgroundTransparency = 1
Version.Text = 'Version 1.2.0'
Version.Position = UDim2.new(1,-100,1,-20)
local Discord = Instance.new('TextLabel',Instance.new('ScreenGui',game.CoreGui))
Discord.TextColor3 = Color3.new(1,1,1)
Discord.Size = UDim2.new(0,150,0,20)
Discord.BackgroundTransparency = 1
Discord.Text = 'discord.gg/Y2weDUr'
Discord.Position = UDim2.new(0,0,1,-20)
Discord.TextXAlignment = 'Left'
--[[local Metatable = getrawmetatable(game); -- getrawmetatable == getmetatable but bypasses the __metatable metamethod.
local OldNamecall = Metatable.__namecall; -- We have to store the old metamethod so we don't break any called functions (e.g :Destroy() would start throwing errors)

setreadonly(Metatable, false); -- Give our script read/write access to the metatable.

Metatable.__namecall = function(...) -- ... as a function argument basically means a function can be called with unlimited parameters.

local Table = {...};
local args = {...}
if args[#args] == 'Kick' or args[#args] == 'kick' then
	print'Attempted Kick'
	return false
else
	return OldNamecall(unpack(args))
end
end;--]]
function SendMessage(Text)
	game.StarterGui:SetCore("SendNotification", {
	Title = "Eski Menu"; -- the title (ofc)
	Text = Text; -- what the text says (ofc)
	Duration = 1; -- how long the notification should in secounds
	})
end

local AutoKey = false
--Login
local logedin = false
if not AutoKey then
	local zg = Instance.new('ScreenGui',game.CoreGui)
	local drg = Instance.new('TextButton',zg)
	drg.Size = UDim2.new(0,300,0,20)
	drg.Draggable = true
	drg.TextColor3 = Color3.new(1,1,1)
	drg.Text = 'Login for Eski Hub'
	drg.BackgroundColor3 = Color3.new(0,0.6,0.6)
	drg.BackgroundTransparency = .5
	drg.Position = UDim2.new(.5,-150,0.5,-100)
	local frm = Instance.new('Frame',drg)
	frm.Size = UDim2.new(1,0,0,100)
	frm.BackgroundTransparency = .6
	frm.BackgroundColor3 = Color3.new(0,0,0)
	frm.Position = UDim2.new(0,0,1,0)
	local ky = Instance.new('TextBox',frm)
	ky.Size = UDim2.new(.8,0,0,20)
	ky.Position = UDim2.new(.1,0,0,20)
	ky.BackgroundColor3 = Color3.new(.6,.6,.6)
	ky.BackgroundTransparency=0
	ky.Text = 'Key'
	ky.TextColor3 = Color3.new(1,1,1)
	local sve = Instance.new('TextButton',ky)
	sve.Text = 'Save Login'
	sve.Position = UDim2.new(0,0,1,0)
	sve.Size = UDim2.new(1,0,1,0)
	sve.BackgroundTransparency = 0
	sve.TextColor3 = Color3.new(1,1,1)
	sve.BackgroundColor3 = Color3.new(.3,.3,.3)
	sve.MouseButton1Down:connect(function()
		writefile('EskiKey','return "'..ky.Text..'"')
	end)
	local logn = Instance.new('TextButton',sve)
	logn.Size = UDim2.new(1,0,1,0)
	logn.Text = 'Login'
	logn.Position = UDim2.new(0,0,1,0)
	logn.BackgroundColor3 = Color3.new(.3,.3,.3)
	logn.TextColor3 = Color3.new(1,1,1)
	logn.MouseButton1Down:connect(function()
		logedin = loadstring(game:HttpGet('http://eskihosting.xyz/baxkup.php?KEY='..(tostring(ky.Text) or 'no key')..'&USER='..(game:GetService'Players'.LocalPlayer.Name or ' no user'),true))()
		if logedin == true then
			zg:Destroy()
		else
			SendMessage('Key not whitelisted.')
		end
	end)

end

repeat wait() until logedin == true

a = game:HttpGet("https://pastebin.com/raw/cjbNErPZ")

if not loadstring(a)() then
	while true do end
end

local sg2 = Instance.new('ScreenGui',game.CoreGui)
local DrwFov = Instance.new('Frame',sg2)
DrwFov.Size = UDim2.new(0,0,0)
DrwFov.Position= UDim2.new(0,0,0,0)
DrwFov.BackgroundTransparency = .7
DrwFov.BackgroundColor3 = Color3.new(1,0,0)

local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local Character = function()
	return (Player.Character or false)
end
local UIP = game:GetService('UserInputService')
local uip = UIP
local Mouse = Player:GetMouse()
local mouse = Mouse
local CoreGui = game:GetService('CoreGui')
local camera = workspace.CurrentCamera
local Camera = function()
	return camera
end
require = loadstring(game:GetObjects("rbxassetid://967517547")[1].Source)()
local module = require(03061695464)
local RunService = game:GetService('RunService')
local RS = RunService.RenderStepped
local RenderStepped = RS
local Target
local target
local UserSetting = UserSettings():GetService'UserGameSettings'
local MouseMoveEquiv
local MouseDownEquiv
local MouseUpEquiv
local engine;
local camera;
local network;
local char;
local MiningLoaded = false
local network

if leftpress then
	SendMessage('Script ajusted for SirHurt')
	MouseMoveEquiv = mousemoverel
	MouseDownEquiv = leftpress
	MouseUpEquiv = leftrelease
end

if mouse1press then
	SendMessage('Script ajusted for Synapse')
	if mousemoverel then
		MouseMoveEquiv = mousemoverel
	end
	MouseDownEquiv = mouse1press
	MouseUpEquiv = mouse1release
end
if PROTOSMASHER_LOADED then
	SendMessage('Script ajusted for Protosmasher')
	MouseMoveEquiv = Input.MoveMouse
	MouseDownEquiv = function()
		Input.LeftClick(MOUSE_DOWN)
	end
	MouseUpEquiv = function()
		Input.LeftClick(MOUSE_UP)
	end
end
if not MouseDownEquiv or not MouseDownEquiv or not MouseUpEquiv then
	SendMessage('Exploit not supported!')
	wait(1/0)
end

local Menu = module.MakeTab('Menu','Menu v1.0.4')
Menu.Visible = true
local Menu1 = module.MakeCheckButton('Aimbot Menu','Menu')
wait()
local Menu2 = module.MakeCheckButton('Esp Menu','Menu')
wait()
local Menu3 = module.MakeCheckButton('Phantom Menu','Menu')
wait()
local Menu4 = module.MakeCheckButton('Mining Simualator','Menu')
wait()
local Menu5 = module.MakeCheckButton('Jailbreak','Menu')
wait()
local Menu8 = module.MakeCheckButton('Mount of the Gods','Menu')
wait()
local Menu6 = module.MakeCheckButton('Anti-Aim','Menu')
wait()
local Menu7 = module.MakeCheckButton('Hub Settings','Menu')
wait()
local Menu9 = module.MakeCheckButton('Deadmist 2','Menu')
wait()
local Menu10 = module.MakeCheckButton('Strucid','Menu')

local AimbotMenu = module.MakeTab('Aimbot','Aimbot Settings')
AimbotMenu.ScrollingFrame.Position = UDim2.new(0,0,1,20)
local AimbotTarget = Instance.new('TextButton',AimbotMenu)
wait()
AimbotTarget.Size = UDim2.new(0.8,0,0,20)
AimbotTarget.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
AimbotTarget.TextColor3 = Color3.new(1,1,1)
AimbotTarget.Text = 'Fov'
AimbotTarget.Position = UDim2.new(.1,0,1,0)
AimbotTarget.BorderSizePixel = 0
local Left = Instance.new('TextButton',AimbotTarget)
Left.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
Left.Text = '<'
Left.BorderSizePixel = 0
Left.TextSize = 14
Left.TextColor3 = Color3.new(1,1,1)
Left.Size = UDim2.new(0,15,0,20)
Left.Position = UDim2.new(0,-15,0,0)
Left.MouseButton1Down:connect(function()
	local Options = {
		'Fov',
		'NextTarget',
		'Distance',
		'Roll'
	}
	

	local Previous = ''

	for i,v in pairs(Options) do
		if AimbotTarget.Text == v then
			if i == 1 then
				AimbotTarget.Text = Options[4]
				break
			else
				AimbotTarget.Text = Options[i-1]
			end
		end
	end
end)
local Right = Instance.new('TextButton',AimbotTarget)
Right.BackgroundColor3 = Color3.fromRGB(83, 83, 83)
Right.Text = '>'
Right.BorderSizePixel = 0
Right.TextSize = 14
Right.TextColor3 = Color3.new(1,1,1)
Right.Size = UDim2.new(0,15,0,20)
Right.Position = UDim2.new(1,0,0,0)
Right.MouseButton1Down:connect(function()
	local Options = {
		'Fov',
		'NextTarget',
		'Distance',
		'Roll'
	}
	
	local Next = false

	for i,v in pairs(Options) do
		if Next then
			AimbotTarget.Text = v
			Next = false
			break
		end
		if v == AimbotTarget.Text then
			if i == #Options then
				AimbotTarget.Text = Options[1]
			else
				Next = true
			end
		end
	end
end)
local AimbotEnabled = module.MakeCheckButton('Enabled','Aimbot')
wait()
local AimbotKey = module.MakeKeyBind('Aim Key','F','Aimbot')
wait()
local AimbotClick = module.MakeCheckButton('Right Click Aimbot','Aimbot')
wait()
local AimbotFov = module.MakeInputButton('Fov',40,'Aimbot')
wait()
local AimbotDraw = module.MakeCheckButton('Draw Fov','Aimbot')
wait()
local AimbotVisible = module.MakeCheckButton('Visible Only','Aimbot')
wait()
local AimbotFFA = module.MakeCheckButton('Free for All','Aimbot')
wait()
local AimbotWall = module.MakeCheckButton('Auto Wall','Aimbot')
wait()
local AimbotScan = module.MakeCheckButton('HitScan','Aimbot')
wait()
local AimbotTrigger = module.MakeCheckButton('AutoFire','Aimbot')
wait()
local AimbotSmooth = module.MakeInputButton('Smooth',0,'Aimbot')
wait()
local AimbotDrop = module.MakeInputButton('Bullet Drop',0,'Aimbot')
wait()
local AimbotTarg = module.MakeInputButton('Aim Part','Head','Aimbot')
wait()
local AimbotPred = module.MakeInputButton('Prediction',0,'Aimbot')
wait()






--Done VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
local EspMenu = module.MakeTab('Esp','Esp Settings')
wait()
local EspEnabled = module.MakeCheckButton('Enabled','Esp')
wait()
local EspFFA = module.MakeCheckButton('Free For All','Esp')
wait()
local EspHand = module.MakeCheckButton('Hand Chams','Esp')
wait()
local EspChams = module.MakeCheckButton('Player Chams','Esp')
wait()
local EspHitbox = module.MakeCheckButton('Player Hitbox','Esp')
wait()
local EspDynamic = module.MakeCheckButton('Dynamic Esp','Esp')
wait()
local EspName = module.MakeCheckButton('Player Name','Esp')
wait()
local EspTool = module.MakeCheckButton('Player Tool','Esp')
wait()
local EspHealth = module.MakeCheckButton('Player Health','Esp')
wait()
local EspDistance = module.MakeCheckButton('Player Distance','Esp')
wait()
local EspWait = module.MakeCheckButton('(lag) Wait/Stepped','Esp')
wait()


local PhantomMenu = module.MakeTab('PF','Phantom Forces')
wait()
local PFLoad = module.MakeCheckButton('Load Network','PF')
wait()
local PFAmmo = module.MakeCheckButton('Infinite Ammo','PF')
wait()
local PFRecoil = module.MakeCheckButton('No Recoil','PF')
wait()
local PFRate = module.MakeCheckButton('High Fire Rate','PF')
wait()
local PFReload = module.MakeCheckButton('Instant Reload','PF')
wait()

local MiningMenu = module.MakeTab('MS','Mining Simulator')
wait()
local MSLoad = module.MakeCheckButton('Load Network','MS')
wait()
local MSCrates = module.MakeCheckButton('Open Crates','MS')
wait()
local MSMine = module.MakeCheckButton('Instant Mine','MS')
wait()
local MSAuto = module.MakeCheckButton('Auto Mine','MS')
wait()
local MSBloc = module.MakeInputButton('Teleport To Block','','MS')
wait()
local MSSell = module.MakeCheckButton('Sell','MS')
wait()

local JailMenu = module.MakeTab('JB','Jailbreak',680)
wait()
local JailEsp = module.MakeCheckButton('Briefcase Esp','JB')
wait()


local AntiMenu = module.MakeTab('AA','Anti Aim',680)
wait()
local AntiRight = module.MakeCheckButton('Right','AA')
wait()
local AntiLeft = module.MakeCheckButton('Left','AA')
wait()
local AntiBack = module.MakeCheckButton('Backward','AA')
wait()
local AntiSpin = module.MakeCheckButton('Spinbot','AA')
wait()
local AntiRandom = module.MakeCheckButton('Random','AA')
wait()

local SettingsMenu = module.MakeTab('SS','Settings',680)
wait()
local SSKey = module.MakeKeyBind('Menu Key','E','SS')
wait()

local MountMenu = module.MakeTab('MM','Mount of the Gods',680)
wait()
local MountDestroy = module.MakeCheckButton('Destroy all Items','MM')
wait()
local MountKill = module.MakeInputButton('Kill Mob','','MM')
wait()
local MountSpawn = module.MakeInputButton('Spawn Item','','MM')
wait()
local MountMask = module.MakeInputButton('Set Mask','','MM')
wait()
local MountCrash = module.MakeCheckButton('Crash Server','MM')
wait()
local DeadMenu = module.MakeTab('DM','Deadmist 2',680)
wait()
local DeadSpawn = module.MakeInputButton("Spawn Item",'','DM')
wait()
local STMenu = module.MakeTab('ST','Strucid',680)
wait()
local STAcc = module.MakeCheckButton('No Recoil','ST')
wait()
local STUnlock = module.MakeCheckButton('Unlock All','ST')
wait()
local STSilent = module.MakeCheckButton('Silent Aim','ST')
wait()
local STRate = module.MakeCheckButton('Fire Rate','ST')
wait()



STRate.MouseButton1Down:connect(function()
	for i,v in pairs(game.ReplicatedStorage.Weapons.Modules:GetChildren()) do
		local gun = require(v)
		gun.Debounce = .1
	end
end)

STLoaded = false

local CanShoot = true
local WaitedST = 0
STSilent.MouseButton1Down:connect(function()
	if not STLoaded then
		STLoaded = true
		game:GetService("ReplicatedStorage")["AdminRE"]:ClearAllChildren()
		local module = require(game.ReplicatedStorage.NetworkModule)
		
		function GetFirstPlayer()
			local thing = {}
			for i,v in pairs(game:GetService'Players':GetChildren()) do
				if v.Character and v.Character:FindFirstChild'Head' and v.Character:FindFirstChild'Humanoid' then
					if v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 then
						table.insert(thing,v)
					end
				end
			end
			if #thing > 0 then
				return thing[math.random(1,#thing)]
			else
				return nil
			end
		end
		
		_fireclient = module.FireClient
			module.FireClient = function(Player,Action,...) 
			return _fireclient(Player,Action,...)
		end
		_fireserver = module.FireServer
			module.FireServer = function(Player,Action,...) 
			--[[print(Action)
			for i,v in pairs({...}) do 
				print(i,v)
			end--]]
			local a = {...}
			if Action == 'Damage' then 
				if game:GetService("ReplicatedStorage"):FindFirstChild"AdminRE" then
					game:GetService("ReplicatedStorage")["AdminRE"]:Destroy()
				end
				if GetFirstPlayer() and CanShoot then
					local plr = GetFirstPlayer()
					SendMessage('Sent SilentAim Shot at: '..plr.Name)
					CanShoot = false
					WaitedST = 0
					a[1],a[2] = (plr.Character.Humanoid or Instance.new('Part')),(plr.Character.Head or Instance.new('Part'))
					a[3],a[4] = (plr.Character.Head.Position or Vector3.new(0,0,0)),(plr.Character.Head.Position or Vector3.new(0,0,0))
				end
				for i,v in pairs(a) do 
					if type(v) == 'Part' then 
						print(i,v:GetFullName())
					else
						print(i,v)
					end
				end
				return _fireserver(Player,Action,unpack(a))
			end
		--	print(Player,Action)
			return _fireserver(Player,Action,unpack(a))
		end
		SendMessage('Im lazy, so you cant turn this off xd')
		SendMessage('Potential Ban!')
	end
end)

STAcc.MouseButton1Down:connect(function()
	for i,v in pairs(game.ReplicatedStorage.Weapons.Modules:GetChildren()) do
		local gun = require(v)
		gun.Recoil = 0
	end
	local moduleB = require(game.ReplicatedStorage.GlobalStuff)
	moduleB.ConeOfFire = function(Start, End, Inaccuracy)
		return game.Players.LocalPlayer:GetMouse().Hit.p
	end
end)

STUnlock.MouseButton1Down:connect(function()
	for i,v in pairs(game.ReplicatedStorage.Weapons.Modules:GetChildren()) do
		local gun = require(v)
		gun.Lvl = 1
		game:GetService("ReplicatedStorage")["AdminRE"]:ClearAllChildren()
		
	end
end)
--[[Animate
Reload
{}
1]]
local realremote;
DeadSpawn.TextBox.FocusLost:connect(function(EnterPressed)
	if EnterPressed then
		if not realremote then
			for i,v in pairs(workspace.Water:GetChildren()) do 
		       if v:IsA("RemoteEvent") and v.Name == "i" then
		          if i == 29 then 
		              realremote = v
		          end
		       end
		    end
		end
		local fressy = 100
  	  realremote:FireServer({DeadSpawn.TextBox.Text, fressy}, game:GetService("Players").LocalPlayer.Character["Left Leg"].Position, game.Workspace.conf.Value)
	end
end)

MountDestroy.MouseButton1Down:connect(function()
	wait()
	if MountDestroy.TextColor3 == Color3.new(0,1,0) then
		for i,v in pairs(game:GetService'Workspace'.Items:GetChildren()) do
			local tbl_main = 
			{
				  "Take", 
				  v
			}
			game:GetService("ReplicatedStorage").Resources.Remotes.InteractItem:FireServer(unpack(tbl_main))
	
		end
	end
end)
MountKill.TextBox.FocusLost:connect(function(EnterPressed)
	if EnterPressed then
		for i,v in pairs(workspace.Animals:GetChildren()) do
			if v.Name:lower():find(MountKill.TextBox.Text:lower()) then
				local tbl_main = 
				{
					  v, 
					  1/0
				}
				game:GetService("ReplicatedStorage").Resources.Remotes.DamageAnimal:FireServer(unpack(tbl_main))
				MountKill.TextBox.Text = ''
				SendMessage(v.Name..' Killed')
			end
		end
	end
end)
MountSpawn.TextBox.FocusLost:connect(function(EnterPressed)
	if EnterPressed then
		local tbl_main = 
		{
			  MountSpawn.TextBox.Text, 
			  game.Players.LocalPlayer.Character.Head.Position
		}
		game:GetService("ReplicatedStorage").Resources.Remotes.MakeItem:FireServer(unpack(tbl_main))
		MountSpawn.TextBox.Text = ''
		SendMessage('Item Spawned Attempted')
	end
end)
MountMask.TextBox.FocusLost:connect(function(EnterPressed)
	if EnterPressed then
		local Masks = game.ReplicatedStorage.Resources.Hats
		local tbl_main = 
		{
			  MountMask.TextBox.Text
		}
		game:GetService("ReplicatedStorage").Resources.Remotes.EquipMask:FireServer(unpack(tbl_main))
		MountMask.TextBox.Text = ''
		SendMessage('Mask Set')
	end
end)

function IsEnabled(ting)
	return ting.TextColor3 == Color3.new(0,1,0)
end
function IsOnScreen(part)
    local vector, onscreen = Camera():WorldToScreenPoint(part.Position)
    return(vector.Z > 0)
end
function Update()
	AimbotMenu.Visible = IsEnabled(Menu1)
	EspMenu.Visible = IsEnabled(Menu2)
	PhantomMenu.Visible = IsEnabled(Menu3)
	MiningMenu.Visible = IsEnabled(Menu4)
	JailMenu.Visible = IsEnabled(Menu5)
	AntiMenu.Visible = IsEnabled(Menu6)
	SettingsMenu.Visible = IsEnabled(Menu7)
	MountMenu.Visible = IsEnabled(Menu8)
	DeadMenu.Visible = IsEnabled(Menu9)
	STMenu.Visible = IsEnabled(Menu10)
end
local esp = {}
local Draw = {}
function GetTool(plr)
	if plr.Character then
		for i,v in pairs(plr.Character:GetChildren()) do
			if v:IsA'Tool' then
				return 'Tool: '..v.Name
			end
		end
	end
	return 'Tool: No Tool'
end
function UpdateEsp()
	if IsEnabled(EspEnabled) then
		for i,v in pairs(Players:GetChildren()) do
			pcall(function()
			if v.Character then
				if IsEnabled(EspFFA) then
					if IsEnabled(EspChams) then
						for i,k in pairs(v.Character:GetChildren()) do
							if k:IsA'BasePart' and not CoreGui:FindFirstChild(k:GetFullName()..'Cham') then
								local cham = Instance.new('BoxHandleAdornment',game:GetService'CoreGui')
								cham.Size = k.Size
								cham.Adornee = k
								cham.AlwaysOnTop = true
								cham.ZIndex = 10
								cham.Name = (k:GetFullName()..'Cham')
								cham.Transparency = .6
								cham.Color3 = Color3.new(1,1,1)
								table.insert(esp,cham)
							end
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'Cham' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspDynamic) then
						if v.Character:FindFirstChild'Head' and not CoreGui:FindFirstChild(v.Character.Head:GetFullName()..'Dynamic') then
							local bill = Instance.new('BillboardGui',CoreGui)
							bill.Name = v.Character.Head:GetFullName()..'Dynamic'
							bill.Size = UDim2.new(1,0,1,0)
							bill.Adornee = v.Character.Head
							bill.AlwaysOnTop = true
							local Frame = Instance.new('Frame',bill)
							Frame.Size = UDim2.new(5,0,6,0)
							Frame.Position = UDim2.new(-2,0,-.5,0)
							Frame.BackgroundTransparency = .5
							Frame.BackgroundColor3 = Color3.new(1,1,1)
							Frame.BorderColor3 = Color3.new(1,1,1)
							table.insert(esp,bill)
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'Dynamic' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspHitbox) then
						for i,v in pairs(v.Character:GetChildren()) do
							if v:IsA'BasePart' and not CoreGui:FindFirstChild(v:GetFullName()..'HitBox') then
								local cham = Instance.new('SelectionBox',game:GetService'CoreGui')
								cham.Adornee = v
								cham.Name = (v:GetFullName()..'HitBox')
								cham.Transparency = .7
								cham.Color3 = Color3.new(1,1,1)
								table.insert(esp,cham)
							end
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'HitBox' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspHealth) then
						if not Draw[v.Name..'Health'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = tostring(v.Character:FindFirstChild'Humanoid'.Health) or 'nil'
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Health'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Health']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+10)
									txt.Text = tostring(v.Character:FindFirstChild'Humanoid'.Health) or 'nil'
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Health'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Health'].Visible = false
						end
					end
					if IsEnabled(EspName) then
						if not Draw[v.Name..'Name'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = v.Name
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Name'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Name']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
									txt.Text = v.Name
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Name'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Name'].Visible = false
						end
					end
					if IsEnabled(EspTool) then
						if not Draw[v.Name..'Tool'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = GetTool(v)
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Tool'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Tool']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+30)
									txt.Text = GetTool(v)
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Tool'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Tool'].Visible = false
						end
					end
					if IsEnabled(EspDistance) and Character() then
						if not Draw[v.Name..'Dist'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = 'Distance: '.. math.floor((Character().PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude)
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Dist'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Dist']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+20)
									txt.Text = 'Distance: '.. math.floor((Character().PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude)
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Dist'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Dist'].Visible = false
						end
					end
					
					
					
					
					
					
					
					
					
					
					
					
				elseif not IsEnabled(EspFFA) and v.Team ~= Player.Team then
					if IsEnabled(EspChams) then
						for i,k in pairs(v.Character:GetChildren()) do
							if k:IsA'BasePart' and not CoreGui:FindFirstChild(k:GetFullName()..'Cham') then
								local cham = Instance.new('BoxHandleAdornment',CoreGui)
								cham.Size = k.Size
								cham.Adornee = k
								cham.AlwaysOnTop = true
								cham.ZIndex = 10
								cham.Name = (k:GetFullName()..'Cham')
								cham.Transparency = .6
								cham.Color3 = Color3.new(1,1,1)
								table.insert(esp,cham)
							end
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'Cham' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspDynamic) then
						if v.Character:FindFirstChild'Head' and not CoreGui:FindFirstChild(v.Character.Head:GetFullName()..'Dynamic') and v.Team ~= Player.Team then
							local bill = Instance.new('BillboardGui',CoreGui)
							bill.Name = v.Character.Head:GetFullName()..'Dynamic'
							bill.Size = UDim2.new(1,0,1,0)
							bill.Adornee = v.Character.Head
							bill.AlwaysOnTop = true
							local Frame = Instance.new('Frame',bill)
							Frame.Size = UDim2.new(5,0,6,0)
							Frame.Position = UDim2.new(-2,0,-.5,0)
							Frame.BackgroundTransparency = .5
							Frame.BackgroundColor3 = Color3.new(1,1,1)
							Frame.BorderColor3 = Color3.new(1,1,1)
							table.insert(esp,bill)
							
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'Dynamic' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspHitbox) then
						for i,v in pairs(v.Character:GetChildren()) do
							if v:IsA'BasePart' and not CoreGui:FindFirstChild(v:GetFullName()..'HitBox') then
								local cham = Instance.new('SelectionBox',game:GetService'CoreGui')
								cham.Adornee = v
								cham.Name = (v:GetFullName()..'HitBox')
								cham.Transparency = .7
								cham.Color3 = Color3.new(1,1,1)
								table.insert(esp,cham)
							end
						end
					else
						for i,v in pairs(CoreGui:GetChildren()) do
							if v.Name:find'HitBox' then
								v:Destroy()
							end
						end
					end
					if IsEnabled(EspHealth) then
						if not Draw[v.Name..'Health'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = tostring(v.Character:FindFirstChild'Humanoid'.Health) or 'nil'
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+10)
							Draw[v.Name..'Health'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Health']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+10)
									txt.Text = tostring(v.Character:FindFirstChild'Humanoid'.Health) or 'nil'
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Health'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Health'].Visible = false
						end
					end
					if IsEnabled(EspDistance) and Character() then
						if not Draw[v.Name..'Dist'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = 'Distance: '.. math.floor((Character().PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude)
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Dist'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Dist']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+20)
									txt.Text = 'Distance: '.. math.floor((Character().PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude)
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Dist'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Dist'].Visible = false
						end
					end
					if IsEnabled(EspName) then
						if not Draw[v.Name..'Name'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = v.Name
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Name'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Name']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
									txt.Text = v.Name
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Name'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Name'].Visible = false
						end
					end
					if IsEnabled(EspTool) then
						if not Draw[v.Name..'Name'] and IsOnScreen(v.Character.PrimaryPart) then
							local txt = Drawing.new('Text')
							txt.Size = 15
							txt.Text = GetTool(v)
							txt.Color = Color3.new(1,1,1)
							txt.Visible = true
							txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y)
							Draw[v.Name..'Tool'] = txt
						else
							pcall(function()
								local txt = Draw[v.Name..'Tool']
								if IsOnScreen(v.Character.PrimaryPart) then
									txt.Visible = true
									txt.Position = Vector2.new(workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).X+10,workspace.CurrentCamera:WorldToScreenPoint(v.Character.PrimaryPart.Position).Y+30)
									txt.Text = GetTool(v)
								else
									txt.Visible = false
								end
								
							end)
						end
					else
						if Draw[v.Name..'Tool'] and IsOnScreen(v.Character.PrimaryPart) then
							Draw[v.Name..'Tool'].Visible = false
						end
					end
					
					
					
					
					
					
					
					
					
				elseif not IsEnabled(EspFFA) and v.Team == Player.Team then
					if Draw[v.Name..'Health'] then
						Draw[v.Name..'Health'].Visible = false
					end
					if Draw[v.Name..'Dist'] then
						Draw[v.Name..'Dist'].Visible = false
					end
					if Draw[v.Name..'Name'] then
						Draw[v.Name..'Name'].Visible = false
					end
					if Draw[v.Name..'Tool'] then
						Draw[v.Name..'Tool'].Visible = false
					end
					for i,k in pairs(CoreGui:GetChildren()) do
						if k.Name:find(v.Name) then
							k:Destroy()
						end
					end
				end
			end
			
			end)
			end
	else
		for i,v in pairs(esp) do
			if type(v) == 'table' then
				v.Visible = false
			else
				v.Parent = nil
				v:Destroy()
			end
		end
		for i,v in pairs(Draw) do
			v.Visible = false
		end
		
	end
end
function IsInFov(Part)
	if IsOnScreen(Part) then
		local X = Mouse.X
		local Y = Mouse.Y
		local MinX = X-((tonumber(AimbotFov.TextBox.Text)or 40)/2)
		local MaxX = X+((tonumber(AimbotFov.TextBox.Text)or 40)/2)
		local MinY = Y-((tonumber(AimbotFov.TextBox.Text)or 40)/2)
		local MaxY = Y+((tonumber(AimbotFov.TextBox.Text)or 40)/2)
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
function GetDistAwayFromCursor(Part)
	local X = Mouse.X
	local Y = Mouse.Y
	local x = Camera():WorldToScreenPoint(Part.Position)
	return(X-x.X + Y-x.Y)
end
i = 0
function UpdateRgb()
	if i > 1 then
		i = 0
	end
	i = i + .01
	for k,v in pairs(CoreGui:GetChildren()) do
		if v.ClassName == 'BoxHandleAdornment' or v.ClassName == 'SelectionBox' then
			v.Color3 = Color3.fromHSV(i,1,1)
		elseif v.ClassName == 'BillboardGui' then
			v.Frame.BackgroundColor3 = Color3.fromHSV(i,1,1)
		end
	end
end
function CanAutoWall(Part) -- Pasted
	if Part then
		local targ = (Mouse.Target or Instance.new('Part',workspace))
		local ScreenPos = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
		local length = 3000
		local unitRay = Camera():ScreenPointToRay(ScreenPos.X, ScreenPos.Y)
		local ray = Ray.new(unitRay.Origin, unitRay.Direction * length)
		local Ignore = game.Players.LocalPlayer.Character:GetChildren()
		if targ.Name:find(Player.Name) or targ.Parent.Name:find(Player.Name) or targ.Parent.Parent.Name:find(Player.Name) or targ.Parent.Parent.Parent.Name:find(Player.Name) then
			for i,v in pairs(targ.Parent:GetChildren()) do
				table.insert(Ignore,v)
			end
			
		end
		for i,v in pairs(Camera():GetChildren()) do
			table.insert(Ignore,v)
		end
		local hit,pos,normal = workspace:FindPartOnRayWithIgnoreList(ray, Ignore)
		local a
		pcall(function()
			a = (hit == Part or hit.Parent == Part or hit.Parent == Part.Parent or hit.Parent.Parent == Part.Parent)
		end)
		if not a then
			table.insert(Ignore,hit)
			hit,pos,normal = workspace:FindPartOnRayWithIgnoreList(ray, Ignore)
			pcall(function()
				a = (hit == Part or hit.Parent == Part or hit.Parent == Part.Parent or hit.Parent.Parent == Part.Parent or hit.Parent.Parent.Parent == Part.Parent or hit.Parent.Parent.Parent.Parent == Part.Parent)
			end)
		end
		return(a or false)
	end
end
function IsVisible(Part) -- Pasted
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
			ShouldReturn = (Hit == Part or Hit.Parent.Name == Part.Parent.Name or Hit.Parent.Parent.Name == Part.Parent.Name or Hit.Parent.Parent.Parent.Name == Part.Parent.Name)
		end)
		return (ShouldReturn or false)
	end
end
function GetTarget(Player2) -- Pasted
	if IsEnabled(AimbotScan) then
		if Player2.Character then
			for i,v in pairs(Player2.Character:GetChildren()) do
				if v:IsA'BasePart' then
					if v.Name:lower():find(AimbotTarg.TextBox.Text:lower()) then
						if IsEnabled(AimbotVisible) then
							if IsVisible(v) then
								return v
							end
						end
						if IsEnabled(AimbotWall) then
							if CanAutoWall(v) then
								return v
							end
						end
						return v
					end
					if IsEnabled(AimbotVisible) then
						if IsVisible(v) then
							return v
						end
					end
					if IsEnabled(AimbotWall) then
						if CanAutoWall(v) then
							return v
						end
					end
					return v
				end
			end
		end
	else
		return Player2.Character:FindFirstChild(AimbotTarg.TextBox.Text)
	end
end
function GetTargetByFov()
	local dist = {}
	local pliar = {}
	if Target and not IsInFov(Target) then
		Target = nil
	end
	if not Target then
		for i,v in pairs(Players:GetChildren()) do
			if v.Character and GetTarget(v) and v~= Player and v.Character:FindFirstChild'Humanoid' and v.Character.Humanoid.Health > 0 then
				if IsInFov(GetTarget(v)) then
					if IsEnabled(AimbotWall) then
						if IsOnScreen(GetTarget(v)) then
							if not IsEnabled(AimbotFFA) then
								if v.Team ~= Player.Team and IsVisible(GetTarget(v)) and v.Character.Humanoid.Health > 0 then
									table.insert(pliar,v)
								else
									Target = nil
								end
							else
								table.insert(pliar,v)
							end
						end
					end
					if IsEnabled(AimbotVisible) then
						if not IsEnabled(AimbotFFA) then
							if v.Team ~= Player.Team and IsVisible(GetTarget(v)) and v.Character.Humanoid.Health > 0 then
								if IsOnScreen(GetTarget(v)) then
									table.insert(pliar,v)
								end
							else
								Target = nil
							end
						else
							if IsOnScreen(GetTarget(v)) then
								table.insert(pliar,v)
							end
						end
					else
						if not IsEnabled(AimbotFFA) then
							if v.Team ~= Player.Team and v.Character.Humanoid.Health > 0 then
								if IsOnScreen(GetTarget(v)) then
									table.insert(pliar,v)
								end
							else
								Target = nil
							end
						else
							if IsOnScreen(GetTarget(v)) then
								table.insert(pliar,v)
							else
								Target = nil
							end
						end
					end
				end
			end
		end
		for i,v in pairs(pliar) do
			if GetTarget(v) and v.Name ~= game.Players.LocalPlayer.Name then
				table.insert(dist, math.abs(GetDistAwayFromCursor(GetTarget(v))))
			end
		end
		for i,v in pairs(dist) do
			if v == math.min(unpack(dist)) then
				if IsEnabled(AimbotVisible) then
					if IsVisible(GetTarget(pliar[i])) then
						Target = GetTarget(pliar[i])
						return
					end
				elseif IsEnabled(AimbotWall) then
					if CanAutoWall(GetTarget(pliar[i])) then
						Target = GetTarget(pliar[i])
					else
						Target = nil
					end
				else
					Target = GetTarget(pliar[i])
					return
				end
			end
		end
	end
end
function ByDistance()
	local Distance = {}
	local Plrs = {}
	for i,v in pairs(Players:GetChildren()) do
		if not IsEnabled(AimbotFFA) and v.Team ~= Player.Team then
			if v ~= Player then
				table.insert(Plrs,v.Name)
				table.insert(Distance,(GetTarget(Player).Position - GetTarget(v).Position).Magnitude)
			end
		elseif not IsEnabled(AimbotFFA) then
			if v ~= Player then
				table.insert(Plrs,v.Name)
				table.insert(Distance,(GetTarget(Player).Position - GetTarget(v).Position).Magnitude)
			end
		end
	end
	for i,v in pairs(Distance) do
		if v == math.min(unpack(Distance)) then
			return Players[Plrs[i]]
		end
	end
end
function TargetByDistance()
	local Plr = ByDistance()
	if Plr.Character and GetTarget(Plr) then
		if IsEnabled(AimbotVisible) then
			if IsVisible(GetTarget(Plr)) and Plr.Character.Humanoid.Health > 0 then
				if IsOnScreen(GetTarget(Plr)) then
					Target = GetTarget(Plr)
				end
			else
				Target = nil
			end
		else
			if Plr.Character.Humanoid.Health > 0 then
				if IsOnScreen(GetTarget(Plr)) then
					Target = GetTarget(Plr)
				end
			end
		end
	end
end
function TargetByNextTarget()
	for i,v in pairs(Players:GetChildren()) do
		if v.Character and v.Character.Humanoid.Health > 0 then
			if not IsEnabled(AimbotFFA) then
				if not v.Team == Player.Team then
					if IsEnabled(AimbotVisible) then
						if IsVisible(GetTarget(v)) and IsOnScreen(GetTarget(v)) then
							Target = GetTarget(v)
						end
					else
						if IsEnabled(AimbotWall) then
							if CanAutoWall(GetTarget(v)) and IsOnScreen(GetTarget(v)) then
								Target = GetTarget(v)
							end
						else
							Target = GetTarget(v)
						end
					end
				end
			else
				if IsEnabled(AimbotVisible) then
					if IsVisible(GetTarget(v)) and IsOnScreen(GetTarget(v)) then
						Target = GetTarget(v)
					end
				else
					if IsEnabled(AimbotWall) then
						if CanAutoWall(GetTarget(v)) and IsOnScreen(GetTarget(v)) then
							Target = GetTarget(v)
						end
					else
						if IsOnScreen(GetTarget(v)) then
							Target = GetTarget(v)
						end
					end
				end
			end
		end
	end
end
function TargetByRoll()
	local function Roll(Table)
		return (Table[math.random(1,#Table)] or {})
	end
	
	if IsEnabled(AimbotVisible) then
		local tide = {}
		for i,v in pairs(Players:GetChildren()) do
			if IsVisible(GetTarget(v)) and v ~= Player then
				if not IsEnabled(AimbotFFA) and v.Team ~= Player.Team and v.Character.Humanoid.Health > 0 then
					table.insert(tide,v)
				elseif IsEnabled(AimbotFFA) and v.Character.Humanoid.Health > 0 then
					table.insert(tide,v)
				end
			end
		end
		local a = Roll(tide)
		Target = GetTarget(a) or nil
	else
		local tide = {}
		for i,v in pairs(Players:GetChildren()) do
			if v ~= Player and v.Character then
				if not IsEnabled(AimbotFFA) and v.Team ~= Player.Team and v.Character.Humanoid.Health > 0 then
					table.insert(tide,v)
				elseif not IsEnabled(AimbotFFA) and v.Character.Humanoid.Health > 0 then
					table.insert(tide,v)
				end
			end
		end
		
		local a = Roll(tide)
		Target = GetTarget(a) or nil
	end
end
function ShouldAim()
	if Target then
		if not IsOnScreen(Target) then
			Target = nil
		end
		if IsEnabled(AimbotVisible) then
			if not IsVisible(Target) then
				Target = nil
			end
		end
		if IsEnabled(AimbotWall) then
			if not CanAutoWall(Target) then
				Target = nil
			end
		end
	end
	if AimbotTarget.Text == 'Fov' then
		GetTargetByFov()
	end
	if AimbotTarget.Text == 'ByDistance' then
		TargetByDistance()
	end
	if AimbotTarget.Text == 'Roll' then
		TargetByRoll()
	end
	if AimbotTarget.Text == 'NextTarget' then
		TargetByNextTarget()
	end
end
function SetAim(ppart)-- offset y 3
	if ppart then
		local smooth = (tonumber(AimbotSmooth.TextBox.Text)+1 or 1)
		local dist = (GetTarget(Player).Position - ppart.Position).Magnitude
		local AimPos = Camera():WorldToScreenPoint((ppart.Position+(ppart.Velocity*((tonumber(AimbotPred.TextBox.Text) or 0)* (dist/100))))+Vector3.new(0,dist/(100/(tonumber(AimbotDrop.TextBox.Text)or 0)),0))
		local Base = Vector2.new(((AimPos.X-Mouse.X)/2),((AimPos.Y-Mouse.Y)/2))
		local moveto
		local Modifier = ((UserSetting.MouseSensitivity*2))
		
		if (Camera().focus.p - Camera().CoordinateFrame.p).magnitude >= 1 then
			moveto = Vector2.new(Base.X,Base.Y)
		else
			moveto = ((Base)/Modifier)
		end
		MouseMoveEquiv(moveto.X/smooth,moveto.Y/smooth)
	end
end
function AntiAimOptions()
	if IsEnabled(AntiSpin)  then
		local Char = Character()
		Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame*CFrame.Angles(0,.5,0)
	end
	if IsEnabled(AntiLeft) then
		local Char = Character()
		Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame*CFrame.Angles(0,-5,0)
	
	end
	if IsEnabled(AntiRight) then
		local Char = Character()
		Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame*CFrame.Angles(0,5,0)
	
	end
	if IsEnabled(AntiBack) then
		local Char = Character()
		Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame*CFrame.Angles(0,9.5,0)
	end
	if IsEnabled(AntiRandom) then
		local Char = Character()
		Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame*CFrame.Angles(0,math.random(-18,18),0)
	end
end
local AimbotWaiting = false
local MenuWaiting = false
SSKey.MouseButton1Down:connect(function()
	MenuWaiting = true
end)
AimbotKey.MouseButton1Down:connect(function()
	AimbotWaiting = true
end)
local waited = false
local MenuClosed
UIP.InputBegan:connect(function(key)
	if AimbotWaiting then
		if not waited then
			wait(.5)
			waited = true
			return
		end
		waited = false
		AimbotWaiting = false
		AimbotKey.Text = tostring(key.KeyCode)
		print('set key 1:'..AimbotKey.Text)
	end
	if MenuWaiting then
		if not waited then
			wait(.5)
			waited = true
			return
		end
		waited = false
		MenuWaiting = false
		SSKey.Text = tostring(key.KeyCode)
		print('set key 2:'..SSKey.Text)
	end
	if tostring(key.KeyCode) == AimbotKey.Text then
		if AimbotEnabled.TextColor3 == Color3.new(0,1,0) then
			AimbotEnabled.TextColor3 = Color3.new(1,1,1)
		else
			AimbotEnabled.TextColor3 = Color3.new(0,1,0)
		end
	end
	if tostring(key.KeyCode) == SSKey.Text then
		if MenuClosed then
			Menu1.TextColor3 = Color3.new(1,1,1)
			Menu2.TextColor3 = Color3.new(1,1,1)
			Menu3.TextColor3 = Color3.new(1,1,1)
			Menu4.TextColor3 = Color3.new(1,1,1)
			Menu5.TextColor3 = Color3.new(1,1,1)
			Menu6.TextColor3 = Color3.new(1,1,1)
			Menu7.TextColor3 = Color3.new(1,1,1)
			Menu8.TextColor3 = Color3.new(1,1,1)
			Menu9.TextColor3 = Color3.new(1,1,1)
			Menu10.TextColor3 = Color3.new(1,1,1)
			MenuClosed = false
		else
			Menu1.TextColor3 = Color3.new(0,1,0)
			Menu2.TextColor3 = Color3.new(0,1,0)
			Menu3.TextColor3 = Color3.new(0,1,0)
			Menu4.TextColor3 = Color3.new(0,1,0)
			Menu5.TextColor3 = Color3.new(0,1,0)
			Menu6.TextColor3 = Color3.new(0,1,0)
			Menu7.TextColor3 = Color3.new(0,1,0)
			Menu8.TextColor3 = Color3.new(0,1,0)
			Menu9.TextColor3 = Color3.new(0,1,0)
			Menu10.TextColor3 = Color3.new(0,1,0)
			MenuClosed = true
		end
		
	end
end)
Mouse.Button2Down:connect(function()
	if IsEnabled(AimbotClick) then
		AimbotEnabled.TextColor3 = Color3.new(0,1,0)
	end
end)
Mouse.Button2Up:connect(function()
	if IsEnabled(AimbotClick) then
		AimbotEnabled.TextColor3 = Color3.new(1,1,1)
	end
end)
MSLoad.MouseButton1Down:connect(function()
	if not MiningLoaded then
		SendMessage('Mining Simulator Network Loaded!')
		MiningLoaded = true
		network = { cache = {} }
function network:Initialize()
    local id = 0
    local runs = 0
    function key()
        id = id + 1
        if id > 100 then
            id = 0
        end
        return 2654 * (id * 3)
    end
    function network.new()
        local remote, func = game.ReplicatedStorage.Network:InvokeServer()
        runs = runs + 1
        if runs >= 2 then
            self:FireServer("KickSelf", "Bypassing Network")
        end
        network.RemoteEvent = remote
        network.RemoteFunction = func
    end
    network.new()
    function network:Cache(name, func)
        if not self.cache[name] then
            self.cache[name] = func
        else
            warn("Function '" .. name .. "' has previous cache.")
        end
    end
    function network:Function(name, ...)
        if not network.init then
            repeat
                wait(0.25)
            until network.init
        end
        if not self.cache[name] then
            warn("Function " .. name .. " has not been cached yet")
        else
            return self.cache[name](...)
        end
    end
    function network:FireServer(name, ...)
        self.RemoteEvent:FireServer(name, {
            {
                ...
            }
        }, key())
    end
    function network:InvokeServer(name, ...)
        return self.RemoteFunction:InvokeServer(name, {
            {
                ...
            }
        }, key())
    end
    function self.RemoteFunction.OnClientInvoke(...)
        return self:Function(...)
    end
    self.RemoteEvent.OnClientEvent:connect(function(...)
        self:Function(...)
    end)
    network.init = true
end
network:Initialize()
function network:FireServer(name, ...)
    self.RemoteEvent:FireServer(name, {
        {
            ...
        }
    }, key())
end
	end
end)
function teleportToSell()
	local player = Player
	PlaceTeleport(Character().HumanoidRootPart)
    wait(1)
    local zone
    if player.Character.HumanoidRootPart.Position.Z > game.Workspace.BeachPosition.Value.Z then
        network:FireServer("MoveTo", "BeachSell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.SeaPosition.Value.Z then
        network:FireServer("MoveTo", "SeaSell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.DinoPosition.Value.Z then
        network:FireServer("MoveTo", "DinoSell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.FoodPosition.Value.Z then
        network:FireServer("MoveTo", "FoodSell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.ToyPosition.Value.Z then
        network:FireServer("MoveTo", "ToySell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.CandyPosition.Value.Z then
        zone = "Candy"
        network:FireServer("MoveTo", "CandySell")
    elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.SpacePosition.Value.Z then
        zone = "Space"
        network:FireServer("MoveTo", "SpaceSell")
    else
        zone = "Earth"
        network:FireServer("MoveTo", "SellSpawn")
    end
    wait(2)
	TeleportToPad()
end
function isnil(ting)
    return ting == nil
end
function findFirstParent(obj, parent)
    local function find(current)
        if not isnil(current) and current.Parent == parent then
            return current
        elseif not isnil(current) and current.Parent == game then
            return nil
        elseif not isnil(current) then
            return find(current.Parent)
        end
    end
    return find(obj)
end
function MineBlock()
    local targ
	local mouse = Mouse
	targ = mouse.Target
	if (mouse.Target.Position - Character().Head.Position).Magnitude <= 20 then
       local IsBlock = findFirstParent(targ, game.Workspace.Blocks)
       if IsBlock then
           network:FireServer('MineBlock',IsBlock)
       end
	end
end
function RemovePad()
    network:FireServer("RemovePad")
end
function GetShit()
    local coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack = network:InvokeServer("GetStats")
    return {coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack}
end
function OpenCrates()
    if IsEnabled(MSCrates) then
        local a = {}
        for i,v in pairs(GetShit()[10]) do
            local crate,num = v[1],v[2]
            for i=1,num do
                if IsEnabled(MSCrates) then
                    network:FireServer('SpinCrate',crate)
              		wait(1)
                end
            end
        end
    else
        return nil
    end
end
function TeleporterDown()
    if Character().Parent:FindFirstChild(Player.Name..'Teleporter',true) then
        return true
    else
        return false
    end
end
function PlaceTeleport(item)
    if TeleporterDown() then
        RemovePad()
        wait(0.1)
        Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    else
        Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    end
   
    Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
end
function TeleportToPad()
    wait(1)
    network:FireServer("TeleportToPad")
end
function TpToBlock(block)
    local isBlock = workspace.Blocks:FindFirstChild(block, true)
	if not isBlock then
		SendMessage('Ore not found')
		return
	end
    local primary = isBlock.PrimaryPart
   
    if primary then
        PlaceTeleport(primary)
        wait(0.5)
        TeleportToPad()
    end
	wait(.5)
	RemovePad()
end
MSBloc.TextBox.FocusLost:connect(function(enterPressed)
	if enterPressed and MiningLoaded then
		TpToBlock(MSBloc.Text)
	else
		SendMessage('Please load network')
	end
end)
MSSell.MouseButton1Down:connect(function()
	if MiningLoaded then
		teleportToSell()
	else
		SendMessage('Please load network')
	end
end)
Mouse.Button1Down:connect(function()
	if MiningLoaded and IsEnabled(MSMine) then
		MineBlock()
	elseif IsEnabled(MSMine) and not MiningLoaded then
		SendMessage('Please load network')
	end
end)
MSCrates.MouseButton1Down:connect(function()
	wait()
	if MiningLoaded and IsEnabled(MSCrates) then
		SendMessage('Opening Crates')
		OpenCrates()
	end
end)
local PhantomForces = {
	false,
	false,
	false,
	false
}
PFLoad.MouseButton1Down:connect(function()
	if not char then
		while (not engine) and (not network) do
		    for _, F in next, getreg() do
		        if type(F) == 'function' then
		            if not (engine) then
		                engine = debug.getupvalue(F, 'engine');
		            end
		            if not(network) then 
		                network = debug.getupvalue(F, 'network')
		            end
		            if not(camera) then
		                camera = debug.getupvalue(F, 'camera');
		            end
					if not(char) then
						char = debug.getupvalue(F,'char');
					else
						
					end
		        end;
		        if (engine) and (camera) then
		            break;
		        end;
		    end;
		    wait();
		end;
		repeat wait() until char
		SendMessage('Network Loaded')
		_loadgun = char.loadgun
			char.loadgun = function(...)
			local args = {...}
			local gundata = args[2]
			if gundata.MaxMag then print"gundata.MaxMag" end
			gundata.range = 3000
			for i,v in pairs(gundata) do
				print(i..' : '..tostring(v))
			end
			if PhantomForces[1] then
				--gundata.magsize = math.huge
				gundata.sparerounds = 13337
			end
			if PhantomForces[2] then
				local V3 = Vector3.new(0,0,0)
				gundata.camkickmin = V3
				gundata.camkickmax = V3
				gundata.aimcamkickmin = V3
				gundata.aimcamkickmax = V3
				gundata.aimtranskickmin = V3
				gundata.aimtranskickmax = V3
				gundata.transkickmin = V3
				gundata.transkickmax = V3
				gundata.rotkickmin = V3
				gundata.rotkickmax = V3
				gundata.aimrotkickmin = V3
				gundata.aimrotkickmax = V3
				gundata.camkickmin = V3
				gundata.camkickmax = V3
				gundata.aimcamkickmin = V3
				gundata.aimcamkickmax = V3
				gundata.aimtranskickmin = V3
				gundata.aimtranskickmax = V3
				gundata.transkickmin = V3
				gundata.transkickmax = V3
				gundata.rotkickmin = V3
				gundata.rotkickmax = V3
				gundata.aimrotkickmin = V3
				gundata.aimrotkickmax = V3
				gundata.swayamp = 0
				gundata.swayspeed = 0
				gundata.steadyspeed = 0
				gundata.breathspeed = 0
				gundata.hipfirespreadrecover = 100
				gundata.hipfirespread = 0
				gundata.hipfirestability = 0
				gundata.crosssize = 2
				gundata.crossexpansion = 0
			end
			if PhantomForces[3] then
				gundata.firerate = 3500
				gundata.variablefirerate = false
				gundata.firemodes = {true, 3, 1}
				gundata.requirechamber = false
			end
			if PhantomForces[4] then
				for i,v in pairs(gundata.animations) do
					v.timescale = .01
				end
			end
			args[2] = gundata
			return _loadgun(...)
		end
		
	end
end)

local MouseDown = false
function AutoShoot()
	if Target then
		MouseDownEquiv()
		MouseDown = true
	end
end
RS:connect(function()
	if IsEnabled(AimbotEnabled) then
		ShouldAim()
	else
		Target = nil
	end
	if Target then
		SetAim(Target)
	end
	if IsEnabled(MountCrash) then
		local tbl_main = 
		{
			  'Large Log', 
			  game.Players.LocalPlayer.Character.Head.Position
		}
		game:GetService("ReplicatedStorage").Resources.Remotes.MakeItem:FireServer(unpack(tbl_main))
	end
	PhantomForces[1] = IsEnabled(PFAmmo)
	PhantomForces[2] = IsEnabled(PFRecoil)
	PhantomForces[3] = IsEnabled(PFRate)
	PhantomForces[4] = IsEnabled(PFReload)
	if IsEnabled(MSAuto) then
		MineBlock()
	end
	if IsEnabled(AimbotDraw) then
		DrwFov.Size = UDim2.new(0,(tonumber(AimbotFov.TextBox.Text) or 0),0,(tonumber(AimbotFov.TextBox.Text) or 0))
		DrwFov.Position = UDim2.new(0,Mouse.X-(tonumber(AimbotFov.TextBox.Text) or 0)/2,0,Mouse.Y-(tonumber(AimbotFov.TextBox.Text) or 0)/2)
	else
		DrwFov.Size = UDim2.new(0,0,0,0)
	end
	AntiAimOptions()
	if IsEnabled(EspWait) then
		UpdateEsp()
	end
	UpdateRgb()
	Update()
	if MouseDown then
		MouseUpEquiv()
		MouseDown = false
	end
	if IsEnabled(AimbotTrigger) then
		AutoShoot()
	end
end)
while wait() do
	if not CanShoot then
		WaitedST = WaitedST + 1
		if WaitedST > 120 then
			CanShoot = true
			WaitedST = false
			SendMessage('Can Shoot')
		end
	end
	if not IsEnabled(EspWait) then
		UpdateEsp()
	end
end
