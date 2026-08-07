-- [[ MOD TREE MODULE ]]
-- Designed for Dynxe LT2 UI Engine

local ModTreeModule = {}

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

local Player      = Players.LocalPlayer
local Mouse       = Player:GetMouse()
local RemoteProxy = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("RemoteProxy")
local LT2Axes     = _G.LT2Axes

local ClientPlacedBlueprint = ReplicatedStorage
    :WaitForChild("PlaceStructure")
    :WaitForChild("ClientPlacedBlueprint")

local _LOT = nil
local _Lib = nil

function ModTreeModule.SetLOT(lot) _LOT = lot end

-- Constants
local MOD_TP_CF            = CFrame.new(-1420, 380, 1400)
local DROP_ZONE_CF         = CFrame.new(-360, 92, -100)
local DISAPPEAR_TIMEOUT    = 60
local CHOP_FIRES           = 100
local CHOP_FIRE_DELAY      = 0.03
local CHOP_CONFIRM_TIMEOUT = 40

-- Blueprint placement constants
local BLUEPRINT_NAME  = "Floor2"
local TILE_END_OFFSET = CFrame.new(-0.2, 5, 0)
local TILE_OFFSET_4L  = CFrame.new(-0.2, 9, 0)
local OVERLAP_RADIUS  = 10

-- Session state
local _isModding      = false
local _isModSawmill   = false
local _currentSession = nil

-- ┌─────────────────────────────────────────────────────────────────┐
-- │  Module-level alive refs — stored here so the cancel handlers   │
-- │  can set [1] = false and immediately unblock any WaitFor loop   │
-- │  that is still spinning in an old or cancelled run.             │
-- │  Without this, old loops outlive their run and fire duplicate   │
-- │  notifications when the player clicks something in a new run.   │
-- └─────────────────────────────────────────────────────────────────┘
local _modAliveRef     = { false }
local _sawmillAliveRef = { false }

-- ============================================================
-- NOTIFY HELPER
-- ============================================================

local function Notify(title, text)
    if _Lib and _Lib.Notify then
        _Lib:Notify(title, text)
    end
end

-- ============================================================
-- SAWMILL BLUEPRINT HELPERS
-- ============================================================

local function GetBlueprintOffset(sawmill)
    local itemName = sawmill:FindFirstChild("ItemName")
    if itemName and itemName.Value == "Sawmill4L" then return TILE_OFFSET_4L end
    return TILE_END_OFFSET
end

local function GetSawmillParticlesCF(sawmill)
    local particles = sawmill:FindFirstChild("Particles", true)
    if particles and particles:IsA("BasePart") then return particles.CFrame end
    return select(1, sawmill:GetBoundingBox())
end

local function FindExistingBlueprint(targetPos)
    local pm = workspace:FindFirstChild("PlayerModels")
    if not pm then return nil end
    for _, model in ipairs(pm:GetChildren()) do
        local itemName = model:FindFirstChild("ItemName")
        if not itemName or itemName.Value ~= BLUEPRINT_NAME then continue end
        local owner       = model:FindFirstChild("Owner")
        local ownerString = owner and owner:FindFirstChild("OwnerString")
        local ownerVal    = owner and owner.Value
        local isOwner = (ownerString and ownerString.Value == Player.Name)
                     or (ownerVal    and ownerVal           == Player)
        if not isOwner then continue end
        local cf = (model:FindFirstChild("MainCFrame") and model.MainCFrame.Value)
                or (model.PrimaryPart and model.PrimaryPart.CFrame)
                or model:GetPivot()
        if (cf.Position - targetPos).Magnitude <= OVERLAP_RADIUS then
            return model
        end
    end
    return nil
end

local function PlaceBlueprintAtSawmill(sawmill)
    local finalCF  = GetSawmillParticlesCF(sawmill) * GetBlueprintOffset(sawmill)
    local existing = FindExistingBlueprint(finalCF.Position)
    if existing then
        print("[ModTree] Blueprint already at sawmill — skipping placement.")
        return
    end
    print("[ModTree] Placing Floor2 blueprint at sawmill output...")
    ClientPlacedBlueprint:FireServer(BLUEPRINT_NAME, finalCF, Player)
    print("[ModTree] Blueprint placed.")
