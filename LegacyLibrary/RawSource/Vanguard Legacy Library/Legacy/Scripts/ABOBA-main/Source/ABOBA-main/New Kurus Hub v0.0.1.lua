local SimpleUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/naypramx/Ui__Project/Script/Asss"))()
local Ui = SimpleUi:Win('Kurus Hub v0.0.1')
local Chanel = Ui:Channel('Main')

local Page = Chanel:Addpage('Main?')

Page:Button("Click TP",function()
    mouse = game.Players.LocalPlayer:GetMouse()
    tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Click - TP"
    tool.Activated:connect(function()
    local pos = mouse.Hit+Vector3.new(0,2.5,0)
    pos = CFrame.new(pos.X,pos.Y,pos.Z)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end)
    tool.Parent = game.Players.LocalPlayer.Backpack
end)

Page:Button("Fly",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Fly2.lua"))()
end)

Page:Button("Freecam",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/794d8a95e2fc929a793481526488b9607f32103e/Freecam.lua"))()
end)

Page:Button("Aimbot",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/aimbot.lua"))()
end)

Page:Button("ESP",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/esp.lua"))()
end)

Page:Button("Headless",function()
    loadstring(game:HttpGet("https://pastebin.com/raw/6venTtNA", true))()
end)

Page:Label('Page 1')
Page:line(1)

Page:Button("FE R6",function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ErJ7MBCy"))()
end)

Page:Button("Small Avatar (R15)",function()
    loadstring(game:HttpGet('https://pastebin.com/raw/YSdZRUbc'))()
end)

Page:Button("Display Name Remover",function()
    loadstring(game:HttpGet("https://pastebin.com/raw/9JFmENGT"))()
end)

Page:Label('Page 2')
Page:line(2)

Page:Button("Old Kurus Hub 1.5",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/The%20End!%20Old%20Kurus%20Hub%201.5.lua"))()
end)

Page:Button("V.G Hub",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
end)

Page:Button("K. Hub - Bang",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20bang.lua'))()
end)

Page:Button("K. Hub - Da Hood",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20da%20hood.lua"))()
end)

Page:Button("K. Hub - PLS DONATE",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20PLS%20DONATE.lua"))()
end)

Page:Button("K. Hub - Mad City",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20Mad%20City.lua"))()
end)

Page:Button("K. Hub - MM2",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Murder%20Mystery.lua"))()
end)

Page:Label('Page 3')
Page:line(1)

Page:Button("K. Hub - Build A Boat",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Build%20A%20Boat.lua"))()
end)

Page:Button("K. Hub - Prison Life",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Prison%20Life.lua"))()
end)

Page:Button("K. Hub - LT2",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Lumber%20Tycoon%202.lua"))()
end)

Page:Button("K. Hub - BP",function()
    loadstring(game:HttpGet("https://pastebin.com/raw/bEBDTUZb"))()
end)

Page:Label('Page 4')
Page:line(2)
