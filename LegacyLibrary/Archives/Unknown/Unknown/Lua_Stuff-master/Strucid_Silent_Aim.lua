local strucidsilentaim = false


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
		if Part then
			local thingy = math.huge
			local pos = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
			local dist = (Vector2.new(Mouse.X,Mouse.Y)-Vector2.new(pos.X,pos.Y)).magnitude
			if pos.Z>0 and dist <= workspace.CurrentCamera.ViewportSize.X/(90/globalsettings["StrucidFOV"]) and dist < thingy then
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
	return(math.abs(X-x.X + Y-x.Y))
end
function ByDistance(partlist)
	print'============ Start ============'
	local Distance = {}
	for i,v in pairs(partlist) do
		table.insert(Distance,GetDistAwayFromCursor(v))
	end
	for i,v in pairs(Distance) do
		if v == math.min(unpack(Distance)) then
			print('Closest Part: '..partlist[i].Name)
			return partlist[i]
		end
	end
end
function GetRandomPart(char)-- get part closest to cursor
    local ran = {}
    math.randomseed(os.time())
    for i,v in pairs(char:GetChildren()) do
        if v:IsA'BasePart' then
			if IsVisible(v) then
				if v.Name == 'Head' then
					for i=1,15 do
						table.insert(ran,v)
					end
				end
				table.insert(ran,v)
			end
        end
    end
	return ByDistance(ran)
    --return ran[math.random(1,#ran)]
end
function IsVisible(Part)
    if Part then
        local ScreenPos = Camera():WorldToScreenPoint(Part.Position)
        local unitRay = Camera():ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
        local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
        local Ignore = Character():GetChildren()
        for i,v in pairs(Camera():GetChildren()) do
            table.insert(Ignore,v)
        end
        for i,v in pairs(Part.Parent:GetChildren()) do
            if not v:IsA'BasePart' then
                --print('Ignoring: '..v.Name)
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
        --print(ShouldReturn)
        return (ShouldReturn or false)
    end
end
function GetFirstPlayer()
	local thing = {}
	for i,v in pairs(game:GetService'Players':GetChildren()) do
		if v.Character and v.Character:FindFirstChild'Head' and v.Character:FindFirstChild'Humanoid' and v ~= game.Players.LocalPlayer then
			if v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 and globalsettings["StrucidFFA"] == false then
				if IsVisible(v.Character.Head) and IsInFov(v.Character.Head) then
					table.insert(thing,v)
				end
				elseif globalsettings["StrucidFFA"] == true and v.Character.Humanoid.Health > 0 then 
				if IsVisible(v.Character.Head) and IsInFov(v.Character.Head) then
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

strucidrunsilentaim = function()
 if strucidsilentaim == false then
strucidsilentaim = true
moduleB.ConeOfFire = function(Start, End, Inaccuracy)
    local target
    if GetFirstPlayer() then
        target = GetRandomPart(GetFirstPlayer().Character)
        target = (target.Position)
    end
    if not target then 
        target = game.Players.LocalPlayer:GetMouse().Hit.p
    end
    if strucidsilentaim == true then
	return (target)
	else
	return (game.Players.LocalPlayer:GetMouse().Hit.p)
	end
end
else
strucidsilentaim = false
end
end
end
