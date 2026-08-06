-- ============================================================
-- VANGUARD HUB - CONFIG v1.0
-- ============================================================

local HttpService = game:GetService("HttpService")

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================

local function IsColor3(value)
    local typeOf = rawget(_G, "typeof") or typeof

    if type(typeOf) == "function" then
        local success, valueType = pcall(typeOf, value)
        if success then
            return valueType == "Color3"
        end
    end

    return type(value) == "Color3"
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if IsColor3(v) then
            -- Color3 values are immutable; keep their type in in-memory profiles
            -- and backups. EncodeForJSON handles conversion at persistence time.
            copy[k] = v
        elseif type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function EncodeForJSON(value)
    if IsColor3(value) then
        return {r = value.R * 255, g = value.G * 255, b = value.B * 255}
    elseif type(value) == "table" then
        local encoded = {}
        for k, v in pairs(value) do
            encoded[k] = EncodeForJSON(v)
        end
        return encoded
    end
    return value
end

local function DecodeFromJSON(value)
    if type(value) == "table" then
        if value.r and value.g and value.b then
            return Color3.fromRGB(value.r, value.g, value.b)
        elseif #value == 3 and type(value[1]) == "number" then
            return Color3.fromRGB(value[1], value[2], value[3])
        else
            local decoded = {}
            for k, v in pairs(value) do
                decoded[k] = DecodeFromJSON(v)
            end
            return decoded
        end
    end
    return value
end

-- ============================================================
-- CONFIG DATA (pure data, no methods)
-- ============================================================

