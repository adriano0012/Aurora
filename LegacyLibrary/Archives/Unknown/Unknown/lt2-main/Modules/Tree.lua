local TreeModule = {}

-- ==========================================
--             SYSTEM SETTINGS
-- ==========================================
local Settings = {
    SyncDelay       = 0.1,
    ReadyDelay      = 0.1,

    -- [ Cut Settings ]
    FiresPerSection = 100,
    FireDelay       = 0.01,
    SweepDelay      = 0.1,

    -- [ LOT Settings ]
    LogDropDistance = 6,

    -- [ Sell Location ]
    SellPosition    = Vector3.new(315, 0, 88),

    -- [ Death Handling ]
    RespawnResumeDelay = 1,   -- seconds to wait after respawn before resuming
}

-- ==========================================
--             CORE SERVICES & VARS
-- ==========================================
local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LT2Axes = _G.LT2Axes

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local isChopping          = false
local preChopCFrame       = nil
local preChopCameraCFrame = nil
local preChopLogModels    = {}

-- ==========================================
--   SILENCE TROLL SOUNDS
-- ==========================================
local function SilenceRegionAlternates()
    local function killAlternate(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == "Alternate" and child:IsA("Sound") then
                child.Volume = 0
                pcall(function() child:Stop() end)
            end
        end
        parent.ChildAdded:Connect(function(child)
            if child.Name == "Alternate" and child:IsA("Sound") then
                child.Volume = 0
                pcall(function() child:Stop() end)
            end
        end)
    end

    local function scanClientSounds()
        local pg     = player:WaitForChild("PlayerGui", 10)
        local sounds = pg and pg:FindFirstChild("ClientSounds")
        if not sounds then return end

        local function processRegion(folder)
            killAlternate(folder)
        end

        local function scanAll()
            for _, child in ipairs(sounds:GetChildren()) do
                if child.Name == "Region_Main" or child.Name == "Region_Mountain" then
                    processRegion(child)
                end
            end
        end

        scanAll()

        sounds.ChildAdded:Connect(function(child)
            if child.Name == "Region_Main" or child.Name == "Region_Mountain" then
                processRegion(child)
            end
        end)
    end

    task.spawn(scanClientSounds)
end

SilenceRegionAlternates()

-- ==========================================
--             UTILITY
-- ==========================================

local function ReadAxeName(tool)
    if not tool then return nil end
    local tipChild = tool:FindFirstChild("ToolTip")
    return (tipChild and tipChild:IsA("StringValue")) and tipChild.Value or tool.ToolTip
end

local function GetBackpackAxe(treeClass)
    local candidates = {}

    local function TryAdd(tool)
        if not tool:IsA("Tool") then return end
        if tool.Name == "BlueprintTool" then return end

        local axeName = ReadAxeName(tool)
        if not axeName then return end

        local score = treeClass
            and LT2Axes.GetDamage(axeName, treeClass)
            or (1 / (LT2Axes.Rank[axeName] or 2^53))

        table.insert(candidates, { tool = tool, axeName = axeName, score = score })
    end

    local char = player.Character
    if char then
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then TryAdd(equipped) end
    end
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        TryAdd(tool)
    end

    if #candidates == 0 then return nil, nil end

    table.sort(candidates, function(a, b) return a.score > b.score end)

    local best = candidates[1]
    return best.tool, best.axeName
end

local function FindPriorityTree(treeClass)
    local bestModel   = nil
    local maxSections = -1
    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder.Name:lower():match("treeregion") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model")
                and model:FindFirstChild("TreeClass")
                and model.TreeClass.Value == treeClass then
                    local count = 0
                    for _, part in ipairs(model:GetChildren()) do
                        if part.Name == "WoodSection" then count += 1 end
                    end
                    if treeClass == "Generic" and count < 12 then continue end
                    if count > maxSections then
                        maxSections = count
                        bestModel   = model
                    end
                end
            end
        end
    end
    return bestModel
end

local function GetSectionsBottomFirst(treeModel)
    local sections = {}
    for _, part in ipairs(treeModel:GetChildren()) do
        if part.Name == "WoodSection" then
            table.insert(sections, part)
        end
    end
    table.sort(sections, function(a, b)
        return a.Position.Y < b.Position.Y
    end)
    return sections
end

local function SnapshotLogModels()
    preChopLogModels = {}
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then return end
    for _, model in ipairs(logModels:GetChildren()) do
        preChopLogModels[model] = true
    end
end

-- ==========================================
--   OWNERSHIP CHECK
-- ==========================================
local function IsOwnedByLocalPlayer(model)
    local ownerObj = model:FindFirstChild("Owner")
    if ownerObj then
        if ownerObj:IsA("ObjectValue") and ownerObj.Value == player then return true end
        if ownerObj:IsA("StringValue") and ownerObj.Value == player.Name then return true end
    end
    local ownerStr = model:FindFirstChild("OwnerString")
    if ownerStr and ownerStr:IsA("StringValue") and ownerStr.Value == player.Name then
        return true
    end
    return false
end

local function CountWoodSections(model)
    local count = 0
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Name == "WoodSection" then
            count += 1
        end
    end
    return count
end

local function CountTreeSections(model)
    local count = 0
    for _, part in ipairs(model:GetChildren()) do
        if part.Name == "WoodSection" then count += 1 end
    end
    return count
end

local function ScanForTreeTypes()
    local found, seen = {}, {}
    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder.Name:lower():match("treeregion") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") then
                    local tc = model:FindFirstChild("TreeClass")
                    if tc and tc:IsA("StringValue") and not seen[tc.Value] then
                        if CountTreeSections(model) > 1 then
                            seen[tc.Value] = true
                            table.insert(found, tc.Value)
                        end
                    end
                end
            end
        end
    end
    return #found > 0 and found or {"None Found"}
end

local function CollectNewStumps(treeClass)
    local results   = {}
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then return results end
    for _, model in ipairs(logModels:GetChildren()) do
        if preChopLogModels[model] then continue end
        if model:IsA("Model") then
            local tc = model:FindFirstChild("TreeClass")
            if tc and tc.Value == treeClass then
                local iw = model:FindFirstChild("InnerWood")
                if iw and iw:IsA("BasePart") then
                    table.insert(results, iw)
                end
            end
        end
    end
    if #results == 0 then
        warn("[TreeModule] No InnerWood found after chop for TreeClass:", treeClass)
    end
    return results
end

local function CollectAllOwnedStumps()
    local results   = {}
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then return results end
    for _, model in ipairs(logModels:GetChildren()) do
        if not model:IsA("Model") then continue end
        if not IsOwnedByLocalPlayer(model) then continue end
        local iw = model:FindFirstChild("InnerWood")
        if iw and iw:IsA("BasePart") then
            table.insert(results, iw)
        end
    end
    if #results == 0 then
        warn("[TreeModule] No owned InnerWood found.")
    end
    return results
end

local function CollectSingleSectionStumps()
    local results   = {}
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then return results end
    for _, model in ipairs(logModels:GetChildren()) do
        if not model:IsA("Model") then continue end
        if not IsOwnedByLocalPlayer(model) then continue end
        if CountWoodSections(model) ~= 1 then continue end
        local iw = model:FindFirstChild("InnerWood")
        if iw and iw:IsA("BasePart") then
            table.insert(results, iw)
        end
    end
    if #results == 0 then
        warn("[TreeModule] No single-section logs ready to sell. Chop logs into sections first.")
    end
    return results
end

local function SellLogModelSectionBySection(model, LOT, sellPos, sectionIndex)
    sectionIndex = sectionIndex or 0

    local sections = {}
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "WoodSection" then
            table.insert(sections, part)
        end
    end
    table.sort(sections, function(a, b) return a.Position.Y < b.Position.Y end)

    if #sections == 0 then
        warn("[TreeModule] No WoodSections found in model:", model.Name)
        return sectionIndex
    end

    for _, section in ipairs(sections) do
        if not section or not section.Parent then continue end

        for _, desc in ipairs(model:GetDescendants()) do
            if desc:IsA("Weld") or desc:IsA("WeldConstraint") or desc:IsA("ManualWeld") then
                if desc.Part0 == section or desc.Part1 == section then
                    pcall(function() desc:Destroy() end)
                end
            end
        end

        task.wait(0.1)

        sectionIndex += 1
        local cf = CFrame.new(sellPos.X + ((sectionIndex - 1) * 3), sellPos.Y, sellPos.Z)
        if LOT.IsBusy() then repeat task.wait(0.05) until not LOT.IsBusy() end
        LOT.TeleportObjectTo(section, cf)
        repeat task.wait(0.05) until not LOT.IsBusy()
    end

    return sectionIndex
end

local function SellAllOwnedTreesSectionBySection(LOT, sellPos, onComplete)
    task.spawn(function()
        local logModels = Workspace:FindFirstChild("LogModels")
        if not logModels then
            if onComplete then onComplete() end
            return
        end

        local ownedModels = {}
        for _, model in ipairs(logModels:GetChildren()) do
            if model:IsA("Model") and IsOwnedByLocalPlayer(model) then
                table.insert(ownedModels, model)
            end
        end

        if #ownedModels == 0 then
            warn("[TreeModule] No owned log models found.")
            if onComplete then onComplete() end
            return
        end

        print(("[TreeModule] Selling %d log model(s) section by section."):format(#ownedModels))

        local globalIndex = 0
        for _, model in ipairs(ownedModels) do
            if not model or not model.Parent then continue end
            globalIndex = SellLogModelSectionBySection(model, LOT, sellPos, globalIndex)
        end

        if onComplete then onComplete() end
    end)
end

local function CleanupState()
    isChopping = false

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")

    if hrp and preChopCFrame then
        hrp.CFrame = preChopCFrame
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end

    player.CameraMode = Enum.CameraMode.Classic

    if preChopCameraCFrame then
        camera.CFrame = preChopCameraCFrame
    end
end

local function WaitForLogsToSettle(treeClass)
    local VELOCITY_THRESHOLD = 0.5
    local STABLE_DURATION    = 0.3
    local TIMEOUT            = 10
    local POLL_RATE          = 0.05

    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then task.wait(1.5) return end

    local innerWoods = {}
    for _, model in ipairs(logModels:GetChildren()) do
        if preChopLogModels[model] then continue end
        if model:IsA("Model") then
            local tc = model:FindFirstChild("TreeClass")
            if tc and tc.Value == treeClass then
                local iw = model:FindFirstChild("InnerWood")
                if iw and iw:IsA("BasePart") then
                    table.insert(innerWoods, iw)
                end
            end
        end
    end

    if #innerWoods == 0 then task.wait(1.5) return end

    local deadline   = tick() + TIMEOUT
    local stableFrom = nil

    while tick() < deadline do
        local allStill = true
        for _, iw in ipairs(innerWoods) do
            if not iw or not iw.Parent then continue end
            if iw.AssemblyLinearVelocity.Magnitude > VELOCITY_THRESHOLD then
                allStill = false
                break
            end
        end
        if allStill then
            if not stableFrom then
                stableFrom = tick()
            elseif tick() - stableFrom >= STABLE_DURATION then
                return
            end
        else
            stableFrom = nil
        end
        task.wait(POLL_RATE)
    end
    warn("[TreeModule] WaitForLogsToSettle timed out — proceeding anyway.")
end

-- ==========================================
--   LOT BATCH HELPER
-- ==========================================
local function RunLOTBatch(LOT, stumps, goalCFBuilder, onComplete)
    if not LOT then if onComplete then onComplete() end return end
    if #stumps == 0 then
        warn("[TreeModule] RunLOTBatch: nothing to teleport.")
        if onComplete then onComplete() end
        return
    end

    task.spawn(function()
        for i, stump in ipairs(stumps) do
            if LOT.IsBusy() then
                repeat task.wait(0.1) until not LOT.IsBusy()
            end
            local goalCF = goalCFBuilder(i, stump)
            LOT.TeleportObjectTo(stump, goalCF, true)
            task.spawn(function()
                repeat task.wait(0.1) until not LOT.IsBusy()
            end)
        end
        if onComplete then onComplete() end
    end)
end

-- ==========================================
--   PLANK SELLING
-- ==========================================
local PLANK_SELL_CF = CFrame.new(315, 0, 88) * CFrame.Angles(math.rad(90), 0, 0)
local _sellPlanksOn = false
local _hoverOutline = nil
local _hoverPlank   = nil
local _plankConn    = nil
local _clickConn    = nil
local _isSelling    = false

local function FindOwnedPlank(part)
    if not part then return nil end
    local current = part
    while current and current ~= Workspace do
        if current.Name == "Plank" and current:IsA("Model") then
            local playerModels = Workspace:FindFirstChild("PlayerModels")
            if not playerModels then return nil end
            if current.Parent ~= playerModels then return nil end
            local owner = current:FindFirstChild("Owner")
            if not owner then return nil end
            local ownerStr = owner:FindFirstChild("OwnerString")
            if not ownerStr or not ownerStr:IsA("StringValue") then return nil end
            if ownerStr.Value ~= player.Name then return nil end
            return current
        end
        current = current.Parent
    end
    return nil
end

local function ClearHoverOutline()
    if _hoverOutline then _hoverOutline:Destroy(); _hoverOutline = nil end
    _hoverPlank = nil
end

local function ApplyHoverOutline(model)
    if _hoverPlank == model then return end
    ClearHoverOutline()
    _hoverPlank                       = model
    _hoverOutline                     = Instance.new("SelectionBox")
    _hoverOutline.Adornee             = model
    _hoverOutline.Color3              = Color3.fromRGB(74, 120, 255)
    _hoverOutline.LineThickness       = 0.08
    _hoverOutline.SurfaceColor3       = Color3.fromRGB(74, 120, 255)
    _hoverOutline.SurfaceTransparency = 0.65
    _hoverOutline.Parent              = Workspace
end

local function StopSellPlanks()
    _sellPlanksOn = false
    _isSelling    = false
    ClearHoverOutline()
    if _plankConn then _plankConn:Disconnect(); _plankConn = nil end
    if _clickConn then _clickConn:Disconnect(); _clickConn = nil end
end

local function StartSellPlanks(LOT)
    if not LOT then warn("[TreeModule] LOT not available for Sell Planks.") return end

    _sellPlanksOn = true
    _isSelling    = false
    local mouse   = player:GetMouse()

    _plankConn = RunService.RenderStepped:Connect(function()
        if not _sellPlanksOn then return end
        if _isSelling then ClearHoverOutline() return end
        local plank = FindOwnedPlank(mouse.Target)
        if plank then ApplyHoverOutline(plank) else ClearHoverOutline() end
    end)

    _clickConn = mouse.Button1Down:Connect(function()
        if not _sellPlanksOn or _isSelling then return end
        if not _hoverPlank or not _hoverPlank.Parent then return end

        local plank = _hoverPlank
        ClearHoverOutline()
        _isSelling = true

        task.spawn(function()
            if LOT.IsBusy() then repeat task.wait(0.05) until not LOT.IsBusy() end

            local target = plank.PrimaryPart
            if not target then
                for _, v in ipairs(plank:GetDescendants()) do
                    if v:IsA("BasePart") then target = v; break end
                end
            end

            if not target then
                warn("[TreeModule] Plank has no BasePart to teleport.")
                _isSelling = false
                return
            end

            LOT.TeleportObjectTo(target, PLANK_SELL_CF)
            repeat task.wait(0.05) until not LOT.IsBusy()
            _isSelling = false
        end)
    end)
end

-- ==========================================
--   REMOTE CUT
-- ==========================================
local RemoteProxy = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("RemoteProxy")
local NPCDialogRemote = ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PlayerChatted")
local NPCPromptChat   = ReplicatedStorage:WaitForChild("NPCDialog"):WaitForChild("PromptChat")

local function CutHeightFrac(sizeY)
    return math.clamp(0.1 + (8 - sizeY) / 60, 0.1, 0.2)
end

local function FireCutSection(section, tool, axeName, treeClass, stopFn)
    if not section or not section.Parent then return end

    local idObj = section:FindFirstChild("ID")
    if not idObj then return end

    local cutEvent = section:FindFirstChild("CutEvent")
                  or section.Parent:FindFirstChild("CutEvent")
                  or (section.Parent.Parent and section.Parent.Parent:FindFirstChild("CutEvent"))
    if not cutEvent then return end

    local damage = LT2Axes.GetDamage(axeName, treeClass)
    local height = section.Size.Y * CutHeightFrac(section.Size.Y)

    local args = {
        sectionId    = idObj.Value,
        faceVector   = Vector3.new(0, 0, -1),
        height       = height,
        hitPoints    = damage,
        cooldown     = 0,
        cuttingClass = "Axe",
        tool         = tool,
    }

    for _ = 1, Settings.FiresPerSection do
        if not section.Parent then break end
        if stopFn and stopFn() then break end
        RemoteProxy:FireServer(cutEvent, args)
        task.wait(Settings.FireDelay)
    end
end

local function FireCutAtHeight(section, tool, axeName, treeClass, height)
    if not section or not section.Parent then return end
    local idObj = section:FindFirstChild("ID")
    if not idObj then return end

    local cutEvent = section:FindFirstChild("CutEvent")
                  or section.Parent:FindFirstChild("CutEvent")
                  or (section.Parent.Parent and section.Parent.Parent:FindFirstChild("CutEvent"))

    if not cutEvent then
        warn("[TreeModule] CutEvent not found for section:", section:GetFullName())
        for _, c in ipairs(section.Parent:GetChildren()) do
            print("  parent child:", c.Name, c.ClassName)
        end
        return
    end

    local damage = LT2Axes.GetDamage(axeName, treeClass)
    local args = {
        sectionId    = idObj.Value,
        faceVector   = Vector3.new(0, 0, -1),
        height       = height,
        hitPoints    = damage,
        cooldown     = 0,
        cuttingClass = "Axe",
        tool         = tool,
    }

    for _ = 1, Settings.FiresPerSection do
        if not section.Parent then break end
        RemoteProxy:FireServer(cutEvent, args)
        task.wait(Settings.FireDelay)
    end
end

-- ==========================================
--   CHOP LOGS INTO INDIVIDUAL SECTIONS
-- ==========================================
local function ChopLogsIntoSections(onComplete)
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then
        warn("[TreeModule] No LogModels folder.")
        if onComplete then onComplete() end
        return
    end

    local ownedModels = {}
    for _, model in ipairs(logModels:GetChildren()) do
        if model:IsA("Model") and IsOwnedByLocalPlayer(model) then
            table.insert(ownedModels, model)
        end
    end

    if #ownedModels == 0 then
        warn("[TreeModule] No owned log models to chop.")
        if onComplete then onComplete() end
        return
    end

    local function SnapshotModels()
        local snap = {}
        for _, m in ipairs(logModels:GetChildren()) do snap[m] = true end
        return snap
    end

    local function SectionCount(model)
        local count = 0
        for _, desc in ipairs(model:GetDescendants()) do
            if desc:IsA("BasePart") and desc.Name == "WoodSection" then
                count += 1
            end
        end
        return count
    end

    local function BuildConnectionMap(model)
        local map = {}
        for _, desc in ipairs(model:GetDescendants()) do
            if (desc:IsA("Weld") or desc:IsA("ManualWeld")) and desc.Name == "Tree Weld" then
                local p0, p1 = desc.Part0, desc.Part1
                if p0 and p1 and p0.Name == "WoodSection" and p1.Name == "WoodSection" then
                    map[p0] = (map[p0] or 0) + 1
                    map[p1] = (map[p1] or 0) + 1
                end
            end
        end
        return map
    end

    local function FindStump(model)
        local iw = model:FindFirstChild("InnerWood", true)
        if not iw then return nil end
        for _, desc in ipairs(model:GetDescendants()) do
            if (desc:IsA("Weld") or desc:IsA("ManualWeld")) then
                local p0, p1 = desc.Part0, desc.Part1
                if p0 == iw and p1 and p1.Name == "WoodSection" then return p1 end
                if p1 == iw and p0 and p0.Name == "WoodSection" then return p0 end
            end
        end
        return nil
    end

    local function FindTipWeld(model, tip)
        for _, desc in ipairs(model:GetDescendants()) do
            if (desc:IsA("Weld") or desc:IsA("ManualWeld")) and desc.Name == "Tree Weld" then
                local p0, p1 = desc.Part0, desc.Part1
                if p0 == tip and p1 and p1.Name == "WoodSection" then return desc, p1 end
                if p1 == tip and p0 and p0.Name == "WoodSection" then return desc, p0 end
            end
        end
        return nil
    end

    task.spawn(function()
        local queue = {}
        for _, m in ipairs(ownedModels) do
            table.insert(queue, m)
        end

        while #queue > 0 do
            local model = table.remove(queue, 1)
            if not model or not model.Parent then continue end

            local tc        = model:FindFirstChild("TreeClass")
            local treeClass = tc and tc.Value or "Generic"
            local tool, axeName = GetBackpackAxe(treeClass)
            local stump     = FindStump(model)

            if not tool then
                warn("[TreeModule] No axe found for model:", model.Name, "— skipping.")
                continue
            end

            while model and model.Parent and SectionCount(model) > 1 do
                local connMap = BuildConnectionMap(model)

                local tip = nil
                for section, count in pairs(connMap) do
                    if count == 1 and section ~= stump and section.Parent then
                        tip = section
                        break
                    end
                end

                if not tip then break end

                local weld, parent = FindTipWeld(model, tip)
                if not weld or not parent then break end

                local cutSection    = parent:FindFirstChild("ID") and parent or tip
                local jointWorldPos = (weld.Part0.CFrame * weld.C0).Position
                local localY        = (cutSection.CFrame:Inverse() * CFrame.new(jointWorldPos)).Position.Y
                local height        = math.clamp(localY + cutSection.Size.Y / 2, 0.05, cutSection.Size.Y - 0.05)

                local char = player.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(jointWorldPos + cutSection.CFrame.RightVector * 4)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    task.wait(0.1)
                end

                local before = SnapshotModels()

                FireCutAtHeight(cutSection, tool, axeName, treeClass, height)

                task.wait(0.1)

                for _, m in ipairs(logModels:GetChildren()) do
                    if not before[m] and m:IsA("Model") and IsOwnedByLocalPlayer(m) then
                        if SectionCount(m) > 1 then
                            table.insert(queue, m)
                        end
                    end
                end
            end
        end

        print("[TreeModule] Done chopping logs into sections.")
        if onComplete then onComplete() end
    end)
end

-- ==========================================
--   BRIDGE TOLL (LoneCave only)
-- ==========================================
local _bridgeNPCID       = nil
local _bridgeLastPaid    = 0
local BRIDGE_PAID_WINDOW = 120

local function BridgeSafeInvoke(npcArg, action)
    local co   = coroutine.running()
    local done = false
    local thread = task.spawn(function()
        pcall(function() NPCDialogRemote:InvokeServer(npcArg, action) end)
        if not done then done = true; task.spawn(co) end
    end)
    task.delay(7, function()
        if not done then done = true; pcall(task.cancel, thread); task.spawn(co) end
    end)
    coroutine.yield()
end

local function PayBridgeToll()
    local seranok = Workspace:FindFirstChild("Bridge")
        and Workspace.Bridge:FindFirstChild("TollBooth0")
        and Workspace.Bridge.TollBooth0:FindFirstChild("Seranok")

    if not seranok then
        warn("[TreeModule] Seranok not found — cannot lower bridge.")
        return
    end

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local npcRoot = seranok:FindFirstChild("HumanoidRootPart")
    hrp.CFrame = npcRoot
        and CFrame.new(npcRoot.Position + Vector3.new(3, 0, 0))
        or seranok:GetPivot() * CFrame.new(3, 0, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(0.1)

    if not seranok:FindFirstChild("Dialog") then
        Instance.new("Dialog", seranok)
    end

    if not _bridgeNPCID then
        local lastData = nil
        local conn = NPCPromptChat.OnClientEvent:Connect(function(_, data)
            if data then lastData = data end
        end)
        pcall(function() NPCPromptChat:FireServer(true, seranok, seranok.Dialog) end)
        local t = tick()
        repeat task.wait(0.05) until lastData or tick() - t > 5
        conn:Disconnect()
        pcall(function() NPCPromptChat:FireServer(false, seranok, seranok.Dialog) end)
        task.wait(0.1)

        if lastData then
            _bridgeNPCID = lastData.ID
        else
            warn("[TreeModule] Failed to get Seranok NPC ID.")
            return
        end
    end

    local npcArg = {
        ID        = _bridgeNPCID,
        Character = seranok,
        Name      = "Seranok",
        Dialog    = seranok.Dialog,
    }

    BridgeSafeInvoke(npcArg, "Initiate")
    task.wait(0.05)
    BridgeSafeInvoke(npcArg, "ConfirmPurchase")
    task.wait(0.05)
    BridgeSafeInvoke(npcArg, "EndChat")

    print("[TreeModule] Bridge toll paid — waiting for bridge to lower.")
    task.wait(1.5)
end

-- ==========================================
--   FALL DETECTION
-- ==========================================
local function TreeHasFallen(treeClass)
    local logModels = Workspace:FindFirstChild("LogModels")
    if not logModels then return false end
    for _, model in ipairs(logModels:GetChildren()) do
        if preChopLogModels[model] then continue end
        if not model:IsA("Model") then continue end
        local tc = model:FindFirstChild("TreeClass")
        if tc and tc.Value == treeClass then return true end
    end
    return false
end

-- ==========================================
--   DEATH / RESPAWN HANDLING
-- ==========================================
local function WaitForRespawn()
    print("[TreeModule] Player died — waiting for respawn...")

    local char = player.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then
        player.CharacterAdded:Wait()
    end

    local deadline = tick() + 30
    repeat
        task.wait(0.1)
        char = player.Character
        hum  = char and char:FindFirstChildOfClass("Humanoid")
    until (char and hum and hum.Health > 0 and char:FindFirstChild("HumanoidRootPart"))
       or tick() > deadline

    print(("[TreeModule] Respawned — resuming in %ds"):format(Settings.RespawnResumeDelay))
    task.wait(Settings.RespawnResumeDelay)
end

-- ==========================================
--   MAIN CHOP SEQUENCE
-- ==========================================
local function StartChopping(treeClass, LOT, onComplete)
    if isChopping then return end

    SnapshotLogModels()

    local treeModel = FindPriorityTree(treeClass)
    if not treeModel then
        warn("[TreeModule] No tree found for class:", treeClass)
        if onComplete then onComplete() end
        return
    end

    local sections = GetSectionsBottomFirst(treeModel)
    if #sections == 0 then
        warn("[TreeModule] Tree has no WoodSections.")
        if onComplete then onComplete() end
        return
    end

    local tool, axeName = GetBackpackAxe(treeClass)
    if not tool then
        warn("[TreeModule] No tool found in Backpack. Cannot chop.")
        if onComplete then onComplete() end
        return
    end
    print(("[TreeModule] Using '%s' from Backpack for tree class '%s'."):format(axeName, treeClass))

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        if onComplete then onComplete() end
        return
    end

    preChopCFrame       = hrp.CFrame
    preChopCameraCFrame = camera.CFrame
    isChopping          = true

    if treeClass == "LoneCave" then
        PayBridgeToll()
        char = player.Character
        hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            isChopping = false
            if onComplete then onComplete() end
            return
        end
    end

    local targetPart = sections[1]
    for _, s in ipairs(sections) do
        local idObj = s:FindFirstChild("ID")
        if idObj and idObj.Value == 1 then
            targetPart = s
            break
        end
    end
    hrp.CFrame = targetPart.CFrame
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    local lockConn = nil

    local function StartLockConn()
        if lockConn then lockConn:Disconnect() end
        lockConn = RunService.Heartbeat:Connect(function()
            local c = player.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r and targetPart and targetPart.Parent then
                r.CFrame = targetPart.CFrame
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    local function StopLockConn()
        if lockConn then lockConn:Disconnect(); lockConn = nil end
    end

    local playerDied = false
    local diedConn   = nil

    local function HookDiedEvent()
        if diedConn then diedConn:Disconnect(); diedConn = nil end
        local c    = player.Character
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        diedConn = hum2.Died:Connect(function()
            playerDied = true
            StopLockConn()
            print("[TreeModule] Death detected during chop.")
        end)
    end

    HookDiedEvent()
    StartLockConn()
    task.wait(Settings.SyncDelay)

    task.spawn(function()
        local baseSection = nil

        local function RefreshBaseSection()
            baseSection = nil
            local fresh = GetSectionsBottomFirst(treeModel)
            if #fresh == 0 then return end
            baseSection = fresh[1]
            for _, s in ipairs(fresh) do
                local idObj = s:FindFirstChild("ID")
                if idObj and idObj.Value == 1 then
                    baseSection = s
                    break
                end
            end
        end

        RefreshBaseSection()

        while not TreeHasFallen(treeClass) and isChopping do
            if playerDied then
                StopLockConn()
                WaitForRespawn()
                if not isChopping then break end
                if TreeHasFallen(treeClass) then break end

                tool, axeName = GetBackpackAxe(treeClass)
                if not tool then
                    warn("[TreeModule] No axe found after respawn — stopping.")
                    isChopping = false
                    break
                end
                print(("[TreeModule] Resumed with '%s' after respawn."):format(axeName))

                local newChar = player.Character
                local newHRP  = newChar and newChar:FindFirstChild("HumanoidRootPart")
                if newHRP and targetPart and targetPart.Parent then
                    newHRP.CFrame = targetPart.CFrame
                    newHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end

                playerDied = false
                HookDiedEvent()
                StartLockConn()
                task.wait(Settings.SyncDelay)

                RefreshBaseSection()
            end

            if not baseSection or not baseSection.Parent then
                RefreshBaseSection()
                if not baseSection then break end
            end

            FireCutSection(baseSection, tool, axeName, treeClass, function()
                return TreeHasFallen(treeClass) or playerDied
            end)

            task.wait(Settings.SweepDelay)
        end

        StopLockConn()
        if diedConn then diedConn:Disconnect(); diedConn = nil end

        if not isChopping then
            CleanupState()
            if onComplete then onComplete() end
            return
        end

        print("[TreeModule] Tree is down. Returning player.")
        task.wait(0.3)
        CleanupState()

        local stumps     = CollectNewStumps(treeClass)
        local currentHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        RunLOTBatch(LOT, stumps, function(i, _)
            return currentHRP
                and (currentHRP.CFrame * CFrame.new((i - 1) * 5, 0, -Settings.LogDropDistance))
                or CFrame.new(0, 0, 0)
        end, onComplete)
    end)
end

-- ==========================================
--   LIVE TREE REMOVAL WATCHER
-- ==========================================
local function WatchForRemovedTreeTypes(onClassEmpty)
    local connections = {}
    
    local function CountTreeClass(className)
        local count = 0
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:lower():match("treeregion") then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") then
                        local tc = model:FindFirstChild("TreeClass")
                        if tc and tc.Value == className and CountTreeSections(model) > 1 then
                            count += 1
                        end
                    end
                end
            end
        end
        return count
    end

    local function WatchFolder(folder)
        local conn = folder.ChildRemoved:Connect(function(model)
            if not model:IsA("Model") then return end
            local tc = model:FindFirstChild("TreeClass")
            if not tc or not tc:IsA("StringValue") then return end
            local className = tc.Value
            -- small delay to let the engine settle before we recount
            task.delay(0.5, function()
                local remaining = CountTreeClass(className)
                onClassEmpty(className, remaining == 0)
            end)
        end)
        table.insert(connections, conn)
    end

    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder.Name:lower():match("treeregion") then
            WatchFolder(folder)
        end
    end

    local workspaceConn = Workspace.ChildAdded:Connect(function(child)
        if child.Name:lower():match("treeregion") then
            WatchFolder(child)
        end
    end)
    table.insert(connections, workspaceConn)

    return function()
        for _, conn in ipairs(connections) do conn:Disconnect() end
    end
end

-- ==========================================
--   LIVE TREE TYPE WATCHER
-- ==========================================
-- Calls `onNewClass(className)` whenever a tree class appears in any
-- TreeRegion folder that wasn't present in `knownSet` at call time.
-- Returns a cleanup function that disconnects all listeners.
local function WatchForNewTreeTypes(knownSet, onNewClass)
    local connections = {}

    -- Hook ChildAdded on a single TreeRegion folder
    local function WatchFolder(folder)
        local conn = folder.ChildAdded:Connect(function(model)
            if not model:IsA("Model") then return end

            -- The TreeClass StringValue may not exist yet if the model
            -- is still streaming in — wait a short moment for it.
            task.delay(0.5, function()
                if not model or not model.Parent then return end
                local tc = model:FindFirstChild("TreeClass")
                if not tc or not tc:IsA("StringValue") then return end
                if CountTreeSections(model) <= 1 then return end
                local className = tc.Value
                if knownSet[className] then return end
                knownSet[className] = true
                onNewClass(className)
            end)
        end)
        table.insert(connections, conn)
    end

    -- Watch all TreeRegion folders that exist right now
    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder.Name:lower():match("treeregion") then
            WatchFolder(folder)
        end
    end

    -- Also watch for TreeRegion folders that haven't loaded yet
    local workspaceConn = Workspace.ChildAdded:Connect(function(child)
        if child.Name:lower():match("treeregion") then
            WatchFolder(child)
        end
    end)
    table.insert(connections, workspaceConn)

    -- Return a cleanup function so Init can disconnect everything on
    -- shutdown if needed (e.g. if the Tab is destroyed)
    return function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
    end
end

-- ==========================================
--             DYNXE UI
-- ==========================================
function TreeModule.Init(Tab, LOT)
    Tab:CreateSection("Auto-Tree Configuration")

    local PRIORITY_TREES = {
        "Generic", "Cherry", "Birch", "Oak", "Walnut", "Koa", "Pine", "Palm", "Fir",
        "Volcano", "Frost", "GreenSwampy", "GoldSwampy",
        "SnowGlow", "CaveCrawler", "LoneCave", "Spook", "Sinister",
    }

    local treeTypes = ScanForTreeTypes()
    
    -- Also scan for ALL tree classes present regardless of section count
    -- so we can show them in the list but disabled
    local function ScanAllTreeClasses()
        local found, seen = {}, {}
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:lower():match("treeregion") then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") then
                        local tc = model:FindFirstChild("TreeClass")
                        if tc and tc:IsA("StringValue") and not seen[tc.Value] then
                            seen[tc.Value] = true
                            table.insert(found, tc.Value)
                        end
                    end
                end
            end
        end
        return found
    end
    
    local allTreeClasses = ScanAllTreeClasses()
    
    local foundSet    = {}
    for _, t in ipairs(treeTypes) do foundSet[t] = true end
    local prioritySet = {}
    for _, t in ipairs(PRIORITY_TREES) do prioritySet[t] = true end
    
    -- allClassSet = every class present in workspace (even single-section ones)
    local allClassSet = {}
    for _, t in ipairs(allTreeClasses) do allClassSet[t] = true end
    
    local orderedOptions = {}
    local disabledInDrop = {}
    
    -- 1. Priority trees with valid (>1 section) trees — enabled
    for _, t in ipairs(PRIORITY_TREES) do
        if foundSet[t] then table.insert(orderedOptions, t) end
    end
    -- 2. Non-priority trees with valid trees — enabled
    for _, t in ipairs(treeTypes) do
        if not prioritySet[t] then table.insert(orderedOptions, t) end
    end
    -- 3. Priority trees that exist but only have single-section trees — disabled
    for _, t in ipairs(PRIORITY_TREES) do
        if not foundSet[t] and allClassSet[t] then
            table.insert(orderedOptions, t)
            disabledInDrop[t] = true
        end
    end
    -- 4. Priority trees completely absent from workspace — disabled
    for _, t in ipairs(PRIORITY_TREES) do
        if not allClassSet[t] then
            table.insert(orderedOptions, t)
            disabledInDrop[t] = true
        end
    end

    -- Default to first available (non-disabled) option
    local selectedTree = "Error"
    for _, t in ipairs(orderedOptions) do
        if not disabledInDrop[t] then selectedTree = t; break end
    end

    local chopQuantity      = 1
    local chopButton
    local chopSessionActive = false

    local treeDropdown = Tab:CreateDropdown("Target Tree Type", orderedOptions, selectedTree, function(sel)
        selectedTree = sel
    end)

    for t in pairs(disabledInDrop) do
        treeDropdown:SetOptionDisabled(t, true)
    end

    -- ── Live watcher ─────────────────────────────────────────────
    -- `knownSet` starts as a copy of foundSet so the watcher only
    -- fires for classes that were genuinely absent at init time.
    local knownSet = {}
    for k, v in pairs(foundSet) do knownSet[k] = v end

    WatchForNewTreeTypes(knownSet, function(newClass)
        print(("[TreeModule] New tree type detected: %s — enabling in dropdown."):format(newClass))

        -- If it's a known priority tree that was sitting disabled at
        -- the bottom, just re-enable it.  Otherwise add it fresh
        -- (between existing enabled options and the disabled block).
        if disabledInDrop[newClass] then
            disabledInDrop[newClass] = nil
            treeDropdown:SetOptionDisabled(newClass, false)
        else
            -- Truly new class (not in PRIORITY_TREES at all) —
            -- insert it before the first disabled entry so it lands
            -- in the "workspace extras" region of the list.
            local insertAt = #orderedOptions + 1
            for i, opt in ipairs(orderedOptions) do
                if disabledInDrop[opt] then
                    insertAt = i
                    break
                end
            end
            table.insert(orderedOptions, insertAt, newClass)
            treeDropdown:AddOption(newClass, insertAt)
        end

        -- If nothing was selectable before, auto-select this new class
        if selectedTree == "Error" then
            selectedTree = newClass
            treeDropdown:SetSelected(newClass)
        end
    end)
    -- ─────────────────────────────────────────────────────────────

    WatchForRemovedTreeTypes(function(className, isEmpty)
        if isEmpty then
            -- tree class has no more instances in any region — disable it
            disabledInDrop[className] = true
            treeDropdown:SetOptionDisabled(className, true)
            print(("[TreeModule] No more '%s' trees — disabled in dropdown."):format(className))
    
            -- if the player had this selected, reset to next available
            if selectedTree == className then
                selectedTree = "Error"
                for _, t in ipairs(orderedOptions) do
                    if not disabledInDrop[t] then
                        selectedTree = t
                        treeDropdown:SetSelected(t)
                        break
                    end
                end
            end
        else
            -- tree grew back / still has instances — make sure it's enabled
            if disabledInDrop[className] then
                disabledInDrop[className] = nil
                treeDropdown:SetOptionDisabled(className, false)
                print(("[TreeModule] '%s' trees available again — enabled in dropdown."):format(className))
            end
        end
    end)
    
    Tab:CreateSlider("Quantity", 1, 25, 1, function(val)
        chopQuantity = val
    end)

    chopButton = Tab:CreateAction("Get Tree", "Start", function()
        if chopSessionActive then
            chopSessionActive = false
            isChopping = false
            if type(chopButton) == "table" and chopButton.SetText then
                chopButton:SetText("Start")
            end
        else
            if selectedTree == "None Found" or selectedTree == "Error" then return end
            chopSessionActive = true
            if type(chopButton) == "table" and chopButton.SetText then
                chopButton:SetText("Stop")
            end

            local remaining = chopQuantity
            local function chopNext()
                if not chopSessionActive or remaining <= 0 then
                    chopSessionActive = false
                    if type(chopButton) == "table" and chopButton.SetText then
                        chopButton:SetText("Start")
                    end
                    return
                end
                remaining -= 1
                StartChopping(selectedTree, LOT, function()
                    chopNext()
                end)
            end

            chopNext()
        end
    end)

    Tab:CreateSection("Log Management")

    local chopSectionsButton = Tab:CreateAction("Chop All Trees", "Start", function()
        if not LOT then warn("[TreeModule] LOT not available.") return end

        if type(chopSectionsButton) == "table" and chopSectionsButton.SetText then
            chopSectionsButton:SetText("Chopping...")
        end

        ChopLogsIntoSections(function()
            if type(chopSectionsButton) == "table" and chopSectionsButton.SetText then
                chopSectionsButton:SetText("Start")
            end
        end)
    end)

    local tpAllButton = Tab:CreateAction("Teleport All Logs To Me", "TP", function()
        if not LOT then warn("[TreeModule] LOT not available.") return end
        if LOT.IsBusy() then warn("[TreeModule] LOT busy.") return end

        local stumps     = CollectAllOwnedStumps()
        local currentHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if #stumps == 0 then return end

        if type(tpAllButton) == "table" and tpAllButton.SetText then
            tpAllButton:SetText("Working...")
        end

        RunLOTBatch(LOT, stumps, function(_, _)
            return currentHRP
                and (currentHRP.CFrame * CFrame.new(0, 0, -Settings.LogDropDistance))
                or CFrame.new(0, 0, 0)
        end, function()
            if type(tpAllButton) == "table" and tpAllButton.SetText then
                tpAllButton:SetText("TP")
            end
        end)
    end)

    local sellButton = Tab:CreateAction("Sell All Logs", "Sell", function()
        if not LOT then warn("[TreeModule] LOT not available.") return end
        if LOT.IsBusy() then warn("[TreeModule] LOT busy.") return end

        local stumps = CollectSingleSectionStumps()
        if #stumps == 0 then return end

        if type(sellButton) == "table" and sellButton.SetText then
            sellButton:SetText("Selling...")
        end

        local sellPos = Settings.SellPosition
        RunLOTBatch(LOT, stumps, function(_, _)
            return CFrame.new(sellPos.X, sellPos.Y, sellPos.Z)
        end, function()
            if type(sellButton) == "table" and sellButton.SetText then
                sellButton:SetText("Sell")
            end
        end)
    end)

    Tab:CreateToggle("Click To Sell (Planks)", false, function(state)
        if state then StartSellPlanks(LOT) else StopSellPlanks() end
    end)
end

return TreeModule
