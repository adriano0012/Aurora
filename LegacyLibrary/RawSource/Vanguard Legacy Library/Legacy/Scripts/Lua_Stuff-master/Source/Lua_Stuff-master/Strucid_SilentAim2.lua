local FOV = 20
local team = false

game.Players.LocalPlayer.Chatted:connect(function(msg)
	if msg:lower() == '.team' then
	print('team = true')
		team = true
	elseif msg:lower() == '.ffa' then
	print('team = false')
		team = false
	end

end)


Camera = function()
	return game.workspace.CurrentCamera
end	
Character = function()
		return game.Players.LocalPlayer.Character
end
Mouse = game.Players.LocalPlayer:GetMouse()
function IsOnScreen(part)
    local vector, onscreen = Camera():WorldToScreenPoint(part.Position)
    return(vector.Z > 0)
end
function IsInFov(Part)
	if IsOnScreen(Part) then
		local X = Mouse.X
		local Y = Mouse.Y
		local MinX = X-(FOV)
		local MaxX = X+(FOV)
		local MinY = Y-(FOV)
		local MaxY = Y+(FOV)
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
function GetFirstPlayer()
	local thing = {}
	for i,v in pairs(game:GetService'Players':GetChildren()) do
		if v.Character and v.Character:FindFirstChild'Head' and v.Character:FindFirstChild'Humanoid' and v ~= game.Players.LocalPlayer then
			if team then
				if v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 then
					if IsVisible(v.Character.Head) then
						table.insert(thing,v)
					end
				end
			else
				if IsVisible(v.Character.Head) then
					table.insert(thing,v)
				end
			end
		end
	end
	if #thing > 0 then
		return thing[math.random(1,#thing)]
	else
		return nil
	end
end
local moduleB = require(game.ReplicatedStorage.GlobalStuff)
local _Cone = moduleB.ConeOfFire

function GetRandomPart(char)
	local ran = {}
	for i,v in pairs(char:GetChildren()) do
		if v:IsA'BasePart' then
			table.insert(ran,v)
		end
	end
	return ran[math.random(1,#ran)]
end

moduleB.ConeOfFire = function(Start, End, Inaccuracy)
	local target
	print'Cone Started'
	if GetFirstPlayer() then
		target = GetRandomPart(GetFirstPlayer().Character)
		print(target.Name)
		target = (target.Position)
	end
	if not target then 
		target = game.Players.LocalPlayer:GetMouse().Hit.p
	end
	return (target)
end
