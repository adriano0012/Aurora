local gm = getrawmetatable(game);
local gmni = gm.__newindex;
local gmn = gm.__namecall;
local random,ogen;
local sr;
local ocaller; 
local hookf = hookfunction or function(f)end
local newc = newcclosure or protect_function or function(f)end
ocaller = hookf(checkcaller,newc(function()
    return ocaller();
end));

local otostring;
otostring = hookf(tostring,newc(function(s)
    s = otostring(s);
	sr = s
    if (ocaller() and getfenv(2)["script"] ~= script) and (s:find("http") or s:find("snowygui") or s:find(".com") or s:find(otostring(random)) or s == ogen) then
        return "suck my ass";
    end;  
    return s;
end));
--[[
    does me scrolling make you scroll?
]]

setreadonly(gm,false);
gm.__newindex = newc(function(self,i,v)
    if (ocaller() and getfenv(2)["script"] ~= script) and i == "Text" and (sr:find("http") or sr:find("snowygui") or sr:find(".com") or sr:find(otostring(random)) or sr == ogen) then
        return "suck my ass";
    end;
    return gmni(self,i,v)
end);
setreadonly(gm,true);

local part = Instance.new("Part",nil);
ogen = part:GetDebugId(2147483648);
local ngen = tonumber(ogen);
if otostring(ngen) ~= ogen then
    while true do end;
end;
if ngen <= 1000 then
    ngen = ngen + 1092;
end;
part:Destroy();
local a,b = 0,1;
local c,d,e,f = 727595-(ngen/2),798405-ngen,1048576+(ngen*1.5),1099511627776-(ngen*2.714159265359); --> i take no credit for this, it is a widely used to replace standard c number generators
local calculate = function(g,h)
    local i = (g*d+h*c)%e;
    i = (i*e+(h*d))%f;
    a,b = math.floor(i/e),i-(g*e);
    return i/f; --> the number
end;
local oa,ob,h,i;
for e = 1,4 do
    if e == 3 then
        i = calculate(a,b);
    elseif e == 4 then
        h = calculate(a,b);
    end;
end;
random = (h+i*10)/h;
local encrandom = random; --> encrypted random
encrandom = (encrandom*2.35)/4;
encrandom = (9.29+(encrandom*0.495834))*0.1;
encrandom = (encrandom*31)*0.89;
local decrandom = tonumber(game:HttpGet("http://basehosting.xyz/Files/Time.php"..encrandom,true));
if decrandom == nil then
    while true do end;
end;
decrandom = (decrandom/0.52)/52;
decrandom = ((decrandom/0.2)-14.29)/(0.2958);
decrandom = ((decrandom*2)/8)

--[[
if not (decrandom < random+0.00001 and decrandom > random-0.00001) then
    while true do end;
end
--]]
print(decrandom)