end

-- ============================================================
-- AXE HELPERS
-- ============================================================

local function ReadAxeName(tool)
    if not tool then return nil end
    local tip = tool:FindFirstChild("ToolTip")
    return (tip and tip:IsA("StringValue")) and tip.Value or tool.ToolTip
end

local function GetBestAxe(treeClass)
    local candidates = {}

    local function TryAdd(tool)
        if not tool:IsA("Tool") or tool.Name == "BlueprintTool" then return end
        local name = ReadAxeName(tool)
        if not name then return end
        local score = treeClass
            and LT2Axes.GetDamage(name, treeClass)
            or (1 / (LT2Axes.Rank[name] or 2^53))
        table.insert(candidates, { tool = tool, name = name, score = score })
    end

    local char = Player.Character
    if char then
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then TryAdd(equipped) end
    end
    for _, tool in ipairs(Player.Backpack:GetChildren()) do TryAdd(tool) end

    if #candidates == 0 then return nil, nil, 0 end
    table.sort(candidates, function(a, b) return a.score > b.score end)

    local best = candidates[1]
    return best.tool, best.name, best.score
end

-- ============================================================
-- TREE ANALYSIS
-- ============================================================

local function AnalyzeTree(treeModel)
    local entries = {}

    for _, part in ipairs(treeModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "Stump" then
            local idVal = part:FindFirstChild("ID")
            if idVal and (idVal:IsA("IntValue") or idVal:IsA("NumberValue")) then
                local childIDs    = {}
                local childFolder = part:FindFirstChild("ChildIDs")
                if childFolder then
                    for _, child in ipairs(childFolder:GetChildren()) do
                        if child.Name == "Child" and (child:IsA("IntValue") or child:IsA("NumberValue")) then
                            table.insert(childIDs, child.Value)
                        end
                    end
                end
                table.insert(entries, {
                    part        = part,
                    id          = idVal.Value,
                    childIDs    = childIDs,
                    hasChildren = #childIDs > 0,
                })
            end
        end
    end

    table.sort(entries, function(a, b) return a.id < b.id end)

    local stumpEntry, targetEntry = entries[1], nil
    for i = #entries, 1, -1 do
        if entries[i].hasChildren then targetEntry = entries[i]; break end
    end

    local tipID = nil
    if targetEntry then
        for _, cid in ipairs(targetEntry.childIDs) do
            if not tipID or cid > tipID then tipID = cid end
        end
    end

    return { all = entries, stump = stumpEntry, target = targetEntry, tipID = tipID }
end

-- ============================================================
-- CLICK HELPERS
-- ============================================================

local function GetAncestorModel(instance)
    local current = instance
    while current and not current:IsA("Model") do current = current.Parent end
    return current
end

local function WaitForTreeClick(aliveRef)
    local logModels = workspace:FindFirstChild("LogModels")
    local result, done, conn = nil, false, nil
    conn = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if not target then return end
        local model = GetAncestorModel(target)
        if not model then return end
        if not logModels or model.Parent ~= logModels then return end
        for _, desc in ipairs(model:GetDescendants()) do
            if desc:IsA("BasePart") and desc:FindFirstChild("ID") then
                result = model; done = true; conn:Disconnect(); return
            end
        end
    end)
    while not done and aliveRef[1] do task.wait() end
    if conn.Connected then conn:Disconnect() end
    return result
end

local SAWMILL_NAMES = {
    Sawmill = true, Sawmill2 = true, Sawmill3 = true,
    Sawmill4 = true, Sawmill4L = true,
}

