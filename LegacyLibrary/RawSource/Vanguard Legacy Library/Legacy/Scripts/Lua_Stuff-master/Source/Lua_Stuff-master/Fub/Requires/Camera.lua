CameraTable = {}

Camera = setmetatable(CameraTable,{
    __index = function(self,prop)
        return workspace.CurrentCamera[prop]
    end,
    __tostring = function(self) 
        return "Camera Table {Embed Functions}"
    end,
})



return Camera