-- ============================================================
-- VANGUARD HUB - WORLD
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("world_title"), "6026568213")

    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local Terrain = Workspace:FindFirstChildOfClass("Terrain")

    local ModuleAlive = true
    local FeatureConnections = {}
    local CreatedInstances = {}

    local function Notify(title, message, duration)
        if Utils and type(Utils.Notify) == "function" then
            Utils.Notify(title, message, duration or 3)
        end
    end

    local function AddConnection(name, connection)
        if FeatureConnections[name] then
            pcall(function()
                FeatureConnections[name]:Disconnect()
            end)
        end

        FeatureConnections[name] = connection
        return connection
    end

    local function RemoveConnection(name)
        local connection = FeatureConnections[name]
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
            FeatureConnections[name] = nil
        end
    end

    local function TrackInstance(instance)
        table.insert(CreatedInstances, instance)
        return instance
    end

    local function ToColor3(value, fallback)
        fallback = fallback or Color3.new(1, 1, 1)

        if typeof(value) == "Color3" then
            return value
        end

        if type(value) == "table" then
            local r = value.R or value.r or value[1]
            local g = value.G or value.g or value[2]
            local b = value.B or value.b or value[3]

            if r and g and b then
                if r <= 1 and g <= 1 and b <= 1 then
                    return Color3.new(r, g, b)
                end

                return Color3.fromRGB(r, g, b)
            end
        end

        return fallback
    end

    local function ColorToConfig(color)
        return {
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5),
        }
    end

    local StateSaver = {
        partStates = {},
        effectStates = {},
        objectStates = {},
        cleanupInterval = 300,
        lastCleanup = time(),
    }

    function StateSaver:SavePart(part)
        if not part or self.partStates[part] then return end
        self.partStates[part] = {
            Transparency = part.Transparency,
            CanCollide = part.CanCollide,
            CanTouch = part.CanTouch,
            CanQuery = part.CanQuery,
            Material = part.Material,
            Color = part.Color,
            BrickColor = part.BrickColor,
            Reflectance = part.Reflectance,
            CFrame = part.CFrame,
            Size = part.Size,
            Anchored = part.Anchored,
            CastShadow = part.CastShadow,
            LocalTransparencyModifier = part.LocalTransparencyModifier,
        }
    end

    function StateSaver:RestorePart(part)
        local state = part and self.partStates[part]
        if not state then return end

        for property, value in pairs(state) do
            pcall(function()
                part[property] = value
            end)
        end

        self.partStates[part] = nil
    end

    function StateSaver:SaveEffect(effect)
        if not effect or self.effectStates[effect] then return end

        local state = {}
        for _, property in ipairs({
            "Enabled", "Brightness", "Contrast", "Saturation", "TintColor",
            "Intensity", "Size", "Threshold", "Spread", "FarIntensity",
            "NearIntensity", "InFocusRadius", "FocusDistance", "Density",
            "Haze", "Glare",
        }) do
            pcall(function()
                state[property] = effect[property]
            end)
        end

        self.effectStates[effect] = state
    end

    function StateSaver:RestoreEffect(effect)
        local state = effect and self.effectStates[effect]
        if not state then return end

        for property, value in pairs(state) do
            pcall(function()
                effect[property] = value
            end)
        end

        self.effectStates[effect] = nil
    end

    function StateSaver:SaveObject(key, values)
        if self.objectStates[key] then return end
        self.objectStates[key] = values
    end

    function StateSaver:RestoreObject(key, callback)
        local state = self.objectStates[key]
        if not state then return end
        callback(state)
        self.objectStates[key] = nil
    end

    function StateSaver:Cleanup()
        local now = time()
        if now - self.lastCleanup < self.cleanupInterval then return end
        self.lastCleanup = now

        for part in pairs(self.partStates) do
            if not part or not part.Parent then
                self.partStates[part] = nil
            end
        end

        for effect in pairs(self.effectStates) do
            if not effect or not effect.Parent then
                self.effectStates[effect] = nil
            end
        end
    end

    local stateSaver = StateSaver

    task.spawn(function()
        while ModuleAlive do
            task.wait(stateSaver.cleanupInterval)
            if ModuleAlive then
                stateSaver:Cleanup()
            end
        end
    end)

    local OriginalLighting = {
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        ClockTime = Lighting.ClockTime,
        ShadowSoftness = Lighting.ShadowSoftness,
        GlobalShadows = Lighting.GlobalShadows,
        ExposureCompensation = Lighting.ExposureCompensation,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    }

    local OriginalGravity = Workspace.Gravity
    local OriginalTerrain = Terrain and {
        WaterColor = Terrain.WaterColor,
        WaterTransparency = Terrain.WaterTransparency,
        WaterReflectance = Terrain.WaterReflectance,
        WaterWaveSize = Terrain.WaterWaveSize,
        WaterWaveSpeed = Terrain.WaterWaveSpeed,
    } or nil

    local function forEachPart(root, callback)
        if not root then return end

        if root:IsA("BasePart") then
            callback(root)
        end

        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("BasePart") then
                callback(obj)
            end
        end
    end

    local function hideRoot(root)
        forEachPart(root, function(part)
            stateSaver:SavePart(part)
            part.Transparency = 1
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
        end)
    end

    local function restoreRoot(root)
        forEachPart(root, function(part)
            stateSaver:RestorePart(part)
        end)
    end

    local function GetWaterContainers()
        local containers = {}
        local water = Workspace:FindFirstChild("Water")
        if water then table.insert(containers, water) end

        local bridge = Workspace:FindFirstChild("Bridge")
        local liftBridge = bridge and bridge:FindFirstChild("VerticalLiftBridge")
        local waterModel = liftBridge and liftBridge:FindFirstChild("WaterModel")
        if waterModel then table.insert(containers, waterModel) end

        return containers
    end

    local function ForEachWaterPart(callback)
        for _, container in ipairs(GetWaterContainers()) do
            forEachPart(container, function(part)
                if part.Name == "Water" or container.Name == "Water" or container.Name == "WaterModel" then
                    callback(part)
                end
            end)
        end
    end

    local LightingManager = {
        effects = {
            AlwaysDay = Config.AlwaysDay or false,
            AlwaysNight = Config.AlwaysNight or false,
            NoFog = Config.NoFog or false,
            BrightMode = Config.BrightMode or false,
            ImprovedGraphics = Config.ImprovedGraphics or false,
            SoftShadows = Config.SoftShadows or false,
            RemoveShadows = Config.RemoveShadows or false,
            Reflections = Config.Reflections or false,
        },
        shadowParts = {},
        shadowsApplied = false,
    }

    function LightingManager:UpdateClockConnection()
        if self.effects.AlwaysDay or self.effects.AlwaysNight then
            if not FeatureConnections.ClockLock then
                AddConnection("ClockLock", RunService.Heartbeat:Connect(function()
                    if self.effects.AlwaysDay then
                        Lighting.ClockTime = 14
                    elseif self.effects.AlwaysNight then
                        Lighting.ClockTime = 0
                    end
                end))
            end
        else
            RemoveConnection("ClockLock")
            Lighting.ClockTime = OriginalLighting.ClockTime
        end
    end

    function LightingManager:Apply()
        if self.effects.AlwaysDay then
            Lighting.ClockTime = 14
        elseif self.effects.AlwaysNight then
            Lighting.ClockTime = 0
        end

        if self.effects.BrightMode then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        elseif self.effects.ImprovedGraphics then
            Lighting.Brightness = 1.2
            Lighting.Ambient = Color3.fromRGB(150, 150, 150)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        else
            Lighting.Brightness = Config.Brightness or OriginalLighting.Brightness
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        end

        Lighting.FogStart = self.effects.NoFog and 0 or OriginalLighting.FogStart
        Lighting.FogEnd = self.effects.NoFog and 1000000 or OriginalLighting.FogEnd
        Lighting.FogColor = OriginalLighting.FogColor

        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            stateSaver:SaveEffect(atmosphere)
            if self.effects.NoFog then
                atmosphere.Density = 0
                atmosphere.Haze = 0
                atmosphere.Glare = 0
            else
                stateSaver:RestoreEffect(atmosphere)
            end
        end

        Lighting.GlobalShadows = self.effects.RemoveShadows and false or OriginalLighting.GlobalShadows
        Lighting.ShadowSoftness = (self.effects.SoftShadows and not self.effects.RemoveShadows) and 0.5 or OriginalLighting.ShadowSoftness

        if self.effects.RemoveShadows then
            if not self.shadowsApplied then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        stateSaver:SavePart(obj)
                        self.shadowParts[obj] = true
                        obj.CastShadow = false
                    end
                end
                self.shadowsApplied = true
            end
        else
            for part in pairs(self.shadowParts) do
                stateSaver:RestorePart(part)
            end
            self.shadowParts = {}
            self.shadowsApplied = false
        end

        if self.effects.Reflections then
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            if Terrain then Terrain.WaterReflectance = 0.35 end
        else
            Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale
            if Terrain and OriginalTerrain then Terrain.WaterReflectance = OriginalTerrain.WaterReflectance end
        end

        self:UpdateClockConnection()
    end

    function LightingManager:SetEffect(effect, value)
        self.effects[effect] = value
        self:Apply()

        local needsLock = self.effects.NoFog or self.effects.BrightMode or self.effects.ImprovedGraphics
            or self.effects.RemoveShadows or self.effects.SoftShadows or self.effects.Reflections

        if needsLock then
            AddConnection("LightingLock", RunService.Heartbeat:Connect(function()
                self:Apply()
            end))
        else
            RemoveConnection("LightingLock")
        end
    end

    local WaterManager = {
        effects = {
            WaterWalk = Config.WaterWalk or false,
            RemoveWater = Config.RemoveWater or false,
            RealisticWater = Config.RealisticWater or false,
        }
    }

    function WaterManager:Apply()
        local customWaterColor = ToColor3(Config.WaterColor, OriginalTerrain and OriginalTerrain.WaterColor or Color3.fromRGB(0, 100, 200))

        ForEachWaterPart(function(part)
            stateSaver:SavePart(part)
            local original = stateSaver.partStates[part]
            if not original then return end

            part.Transparency = original.Transparency
            part.CanCollide = original.CanCollide
            part.CanTouch = original.CanTouch
            part.CanQuery = original.CanQuery
            part.Color = original.Color
            part.BrickColor = original.BrickColor

            if self.effects.RemoveWater then
                part.Transparency = 1
                part.CanCollide = false
                part.CanTouch = false
            elseif self.effects.RealisticWater then
                part.Transparency = 0.3
                part.Color = customWaterColor
                part.CanCollide = self.effects.WaterWalk and true or original.CanCollide
            elseif self.effects.WaterWalk then
                part.Color = customWaterColor
                part.CanCollide = true
            else
                stateSaver:RestorePart(part)
                part.Color = customWaterColor
            end
        end)

        if Terrain and OriginalTerrain then
            if self.effects.RealisticWater then
                Terrain.WaterColor = customWaterColor
                Terrain.WaterTransparency = 0.3
                Terrain.WaterReflectance = 0.25
                Terrain.WaterWaveSize = 0.15
                Terrain.WaterWaveSpeed = 10
            elseif not LightingManager.effects.Reflections then
                Terrain.WaterColor = customWaterColor
                Terrain.WaterTransparency = OriginalTerrain.WaterTransparency
                Terrain.WaterReflectance = OriginalTerrain.WaterReflectance
                Terrain.WaterWaveSize = OriginalTerrain.WaterWaveSize
                Terrain.WaterWaveSpeed = OriginalTerrain.WaterWaveSpeed
            else
                Terrain.WaterColor = customWaterColor
                Terrain.WaterTransparency = OriginalTerrain.WaterTransparency
                Terrain.WaterReflectance = 0.35
                Terrain.WaterWaveSize = OriginalTerrain.WaterWaveSize
                Terrain.WaterWaveSpeed = OriginalTerrain.WaterWaveSpeed
            end
        end
    end

    function WaterManager:SetEffect(effect, value)
        self.effects[effect] = value
        self:Apply()
    end

    local RemovalManager = {
        ShrineRemoved = false,
        ShrineObjects = {},
        LavaSoundStates = {},
        LavaEffectStates = {},
    }

    local function isCharacterDescendant(obj)
        local character = Player and Player.Character
        return character and obj:IsDescendantOf(character)
    end

    local function isMapRegion(obj)
        local current = obj
        while current and current ~= Workspace do
            if current.Name:find("^Region_") or current.Name == "Water" or current.Name == "Bridge" or current.Name == "TreeRegion" then
                return true
            end
            current = current.Parent
        end
        return false
    end

    function RemovalManager:ToggleLava(hide)
        local volcano = Workspace:FindFirstChild("Region_Volcano")

        if volcano then
            forEachPart(volcano, function(part)
                if part.Name == "Lava" or (part.Parent and part.Parent.Name == "Lava") then
                    if hide then
                        hideRoot(part)
                    else
                        stateSaver:RestorePart(part)
                    end
                end
            end)
        end

        local function isLavaRelated(obj)
            local name = string.lower(obj.Name)
            local fullName = string.lower(obj:GetFullName())
            return name:find("lava") or name:find("volcano") or fullName:find("lava") or fullName:find("volcano")
        end

        for _, obj in ipairs(game:GetDescendants()) do
            if isLavaRelated(obj) then
                if obj:IsA("Sound") then
                    if hide then
                        if not self.LavaSoundStates[obj] then
                            self.LavaSoundStates[obj] = {Volume = obj.Volume, Playing = obj.Playing}
                        end
                        obj.Volume = 0
                        obj:Stop()
                    elseif self.LavaSoundStates[obj] then
                        local state = self.LavaSoundStates[obj]
                        obj.Volume = state.Volume
                        if state.Playing then obj:Play() end
                        self.LavaSoundStates[obj] = nil
                    end
                elseif obj:IsA("ColorCorrectionEffect") or obj:IsA("BlurEffect") or obj:IsA("BloomEffect") then
                    if hide then
                        if not self.LavaEffectStates[obj] then
                            self.LavaEffectStates[obj] = obj.Enabled
                        end
                        obj.Enabled = false
                    elseif self.LavaEffectStates[obj] ~= nil then
                        obj.Enabled = self.LavaEffectStates[obj]
                        self.LavaEffectStates[obj] = nil
                    end
                elseif obj:IsA("GuiObject") then
                    if hide then
                        if not self.LavaEffectStates[obj] then
                            self.LavaEffectStates[obj] = obj.Visible
                        end
                        obj.Visible = false
                    elseif self.LavaEffectStates[obj] ~= nil then
                        obj.Visible = self.LavaEffectStates[obj]
                        self.LavaEffectStates[obj] = nil
                    end
                end
            end
        end
    end

    function RemovalManager:ToggleSpawnerParts(regionName, connectionName, hide)
        local region = Workspace:FindFirstChild(regionName)
        local spawner = region and region:FindFirstChild("PartSpawner")
        if not spawner then return end

        local function apply(obj)
            if hide then hideRoot(obj) else restoreRoot(obj) end
        end

        for _, child in ipairs(spawner:GetChildren()) do
            apply(child)
        end

        if hide then
            AddConnection(connectionName, spawner.ChildAdded:Connect(function(child)
                task.wait()
                if Config[connectionName] or hide then
                    apply(child)
                end
            end))
        else
            RemoveConnection(connectionName)
        end
    end

    function RemovalManager:ToggleShrine()
        self.ShrineRemoved = not self.ShrineRemoved

        if #self.ShrineObjects == 0 then
            local mountainside = Workspace:FindFirstChild("Region_Mountainside")
            if mountainside then
                local doorFolder = mountainside:FindFirstChild("Door")
                local boulderRegen = mountainside:FindFirstChild("BoulderRegen")
                local door = doorFolder and doorFolder:FindFirstChild("Door")
                local boulder = boulderRegen and boulderRegen:FindFirstChild("Boulder")

                if door then table.insert(self.ShrineObjects, door) end
                if doorFolder then table.insert(self.ShrineObjects, doorFolder) end
                if boulder then table.insert(self.ShrineObjects, boulder) end

                if #self.ShrineObjects == 0 then
                    local fallbackDoor = mountainside:FindFirstChild("Door", true)
                    local fallbackBoulder = mountainside:FindFirstChild("Boulder", true)
                    if fallbackDoor then table.insert(self.ShrineObjects, fallbackDoor) end
                    if fallbackBoulder then table.insert(self.ShrineObjects, fallbackBoulder) end
                end
            end
        end

        for _, obj in ipairs(self.ShrineObjects) do
            if self.ShrineRemoved then hideRoot(obj) else restoreRoot(obj) end
        end

        Notify("World", "Santuario: " .. tostring(#self.ShrineObjects) .. " objeto(s).", 3)
    end

    function RemovalManager:ToggleTrees(hide)
        local regions = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "TreeRegion" then
                table.insert(regions, obj)
            end
        end

        local function applyTree(tree)
            if hide then hideRoot(tree) else restoreRoot(tree) end
        end

        for index, region in ipairs(regions) do
            for _, tree in ipairs(region:GetChildren()) do
                applyTree(tree)
            end
            
            local connectionName = "Trees_" .. tostring(index)

            if hide then
                AddConnection(connectionName, region.ChildAdded:Connect(function(tree)
                    task.wait()
                    applyTree(tree)
                end))
            else
                RemoveConnection(connectionName)
            end
        end
    end

    function RemovalManager:ToggleBuildings(hide)
        local playerModels = Workspace:FindFirstChild("PlayerModels")
        if not playerModels then return end

        local function isBuilding(model)
            return model:IsA("Model") and model:FindFirstChild("Owner") and not model:FindFirstChildOfClass("Humanoid")
        end

        local function apply(model)
            if isBuilding(model) then
                if hide then hideRoot(model) else restoreRoot(model) end
            end
        end

        for _, model in ipairs(playerModels:GetChildren()) do
            apply(model)
        end

        if hide then
            AddConnection("RemoveBuildings", playerModels.ChildAdded:Connect(function(model)
                task.wait()
                apply(model)
            end))
        else
            RemoveConnection("RemoveBuildings")
        end
    end

    function RemovalManager:ToggleItems(hide)
        Notify("World", "Remover itens do chao e experimental.", 3)

        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart")
                and not part.Anchored
                and not isCharacterDescendant(part)
                and not isMapRegion(part)
                and not part:FindFirstAncestorOfClass("Tool")
                and not (part.Parent and part.Parent:FindFirstChildOfClass("Humanoid")) then
                if hide then
                    hideRoot(part)
                else
                    stateSaver:RestorePart(part)
                end
            end
        end
    end

    local ThemeManager = {
        activeTheme = nil,
        originalParts = {},
        originalLighting = nil,
    }

    function ThemeManager:SavePart(part)
        if self.originalParts[part] then return end
        self.originalParts[part] = {
            Material = part.Material,
            Color = part.Color,
            BrickColor = part.BrickColor,
            Transparency = part.Transparency,
            Reflectance = part.Reflectance,
        }
    end

    function ThemeManager:RestoreOriginal()
        for part, state in pairs(self.originalParts) do
            if part and part.Parent then
                for property, value in pairs(state) do
                    pcall(function()
                        part[property] = value
                    end)
                end
            end
        end

        self.originalParts = {}

        if self.originalLighting then
            for property, value in pairs(self.originalLighting) do
                pcall(function()
                    Lighting[property] = value
                end)
            end
            self.originalLighting = nil
        end
    end

    function ThemeManager:StylePart(part, styles)
        self:SavePart(part)
        for property, value in pairs(styles) do
            part[property] = value
        end
    end

    function ThemeManager:ApplyTheme(themeName)
        self:RestoreOriginal()
        self.activeTheme = themeName

        if themeName == "Halloween" then
            self.originalLighting = {
                ClockTime = Lighting.ClockTime,
                FogColor = Lighting.FogColor,
                Ambient = Lighting.Ambient,
            }
            Lighting.ClockTime = 0
            Lighting.FogColor = Color3.fromRGB(35, 10, 55)
            Lighting.Ambient = Color3.fromRGB(45, 20, 65)
        end

        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if themeName == "Christmas" then
                    if part.Name == "Road" then
                        self:StylePart(part, {Material = Enum.Material.Glacier, BrickColor = BrickColor.new("Institutional white")})
                    elseif part.Name == "Ground" or part.Name == "LeafPart" then
                        self:StylePart(part, {Material = Enum.Material.Snow, BrickColor = BrickColor.new("Institutional white")})
                    elseif part.Name == "Slate" or part.Name == "Pebble" then
                        self:StylePart(part, {Material = Enum.Material.Ice, BrickColor = BrickColor.new("Institutional white")})
                    end
                elseif themeName == "Autumn" then
                    if part.Name == "Road" then
                        self:StylePart(part, {Material = Enum.Material.Cobblestone, BrickColor = BrickColor.new("Mid gray")})
                    elseif part.Name == "Ground" or part.Name == "LeafPart" then
                        self:StylePart(part, {Material = Enum.Material.Grass, BrickColor = BrickColor.new("Nougat")})
                    elseif part.Name == "Slate" then
                        self:StylePart(part, {BrickColor = BrickColor.new("Brown")})
                    elseif part.Name == "Pebble" then
                        self:StylePart(part, {Material = Enum.Material.Sand, BrickColor = BrickColor.new("Brick yellow")})
                    end
                elseif themeName == "Alien" then
                    if part.Name == "Road" then
                        self:StylePart(part, {Material = Enum.Material.Granite, BrickColor = BrickColor.new("Parsley green")})
                    elseif part.Name == "Ground" then
                        self:StylePart(part, {Material = Enum.Material.Glass, BrickColor = BrickColor.new("Royal purple")})
                    elseif part.Name == "WoodSection" then
                        self:StylePart(part, {Material = Enum.Material.Neon, BrickColor = BrickColor.new("New Yeller")})
                    elseif part.Name == "LeafPart" then
                        self:StylePart(part, {Material = Enum.Material.Neon, BrickColor = BrickColor.new("Toothpaste")})
                    elseif part.Name == "Slate" then
                        self:StylePart(part, {Material = Enum.Material.Granite, BrickColor = BrickColor.new("Dark blue")})
                    end
                elseif themeName == "Halloween" then
                    if part.Name == "Road" then
                        self:StylePart(part, {Material = Enum.Material.Slate, BrickColor = BrickColor.new("Really black")})
                    elseif part.Name == "Ground" then
                        self:StylePart(part, {Material = Enum.Material.Grass, BrickColor = BrickColor.new("Dark orange")})
                    elseif part.Name == "LeafPart" then
                        self:StylePart(part, {BrickColor = BrickColor.new("Bright orange")})
                    elseif part.Name == "Slate" then
                        self:StylePart(part, {BrickColor = BrickColor.new("Black")})
                    elseif part.Name == "Pebble" then
                        self:StylePart(part, {BrickColor = BrickColor.new("Reddish brown")})
                    end
                end
            end
        end
    end

    local ThemeToggles = {}

    function ThemeManager:SetTheme(themeName, enabled)
        for name, toggle in pairs(ThemeToggles) do
            Config[name .. "Theme"] = false
            if name ~= themeName and toggle and toggle.GetState and toggle:GetState() then
                toggle:SetState(false, true)
            end
        end

        if enabled then
            Config[themeName .. "Theme"] = true
            self:ApplyTheme(themeName)
            Notify("Theme", themeName .. " aplicado.", 2)
        else
            self.activeTheme = nil
            self:RestoreOriginal()
        end
    end

    function ThemeManager:DisableTheme()
        for name, toggle in pairs(ThemeToggles) do
            Config[name .. "Theme"] = false
            if toggle and toggle.GetState and toggle:GetState() then
                toggle:SetState(false, true)
            end
        end
        self.activeTheme = nil
        self:RestoreOriginal()
    end

    local GraphicsManager = {
        effects = {
            BetterGraphics = Config.BetterGraphics or false,
            Bloom = Config.Bloom or false,
            DepthOfField = Config.DepthOfField or false,
        }
    }

    function GraphicsManager:GetEffect(name, className)
        local existing = Lighting:FindFirstChild(name)
        if existing then return existing end

        local instance = TrackInstance(Instance.new(className))
        instance.Name = name
        instance.Parent = Lighting
        return instance
    end

    function GraphicsManager:Apply()
        local color = self:GetEffect("VanguardColorCorrection", "ColorCorrectionEffect")
        local blur = self:GetEffect("VanguardBlur", "BlurEffect")
        local sun = self:GetEffect("VanguardSunRays", "SunRaysEffect")
        local bloom = self:GetEffect("VanguardBloom", "BloomEffect")
        local dof = self:GetEffect("VanguardDepthOfField", "DepthOfFieldEffect")

        color.Enabled = self.effects.BetterGraphics
        color.Brightness = 0.03
        color.Contrast = 0.3
        color.Saturation = 0.01
        color.TintColor = Color3.fromRGB(244, 244, 244)

        blur.Enabled = self.effects.BetterGraphics
        blur.Size = 3

        sun.Enabled = self.effects.BetterGraphics
        sun.Intensity = 0.1
        sun.Spread = 1

        bloom.Enabled = self.effects.Bloom
        bloom.Intensity = Config.BloomIntensity or 1
        bloom.Size = 56
        bloom.Threshold = 0.5

        dof.Enabled = self.effects.DepthOfField
        dof.FarIntensity = 0.25
        dof.NearIntensity = 0.05
        dof.InFocusRadius = 20
        dof.FocusDistance = 25
    end

    function GraphicsManager:SetEffect(effect, value)
        self.effects[effect] = value
        self:Apply()
    end

    local ExtraManager = {
        XrayStates = {},
        BridgeStates = {},
    }

    function ExtraManager:SetXray(enabled)
        if enabled then
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not isCharacterDescendant(part) and not isMapRegion(part) then
                    stateSaver:SavePart(part)
                    self.XrayStates[part] = true
                    pcall(function()
                        part.LocalTransparencyModifier = math.clamp(part.LocalTransparencyModifier + 0.65, 0, 0.95)
                    end)
                end
            end
        else
            for part in pairs(self.XrayStates) do
                stateSaver:RestorePart(part)
            end
            self.XrayStates = {}
        end
    end

    function ExtraManager:SetBridgeRaised(enabled)
        local bridge = Workspace:FindFirstChild("Bridge")
        local liftBridge = bridge and bridge:FindFirstChild("VerticalLiftBridge")
        local lift = liftBridge and liftBridge:FindFirstChild("Lift")
        if not lift then return end

        forEachPart(lift, function(part)
            if not self.BridgeStates[part] then
                self.BridgeStates[part] = part.CFrame
            end

            part.CFrame = enabled and (self.BridgeStates[part] + Vector3.new(0, 26, 0)) or self.BridgeStates[part]
        end)
    end

    function ExtraManager:SetNamedParts(names, enabled, styles)
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and names[part.Name] then
                if enabled then
                    stateSaver:SavePart(part)
                    for property, value in pairs(styles) do
                        part[property] = value
                    end
                else
                    stateSaver:RestorePart(part)
                end
            end
        end
    end

    function ExtraManager:SetLeafColor(color)
        local leaves = {}
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "LeafPart" then
                table.insert(leaves, part)
            end
        end

        task.spawn(function()
            local batchSize = 100
            for i, part in ipairs(leaves) do
                if not ModuleAlive then return end
                stateSaver:SavePart(part)
                part.Color = color
                if i % batchSize == 0 then
                    RunService.Heartbeat:Wait()
                end
            end
        end)
    end

    local function SetSpook(enabled)
        local spook = Lighting:FindFirstChild("Spook")
        if not spook then
            Notify("World", "Spook nao esta disponivel neste servidor.", 3)
            return
        end

        local ok = pcall(function()
            spook.Value = enabled
        end)

        if not ok then
            Notify("World", "Spook nao pode ser alterado neste servidor.", 3)
        end
    end

    local function CreateManagerToggle(section, label, configKey, manager, effect)
        return section:Toggle(label, configKey, Config[configKey] or false, function(value)
            Config[configKey] = value
            manager:SetEffect(effect or configKey, value)
        end)
    end

    local LightingSection = Tab:Section(Utils._("world_lighting"), true)

    local AlwaysDayToggle
    local AlwaysNightToggle

    AlwaysDayToggle = LightingSection:Toggle(Utils._("world_always_day"), "AlwaysDay", Config.AlwaysDay or false, function(value)
        Config.AlwaysDay = value
        LightingManager.effects.AlwaysDay = value
        if value and AlwaysNightToggle and AlwaysNightToggle:GetState() then
            AlwaysNightToggle:SetState(false)
        end
        LightingManager:Apply()
    end)

    AlwaysNightToggle = LightingSection:Toggle(Utils._("world_always_night"), "AlwaysNight", Config.AlwaysNight or false, function(value)
        Config.AlwaysNight = value
        LightingManager.effects.AlwaysNight = value
        if value and AlwaysDayToggle and AlwaysDayToggle:GetState() then
            AlwaysDayToggle:SetState(false)
        end
        LightingManager:Apply()
    end)

    CreateManagerToggle(LightingSection, Utils._("world_no_fog"), "NoFog", LightingManager)
    CreateManagerToggle(LightingSection, Utils._("world_bright_mode"), "BrightMode", LightingManager)

    LightingSection:Toggle(Utils._("world_spook"), "Spook", Config.Spook or false, function(value)
        Config.Spook = value
        SetSpook(value)
    end)

    LightingSection:Slider(Utils._("world_brightness"), "Brightness", Config.Brightness or 1, 1, 50, false, function(value)
        Config.Brightness = value
        LightingManager:Apply()
    end)

    LightingSection:Slider(Utils._("world_gravity"), "Gravity", Config.Gravity or OriginalGravity, 16, 500, false, function(value)
        Config.Gravity = value
        Workspace.Gravity = value
    end)

    local WaterSection = Tab:Section(Utils._("world_water"), true)

    CreateManagerToggle(WaterSection, Utils._("world_water_walk"), "WaterWalk", WaterManager)
    CreateManagerToggle(WaterSection, Utils._("world_remove_water"), "RemoveWater", WaterManager)
    CreateManagerToggle(WaterSection, Utils._("world_realistic_water"), "RealisticWater", WaterManager)

    WaterSection:ColorPicker(Utils._("world_water_color"), "WaterColor", ToColor3(Config.WaterColor, Color3.fromRGB(0, 100, 200)), function(value)
        Config.WaterColor = ColorToConfig(value)
        WaterManager:Apply()
    end)

    local RemovalsSection = Tab:Section(Utils._("world_removals"), true)

    CreateManagerToggle(RemovalsSection, Utils._("world_remove_shadows"), "RemoveShadows", LightingManager)

    RemovalsSection:Toggle(Utils._("world_remove_lava"), "RemoveLava", Config.RemoveLava or false, function(value)
        Config.RemoveLava = value
        RemovalManager:ToggleLava(value)
    end)

    RemovalsSection:Button(Utils._("world_remove_shrine"), function()
        Config.RemoveShrine = not Config.RemoveShrine
        RemovalManager:ToggleShrine()
    end)

    RemovalsSection:Toggle(Utils._("world_remove_snow"), "RemoveSnowRocks", Config.RemoveSnowRocks or false, function(value)
        Config.RemoveSnowRocks = value
        RemovalManager:ToggleSpawnerParts("Region_Snow", "RemoveSnowRocks", value)
    end)

    RemovalsSection:Toggle(Utils._("world_remove_volcano"), "RemoveVolcanoRocks", Config.RemoveVolcanoRocks or false, function(value)
        Config.RemoveVolcanoRocks = value
        RemovalManager:ToggleSpawnerParts("Region_Volcano", "RemoveVolcanoRocks", value)
    end)

    RemovalsSection:Toggle(Utils._("world_remove_trees"), "RemoveTrees", Config.RemoveTrees or false, function(value)
        Config.RemoveTrees = value
        RemovalManager:ToggleTrees(value)
    end)

    RemovalsSection:Toggle(Utils._("world_remove_buildings"), "RemoveBuildings", Config.RemoveBuildings or false, function(value)
        Config.RemoveBuildings = value
        RemovalManager:ToggleBuildings(value)
    end)

    RemovalsSection:Toggle(Utils._("world_remove_items"), "RemoveItems", Config.RemoveItems or false, function(value)
        Config.RemoveItems = value
        RemovalManager:ToggleItems(value)
    end)

    local ThemesSection = Tab:Section(Utils._("world_themes"), true)

    ThemeToggles.Christmas = ThemesSection:Toggle(Utils._("world_christmas"), "ChristmasTheme", Config.ChristmasTheme or false, function(value)
        ThemeManager:SetTheme("Christmas", value)
    end)

    ThemeToggles.Halloween = ThemesSection:Toggle(Utils._("world_halloween"), "HalloweenTheme", Config.HalloweenTheme or false, function(value)
        ThemeManager:SetTheme("Halloween", value)
    end)

    ThemeToggles.Autumn = ThemesSection:Toggle(Utils._("world_autumn"), "AutumnTheme", Config.AutumnTheme or false, function(value)
        ThemeManager:SetTheme("Autumn", value)
    end)

    ThemeToggles.Alien = ThemesSection:Toggle(Utils._("world_alien"), "AlienTheme", Config.AlienTheme or false, function(value)
        ThemeManager:SetTheme("Alien", value)
    end)

    ThemesSection:Button(Utils._("world_disable_theme"), function()
        ThemeManager:DisableTheme()
        Notify("Theme", "Tema desativado.", 2)
    end)

    local GraphicsSection = Tab:Section(Utils._("world_graphics"), true)

    CreateManagerToggle(GraphicsSection, Utils._("world_improved_graphics"), "ImprovedGraphics", LightingManager)
    CreateManagerToggle(GraphicsSection, Utils._("world_better_graphics"), "BetterGraphics", GraphicsManager)
    CreateManagerToggle(GraphicsSection, Utils._("world_bloom"), "Bloom", GraphicsManager)

    local AntiAliasingToggle
    local AntiAliasingResetting = false
    
    AntiAliasingToggle = GraphicsSection:Toggle(Utils._("world_antialiasing"), "AntiAliasing", Config.AntiAliasing or false, function(value)
        if AntiAliasingResetting then return end
        
        Config.AntiAliasing = false
        Notify("Graficos", "Anti-Aliasing nao e suportado neste cliente.", 3)
        
        if value and AntiAliasingToggle then
            AntiAliasingResetting = true
            AntiAliasingToggle:SetState(false)
            AntiAliasingResetting = false
        end
    end)

    CreateManagerToggle(GraphicsSection, Utils._("world_soft_shadows"), "SoftShadows", LightingManager)
    CreateManagerToggle(GraphicsSection, Utils._("world_reflections"), "Reflections", LightingManager)
    CreateManagerToggle(GraphicsSection, Utils._("world_dof"), "DepthOfField", GraphicsManager)

    GraphicsSection:Slider(Utils._("world_bloom_intensity"), "BloomIntensity", Config.BloomIntensity or 1, 0, 10, true, function(value)
        Config.BloomIntensity = value
        GraphicsManager:Apply()
    end)

    local ExtraSection = Tab:Section("Ambiente extra", false)

    ExtraSection:Toggle("X-Ray", "Xray", Config.Xray or false, function(value)
        Config.Xray = value
        ExtraManager:SetXray(value)
    end)

    local BridgeRaisedToggle = ExtraSection:Toggle("Ponte Levantada", "BridgeRaised", Config.BridgeRaised or false, function(value)
        Config.BridgeRaised = value
        ExtraManager:SetBridgeRaised(value)
    end)

    ExtraSection:Button("Levantar Ponte", function()
        BridgeRaisedToggle:SetState(true)
    end)

    ExtraSection:Button("Abaixar Ponte", function()
        BridgeRaisedToggle:SetState(false)
    end)

    ExtraSection:Toggle("Estradas Realistas", "RealisticRoads", Config.RealisticRoads or false, function(value)
        Config.RealisticRoads = value
        ExtraManager:SetNamedParts({Road = true}, value, {
            Material = Enum.Material.CrackedLava,
            BrickColor = BrickColor.new("Really black"),
        })
    end)

    ExtraSection:Toggle("Grama Realista", "RealisticGrass", Config.RealisticGrass or false, function(value)
        Config.RealisticGrass = value
        ExtraManager:SetNamedParts({Ground = true}, value, {
            Material = Enum.Material.Grass,
            BrickColor = BrickColor.new("Camo"),
        })
    end)

    ExtraSection:ColorPicker("Cor das Folhas", "LeafColor", ToColor3(Config.LeafColor, Color3.fromRGB(79, 63, 29)), function(value)
        Config.LeafColor = ColorToConfig(value)
        ExtraManager:SetLeafColor(value)
    end)

    LightingManager:Apply()
    WaterManager:Apply()
    GraphicsManager:Apply()

    local function Cleanup()
        ModuleAlive = false

        for name in pairs(FeatureConnections) do
            RemoveConnection(name)
        end

        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.FogStart = OriginalLighting.FogStart
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogColor = OriginalLighting.FogColor
        Lighting.ShadowSoftness = OriginalLighting.ShadowSoftness
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation
        Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale

        Workspace.Gravity = OriginalGravity

        if Terrain and OriginalTerrain then
            Terrain.WaterColor = OriginalTerrain.WaterColor
            Terrain.WaterTransparency = OriginalTerrain.WaterTransparency
            Terrain.WaterReflectance = OriginalTerrain.WaterReflectance
            Terrain.WaterWaveSize = OriginalTerrain.WaterWaveSize
            Terrain.WaterWaveSpeed = OriginalTerrain.WaterWaveSpeed
        end

        ThemeManager:RestoreOriginal()
        RemovalManager:ToggleLava(false)
        ExtraManager:SetXray(false)
        ExtraManager:SetBridgeRaised(false)

        local savedParts = {}
        for part in pairs(stateSaver.partStates) do
            table.insert(savedParts, part)
        end

        for _, part in ipairs(savedParts) do
            stateSaver:RestorePart(part)
        end

        local savedEffects = {}
        for effect in pairs(stateSaver.effectStates) do
            table.insert(savedEffects, effect)
        end

        for _, effect in ipairs(savedEffects) do
            stateSaver:RestoreEffect(effect)
        end

        for _, instance in ipairs(CreatedInstances) do
            if instance and instance.Parent and instance.Name:find("^Vanguard") then
                instance:Destroy()
            end
        end
    end

    return Cleanup
end