local function WaitForSawmillClick(aliveRef)
    local result, done, conn = nil, false, nil
    conn = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if not target then return end
        local playerModels = workspace:FindFirstChild("PlayerModels")
        if not playerModels then return end
        local current = target
        while current and current.Parent ~= playerModels do current = current.Parent end
        if not current or not current:IsA("Model") then return end
        local itemName = current:FindFirstChild("ItemName")
        if itemName and itemName:IsA("StringValue") and SAWMILL_NAMES[itemName.Value] then
            result = current; done = true; conn:Disconnect()
        end
    end)
    while not done and aliveRef[1] do task.wait() end
    if conn.Connected then conn:Disconnect() end
    return result
end

-- ============================================================
-- REMOTE CUT
-- ============================================================

local function FireCutSection(section, tool, axeName, treeClass, stopFn)
    if not section or not section.Parent then return false end

    local idObj = section:FindFirstChild("ID")
    if not idObj then
        warn("[ModTree] FireCutSection: no ID on", section:GetFullName()); return false
    end

    local cutEvent, current = nil, section
    while current and current ~= workspace do
        cutEvent = current:FindFirstChild("CutEvent")
        if cutEvent then break end
        current = current.Parent
    end
    if not cutEvent then
        warn("[ModTree] FireCutSection: CutEvent not found for", section:GetFullName()); return false
    end

    local char = Player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.lookAt(section.Position + section.CFrame.RightVector * 4, section.Position)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        task.wait(0.1)
    end

    local sizeY  = section.Size.Y
    local height = sizeY * math.clamp(0.1 + (8 - sizeY) / 60, 0.1, 0.2)
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

    for _ = 1, CHOP_FIRES do
        if not section.Parent then break end
        if stopFn and stopFn() then break end
        RemoteProxy:FireServer(cutEvent, args)
        task.wait(CHOP_FIRE_DELAY)
    end

    return true
end

-- ============================================================
-- LAVA HELPERS
-- ============================================================

local function GetAllLavaTouchParts()
    local parts = {}
    for _, child in ipairs(workspace.Region_Volcano:GetChildren()) do
        for _, desc in ipairs(child:GetDescendants()) do
            if desc:IsA("BasePart")
            and (desc:FindFirstChildOfClass("TouchTransmitter") or desc:FindFirstChild("TouchInterest")) then
                table.insert(parts, desc)
            end
        end
    end
    return parts
end

-- ============================================================
-- LOT HELPERS
-- ============================================================

local function SafeTeleportMany(batch)
    if _LOT.IsBusy() then _LOT.WaitForBatch() end
    _LOT.TeleportMany(batch)
    if _LOT.IsBusy() then _LOT.WaitForBatch() end
end

-- ============================================================
-- MAIN MOD SEQUENCE
-- ============================================================

