function SendMessage(Text) game.StarterGui:SetCore("SendNotification", { Title = "YeYe"; Text = Text; Duration = 1; }) end

function Synapse_Proto()
a.f = g;
-- // ProtoSmasher Compatability \\ -- 
SendMessage('Loading Protosmasher Compatible Functions')
local syn = getgenv()
syn.dofile = function(path) loadstring(readfile(path))() end
syn.make_writeable = function(tbl) setreadonly(tbl, false) end
syn.make_readonly = function(tbl) setreadonly(tbl, true) end
syn.is_writeable = function(tbl) return not isreadonly(tbl) end
syn.get_nil_instances = function() return getnilinstances() end
syn.dump_function = function(func) return dumpstring(func) end
syn.unlock_modulescript = function() return true end
syn.printoutput = function(str) print(str) end
syn.get_calling_script = function() return getcallingscript() end
syn.debug = {}
syn.debug.getregistry = function() return getreg() end
syn.debug.setfenv = function(obj,tbl) return setfenv(obj,tbl) end
syn.Input = {}
syn.Input.LeftClick = function(action) if action == 'MOUSE_DOWN' then mouse1press() elseif action == 'MOUSE_UP' then mouse1release() end end
syn.Input.MoveMouse = function(x,y) mousemoverel(x,y) end
syn.Input.ScrollMouse = function(int) mousescroll(int) end
syn.Input.KeyPress = function(key) keypress(key) end
syn.Input.KeyDown = function(key) keypress(key) end
syn.Input.KeyUp = function(key) keyrelease(key) end

SendMessage('ProtoSmasher Compatability Loaded')
end
function Synapse_Elysian()
-- // Elysian Compatability \\ -- 
SendMessage('Loading Protosmasher Compatible Functions')
local syn = getgenv()
syn.printconsole = function(str) print(str) end
syn.printdebug = function(str) warn(str) end
syn.saveplace = function() return saveinstance() end
syn.getallthreads = function() return getscripts() end
syn.getupvals = function(func) return debug.getupvalues(func) end
syn.setupval = function(func,str,inp) return debug.setupvalue(func,str,imp) end
end
function Proto_Synapse()
-- // Synapse Compatability \\ -- 
SendMessage('Loading Synapse Compatible Functions')
local syn = getgenv()
syn.setreadonly = function(tbl,typ) if typ == 'true' then make_readonly(tbl) else make_writeable(tbl) end end
syn.isreadonly = function(tbl) return not is_writeable(tbl) end
syn.getnilinstances = function() return get_nil_instances() end
syn.dumpstring = function(func) return dump_function end
syn.getcallingscript = function() return get_calling_script() end
syn.getreg = function() return debug.getregistry() end
syn.setfenv = function(obj,tbl) return debug.setfenv(obj,tbl) end
syn.mouse1press = function() Input.LeftClick("MOUSE_DOWN") end
syn.mouse1release = function() Input.LeftClick("MOUSE_UP") end
syn.mousemoverel = function(x,y) Input.MoveMouse(x,y) end
syn.mousescroll = function(int) Input.ScrollMouse(int) end
syn.keypress = function(Key) Input.KeyDown(Key) end
syn.keyrelease = function(Key) Input.KeyUp(Key) end
SendMessage(print'Synapse Compatability Loaded')
end
function Sirhurt_Synapse()
local syn = getgenv()
syn.mouse1press = function() leftpress() end
syn.mouse1release = function() leftrelease() end
syn.mouse2press = function() rightpress() end
syn.mouse2release = function() rightrelease() end
end
function Synapse_Sirhurt()
local syn = getgenv()
syn.RandomString = function(len) math.randomseed(tick()) local a = '' nag = 'abcdefghijklmnopqrstuvwxyz' for i=1,len do local r = math.random(1,nag:len() a = a..math.random() end return a end end
syn.getclipboard = function() return'Nop' end
syn.HttpGet = function(url) return game:HttpGet(url,true) end
syn.leftpress = function() mouse1press() end
syn.leftrelease = function() mouse1release() end
syn.rightpress = function() mouse2press() end
syn.rightrelease = function() mouse2release() end

end
if syn then
	Synapse_Elysian()
	Synapse_Proto()
	Synapse_Sirhurt()
end
if PROTOSMASHER_LOADED then
	Proto_Synapse()
end

Sirhurt_Synapse()