local ConfigData = {
    -- Metadata
    Version = "1.0",
    CurrentProfile = "Default",
    LastSave = 0,
    Executor = "",
    
    -- General
    Language = "pt",
    Theme = "dark_purple",
    Debug = false,
    AutoSave = true,
    AutoSaveInterval = 60,

    -- Player flat flags
    WalkSpeed = 120,
    SprintSpeed = 65,
    SprintInf = false,
    SprintKey = "LeftShift",
    JumpPower = 250,
    FlySpeed = 200,
    FlyKey = "F",
    FlyUp = "E",
    FlyDown = "Q",
    NoclipKey = "LeftControl",
    Flight = false,
    Noclip = false,
    InfiniteJump = false,
    Invisible = false,
    FOV = 90,
    Zoom = 100,
    Flashlight = false,
    AntiAFK = true,
    GodMode = false,
    AntiKB = false,
    AntiVoid = false,
    HardDragger = false,
    VoidHeight = -80,

    -- Teleports flat flags
    ClickTP = false,
    ClickTPKey = "LeftControl",
    CoordX = 0,
    CoordY = 0,
    CoordZ = 0,

    -- World flat flags
    AlwaysDay = false,
    AlwaysNight = false,
    NoFog = false,
    Spook = false,
    BrightMode = false,
    Brightness = 1,
    Gravity = 196,
    WaterWalk = false,
    RemoveWater = false,
    RealisticWater = false,
    WaterColor = {0, 100, 200},
    RemoveShadows = false,
    RemoveLava = false,
    RemoveShrine = false,
    RemoveSnowRocks = false,
    RemoveVolcanoRocks = false,
    RemoveTrees = false,
    RemoveBuildings = false,
    RemoveItems = false,
    ChristmasTheme = false,
    HalloweenTheme = false,
    AutumnTheme = false,
    AlienTheme = false,
    ImprovedGraphics = false,
    BetterGraphics = false,
    Bloom = false,
    AntiAliasing = false,
    SoftShadows = false,
    Reflections = false,
    DepthOfField = false,
    BloomIntensity = 1,
    Xray = false,
    BridgeRaised = false,
    RealisticRoads = false,
    RealisticGrass = false,
    LeafColor = {79, 63, 29},
    
    -- Keybinds
    Keybinds = {
        Fly = "F",
        FlyUp = "E",
        FlyDown = "Q",
        Noclip = "LeftControl",
        ClickTP = "LeftControl",
        ToggleUI = "RightShift"
    },
    
    -- Player
    Player = {
        WalkSpeed = 120,
        SprintSpeed = 65,
        InfiniteSprint = false,
        JumpPower = 250,
        FlySpeed = 200,
        Flight = false,
        Noclip = false,
        InfiniteJump = false,
        Invisible = false,
        FOV = 90,
        Zoom = 100,
        Flashlight = false,
        AntiAFK = true,
        GodMode = false,
        AntiKnockback = false,
        AntiVoid = false,
        SafeDeath = false,
        BTools = false,
        HardDragger = false
    },
    
    -- World
    World = {
        AlwaysDay = false,
        AlwaysNight = false,
        NoFog = false,
        SpookMode = false,
        BrightMode = false,
        Brightness = 1,
        Gravity = 196.2,
        WaterWalk = false,
        RemoveWater = false,
        WaterColor = Color3.fromRGB(0, 100, 200),
        RemoveShadows = false,
        RemoveLava = false,
        RemoveShrineDoors = false,
        RemoveSnowBoulders = false,
        RemoveVolcanoBoulders = false,
        RemoveTrees = false,
        RemoveBuildings = false,
        RemoveGroundItems = false
    },
    
    -- World Themes
    Themes = {
        Christmas = false,
        Halloween = false,
        Autumn = false,
        Alien = false
    },
    
    -- World Graphics
    Graphics = {
        Improved = false,
        HD = false,
        Bloom = false,
        BloomIntensity = 1,
        RealisticWater = false,
        AntiAliasing = false,
        SoftShadows = false,
        Reflections = false,
        DepthOfField = false
    },
    
    -- Teleports
    Teleports = {
        ClickTeleport = false,
        CoordX = 0,
        CoordY = 0,
        CoordZ = 0
    },
    
    -- Wood
    Wood = {
        TreeType = "Generic",
        TreeAmount = 1,
        TreeSize = "Largest",
        AutoFarm = false,
        ModWood = false,
        ModSawmill = false,
        BringLogs = false,
        SellLogs = false,
        SellPlanks = false,
        CutPlank = false,
        ClickSell = false,
        DismemberTree = false,
        ViewLoneCave = false
    },
    
    -- Dupe
    Dupe = {
        Base = "",
        Slot = 1,
        Type = "Normal",
        Truck = false,
        Empty = false,
        Woods = false,
        Gifts = false,
        Blueprints = false,
        Paintings = false,
        Wires = false,
        Vehicles = false,
        Speed = 5,
        WaitTime = 1
    },
    
    -- Vehicle
    Vehicle = {
        Speed = 1,
        Pitch = 1,
        Fly = false,
        SitAny = false,
        Color = "Silver",
        StopPink = false,
        DeleteSpot = false
    },
    
    -- Sorter
    Sorter = {
        SizeX = 1,
        SizeY = 1,
        SizeZ = 1,
        Speed = 0.3,
        Player = "",
        Type = "All"
    },
    
    -- Autobuy
    Autobuy = {
        Amount = 1,
        Item = "Basic Hatchet - $12",
        OpenBox = false,
        FastCheckout = false
    },
    
    -- Build
    Build = {
        Mode = false,
        BaseWood = "",
        BaseTarget = "",
        WoodType = "Generic",
        AutoFill = false
    },
    
    -- Item
    Item = {
        LassoTool = false,
        ClickSelect = false,
        Direction = "All"
    },
    
    -- Slot
    Slot = {
        Number = 1,
        FastLoad = false,
        RainbowLand = false
    },
    
    -- Schematics
    Schematics = {
        Current = "",
        Favorites = {},
        Recent = {}
    },
    
    -- Profiles (stored as data)
    Profiles = {},
    
    -- Backups (stored as data)
    Backups = {},
    
    -- UI Settings
    UI = {
        Animations = true,
        Notifications = true,
        DarkMode = false,
        FPSOverlay = true,
        Colors = {
            Main = Color3.fromRGB(8, 6, 14),
            Secondary = Color3.fromRGB(18, 14, 28),
            Accent = Color3.fromRGB(160, 60, 255),
            Text = Color3.fromRGB(255, 255, 255)
        },
        LandColor = Color3.fromRGB(124, 92, 70)
    }
}

