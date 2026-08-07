local World = {}

function World.Init(Tab, Lib)
    local Lighting    = game:GetService("Lighting")
    local RunService  = game:GetService("RunService")
    local Workspace   = game:GetService("Workspace")

    -- ===========================
    -- STATE & CACHE
    -- ===========================
    _G.TimeOfDay              = 12
    _G.TimeLock               = false
    _G.FullBright             = false
    _G.ShadowsEnabled         = true
    _G.FogEnabled             = true
    _G.WaterEnabled           = true
    _G.BouldersEnabled        = true -- Default to True (Boulders exist)
    _G.VolcanoBouldersEnabled = true -- Default to True (Boulders exist)
    _G.PostProcessing         = true
    _G.SpookEvent             = false
    _G.EnhancedGraphics       = false

    local waterParts             = {}
    local boulderParts           = {}
    local effectCache            = {}
    local originalLightingSettings = {}

    -- Cache atmosphere for efficiency
    local cachedAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    -- ===========================
    -- VOLCANO BOULDER WATCHER
    -- ===========================
    local _volcanoConn = nil

    local function KillVolcanoBoulder(obj)
        if obj.Name == "VolcanoBoulder" then
            pcall(function() obj:Destroy() end)
        end
    end

    local function StartVolcanoWatcher()
        local spawner = Workspace:FindFirstChild("Region_Volcano")
            and Workspace.Region_Volcano:FindFirstChild("PartSpawner")
        if spawner then
            for _, obj in ipairs(spawner:GetChildren()) do
                KillVolcanoBoulder(obj)
            end
            _volcanoConn = spawner.ChildAdded:Connect(KillVolcanoBoulder)
        else
            warn("[World] Region_Volcano.PartSpawner not found — will retry on next toggle.")
        end
    end

    local function StopVolcanoWatcher()
        if _volcanoConn then
            _volcanoConn:Disconnect()
            _volcanoConn = nil
        end
    end

    -- ===========================
    -- BRIDGE BACKUP
    -- ===========================
    local bridgeBackup = nil
    if Workspace:FindFirstChild("Bridge") then
        bridgeBackup = Workspace.Bridge:Clone()
    end

    -- ===========================
    -- WORLD SCAN
    -- ===========================
    local waterRoot   = Workspace:FindFirstChild("Water")
    local boulderRoot = Workspace:FindFirstChild("Region_Snow")
        and Workspace.Region_Snow:FindFirstChild("PartSpawner")

    local _tundraConn = nil 

    local function IsTundraBoulder(obj)
        return obj:IsA("BasePart")
            and (obj.Name == "Boulder" or obj.Name == "SmallBoulder")
            and not (obj:FindFirstChild("LavaLight") or obj:FindFirstChild("Fire"))
    end

    local function ApplyBoulderState(data)
        local part = data.Instance
        if part and part.Parent then
            -- If BouldersEnabled is true, show them. If false, hide/no-collide them.
            part.Transparency = _G.BouldersEnabled and data.OriginalTransparency or 1
            part.CanCollide   = _G.BouldersEnabled
        end
    end

    local function StartTundraWatcher()
        if _tundraConn or not boulderRoot then return end
        _tundraConn = boulderRoot.ChildAdded:Connect(function(obj)
            if not IsTundraBoulder(obj) then return end
            local data = { Instance = obj, OriginalTransparency = obj.Transparency }
            table.insert(boulderParts, data)
            if not _G.BouldersEnabled then ApplyBoulderState(data) end
        end)
    end

    local function StopTundraWatcher()
        if _tundraConn then _tundraConn:Disconnect(); _tundraConn = nil end
    end

    local function ScanContainer(root, fn)
        if not root then return end
        local descendants = root:GetDescendants()
        for i, obj in ipairs(descendants) do
            if i % 500 == 0 then task.wait() end
            fn(obj)
        end
    end

    local function ScanWorld()
        waterParts   = {}
        boulderParts = {}

        -- Store original Fog/Atmosphere settings for restoration
        originalLightingSettings.FogEnd = Lighting.FogEnd
        originalLightingSettings.FogStart = Lighting.FogStart
        if cachedAtmosphere then
            originalLightingSettings.AtmosphereDensity = cachedAtmosphere.Density
            originalLightingSettings.AtmosphereGlare = cachedAtmosphere.Glare
            originalLightingSettings.AtmosphereHaze = cachedAtmosphere.Haze
        end

        ScanContainer(waterRoot, function(obj)
            if obj:IsA("BasePart") and obj.Name == "Water" then
                table.insert(waterParts, { Instance = obj, OriginalTransparency = obj.Transparency })
            end
        end)

        ScanContainer(boulderRoot, function(obj)
            if IsTundraBoulder(obj) then
                table.insert(boulderParts, { Instance = obj, OriginalTransparency = obj.Transparency })
            end
        end)

        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostProcessEffect") or effect:IsA("BlurEffect")
            or effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect")
            or effect:IsA("SunRaysEffect") then
                effectCache[effect] = effect.Enabled
            end
        end

        StartTundraWatcher()

        if Lib and Lib.Notify then
            Lib:Notify("System", "World Scan Complete!", 2)
        end
    end

    task.spawn(ScanWorld)

    -- ===========================
    -- BRIDGE LOGIC
    -- ===========================
    local function ToggleBridge(state)
        if state then
            local bridge = Workspace:FindFirstChild("Bridge")
            if bridge then
                local vlb  = bridge:FindFirstChild("VerticalLiftBridge")
                local lift = vlb and vlb:FindFirstChild("Lift")
                if lift then
                    for _, child in ipairs(lift:GetChildren()) do
                        if child:IsA("BasePart") and child.Name == "Base" then
                            child.CFrame = CFrame.new(child.Position.X, 6.5, child.Position.Z) * child.CFrame.Rotation
                        end
                    end
                end
                local targets = { BRope = true, Structure = true, Weight = true, WRope = true }
                if vlb then
                    for _, child in ipairs(vlb:GetChildren()) do
                        if targets[child.Name] then child:Destroy() end
                    end
                end
            end
        else
            if bridgeBackup then
                if Workspace:FindFirstChild("Bridge") then
                    Workspace.Bridge:Destroy()
                end
                bridgeBackup:Clone().Parent = Workspace
            end
        end
    end

    -- ===========================
    -- ENHANCED VISUALS
    -- ===========================
    local function ToggleEnhanced(state)
        if state then
            originalLightingSettings.Brightness            = Lighting.Brightness
            originalLightingSettings.OutdoorAmbient        = Lighting.OutdoorAmbient
            originalLightingSettings.ExposureCompensation  = Lighting.ExposureCompensation

            Lighting.Brightness             = 3
            Lighting.ExposureCompensation   = 0.5

            local bloom = Lighting:FindFirstChild("EnhancedBloom") or Instance.new("BloomEffect", Lighting)
            bloom.Name = "EnhancedBloom"; bloom.Intensity = 1; bloom.Size = 24; bloom.Threshold = 2; bloom.Enabled = true

            local cc = Lighting:FindFirstChild("EnhancedCC") or Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "EnhancedCC"; cc.Contrast = 0.1; cc.Saturation = 0.15
            cc.TintColor = Color3.fromRGB(255, 253, 245); cc.Enabled = true

            local rays = Lighting:FindFirstChild("EnhancedRays") or Instance.new("SunRaysEffect", Lighting)
            rays.Name = "EnhancedRays"; rays.Intensity = 0.1; rays.Spread = 1; rays.Enabled = true
        else
            Lighting.Brightness             = originalLightingSettings.Brightness or 2
            Lighting.ExposureCompensation   = originalLightingSettings.ExposureCompensation or 0
            for _, n in ipairs({ "EnhancedBloom", "EnhancedCC", "EnhancedRays" }) do
                local e = Lighting:FindFirstChild(n)
                if e then e.Enabled = false end
            end
        end
    end

    -- ===========================
    -- WATER / BOULDERS
    -- ===========================
    local function ToggleWater(state)
        for _, data in ipairs(waterParts) do
            local part = data.Instance
            if part and part.Parent then
                part.Transparency = state and data.OriginalTransparency or 1
                part.CanCollide   = false
                part.CanTouch     = state
            end
        end
    end

    local function ToggleBoulders(state)
        for _, data in ipairs(boulderParts) do
            ApplyBoulderState(data)
        end
    end

    -- ===========================
    -- UI SECTIONS
    -- ===========================
    Tab:CreateSection("Lighting & Time")

    Tab:CreateSlider("Time of Day", 0, 24, 12, function(v)
        _G.TimeOfDay = v
        Lighting.ClockTime = v
    end)

    Tab:CreateToggle("Time Lock", false, function(s) _G.TimeLock = s end)

    Tab:CreateToggle("Full Bright", false, function(s)
        _G.FullBright = s
    end)

    Tab:CreateToggle("Shadows", true, function(s)
        _G.ShadowsEnabled       = s
        Lighting.GlobalShadows  = s
    end)

    Tab:CreateToggle("Fog", true, function(s)
        _G.FogEnabled = s
        if s then
            -- Restore original values when turning back ON
            Lighting.FogEnd = originalLightingSettings.FogEnd or 1000
            Lighting.FogStart = originalLightingSettings.FogStart or 0
            if cachedAtmosphere then
                cachedAtmosphere.Density = originalLightingSettings.AtmosphereDensity or 0.3
                cachedAtmosphere.Glare = originalLightingSettings.AtmosphereGlare or 0
                cachedAtmosphere.Haze = originalLightingSettings.AtmosphereHaze or 0
            end
        end
    end)

    Tab:CreateSection("Environment")

    Tab:CreateToggle("Enhanced Visuals", false, function(s)
        _G.EnhancedGraphics = s
        ToggleEnhanced(s)
        if Lib and Lib.Notify then Lib:Notify("Graphics", s and "Visuals Enhanced!" or "Visuals reset.", 3) end
    end)

    Tab:CreateToggle("Spook Event", false, function(s)
        _G.SpookEvent = s
        local spook = Lighting:FindFirstChild("Spook")
        if spook then
            spook.Value = s
        elseif Lib and Lib.Notify then
            Lib:Notify("Error", "Spook object not found in Lighting!", 3)
        end
    end)

    Tab:CreateToggle("Post-Processing", true, function(s)
        _G.PostProcessing = s
        for effect, originalState in pairs(effectCache) do
            if effect then effect.Enabled = s and originalState or false end
        end
    end)

    Tab:CreateToggle("Water Enabled", true, function(s)
        _G.WaterEnabled = s
        ToggleWater(s)
    end)

    Tab:CreateToggle("Lower Bridge", false, function(s)
        _G.BridgeDown = s
        ToggleBridge(s)
    end)

    -- Toggle Tundra Boulders: ON = Enabled (Default), OFF = Removed
    Tab:CreateToggle("Tundra Boulders", true, function(s)
        _G.BouldersEnabled = s
        ToggleBoulders(s)
    end)

    -- Toggle Volcano Boulders: ON = Enabled (Default), OFF = Removed
    Tab:CreateToggle("Volcano Boulders", true, function(s)
        _G.VolcanoBouldersEnabled = s
        if not s then StartVolcanoWatcher() else StopVolcanoWatcher() end
    end)

    -- ===========================
    -- MASTER LOOP
    -- ===========================
    RunService.RenderStepped:Connect(function()
        -- Handle Time Locking
        if _G.TimeLock then
            Lighting.ClockTime = _G.TimeOfDay
        end

        -- Handle FullBright
        if _G.FullBright then
            Lighting.Ambient        = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness     = 2
        end

        -- Handle Fog Removal
        if not _G.FogEnabled then
            Lighting.FogEnd = 1e6
            Lighting.FogStart = 1e6
            
            if not cachedAtmosphere then
                cachedAtmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
            end
            
            if cachedAtmosphere then
                cachedAtmosphere.Density = 0
                cachedAtmosphere.Glare = 0
                cachedAtmosphere.Haze = 0
            end
        end
    end)
end

return World
