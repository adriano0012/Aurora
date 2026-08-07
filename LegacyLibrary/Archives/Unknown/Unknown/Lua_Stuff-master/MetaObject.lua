local new = {}
local ObjMeta = {}
ObjMeta.__index = ObjMeta
new.Obj = function(num)
    local ToRet = setmetatable({}, ObjMeta)
    ToRet.Stored = num
    return ToRet
end
function ObjMeta:TestFunction()
    print("Test function ran!")
    print("This is stored in me! "..self.Stored)
end

NewObject = new.Obj(2)
NewObject:TestFunction()
