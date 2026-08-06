local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("Kurus-Ware! - Scripts", "RJTheme2")

local Tab = Window:NewTab("Scripts")

local Section = Tab:NewSection("Murder Mystery 2")

Section:NewButton("EzScripts.win", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TurfuFrogy/EzScripts/main/loader.lua"))()
end)

Section:NewButton("Xenny-ware", "idk", function()
    repeat wait() until game.Players.LocalPlayer.Character
url = "https://raw.githubusercontent.com/xennyy/Xenny-Ware/main/loader.lua"
loadstring(game:HttpGet(url))()
end)

Section:NewButton("Eclipse Hub (Only KRNL)", "idk", function()
    getgenv().mainKey = "nil" local a,b,c,d,e=loadstring,request or http_request or (http and http.request) or (syn and syn.request),assert,tostring,"https://api.eclipsehub.xyz/auth"c(a and b,"Executor not Supported")a(b({Url=e.."\?\107e\121\61"..d(mainKey),Headers={["User-Agent"]="Eclipse"}}).Body)()

end)

Section:NewButton("V.G Hub (avaible in hub)", "idk", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
end)

Section:NewButton("JayHub", "idk", function()
    loadstring(game:HttpGet("https://jack1214060.xyz/jayhub",true))()
end)

Section:NewButton("Helios Hub", "idk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Helios-Hub/main/Loader.lua"))()
end)

Section:NewButton("Supreme`s", "idk", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Njs5gZfZ"))()
end)
