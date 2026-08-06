
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
     IntroText = "Project Astro",
     IntroIcon = "rbxassetid://7733964640",
     Name = "Project Astro | SB",
     SearchBar = {
         Default = "Search Tabs",
         ClearTextOnFocus = true
     },
     IntroToggleIcon = "rbxassetid://7733964640",
     HidePremium = false, 
     SaveConfig = false,
     IntroEnabled = true,
     ConfigFolder = "slap battles"
}) 


OrionLib:MakeNotification({
	Name = "Welcome",
	Content = "Welcome To Project Astro Have fun Lmfao",
	Image = "rbxassetid://4483345998",
	Time = 5
})

OrionLib:MakeNotification({
	Name = "Script Status",
	Content = "Legacy Version",
	Image = "rbxassetid://4483345998",
	Time = 10
})


local Tab = Window:MakeTab({
	Name = "The Slap Battles Hub 🥶",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Incongito Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/mBB0bKaM/raw",true))()
  	end    
})


Tab:AddButton({
	Name = "Article Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/tanhoangviet/Article-Hub/refs/heads/main/Slap_Battles.lua",true))()
  	end    
})


Tab:AddButton({
	Name = "Destroyer X",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Aquoupi/DestroyerX/main/DestroyerX"))()
  	end    
})

Tab:AddButton({
	Name = "Vgxmod ",
	Callback = function()
      		loadstring(game:HttpGet("https://rawscripts.net/raw/THE-GAMES-Slap-Battles-Vgxmod-Hub-16600"))()
  	end    
})

Tab:AddButton({
	Name = "KykyryzoB Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://rawscripts.net/raw/Slap-Battles-KykyryzoB-Hub-SB-9008"))()
  	end    
})

Tab:AddButton({
	Name = "Slap battle hub that exist",
	Callback = function()
      		loadstring(game:HttpGet(("https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Slap%20Battles")))()
  	end    
})

Tab:AddButton({
	Name = "Gaster Hub v2",
	Callback = function()
      		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Dusty1234567890/Loader/main/GHUBV0.2.")))()
  	end    
})


Tab:AddButton({
	Name = "Forge Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Skzuppy/forge-hub/main/loader.lua"))()
  	end    
})


Tab:AddButton({
	Name = "GFET Hub",
	Callback = function()
      		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Latundra/GFET/main/script")))()
  	end    
})

Tab:AddButton({
	Name = "SBS Hub",
	Callback = function()
      		loadstring(game:HttpGet('https://pastebin.com/raw/t9XmdEFT'))()
  	end    
})

Tab:AddButton({
	Name = "Giang Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Slap_Battles/main/Slap_Battles.lua",true))()
  	end    
})

Tab:AddButton({
	Name = "Coder Script hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter-Coder/Scripter-Coder/refs/heads/main/Slap%20Battles/Script%20Hub"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Grinding Script",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Slap Farm gui v3 by nexer",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/slapfarmgui/main/main.lua'))()
  	end    
})

Tab:AddButton({
	Name = "Nexer Ultimate badge hub v3 ",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/UltimateBadgeHub/main/main.lua'))()
  	end    
})


Tab:AddButton({
	Name = "Slappler Farm",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Cortzalno666/NectoVerse-Industries-Data/master/Scripts%20Folder/Auto.Slapple'))()
  	end    
})


Tab:AddButton({
	Name = "Auto Get Snowroller",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/KBhl26F1/raw"))()
  	end    
})

Tab:AddButton({
	Name = "Coder Mastery Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter-Coder/Scripter-Coder/refs/heads/main/Slap%20Battles/Mastery%20Gui"))()
end
})

Tab:AddButton({
	Name = "Auto get pillow Donjosx",
	Callback = function()
      		for i,v in pairs(game:GetService("Workspace").map:GetChildren()) do
    if v.Name:find("pillow") then
        local cd = v:FindFirstChildWhichIsA("ClickDetector")
        if cd then
            fireclickdetector(cd)
        else
            fireclickdetector(v)
        end
    end
end
  	end    
})

Tab:AddButton({
	Name = "Incongito Slap farm",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapFarmScript/refs/heads/main/SlapFarmOP"))()
  	end    
})

Tab:AddButton({
	Name = "Incongito Kilstreak Farm script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/KillstreakFarm"))()
  	end    
})

