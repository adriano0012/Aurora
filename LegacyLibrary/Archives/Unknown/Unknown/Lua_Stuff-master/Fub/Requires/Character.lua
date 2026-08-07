local PlayerTable = {
Teleport = function(self,CFrame)
    print(CFrame)
    self.HumanoidRootPart.CFrame = CFrame 
end,
Distance = function(self, Position)
    return Player:DistanceFromCharacter(Position)
end,


}

Character = setmetatable(PlayerTable,{
    __index = function(self,prop)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:wait()
        if not char then
            return error"Character not loaded"
        else
            return char[prop]
        end
    end,
    __call = function(self,...)
        if PlayerTable[({...})[1]] then
            PlayerTable[({...})[1]](self,({...})[2])
        end
    end,
    __tostring = function(self)
        return "Character Table"
    end,
})



return Character