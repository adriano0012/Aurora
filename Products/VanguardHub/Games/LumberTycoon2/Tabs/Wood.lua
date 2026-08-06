-- ============================================================
-- VANGUARD HUB - WOOD v1.0
-- ============================================================

return function(UI, Config, Utils)
    -- ============================================================
    -- SERVICES
    -- ============================================================

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = workspace
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    -- ============================================================
    -- REMOTES
    -- ============================================================

    local Interaction = ReplicatedStorage:FindFirstChild("Interaction")
    local ClientIsDragging = Interaction and Interaction:FindFirstChild("ClientIsDragging")
    local RemoteProxy = Interaction and Interaction:FindFirstChild("RemoteProxy")
    local AxeFolder = ReplicatedStorage:FindFirstChild("AxeClasses")

    -- ============================================================
    -- PLAYER REFERENCES
    -- ============================================================

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = Workspace.CurrentCamera

    -- ============================================================
    -- CONSTANTS
    -- ============================================================

    local DRAG_TIMEOUT = 3
    local MOVE_TIMEOUT = 3
    local CHOP_TIMEOUT = 8

    -- ============================================================
    -- TREE DATABASE
    -- ============================================================

    local TreeTypes = {
        "Generic", "Walnut", "Cherry", "Oak", "Birch", "Koa", "Fir", "Pine",
        "SnowGlow", "Volcano", "GreenSwampy", "GoldSwampy",
        "CaveCrawler", "Palm", "Frost", "Spooky",
        "LoneCave", "BlueSpruce", "SpookyNeon",
    }

    local TreeIcons = {
        Generic = "🌳", Walnut = "🌳", Cherry = "🌸", Oak = "🌳",
        Birch = "🌳", Koa = "🌳", Fir = "🌲", Pine = "🌲",
        SnowGlow = "❄️", Volcano = "🌋", GreenSwampy = "💚",
        GoldSwampy = "💛", CaveCrawler = "🕳️", Palm = "🌴",
        Frost = "🧊", Spooky = "👻", LoneCave = "💎",
        BlueSpruce = "🔷", SpookyNeon = "🟧",
    }

    local SpecialAxes = {
        LoneCave = "EndTimesAxe",
        Volcano = "FireAxe",
        CaveCrawler = "CaveAxe",
        Frost = "IceAxe",
        GoldSwampy = "AxeSwamp",
    }

    local TreeDisplayList = {}
    for _, name in ipairs(TreeTypes) do
        local icon = TreeIcons[name] or "🌳"
        table.insert(TreeDisplayList, icon .. " " .. name)
    end

    -- ============================================================
    -- STATE
    -- ============================================================

    local ModuleAlive = true
    local OperationToken = 0
    local Connections = {}
    local FeatureConnections = {}

    local BringingTree = false
    local Autofarming = false
    local SellingLogs = false
    local BringingLogs = false
    local Dismembering = false
    local ModWoodRunning = false
    local ModWoodState = "Idle"

    local UsedTrees = {}
    local LoneHighlight = nil

    -- Stats UI elements
    local StatsLabels = {}
    local ModWoodLabels = {}
    local ModWoodHighlight = nil

    local Stats = {
        TreesCollected = 0,
        WoodSold = 0,
        StartTime = 0,
        ActiveLogs = 0,
    }

    -- ============================================================
    -- CONNECTION MANAGEMENT
    -- ============================================================

    local function TrackConnection(connection)
        table.insert(Connections, connection)
        return connection
    end

    local function AddFeatureConnection(name, connection)
        if FeatureConnections[name] then
            pcall(function() FeatureConnections[name]:Disconnect() end)
        end
        FeatureConnections[name] = connection
        return connection
    end

    local function RemoveFeatureConnection(name)
        if FeatureConnections[name] then
            pcall(function() FeatureConnections[name]:Disconnect() end)
            FeatureConnections[name] = nil
        end
    end

    local function IsOperationActive(token)
        return ModuleAlive and token == OperationToken
    end

    local function CancelOperation()
        OperationToken = OperationToken + 1
        BringingTree = false
        Autofarming = false
        SellingLogs = false
        BringingLogs = false
        Dismembering = false
        ModWoodRunning = false
    end

    -- ============================================================
    -- CHARACTER HELPERS
    -- ============================================================

    local function GetCharacter()
        return LocalPlayer and LocalPlayer.Character
    end

    local function GetRoot()
        local char = GetCharacter()
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function GetHumanoid()
        local char = GetCharacter()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function SafeTeleport(cframe)
        if not cframe then return end
        local char = GetCharacter()
        if char then
            if char.PivotTo then
                char:PivotTo(cframe)
            else
                local root = GetRoot()
                if root then root.CFrame = cframe end
            end
        end
    end

    -- ============================================================
    -- AXE HELPERS
    -- ============================================================

    local function IsAxeTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if tool:FindFirstChild("CuttingTool") then return true end

        local toolName = tool:FindFirstChild("ToolName")
        return toolName and AxeFolder and AxeFolder:FindFirstChild("AxeClass_" .. tostring(toolName.Value)) ~= nil
    end

    local function IsPlayerOwnedTool(tool)
        if not tool then return false end

        local owner = tool:FindFirstChild("Owner") or tool:FindFirstChild("Player") or tool:FindFirstChild("Creator")
        if not owner then return true end

        local value = owner.Value
        return value == nil or value == LocalPlayer or value == LocalPlayer.Name or value == LocalPlayer.UserId
    end

    local function CollectAxes()
        local tools = {}
        local seen = {}
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local char = GetCharacter()

        local function addTool(tool)
            if IsAxeTool(tool) and IsPlayerOwnedTool(tool) and not seen[tool] then
                seen[tool] = true
                table.insert(tools, tool)
            end
        end

        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                addTool(tool)
            end
        end

        if char then
            for _, tool in ipairs(char:GetChildren()) do
                addTool(tool)
            end
        end

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                addTool(obj)
            end
        end

        return tools
    end

    local function GetAxeDamage(tool, treeType)
        local toolName = tool and tool:FindFirstChild("ToolName")
        if not toolName or not AxeFolder then return 0 end

        local axeClass = AxeFolder:FindFirstChild("AxeClass_" .. tostring(toolName.Value))
        if not axeClass then return 0 end

        local success, stats = pcall(function()
            return require(axeClass).new()
        end)

        if not success or not stats then return 0 end

        local damage = stats.Damage or 0
        if stats.SpecialTrees and stats.SpecialTrees[treeType] then
            damage = stats.SpecialTrees[treeType].Damage or damage
        end

        return damage
    end

    local function GetBestAxe(treeType)
        local tools = CollectAxes()
        if #tools == 0 then return nil end

        local specialAxeName = SpecialAxes[treeType]
        if specialAxeName then
            for _, tool in ipairs(tools) do
                local toolName = tool:FindFirstChild("ToolName")
                if toolName and toolName.Value == specialAxeName then
                    return tool
                end
            end
        end

        local bestAxe = nil
        local bestDamage = 0

        for _, tool in ipairs(tools) do
            local damage = GetAxeDamage(tool, treeType)
            if damage > bestDamage then
                bestDamage = damage
                bestAxe = tool
            end
        end

        return bestAxe
    end

    local function GetHitPoints(treeType)
        local axe = GetBestAxe(treeType)
        if not axe then return 0 end

        return GetAxeDamage(axe, treeType)
    end

    -- ============================================================
    -- TREE SCANNER
    -- ============================================================

    local function ScanTrees(treeType)
        local trees = {}
        local rootPos = GetRoot()
        local playerPos = rootPos and rootPos.Position or Vector3.new(0, 0, 0)

        for _, region in ipairs(Workspace:GetChildren()) do
            if region.Name == "TreeRegion" then
                for _, tree in ipairs(region:GetChildren()) do
                    if tree:IsA("Model") then
                        local treeClass = tree:FindFirstChild("TreeClass")
                        local owner = tree:FindFirstChild("Owner")

                        if treeClass and treeClass.Value == treeType then
                            local isOwned = owner and owner.Value ~= nil and owner.Value ~= LocalPlayer
                            if not isOwned then
                                local trunk = nil
                                local totalMass = 0

                                for _, part in ipairs(tree:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        totalMass = totalMass + part:GetMass()
                                        local id = part:FindFirstChild("ID")
                                        if id and id.Value == 1 then
                                            trunk = part
                                        end
                                    end
                                end

                                if trunk then
                                    local distance = (trunk.Position - playerPos).Magnitude
                                    table.insert(trees, {
                                        tree = tree,
                                        trunk = trunk,
                                        mass = totalMass,
                                        distance = distance,
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end

        return trees
    end

    local function GetBestTree(treeType, priority)
        local trees = ScanTrees(treeType)

        if #trees == 0 then return nil end

        local available = {}
        for _, data in ipairs(trees) do
            if not UsedTrees[data.tree] then
                table.insert(available, data)
            end
        end

        if #available == 0 then
            UsedTrees = {}
            available = trees
        end

        -- FIXED: Random uses proper selection, not unstable sort comparator
        if priority == "Random" then
            local index = math.random(1, #available)
            local selected = available[index]
            if selected then UsedTrees[selected.tree] = true end
            return selected
        end

        table.sort(available, function(a, b)
            if priority == "Largest" then return a.mass > b.mass
            elseif priority == "Smallest" then return a.mass < b.mass
            elseif priority == "Nearest" then return a.distance < b.distance
            else return a.mass > b.mass
            end
        end)

        local selected = available[1]
        if selected then UsedTrees[selected.tree] = true end

        return selected
    end

    -- ============================================================
    -- STATS PANEL
    -- ============================================================

    local function UpdateStatsPanel()
        if StatsLabels.Trees then
            StatsLabels.Trees.Text = "🌳 Coletadas: " .. Stats.TreesCollected
        end
        if StatsLabels.Sold then
            StatsLabels.Sold.Text = "💰 Vendidos: " .. Stats.WoodSold
        end
        if StatsLabels.Time then
            if Stats.StartTime > 0 then
                local elapsed = os.time() - Stats.StartTime
                local minutes = math.floor(elapsed / 60)
                local seconds = elapsed % 60
                StatsLabels.Time.Text = string.format("⏱ Tempo: %02d:%02d", minutes, seconds)
            else
                StatsLabels.Time.Text = "⏱ Tempo: --:--"
            end
        end
        if StatsLabels.Logs then
            StatsLabels.Logs.Text = "📦 Logs ativos: " .. Stats.ActiveLogs
        end
    end

    local function UpdateActiveLogsCount()
        local logModels = Workspace:FindFirstChild("LogModels")
        if logModels then
            local count = 0
            for _, log in ipairs(logModels:GetChildren()) do
                local owner = log:FindFirstChild("Owner")
                if owner and (owner.Value == nil or owner.Value == LocalPlayer) then
                    count = count + 1
                end
            end
            Stats.ActiveLogs = count
        else
            Stats.ActiveLogs = 0
        end
        UpdateStatsPanel()
    end

    -- ============================================================
    -- LOG HELPER
    -- ============================================================

    local function GetLogModels()
        return Workspace:FindFirstChild("LogModels")
    end

    local function GetOwnedLogs()
        local logs = {}
        local logModels = GetLogModels()
        if not logModels then return logs end

        for _, log in ipairs(logModels:GetChildren()) do
            local owner = log:FindFirstChild("Owner")
            if owner and (owner.Value == nil or owner.Value == LocalPlayer) then
                local woodSection = log:FindFirstChild("WoodSection")
                if woodSection then
                    table.insert(logs, log)
                end
            end
        end
        return logs
    end

    local function IsOwnedLog(model)
        if not model then return false end

        local owner = model:FindFirstChild("Owner")
        if not owner then return false end

        return owner.Value == nil or owner.Value == LocalPlayer
    end

    local function GetDragPart(target)
        if not target then return nil end
        if target:IsA("BasePart") then return target end

        if target:IsA("Model") then
            if target.PrimaryPart then return target.PrimaryPart end
            return target:FindFirstChild("WoodSection") or target:FindFirstChildWhichIsA("BasePart", true)
        end

        return nil
    end

    local function SetModWoodState(state, step, total)
        ModWoodState = state or "Idle"

        if ModWoodLabels.State then
            ModWoodLabels.State.Text = "Status: " .. ModWoodState
        end

        if ModWoodLabels.Progress then
            if step and total then
                ModWoodLabels.Progress.Text = string.format("Progresso: %d/%d", step, total)
            else
                ModWoodLabels.Progress.Text = "Progresso: --"
            end
        end
    end

    local function ClearModWoodHighlight()
        if ModWoodHighlight then
            pcall(function() ModWoodHighlight:Destroy() end)
            ModWoodHighlight = nil
        end
    end

    local function HighlightPart(part, color)
        ClearModWoodHighlight()
        if not part then return end

        ModWoodHighlight = Instance.new("Highlight")
        ModWoodHighlight.FillColor = color or Color3.fromRGB(160, 60, 255)
        ModWoodHighlight.FillTransparency = 0.55
        ModWoodHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        ModWoodHighlight.OutlineTransparency = 0
        ModWoodHighlight.Parent = part
    end

    local function FindSawmillFromTarget(target)
        local current = target

        while current and current ~= Workspace do
            local settings = current:FindFirstChild("Settings")
            if settings and settings:FindFirstChild("DimZ") then
                return current
            end

            current = current.Parent
        end

        return nil
    end

    local function WaitForClickSawmill(token, timeout)
        local selected = nil
        local connection
        local startTime = os.clock()

        connection = Mouse.Button1Down:Connect(function()
            if not IsOperationActive(token) then return end
            selected = FindSawmillFromTarget(Mouse.Target)
        end)

        while not selected and IsOperationActive(token) and os.clock() - startTime < timeout do
            task.wait(0.1)
        end

        if connection then connection:Disconnect() end
        return selected
    end

    local function GetLogFromTarget(target)
        local logModels = GetLogModels()
        local current = target

        while current and current ~= Workspace do
            if logModels and current.Parent == logModels and IsOwnedLog(current) then
                return current
            end

            current = current.Parent
        end

        return nil
    end

    local function SelectBranchFromLog(log)
        local leafIds = {}

        for _, obj in ipairs(log:GetDescendants()) do
            if obj.Name == "ChildIDs" and #obj:GetChildren() == 0 then
                local id = obj.Parent and obj.Parent:FindFirstChild("ID")
                if id then
                    table.insert(leafIds, id.Value)
                end
            end
        end

        table.sort(leafIds)

        local childId = leafIds[#leafIds]
        if not childId then return nil end

        local childBranch = nil
        local parentBranch = nil

        for _, obj in ipairs(log:GetDescendants()) do
            if obj.Name == "ID" and obj.Value == childId then
                childBranch = obj.Parent
            elseif obj.Name == "ChildIDs" then
                for _, childValue in ipairs(obj:GetChildren()) do
                    if childValue.Value == childId then
                        parentBranch = obj.Parent
                        break
                    end
                end
            end
        end

        if not childBranch then return nil end

        return {
            log = log,
            childbranch = childBranch,
            parentbranch = parentBranch or childBranch,
            childbranchId = childId
        }
    end

    local function WaitForClickLog(token, timeout)
        local selected = nil
        local connection
        local startTime = os.clock()

        connection = Mouse.Button1Down:Connect(function()
            if not IsOperationActive(token) then return end

            local log = GetLogFromTarget(Mouse.Target)
            if log then
                selected = SelectBranchFromLog(log)
                if selected then
                    HighlightPart(selected.childbranch, Color3.fromRGB(0, 230, 118))
                end
            end
        end)

        while not selected and IsOperationActive(token) and os.clock() - startTime < timeout do
            task.wait(0.1)
        end

        if connection then connection:Disconnect() end
        return selected
    end

    local function FindLavaPart()
        local volcano = Workspace:FindFirstChild("Region_Volcano")
        if not volcano then return nil end

        for _, obj in ipairs(volcano:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Lava" then
                return obj
            end
        end

        return nil
    end

    local function FindWoodDropoff()
        local candidates = {}

        for _, obj in ipairs(Workspace:GetDescendants()) do
            local name = string.lower(obj:GetFullName())
            if obj:IsA("BasePart") and (name:find("drop") or name:find("sell")) and name:find("wood") then
                table.insert(candidates, obj)
            end
        end

        table.sort(candidates, function(a, b)
            return a:GetFullName() < b:GetFullName()
        end)

        return candidates[1]
    end

    local function WaitForOwnedLogSpawn(token, timeout)
        local logModels = GetLogModels()
        if not logModels then return false end

        local spawned = false
        local connection = logModels.ChildAdded:Connect(function(log)
            task.defer(function()
                local owner = log:FindFirstChild("Owner") or log:WaitForChild("Owner", 2)
                local woodSection = log:FindFirstChild("WoodSection") or log:WaitForChild("WoodSection", 2)

                if IsOperationActive(token) and owner and woodSection and IsOwnedLog(log) then
                    spawned = true
                end
            end)
        end)

        local startTime = os.clock()
        while not spawned and IsOperationActive(token) and os.clock() - startTime < timeout do
            task.wait(0.1)
        end

        connection:Disconnect()
        return spawned
    end

    -- ============================================================
    -- CUTTING
    -- ============================================================

    local function AttemptChop(tree, dismember, token)
        if not IsOperationActive(token) then return false end

        local treeClass = tree and tree:FindFirstChild("TreeClass")
        local treeType = treeClass and treeClass.Value or Config.TreeType or "Generic"
        local axe = GetBestAxe(treeType)

        if not axe then return false end

        local cutEvent = tree:FindFirstChild("CutEvent") or (tree.Parent and tree.Parent:FindFirstChild("CutEvent"))
        if not cutEvent then return false end

        local lowestId = math.huge
        local dismemberHeight = 0.3

        for _, section in ipairs(tree:GetDescendants()) do
            if section.Name == "WoodSection" then
                local id = section:FindFirstChild("ID")
                if id and id.Value < lowestId then
                    lowestId = id.Value
                    if dismember then dismemberHeight = section.Size.Y end
                end
            end
        end

        if lowestId == math.huge then return false end

        local hitPoints = GetHitPoints(treeType)
        local toolName = axe:FindFirstChild("ToolName")

        if not toolName then return false end

        pcall(function()
            RemoteProxy:FireServer(cutEvent, {
                tool = axe,
                faceVector = Vector3.new(1, 0, 0),
                height = dismember and dismemberHeight or 0.3,
                sectionId = lowestId,
                hitPoints = hitPoints,
                cooldown = 0.1,
                cuttingClass = "Axe"
            })
        end)

        return true
    end

    -- ============================================================
    -- DRAG HELPER
    -- ============================================================

    local function DragModel(model, targetCFrame, token)
        if not IsOperationActive(token) then return false end
        if not model or not targetCFrame or not ClientIsDragging then return false end

        local dragPart = GetDragPart(model)
        if not dragPart then return false end

        local startTime = os.clock()
        local hasOwnership = false

        while os.clock() - startTime < DRAG_TIMEOUT and IsOperationActive(token) do
            ClientIsDragging:FireServer(model)

            local success, isOwner = pcall(function()
                return dragPart:GetNetworkOwner() == LocalPlayer
            end)

            if success and isOwner then
                hasOwnership = true
                break
            end

            task.wait(0.1)
        end

        if not hasOwnership then return false end

        startTime = os.clock()
        local arrived = false

        while os.clock() - startTime < MOVE_TIMEOUT and IsOperationActive(token) do
            ClientIsDragging:FireServer(model)
            pcall(function()
                model:PivotTo(targetCFrame)
            end)

            local currentPivot = nil
            local pivotSuccess = pcall(function()
                currentPivot = model:GetPivot()
            end)

            local distance = pivotSuccess and (currentPivot.Position - targetCFrame.Position).Magnitude or math.huge
            if distance < 5 then
                arrived = true
                break
            end

            task.wait(0.05)
        end

        return arrived
    end

    -- ============================================================
    -- BRING TREE
    -- ============================================================

    local function BringTree(token)
        local treeType = Config.TreeType or "Generic"
        local treeAmount = Config.TreeAmount or 1
        local treePriority = Config.TreePriority or "Largest"

        local originalCFrame = GetRoot() and GetRoot().CFrame

        for i = 1, treeAmount do
            if not IsOperationActive(token) then break end

            local treeData = GetBestTree(treeType, treePriority)
            if not treeData then
                Utils.Notify("Wood", "❌ Nenhuma árvore disponível!", 2)
                break
            end

            BringingTree = true

            SafeTeleport(treeData.trunk.CFrame + Vector3.new(0, 3, 3))

            local logSpawned = false
            local logConnection
            local chopStart = os.clock()
            local logModels = GetLogModels()

            if logModels then
                logConnection = logModels.ChildAdded:Connect(function(log)
                    local owner = log:FindFirstChild("Owner")
                    if owner and owner.Value == LocalPlayer then
                        logSpawned = true
                    end
                end)
            end

            while not logSpawned and os.clock() - chopStart < CHOP_TIMEOUT and IsOperationActive(token) do
                AttemptChop(treeData.tree, false, token)
                task.wait(0.15)
            end

            if logConnection then logConnection:Disconnect() end

            if not logSpawned then
                Utils.Notify("Wood", "❌ Falha ao cortar", 2)
                BringingTree = false
                continue
            end

            task.wait(0.5)

            local logs = GetOwnedLogs()
            for _, log in ipairs(logs) do
                DragModel(log, originalCFrame, token)
            end

            Stats.TreesCollected = Stats.TreesCollected + 1
            UpdateActiveLogsCount()
            UpdateStatsPanel()

            BringingTree = false
        end

        SafeTeleport(originalCFrame)
    end

    -- ============================================================
    -- AUTOFARM
    -- ============================================================

    local function StartAutofarm(token)
        Autofarming = true
        Stats.TreesCollected = 0
        Stats.WoodSold = 0
        Stats.StartTime = os.time()
        UpdateStatsPanel()

        while Autofarming and IsOperationActive(token) do
            BringTree(token)

            if Config.SellAfterBring then
                SellAllLogs(token)
                Stats.WoodSold = Stats.WoodSold + (Config.TreeAmount or 1)
                UpdateStatsPanel()
            end

            UpdateActiveLogsCount()
            task.wait(1)
        end

        Autofarming = false
        Stats.StartTime = 0
        UpdateStatsPanel()
    end

    -- ============================================================
    -- LOG MANAGER
    -- ============================================================

    local function BringAllLogs(token)
        BringingLogs = true
        local originalCFrame = GetRoot() and GetRoot().CFrame

        local logModels = GetLogModels()
        if not logModels then
            Utils.Notify("Wood", "❌ LogModels não encontrado!", 2)
            BringingLogs = false
            return
        end

        local logs = GetOwnedLogs()
        local brought = 0
        for _, log in ipairs(logs) do
            if not IsOperationActive(token) then break end
            if DragModel(log, originalCFrame, token) then
                brought = brought + 1
            end
        end

        SafeTeleport(originalCFrame)
        UpdateActiveLogsCount()
        BringingLogs = false
        Utils.Notify("Wood", "✅ " .. brought .. " logs trazidos!", 2)
    end

    local function SellAllLogs(token)
        SellingLogs = true

        local logModels = GetLogModels()
        if not logModels then
            Utils.Notify("Wood", "❌ LogModels não encontrado!", 2)
            SellingLogs = false
            return
        end

        local logs = GetOwnedLogs()
        local dropoff = FindWoodDropoff()
        if not dropoff then
            Utils.Notify("Wood", "Dropoff de madeira não encontrado.", 2)
            SellingLogs = false
            return
        end

        local sellCFrame = dropoff.CFrame + Vector3.new(0, 2, 0)
        local sold = 0
        for _, log in ipairs(logs) do
            if not IsOperationActive(token) then break end
            if DragModel(log, sellCFrame, token) then
                sold = sold + 1
                Stats.WoodSold = Stats.WoodSold + 1
            end
        end

        UpdateActiveLogsCount()
        UpdateStatsPanel()
        SellingLogs = false
        Utils.Notify("Wood", "✅ " .. sold .. " logs vendidos!", 2)
    end

    -- ============================================================
    -- DISMEMBER
    -- ============================================================

    local function StartDismember(token)
        Dismembering = true
        local originalCFrame = GetRoot() and GetRoot().CFrame

        local logModels = GetLogModels()
        if not logModels then
            Utils.Notify("Wood", "❌ LogModels não encontrado!", 2)
            Dismembering = false
            return
        end

        Utils.Notify("Wood", "🖱️ Clique em um log para desmembrar", 3)

        local clickedLog = nil
        local clickConnection

        clickConnection = Mouse.Button1Down:Connect(function()
            if not IsOperationActive(token) then return end

            local target = Mouse.Target
            if target then
                local parent = target.Parent
                while parent do
                    if parent.Parent == logModels then
                        local owner = parent:FindFirstChild("Owner")
                        if owner and owner.Value == LocalPlayer then
                            clickedLog = parent
                            break
                        end
                    end
                    parent = parent.Parent
                end
            end
        end)

        while not clickedLog and IsOperationActive(token) do
            task.wait(0.1)
        end

        if clickConnection then clickConnection:Disconnect() end

        if not clickedLog or not IsOperationActive(token) then
            Dismembering = false
            return
        end

        local sections = {}
        for _, section in ipairs(clickedLog:GetDescendants()) do
            if section.Name == "WoodSection" then
                local id = section:FindFirstChild("ID")
                if id and id.Value ~= 1 then
                    table.insert(sections, section)
                end
            end
        end

        table.sort(sections, function(a, b) return a.ID.Value > b.ID.Value end)

        for _, section in ipairs(sections) do
            if not IsOperationActive(token) then break end

            SafeTeleport(section.CFrame + Vector3.new(0, 3, 0))

            local logChopped = false
            local logConnection
            local chopStart = os.clock()

            logConnection = logModels.ChildAdded:Connect(function(log)
                local owner = log:FindFirstChild("Owner")
                if owner and owner.Value == LocalPlayer then
                    logChopped = true
                end
            end)

            while not logChopped and os.clock() - chopStart < CHOP_TIMEOUT and IsOperationActive(token) do
                AttemptChop(clickedLog, true, token)
                task.wait(0.15)
            end

            if logConnection then logConnection:Disconnect() end
            task.wait(0.5)
        end

        SafeTeleport(originalCFrame)
        UpdateActiveLogsCount()
        Dismembering = false
        Utils.Notify("Wood", "✅ Desmembramento concluído!", 2)
    end

    -- ============================================================
    -- MOD WOOD STATE MACHINE
    -- ============================================================

    local function GetSawmillTargetCFrame(sawmill)
        if not sawmill then return nil end

        local particles = sawmill:FindFirstChild("Particles", true)
        if particles and particles:IsA("BasePart") then
            return particles.CFrame + Vector3.new(0, 0.5, 0)
        end

        local main = sawmill:FindFirstChild("Main", true)
        if main and main:IsA("BasePart") then
            return main.CFrame + Vector3.new(0, 2, 0)
        end

        local success, pivot = pcall(function()
            return sawmill:GetPivot()
        end)

        return success and (pivot + Vector3.new(0, 2, 0)) or nil
    end

    local function GetBranchTreeType(branchData)
        local treeClass = branchData.log and branchData.log:FindFirstChild("TreeClass")
        return treeClass and treeClass.Value or Config.TreeType or "Generic"
    end

    local function AttemptChopBranch(branchData, token)
        if not IsOperationActive(token) or not branchData then return false end

        local cutEvent = branchData.log and branchData.log:FindFirstChild("CutEvent")
        if not cutEvent then return false end

        local treeType = GetBranchTreeType(branchData)
        local axe = GetBestAxe(treeType)
        if not axe then return false end

        pcall(function()
            RemoteProxy:FireServer(cutEvent, {
                tool = axe,
                faceVector = Vector3.new(1, 0, 0),
                height = 0.3,
                sectionId = branchData.childbranchId,
                hitPoints = GetHitPoints(treeType),
                cooldown = 0.12,
                cuttingClass = "Axe"
            })
        end)

        return true
    end

    local function WaitForLavaFire(part, token, timeout)
        local startTime = os.clock()

        while IsOperationActive(token) and os.clock() - startTime < timeout do
            if part and part:FindFirstChild("LavaFire") then
                return true
            end

            task.wait(0.1)
        end

        return false
    end

    local function StartModWood(token)
        ModWoodRunning = true
        ClearModWoodHighlight()

        local originalCFrame = GetRoot() and GetRoot().CFrame

        local function StopModWood(state)
            SetModWoodState(state or "Idle")
            ModWoodRunning = false
            ClearModWoodHighlight()
            SafeTeleport(originalCFrame)
        end

        SetModWoodState("SelectingSawmill", 1, 8)
        Utils.Notify("Mod Wood", "Clique na serraria.", 4)

        local sawmill = WaitForClickSawmill(token, 20)
        if not sawmill or not IsOperationActive(token) then
            StopModWood("Idle")
            Utils.Notify("Mod Wood", "Seleção da serraria cancelada.", 3)
            return
        end

        SetModWoodState("SelectingTree", 2, 8)
        Utils.Notify("Mod Wood", "Clique no log da árvore.", 4)

        local branchData = WaitForClickLog(token, 25)
        if not branchData or not IsOperationActive(token) then
            StopModWood("Idle")
            Utils.Notify("Mod Wood", "Seleção do log cancelada.", 3)
            return
        end

        SetModWoodState("PreparingBranch", 3, 8)
        SafeTeleport(branchData.childbranch.CFrame + Vector3.new(4, 2, 0))
        task.wait(0.2)

        SetModWoodState("Burning", 4, 8)
        local lava = FindLavaPart()
        if not lava then
            StopModWood("Idle")
            Utils.Notify("Mod Wood", "Lava não encontrada dinamicamente.", 3)
            return
        end

        local burnTarget = lava.CFrame + Vector3.new(0, 2, 0)
        DragModel(branchData.log, burnTarget, token)
        if not IsOperationActive(token) then
            StopModWood("Idle")
            return
        end

        if not WaitForLavaFire(branchData.parentbranch, token, 6) then
            Utils.Notify("Mod Wood", "Queima não confirmada; seguindo sem venda forçada.", 3)
        end
        if not IsOperationActive(token) then
            StopModWood("Idle")
            return
        end

        SetModWoodState("Cutting", 5, 8)
        local spawnedCutLog = false
        local cutStart = os.clock()
        task.spawn(function()
            spawnedCutLog = WaitForOwnedLogSpawn(token, CHOP_TIMEOUT)
        end)

        while not spawnedCutLog and IsOperationActive(token) and os.clock() - cutStart < CHOP_TIMEOUT do
            AttemptChopBranch(branchData, token)
            task.wait(0.15)
        end
        if not IsOperationActive(token) then
            StopModWood("Idle")
            return
        end

        SetModWoodState("Transporting", 6, 8)
        local sawmillCFrame = GetSawmillTargetCFrame(sawmill)
        if sawmillCFrame then
            DragModel(branchData.log, sawmillCFrame, token)
        else
            Utils.Notify("Mod Wood", "Entrada da serraria não encontrada.", 3)
        end
        if not IsOperationActive(token) then
            StopModWood("Idle")
            return
        end

        SetModWoodState("Processing", 7, 8)
        local dropoff = FindWoodDropoff()
        if dropoff and branchData.parentbranch and branchData.parentbranch.Parent then
            DragModel(branchData.parentbranch.Parent, dropoff.CFrame + Vector3.new(0, 2, 0), token)
        end
        if not IsOperationActive(token) then
            StopModWood("Idle")
            return
        end

        SetModWoodState("Completed", 8, 8)
        UpdateActiveLogsCount()
        Utils.Notify("Mod Wood", "Concluído.", 3)

        task.wait(1)
        if IsOperationActive(token) then
            SetModWoodState("Idle")
        end

        StopModWood(ModWoodState == "Completed" and "Idle" or ModWoodState)
    end

    -- ============================================================
    -- VIEW LONE CAVE
    -- ============================================================

    local function SetViewLoneCave(enabled)
        RemoveFeatureConnection("ViewLone")

        if LoneHighlight then
            LoneHighlight:Destroy()
            LoneHighlight = nil
        end

        if not enabled then
            local hum = GetHumanoid()
            if hum then Camera.CameraSubject = hum end
            return
        end

        local loneCaveTree = nil
        for _, region in ipairs(Workspace:GetChildren()) do
            if region.Name == "TreeRegion" then
                for _, tree in ipairs(region:GetChildren()) do
                    if tree:IsA("Model") then
                        local treeClass = tree:FindFirstChild("TreeClass")
                        if treeClass and treeClass.Value == "LoneCave" then
                            loneCaveTree = tree
                            break
                        end
                    end
                end
            end
            if loneCaveTree then break end
        end

        if not loneCaveTree then
            Utils.Notify("Wood", "❌ LoneCave não encontrada!", 2)
            return
        end

        local woodSection = loneCaveTree:FindFirstChild("WoodSection", true)
        if not woodSection then
            Utils.Notify("Wood", "❌ WoodSection não encontrada!", 2)
            return
        end

        LoneHighlight = Instance.new("Highlight")
        LoneHighlight.FillColor = Color3.fromRGB(160, 60, 255)
        LoneHighlight.FillTransparency = 0.5
        LoneHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        LoneHighlight.OutlineTransparency = 0
        LoneHighlight.Parent = woodSection

        Camera.CameraSubject = woodSection

        AddFeatureConnection("ViewLone", loneCaveTree.AncestryChanged:Connect(function()
            if not loneCaveTree.Parent then
                SetViewLoneCave(false)
                Config.ViewLone = false
            end
        end))
    end

    -- ============================================================
    -- UI CREATION
    -- ============================================================

    local Tab = UI:Tab(Utils._("wood_title"), "6034503369")

    local Bring = Tab:Section(Utils._("wood_bring"), true)
    local Mod = Tab:Section(Utils._("wood_mod"), false)
    local StatsSection = Tab:Section("📊 Estatísticas", true)
    local Logs = Tab:Section(Utils._("wood_logs"), false)
    local Tools = Tab:Section(Utils._("wood_tools"), false)

    -- Stats Panel
    StatsLabels.Trees = StatsSection:Label("🌳 Coletadas: 0")
    StatsLabels.Sold = StatsSection:Label("💰 Vendidos: 0")
    StatsLabels.Time = StatsSection:Label("⏱ Tempo: --:--")
    StatsLabels.Logs = StatsSection:Label("📦 Logs ativos: 0")

    -- Update stats initially
    UpdateActiveLogsCount()

    -- Bring
    Bring:Dropdown(Utils._("wood_tree_type"), "TreeType", TreeDisplayList, function(v)
        Config.TreeType = v:match(" (.+)$") or v
    end)

    Bring:Slider(Utils._("wood_amount"), "TreeAmount", Config.TreeAmount or 1, 1, 30, false, function(v)
        Config.TreeAmount = v
    end)

    Bring:Dropdown(Utils._("wood_tree_size"), "TreePriority", {
        "🔽 Largest", "🔼 Smallest", "📍 Nearest", "🎲 Random",
    }, function(v)
        if v:find("Largest") then Config.TreePriority = "Largest"
        elseif v:find("Smallest") then Config.TreePriority = "Smallest"
        elseif v:find("Nearest") then Config.TreePriority = "Nearest"
        elseif v:find("Random") then Config.TreePriority = "Random"
        end
    end)

    Bring:Button(Utils._("wood_bring"), function()
        if BringingTree or Autofarming then
            Utils.Notify("Wood", "⚠️ Operação em andamento!", 2)
            return
        end

        if not ClientIsDragging or not RemoteProxy then
            Utils.Notify("Wood", "❌ Remotes não encontrados!", 2)
            return
        end

        if not GetBestAxe(Config.TreeType or "Generic") then
            Utils.Notify("Wood", "❌ Machado necessário!", 2)
            return
        end

        OperationToken = OperationToken + 1
        task.spawn(function() BringTree(OperationToken) end)
    end)

    Bring:Button(Utils._("wood_abort"), function()
        CancelOperation()
        Utils.Notify("Wood", "⏹️ Abortado!", 2)
    end)

    Bring:Toggle(Utils._("wood_autofarm"), "Autofarm", Config.Autofarm or false, function(v)
        Config.Autofarm = v
        if v then
            OperationToken = OperationToken + 1
            task.spawn(function() StartAutofarm(OperationToken) end)
        else
            CancelOperation()
        end
    end)

    -- Mod Wood
    ModWoodLabels.State = Mod:Label("Status: Idle")
    ModWoodLabels.Progress = Mod:Label("Progresso: --")

    Mod:Button(Utils._("wood_mod_wood"), function()
        if ModWoodRunning or BringingTree or Autofarming or SellingLogs or BringingLogs or Dismembering then
            Utils.Notify("Mod Wood", "Operação em andamento.", 2)
            return
        end

        if not ClientIsDragging or not RemoteProxy then
            Utils.Notify("Mod Wood", "Remotes não encontrados.", 2)
            return
        end

        if not GetBestAxe(Config.TreeType or "Generic") then
            Utils.Notify("Mod Wood", "Machado necessário.", 2)
            return
        end

        OperationToken = OperationToken + 1
        task.spawn(function() StartModWood(OperationToken) end)
    end)

    Mod:Button(Utils._("wood_abort"), function()
        CancelOperation()
        ModWoodRunning = false
        ClearModWoodHighlight()
        SetModWoodState("Idle")
        Utils.Notify("Mod Wood", "Abortado.", 2)
    end)

    -- Logs
    Logs:Button(Utils._("wood_bring_logs"), function()
        if BringingLogs then
            Utils.Notify("Wood", "⚠️ Operação em andamento!", 2)
            return
        end

        OperationToken = OperationToken + 1
        task.spawn(function() BringAllLogs(OperationToken) end)
    end)

    Logs:Button(Utils._("wood_sell_logs"), function()
        if SellingLogs then
            Utils.Notify("Wood", "⚠️ Operação em andamento!", 2)
            return
        end

        OperationToken = OperationToken + 1
        task.spawn(function() SellAllLogs(OperationToken) end)
    end)

    -- Tools
    Tools:Button(Utils._("wood_dismember"), function()
        if Dismembering then
            Utils.Notify("Wood", "⚠️ Operação em andamento!", 2)
            return
        end

        OperationToken = OperationToken + 1
        task.spawn(function() StartDismember(OperationToken) end)
    end)

    Tools:Toggle(Utils._("wood_view_lone"), "ViewLone", Config.ViewLone or false, function(v)
        Config.ViewLone = v
        SetViewLoneCave(v)
    end)

    -- ============================================================
    -- PERIODIC STATS UPDATE
    -- ============================================================

    TrackConnection(RunService.Heartbeat:Connect(function()
        -- Update every 2 seconds to avoid performance impact
        if Stats._lastUpdate and os.clock() - Stats._lastUpdate < 2 then return end
        Stats._lastUpdate = os.clock()

        UpdateActiveLogsCount()
        if Autofarming then
            UpdateStatsPanel()
        end
    end))

    -- ============================================================
    -- RESPAWN HANDLING
    -- ============================================================

    TrackConnection(LocalPlayer.CharacterAdded:Connect(function()
        if Config.ViewLone then SetViewLoneCave(true) end
    end))

    -- ============================================================
    -- CLEANUP
    -- ============================================================

    local function Cleanup()
        ModuleAlive = false
        CancelOperation()
        SetViewLoneCave(false)

        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        Connections = {}

        for name, _ in pairs(FeatureConnections) do
            RemoveFeatureConnection(name)
        end

        if LoneHighlight then
            LoneHighlight:Destroy()
            LoneHighlight = nil
        end
        ClearModWoodHighlight()

        UsedTrees = {}
        StatsLabels = {}
        ModWoodLabels = {}
    end

    return Cleanup
end
