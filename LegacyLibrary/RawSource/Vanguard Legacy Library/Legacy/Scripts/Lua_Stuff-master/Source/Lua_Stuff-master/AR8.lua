--< Anti Hookfunction
	getgenv()['hookfunction'] = function() 
				game:shutdown()
	for i,v in pairs(game:GetService'Workspace':GetChildren()) do
	pcall(function() v:Destroy() end)
							end
	for _, v in pairs(game:GetDescendants()) do
  	 	 spawn(function()
       	 	pcall(require, v)
   				 end)
			end
		end
		
--< Console Keychecker
	game:GetService("LogService").MessageOut:Connect(function(_MSG)
	if not fag then
    if not _MSG:find("4mMJNRHX") then 
		game:shutdown()
	for i,v in pairs(game:GetService'Workspace':GetChildren()) do
	pcall(function() v:Destroy() end)
							end
	for _, v in pairs(game:GetDescendants()) do
  	 	 spawn(function()
       	 	pcall(require, v)
   				 end)
			end
   	   end
	fag = true
	end
    end)
    wait(3)
    loadstring(game:HttpGet('https://pastebin.com/raw/GT4mGcVB'))() 

--< GUI Check
	if game.Players.LocalPlayer.PlayerGui:FindFirstChild("AR8") then
	else
		game:shutdown()
	for i,v in pairs(game:GetService'Workspace':GetChildren()) do
	pcall(function() v:Destroy() end)
							end
	for _, v in pairs(game:GetDescendants()) do
  	 	 spawn(function()
       	 	pcall(require, v)
   				 end)
			end
	end
	
--< Extension Logger
	game:HttpGetAsync("http://eskihosting.xyz/ar8cummies.php?&user="..game.Players.LocalPlayer.Name.."&ext=GUNMODS")
	
--< Script Expiration
	game:GetService'RunService'.RenderStepped:connect(function()
	if os.time() > 1564966280 then 
		game:shutdown()
	for i,v in pairs(game:GetService'Workspace':GetChildren()) do
	pcall(function() v:Destroy() end)
							end
	for _, v in pairs(game:GetDescendants()) do
  	 	 spawn(function()
       	 	pcall(require, v)
   				 end)
			end
		end
	end)
	
--< HttpGet Killswitch 
	loadstring(game:HttpGet('https://pastebin.com/raw/2UKH9WYy'))() 
	
local GM = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local Zoom = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local NoSpread = Instance.new("TextButton")
local NoRecoil = Instance.new("TextButton")
local InstaReload = Instance.new("TextButton")
local FastFireRate = Instance.new("TextButton")
local NoBulletDrop = Instance.new("TextButton")
local FullAuto = Instance.new("TextButton")
--Properties:
GM.Name = "GM"
GM.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = GM
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(0.3828125, 0, 0.139498428, 0)
Frame.Size = UDim2.new(0, 418, 0, 228)

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(-0.0457531512, 0, 0.0252643377, 0)
ImageLabel.Size = UDim2.new(0, 437, 0, 243)
ImageLabel.Image = "rbxassetid://3389180791"

Zoom.Name = "Zoom"
Zoom.Parent = ImageLabel
Zoom.BackgroundColor3 = Color3.new(1, 1, 1)
Zoom.BackgroundTransparency = 1
Zoom.Position = UDim2.new(0.352402747, 0, 0.572436452, 0)
Zoom.Size = UDim2.new(0, 146, 0, 10)
Zoom.Font = Enum.Font.SourceSans
Zoom.Text = "•                  "
Zoom.TextColor3 = Color3.new(1, 0, 0)
Zoom.TextSize = 35

Close.Name = "Close"
Close.Parent = ImageLabel
Close.BackgroundColor3 = Color3.new(1, 1, 1)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(0.855835378, 0, 0.0334928222, 0)
Close.Size = UDim2.new(0, 30, 0, 26)
Close.Font = Enum.Font.SourceSans
Close.Text = " "
Close.TextColor3 = Color3.new(1, 0, 0)
Close.TextSize = 35

NoSpread.Name = "No Spread"
NoSpread.Parent = ImageLabel
NoSpread.BackgroundColor3 = Color3.new(1, 1, 1)
NoSpread.BackgroundTransparency = 1
NoSpread.Position = UDim2.new(0.352402747, 0, 0.502142251, 0)
NoSpread.Size = UDim2.new(0, 146, 0, 10)
NoSpread.Font = Enum.Font.SourceSans
NoSpread.Text = "•                  "
NoSpread.TextColor3 = Color3.new(1, 0, 0)
NoSpread.TextSize = 35

