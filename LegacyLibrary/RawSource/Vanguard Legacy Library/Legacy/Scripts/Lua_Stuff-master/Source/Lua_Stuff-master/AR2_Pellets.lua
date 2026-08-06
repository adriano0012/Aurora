
oldfunc = getrenv().math.max
local func = function(val,max)
	if max == 1 then 
		return 20
	end
	if tostring(getcallingscript().Name):lower():find'bullet' then 
		print'Bullets ;)'
	end

	if val > max then return max else return val end
end
hookfunction(getrenv().math.max,func)


mod = game.ReplicatedStorage.Shared.ItemData.Firearms['M1909 Snubnose']
local b = require(mod)
b.PelletCount = 20
