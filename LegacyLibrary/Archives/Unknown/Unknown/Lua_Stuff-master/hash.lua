-- Client Whitelist
local letters = 'QYh29ktXxJ8noBg HNq5)z;MT6K7EIFRcjO0P:aUb(epZifSGWD,1sv&ALrmd3Vwu.lyC4'

local tbl = {'UserName','PassWord',tick()}

local len = 70

function GetLetterWithOffset(str,offset)
	local _old = offset
	offset = ((((offset/1337)/6)*8)/4)/7
	--print(offset)
	local NewStr = ''
	local ghetto = letters:rep(math.floor(offset/len))
	for i=1,str:len() do
		local letter = str:sub(i,i)
		local a;
		for i=1,string.len(letters) do
			if string.sub(letters,i,i) == tostring(letter) then
				a = i
				break
			end
		end
		local letteroffset = a*(math.floor(offset/len));
		NewStr = NewStr..ghetto:sub(letteroffset,letteroffset)
	end
	--print(NewStr)
	return NewStr,_old
end



a = {}
print'=========='
function a:Hash(str)
	math.randomseed(tick()+math.random(1,9*math.random(1,99999)))
	local offset = math.random(100000,999999)
	math.randomseed(offset)
	local offset = math.random(10000,99999)
	--print(offset)
	offset = ((((offset * 7) *4 )/8)*6)*1337
	--print(offset)
	return GetLetterWithOffset(str..'.Tick,'..tick(),offset),offset
	
end
function FlatLayer(hash)
	--local tik = tick()
	hash = hash--..tik
	local newhash = GetLetterWithOffset(hash,6217326)
	return newhash,6217326
end
function RemoveHash(hash,offset)
	offset = (offset or 6217326)
	offset = ((((offset/1337)/6)*8)/4)/7
	--print(offset)
	local NewStr = ''
	local ghetto = letters:rep(math.floor(offset/len))
	for i=1,hash:len() do
		local letter = hash:sub(i,i)
		local a;
		for i=1,string.len(letters) do
			if string.sub(letters,i,i) == tostring(letter) then
				a = i
				break
			end
		end
		local letteroffset = (a*(math.floor(offset/len)+1))
		for l=1,string.len(letters) do
			local letr = letters:sub(l,l)
			if ghetto:sub(l*(math.floor(offset/len)),l*(math.floor(offset/len))) == letter then
				NewStr = NewStr.. letr
				--break
			end
		end
		--NewStr = NewStr..ghetto:sub(letteroffset,letteroffset)
	end
	--print(NewStr)
	return NewStr
end
local sucess;
local hash_to_send;
local offset;
while not sucess do
	wait()
	local hash,ofset = a:Hash('User,Eski.Password,Admin')
	local flat_layer,flat_offset = FlatLayer(hash)
	local de_hash = RemoveHash(flat_layer)
	local base = RemoveHash(de_hash,ofset)
	if base:find'User' and base:find'Password' then
		sucess = true
		hash_to_send = hash
		offset = offset
		print('Base: '..base)
	end
end
print('Hash: '..hash_to_send);
