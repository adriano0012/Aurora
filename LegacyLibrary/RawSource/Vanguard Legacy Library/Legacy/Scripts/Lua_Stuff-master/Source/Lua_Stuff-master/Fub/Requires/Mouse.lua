local pla = Require('Player',false)
local Mouse = pla:GetMouse()
function GetDistAwayFromCursor(Part)
	local X = Mouse.X
	local Y = Mouse.Y
    local x = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
    --if x.Z > 0 then
        return(X-x.X + Y-x.Y)
    --else
    --    return math.huge
    --end
end

MouseTable = {}

function MouseTable:GetClosestPlayerToCrosshair(List)
    local dist = {};
    local plrs = {};
    for i,v in pairs(List) do
        if v.Character then
            if v.Character.Head then
            table.insert(plrs,v)
            table.insert(dist, math.abs(GetDistAwayFromCursor(v.Character.Head)))
            end
        end
    end
    for i,v in pairs(dist) do
        if v == math.min(unpack(dist)) then
            return plrs[i]
        end
    end
end

Mouse = setmetatable(MouseTable,{
    __index = function(self,prop)
        return game.Players.LocalPlayer:GetMouse()[prop]
    end,
    __tostring = function(self)
        return "Mouse Table {Embed Functions}"
    end,
})



return Mouse