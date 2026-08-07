local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Slap Battles Hub",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })


 local badgesTab = Window:CreateTab("badges", 4483362458) -- Title, Image
 


 local Button = badgesTab:CreateButton({
    Name = "BypassAntiCheat",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/Pro666Pro/BypassAntiCheat/blob/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })




 print(game.Players.LocalPlayer.leaderstats.Slaps.Value)
 print(game.Players.LocalPlayer.AccountAge)
 local Button = badgesTab:CreateButton({
    Name = "Please click its info",
    Callback = function()
        Rayfield:Notify({
            Title = "Hi",
            Content = "Use /Console for info of your stats",
            Duration = 6.5,
            Image = 4483362458,
         })
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Metaverse",
    Callback = function()
            loadstring(game:HttpsGet("https://raw.githubusercontent.com/Pro666Pro/AutoGetMetaverse/refs/heads/main/OpenSource.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Hexagon",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/AutoGetHexagon/refs/heads/main/OpenSource.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Mouse",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/AutoGetMouse/refs/heads/main/OpenSource.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Bob",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/AutoGetBob/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Untitled Tag",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/autogettagglove/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "Auto-Get Clock",
    Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/AutoGetClockExtended/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local Button = badgesTab:CreateButton({
    Name = "FishVoodooTrap",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/fish-voodoo-trap/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisTab = Window:CreateTab("Guis", 4483362458) -- Title, Image
 

 
 local GuisButton = GuisTab:CreateButton({
    Name = "King Sbeve",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/KingSbeve/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })


 local GuisButton = GuisTab:CreateButton({
    Name = "SlapBattles",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/SlapBattles/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "MasteryFarm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/MasteryFarmGui/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Slap Farm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/slapfarmgui/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Mastery Farm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/MasteryFarmGui/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Badge Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/UltimateBadgeHub/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Nametag",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/Change_Nametag/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Recall",
    Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/recallcheatsheet/refs/heads/main/main.lua",true))()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Bob2",
    Callback = function()
        loadstring(game:HttpGet"https://pastefy.app/7qbY4h0Z/raw")()
    -- The function that takes place when the button is pressed
    end,
 })

 local GuisButton = GuisTab:CreateButton({
    Name = "Guide boss",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Ty7G6BXs/raw"))()
    -- The function that takes place when the button is pressed
    end,
 })
