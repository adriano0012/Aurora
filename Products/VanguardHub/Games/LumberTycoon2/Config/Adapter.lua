local Adapter = {}

Adapter.SectionOrder = {
    "Player",
    "World",
    "Teleports",
    "Wood",
    "Dupe",
    "Vehicle",
    "Sorter",
    "Autobuy",
    "Build",
    "Item",
    "Slot",
    "Schematics",
    "UI"
}

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, item in pairs(value) do
        copy[key] = deepCopy(item)
    end
    return copy
end

local flatSections = {
    Player = {
        "WalkSpeed", "SprintSpeed", "SprintInf", "SprintKey", "JumpPower", "FlySpeed",
        "FlyKey", "FlyUp", "FlyDown", "NoclipKey", "Flight", "Noclip", "InfiniteJump",
        "Invisible", "FOV", "Zoom", "Flashlight", "AntiAFK", "GodMode", "AntiKB",
        "AntiVoid", "HardDragger", "VoidHeight"
    },
    World = {
        "AlwaysDay", "AlwaysNight", "NoFog", "Spook", "BrightMode", "Brightness",
        "Gravity", "WaterWalk", "RemoveWater", "RealisticWater", "WaterColor",
        "RemoveShadows", "RemoveLava", "RemoveShrine", "RemoveSnowRocks",
        "RemoveVolcanoRocks", "RemoveTrees", "RemoveBuildings", "RemoveItems",
        "ChristmasTheme", "HalloweenTheme", "AutumnTheme", "AlienTheme",
        "ImprovedGraphics", "BetterGraphics", "Bloom", "AntiAliasing",
        "SoftShadows", "Reflections", "DepthOfField", "BloomIntensity"
    },
    Teleports = {"ClickTP", "ClickTPKey", "CoordX", "CoordY", "CoordZ"},
    Wood = {"TreeType", "TreeAmount", "TreeSize", "AutoFarm", "ModWood", "ModSawmill", "BringLogs", "SellLogs", "SellPlanks", "CutPlank", "ClickSell", "DismemberTree", "ViewLoneCave"},
    Dupe = {"DupeBase", "DupeSlot", "DupeType", "DupeTruck", "DupeEmpty", "DupeWoods", "DupeGifts", "DupeBlueprints", "DupePaintings", "DupeWires", "DupeVehicles", "DupeSpeed", "DupeWaitTime"},
    Vehicle = {"VehicleSpeed", "VehiclePitch", "VehicleFly", "VehicleColor", "StopPink", "DeleteSpot"},
    Sorter = {"SizeX", "SizeY", "SizeZ", "SortSpeed", "SortPlayer", "SortType"},
    Autobuy = {"AutobuyAmount", "AutobuyItem", "OpenBox", "FastCheckout"},
    Build = {"BuildMode", "BuildBaseWood", "BuildBaseTarget", "BuildWood", "AutoFill"},
    Item = {"LassoTool", "ClickSelect", "Direction"},
    Slot = {"Slot", "FastLoad", "RainbowLand"},
    UI = {"Language", "Theme", "Debug", "AutoSave", "AutoSaveInterval", "Animations", "Notifications", "FPSOverlay", "ToggleUI"}
}

local metaKeys = {
    "Version",
    "CurrentProfile",
    "LastSave",
    "Executor",
    "Language",
    "Theme",
    "Debug",
    "AutoSave",
    "AutoSaveInterval",
    "Keybinds",
    "Profiles",
    "Backups"
}

local function exportPayload(config, sectionName)
    local payload = {
        Section = deepCopy(config[sectionName]),
        Flat = {}
    }

    for _, key in ipairs(flatSections[sectionName] or {}) do
        payload.Flat[key] = deepCopy(config[key])
    end

    return payload
end

function Adapter.ExportSections(config)
    local sections = {}
    for _, sectionName in ipairs(Adapter.SectionOrder) do
        sections[sectionName] = exportPayload(config, sectionName)
    end
    return sections
end

function Adapter.ImportSections(config, sections)
    for sectionName, payload in pairs(sections or {}) do
        if type(payload) == "table" then
            if type(payload.Section) == "table" then
                config[sectionName] = deepCopy(payload.Section)
            end

            if type(payload.Flat) == "table" then
                for key, value in pairs(payload.Flat) do
                    config[key] = deepCopy(value)
                end
            end
        end
    end
end

function Adapter.ExportMeta(config)
    local meta = {}
    for _, key in ipairs(metaKeys) do
        meta[key] = deepCopy(config[key])
    end
    return meta
end

function Adapter.ImportMeta(config, meta)
    for _, key in ipairs(metaKeys) do
        if meta[key] ~= nil then
            config[key] = deepCopy(meta[key])
        end
    end
end

function Adapter.ExportSnapshot(config)
    local snapshot = Adapter.ExportMeta(config)
    snapshot.Sections = Adapter.ExportSections(config)
    return snapshot
end

function Adapter.ImportSnapshot(config, snapshot)
    Adapter.ImportMeta(config, snapshot)
    Adapter.ImportSections(config, snapshot.Sections)
end

function Adapter.Reset(config, defaults)
    for key, value in pairs(defaults or {}) do
        if type(value) ~= "function" then
            config[key] = deepCopy(value)
        end
    end
end

return Adapter