local function RunModLoop(onDone)
    -- Fresh alive ref for this run. Storing it at module level means the
    -- cancel handler can set [1] = false and immediately unblock any
    -- WaitFor loop, preventing old runs from firing stale notifications.
    _modAliveRef = { true }
    local aliveRef = _modAliveRef

    _isModding = true

    local char0    = Player.Character
    local root0    = char0 and char0:FindFirstChild("HumanoidRootPart")
    local preModCF = root0 and root0.CFrame

    -- Step 1: tree selection
    Notify("Mod Tree", "Click the tree you want to mod.")
    print("[ModTree] Click the tree you want to mod.")

    local treeModel = WaitForTreeClick(aliveRef)

    -- aliveRef[1] is false only when the cancel button was pressed.
    -- In that case the cancel handler already reset state, so exit silently
    -- without calling onDone (which would double-trigger SetState).
    if not aliveRef[1] then return end

    if not treeModel then
        _isModding = false; if onDone then onDone() end; return
    end
    print("[ModTree] Tree selected:", treeModel.Name)

    local treeClassObj = treeModel:FindFirstChild("TreeClass")
    local treeClass    = treeClassObj and treeClassObj.Value or nil

    -- Step 2: sawmill selection
    Notify("Mod Tree", "Now click your sawmill.")
    print("[ModTree] Click the sawmill.")

    local sawmill = WaitForSawmillClick(aliveRef)

    if not aliveRef[1] then return end

    if not sawmill then
        _isModding = false; if onDone then onDone() end; return
    end
    print("[ModTree] Sawmill selected:", sawmill.Name)

    local sawmillParticles = sawmill:FindFirstChild("Particles", true)
    local sawmillCF
    if sawmillParticles and sawmillParticles:IsA("BasePart") then
        sawmillCF = sawmillParticles.CFrame
    else
        warn("[ModTree] Particles part not found — using bounding box.")
        sawmillCF = sawmill:GetBoundingBox()
    end

    local function SawmillStandCF()
        return sawmillCF * CFrame.new(0, 8, 6)
    end

    -- Step 3: analyse tree
    print("[ModTree] Analysing tree...")
    local analysis = AnalyzeTree(treeModel)

    if #analysis.all == 0 then
        warn("[ModTree] No wood sections found.")
        _isModding = false; if onDone then onDone() end; return
    end
    if not analysis.target then
        warn("[ModTree] No weld-holding section found.")
        _isModding = false; if onDone then onDone() end; return
    end

    local baseSection = nil
    for _, entry in ipairs(analysis.all) do
        if entry.id == 1 then baseSection = entry.part; break end
    end
    if not baseSection then baseSection = analysis.all[1].part end

    local originalTreeCF = baseSection.CFrame

    local logModels  = workspace:FindFirstChild("LogModels")
    local beforeLogs = {}
    if logModels then
        for _, m in ipairs(logModels:GetChildren()) do beforeLogs[m] = true end
    end

    local function GetOurNewLogModels()
        local result = {}
        if logModels then
            for _, m in ipairs(logModels:GetChildren()) do
                if not beforeLogs[m] and m:IsA("Model") then
                    table.insert(result, m)
                end
            end
        end
        return result
    end

    local function FindSectionInScope(targetID)
        for _, entry in ipairs(analysis.all) do
            if entry.id == targetID and entry.part and entry.part.Parent then
                return entry.part
            end
        end
        for _, desc in ipairs(treeModel:GetDescendants()) do
            if desc:IsA("BasePart") then
                local idVal = desc:FindFirstChild("ID")
                if idVal and idVal.Value == targetID then return desc end
            end
        end
        for _, model in ipairs(GetOurNewLogModels()) do
            for _, desc in ipairs(model:GetDescendants()) do
                if desc:IsA("BasePart") then
                    local idVal = desc:FindFirstChild("ID")
                    if idVal and idVal.Value == targetID then return desc end
                end
            end
        end
        return nil
    end

    -- Step 4: LOT to drop zone, then CFrame to mod zone
    SafeTeleportMany({ { target = baseSection, goalCF = DROP_ZONE_CF } })
    pcall(function() baseSection.CFrame = MOD_TP_CF end)

    -- Step 5: shrink lava touch parts
    local touchParts = GetAllLavaTouchParts()
    if #touchParts == 0 then
        warn("[ModTree] No TouchInterest parts found under Region_Volcano.")
        _isModding = false; if onDone then onDone() end; return
    end
    print(("[ModTree] Found %d lava touch part(s)."):format(#touchParts))

    local touchSizes, touchCFs = {}, {}
    for i, tp in ipairs(touchParts) do
        touchSizes[i] = tp.Size
        touchCFs[i]   = tp.CFrame
        tp.Size = Vector3.new(0.1, 0.1, 0.1)
    end

    _currentSession = {
        treeModel      = treeModel,
        baseSection    = baseSection,
        originalTreeCF = originalTreeCF,
        preModCF       = preModCF,
        sawmillCF      = sawmillCF,
        touchParts     = touchParts,
        touchSizes     = touchSizes,
        touchCFs       = touchCFs,
    }

    -- Step 6: lock lava parts onto weld-holder to trigger "Burning"
    local targetSection = analysis.target.part
    local tipID         = analysis.tipID
    print(("[ModTree] Target ID=%d | Tip ID=%d"):format(analysis.target.id, tipID))

    local MAX_BURN_ATTEMPTS = 5
    local burnConfirmed     = false

    for attempt = 1, MAX_BURN_ATTEMPTS do
        if not _isModding then break end

        if attempt > 1 then
            print(("[ModTree] Retrying burn (%d/%d) — re-CFraming tree."):format(attempt, MAX_BURN_ATTEMPTS))
            pcall(function() baseSection.CFrame = MOD_TP_CF end)
            task.wait(0.1)
        end

        local lockConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local targetCF = targetSection.CFrame
                for _, tp in ipairs(touchParts) do
                    tp.Size   = Vector3.new(0.1, 0.1, 0.1)
                    tp.CFrame = targetCF
                end
            end)
        end)
        task.wait(0.1)
        lockConn:Disconnect()

        for i, tp in ipairs(touchParts) do
            pcall(function() tp.Size = touchSizes[i]; tp.CFrame = touchCFs[i] end)
        end

        task.wait(0.1)

        if treeModel:FindFirstChild("Burning") then
            print(("[ModTree] Burning confirmed on attempt %d/%d."):format(attempt, MAX_BURN_ATTEMPTS))
            burnConfirmed = true
            break
        end

        warn(("[ModTree] Burning not detected (attempt %d/%d)."):format(attempt, MAX_BURN_ATTEMPTS))
    end

    _currentSession.touchParts = nil

    if not burnConfirmed or not _isModding then
        warn("[ModTree] Could not confirm tree is burning — aborting.")
        _isModding = false
        _currentSession = nil
        local failChar = Player.Character
        local failRoot = failChar and failChar:FindFirstChild("HumanoidRootPart")
        if failRoot and preModCF then failRoot.CFrame = preModCF end
        if onDone then onDone() end
        return
    end

    -- Step 7: Burning confirmed — reposition sections.
    print("[ModTree] Burning confirmed — repositioning sections.")
    local tipSection = FindSectionInScope(tipID)
    pcall(function() targetSection.CFrame = CFrame.new(1279, 52, 2328) end)
    pcall(function() baseSection.CFrame = DROP_ZONE_CF end)
    if tipSection and tipSection.Parent then
        pcall(function() tipSection.CFrame = sawmillCF end)
        print(("[ModTree] Tip (ID=%d) moved directly to sawmill."):format(tipID))
    else
        warn(("[ModTree] Tip (ID=%d) not yet available at burn time."):format(tipID))
    end

    -- Step 7b: wait for weld-holder to be destroyed
    print("[ModTree] Waiting for weld-holder to be removed...")
    local disappearDeadline = tick() + DISAPPEAR_TIMEOUT
    while tick() < disappearDeadline do
        if not targetSection or not targetSection.Parent then break end
        task.wait(0.1)
    end
    if targetSection and targetSection.Parent then
        warn("[ModTree] Weld-holder did not disappear in time — proceeding anyway.")
    else
        print("[ModTree] Weld-holder removed.")
    end

    -- Step 8: chop the stump section
    print("[ModTree] Chopping stump section...")

    local stumpID      = analysis.stump and analysis.stump.id or 1
    local stumpSection = FindSectionInScope(stumpID)

    local tool, axeName = GetBestAxe(treeClass)
    if not tool then
        warn("[ModTree] No axe found — skipping stump chop.")
    else
        print(("[ModTree] Using '%s' (treeClass=%s)."):format(axeName, tostring(treeClass)))

        local initialSize = stumpSection and stumpSection.Size
                         or Vector3.new(math.huge, math.huge, math.huge)

        local function TreeHasFallen()
            if not stumpSection or not stumpSection.Parent then return true end
            return stumpSection.Size.Y < initialSize.Y - 1
        end

        local chopDone     = false
        local chopDeadline = tick() + CHOP_CONFIRM_TIMEOUT

        while not chopDone and tick() < chopDeadline do
            if not stumpSection or not stumpSection.Parent then
                stumpSection = FindSectionInScope(stumpID)
                if stumpSection then initialSize = stumpSection.Size end
            end
            if not stumpSection or not stumpSection.Parent then
                warn("[ModTree] Stump section lost — aborting chop."); break
            end
            FireCutSection(stumpSection, tool, axeName, treeClass, TreeHasFallen)
            chopDone = TreeHasFallen()
        end

        if chopDone then
            print("[ModTree] Chop confirmed.")
        else
            warn("[ModTree] Chop timed out — proceeding anyway.")
        end
    end

    -- Step 9: TP player to sawmill stand then notify done
    local returnChar = Player.Character
    local returnRoot = returnChar and returnChar:FindFirstChild("HumanoidRootPart")
    if returnRoot then returnRoot.CFrame = SawmillStandCF() end

    Notify("Mod Tree", "Done!")
    print("[ModTree] Done — tip placed at sawmill.")

    _isModding = false
    _currentSession = nil
    if onDone then onDone() end
