
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Old Kurus Hub 1.5", "RJTheme1")

local Tab = Window:NewTab("Main")
    
local Section = Tab:NewSection("Main")

Section:NewButton("Click-TP", "idk", function()
    mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Клик-ТП"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
end)

Section:NewSlider("WalkSpeed", "idk", 500, 0, function(s) 
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section:NewButton("Fly", "fly", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Fly2.lua"))()
end)

Section:NewButton("Freecam", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/794d8a95e2fc929a793481526488b9607f32103e/Freecam.lua"))()
end)

Section:NewButton("Aimbot", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/aimbot.lua"))()
end)

Section:NewButton("ESP", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/esp.lua"))()
end)

Section:NewButton("Headless", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/6venTtNA", true))()
end)

Section:NewButton("FE R6", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ErJ7MBCy"))()
end)

Section:NewButton("FE Small avatar (R15)", "idk", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/YSdZRUbc'))()
end)

Section:NewButton("Display Name Remover", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/9JFmENGT"))()
end)

local Tab = Window:NewTab("Guis")

local Section = Tab:NewSection("Guis")

Section:NewButton("Kurus Hub Green Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Green%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Blue Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Blue%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Blood Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Blood%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Grape Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Grape%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Midnight Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Midnight%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Sentinel Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Sentinel%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("Kurus Hub Synapse Edit.", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Synapse%20Kurus%20Hub.lua'),true))()
end)

Section:NewButton("V.G Hub", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
end)

Section:NewButton("Kurus Hub - Bang", "hub", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20bang.lua'))()
end)

Section:NewButton("Kurus Hub - Da Hood", "hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20da%20hood.lua"))()
end)

Section:NewButton("Kurus Hub - PLS DONATE", "hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20PLS%20DONATE.lua"))()
end)

Section:NewButton("Kurus Hub - Mad City", "hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20hub%20-%20Mad%20City.lua"))()
end)

Section:NewButton("Kurus Hub - Murder Mystery 2", "hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Murder%20Mystery.lua"))()
end)

Section:NewButton("Kurus Hub - Build A Boat", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Build%20A%20Boat.lua"))()
end)

Section:NewButton("Kurus Hub - Prison Life", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Prison%20Life.lua"))()
end)

Section:NewButton("Kurus Hub - Lumber Tycoon 2", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Kurus%20Hub%20-%20Lumber%20Tycoon%202.lua"))()
end)

Section:NewButton("Kurus Hub - Breaking Point", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/bEBDTUZb"))()
end)

Section:NewButton("Fe Audio Gui", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Fe%20Audio%20Gui.lua"))()
end)

Section:NewButton("Shed Byppaser", "idk", function()
    loadstring(game:HttpGet("https://the-shed.xyz/roblox/scripts/ChatBypass", true))()
end)

local Tab = Window:NewTab("Admins")

local Section = Tab:NewSection("Admins Scripts")

Section:NewButton("infinity yeild", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
end)

Section:NewButton("Leg's FE Admin", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/leg1337/legadmv2/main/legadminv2.lua'))()
end)

Section:NewButton("Homebrew V2", "idk", function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Syntaxx64/HomebrewAdmin/master/Main"))()
end)

local Tab = Window:NewTab("R6")

local Section = Tab:NewSection("R6 Scripts")

Section:NewButton("Nullware V3", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/nullware.lua'))()
end)

Section:NewButton("FE Default Dance", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Default%20Dance.lua'))()
end)

Section:NewButton("Ptk Animation", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/ptk.lua'))()
end)

Section:NewButton("Fe Neko", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Neko.lua'))()
end)

Section:NewButton("Fe Creepy Crawler", "idk", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/uLKaWuQm'))()
end)

Section:NewButton("Replication GUI R6", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Replication%20R6%20GUI.lua'))()
end)

Section:NewButton("FE Parkour (Update)", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Parkourr.lua"))()
end)

Section:NewButton("FE Parkour V2", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Parkour%20V2.lua"))()
end)

Section:NewButton("FE Sonic", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/K7YSDZsB"))()
end)

Section:NewButton("FE Weelchair", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Wellchair%20script.lua"))()
end)

Section:NewButton("Fe Size GUI", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/vgz5yrhx"))()
end)

Section:NewButton("Fe Curse", "idk", function()
    loadstring(game:HttpGet('https://gist.githubusercontent.com/1BlueCat/8b9b759a86e7f70707a28f7f0a637d92/raw/954003b1de40af5b3568a3d6d94487574b58d92b/FE%2520Cursed%252064'))()
end)

Section:NewButton("Mastrubation", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Mastrubation.lua", true))()
end)

Section:NewButton("Arosia GUI", "idk", function()
    loadstring(Game:GetObjects("rbxassetid://1255908305")[1].Source)()
end)

Section:NewButton("Ry Sonic Animation", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Ry%20Sonic%20animation.lua", true))()
end)

Section:NewButton("FE Rare Animation", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Rare%20Animation%20GUI.lua", true))()
end)

Section:NewButton("Fe Ultimate Meme Dance", "idk", function()
    loadstring(game:HttpGetAsync("https://pastebin.com/raw/0QfjMKrF"))()
end)

Section:NewButton("FE Orange Justice", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/bP8gy3gz"))()
end)

Section:NewButton("FE Chill GUI", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/XmHFdTij"))()
end)

Section:NewButton("Fe Among Us v2", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Amogus'))()
end)

Section:NewButton("FE NetBypass", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20NetBypass.lua", true))()
end)

Section:NewButton("FE Dog", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/D2Y35BRR", true))()
end)

Section:NewButton("FE Krystal Dance", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Lzi4LaZM", true))()
end)

