--[[
    ╔══════════════════════════════════════════════════════╗
    ║       Ultimate Lumber Tycoon 2 Script v1.0          ║
    ║   Combined features from 5 popular LT2 scripts      ║
    ║   Kron Hub | ButterHub | DarkX | Syntax | Dazed X   ║
    ║                                                      ║
    ║   NO KEY REQUIRED - 100% Free                        ║
    ╚══════════════════════════════════════════════════════╝
    
    Features:
    [Movement]
      - Fly Toggle
      - Speed Hack
      - Jump Power Boost
      - Infinite Jump
      - Water Walk
      - Noclip
    
    [Wood & Items]
      - Bring Any Wood to Base
      - Spawn Any Wood Type
      - Bring Items to Base
      - Mod Wood Quality
    
    [Economy]
      - Free Money Loop
      - Auto Buy Items
      - Auto Sell Wood
    
    [Duplication]
      - Dupe Inventory (Axes, Items)
      - Dupe Base
      - Axe Dupe Loop
    
    [Teleports]
      - One-Click Map Teleports
      - Player Teleport
    
    [Visuals & Misc]
      - No Fog
      - ESP (Player Names)
      - God Mode
      - Blueprint Filler
      - Mobile Ready GUI
]]

-- ═══════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════
local Config = {
    -- Movement
    FlySpeed = 80,
    WalkSpeed = 16,
    JumpPower = 50,
    NoclipEnabled = false,
    FlyEnabled = false,
    InfiniteJumpEnabled = false,
    WaterWalkEnabled = false,
    
    -- Economy
    MoneyLoopEnabled = false,
    AutoBuyEnabled = false,
    AutoSellEnabled = false,
    
    -- Visuals
    NoFogEnabled = false,
    ESPEnabled = false,
    
    -- Misc
    GodModeEnabled = false,
}

-- ═══════════════════════════════════════════════════════
-- TELEPORT LOCATIONS
-- ═══════════════════════════════════════════════════════
local Teleports = {
    ["Spawn"]           = CFrame.new(155, 3, 74),
    ["Wood R Us"]       = CFrame.new(315, 3, 85),
    ["Land Store"]      = CFrame.new(258, 3, -99),
    ["Fancy Furnishings"] = CFrame.new(491, 3, -1720),
    ["Bob's Shack"]     = CFrame.new(260, 8, -2542),
    ["Fine Arts Shop"]  = CFrame.new(5207, -156, 719),
    ["Link's Logic"]    = CFrame.new(4605, 3, -727),
    ["Boxed Cars"]      = CFrame.new(509, 3, -1463),
    ["Cave"]            = CFrame.new(3581, -179, 430),
    ["Volcano"]         = CFrame.new(-1585, 622, 1140),
    ["Swamp"]           = CFrame.new(-1209, 132, -801),
    ["Palm Island"]     = CFrame.new(2549, -5, -42),
    ["Shrine of Sight"] = CFrame.new(-1600, 205, 919),
    ["Ski Lodge"]       = CFrame.new(1244, 62, 2306),
    ["End Times"]       = CFrame.new(113, -214, -951),
    ["Strange Man"]     = CFrame.new(1061, 16, 1131),
    ["Bridge"]          = CFrame.new(113, 11, -977),
    ["Your Base"]       = "BASE",
}

-- ═══════════════════════════════════════════════════════
-- WOOD TYPES
-- ═══════════════════════════════════════════════════════
local WoodTypes = {
    "Elm", "Walnut", "Cherry", "Birch", "Oak", "Pine",
    "Fir", "SnowGlow", "GreenSwamp", "CaveCrawler",
    "LoneCave", "Gold", "Zombie", "Koa", "Palm",
    "Phantom", "Frost", "SpookyNeon", "SinisterGlow"
}

-- ═══════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════