Tab:AddButton({
	Name = "Coder Badge hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripter-Coder/Scripter-Coder/refs/heads/main/Slap%20Battles/Launcher%20Script%20(Badges%20Hub)"))()
  	end    
})

Tab:AddButton({
	Name = "Auto Get Frostbite By donjosx",
	Callback = function()
      		if  game.PlaceId ~= 17290438723 then
game:GetService("TeleportService"):Teleport(17290438723)
elseif game.PlaceId == 17290438723 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-558, 182, 54)
local function fireAllProximityPrompts()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            fireproximityprompt(descendant)
        end
    end
end

-- Trigger all ProximityPrompts
fireAllProximityPrompts()
end
  	end    
})

Tab:AddButton({
	Name = "Auto get clock glove by nexer",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/AutoGetClock/main/main.lua'))()
  	end    
})

Tab:AddButton({
	Name = "auto get boxer glove (nexer)",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/autogetboxerglove/main/main.lua'))()
  	end    
})

Tab:AddButton({
	Name = "Auto get Fan glove (nexer)",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/autogetfanglove/main/main.lua'))()
  	end    
})

Tab:AddButton({
	Name = "Donjo Mastery Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Mastery-HelperGui"))()
  	end    
})

Tab:AddButton({
	Name = "Donjo Boxer Farm",
	Callback = function()
      		DurationTimeSHOP = math.huge -- math.huge is inf, u can also edit to number like 10s to server hop
loadstring(game:HttpGet("https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Boxer-slap-farm"))()
  	end    
})

Tab:AddButton({
	Name = "Auto bind glove (Donjo)",
	Callback = function()
      		
if game.PlaceId ~= 74169485398268 then
game:GetService("TeleportService"):Teleport(74169485398268)
elseif game.PlaceId == 74169485398268 then
for i,v in pairs(workspace:GetDescendants()) do
if v.Name:find("Shadow") then
v:Destroy()
end
if v.Name:find("rock chain glove_defaultglove_cell") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
end
end
end
  	end    
})


local Tab = Window:MakeTab({
	Name = "Troll Scripts",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Server Crasher By sigma mojjos ( need grapple)",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/SuperCrasher!!!Uwa!SoLag%3Askull%3ADontAskWhyISTheLinkSoLongLol%2CILikeItAlsoRememeberYouHaveToEquipGrappleToUseThisScript%3E-%3C'))()
-- Hehehaha
  	end    
})

Tab:AddButton({
	Name = "Ping Pong Fling all script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/1LIFEY1/slap-battle-scripts/refs/heads/main/fling%20all%20obf",true))()
end
})

Tab:AddButton({
	Name = "Incongito Server Crasher Script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/ServerDestroyer"))()
  	end    
})


Tab:AddButton({
	Name = "DonjoSx Edgelord v4",
	Callback = function()
      		edgelordsetting = {
    HideClientVFX = false,
    SlapstickPush = false
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Donjosx/SBScriptsLink/refs/heads/main/DonjoSx's-edgelord-FE.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Donjosx Alchemist Absuer",
	Callback = function()
      		BypassAlchemistPotion = true -- turn off if it lag u
local AlchemistAbuser = loadstring(game:HttpGet('<https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Alchemist%20abuser.lua'))()
end
})

Tab:AddButton({
	Name = "Donjosx Utg Abuser",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Donjosx/GenZ/refs/heads/main/UTG%20Abuser.lua"))()
  	end    
})

Tab:AddButton({
	Name = "mojjos Server Destroyer",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/SBSDMojjos.lua'))()
  	end    
})

Tab:AddButton({
	Name = "Hitbox increaser",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Ungravved/OP-HITBOX-ABUSER/refs/heads/main/Pacman"))()
  	end    
})

Tab:AddButton({
  Name = " inco Sans glove (non godmode) ", 
  Callback = function() 
_G.GodMode = false --[SET TO TRUE IF YOU WANT GODMODE]
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/SansGlove"))()
   end
}) 

Tab:AddButton({
  Name = " inco Sans glove (Godmode) ", 
  Callback = function() 
_G.GodMode = true --[SET TO TRUE IF YOU WANT GODMODE]
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/SansGlove"))()
   end
}) 

Tab:AddButton({
  Name = "Death glove mojjos", 
  Callback = function() 


loadstring(game:HttpGet("https://rawscripts.net/raw/Slap-Battles-Death-Glove-Script-30411"))()


   end
}) 

Tab:AddButton({
	Name = "Aquoupi Kick Script",
	Callback = function()
      		local mode = "Recall" -- You can change to "Swapper" if you don't have the glove.
if mode == "Recall" then
loadstring(game:HttpGet("https://raw.githubusercontent.com/AquoupiRblx/SlapBattles/refs/heads/main/KickUIRecall.lua"))()
elseif mode == "Swapper" then 
loadstring(game:HttpGet("https://raw.githubusercontent.com/AquoupiRblx/SlapBattles/refs/heads/main/KickUISwapper.lua"))()
end
  	end    
})


Tab:AddButton({
	Name = "Oven Abuser Script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Ungravved/OP-OVEN-ABUSER-/refs/heads/main/jail.txt"))()
  	end    
})


