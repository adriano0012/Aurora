-- Farewell Infortality.
-- Version: 2.82
-- Instances:
local GM = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local Zoom = Instance.new("TextButton")
local NoSpread = Instance.new("TextButton")
local NoRecoil = Instance.new("TextButton")
local InstaReload = Instance.new("TextButton")
local FullAuto = Instance.new("TextButton")
local FastFireRate = Instance.new("TextButton")
local Close = Instance.new("TextButton")
--Properties:
GM.Name = "GM"
GM.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Parent = GM
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(0.3828125, 0, 0.139498428, 0)
Frame.Size = UDim2.new(0, 418, 0, 221)

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(-0.0457531512, 0, 0.0252643824, 0)
ImageLabel.Size = UDim2.new(0, 437, 0, 209)
ImageLabel.Image = "rbxassetid://3357291813"

Zoom.Name = "Zoom"
Zoom.Parent = ImageLabel
Zoom.BackgroundColor3 = Color3.new(1, 1, 1)
Zoom.BackgroundTransparency = 1
Zoom.Position = UDim2.new(0.329519451, 0, 0.550239265, 0)
Zoom.Size = UDim2.new(0, 112, 0, 14)
Zoom.Font = Enum.Font.SourceSans
Zoom.Text = "•                  "
Zoom.TextColor3 = Color3.new(1, 0, 0)
Zoom.TextSize = 20

NoSpread.Name = "No Spread"
NoSpread.Parent = ImageLabel
NoSpread.BackgroundColor3 = Color3.new(1, 1, 1)
NoSpread.BackgroundTransparency = 1
NoSpread.Position = UDim2.new(0.329519451, 0, 0.488038242, 0)
NoSpread.Size = UDim2.new(0, 112, 0, 13)
NoSpread.Font = Enum.Font.SourceSans
NoSpread.Text = "•                  "
NoSpread.TextColor3 = Color3.new(1, 0, 0)
NoSpread.TextSize = 20

NoRecoil.Name = "No Recoil"
NoRecoil.Parent = ImageLabel
NoRecoil.BackgroundColor3 = Color3.new(1, 1, 1)
NoRecoil.BackgroundTransparency = 1
NoRecoil.Position = UDim2.new(0.329519451, 0, 0.401913851, 0)
NoRecoil.Size = UDim2.new(0, 112, 0, 18)
NoRecoil.Font = Enum.Font.SourceSans
NoRecoil.Text = "•                  "
NoRecoil.TextColor3 = Color3.new(1, 0, 0)
NoRecoil.TextSize = 20

InstaReload.Name = "Insta-Reload"
InstaReload.Parent = ImageLabel
InstaReload.BackgroundColor3 = Color3.new(1, 1, 1)
InstaReload.BackgroundTransparency = 1
InstaReload.Position = UDim2.new(0.329519451, 0, 0.760765553, 0)
InstaReload.Size = UDim2.new(0, 112, 0, 14)
InstaReload.Font = Enum.Font.SourceSans
InstaReload.Text = "•                  "
InstaReload.TextColor3 = Color3.new(1, 0, 0)
InstaReload.TextSize = 20

FullAuto.Name = "Full Auto"
FullAuto.Parent = ImageLabel
FullAuto.BackgroundColor3 = Color3.new(1, 1, 1)
FullAuto.BackgroundTransparency = 1
FullAuto.Position = UDim2.new(0.329519451, 0, 0.693779945, 0)
FullAuto.Size = UDim2.new(0, 112, 0, 14)
FullAuto.Font = Enum.Font.SourceSans
FullAuto.Text = "•                  "
FullAuto.TextColor3 = Color3.new(1, 0, 0)
FullAuto.TextSize = 20

FastFireRate.Name = "Fast Fire Rate"
FastFireRate.Parent = ImageLabel
FastFireRate.BackgroundColor3 = Color3.new(1, 1, 1)
FastFireRate.BackgroundTransparency = 1
FastFireRate.Position = UDim2.new(0.329519451, 0, 0.617224932, 0)
FastFireRate.Size = UDim2.new(0, 112, 0, 14)
FastFireRate.Font = Enum.Font.SourceSans
FastFireRate.Text = "•                  "
FastFireRate.TextColor3 = Color3.new(1, 0, 0)
FastFireRate.TextSize = 20

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
	            NoRecoil.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                mod.KickUpForce = pre[v.Name][1]
	                mod.ShiftCameraInfluence = pre[v.Name][2]
	                mod.ShiftGunInfluence = pre[v.Name][3]
	                print(v.Name..' Recoil Added')
	            end
	        end
		end)
	local noreload = false
	local api;
	local framework; do
	    local renv = getrenv();
	    local fag = renv._G.ClientFramework
	    api = debug.getupvalue(fag,'api')
	    renv.settings = error;
	end
	local library = api.PreRequire('Libraries','Network')
	setupvalue(debug.getupvalues(library.Send).getKey, 'stop', error)
	debug.setupvalue(library.Add,'uhOH',library.Kill)
	a = api.Classes.Characters.new
	print'========================='
	charstep = getupvalue(a,'characterStep')
	func = function(char,delta,run)
	    char.MoveState = "Running"
	    char.Shoving = false
	    char.Staggered = false
		if noreload then
			char.Reloading = false
			char.AtEase = false
		end
	    charstep(char,delta,run)
	end
	setupvalue(a,'characterStep',func)
	
	local pre = {}
		InstaReload.MouseButton1Down:connect(function()
	          if InstaReload.TextColor3 == Color3.new(1,0,0) then
	            InstaReload.TextColor3 = Color3.new(0,1,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v)
	                if not pre[v.Name] then
	                    pre[v.Name] = {mod.ReloadTime,mod.ReChamberTime}
	                end
	                mod.ReloadTime = 0
					mod.ReChamberTime = 0
					noreload = true
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
						noreload = false
	                end
	            end
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
	                table.insert(mod.FireModes,'Automatic')
					mod.DefaultFireMode = 'Automatic' -- Semiautomatic Automatic
	            end
	        else
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

Close.MouseButton1Down:connect(function()
			game.Players.LocalPlayer.PlayerGui.GM:Destroy()
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