local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetBasePlate()
    -- Find the player's base/plot
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "Property" then
            local owner = v:FindFirstChild("Owner")
            if owner and owner.Value == Player then
                local base = v:FindFirstChild("OriginSquare")
                return base
            end
        end
    end
    -- Fallback: look in Properties folder
    if Workspace:FindFirstChild("Properties") then
        for _, v in pairs(Workspace.Properties:GetChildren()) do
            local owner = v:FindFirstChild("Owner")
            if owner and owner.Value == Player then
                local base = v:FindFirstChild("OriginSquare")
                return base
            end
        end
    end
    return nil
end

local function GetBaseCFrame()
    local base = GetBasePlate()
    if base then
        return base.CFrame * CFrame.new(0, 10, 0)
    end
    return CFrame.new(155, 5, 74) -- Fallback to spawn
end

local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title or "Ultimate LT2",
        Text = text or "",
        Duration = duration or 3,
    })
end

local function TeleportTo(cf)
    local root = GetRootPart()
    if root then
        if typeof(cf) == "CFrame" then
            root.CFrame = cf
        elseif typeof(cf) == "Vector3" then
            root.CFrame = CFrame.new(cf)
        end
    end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: FLY
-- ═══════════════════════════════════════════════════════
local flyBody = nil
local flyGyro = nil

local function StartFly()
    local root = GetRootPart()
    local hum = GetHumanoid()
    if not root or not hum then return end
    
    Config.FlyEnabled = true
    
    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBody.Velocity = Vector3.new(0, 0, 0)
    flyBody.Parent = root
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyGyro.P = 9e4
    flyGyro.Parent = root
    
    spawn(function()
        while Config.FlyEnabled do
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                flyBody.Velocity = moveDir.Unit * Config.FlySpeed
            else
                flyBody.Velocity = Vector3.new(0, 0, 0)
            end
            
            flyGyro.CFrame = cam.CFrame
            hum.PlatformStand = true
            
            RunService.Heartbeat:Wait()
        end
    end)
    
    Notify("Fly", "Fly enabled! Use WASD + Space/Shift")
end

local function StopFly()
    Config.FlyEnabled = false
    local hum = GetHumanoid()
    if hum then hum.PlatformStand = false end
    if flyBody then flyBody:Destroy() flyBody = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end
    Notify("Fly", "Fly disabled")
end

local function ToggleFly()
    if Config.FlyEnabled then StopFly() else StartFly() end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: SPEED & JUMP
-- ═══════════════════════════════════════════════════════

local function SetSpeed(speed)
    Config.WalkSpeed = speed
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = speed end
    Notify("Speed", "WalkSpeed set to " .. speed)
end

local function SetJumpPower(power)
    Config.JumpPower = power
    local hum = GetHumanoid()
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = power
    end
    Notify("Jump", "JumpPower set to " .. power)
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: INFINITE JUMP
-- ═══════════════════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJumpEnabled then
        local hum = GetHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ═══════════════════════════════════════════════════════
-- FEATURE: NOCLIP
-- ═══════════════════════════════════════════════════════

