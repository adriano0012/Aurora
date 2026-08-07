
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus Hub - PLS DONATE 🇷🇺", "RJTheme5")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("PLS DONATE")

Section:NewButton("AutoFarm", "Autofarm", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tzechco/roblox-scripts/main/PLS%20DONATE/autofarm.lua'))()
end)

Section:NewButton("Animations (Avaible in hub)", "not visual", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/o5u3/emotesv2/main/script"))()
end)

Section:NewButton("V.G Hub (Avaible in Hub)", "Очень крутой скрипт", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
end)

Section:NewButton("AntiAFK (Chance to kick)", "Багганый не много", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/2dgeneralspam1/scripts-and-stuff/master/scripts/LoadstringypVvhJBq4QNz", true))()
end)

local Tab = Window:NewTab("Credits")

local Section = Tab:NewSection("kurusLK")

local Section = Tab:NewSection("Kurus#6448")

local Section = Tab:NewSection("Developer russian!")


