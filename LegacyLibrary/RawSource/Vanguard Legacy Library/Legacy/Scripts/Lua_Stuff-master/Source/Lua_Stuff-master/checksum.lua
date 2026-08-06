local az = {97,122}
local AZ = {65,90}
local num1 = {48,57}

local str = 'ZkGmAlbSTysyDHnkpFmhHjPiiMUMkqFPGwKhenvlEGxYEAIspsWUNIikwdjA' 

function checksum(a)
	local substring;

	repeat 
	math.randomseed(math.random(1,999999999))
	local r = math.random(1,#a)
	local left = #a-r
	local left2 = math.random(r,#a)
	substring = a:sub(r,left2)
	until #substring > 10
	
	a = substring:sub(1,10)
	print(a)
	local num = 0;
	local constant = 91464479
	for i=1,#a do
		num = constant * num + string.byte(a:sub(i))
	end
end

checksum(str)