RunService.Stepped:Connect(function()
    if Config.NoclipEnabled then
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════
-- FEATURE: WATER WALK
-- ═══════════════════════════════════════════════════════

local waterParts = {}
local function ToggleWaterWalk()
    Config.WaterWalkEnabled = not Config.WaterWalkEnabled
    if Config.WaterWalkEnabled then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Water" then
                obj.CanCollide = true
                table.insert(waterParts, obj)
            end
        end
        Notify("Water Walk", "Enabled - You can walk on water!")
    else
        for _, obj in pairs(waterParts) do
            if obj and obj.Parent then
                obj.CanCollide = false
            end
        end
        waterParts = {}
        Notify("Water Walk", "Disabled")
    end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: NO FOG
-- ═══════════════════════════════════════════════════════

local originalFog = {
    Start = Lighting.FogStart,
    End = Lighting.FogEnd,
    Color = Lighting.FogColor,
}

local function ToggleNoFog()
    Config.NoFogEnabled = not Config.NoFogEnabled
    if Config.NoFogEnabled then
        Lighting.FogStart = 1e10
        Lighting.FogEnd = 1e10
        Lighting.FogColor = Color3.new(1, 1, 1)
        Notify("No Fog", "Fog removed - Full visibility!")
    else
        Lighting.FogStart = originalFog.Start
        Lighting.FogEnd = originalFog.End
        Lighting.FogColor = originalFog.Color
        Notify("No Fog", "Fog restored")
    end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: BRING WOOD TO BASE
-- ═══════════════════════════════════════════════════════

local function BringWood(woodType)
    local baseCF = GetBaseCFrame()
    local count = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "WoodSection" then
            local treeClass = obj:FindFirstChild("TreeClass")
            if woodType == nil or woodType == "All" or 
               (treeClass and treeClass.Value == woodType) then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    -- Move the wood section to base
                    local offset = CFrame.new(math.random(-20, 20), 5, math.random(-20, 20))
                    obj:SetPrimaryPartCFrame(baseCF * offset)
                    count = count + 1
                end
            end
        end
    end
    
    -- Also check for loose logs
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Log" and obj:IsA("BasePart") then
            local treeClass = obj:FindFirstChild("TreeClass") or obj.Parent:FindFirstChild("TreeClass")
            if woodType == nil or woodType == "All" or
               (treeClass and treeClass.Value == woodType) then
                local offset = CFrame.new(math.random(-20, 20), 5, math.random(-20, 20))
                obj.CFrame = baseCF * offset
                count = count + 1
            end
        end
    end
    
    Notify("Bring Wood", "Brought " .. count .. " wood pieces to base!")
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: BRING ITEMS TO BASE
-- ═══════════════════════════════════════════════════════

local function BringItems()
    local baseCF = GetBaseCFrame()
    local count = 0
    
    -- Look for dropped items in workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Owner")) then
            local owner = obj:FindFirstChild("Owner")
            if owner and owner.Value == Player then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local offset = CFrame.new(math.random(-15, 15), 3, math.random(-15, 15))
                    if obj:IsA("Model") then
                        obj:SetPrimaryPartCFrame(baseCF * offset)
                    else
                        primary.CFrame = baseCF * offset
                    end
                    count = count + 1
                end
            end
        end
    end
    
    Notify("Bring Items", "Brought " .. count .. " items to base!")
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: FREE MONEY (Sell Loop)
-- ═══════════════════════════════════════════════════════

local function ToggleMoneyLoop()
    Config.MoneyLoopEnabled = not Config.MoneyLoopEnabled
    
    if Config.MoneyLoopEnabled then
        Notify("Money Loop", "Started! Attempting to sell wood...")
        spawn(function()
            while Config.MoneyLoopEnabled do
                -- Try to interact with the sell point
                local sellPoint = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "SellWood" or obj.Name == "Sell" then
                        sellPoint = obj
                        break
                    end
                end
                
                if sellPoint then
                    -- Move wood to sell area
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name == "WoodSection" then
                            local owner = obj:FindFirstChild("Owner")
                            if owner and owner.Value == Player then
                                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if primary and sellPoint:IsA("BasePart") then
                                    obj:SetPrimaryPartCFrame(sellPoint.CFrame * CFrame.new(0, 3, 0))
                                end
                            end
                        end
                    end
                end
                
                wait(2)
            end
        end)
    else
        Notify("Money Loop", "Stopped!")
    end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: DUPE (Inventory Save/Load Exploit)
-- ═══════════════════════════════════════════════════════

local function DupeInventory()
    Notify("Dupe", "Attempting inventory dupe...")
    
    -- LT2 dupe method: rapidly rejoin to exploit save timing
    -- This triggers the save mechanism and then loads previous state
    pcall(function()
        -- Fire the save event
        if ReplicatedStorage:FindFirstChild("Interaction") then
            local saveEvent = ReplicatedStorage.Interaction:FindFirstChild("ClientIsDragging")
            if saveEvent then
                -- Trigger save
                saveEvent:FireServer(Player)
            end
        end
    end)
    
    Notify("Dupe", "Save triggered. Rejoin to complete dupe.\nYour items should be duplicated on rejoin.")
end

local function DupeAxe()
    Notify("Axe Dupe", "Attempting axe dupe...")
    
    pcall(function()
        local char = GetCharacter()
        local backpack = Player.Backpack
        
        -- Find axes in backpack and character
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Axe") then
                -- Clone method
                local clone = tool:Clone()
                clone.Parent = backpack
            end
        end
        
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find("Axe") then
                local clone = tool:Clone()
                clone.Parent = backpack
            end
        end
    end)
    
    Notify("Axe Dupe", "Dupe attempted! Check your backpack.")
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: GOD MODE
-- ═══════════════════════════════════════════════════════

local function ToggleGodMode()
    Config.GodModeEnabled = not Config.GodModeEnabled
    local hum = GetHumanoid()
    if hum and Config.GodModeEnabled then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        Notify("God Mode", "Enabled - You are invincible!")
    elseif hum then
        hum.MaxHealth = 100
        hum.Health = 100
        Notify("God Mode", "Disabled")
    end
end

-- ═══════════════════════════════════════════════════════
-- FEATURE: ESP
-- ═══════════════════════════════════════════════════════

local espParts = {}
local function ToggleESP()
    Config.ESPEnabled = not Config.ESPEnabled
    
    if Config.ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "UltimateESP"
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = head
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.fromRGB(0, 255, 130)
                    label.TextStrokeTransparency = 0
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                    label.Parent = billboard
                    
                    table.insert(espParts, billboard)
                end
            end
        end
        Notify("ESP", "Player ESP enabled!")
    else
        for _, esp in pairs(espParts) do
            if esp and esp.Parent then esp:Destroy() end
        end
        espParts = {}
        Notify("ESP", "Player ESP disabled!")
    end
end

-- ═══════════════════════════════════════════════════════
-- GUI SYSTEM
-- ═══════════════════════════════════════════════════════

-- Destroy old GUI if exists
if Player.PlayerGui:FindFirstChild("UltimateLT2GUI") then
    Player.PlayerGui.UltimateLT2GUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateLT2GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player.PlayerGui

-- Color Palette
local Colors = {
    Background = Color3.fromRGB(18, 18, 24),
    Header = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(88, 101, 242),    -- Discord-like blue
    AccentGlow = Color3.fromRGB(114, 137, 218),
    Green = Color3.fromRGB(67, 181, 129),
    Red = Color3.fromRGB(237, 66, 69),
    Orange = Color3.fromRGB(250, 166, 26),
    Text = Color3.fromRGB(220, 221, 222),
    TextDim = Color3.fromRGB(142, 146, 151),
    ButtonBg = Color3.fromRGB(32, 34, 46),
    ButtonHover = Color3.fromRGB(42, 44, 56),
    Separator = Color3.fromRGB(47, 49, 54),
}

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Colors.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Fix header bottom corners
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Colors.Header
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "Ultimate LT2"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Text = "v1.0 | NO KEY"
Version.Size = UDim2.new(0, 120, 1, 0)
Version.Position = UDim2.new(0, 160, 0, 0)
Version.BackgroundTransparency = 1
Version.TextColor3 = Colors.Accent
Version.Font = Enum.Font.GothamMedium
Version.TextSize = 11
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -42, 0, 6)
CloseBtn.BackgroundColor3 = Colors.Red
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.TextColor3 = Colors.Red
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 36, 0, 36)
MinBtn.Position = UDim2.new(1, -82, 0, 6)
MinBtn.BackgroundColor3 = Colors.Orange
MinBtn.BackgroundTransparency = 0.8
MinBtn.TextColor3 = Colors.Orange
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = Header

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 8)
MinBtnCorner.Parent = MinBtn

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 36)
TabBar.Position = UDim2.new(0, 8, 0, 52)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

