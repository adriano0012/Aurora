-- Module Mapper


local Module = require(game.ReplicatedStorage.Modules.Load)
local str = "Framework\n"
writefile(game.PlaceId,str,inst)
function loop(tbl,ind)
	if ind > 15 then
		return
	end
	local inda=("	"):rep(ind)
	for i,v in pairs(tbl) do
		a = tostring(i)
		b = type(v)
		c = str
		str = tostring(c)..inda..a..' = ('..b..")"..tostring(v).."\n"
		if type(v) == 'table' then
			loop(v,ind+1)
		elseif type(v) == 'function' then
			--[[if inst then
				return
			end--]]
			local x,y = pcall(function() return getconstants(v) end)
			local x1,y1 = pcall(function() return getupvalues(v) end)
			if x and #y > 0 then
				str = inda.."	".."-Constants\n"
				loop(y,ind+2,true)
			end
			if x1 and #y1 > 0 then
				str = inda.."	".."-Upvalues\n"
				loop(y1,ind+2,true)
			end
		end
		
		appendfile(game.PlaceId,str)
		str = ''
	end
end

for i,v in pairs(Module) do
	str = str..("	"):rep(1)..tostring(i)..' = '..tostring(v).."\n"
	if type(v) == 'table' then
		loop(v,2)
	elseif type(v) == 'function' then
		loop(debug.getupvalues(v),2)
	end
end
