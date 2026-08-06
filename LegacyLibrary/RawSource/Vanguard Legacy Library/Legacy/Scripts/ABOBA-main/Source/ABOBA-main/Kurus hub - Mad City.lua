
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus Hub - Mad City", "RJTheme1")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("Mad City")

Section:NewButton("Ruby Hub 1.3", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Deni210/madcity/main/Ruby%20Hub%20v1.3", true))()
end)

Section:NewButton("Zephyr X (Key System)", "idk", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ECLIPSEXHUB/ECLIPSE-X/main/ECLIPSE%20X.txt", true))()
        end)
end)

Section:NewButton("AutoFarm (Key - Frost_27824375) ", "idk", function()
    loadstring(game:HttpGet('https://scripts.luawl.com/11900/MadcityFarm.lua'))()
end)

Section:NewButton("XPFarm", "idk", function()
    getgenv().key = 'Frost_4646746'
loadstring(game:HttpGet("https://raw.githubusercontent.com/Brizzy9999/scripts/main/madcityxpfarm"))()
end)

Section:NewButton("ServerHop", "idk", function()
    getgenv().key = 'Frost_4646746'
loadstring(game:HttpGet('https://raw.githubusercontent.com/Brizzy9999/scripts/main/madcityserverhop'))()
end)