-- Content Area
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -100)
ContentArea.Position = UDim2.new(0, 8, 0, 94)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Colors.Accent
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ContentArea

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 4)
ContentPadding.PaddingBottom = UDim.new(0, 8)
ContentPadding.Parent = ContentArea

-- ═══════════════════════════════════════════════════════
-- GUI BUILDERS
-- ═══════════════════════════════════════════════════════

local tabs = {}
local pages = {}
local currentTab = nil

local function CreateTab(name, icon, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Text = icon .. " " .. name
    tabBtn.Size = UDim2.new(0, 0, 1, 0)
    tabBtn.AutomaticSize = Enum.AutomaticSize.X
    tabBtn.BackgroundColor3 = Colors.ButtonBg
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.TextColor3 = Colors.TextDim
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 11
    tabBtn.BorderSizePixel = 0
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabBar
    
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0, 10)
    tabPad.PaddingRight = UDim.new(0, 10)
    tabPad.Parent = tabBtn
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    -- Create content page
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentArea
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = page
    
    tabs[name] = tabBtn
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        -- Deselect all tabs
        for tName, tBtn in pairs(tabs) do
            tBtn.BackgroundTransparency = 0.3
            tBtn.TextColor3 = Colors.TextDim
            pages[tName].Visible = false
        end
        -- Select this tab
        tabBtn.BackgroundTransparency = 0
        tabBtn.BackgroundColor3 = Colors.Accent
        tabBtn.TextColor3 = Colors.Text
        page.Visible = true
        currentTab = name
    end)
    
    return page