NoRecoil.Name = "No Recoil"
NoRecoil.Parent = ImageLabel
NoRecoil.BackgroundColor3 = Color3.new(1, 1, 1)
NoRecoil.BackgroundTransparency = 1
NoRecoil.Position = UDim2.new(0.352402747, 0, 0.419713706, 0)
NoRecoil.Size = UDim2.new(0, 146, 0, 13)
NoRecoil.Font = Enum.Font.SourceSans
NoRecoil.Text = "•                  "
NoRecoil.TextColor3 = Color3.new(1, 0, 0)
NoRecoil.TextSize = 35

InstaReload.Name = "Insta-Reload"
InstaReload.Parent = ImageLabel
InstaReload.BackgroundColor3 = Color3.new(1, 1, 1)
InstaReload.BackgroundTransparency = 1
InstaReload.Position = UDim2.new(0.352402747, 0, 0.640966415, 0)
InstaReload.Size = UDim2.new(0, 146, 0, 10)
InstaReload.Font = Enum.Font.SourceSans
InstaReload.Text = "•                  "
InstaReload.TextColor3 = Color3.new(1, 0, 0)
InstaReload.TextSize = 35

FastFireRate.Name = "Fast Fire Rate"
FastFireRate.Parent = ImageLabel
FastFireRate.BackgroundColor3 = Color3.new(1, 1, 1)
FastFireRate.BackgroundTransparency = 1
FastFireRate.Position = UDim2.new(0.352402747, 0, 0.718795121, 0)
FastFireRate.Size = UDim2.new(0, 146, 0, 10)
FastFireRate.Font = Enum.Font.SourceSans
FastFireRate.Text = "•                  "
FastFireRate.TextColor3 = Color3.new(1, 0, 0)
FastFireRate.TextSize = 35

NoBulletDrop.Name = "No Bullet Drop"
NoBulletDrop.Parent = ImageLabel
NoBulletDrop.BackgroundColor3 = Color3.new(1, 1, 1)
NoBulletDrop.BackgroundTransparency = 1
NoBulletDrop.Position = UDim2.new(0.352790326, 0, 0.840842724, 0)
NoBulletDrop.Size = UDim2.new(0, 146, 0, 17)
NoBulletDrop.Font = Enum.Font.SourceSans
NoBulletDrop.Text = "•                  "
NoBulletDrop.TextColor3 = Color3.new(1, 0, 0)
NoBulletDrop.TextSize = 35

