local Window = Rayfield:CreateWindow({
    Name = "Echo Hub",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "By Corrupt_Echo",
    Theme = "Amythyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = false,
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

 local Tab = Window:CreateTab("Tab Example", "apeture")

 local Button = Tab:CreateButton({
    Name = "Rochips admin commands",
    Callback = function()
    -- The function that takes place when the button is pressed
    loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/new/refs/heads/main/cmd.lua"))()
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Rochips universal",
    Callback = function()
    -- The function that takes place when the button is pressed
    loadstring(game:HttpGet("https://pastebin.com/raw/wc8Mhebe",true))()
    end,
 })

 local Divider = Tab:CreateDivider()

 local Button = Tab:CreateButton({
    Name = "Inf yeild",
    Callback = function()
    -- The function that takes place when the button is pressed
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
 })

 local Button = Tab:CreateButton({
    Name = "Invisibility",
    Callback = function()
    -- The function that takes place when the button is pressed
    loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
    end,
 })

 local Divider = Tab:CreateDivider()

 --Move Speed
local Slider = Tab:CreateSlider({
    Name = "Speed",
    Range = {0, 500},
    Increment = 1,
    Suffix = "0-500",
    CurrentValue = 16,
    Flag = "Speed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
       game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value -- Sets the player's speed to the slider value
    end,
 })

 
 --Jump Hight
local Slider = Tab:CreateSlider({
    Name = "Jump",
    Range = {0, 500},
    Increment = 1,
    Suffix = "0-500",
    CurrentValue = 50,
    Flag = "Jump", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
       game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = Value -- Sets the player's speed to the slider value
    end,
 })

 --Divider
local Divider = UniversalTab:CreateDivider()

--reset
local Button = UniversalTab:CreateButton({
   Name = "Reset Player",
   Callback = function()
		game.Players.LocalPlayer.Character:BreakJoints()
   end,
})


local Tab = Window:CreateTab("Misk", "shield")
local Toggle = MiskTab:CreateToggle({
    Name = "Midnight Toggle",
    CurrentValue = false,
    Flag = "MidnightTPT2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        -- The variable (Value) is a boolean on whether the toggle is true or false
        if Value then
            -- Enable ClockTime change when toggle is ON
            game.Lighting.ClockTime = 0
        end
    end,
 })
 
 -- Keep the original connection
 local runService = game:GetService("RunService")
 runService.RenderStepped:Connect(function()
     if Toggle.CurrentValue then
         game.Lighting.ClockTime = 0 -- 0 represents 12 AM, active only when toggle is on
     end
 end)
 
 --midday for tpt2
 local Toggle = MiskTab:CreateToggle({
    Name = "Midday Toggle",
    CurrentValue = false,
    Flag = "MiddayTPT2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        -- The variable (Value) is a boolean on whether the toggle is true or false
        if Value then
            -- Enable ClockTime change when toggle is ON
            game.Lighting.ClockTime = 12
        end
    end,
 })
 
 -- Keep the original connection
 local runService = game:GetService("RunService")
 runService.RenderStepped:Connect(function()
     if Toggle.CurrentValue then
         game.Lighting.ClockTime = 12 -- 0 represents 12 AM, active only when toggle is on
     end
 end)
 
 --mm2 tab create
 local mm2Tab = Window:CreateTab("MM2", "skull")

 local Button = mm2Tab:CreateButton({
    Name = "Load MM2 menu",
    Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
    end,
 })
 
 
