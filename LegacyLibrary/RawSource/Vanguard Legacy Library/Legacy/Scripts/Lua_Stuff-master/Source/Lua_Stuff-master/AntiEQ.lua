local function EQ(v1,v2)
    local Type = math.floor(math.random(1,2))
    if type(v1) == "string" and type(v2) == "string" then
        local T = true
        local T1,T2 = v1:split("."),v2:split(".")
        local L1,L2 = #v1,#v2
        if (L1-L2) < 0 or (L1-L2) > 0 then
            T = false
        end
        local Start = math.floor(math.random(1,#v1))
        for i=Start,#v1 do
            local Type2 = math.floor(math.random(1,2))
            if Type2 == 1 then
                if T1[i] == T2[i] then
                else
                    T = false
                end
            elseif Type2 == 2 then
                if T1[i] ~= T2[i] then
                    T = false
                end
            end
        end    
        for i=1,(#v1-Start) do
            local Type2 = math.floor(math.random(1,2))
            if Type2 == 1 then
                if T1[i] == T2[i] then
                else
                    T = false
                end
            elseif Type2 == 2 then
                if T1[i] ~= T2[i] then
                    T = false
                end    
            end
        end
        return T
	elseif type(v1) == 'number' and type(v2) == 'number' then
		local a = (v1==v2)
		local b = EQ(tostring(v1),tostring(v2))
		if b ~= a or not b or not a then
			return false
		end
    end
    if Type == 1 then
        return v1 == v2
    elseif Type == 2 then    
        return (not v1 ~= v2)
    end
end