Tab:AddButton({
	Name = "Lobby fling",
	Callback = function()
      		loadstring(game:HttpGet(('https://pastefy.app/jO9lFyRs/raw')))()
  	end    
})


Tab:AddButton({
	Name = "Alchemist Abuser Script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Testerhubplayer/Slap-battle/main/Slap_battle_alchemist_edition.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Donjosx Killerfish glove",
	Callback = function()
      		getgenv().DonjoSxKillerfish = {
            FlopPower = 90, -- flop power 
            RamMode = false -- rewrite it to true will make ur fish can attack while flop like a car
        }
loadstring(game:HttpGet("https://raw.githubusercontent.com/Donjosx/SBScriptsLink/refs/heads/main/DonjoSx'sKillerfish.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Ban Evidence script (Aquoupi)",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/AquoupiRblx/SlapBattles/refs/heads/main/BanEvidence.lua"))()
      end
})


Tab:AddButton({
	Name = "Fan Fling script",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/XPhPgVpJ/raw"))()
  	end    
})

Tab:AddButton({
	Name = "No Cooldown script (Updated)",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/TZeZl1GK/raw"))()
--[[
Disclaimber: Very risky to use, use alt to use this script with vpn, dual space clone app to avoid ban
Use at your own risk. also you MUST EQUIP GLOVE BEFORE USE!]]--
  	end    
})

Tab:AddButton({
	Name = "Brick Abuser Donjo",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Brick-Abuser.lua'))()
  	end    
})

Tab:AddButton({
	Name = "Fake Glovel Mastery (Donjo)",
	Callback = function()
      		getgenv().FakeMastery = {
	Enable = true, -- false to disable it
	ExplosionVFX = true -- using retro bomb to fake ability vfx
}
loadstring(game:HttpGet(('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/%5BFake%5DGlovelMastery'),true))()
  	end    
})

Tab:AddButton({
	Name = "Schlob Mastery",
	Callback = function()
      		loadstring(game:HttpGet(('<https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/schlob-matstery.lua'),true))()
  	end    
})

Tab:AddButton({
	Name = "Fe Glove Morph",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Glove-Morph'))()
  	end    
})

Tab:AddButton({
	Name = "Mace Custom Mastery",
	Callback = function()
      		loadstring(game:HttpGet(('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Mace-Mastery.lua'),true))() --Requires macee
  	end    
})

local Tab = Window:MakeTab({
	Name = "Slap Royale Scripts",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Slap Royale instant Win (no gui)",
	Callback = function()
      		local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local missileDestroyer = coroutine.create(function()
    while true do
        for _, object in pairs(workspace:GetDescendants()) do
            if object.Name == "Missile" then
                object:Destroy()
            end
        end
        wait(0.001)
    end
end)

coroutine.resume(missileDestroyer)

wait(1)
for i = 1, 70 do
    local allPlayers = Players:GetPlayers()
    for _, player in ipairs(allPlayers) do
        if player and player.Character then
            local args = {
                [1] = Players.LocalPlayer.Character:FindFirstChild("Missile-Launcher"),
                [2] = player.Character
            }
            ReplicatedStorage.Events.Ability:FireServer(unpack(args))
        end
    end
end
  	end    
})


Tab:AddButton({
	Name = "Article Hub Slap Royale",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Slap_Battles/main/Slap_Battles.lua",true))()
  	end    
})

Tab:AddButton({
	Name = "Incongito Slap Royale Auto win",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapRoyale/refs/heads/main/InstantWinScript"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "SPRG squad Scripts",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Fe Killerfish ",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/Killerfish.txt"))()
  	end    
})

Tab:AddButton({
	Name = "Brick Controll script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/BrickControl"))()
  	end    
})



