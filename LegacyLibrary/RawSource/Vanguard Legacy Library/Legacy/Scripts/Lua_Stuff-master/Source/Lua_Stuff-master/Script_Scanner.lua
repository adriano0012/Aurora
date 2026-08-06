--[[ Features

	Constant Searching
	Upvalue Searching
	Synapse Function Searching
	
	Remote Spy
	
	Http Spy
	
	Mini Explorer
	
	
	
	Script Scanner
		( Search script names, or return values in a script)
	Module Scanner
		( Search module names, or return values in a module)
		
	Closure Spy
		( Search functions for cclosure ? )
		]]
setreadonly(table,false)
table.count = function(tbl)
	local count = 0
	table.foreach(tbl,function() count = count + 1 end)
	return count
end


local dbg = false
		
-- Script Scanner
local All_Script_Envs = {};
function LoadEnvs()
	local scripts = #getscripts()
	local failed = 0
	local loaded = 0
	print(("Loading %s script enviroments to table."):format(scripts))
	for i,v in pairs(getscripts()) do
		if not v.ClassName:find'Module' then
			if not v.Disabled then
				local fail,Local_Env = pcall(function() return getsenv(v) end)
				if not fail then
					failed = failed + 1
					if dbg then
						print(("%s failed to load"):format(v:GetFullName()))
					end
				else
					if table.count(Local_Env) > 0 then
						loaded = loaded + 1
						All_Script_Envs[v]=Local_Env
						--table.insert(All_Script_Envs,Local_Env)
					else
						failed = failed + 1
						if dbg then
							print(("%s failed to load anything useful"):format(v:GetFullName()))
						end
					end
				end
			else
				failed = failed + 1
			end
		else
			local fail,Local_Env = pcall(function() return require(v) end)
			if not fail then
				failed = failed + 1
				print(("%s failed to load"):format(v:GetFullName()))
			else
				if type(Local_Env) ~= 'table' then
					Local_Env = {Local_Env}
				end
				if table.count(Local_Env) > 0 then
					loaded = loaded + 1
					All_Script_Envs[v]=Local_Env
					--table.insert(All_Script_Envs,Local_Env)
				else
					failed = failed + 1
					if dbg then
						print(("%s failed to load anything useful"):format(v:GetFullName()))
					end
				end
			end
		end
	end
	print(("Done loading %s script enviroments."):format(loaded))
	print(("%s Script enviroments failed to load"):format(failed))
end

LoadEnvs()

function Scan_Scripts(keyword,data) -- data == 1 : SearchFunctions or 0 : Search
	for i,v in pairs(All_Script_Envs) do
		for script,k in pairs(v) do
			if data == 0 then
				if k == keyword then
					print(("Keyword %s found in script (%s)"):format(k,script))
				end
			elseif data == 1 then
				if k == keyword then
					print(("Keyword %s found in script (%s)"):format(k,script))
				end
				if type(k) == 'function' then
					local temp_env = {unpack(getupvalues(k)),unpack(getconstants(k))}
					for new,stuff in pairs(temp_env) do
						if stuff == keyword then
							print(("Keyword %s found in script/function (%s)/(%s)"):format(k,script,debug.getinfo(k)))
						end
					end
				end
			end
		end
	end
	
end

--Scan_Scripts(0,0) -- second arg, 0 == only keywords, 1 == upvalues

function Find_Closures()
	for i,v in pairs(All_Script_Envs) do
		for script,k in pairs(v) do
			if type(k) == 'function' then
				if not islclosure(k) then
					local info = debug.getinfo(k)
					local info2 = info['short_src']..'.'..info['name']
					print(("Closure found in script/function (%s)/(%s)"):format(script,info2))
				elseif is_synapse_function(k) then
					local info = debug.getinfo(k)
					local info2 = info['short_src']..'.'..info['name']
					print(("Synapse Function found in script/function (%s)/(%s)"):format(script,info2))
				end
			end
		end
	end
end

Find_Closures()
