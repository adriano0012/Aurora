
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus Hub - Build A Boat", "RJTheme7")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("Build A Boat For Treashure")

Section:NewButton("Eclipse Hub (Only KRNL)", "idk", function()
    getgenv().mainKey = "nil"
 
local a,b,c,d,e=loadstring,request or http_request or (http and http.request) or (syn and syn.request),assert,tostring,"https://api.eclipsehub.xyz/auth"c(a and b,"Executor not Supported")a(b({Url=e.."\?\107e\121\61"..d(mainKey),Headers={["User-Agent"]="Eclipse"}}).Body)()
end)

Section:NewButton("Pog Hub", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/03koios/Loader/main/Loader.lua"))()
end)