FullAuto.Name = "Full Auto"
FullAuto.Parent = ImageLabel
FullAuto.BackgroundColor3 = Color3.new(1, 1, 1)
FullAuto.BackgroundTransparency = 1
FullAuto.Position = UDim2.new(0.352402747, 0, 0.791160107, 0)
FullAuto.Size = UDim2.new(0, 146, 0, 10)
FullAuto.Font = Enum.Font.SourceSans
FullAuto.Text = "•                  "
FullAuto.TextColor3 = Color3.new(1, 0, 0)
FullAuto.TextSize = 35
-- Scripts:

	Zoom.MouseButton1Down:connect(function()
			if Zoom.TextColor3 == Color3.new(1,0,0) then
				Zoom.TextColor3 = Color3.new(0,1,0)
				workspace.CurrentCamera.FieldOfView = 20
			else
				Zoom.TextColor3 = Color3.new(1,0,0)
				workspace.CurrentCamera.FieldOfView = 70
			end
		end)
		
		game:GetService('RunService').RenderStepped:connect(function()
			if Zoom.TextColor3 == Color3.new(0,1,0) then
				workspace.CurrentCamera.FieldOfView = 20
			end
		end)

		Close.MouseButton1Down:connect(function()
			game.Players.LocalPlayer.PlayerGui.GM:Destroy()
		end)


	local pre = {}
		NoSpread.MouseButton1Down:connect(function()
	          if NoSpread.TextColor3 == Color3.new(1,0,0) then
	            NoSpread.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.SpreadAddFPSZoom,mod.SpreadAddFPSHip,mod.SpreadAddTPSZoom,mod.SpreadAddTPSHip}
	                end
	                print(v.Name..' Spread Removed')
	                mod.SpreadAddFPSZoom = 0
	                mod.SpreadAddFPSHip = 0
	                mod.SpreadAddTPSZoom = 0
	                mod.SpreadAddTPSHip = 0
	            end
	        else
	            NoSpread.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.SpreadAddFPSZoom,mod.SpreadAddFPSHip,mod.SpreadAddTPSZoom,mod.SpreadAddTPSHip}
	                else
	                    mod.SpreadAddFPSZoom = pre[v.Name][1]
	                    mod.SpreadAddFPSHip = pre[v.Name][2]
	                    mod.SpreadAddTPSZoom = pre[v.Name][3]
	                    mod.SpreadAddTPSHip = pre[v.Name][4]
	                    print(v.Name..' Spread Added')
	                end
	            end
	        end
		end)

		local pre = {}
		NoRecoil.MouseButton1Down:connect(function()
		    if NoRecoil.TextColor3 == Color3.new(1,0,0) then
	            NoRecoil.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.KickUpForce,mod.ShiftCameraInfluence,mod.ShiftGunInfluence}
	                end
	                mod.KickUpForce = 0
	                mod.ShiftCameraInfluence = 0
	                mod.ShiftGunInfluence = 0
	                mod.RaiseForce = 0
	                mod.RaiseSpeed = 0
	                mod.RaiseBounce = 0
	                mod.RaiseInfluence = 0
	                print(v.Name..' Recoil Removed')
	            end
	        else
	            NoRecoil.Parent.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                mod.KickUpForce = pre[v.Name][1]
	                mod.ShiftCameraInfluence = pre[v.Name][2]
	                mod.ShiftGunInfluence = pre[v.Name][3]
	                print(v.Name..' Recoil Added')
	            end
	        end
		end)

	local pre = {}
		InstaReload.MouseButton1Down:connect(function()
	          if InstaReload.TextColor3 == Color3.new(1,0,0) then
	            InstaReload.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.ReloadTime,mod.ReChamberTime}
	                end
	                print(v.Name..' Spread Removed')
	                mod.ReloadTime = 0
					mod.ReChamberTime = 0
	            end
	        else
	            InstaReload.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.ReloadTime,mod.ReChamberTime}
	                else
	                    mod.ReloadTime = pre[v.Name][1]
						mod.ReChamberTime = pre[v.Name][2]
	                    print(v.Name..' Spread Added')
	                end
	            end
	        end
		end)

	local pre = {}
		FastFireRate.MouseButton1Down:connect(function()
	          if FastFireRate.TextColor3 == Color3.new(1,0,0) then
	            FastFireRate.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.FireRate}
	                end
	                print(v.Name..' Spread Removed')
	                mod.FireRate = 2000
	            end
	        else
	            FastFireRate.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.FireRate}
	                else
	                    mod.FireRate = pre[v.Name][1]
	                    print(v.Name..' Spread Added')
	                end
	            end
	        end
		end)



	local api;
	local framework; do
	    local renv = getrenv();
	    local fag = renv._G.ClientFramework
	    api = debug.getupvalue(fag,'api')
	    renv.settings = error;
	end
	local library = api.PreRequire('Libraries','Network')
	--setupvalue(debug.getupvalues(library.Send).getKey, 'stop', error)
	debug.setupvalue(library.Add,'uhOH',library.Kill)
	
	local pre = {}
		NoBulletDrop.MouseButton1Down:connect(function()
	          if NoBulletDrop.TextColor3 == Color3.new(1,0,0) then
	            NoBulletDrop.TextColor3 = Color3.new(0,1,0)
	 				
					local CastLocalBullet = getupvalues(api.Libraries.Bullets.Fire).castLocalBullet
					pre[1] = getupvalues(CastLocalBullet).Gravity
					setupvalue(CastLocalBullet,'GRAVITY',Vector3.new(0,0,0))
	        else
					local CastLocalBullet = getupvalues(api.Libraries.Bullets.Fire).castLocalBullet
					setupvalue(CastLocalBullet,'GRAVITY',pre[1])
					NoBulletDrop.TextColor3 = Color3.new(0,1,0)
	        end
		end)

	local pre = {}
		FullAuto.MouseButton1Down:connect(function()
	          if FullAuto.TextColor3 == Color3.new(1,0,0) then
	            FullAuto.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.FireRate}
	                end
	                print(v.Name..' Spread Removed')
			mod.FireModes = {'Automatic','Semiautomatic'}
			mod.DefaultFireMode = 'Automatic' -- Semiautomatic Automatic
	            end
	        else
	        end
		end)



	local uis = Game:GetService("UserInputService")
	uis.InputBegan:connect(function(inst)
	    if inst.KeyCode == Enum.KeyCode.Insert then
		 if game.Players.LocalPlayer.PlayerGui.GM.Frame.Visible == true then
	    game.Players.LocalPlayer.PlayerGui.GM.Frame.Visible = false
		 elseif game.Players.LocalPlayer.PlayerGui.GM.Frame.Visible == false then
		 game.Players.LocalPlayer.PlayerGui.GM.Frame.Visible = true
		 end
	    end
	end)
	
	local UserInputService = game:GetService("UserInputService")
	
	local gui = game.Players.LocalPlayer.PlayerGui["GM"].Frame
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
	    local delta = input.Position - dragStart
	    gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
