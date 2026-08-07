loadstring(game:HttpGet('https://pastebin.com/raw/2UKH9WYy'))() 
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

-- Instances:
local GM = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local Zoom = Instance.new("TextButton")
local Min = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local NoSpread = Instance.new("TextButton")
local NoRecoil = Instance.new("TextButton")
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
ImageLabel.Image = "rbxassetid://3325812184"

Zoom.Name = "Zoom"
Zoom.Parent = ImageLabel
Zoom.BackgroundColor3 = Color3.new(1, 1, 1)
Zoom.BackgroundTransparency = 1
Zoom.Position = UDim2.new(0.418764293, 0, 0.617224872, 0)
Zoom.Size = UDim2.new(0, 112, 0, 14)
Zoom.Font = Enum.Font.SourceSans
Zoom.Text = "•                  "
Zoom.TextColor3 = Color3.new(1, 0, 0)
Zoom.TextSize = 35

Min.Name = "Min"
Min.Parent = ImageLabel
Min.BackgroundColor3 = Color3.new(1, 1, 1)
Min.BackgroundTransparency = 1
Min.Position = UDim2.new(0.78718549, 0, 0.0334928222, 0)
Min.Size = UDim2.new(0, 30, 0, 26)
Min.Font = Enum.Font.SourceSans
Min.Text = " "
Min.TextColor3 = Color3.new(1, 0, 0)
Min.TextSize = 35

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
NoSpread.Position = UDim2.new(0.418764293, 0, 0.526315749, 0)
NoSpread.Size = UDim2.new(0, 112, 0, 13)
NoSpread.Font = Enum.Font.SourceSans
NoSpread.Text = "•                  "
NoSpread.TextColor3 = Color3.new(1, 0, 0)
NoSpread.TextSize = 35

NoRecoil.Name = "No Recoil"
NoRecoil.Parent = ImageLabel
NoRecoil.BackgroundColor3 = Color3.new(1, 1, 1)
NoRecoil.BackgroundTransparency = 1
NoRecoil.Position = UDim2.new(0.418764293, 0, 0.411483228, 0)
NoRecoil.Size = UDim2.new(0, 112, 0, 18)
NoRecoil.Font = Enum.Font.SourceSans
NoRecoil.Text = "•                  "
NoRecoil.TextColor3 = Color3.new(1, 0, 0)
NoRecoil.TextSize = 35
-- Scripts:
function SCRIPT_VKQO83_FAKESCRIPT() -- Zoom.Script 
	local script = Instance.new('Script')
	script.Parent = Zoom
	script.Parent.MouseButton1Down:connect(function()
			if script.Parent.TextColor3 == Color3.new(1,0,0) then
				script.Parent.TextColor3 = Color3.new(0,1,0)
				workspace.CurrentCamera.FieldOfView = 20
			else
				script.Parent.TextColor3 = Color3.new(1,0,0)
				workspace.CurrentCamera.FieldOfView = 70
			end
		end)
		
		game:GetService('RunService').RenderStepped:connect(function()
			if script.Parent.TextColor3 == Color3.new(0,1,0) then
				workspace.CurrentCamera.FieldOfView = 20
			end
		end)

end
coroutine.resume(coroutine.create(SCRIPT_VKQO83_FAKESCRIPT))
function SCRIPT_ZHCU89_FAKESCRIPT() -- Min.Script 
	local script = Instance.new('Script')
	script.Parent = Min
		script.Parent.MouseButton1Down:connect(function()
			script.Parent.Parent.Parent.Visible = not script.Parent.Parent.Parent.Visible
		end)

end
coroutine.resume(coroutine.create(SCRIPT_ZHCU89_FAKESCRIPT))
function SCRIPT_OQBS89_FAKESCRIPT() -- Close.Script 
	local script = Instance.new('Script')
	script.Parent = Close
		script.Parent.MouseButton1Down:connect(function()
			game.Players.LocalPlayer.PlayerGui.GM:Destroy()
		end)

end
coroutine.resume(coroutine.create(SCRIPT_OQBS89_FAKESCRIPT))
function SCRIPT_NQSX71_FAKESCRIPT() -- NoSpread.Script 
	local script = Instance.new('Script')
	script.Parent = NoSpread
	local pre = {}
		script.Parent.MouseButton1Down:connect(function()
	          if script.Parent.TextColor3 == Color3.new(1,0,0) then
	            script.Parent.TextColor3 = Color3.new(0,1,0)
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
	            script.Parent.TextColor3 = Color3.new(1,0,0)
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

end
coroutine.resume(coroutine.create(SCRIPT_NQSX71_FAKESCRIPT))
function SCRIPT_VPBO73_FAKESCRIPT() -- NoRecoil.Script 
	local script = Instance.new('Script')
	script.Parent = NoRecoil
		local pre = {}
		script.Parent.MouseButton1Down:connect(function()
		    if script.Parent.TextColor3 == Color3.new(1,0,0) then
	            script.Parent.TextColor3 = Color3.new(0,1,0)
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
	            script.Parent.TextColor3 = Color3.new(1,0,0)
	            for i,v in pairs(game:GetService("ReplicatedStorage").Shared.ItemData.Firearms:GetChildren()) do
	                local mod = require(v["Recoil Data"])
	                mod.KickUpForce = pre[v.Name][1]
	                mod.ShiftCameraInfluence = pre[v.Name][2]
	                mod.ShiftGunInfluence = pre[v.Name][3]
	                print(v.Name..' Recoil Added')
	            end
	        end
		end)

end
coroutine.resume(coroutine.create(SCRIPT_VPBO73_FAKESCRIPT))
function SCRIPT_NTRO74_FAKESCRIPT() -- GM.Interface 
	local script = Instance.new('Script')
	script.Parent = GM
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

end
coroutine.resume(coroutine.create(SCRIPT_NTRO74_FAKESCRIPT))