Tab:AddButton({
	Name = "Spy Default script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/Spy-default-script/refs/heads/main/UpgradeSpyDefault"))()
  	end    
})

Tab:AddButton({
	Name = "Slap Royale instant Win",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Reallyools/Reallyools/refs/heads/main/Slaproyale"))()
  	end    
})

Tab:AddButton({
	Name = "Fe Kilstreak 1000",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/Fe1000Killstreak"))()
  	end    
})

Tab:AddButton({
	Name = "Edgelord By David",
	Callback = function()
      		loadstring(game:HttpGet("https://pastebin.com/raw/sKyhBjMc"))();
  	end    
})

Tab:AddButton({
	Name = "Rogue Like 2x Exp",
	Callback = function()
      		loadstring(game:HttpGet("https://pastebin.com/raw/xNHnhGS1"))();
  	end    
})

Tab:AddButton({
	Name = "Attack on titan by kiet scripter",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/AttackTitanTest"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Kizzy scripts ",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Auto Clock",
	Callback = function()
      		loadstring(game:HttpGet('https://pastefy.app/wS5nVbFa/raw'))()
  	end    
})

Tab:AddButton({
	Name = "Auto Utg",
	Callback = function()
      		loadstring(game:HttpGet('https://pastefy.app/7wa9YBji/raw'))()
  	end    
})

Tab:AddButton({
	Name = "Auto Mouse",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/fizzyscripting/Slap-Battles/refs/heads/main/AutoMouseOBF"))()
  	end    
})

Tab:AddButton({
	Name = "Edgelord mobile",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/fizzyscripting/Slap-Battles/refs/heads/main/Protected_1228684030236895.txt"))()
  	end    
})

Tab:AddButton({
	Name = "Edgelord Pc",
	Callback = function()
      		loadstring(game:HttpGet('https://pastefy.app/hnNzIvWv/raw'))()
  	end    
})

Tab:AddButton({
	Name = "kizzy name tag modifier",
	Callback = function()
      		_G.enabled = false

getgenv().names = {
"Username1",
"Username2",
"Username3",
"Username4",
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/fizzyscripting/Slap-Battles/refs/heads/main/NicknameModifierOBF"))()
  	end    
})


local Tab = Window:MakeTab({
	Name = "Texis Script ",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Plushie Script (Doors)",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Jwjshdiwj/Plushiee/refs/heads/main/Rah"))();
  	end    
})

local Tab = Window:MakeTab({
	Name = "Bacon scripter Scripts",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Auto get Hexa",
	Callback = function()
      		loadstring(game:HttpGet("https://ghostplayer352.github.io/Authorization/"))()Ioad("8b701ad1f070d67935fe2008c08b7244")
  	end    
})

Tab:AddButton({
	Name = "Auto Get Mouse",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/mW6SplbD/raw"))()
  	end    
})

Tab:AddButton({
	Name = "Instant Snowroller",
	Callback = function()
      		loadstring(game:HttpGet("https://pastefy.app/KBhl26F1/raw"))()
  	end    
})

Tab:AddButton({
	Name = "Mastey Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/0-BaconScripter-0/Script/refs/heads/main/Slap%20Battles/Mastery%20Farm"))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})


Tab:AddButton({
	Name = "Infinite yield",
	Callback = function()
      		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  	end    
})

Tab:AddButton({
	Name = "Nameless Admin",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))();
  	end    
})

Tab:AddButton({
	Name = "Quirky Command ",
	Callback = function()
      		
loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))()
  	end    
})


Tab:AddButton({
	Name = "Fly gui v3",
	Callback = function()
      		loadstring(game:HttpGet('https://pastebin.com/raw/YSL3xKYU'))()
  	end    
})

Tab:AddButton({
	Name = "Teleport tool",
	Callback = function()
      		-- Teleport Tool Script
local ToolName = "Advanced Teleport Tool"

local function createTool()
    -- Create the tool
    local tool = Instance.new("Tool")
    tool.Name = ToolName
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    -- Add the tool to the player’s backpack
    tool.Parent = game.Players.LocalPlayer.Backpack

    -- Teleport on activation
    tool.Activated:Connect(function()
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local targetPos = mouse.Hit.p

        -- Teleport the player to the mouse position
        player.Character:MoveTo(targetPos)
    end)
end

-- Function to handle respawning the tool
local function onCharacterAdded(character)
    createTool()
end

-- Set up tool and handle respawning
game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
createTool()
  	end    
})