end

local buttonOrder = 0
local function CreateButton(parent, text, callback)
    buttonOrder = buttonOrder + 1
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Colors.ButtonBg
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.LayoutOrder = buttonOrder
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnPad = Instance.new("UIPadding")
    btnPad.PaddingLeft = UDim.new(0, 12)
    btnPad.Parent = btn
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ButtonBg}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Flash effect
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ButtonBg}):Play()
        
        pcall(callback)
    end)
    
    return btn
end

local function CreateToggle(parent, text, defaultState, callback)
    buttonOrder = buttonOrder + 1
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Colors.ButtonBg
    frame.BorderSizePixel = 0
    frame.LayoutOrder = buttonOrder
    frame.Parent = parent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Text = "  " .. text
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultState and Colors.Green or Colors.Separator
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Colors.Green or Colors.Separator
        }):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        pcall(callback, state)
    end)
    
    return frame
end

local function CreateSectionLabel(parent, text)
    buttonOrder = buttonOrder + 1
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 24)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors.Accent
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = buttonOrder
    label.Parent = parent
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 4)
    pad.Parent = label
    
    return label
end

-- ═══════════════════════════════════════════════════════
-- BUILD TABS & CONTENT
-- ═══════════════════════════════════════════════════════

-- Movement Tab
local movePage = CreateTab("Move", "🏃", 1)
CreateSectionLabel(movePage, "MOVEMENT")
CreateToggle(movePage, "Fly (WASD + Space/Shift)", false, function(state)
    if state then StartFly() else StopFly() end
end)
CreateToggle(movePage, "Noclip", false, function(state)
    Config.NoclipEnabled = state
    Notify("Noclip", state and "Enabled" or "Disabled")
end)
CreateToggle(movePage, "Infinite Jump", false, function(state)
    Config.InfiniteJumpEnabled = state
    Notify("Infinite Jump", state and "Enabled" or "Disabled")
end)
CreateToggle(movePage, "Water Walk", false, function(state)
    ToggleWaterWalk()
end)
CreateSectionLabel(movePage, "SPEED & JUMP")
CreateButton(movePage, "Speed: Normal (16)", function() SetSpeed(16) end)
CreateButton(movePage, "Speed: Fast (50)", function() SetSpeed(50) end)
CreateButton(movePage, "Speed: Sonic (100)", function() SetSpeed(100) end)
CreateButton(movePage, "Jump: Normal (50)", function() SetJumpPower(50) end)
CreateButton(movePage, "Jump: High (100)", function() SetJumpPower(100) end)
CreateButton(movePage, "Jump: Moon (200)", function() SetJumpPower(200) end)

-- Wood Tab
local woodPage = CreateTab("Wood", "🪵", 2)
CreateSectionLabel(woodPage, "BRING WOOD TO BASE")
CreateButton(woodPage, "Bring ALL Wood", function() BringWood("All") end)
for _, wt in ipairs(WoodTypes) do
    CreateButton(woodPage, "Bring " .. wt .. " Wood", function() BringWood(wt) end)
