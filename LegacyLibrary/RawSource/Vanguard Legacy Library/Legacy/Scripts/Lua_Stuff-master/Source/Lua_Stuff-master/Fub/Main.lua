local game = game;


getgenv().Testing = false
getgenv().Crash = function()
    print'crashed'
end
local loaded = {}
getgenv().Require = function(Script,output)
    if not loaded[Script] then
        local Load = loadfile and loadfile or dofile
        local ret =  Load('Fub/Requires/'..Script..'.lua')()
        if not Testing and output then
            print(Script,'Loaded')
        elseif Testing then
            print(Script,'Loaded with result: ',tostring(ret))
        end
        loaded[Script]=ret
        return ret
    else
        return loaded[Script]
    end
end
local LoadGame = function(id,...)
    if isFile('Fub/Games/'..id..'.lua') then
        local Load = loadfile and loadfile or dofile
        print('Loading: Fub/Games/'..id..'.lua')
        local Game = Load('Fub/Games/'..id..'.lua')()
        local results = type(Game) == 'function' and Game(...) or Game
        print('Loaded: Fub/Games/'..id..'.lua, with return: ',tostring(results))
        return results
    else
        print('File: Fub/Games/'..id..'.lua not found')
    end
end
print("Requires")
Require('Functions',true)
--Require('MetaProtect')

local Settings = Require('Settings',true)
local Players = Require('Players')
local Player = Require('Player')
local Char = Require('Character')
local Camera = Require('Camera')
local Mouse = Require('Mouse')
local Anti = Require('Anti')
local UI = Require('Gui',true)
local Notification = Require('Notify')
local World = Require('World')
--local Low_Rendering = Require('BetterRendering',true)
getgenv().Env = {
    Players = Players,
    Player = Player,
    Char = Char,
    Camera = Camera,
    Mouse = Mouse,
    Anti = Anti,
    Notify = Notification,
    UI = UI,
    World = World,
}
for i,v in pairs(Env) do
    getgenv()[i]=v
end
game:GetService'RunService'.RenderStepped:connect(function()
    --[[if uis:IsKeyDown(Enum.KeyCode.F) then
        Character:Teleport(CFrame.new(workspace['shomo2004'].Head.CFrame * Vector3.new(0,0,3),Vector3.new()))
    end]]
end)
LoadGame(game.PlaceId)


wait(5)

--UI:Destroy()