local DefaultConfigData = DeepCopy(ConfigData)

-- ============================================================
-- CONFIG OBJECT (wraps data with methods)
-- ============================================================

local Config = {}

-- Metatable to forward field access to ConfigData
setmetatable(Config, {
    __index = function(t, k)
        return ConfigData[k]
    end,
    __newindex = function(t, k, v)
        ConfigData[k] = v
    end
})

-- ============================================================
-- MIGRATION SYSTEM
-- ============================================================

local function MigrateV3toV4(old)
    -- Migrate keybinds
    if old.FlyKey or old.NoclipKey or old.ClickTPKey or old.ToggleUI then
        ConfigData.Keybinds.Fly = old.FlyKey or ConfigData.Keybinds.Fly
        ConfigData.Keybinds.FlyUp = old.FlyUp or ConfigData.Keybinds.FlyUp
        ConfigData.Keybinds.FlyDown = old.FlyDown or ConfigData.Keybinds.FlyDown
        ConfigData.Keybinds.Noclip = old.NoclipKey or ConfigData.Keybinds.Noclip
        ConfigData.Keybinds.ClickTP = old.ClickTPKey or ConfigData.Keybinds.ClickTP
        ConfigData.Keybinds.ToggleUI = old.ToggleUI or ConfigData.Keybinds.ToggleUI
    end
    
    -- Migrate Player
    if old.WalkSpeed ~= nil then
        ConfigData.WalkSpeed = old.WalkSpeed or ConfigData.WalkSpeed
        ConfigData.SprintSpeed = old.SprintSpeed or ConfigData.SprintSpeed
        ConfigData.SprintInf = old.SprintInf or old.InfiniteSprint or ConfigData.SprintInf
        ConfigData.SprintKey = old.SprintKey or ConfigData.SprintKey
        ConfigData.JumpPower = old.JumpPower or ConfigData.JumpPower
        ConfigData.FlySpeed = old.FlySpeed or ConfigData.FlySpeed
        ConfigData.FlyKey = old.FlyKey or ConfigData.FlyKey
        ConfigData.FlyUp = old.FlyUp or ConfigData.FlyUp
        ConfigData.FlyDown = old.FlyDown or ConfigData.FlyDown
        ConfigData.NoclipKey = old.NoclipKey or ConfigData.NoclipKey
        ConfigData.Flight = old.Flight or ConfigData.Flight
        ConfigData.Noclip = old.Noclip or ConfigData.Noclip
        ConfigData.InfiniteJump = old.InfiniteJump or ConfigData.InfiniteJump
        ConfigData.Invisible = old.Invisible or ConfigData.Invisible
        ConfigData.FOV = old.FOV or ConfigData.FOV
        ConfigData.Zoom = old.Zoom or ConfigData.Zoom
        ConfigData.Flashlight = old.Flashlight or ConfigData.Flashlight
        ConfigData.AntiAFK = old.AntiAFK or ConfigData.AntiAFK
        ConfigData.GodMode = old.GodMode or ConfigData.GodMode
        ConfigData.AntiKB = old.AntiKB or old.AntiKnockback or ConfigData.AntiKB
        ConfigData.AntiVoid = old.AntiVoid or ConfigData.AntiVoid
        ConfigData.HardDragger = old.HardDragger or ConfigData.HardDragger
        ConfigData.VoidHeight = old.VoidHeight or ConfigData.VoidHeight

        ConfigData.Player.WalkSpeed = old.WalkSpeed
        ConfigData.Player.SprintSpeed = old.SprintSpeed or old.SprintSpeed or 65
        ConfigData.Player.InfiniteSprint = old.SprintInf or old.InfiniteSprint or false
        ConfigData.Player.JumpPower = old.JumpPower or ConfigData.Player.JumpPower
        ConfigData.Player.FlySpeed = old.FlySpeed or ConfigData.Player.FlySpeed
        ConfigData.Player.Flight = old.Flight or ConfigData.Player.Flight
        ConfigData.Player.Noclip = old.Noclip or ConfigData.Player.Noclip
        ConfigData.Player.InfiniteJump = old.InfiniteJump or ConfigData.Player.InfiniteJump
        ConfigData.Player.Invisible = old.Invisible or ConfigData.Player.Invisible
        ConfigData.Player.FOV = old.FOV or ConfigData.Player.FOV
        ConfigData.Player.Zoom = old.Zoom or ConfigData.Player.Zoom
        ConfigData.Player.Flashlight = old.Flashlight or ConfigData.Player.Flashlight
        ConfigData.Player.AntiAFK = old.AntiAFK or ConfigData.Player.AntiAFK
        ConfigData.Player.GodMode = old.GodMode or ConfigData.Player.GodMode
        ConfigData.Player.AntiKnockback = old.AntiKB or old.AntiKnockback or ConfigData.Player.AntiKnockback
        ConfigData.Player.AntiVoid = old.AntiVoid or ConfigData.Player.AntiVoid
        ConfigData.Player.SafeDeath = old.SafeDeath or ConfigData.Player.SafeDeath
        ConfigData.Player.BTools = old.BTools or ConfigData.Player.BTools
        ConfigData.Player.HardDragger = old.HardDragger or ConfigData.Player.HardDragger
    end
    
    -- Migrate World
    if old.AlwaysDay ~= nil then
        ConfigData.World.AlwaysDay = old.AlwaysDay
        ConfigData.World.AlwaysNight = old.AlwaysNight or false
        ConfigData.World.NoFog = old.NoFog or false
        ConfigData.World.SpookMode = old.Spook or old.SpookMode or false
        ConfigData.World.BrightMode = old.BrightMode or false
        ConfigData.World.Brightness = old.Brightness or 1
        ConfigData.World.Gravity = old.Gravity or 196.2
        ConfigData.World.WaterWalk = old.WaterWalk or false
        ConfigData.World.RemoveWater = old.RemoveWater or false
    end
    
    -- Migrate WaterColor
    if old.WaterColor then
        if type(old.WaterColor) == "table" and #old.WaterColor == 3 then
            ConfigData.World.WaterColor = Color3.fromRGB(old.WaterColor[1], old.WaterColor[2], old.WaterColor[3])
        elseif IsColor3(old.WaterColor) then
            ConfigData.World.WaterColor = old.WaterColor
        end
    end
    
    -- Migrate Themes
    if old.ChristmasTheme ~= nil then
        ConfigData.Themes.Christmas = old.ChristmasTheme
        ConfigData.Themes.Halloween = old.HalloweenTheme or false
        ConfigData.Themes.Autumn = old.AutumnTheme or false
        ConfigData.Themes.Alien = old.AlienTheme or false
    end
    
    -- Migrate Graphics
    if old.ImprovedGraphics ~= nil then
        ConfigData.Graphics.Improved = old.ImprovedGraphics
        ConfigData.Graphics.HD = old.BetterGraphics or old.HDGraphics or false
        ConfigData.Graphics.Bloom = old.Bloom or old.BloomEffect or false
        ConfigData.Graphics.BloomIntensity = old.BloomIntensity or 1
        ConfigData.Graphics.RealisticWater = old.RealisticWater or false
        ConfigData.Graphics.AntiAliasing = old.AntiAliasing or false
        ConfigData.Graphics.SoftShadows = old.SoftShadows or false
        ConfigData.Graphics.Reflections = old.Reflections or false
        ConfigData.Graphics.DepthOfField = old.DepthOfField or false
    end
    
    -- Migrate Wood
    if old.TreeType ~= nil then
        ConfigData.Wood.TreeType = old.TreeType
        ConfigData.Wood.TreeAmount = old.TreeAmount or 1
        ConfigData.Wood.TreeSize = old.TreeSize or "Largest"
        ConfigData.Wood.AutoFarm = old.Autofarm or old.AutoFarm or false
        ConfigData.Wood.ModWood = old.ModWood or false
        ConfigData.Wood.ModSawmill = old.ModSawmill or false
        ConfigData.Wood.SellPlanks = old.SellPlank or old.SellPlanks or false
        ConfigData.Wood.CutPlank = old.CutPlank or false
        ConfigData.Wood.ClickSell = old.ClickSell or false
        ConfigData.Wood.DismemberTree = old.DismemberTree or false
        ConfigData.Wood.ViewLoneCave = old.ViewLone or old.ViewLoneCave or false
    end
    
    -- Migrate Dupe
    if old.DupeType ~= nil then
        ConfigData.Dupe.Base = old.DupeBase or ""
        ConfigData.Dupe.Slot = old.DupeSlot or 1
        ConfigData.Dupe.Type = old.DupeType
        ConfigData.Dupe.Truck = old.DupeTruck or false
        ConfigData.Dupe.Empty = old.DupeEmpty or false
        ConfigData.Dupe.Woods = old.DupeWoods or false
        ConfigData.Dupe.Gifts = old.DupeGifts or false
        ConfigData.Dupe.Blueprints = old.DupeBlueprints or false
        ConfigData.Dupe.Paintings = old.DupePaintings or false
        ConfigData.Dupe.Wires = old.DupeWires or false
        ConfigData.Dupe.Vehicles = old.DupeVehicles or false
        ConfigData.Dupe.Speed = old.DupeSpeed or 5
        ConfigData.Dupe.WaitTime = old.DupeWaitTime or 1
    end
    
    -- Migrate Vehicle
    if old.VehicleSpeed ~= nil then
        ConfigData.Vehicle.Speed = old.VehicleSpeed
        ConfigData.Vehicle.Pitch = old.VehiclePitch or 1
        ConfigData.Vehicle.Fly = old.VehicleFly or false
        ConfigData.Vehicle.SitAny = old.SitAny or false
        ConfigData.Vehicle.Color = old.VehicleColor or "Silver"
        ConfigData.Vehicle.StopPink = old.StopPink or false
        ConfigData.Vehicle.DeleteSpot = old.DeleteSpot or false
    end
    
    -- Migrate Sorter
    if old.SortSpeed ~= nil then
        ConfigData.Sorter.SizeX = old.SizeX or 1
        ConfigData.Sorter.SizeY = old.SizeY or 1
        ConfigData.Sorter.SizeZ = old.SizeZ or 1
        ConfigData.Sorter.Speed = old.SortSpeed or 0.3
        ConfigData.Sorter.Player = old.SortPlayer or ""
        ConfigData.Sorter.Type = old.SortType or "All"
    end
    
    -- Migrate Autobuy
    if old.AutobuyAmount ~= nil then
        ConfigData.Autobuy.Amount = old.AutobuyAmount
        ConfigData.Autobuy.Item = old.AutobuyItem or ""
        ConfigData.Autobuy.OpenBox = old.OpenBox or false
        ConfigData.Autobuy.FastCheckout = old.FastCheckout or false
    end
    
    -- Migrate Build
    if old.BuildMode ~= nil then
        ConfigData.Build.Mode = old.BuildMode
        ConfigData.Build.BaseWood = old.BuildBaseWood or ""
        ConfigData.Build.BaseTarget = old.BuildBaseTarget or ""
        ConfigData.Build.WoodType = old.BuildWood or "Generic"
        ConfigData.Build.AutoFill = old.AutoFill or false
    end
    
    -- Migrate Item
    if old.LassoTool ~= nil then
        ConfigData.Item.LassoTool = old.LassoTool
        ConfigData.Item.ClickSelect = old.ClickSelect or false
        ConfigData.Item.Direction = old.Direction or "All"
    end
    
    -- Migrate Slot
    if old.Slot ~= nil then
        ConfigData.Slot.Number = old.Slot
        ConfigData.Slot.FastLoad = old.FastLoad or false
        ConfigData.Slot.RainbowLand = old.RainbowLand or false
    end
    
    -- Migrate Teleports
    if old.CoordX ~= nil then
        ConfigData.CoordX = old.CoordX
        ConfigData.CoordY = old.CoordY or 0
        ConfigData.CoordZ = old.CoordZ or 0

        ConfigData.Teleports.CoordX = old.CoordX
        ConfigData.Teleports.CoordY = old.CoordY or 0
        ConfigData.Teleports.CoordZ = old.CoordZ or 0
    end
    
    if old.ClickTP ~= nil then
        ConfigData.ClickTP = old.ClickTP
        ConfigData.ClickTPKey = old.ClickTPKey or ConfigData.ClickTPKey
        ConfigData.Teleports.ClickTeleport = old.ClickTP
    end
    
    -- Migrate UI
    if old.Animations ~= nil then
        ConfigData.UI.Animations = old.Animations
        ConfigData.UI.Notifications = old.Notifications or true
        ConfigData.UI.DarkMode = old.DarkMode or false
        ConfigData.UI.FPSOverlay = old.FPSOverlay or true
    end
    
    -- Migrate Colors
    if old.MainColor then
        if type(old.MainColor) == "table" and #old.MainColor == 3 then
            ConfigData.UI.Colors.Main = Color3.fromRGB(old.MainColor[1], old.MainColor[2], old.MainColor[3])
        end
    end
    
    if old.SecondaryColor then
        if type(old.SecondaryColor) == "table" and #old.SecondaryColor == 3 then
            ConfigData.UI.Colors.Secondary = Color3.fromRGB(old.SecondaryColor[1], old.SecondaryColor[2], old.SecondaryColor[3])
        end
    end
    
    if old.AccentColor then
        if type(old.AccentColor) == "table" and #old.AccentColor == 3 then
            ConfigData.UI.Colors.Accent = Color3.fromRGB(old.AccentColor[1], old.AccentColor[2], old.AccentColor[3])
        end
    end
    
    if old.TextColor then
        if type(old.TextColor) == "table" and #old.TextColor == 3 then
            ConfigData.UI.Colors.Text = Color3.fromRGB(old.TextColor[1], old.TextColor[2], old.TextColor[3])
        end
    end
    
    if old.LandColor then
        if type(old.LandColor) == "table" and #old.LandColor == 3 then
            ConfigData.UI.LandColor = Color3.fromRGB(old.LandColor[1], old.LandColor[2], old.LandColor[3])
        end
    end
