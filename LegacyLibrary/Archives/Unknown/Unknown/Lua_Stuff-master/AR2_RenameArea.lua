local setupvalue = secret500 or debug.setupvalue
local getupvalues = secret953 or debug.getupvalues
local api;
local framework; do
    local renv = getrenv();
    local fag = renv._G.ClientFramework
    renv.settings = error;
    for i,v in pairs(debug.getupvalues(fag)) do 
        if type(v) ~= 'function' then 
            api = v
        end
    end
end

local library = api.PreRequire('Libraries','Network')

function GetServerSends()
    for i,v in pairs(debug.getupvalues(library.Send)) do 
        if type(v) == 'number' then
            v = v
            return v
        end
    end
end
function FixServerSends()
    for i,v in pairs(debug.getupvalues(library.Send)) do 
        if type(v) == 'number' then
            debug.setupvalue(library.Send,i,v+1)
            return
        end
    end
end

--15789
local fetch = getupvalues(library.Fetch)[7]
--network:Send("Inventory Unlock Item", item.Id)
local send = getupvalues(library.Send)[7]



for i,v in pairs(workspace.Loot:GetChildren()) do
	if #v:GetChildren() > 0 then
		FixServerSends()
		local a = fetch(GetServerSends(),'Get Loot Chunk Data', {v.Name})
		for i,v in pairs(a) do
			for l,k in pairs(v) do
				_name = l
				pcall(function()
					workspace.Loot[tostring(i)][l].Name = k.Name
				end)
				print('Renamed : '.._name..' - '..k.Name)
			end
		end
	end
	v.ChildAdded:connect(function()
		FixServerSends()
		local a = fetch(GetServerSends(),'Get Loot Chunk Data', {v.Name})
		for i,v in pairs(a) do
			for l,k in pairs(v) do
				pcall(function()
					workspace.Loot[tostring(i)][l].Name = k.Name
				end)
			end
		end
	end)
end
