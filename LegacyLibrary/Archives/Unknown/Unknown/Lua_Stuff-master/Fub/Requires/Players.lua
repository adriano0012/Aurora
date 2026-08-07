local pla = game:GetService'Players'.LocalPlayer
function IsVisible(Part)
    if Part then
		local Camera = workspace.CurrentCamera
        local ScreenPos = Camera:WorldToScreenPoint(Part.Position)
        local unitRay = Camera:ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
        local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
        local Ignore = game:GetService'Players'.LocalPlayer.Character:GetChildren()
        for i,v in pairs(Camera:GetChildren()) do
            table.insert(Ignore,v)
        end
        for i,v in pairs(Part.Parent:GetChildren()) do
            if not v:IsA'BasePart' then
                table.insert(Ignore,v)
            end
        end
        local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
        local ShouldReturn
        pcall(function()
            ShouldReturn = (Hit:IsDescendantOf(Part.Parent))
        end)
        return (ShouldReturn or false)
    end
end










local Players = {}

function Players:get(Name)
    if not Name then return game:GetService'Players':GetChildren() end
    local found = {}
    for i,v in pairs(game:GetService'Players':GetChildren()) do
        if v.Name:sub(1,#Name):lower() == Name:lower() or v.Name:lower():find(Name:lower()) then
            table.insert(found,v)
        end
    end
    if #found > 0 then
        return #found > 1 and found or found[1]
    else
        return false,error'Failed to find player'
    end
end
function Players:GetPlayers()
    local List = {}
    for i,v in pairs(game:GetService'Players':GetChildren()) do
        if v.Character then
            if v.Character.Humanoid then
                --if v.Character.Hu
            end
        end
    end
end
function Players:GetWithBlacklist(List)
    local New = {}
    for i,v in pairs(game:GetService'Players':GetChildren()) do
        local db = false
        for l,p in pairs(List) do
            if p == v then
                db = true
            end
        end
        if not db then
            table.insert(New,v)
        end
    end
    return New
end
function Players:GetVisiblePlayers(List)
    local VisiblePlayers = {};
    for i,v in next, List do
        if v.Character and pla.Character then
            if v.Character:FindFirstChild'Head' and pla.Character:FindFirstChild'Head' then
                if IsVisible(v.Character.Head) then
                    table.insert(VisiblePlayers,v)
                end
            end
        elseif not pla.Character then
            return false
        end
    end
    return VisiblePlayers or false
end 
function Players:GetPlayersInRadius(List,Distance)--Players:get(),50
    if not List then return false end
    local Close = {}
    for i,v in pairs(List) do
        if v.Character and not v.Character:FindFirstChild'ForceField' then
            if v.Character.Head then
                if Character:Distance(v.Character.Head.Position) < Distance then
                    table.insert(Close,v)
                end
            end
        end
    end
    return Close
end

function Players:GetClosestPlayer(List)
    if not List then return false end
    local visible = {}
	local distance = {}
	for i,v in pairs(List) do
		if v.Character and v.Character:FindFirstChild'Head' then
			if IsVisible(v.Character.Head) and v.Character.Humanoid.Health > 0 then
				table.insert(visible,v)
				table.insert(distance,pla:DistanceFromCharacter(v.Character.Head.Position))
				--return v.Character.Head,v.Character.Head.Position
			end
		end
	end
	for i,v in pairs(distance) do
        if v == math.min(unpack(distance)) then
			return visible[i],v
		end
    end
    return false
end
function Players:GetEnemyPlayers(List)
    if not List then return false end
    local Enemies = {}
    for i,v in pairs(List) do
        if v.Team == pla.Team then
        else
            Enemies[#Enemies+1]=v
        end
    end
    return #Enemies > 0 and Enemies or false
end
function Players:GetFriendlyPlayers(List)
    if not List then return false end
    local Friendly = {}
    for i,v in pairs(List) do
        if v.Team == pla.Team then
            Friendly[#Friendly+1]=v
        end
    end
    return #Friendly > 0 and Friendly or false
end

--Players:GetClosestPlayer(Players:GetVisiblePlayers(Players:GetEnemyPlayers(game:GetService'Players':GetChildren())))
Players = setmetatable(Players,{
__tostring = function(self) return "Players Table {Embed Functions}" end,
__index = function(self,prop) return game:GetService'Players'[prop] and game:GetService'Players'[prop] or nil end,})

return Players
