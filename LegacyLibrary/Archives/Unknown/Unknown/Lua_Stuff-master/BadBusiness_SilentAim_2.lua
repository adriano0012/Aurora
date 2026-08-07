


local modulefolder;
local ProjectileModule;
local CharacterModule;
local TeamModule;
local Cast;
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
	elseif require(v).CastGeometryAndEnemies then
		Cast = require(v)
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
				table.insert(pliar,v)
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

_a = Cast.CastGeometryAndEnemies
Cast.CastGeometryAndEnemies = function(Input1, Vector_Origin, Vector_Direction, TFXW2G8, AcXi3U7l)
	local Head = CharacterModule:GetCharacter(game.Players.LocalPlayer).Body.Head
	if Head then
		local a = GetTargetByFov()
		if a then
			local Rayy = Ray.new(Head.CFrame.p, (a.CFrame.p).unit*3000)
			if Rayy then
				local ignore = {workspace.Geometry,workspace.NonGeometry,workspace.Ragdolls,workspace.Spawns}
				local a,b,c = workspace:FindPartOnRayWithWhitelist(Rayy ,ignore)
				print'ran succ'
				return a,b,c,Head
			end
		end
	end
	return _a(Input1, Vector_Origin, Vector_Direction, TFXW2G8, AcXi3U7l)
end

gay = ProjectileModule.FireProjectile
ProjectileModule.FireProjectile = function(name,BulletType,Position,Direction,PlayerWhoShot,PlayersBulletsShot,weapon)
	if PlayerWhoShot == game.Players.LocalPlayer then
		local Target = GetTargetByFov()
		if Target then
			--Position = (Target.CFrame * CFrame.new(Direction.X,Direction.Y,Direction.Z)).Position
			Direction = (Target.Position-Position).unit
			--print(Direction,type(Direction))
			
			--[[spawn(function()
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
			end)--]]
			
		else
			Direction = (game.Players.LocalPlayer:GetMouse().Hit.p-CharacterModule:GetCharacter(game.Players.LocalPlayer).Body.Head.Position).unit
		end
	end
	gay(name,BulletType,Position,Direction,PlayerWhoShot,PlayersBulletsShot,weapon)
end
