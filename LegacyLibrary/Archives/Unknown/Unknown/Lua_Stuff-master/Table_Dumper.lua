local upvalue1 = 15
function upvalue()
	upvalue1 = 10
	local a = 69
end
local test_table = {
	Test = {
		gay = upvalue,
		math = 15,
		str = "yep",
		instance = workspace,
		Test = {
		
		}
	}
}


Settings = {
	ClassNameCheck = true,
	FunctionDepth = {
		Dump_Depth = 1,
		Table_Depth = 10,
	},
	FunctionDump = {
		Enabled = true,
		upvalues = getupvalues,
		constants = getconstants,
		info = getinfo,
	},
	max_objs = 300,
}

function table_counter(tbl,debug)
	local data = {}
	local children = 0
	function loop(tbl2)
		table.foreach(tbl2,function(i,v)
			if not rawget(data,tostring(type(v))) then
				rawset(data,tostring(type(v)),1)
			else
				rawset(data,tostring(type(v)),rawget(data,tostring(type(v)))+1)
			end
			if type(v) == 'table' then
				loop(v)
			end
			children = children + 1
		end)
	end
	loop(tbl)
	if debug then print(("="):rep(24));print"Debug Table_Counter Data";print(("="):rep(24));table.foreach(data,function(i,v) print(("%ss (%s)"):format(tostring(i),v)) end) end
	return children
end	
function GetClass(obj)
	return obj['ClassName']
end

function GetIsProp(obj)
	local x,y = pcall(GetClass,obj)
	return {[1]=x,[2]=y}
end


function Output(tbl)
	local Return = ''
	local Table_Size = table_counter(tbl,true)
	function Loop(tbl,indents,kill,realkill)
		if indents > Settings.FunctionDepth.Table_Depth then return end
		local spaces = ("	"):rep(indents)
		for i,v in pairs(tbl) do
			if v == tbl then return; end
			if type(v) == 'table'  then
				Return = Return .. ("%s%s = {\n"):format(spaces,tostring(i))
				Loop(v,indents + 1)
				Return = Return .. ("%s},\n"):format(spaces)
			elseif type(v) == 'table' and kill and not realkill then
				Return = Return .. ("%s%s = {\n"):format(spaces,tostring(i))
				Loop(v,indents + 1,true,true)
				Return = Return .. ("%s}\n"):format(spaces)
			elseif type(v) == 'function' and not kill then
				Return = Return .. ("%s%s = func{\n"):format(spaces,tostring(i))
				local env = {
				
				}
				if Settings.FunctionDump.Enabled then
					for l,func in pairs(Settings.FunctionDump) do
						if type(func) == 'function' then
							local ran,penv = pcall(func,v)
							if ran and table_counter(penv,false) > 0 then
								local safe_env = {}
								table.foreach(penv,function(i,v)
									safe_env[tostring(i)]=tostring(v)
								end)
								env[l]=safe_env
							end
						end
					end
				end
				Loop(env,indents + 1,true)
				Return = Return .. ("%s}\n"):format(spaces)
			else
				local res = GetIsProp(v)
				if res[1] then
					i = ('[%s]%s'):format(tostring(res[2]),tostring(i)
				end
				Return = Return .. ("%s%s=%s,\n"):format(spaces,tostring(i),tostring(v):gsub('function',''))
			end
		end
	end
	Loop(tbl,1)
	return Return
end
-- Phantom Forces

local network;
local funcs;
local char;
local gamelogic;
local effects;

for i,v in next, getgc() do
   if type(v) == "function" then
       for i2,v2 in next, debug.getupvalues(v) do
           if type(v2) == "table" and rawget(v2, 'send') then
               network = v2;
           end
           if type(v2) == "table" and rawget(v2, 'add') then
               funcs = v2;
           end
           if type(v2) == "table" and rawget(v2, 'addgun') then
               char = v2;
           end
           if type(v2) == "table" and rawget(v2, 'gammo') then
               gamelogic = v2;
           end
           if type(v2) == "table" and rawget(v2, 'breakwindow') then
               effects = v2;
           end
       end
   end
end

local dump = {
	network = network,
	funcs = funcs,
	char = char,
	gamelogic = gamelogic,
	effects = effects
}


writefile('pf_loaded.lua',Output(dump))
--writefile('pf_frametry',decompile(dump))











