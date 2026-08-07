repeat wait() until game:IsLoaded() == true
local name = game.Players.LocalPlayer.Name
local Player = game:GetService("Players").LocalPlayer
local version = "v0.0.1"
print("Prism "..version, "Welcome to Prism "..name)

if game.PlaceId ~= 13822889 then
    game.CoreGui.FluxLib:Destroy()
    return
end
local Start,Is_Client_Loaded=os.time(),false,nil;
local Prism = {alwaysday = false,alwaysnight = false}

local Executor=identifyexecutor();
local SupportedExecutors={'Synapse X','ScriptWare','Krnl','Temple'};
local Supported=table.find(SupportedExecutors,Executor)~=nil;
assert(Supported,'Executor Not Supported');
--notification function
local function notif(y, z, A)
	game.StarterGui:SetCore("SendNotification", {
		Title = y,
		Text = z,
		Icon = nil,
		Duration = A
	})
end;

local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/Voxel0/scripts/main/Prism/GuiLib.lua")()

local win = Flux:Window("Prism", "Lumber Tycoon 2", Color3.fromRGB(91, 9, 243), Enum.KeyCode.LeftControl)
local first = win:Tab("Prism", "http://www.roblox.com/asset/?id=6023426915")
local one1 = win:Tab("Player", "http://www.roblox.com/asset/?id=6023426915")
local two2 = win:Tab("Enviroment", "http://www.roblox.com/asset/?id=6023426915")



function alwaysday()
    game.Lighting.TimeOfDay='12:00:00';
end
function alwaysnight()
    game.Lighting.TimeOfDay='2:00:00';
end
first:Label("Welcome to Prism "..name.."!")
first:Label("Made by Voxel")
first:Label("Version: "..version)
first:Label("Executor: "..tostring(Executor))
first:Button("Rejoin Game","Allows you to Rejoin the current server you are in",function()
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)
local ws = 16
spawn(function()
    while game:GetService('RunService').RenderStepped:Wait() do
        pcall(function()
            Player.Character.Humanoid.WalkSpeed = ws
        end)
    end
end)
one1:Slider("Walkspeed", "Modifies Player Walkspeed", 0, 300,16,function(value)
ws = value
end)
local jp = 50
spawn(function()
    while game:GetService('RunService').RenderStepped:Wait() do
        pcall(function()
            Player.Character.Humanoid.JumpPower = jp
        end)
    end
end)

one1:Slider("Jump Power", "Modifies Player Jump Power", 0, 300,50,function(value)
jp = value
end)

one1:Slider("Field of View", "Modifies Player FOV(Field Of View)", 0, 120,70,function(value)
workspace.Camera.FieldOfView = value
end)

two2:Toggle("Water Walk", "Allows the player to walk on water", function(db)
    _G.wtr_toggle = db;
	for J, v in pairs(workspace.Water:children()) do
		if v.Name == "Water" then
			v.CanCollide = not v.CanCollide
		end
	end;
	for J, v in pairs(workspace.Bridge.VerticalLiftBridge.WaterModel:children()) do
		if v.Name == "Water" then
			v.CanCollide = not v.CanCollide
		end
	end
end)
_G.nofog_toggle = false
if _G.nofog_toggle == true then
    game.Lighting.FogStart = 32766;
    game.Lighting.FogEnd = 32767
else
    game.Lighting.FogStart = 0
end;
two2:Toggle("No Fog", "Removes the fog from the world", function(value)
    nofog_toggle = value
end)
warn('Loaded Prism In '..tostring(os.time()-Start)..' Second/s');