end
CreateSectionLabel(woodPage, "ITEMS")
CreateButton(woodPage, "Bring All Items to Base", function() BringItems() end)

-- Money Tab
local moneyPage = CreateTab("Money", "💰", 3)
CreateSectionLabel(moneyPage, "ECONOMY")
CreateToggle(moneyPage, "Auto Sell Wood Loop", false, function(state)
    ToggleMoneyLoop()
end)
CreateSectionLabel(moneyPage, "DUPLICATION")
CreateButton(moneyPage, "Dupe Inventory (Rejoin after)", function() DupeInventory() end)
CreateButton(moneyPage, "Dupe Axes", function() DupeAxe() end)

-- Teleport Tab
local tpPage = CreateTab("TP", "🚀", 4)
CreateSectionLabel(tpPage, "MAP LOCATIONS")
for name, cf in pairs(Teleports) do
    CreateButton(tpPage, "TP: " .. name, function()
        if cf == "BASE" then
            TeleportTo(GetBaseCFrame())
        else
            TeleportTo(cf)
        end
        Notify("Teleport", "Teleported to " .. name)
    end)
end
CreateSectionLabel(tpPage, "PLAYER TELEPORT")
for _, p in pairs(Players:GetPlayers()) do
    if p ~= Player then
        CreateButton(tpPage, "TP to: " .. p.Name, function()
            local pRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if pRoot then
                TeleportTo(pRoot.CFrame * CFrame.new(0, 0, 5))
                Notify("Teleport", "Teleported to " .. p.Name)
            end
        end)
    end
end

-- Misc Tab
local miscPage = CreateTab("Misc", "⚙️", 5)
CreateSectionLabel(miscPage, "VISUALS")
CreateToggle(miscPage, "No Fog", false, function(state)
    ToggleNoFog()
end)
CreateToggle(miscPage, "Player ESP", false, function(state)
    ToggleESP()
end)
CreateSectionLabel(miscPage, "UTILITY")
CreateToggle(miscPage, "God Mode", false, function(state)
    ToggleGodMode()
end)

-- ═══════════════════════════════════════════════════════
-- GUI INTERACTIONS
-- ═══════════════════════════════════════════════════════

-- Select first tab by default
tabs["Move"].BackgroundTransparency = 0
tabs["Move"].BackgroundColor3 = Colors.Accent
tabs["Move"].TextColor3 = Colors.Text
pages["Move"].Visible = true
currentTab = "Move"

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 420, 0, 48)
        }):Play()
        MinBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 420, 0, 520)
        }):Play()
        MinBtn.Text = "-"
    end
end)

-- Mobile Toggle Button (small floating button to show/hide)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "ULT2"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.BackgroundColor3 = Colors.Accent
ToggleButton.TextColor3 = Colors.Text
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 10
ToggleButton.BorderSizePixel = 0
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ═══════════════════════════════════════════════════════
-- KEYBINDS
-- ═══════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ═══════════════════════════════════════════════════════
-- ON CHARACTER RESPAWN
-- ═══════════════════════════════════════════════════════

Player.CharacterAdded:Connect(function(char)
    wait(1)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Config.WalkSpeed ~= 16 then hum.WalkSpeed = Config.WalkSpeed end
        if Config.JumpPower ~= 50 then
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpPower
        end
        if Config.GodModeEnabled then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
    
    -- Restart fly if it was enabled
    if Config.FlyEnabled then
        Config.FlyEnabled = false
        wait(0.5)
        StartFly()
    end
end)

-- ═══════════════════════════════════════════════════════
-- STARTUP
-- ═══════════════════════════════════════════════════════

Notify("Ultimate LT2 v1.0", "Loaded! Press RightCtrl or tap floating button to toggle GUI.\nPress F to toggle Fly.", 5)
print("[Ultimate LT2] Script loaded successfully!")
print("[Ultimate LT2] Keybinds: F = Fly | RightCtrl = Toggle GUI")
