--Anti math.random hook
local ab = {
    ["1"] = 0,
    ["2"] = 0,
    ["3"] = 0,
}
for i=1,100000 do
    local bb = math.random(1,3)
    ab[tostring(math.floor(bb))] = ab[tostring(math.floor(bb))]+1
end
for i,v in pairs(ab) do
    if v > 36000 then
        while true do end
    end
end
