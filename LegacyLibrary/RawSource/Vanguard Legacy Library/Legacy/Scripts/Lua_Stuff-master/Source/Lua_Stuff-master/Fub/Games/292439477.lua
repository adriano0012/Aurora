--[[
    Phantom Forces
]]
--[[
    Network.Sends
        newpos
        newbullets
]]
--[[local send;
local hook = function(...)
    local temp = {...}
    if #temp == 9 then
        if temp[6] == 'Falling' then
            return
        end
    elseif #temp == 3 then
        if temp[2] == 'debug' then
            return
        end
    end
    local funcs = table.remove(temp,1)
    if not isfile(tostring(({...})[2])..'.lua') then
        tbl(temp,false,({...})[2])
    end
    return send(...)
end
local sends = {[tostring(hook)]=true};--]]
for i,v in next, getgc() do
    if type(v) == "function" then
        for i,v in next, debug.getupvalues(v) do
            if type(v) == "table" and rawget(v, 'send') then
                if not sends[tostring(v)] then
                    sends[tostring(v)]=true
                    send = v.send
                    rawset(v,'send',hook)
                end
               --[[ func = hookfunction(v.send,function(...)
                    if not ({...})[2]=='ping' then
                       tbl({...},false,({...})[1]..tick())
                    end
                    wait()
                    return v.send(...)
                end)
                Network = v;--]]
            end
        end
    end
end