end

-- ============================================================
-- MODULE INIT
-- ============================================================

function ModTreeModule.Init(Tab, lot, lib)
    if lot ~= nil then _LOT = lot end
    if lib ~= nil then _Lib = lib end

    Tab:CreateSection("Mod Tree Options")

    -- ── Mod Sawmill button ──────────────────────────────────
    local ModSawmillBtn

    local function SetSawmillState(active)
        if ModSawmillBtn then
            ModSawmillBtn:SetText(active and "Cancel" or "Sawmill")
        end
    end

    ModSawmillBtn = Tab:CreateAction("Mod Sawmill", "Sawmill", function()
        if _isModSawmill then
            -- Kill the waiting loop immediately so no stale notify fires.
            _isModSawmill = false
            _sawmillAliveRef[1] = false
            SetSawmillState(false)
            print("[ModTree] Mod Sawmill cancelled.")
            return
        end

        _isModSawmill = true
        SetSawmillState(true)

        task.spawn(function()
            -- Fresh ref for this sawmill run.
            _sawmillAliveRef = { true }
            local aliveRef = _sawmillAliveRef

            Notify("Mod Sawmill", "Click your sawmill.")
            print("[ModTree] Mod Sawmill — click your sawmill.")

            local sawmill = WaitForSawmillClick(aliveRef)

            -- Silently exit if cancelled; cancel handler already reset state.
            if not aliveRef[1] then return end

            if not sawmill then
                _isModSawmill = false
                SetSawmillState(false)
                return
            end

            PlaceBlueprintAtSawmill(sawmill)
            Notify("Mod Sawmill", "Fill the Floor2 blueprint!")

            _isModSawmill = false
            SetSawmillState(false)
        end)
    end, false)

    ModSawmillBtn:AddTooltip(
        "Places a Floor2 blueprint at your sawmill's output end.\n" ..
        "Run this BEFORE modding a tree.\n" ..
        "After placement, fill the blueprint with wood planks\n" ..
        "so the modded log lands on a full surface."
    )

    -- ── Mod Tree button ─────────────────────────────────────
    local ModBtn

    local function SetState(modding)
        if ModBtn then ModBtn:SetText(modding and "Cancel" or "Tree") end
    end

    ModBtn = Tab:CreateAction("Mod Tree", "Tree", function()
        if _isModding then
            -- Kill the waiting loop immediately so no stale notify fires.
            _isModding = false
            _modAliveRef[1] = false

            if _currentSession then
                local s = _currentSession
                _currentSession = nil

                if s.touchParts then
                    for i, tp in ipairs(s.touchParts) do
                        pcall(function() tp.Size = s.touchSizes[i]; tp.CFrame = s.touchCFs[i] end)
                    end
                end

                local cancelChar = Player.Character
                local cancelRoot = cancelChar and cancelChar:FindFirstChild("HumanoidRootPart")
                if cancelRoot then
                    if s.sawmillCF then
                        cancelRoot.CFrame = s.sawmillCF * CFrame.new(0, 8, 6)
                    elseif s.preModCF then
                        cancelRoot.CFrame = s.preModCF
                    end
                end

                print("[ModTree] Cancelled.")
            end

            SetState(false)
            return
        end

        SetState(true)
        task.spawn(function() RunModLoop(function() SetState(false) end) end)
    end, false)

    ModBtn:AddTooltip("First click on a chopped tree, then on your sawmill.")
end

return ModTreeModule
