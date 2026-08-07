
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus Hub - Da Hood 🇷🇺", "RJTheme4")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("Da Hood")

Section:NewButton("Zapped", "Заппед.", function(s) 
    loadstring(game:HttpGet('https://ekso.gq/raw/relases/zapped.lua'))()
end)

Section:NewButton("SpaceX", "Спэйсикс.", function(s) 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/spacexrandom/Lua/main/DaHood", true))()
end)

Section:NewButton("Vortex", "Вортекс.", function(s) 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ImagineProUser/vortexdahood/main/vortex", true))()
end)

Section:NewButton("Jojo Stand", "ДжоДжо.", function(s) 
    getgenv().settings =  {
        ['Stand'] =1, --userid of the stand
        ['Owner'] =2, -- userid of the jojo stand owner
     }
     getgenv().commands =  {
         ['Summon'] = "Summon!", -- if someone else wants to own the stand.
         ['Follow'] = "Follow!", -- follow/unfollow you
         ['Ghost'] = "Disappear!", -- disappear
         ['Unghost'] = "Appear!", -- appear
         ['Attack'] = "Ora!", -- loop attack a target
         ['Stopattack'] = "Booga!", -- stop attacking the target
         ['Void'] = "Void!", -- send the target to the void when ko (goes with attack)
         ['Godmode'] = "Requiem!", -- enable/disable godmode
         ['Autosave'] = "Save!", -- grab you when k.o 
         ['Autosave2'] = "Bird!", -- send you in the air when k.o
         ['Reset'] = "Stop!", -- resets commands and character (debug)
     }
     loadstring(game:HttpGet("https://raw.githubusercontent.com/racemodex/my-scripts/master/dahoodjojostand", true))()
end)

Section:NewButton("Slammys GUI", "Слайм.", function(s) 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/dh3", true))()
end)

Section:NewButton("Arctic v9.7", "Антарктида.", function(s) 
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/PolarWasHere/Arctic/main/Arctic"))()
end)

Section:NewButton("SwagMode V0.0.2", "Свэг.", function(s) 
    loadstring(game:HttpGet('https://raw.githubusercontent.com/lerkermer/lua-projects/master/SwagModeV002'))()
end)

local Tab = Window:NewTab("Credits")

local Section = Tab:NewSection("kurusLK")

local Section = Tab:NewSection("Kurus#6448")