end

-- Migration registry
local Migrations = {
    ["3.0.0"] = MigrateV3toV4,
    -- Future: ["1.0"] = MigrateV1toV2,
}

-- ============================================================
-- SAVE / LOAD
-- ============================================================

function Config:Save()
    ConfigData.LastSave = os.time()

    local registry = rawget(_G, "__VanguardModuleRegistry") or {}
    local storage = registry["Core/Services/Storage"]
    if not storage or type(storage.Write) ~= "function" then
        return false
    end
    
    local success, result = pcall(function()
        -- Encode only data (not methods)
        local encoded = EncodeForJSON(ConfigData)
        local json = HttpService:JSONEncode(encoded)
        storage.Write("VanguardHub_Config.json", json)
    end)
    
    return success
end

function Config:Load()
    local registry = rawget(_G, "__VanguardModuleRegistry") or {}
    local storage = registry["Core/Services/Storage"]
    if not storage or type(storage.Read) ~= "function" then
        return false
    end
    
    local data = storage.Read("VanguardHub_Config.json")
    if not data then
        return false
    end
    
    local success2, decoded = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    
    if not success2 or not decoded then
        return false
    end
    
    -- Decode Color3 values
    decoded = DecodeFromJSON(decoded)
    
    -- Check if migration needed
    if decoded.Version and decoded.Version ~= ConfigData.Version then
        local migrate = Migrations[decoded.Version]
        if migrate then
            migrate(decoded)
        end
    end
    
    -- Copy decoded values to ConfigData
    for k, v in pairs(decoded) do
        if ConfigData[k] == nil or type(v) == type(ConfigData[k]) then
            ConfigData[k] = v
        end
    end
    
    return true
