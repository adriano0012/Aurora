-- ============================================================
-- VANGUARD HUB - TELEPORTS v1.0
-- ============================================================

return function(UI, Config, Utils)
    -- ============================================================
    -- SERVICES
    -- ============================================================
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = workspace
    local RunService = game:GetService("RunService")
    
    -- ============================================================
    -- PLAYER REFERENCES
    -- ============================================================
    
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = Workspace.CurrentCamera
    
    -- ============================================================
    -- STATE
    -- ============================================================
    
    local Connections = {}
    
    -- Follow state
    local FollowTarget = nil
    local FollowConnection = nil
    local PreviousFollowCFrame = nil
    
    -- Spectate state
    local SpectateTarget = nil
    local SpectateConnection = nil
    local OriginalCameraSubject = nil
    
    -- Click TP state
    local ClickTPConnection = nil
    
    -- Dropdown references
    local PlayerTPDropdown = nil
    local BaseTPDropdown = nil
    local FollowDropdown = nil
    local SpectateDropdown = nil
    
    -- Forward declarations
    local StopFollowing
    local StopSpectating
    
    -- ============================================================
    -- CONNECTION MANAGEMENT
    -- ============================================================
    
    local function TrackConnection(connection)
        table.insert(Connections, connection)
        return connection
    end
    
    local function Cleanup()
        if StopFollowing then StopFollowing() end
        if StopSpectating then StopSpectating() end
        
        if ClickTPConnection then
            ClickTPConnection:Disconnect()
            ClickTPConnection = nil
        end
        
        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        Connections = {}
        
        PlayerTPDropdown = nil
        BaseTPDropdown = nil
        FollowDropdown = nil
        SpectateDropdown = nil
    end
    
    -- ============================================================
    -- WAYPOINT DATABASE
    -- ============================================================
    
    local WaypointDB = {
        Spawn = CFrame.new(172, 5, 74),
        ["Wood R'Us"] = CFrame.new(265, 8, 57),
        ["Land Store"] = CFrame.new(258, 8, -99),
        Bridge = CFrame.new(112, 14, -782),
        Docks = CFrame.new(1114, 6, -197),
        ["The Den"] = CFrame.new(323, 52, 1930),
        Lighthouse = CFrame.new(1465, 359, 3257),
        Cabin = CFrame.new(1244, 69, 2306),
        ["Shrine Of Sight"] = CFrame.new(-1600, 198, 919),
        ["Strange Man"] = CFrame.new(1061, 23, 1131),
        ["Bird Cave"] = CFrame.new(4813, 36, -978),
        ["Wood Dropoff"] = CFrame.new(323, 0, 134),
        ["Cherry Meadow"] = CFrame.new(220, 62, 1306),
        ["Snow Biome"] = CFrame.new(890, 62, 1196),
        ["Tiaga Peak"] = CFrame.new(1560, 413, 3274),
        ["Palm Island"] = CFrame.new(2549, -2, -42),
        ["Palm Island 2"] = CFrame.new(1960, -2, -1501),
        ["Palm Island 3"] = CFrame.new(4344, -2, -1813),
        SnowGlow = CFrame.new(-1087, -2, -945),
        ["Cave Crawler"] = CFrame.new(3581, -176, 430),
        Swamp = CFrame.new(-1209, 135, -801),
        Volcano = CFrame.new(-1585, 628, 1140),
        ["Green Box"] = CFrame.new(-1668, 354, 1475),
        ["End Times"] = CFrame.new(113, -211, -951),
        ["Boxed Cars"] = CFrame.new(509, 8, -1463),
        ["Fancy Furnishings"] = CFrame.new(491, 16, -1720),
        ["Bob's Shack"] = CFrame.new(260, 11, -2542),
        ["Links Logic"] = CFrame.new(4605, 6, -727),
        ["Fine Art Shop"] = CFrame.new(5207, -163, 719),
    }
    
    local LocationList = {
        "Spawn", "Wood R'Us", "Land Store", "Bridge", "Docks",
        "The Den", "Lighthouse", "Cabin", "Shrine Of Sight",
        "Strange Man", "Bird Cave", "Wood Dropoff", "Cherry Meadow",
        "Snow Biome", "Tiaga Peak", "Palm Island", "End Times"
    }
    
    local StoreList = {
        "Wood R'Us", "Land Store", "Fancy Furnishings",
        "Boxed Cars", "Bob's Shack", "Links Logic", "Fine Art Shop"
    }
    
    local BiomeList = {
        "SnowGlow", "Palm Island", "Palm Island 2", "Palm Island 3",
        "End Times", "Cave Crawler", "Swamp", "Volcano",
        "Tiaga Peak", "Cherry Meadow", "Snow Biome"
    }
    
    local PathDB = {
        Palm = {},
        Volcano = {},
        Safari = {},
        Swamp = {},
        SnowGlow = {},
    }
    
    -- ============================================================
    -- HELPERS
    -- ============================================================
    
    local function GetCharacter(player)
        player = player or LocalPlayer
        return player and player.Character
    end
    
    local function GetRoot(player)
        local char = GetCharacter(player)
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    
    local function ValidateKeyName(keyName)
        if not keyName or type(keyName) ~= "string" then return false end
        return Enum.KeyCode[keyName] ~= nil
    end
    
    local function SafeTeleport(cframe)
        if not cframe then return false end
        
        local char = GetCharacter()
        if not char then
            Utils.Notify("Teleports", "Personagem não disponível", 2)
            return false
        end
        
        local root = GetRoot()
        if not root then
            Utils.Notify("Teleports", "RootPart não encontrado", 2)
            return false
        end
        
        local pos = cframe.Position
        if pos.X ~= pos.X or pos.Y ~= pos.Y or pos.Z ~= pos.Z then
            Utils.Notify("Teleports", "Coordenadas inválidas (NaN)", 2)
            return false
        end
        
        if pos.X == math.huge or pos.Y == math.huge or pos.Z == math.huge then
            Utils.Notify("Teleports", "Coordenadas inválidas (Inf)", 2)
            return false
        end
        
        local targetCFrame = cframe + Vector3.new(0, 3, 0)
        
        if root.AssemblyLinearVelocity then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        if root.AssemblyAngularVelocity then
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        local success = pcall(function()
            if char.PivotTo then
                char:PivotTo(targetCFrame)
            else
                root.CFrame = targetCFrame
            end
        end)
        
        return success
    end
    
    -- ============================================================
    -- PLAYER FUNCTIONS
    -- ============================================================
    
    local function GetPlayerList()
        local list = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(list, player.Name)
            end
        end
        return list
    end
    
    local function FindPlayerByName(name)
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name == name then
                return player
            end
        end
        return nil
    end
    
    local function TeleportToPlayer(playerName)
        local player = FindPlayerByName(playerName)
        if not player then
            Utils.Notify("Teleports", "Jogador não encontrado", 2)
            return
        end
        
        local root = GetRoot(player)
        if not root then
            Utils.Notify("Teleports", "Jogador não tem personagem", 2)
            return
        end
        
        SafeTeleport(root.CFrame)
    end
    
    local function TeleportToBase(playerName)
        local player = FindPlayerByName(playerName)
        if not player then
            Utils.Notify("Teleports", "Jogador não encontrado", 2)
            return
        end
        
        -- Method 1: Utils helper
        local property = Utils.GetProperty(playerName)
        if property and property:FindFirstChild("OriginSquare") then
            SafeTeleport(property.OriginSquare.CFrame + Vector3.new(0, 3, 0))
            return
        end
        
        -- Method 2: Search workspace.Properties
        local properties = Workspace:FindFirstChild("Properties")
        if properties then
            for _, prop in ipairs(properties:GetChildren()) do
                local owner = prop:FindFirstChild("Owner")
                if owner then
                    local ownerValue = owner.Value
                    -- Handle both Player object and string name
                    local isMatch = false
                    if type(ownerValue) == "userdata" then
                        -- It's a Player object
                        isMatch = ownerValue == player
                    elseif type(ownerValue) == "string" then
                        -- It's a string name
                        isMatch = ownerValue == playerName
                    end
                    
                    if isMatch then
                        local origin = prop:FindFirstChild("OriginSquare")
                        if origin then
                            SafeTeleport(origin.CFrame + Vector3.new(0, 3, 0))
                            return
                        end
                    end
                end
            end
        end
        
        Utils.Notify("Teleports", "Base não encontrada para " .. playerName, 2)
    end
    
    -- ============================================================
    -- FOLLOW (FIXED: PivotTo + distance threshold)
    -- ============================================================
    
    StopFollowing = function()
        if FollowConnection then
            FollowConnection:Disconnect()
            FollowConnection = nil
        end
        
        FollowTarget = nil
        
        if PreviousFollowCFrame then
            SafeTeleport(PreviousFollowCFrame)
            PreviousFollowCFrame = nil
        end
    end
    
    local function StartFollowing(playerName)
        if playerName == "Stop Following" then
            StopFollowing()
            return
        end
        
        local player = FindPlayerByName(playerName)
        if not player then return end
        
        local root = GetRoot()
        if root then
            PreviousFollowCFrame = root.CFrame
        end
        
        FollowTarget = player
        
        if FollowConnection then
            FollowConnection:Disconnect()
        end
        
        FollowConnection = TrackConnection(RunService.Heartbeat:Connect(function()
            if not FollowTarget then
                StopFollowing()
                return
            end
            
            local targetChar = GetCharacter(FollowTarget)
            if not targetChar then
                StopFollowing()
                return
            end
            
            local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and targetHumanoid.Health <= 0 then
                StopFollowing()
                return
            end
            
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local localChar = GetCharacter()
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            
            if not targetRoot or not localRoot then
                StopFollowing()
                return
            end
            
            -- Only move if distance > 8 studs (reduces jitter/physics conflicts)
            local distance = (localRoot.Position - targetRoot.Position).Magnitude
            if distance > 8 then
                local offset = targetRoot.CFrame.LookVector * -3
                local targetPos = targetRoot.CFrame.Position + offset
                local targetCFrame = CFrame.new(targetPos, targetRoot.CFrame.Position)
                
                if localChar.PivotTo then
                    localChar:PivotTo(targetCFrame)
                else
                    localRoot.CFrame = targetCFrame
                end
            end
        end))
    end
    
    -- ============================================================
    -- SPECTATE
    -- ============================================================
    
    StopSpectating = function()
        if SpectateConnection then
            SpectateConnection:Disconnect()
            SpectateConnection = nil
        end
        
        SpectateTarget = nil
        
        if OriginalCameraSubject then
            Camera.CameraSubject = OriginalCameraSubject
            OriginalCameraSubject = nil
        else
            local char = GetCharacter()
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    Camera.CameraSubject = humanoid
                end
            end
        end
    end
    
    local function StartSpectating(playerName)
        if playerName == "Stop Spectating" then
            StopSpectating()
            return
        end
        
        local player = FindPlayerByName(playerName)
        if not player then return end
        
        local char = GetCharacter(player)
        if not char then
            Utils.Notify("Teleports", "Jogador não tem personagem", 2)
            return
        end
        
        local targetHumanoid = char:FindFirstChildOfClass("Humanoid")
        if not targetHumanoid then
            Utils.Notify("Teleports", "Jogador não tem Humanoid", 2)
            return
        end
        
        OriginalCameraSubject = Camera.CameraSubject
        SpectateTarget = player
        
        if SpectateConnection then
            SpectateConnection:Disconnect()
        end
        
        Camera.CameraSubject = targetHumanoid
        
        SpectateConnection = TrackConnection(RunService.Heartbeat:Connect(function()
            if not SpectateTarget then
                StopSpectating()
                return
            end
            
            local char = GetCharacter(SpectateTarget)
            if not char then
                StopSpectating()
                return
            end
            
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                StopSpectating()
                return
            end
            
            Camera.CameraSubject = humanoid
        end))
    end
    
    -- ============================================================
    -- CLICK TP (FIXED: key validation)
    -- ============================================================
    
    local function SetupClickTP()
        if ClickTPConnection then
            ClickTPConnection:Disconnect()
            ClickTPConnection = nil
        end
        
        ClickTPConnection = TrackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if not Config.ClickTP then return end
            
            local clickKey = Config.ClickTPKey or "LeftControl"
            
            -- Validate key before using
            if not ValidateKeyName(clickKey) then return end
            
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if UserInputService:IsKeyDown(Enum.KeyCode[clickKey]) then
                    local mouseHit = Mouse.Hit
                    if mouseHit then
                        SafeTeleport(mouseHit)
                    end
                end
            end
        end))
    end
    
    -- ============================================================
    -- PATH TELEPORT
    -- ============================================================
    
    local function TeleportPath(pathName)
        local points = PathDB[pathName]
        
        if not points or #points == 0 then
            Utils.Notify("Paths", "Path em desenvolvimento - " .. pathName, 2)
            return
        end
        
        local function TeleportNext(index)
            if index > #points then
                Utils.Notify("Paths", "Caminho concluído!", 2)
                return
            end
            
            SafeTeleport(points[index])
            
            task.delay(0.5, function()
                TeleportNext(index + 1)
            end)
        end
        
        TeleportNext(1)
    end
    
    -- ============================================================
    -- PLAYER LIST UPDATER
    -- ============================================================
    
    local function UpdatePlayerDropdowns()
        local playerList = GetPlayerList()
        
        if PlayerTPDropdown and PlayerTPDropdown.SetOptions then
            pcall(function() PlayerTPDropdown:SetOptions(playerList) end)
        end
        
        if BaseTPDropdown and BaseTPDropdown.SetOptions then
            pcall(function() BaseTPDropdown:SetOptions(playerList) end)
        end
        
        local followList = {"Stop Following"}
        for _, name in ipairs(playerList) do
            table.insert(followList, name)
        end
        if FollowDropdown and FollowDropdown.SetOptions then
            pcall(function() FollowDropdown:SetOptions(followList) end)
        end
        
        local spectateList = {"Stop Spectating"}
        for _, name in ipairs(playerList) do
            table.insert(spectateList, name)
        end
        if SpectateDropdown and SpectateDropdown.SetOptions then
            pcall(function() SpectateDropdown:SetOptions(spectateList) end)
        end
    end
    
    -- ============================================================
    -- UI CREATION
    -- ============================================================
    
    local Tab = UI:Tab(Utils._("teleports_title"), "6034684937")
    
    local WaypointSection = Tab:Section(Utils._("teleports_waypoints"), true)
    local PlayerSection = Tab:Section(Utils._("teleports_players"), true)
    local PathSection = Tab:Section(Utils._("teleports_paths"), false)
    local Custom = Tab:Section(Utils._("teleports_custom"), false)
    
    -- Waypoints
    local selectedLocation = LocationList[1]
    local selectedStore = StoreList[1]
    local selectedBiome = BiomeList[1]
    
    WaypointSection:Dropdown(Utils._("teleports_select_location"), "WaypointLoc", LocationList, function(v)
        selectedLocation = v
    end)
    
    WaypointSection:Dropdown(Utils._("teleports_select_store"), "WaypointStore", StoreList, function(v)
        selectedStore = v
    end)
    
    WaypointSection:Dropdown(Utils._("teleports_select_biome"), "WaypointBiome", BiomeList, function(v)
        selectedBiome = v
    end)
    
    WaypointSection:Button("Teleportar para Local", function()
        if WaypointDB[selectedLocation] then
            SafeTeleport(WaypointDB[selectedLocation])
        end
    end)
    
    WaypointSection:Button("Teleportar para Loja", function()
        if WaypointDB[selectedStore] then
            SafeTeleport(WaypointDB[selectedStore])
        end
    end)
    
    WaypointSection:Button("Teleportar para Bioma", function()
        if WaypointDB[selectedBiome] then
            SafeTeleport(WaypointDB[selectedBiome])
        end
    end)
    
    -- Players
    local playerList = GetPlayerList()
    
    PlayerTPDropdown = PlayerSection:Dropdown(Utils._("teleports_to_player"), "TPPlayer", playerList, function(v)
        TeleportToPlayer(v)
    end)
    
    BaseTPDropdown = PlayerSection:Dropdown(Utils._("teleports_to_base"), "TPBase", playerList, function(v)
        TeleportToBase(v)
    end)
    
    FollowDropdown = PlayerSection:Dropdown(Utils._("teleports_follow"), "Follow", playerList, function(v)
        StartFollowing(v)
    end)
    
    SpectateDropdown = PlayerSection:Dropdown(Utils._("teleports_spectate"), "Spectate", playerList, function(v)
        StartSpectating(v)
    end)
    
    UpdatePlayerDropdowns()
    
    -- Paths
    PathSection:Button(Utils._("teleports_path_palm"), function()
        TeleportPath("Palm")
    end)
    
    PathSection:Button(Utils._("teleports_path_volcano"), function()
        TeleportPath("Volcano")
    end)
    
    PathSection:Button(Utils._("teleports_path_safari"), function()
        TeleportPath("Safari")
    end)
    
    PathSection:Button(Utils._("teleports_path_swamp"), function()
        TeleportPath("Swamp")
    end)
    
    PathSection:Button(Utils._("teleports_path_snow"), function()
        TeleportPath("SnowGlow")
    end)
    
    -- Custom
    Custom:TextBox(Utils._("teleports_coord_x"), "CoordX", tostring(Config.CoordX or 0), function(v)
        local num = tonumber(v)
        if num and num == num and num ~= math.huge then
            Config.CoordX = num
        end
    end)
    
    Custom:TextBox(Utils._("teleports_coord_y"), "CoordY", tostring(Config.CoordY or 0), function(v)
        local num = tonumber(v)
        if num and num == num and num ~= math.huge then
            Config.CoordY = num
        end
    end)
    
    Custom:TextBox(Utils._("teleports_coord_z"), "CoordZ", tostring(Config.CoordZ or 0), function(v)
        local num = tonumber(v)
        if num and num == num and num ~= math.huge then
            Config.CoordZ = num
        end
    end)
    
    Custom:Button(Utils._("teleports_custom_tp"), function()
        local x = Config.CoordX or 0
        local y = Config.CoordY or 0
        local z = Config.CoordZ or 0
        
        if x ~= x or y ~= y or z ~= z then
            Utils.Notify("Teleports", "Coordenadas inválidas", 2)
            return
        end
        
        SafeTeleport(CFrame.new(x, y, z))
    end)
    
    Custom:Toggle(Utils._("teleports_click_tp"), "ClickTP", Config.ClickTP or false, function(v)
        Config.ClickTP = v
        SetupClickTP()
    end)
    
    Custom:Keybind(Utils._("teleports_click_tp_key"), "ClickTPKey", Config.ClickTPKey or "LeftControl", function(v)
        Config.ClickTPKey = v
    end)
    
    -- ============================================================
    -- PLAYER LIST UPDATES
    -- ============================================================
    
    TrackConnection(Players.PlayerAdded:Connect(function()
        task.wait(0.1)
        UpdatePlayerDropdowns()
    end))
    
    TrackConnection(Players.PlayerRemoving:Connect(function()
        task.wait(0.1)
        UpdatePlayerDropdowns()
    end))
    
    -- ============================================================
    -- RESPAWN HANDLING
    -- ============================================================
    
    TrackConnection(LocalPlayer.CharacterAdded:Connect(function()
        if Config.ClickTP then
            SetupClickTP()
        end
        
        if FollowTarget then
            local targetName = FollowTarget.Name
            if FindPlayerByName(targetName) then
                StopFollowing()
                StartFollowing(targetName)
            else
                StopFollowing()
            end
        end
        
        if SpectateTarget then
            local targetName = SpectateTarget.Name
            if FindPlayerByName(targetName) then
                StopSpectating()
                StartSpectating(targetName)
            else
                StopSpectating()
            end
        end
    end))
    
    -- Initialize
    SetupClickTP()
    
    return Cleanup
end
