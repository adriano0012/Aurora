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


--setupvalue(debug.getupvalues(library.Send).getKey, 'stop', error)

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
function PickUpItem(id)
FixServerSends()
local tbl_main = {
        GetServerSends(), 
        "Inventory Pickup Item", 
        id
}
game:GetService("ReplicatedStorage").Networking.Intercom:FireServer(unpack(tbl_main))

end

function AutoLootContainers()
    for i,v in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.Containers) do
        for ID in pairs(v.Occupants) do
            PickUpItem(ID)
        end
    end
end
function AutoLootGround()
    for ID,v in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.GroundContainer.Occupants) do
        PickUpItem(ID)
    end
end