end

-- ============================================================
-- PROFILE MANAGEMENT
-- ============================================================

function Config:SaveProfile(name)
    name = name or ConfigData.CurrentProfile
    
    -- Deep copy to avoid reference sharing
    ConfigData.Profiles[name] = DeepCopy(ConfigData)
    ConfigData.Profiles[name].Profiles = {}
    ConfigData.Profiles[name].Backups = {}
    
    self:Save()
    
    return true
end

function Config:LoadProfile(name)
    if not ConfigData.Profiles[name] then
        return false
    end
    
    -- Deep copy from profile to avoid reference sharing
    local profile = DeepCopy(ConfigData.Profiles[name])
    
    -- Restore profile data (preserve Profiles and Backups)
    local savedProfiles = ConfigData.Profiles
    local savedBackups = ConfigData.Backups
    
    for k, v in pairs(profile) do
        ConfigData[k] = v
    end
    
    ConfigData.Profiles = savedProfiles
    ConfigData.Backups = savedBackups
    ConfigData.CurrentProfile = name
    
    self:Save()
    
    return true
end

function Config:DeleteProfile(name)
    if name == "Default" then
        return false
    end
    
    ConfigData.Profiles[name] = nil
    
    if ConfigData.CurrentProfile == name then
        ConfigData.CurrentProfile = "Default"
    end
    
    self:Save()
    
    return true
