Camera = function() return workspace.CurrentCamera end
Character = function() return game.Players.LocalPlayer.Character end

function addTable(Table1,Table2)
	for i,v in pairs(Table2) do
		table.insert(Table1,v)
	end
	return Table1
end

function IsVisible(Part)
	if Part then
		local ScreenPos = Camera():WorldToScreenPoint(Part.Position)
		local unitRay = Camera():ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
		local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
		local a = Part.Parent:GetChildren()
		for i,v in pairs(a) do
			if v == Part then
				table.remove(a,i)
			end
		end
		local Ignore = addTable(Character():GetChildren(),a)
		
		for i,v in pairs(Camera():GetChildren()) do
			table.insert(Ignore,v)
		end
		local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
		local ShouldReturn
		pcall(function()
			ShouldReturn = Hit:IsDescendantOf(Part.Parent)
		end)
		return (ShouldReturn or false)
	end
end

function hitscan(plr)
	for i,v in pairs(plr:GetChildren()) do
		if v:IsA'BasePart' then
			if IsVisible(v) then
				return v
			end
		end
	end
	return false
end

function GetHead()
	local tbl = {}
	local tbl2 = {}
	for i,v in pairs(workspace.Enemies:GetChildren()) do
		if v:FindFirstChild'Head' then
			if IsVisible(v.Head) then
				table.insert(tbl,v.Head)
				table.insert(tbl2,(v.Head.Position - game.Players.LocalPlayer.Character.Head.Position).magnitude)
			elseif hitscan(v) then
				table.insert(tbl,hitscan(v))
				table.insert(tbl2,(hitscan(v).Position - game.Players.LocalPlayer.Character.Head.Position).magnitude)
			end
		end
	end
	for i,v in pairs(tbl2) do
		if v == math.min(unpack(tbl2)) then
			return(tbl[i])
		end
	end
	return false 
end


local g = getrawmetatable(game)
setreadonly(g,false)
_namecall = g.__namecall
g.__namecall = function(...)
	local a = {...}
	if a[1] == game.ReplicatedStorage.RE and (a[2] == 'shoot' or a[2] == 'Shoot') then 
		local b = GetHead()
		if b and type(b) == 'userdata' then
			a[3] = b.Position
		else
			a[3] = game.Players.LocalPlayer:GetMouse().Hit.p
		end
		return _namecall(unpack(a))
	end

	return _namecall(...)
end
