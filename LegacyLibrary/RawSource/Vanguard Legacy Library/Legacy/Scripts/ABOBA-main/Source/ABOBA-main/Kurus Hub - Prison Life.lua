
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus Hub - Prison Life", "RJTheme1")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("Prison Life")

Section:NewButton("Admin Commands", "you admin", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/PrisonLife'),true))()
end)

Section:NewButton("Prisonners GUI", "idk", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Kurus00/ABOBA/main/Prison%20life%20script.lua'),true))()
end)

