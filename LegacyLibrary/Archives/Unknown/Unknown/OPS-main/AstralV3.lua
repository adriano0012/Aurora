local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title = "Project Astral",
    Footer = "v1.2",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})



local MainTab = Window:AddTab("Main", "building") -- Second parameter is the icon name (optional)


    local LeftGroupbox = MainTab:AddLeftGroupbox("hubs")
local RightGroupbox = MainTab:AddRightGroupbox("General")

local Button = LeftGroupbox:AddButton({
    Text = "Legacy Project astral",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jwjshdiwj/Project-astro-Sb-Legacy/refs/heads/main/Legacy%20ver"))();
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Project Astral Original",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jwjshdiwj/Project-Astro/refs/heads/main/Project%20Astro"))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Vinq",
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/vinqDevelops/erwwefqweqewqwe/refs/heads/main/lol.txt'))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Badge hub",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/UltimateBadgeHub/refs/heads/main/main.lua",true))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Bacon Mastery",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0-BaconScripter-0/Script/refs/heads/main/Slap%20Battles/Mastery%20Farm"))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Mastery Donjo",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/MasteryHelper.NewestVersion",true))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Alchamist Abuser",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Testerhubplayer/Slap-battle/main/Slap_battle_alchemist_edition.lua",true))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = LeftGroupbox:AddButton({
    Text = "Project Echo Backup",
    Func = function()
        loadstring(game:HttpGet("https://pastefy.app/1wt162jE/raw",true))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = RightGroupbox:AddButton({
    Text = "Anticheat",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Pro666Pro/BypassAntiCheat/refs/heads/main/main.lua",true))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = RightGroupbox:AddButton({
    Text = "NickName",
    Func = function()
        while wait() do game.Players.LocalPlayer.Character.Head.Nametag.TextLabel.Text = "Astro" end
    end,
    DoubleClick = false -- Requires double-click for risky actions
})
            
local gloveTab = Window:AddTab("Gloves", "hand")
local LeftGroupbox = gloveTab:AddLeftGroupbox("Mojos Gloves")
local RightGroupbox = gloveTab:AddRightGroupbox("Other Gloves")

local Button = RightGroupbox:AddButton({
    Text = "SprgGlove",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Jwjshdiwj/SPRG-glove/refs/heads/main/SPRG"))();
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = RightGroupbox:AddButton({
    Text = "Killerfish",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/Killerfish.txt"))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})

local Button = RightGroupbox:AddButton({
    Text = "Sans",
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/SansGloveFinished'))()
    end,
    DoubleClick = false -- Requires double-click for risky actions
})
