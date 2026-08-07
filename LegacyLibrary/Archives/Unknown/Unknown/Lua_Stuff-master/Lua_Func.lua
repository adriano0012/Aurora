getgenv().decompile = function(inst)
local name
if inst.Name == '' or #inst.Name < 1 then
    name = 'Temp Name#'..math.random(1,999999)
else
    name = inst.Name
end
-- Module Mapper
if not isfolder('tmp') then
    makefolder('tmp')
end
if not isfolder('tmp/'..game.GameId) then
    makefolder('tmp/'..game.GameId)
end

local Module = (inst.ClassName == 'LocalScript' and getsenv(inst) or require(inst))
local str = ''
writefile('tmp/'..game.GameId..'/'..name,name.."\n")
function loop(tbl,ind)
    if #readfile('tmp/'..game.GameId..'/'..name) > 25000 then
        warn('Script too long ( over 25,000 characters)')
        return readfile('tmp/'..game.GameId..'/'..name)
    end
    if ind > 6 then
        return
    end
    local inda=("    "):rep(ind)
    table.foreach(tbl,function(i,v)
        a = tostring(i)
        b = type(v)
        str = str..inda..a..' = ('..b..")"..tostring(v).."\n"
        appendfile('tmp/'..game.GameId..'/'..name,str)
        str = ''
        if type(v) == 'table' then
            loop(v,ind+1)
        elseif type(v) == 'function' then
            --[[if inst then
                return
            end--]]
            local x,y = pcall(function() return getconstants(v) end)
            local x1,y1 = pcall(function() return getupvalues(v) end)
            if x and #y > 0 then
                str = inda.."    "..("-Constants\n"):format(tostring(i))
                appendfile('tmp/'..game.GameId..'/'..name,str)
                str = ''
                loop(y,ind+2,true)
            end
            if x1 and #y1 > 0 then
                str = inda.."    "..("-Upvalues(%s)\n"):format(tostring(i))
                appendfile('tmp/'..game.GameId..'/'..name,str)
                str = ''
                loop(y1,ind+2,true)
            end
        end
        
    end)
end
if type(Module) == 'table' then
    table.foreach(Module,function(i,v)
        str = str..("    "):rep(1)..tostring(i)..' = '..tostring(v).."\n"
        if type(v) == 'table' then
            loop(v,2)
        elseif type(v) == 'function' then
            loop(debug.getupvalues(v),2)
        end
    end)
elseif type(Module) == 'function' then
    loop(debug.getupvalues(Module),1)
end

return readfile('tmp/'..game.GameId..'/'..name)
end