Tab:AddButton({
	Name = "Noclip script",
	Callback = function()
      		loadstring(game:HttpGet("https://pastebin.com/raw/B5xRxTnk",true))()
  	end    
})

Tab:AddButton({
	Name = "Touch Fling",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))()
  	end    
})

Tab:AddButton({
	Name = "universal camlock script",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/brosula123/CAMLOCK/main/SKIBIDI"))()
  	end    
})

Tab:AddButton({
	Name = "Rochip Panel",
	Callback = function()
      		if "you wanna use rochips universal" then
    local z_x,z_z="gzrux646yj/raw/main.ts","https://glot.io/snippets/"
    local im,lonely,z_c=task.wait,game,loadstring
    z_c(lonely:HttpGet(z_z..""..z_x))()
    return ("This will load in about 2 - 30 seconds" or "according to your device and executor")
end
  	end    
})

Tab:AddButton({
	Name = "Fake Lag",
	Callback = function()
      		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fe-Fake-Lag-13902"))()
  	end    
})

Tab:AddButton({
	Name = "Invisible script",
	Callback = function()
      		loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
  	end    
})

local Tab = Window:MakeTab({
	Name = "For scripting",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Dex explorer keyless",
	Callback = function()
      		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Keyless-mobile-dex-17888"))()
  	end    
})

Tab:AddButton({
	Name = "Wynerd(for looking secret games)",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/ckw69/Wyborn/main/wyborn",true))()
  	end    
})

Tab:AddButton({
	Name = "Remote spy",
	Callback = function()
      		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
  	end    
})

Tab:AddButton({
	Name = "P gui maker",
	Callback = function()
      		loadstring(game:HttpGet(('https://pastefy.app/EOgPqinS/raw'),true))()
  	end    
})

Tab:AddButton({
	Name = "Turtle Spy",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/Turtle%20Spy.lua"))()
  	end    
})

Tab:AddButton({
	Name = "Adonis Anticheat Bypass",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

  	end    
})

Tab:AddButton({
	Name = "Remote Hub",
	Callback = function()
      		loadstring(game:HttpGet("https://raw.githubusercontent.com/zephyr10101/RemoteHub/main/Main",true))()
  	end    
})

Tab:AddButton({
	Name = "Hydroxide",
	Callback = function()
      		local owner = "Hosvile"
local branch = "revision"

local function webImport(file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/MC-Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
end

webImport("init")
webImport("ui/main")
  	end    
})


local Tab = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://7734053426",
	PremiumOnly = false
})

Tab:AddLabel("YouTube Channels")
Tab:AddLabel("Sprg Scripts")

Tab:AddButton({
	Name = "Sprg Yt",
	Callback = function()
      		setclipboard("https://youtube.com/@thesprg?si=oqdpG2-zb_Wx4fKp")

  	end    
})
Tab:AddLabel("Project Astro Yt")
Tab:AddButton({
	Name = "Project Astro Yt",
	Callback = function()
      		setclipboard("https://youtube.com/@averagerobloxplayer-i8i?si=wL5esBCUO5bifhYr")

  	end    
})

Tab:AddLabel("Sprg Discord link")
Tab:AddButton({
Name = "Sprg Discord",
	Callback = function()
      		setclipboard("https://dsc.gg/sprg-squad")

  	end    
})
Tab:AddLabel("Project Astro Discord link")
Tab:AddButton({
Name = "Project Astro Discord link",
	Callback = function()
      		setclipboard("https://discord.gg/3vwxhT8s")

  	end    
})


local Tab = Window:MakeTab({
	Name = "Credits 2",
	Icon = "rbxassetid://7743876054",
	PremiumOnly = false
})

Tab:AddLabel("Credits To kizzy")
Tab:AddLabel("Credits To Texis")
Tab:AddLabel("Credits To Bacon Scripter")

Tab:AddButton({
Name = "Kizzy Server Link",
	Callback = function()
      		setclipboard("https://discord.gg/homosex")

  	end    
})

Tab:AddButton({
Name = "Bacon Scripter Server Link",
	Callback = function()
      		setclipboard("https://discord.gg/fqNVnBTY")

  	end    
})

Tab:AddButton({
Name = "Texis Server Link",
	Callback = function()
      		setclipboard("https://discord.gg/Aqc4yzek")

  	end    
})