Section:NewButton("FE BTools", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/FmjBwYZ4", true))()
end)

Section:NewButton("FE invisible fling", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/bZAA2SDg", true))()
end)

Section:NewButton("FE Drone", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/GriadDUx", true))()
end)

Section:NewButton("FE Block Spam", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/jCKbca53", true))()
end)

Section:NewButton("FE Naruto Run", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zMLQChbv", true))()
end)

Section:NewButton("FE Xester", "idk", function()
    loadstring(game:HttpGetAsync("https://pastebin.com/raw/RPwyPvEi"))()
end)

Section:NewButton("Clone script", "idk", function()
    loadstring(game:GetObjects('rbxassetid://7339698872')[1].Source)()
end)

Section:NewButton("RemX Trolling GUI", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Henry887/RemX-Script-Hub/main/main.lua'),true))()
end)

Section:NewButton("FE Ragdoll Suicide", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/R9gx46Gm"))()
end)

Section:NewButton("FE Pet", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/paQP1dMX"))()
end)

Section:NewButton("FE Shiba Hub", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BlackieBlox/Scripts/main/%5BFE%5D%20Shiba%20Hub.txt"))()
end)

Section:NewButton("Equinox Hub", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/wzB1Qh78"))()
end)

Section:NewButton("Energize Animation", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/wijBATsH"))()
end)

Section:NewButton("Ez Hub", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/debug420/Ez-Industries-Launcher-Data/master/Launcher.lua'),true))()
end)

Section:NewButton("Basic FE Hub", "idk", function()
    loadstring(game:HttpGet(('https://pastebin.com/raw/KwHp0PsK'),true))()
end)

Section:NewButton("Domain Hub X", "idk", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/DomainX/main/source',true))()
end)

local Tab = Window:NewTab("R15")

local Section = Tab:NewSection("R15 Scripts")

Section:NewButton("Free Emotes V2", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/o5u3/emotesv2/main/script"))()
end)

Section:NewButton("FE Parasite", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/KdSuQXwp"))()
end)

Section:NewButton("invisible", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Invisible%20r15.lua"))()
end)

Section:NewButton("Fe Gun", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Gun.lua'))()
end)

Section:NewButton("Walk On Walls", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/scriptsforvideos1/main/walkonwalls.lua'))()
end)

Section:NewButton("Fe Runner", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/FE%20Runner.lua"))()
end)

Section:NewButton("Avatar Resizer", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/GHR9cRn6", true))()
end)

Section:NewButton("FE Spin Fling", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/JYs9FDhN", true))()
end)

Section:NewButton("FE Gale Fighter", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/MRjfKfAV"))()
end)

Section:NewButton("Breakdance", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/mqEyrQ4V"))()
end)

Section:NewButton("FE Smallify", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/sXZKTtJn"))()
end)

Section:NewButton("FE SpiderMan", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/ItsDishan/SpidermanScript/main/Spider-Man V1.0'), true))()
end)

Section:NewButton("Touch Fling", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zaAF1MEq"))()
end)

local Tab = Window:NewTab("Universals")

local Section = Tab:NewSection("Universal Scripts")

Section:NewButton("Universal Vehicle Speed", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AaronS69420/unca/main/ff"))()
end)

Section:NewButton("Universal hitbox extender", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Universal%20hitbox%20extender.lua"))()
end)

Section:NewButton("Hat Univerasal (Ex first)", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/4B4fktPS", true))()
end)

Section:NewButton("Hat Univerasal (Ex last)", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/w5BrRzT9"))()
end)

Section:NewButton("Universal Hub", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Dvrknvss/UniversalFEScriptHub/main/Script'))()
end)

local Tab = Window:NewTab("R15 and R6")

local Section = Tab:NewSection("R15 and R6")

Section:NewButton("FE Ban Hammer", "idk", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/3KPqu4iP'))()
end)

Section:NewButton("Fe Nameless Animations V4", "idk", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/d3uB90XA'))()
end)

Section:NewButton("FE Punch Kill", "idk", function()
    loadstring(game:HttpGet('https://pastebin.com/raw/uDRj8UJh'))()
end)

Section:NewButton("Dino Hub", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DinosaurXxX/dinohub/main/DinoHub"))()
end)

Section:NewButton("Fe Blackhole", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Q3Fjw3PZ"))()
end)

local Tab = Window:NewTab("Hats Scripts")

local Section = Tab:NewSection("Hat Needed")

Section:NewButton("Fling Gun", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/TH1p4f5t"))()
end)

Section:NewButton("Fe Free Hat Hub", "idk", function()
    loadstring(game:HttpGet("https://textbin.net/raw/rvohv1nvuf"))();
end)

Section:NewButton("FE Saitama", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/NTFLTfBS"))();
end)

Section:NewButton("Fe Blue Flame Hoverboard", "idk", function()
    loadstring(game:HttpGet(('https://pastebin.com/raw/U2VHEdFB'),true))()
end)

Section:NewButton("Fe Pickaxe", "idk", function()
    loadstring(game:HttpGet(('https://pastebin.com/raw/7hXaQfYD'),true))()
end)

local Tab = Window:NewTab("Credits")

local Section = Tab:NewSection("Credits")

Section:NewButton("kurusLK", "idk", function()
    print("kurusLK")
end)

Section:NewButton("Kurus#6448", "idk", function()
    print("Kurus#6448")
end)

Section:NewButton("Discord", "Discord RU", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Kurus00/ABOBA/main/Discrod%20gui.lua"))()
end)

local Tab = Window:NewTab("Keybinds")

local Section = Tab:NewSection("Freecam")

local Section = Tab:NewSection("Shift+P")

local Section = Tab:NewSection("Fly")

local Section = Tab:NewSection("E")