end

function Config:Reset()
    local defaults = DeepCopy(DefaultConfigData)
    local savedProfiles = ConfigData.Profiles
    local savedBackups = ConfigData.Backups

    for key in pairs(ConfigData) do
        ConfigData[key] = nil
    end

    for key, value in pairs(defaults) do
        ConfigData[key] = value
    end

    ConfigData.Profiles = savedProfiles or {}
    ConfigData.Backups = savedBackups or {}
    ConfigData.CurrentProfile = "Default"

    self:Save()

    return true
end

-- ============================================================
-- BACKUP SYSTEM
-- ============================================================

function Config:CreateBackup()
    local backupName = "backup_" .. os.date("%Y%m%d_%H%M%S")
    
    -- Deep copy to avoid reference sharing
    ConfigData.Backups[backupName] = DeepCopy(ConfigData)
    ConfigData.Backups[backupName].Backups = {}
    
    -- Keep only last 10 backups
    local backupList = {}
    for name in pairs(ConfigData.Backups) do
        table.insert(backupList, name)
    end
    
    table.sort(backupList)
    
    while #backupList > 10 do
        ConfigData.Backups[backupList[1]] = nil
        table.remove(backupList, 1)
    end
    
    self:Save()
    
    return backupName
end

function Config:RestoreBackup(name)
    if not ConfigData.Backups[name] then
        return false
    end
    
    -- Deep copy to avoid reference sharing
    local backup = DeepCopy(ConfigData.Backups[name])
    
    -- Preserve backups
    local savedBackups = ConfigData.Backups
    
    for k, v in pairs(backup) do
        ConfigData[k] = v
    end
    
    ConfigData.Backups = savedBackups
    
    self:Save()

    return true
end

function Config:DeleteBackup(name)
    if not ConfigData.Backups[name] then
        return false
    end

    ConfigData.Backups[name] = nil

    self:Save()

    return true
end

-- ============================================================
-- EXPORT / IMPORT
-- ============================================================

function Config:Export()
    local encoded = EncodeForJSON(ConfigData)
    local json = HttpService:JSONEncode(encoded)

    local registry = rawget(_G, "__VanguardModuleRegistry") or {}
    local clipboard = registry["Core/Services/Clipboard"]
    if clipboard and type(clipboard.Copy) == "function" then
        clipboard.Copy(json)
    end
    
    return json
end

function Config:Import(json)
    if not json then return false end
    
    local success, decoded = pcall(function()
        return HttpService:JSONDecode(json)
    end)
    
    if not success or not decoded then
        return false
    end
    
    decoded = DecodeFromJSON(decoded)
    
    -- Create backup before import
    self:CreateBackup()
    
    -- Apply imported settings
    for k, v in pairs(decoded) do
        if ConfigData[k] ~= nil and type(v) == type(ConfigData[k]) then
            ConfigData[k] = v
        end
    end
    
    self:Save()
    
    return true
end

return Config
