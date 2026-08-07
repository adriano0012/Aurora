-- [[ PLANK CUTTER MODULE ]] --
-- Designed for Dynxe LT2 UI Engine

local PlankCutterModule = {}

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player      = Players.LocalPlayer
local Mouse       = Player:GetMouse()
local RemoteProxy = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("RemoteProxy")
local LT2Axes = _G.LT2Axes

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                        CONSTANTS                                │
-- └─────────────────────────────────────────────────────────────────┘
local FIRE_DELAY      = 0.03
local CUT_TIMEOUT     = 90
local BLUE            = Color3.fromRGB(74, 120, 255)
local MAX_CUT_UNITS   = 100

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                          STATE                                  │
-- └─────────────────────────────────────────────────────────────────┘
local _enabled       = false
local _isCutting     = false

local _outline        = nil
local _cutPlanes      = {}
local _trackedSection = nil
local _currentTarget  = nil

local _hoverConn  = nil
local _clickConn  = nil
local _visualConn = nil

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      AXE DAMAGE TABLE                           │
-- └─────────────────────────────────────────────────────────────────┘
local function ReadAxeName(tool)
    if not tool then return nil end
    local tip = tool:FindFirstChild("ToolTip")
    return (tip and tip:IsA("StringValue")) and tip.Value or tool.ToolTip
end

local function GetPlankTreeClass(plankModel)
    if not plankModel then return nil end
    local tc = plankModel:FindFirstChild("TreeClass")
    if tc and tc:IsA("StringValue") then return tc.Value end
    -- check descendants too
    for _, v in ipairs(plankModel:GetDescendants()) do
        if v.Name == "TreeClass" and v:IsA("StringValue") then
            return v.Value
        end
    end
    return nil
end

local function GetBestAxe(treeClass)
    local candidates = {}
    local function TryAdd(tool)
        if not tool:IsA("Tool") then return end
        if tool.Name == "BlueprintTool" then return end
        local name = ReadAxeName(tool)
        if not name then return end

        -- LoneCave planks ONLY work with End Times Axe
        if treeClass == "LoneCave" then
            if name ~= "End Times Axe" then return end
        end

        local dmg = LT2Axes.GetDamage(name, treeClass) or 0
        table.insert(candidates, { tool = tool, name = name, dmg = dmg })
    end
    local char = Player.Character
    if char then
        local eq = char:FindFirstChildOfClass("Tool")
        if eq then TryAdd(eq) end
    end
    for _, t in ipairs(Player.Backpack:GetChildren()) do TryAdd(t) end
    if #candidates == 0 then return nil, nil, 0 end
    table.sort(candidates, function(a, b) return a.dmg > b.dmg end)
    local best = candidates[1]
    return best.tool, best.name, best.dmg
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      PLANK HELPERS                               │
-- └─────────────────────────────────────────────────────────────────┘
local function FindOwnedPlank(part)
    if not part then return nil end
    local pm = workspace:FindFirstChild("PlayerModels")
    if not pm then return nil end
    local cur = part
    while cur and cur.Parent ~= pm do cur = cur.Parent end
    if not cur or not cur:IsA("Model") or cur.Name ~= "Plank" then return nil end
    local owner    = cur:FindFirstChild("Owner")
    local ownerStr = owner and owner:FindFirstChild("OwnerString")
    if not ownerStr or ownerStr.Value ~= Player.Name then return nil end
    return cur
end

local function GetPlankSection(model)
    if not model then return nil end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and d:FindFirstChild("ID") then return d end
    end
    return nil
end

local function GetCutStep(section)
    return math.max(0.5, 1 / math.min(section.Size.X, section.Size.Z))
end

local function GetCutHeights(section)
    local sizeY = section.Size.Y
    local step  = GetCutStep(section)
    local out   = {}
    local h     = step
    while h < sizeY - 0.01 do
        table.insert(out, h)
        h = h + step
    end
    return out, step
end

local function IsPlankEligible(section, treeClass)
    if not section then return false end
    local heights, _ = GetCutHeights(section)
    if #heights > MAX_CUT_UNITS then return false end
    -- LoneCave requires End Times Axe specifically
    if treeClass == "LoneCave" then
        local tool, _, _ = GetBestAxe("LoneCave")
        if not tool then return false end
    end
    return true
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     PERSISTENT OUTLINE                          │
-- └─────────────────────────────────────────────────────────────────┘
local function EnsureOutline()
    if _outline and _outline.Parent then return end
    _outline                     = Instance.new("SelectionBox")
    _outline.Color3              = BLUE
    _outline.SurfaceColor3       = BLUE
    _outline.LineThickness       = 0.04
    _outline.SurfaceTransparency = 0.8
    _outline.Parent              = workspace
end

local function SetOutlineTarget(model)
    EnsureOutline()
    if _outline.Adornee ~= model then
        _outline.Adornee = model
    end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │               PERSISTENT CUT PLANES                              │
-- └─────────────────────────────────────────────────────────────────┘
local function ClearCutPlanes()
    for _, e in ipairs(_cutPlanes) do pcall(function() e.part:Destroy() end) end
    _cutPlanes      = {}
    _trackedSection = nil
end

local function RebuildCutPlanes(section)
    ClearCutPlanes()
    if not section or not section.Parent then return end

    local heights, _ = GetCutHeights(section)
    local sx    = section.Size.X + 0.08
    local sz    = section.Size.Z + 0.08
    local sizeY = section.Size.Y

    for _, h in ipairs(heights) do
        local localCF = CFrame.new(0, -sizeY / 2 + h, 0)
        local p              = Instance.new("Part")
        p.Anchored           = true
        p.CanCollide         = false
        p.CanTouch           = false
        p.CanQuery           = false  -- prevents mouse raycasts from hitting cut planes
        p.CastShadow         = false
        p.Size               = Vector3.new(sx, 0.04, sz)
        p.Color              = BLUE
        p.Material           = Enum.Material.Neon
        p.Transparency       = 0.2
        p.CFrame             = section.CFrame * localCF
        p.Parent             = workspace
        table.insert(_cutPlanes, { part = p, localCF = localCF })
    end

    _trackedSection = section
end

local function StartVisualTracking()
    if _visualConn then _visualConn:Disconnect() end
    _visualConn = RunService.Heartbeat:Connect(function()
        if not _trackedSection or not _trackedSection.Parent then return end
        local cf = _trackedSection.CFrame
        for _, e in ipairs(_cutPlanes) do
            if e.part.Parent then
                e.part.CFrame = cf * e.localCF
            end
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                   PLAYER TELEPORT                               │
-- └─────────────────────────────────────────────────────────────────┘
local function TeleportAbovePlank(section)
    local char = Player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not section or not section.Parent then return end
    local abovePos = section.CFrame.Position + Vector3.new(0, section.Size.Y / 2 + 3, 0)
    hrp.CFrame = CFrame.new(abovePos)
    hrp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                    CUT EVENT SEARCH                             │
-- └─────────────────────────────────────────────────────────────────┘
local function FindCutEvent(section)
    local cur = section
    while cur and cur ~= workspace do
        local ce = cur:FindFirstChild("CutEvent")
        if ce then return ce end
        cur = cur.Parent
    end
    return nil
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │               FIRE UNTIL THE CUT REGISTERS                       │
-- └─────────────────────────────────────────────────────────────────┘
local function FireUntilSplit(section, tool, damage, height)
    local idObj    = section:FindFirstChild("ID")
    local cutEvent = FindCutEvent(section)
    if not idObj or not cutEvent then
        warn("[PlankCutter] Missing ID or CutEvent on section:", section:GetFullName())
        return nil
    end

    local pm = workspace:FindFirstChild("PlayerModels")
    local snapshot = {}
    if pm then
        for _, m in ipairs(pm:GetChildren()) do snapshot[m] = true end
    end

    local args = {
        sectionId    = idObj.Value,
        faceVector   = Vector3.new(0, 0, -1),
        height       = height,
        hitPoints    = damage,
        cooldown     = 0,
        cuttingClass = "Axe",
        tool         = tool,
    }

    local function FindNewSection()
        if not pm then return nil end
        for _, m in ipairs(pm:GetChildren()) do
            if not snapshot[m] and m:IsA("Model") and m.Name == "Plank" then
                local owner    = m:FindFirstChild("Owner")
                local ownerStr = owner and owner:FindFirstChild("OwnerString")
                if ownerStr and ownerStr.Value == Player.Name then
                    local sec = GetPlankSection(m)
                    if sec then return sec end
                end
            end
        end
        return nil
    end

    local originalSizeY = section.Size.Y
    local deadline      = tick() + CUT_TIMEOUT

    while tick() < deadline and _enabled do
        if not section.Parent then
            task.wait(0.05)
            return FindNewSection()
        end

        RemoteProxy:FireServer(cutEvent, args)
        task.wait(FIRE_DELAY)

        if not section.Parent or section.Size.Y ~= originalSizeY then
            task.wait(0.05)
            return FindNewSection()
        end
    end

    warn("[PlankCutter] Cut timed out — stopping.")
    return nil
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                    MAIN CUT SEQUENCE                             │
-- └─────────────────────────────────────────────────────────────────┘
local function CutPlankIntoUnits(plankModel)
    _isCutting = true
    _currentTarget = plankModel
    SetOutlineTarget(plankModel)

    local treeClass = GetPlankTreeClass(plankModel)
    local tool, axeName, damage = GetBestAxe(treeClass)

    if not tool then
        if treeClass == "LoneCave" then
            warn("[PlankCutter] LoneCave plank requires End Times Axe — not found in backpack.")
        else
            warn("[PlankCutter] No axe found — aborting.")
        end
        SetOutlineTarget(nil); ClearCutPlanes(); _isCutting = false; _currentTarget = nil; return
    end

    local section = GetPlankSection(plankModel)  -- THIS WAS MISSING
    if not section then
        warn("[PlankCutter] Plank has no cuttable section — aborting.")
        SetOutlineTarget(nil); ClearCutPlanes(); _isCutting = false; _currentTarget = nil; return
    end

    local step = GetCutStep(section)
    print(("[PlankCutter] Starting — units=%d axe='%s' dmg=%.2f")
        :format(#GetCutHeights(section), axeName, damage))

    TeleportAbovePlank(section)
    task.wait(0.1)

    local cur = section

    while _enabled and cur and cur.Parent do
        if cur.Size.Y <= step + 0.05 then break end

        RebuildCutPlanes(cur)

        _currentTarget = cur.Parent
        SetOutlineTarget(_currentTarget)

        local newSec = FireUntilSplit(cur, tool, damage, step)

        ClearCutPlanes()

        if not newSec then
            warn("[PlankCutter] Could not confirm cut — stopping early.")
            break
        end

        local nextPiece = cur
        if not (cur.Parent and cur.Size.Y > newSec.Size.Y) then
            nextPiece = newSec
        end

        if nextPiece and nextPiece.Parent then
            cur = nextPiece
            _currentTarget = nextPiece.Parent
            SetOutlineTarget(_currentTarget)
        end

        task.wait(0.1)
    end

    ClearCutPlanes()
    _isCutting = false
    print("[PlankCutter] Done.")
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                HOVER / CLICK CONNECTIONS                         │
-- └─────────────────────────────────────────────────────────────────┘
local function Stop()
    _enabled = false
    if _hoverConn  then _hoverConn:Disconnect();  _hoverConn  = nil end
    if _clickConn  then _clickConn:Disconnect();  _clickConn  = nil end
    if _visualConn then _visualConn:Disconnect(); _visualConn = nil end
    SetOutlineTarget(nil)
    ClearCutPlanes()
    _currentTarget = nil
end

local function Start()
    _enabled = true
    EnsureOutline()
    StartVisualTracking()

    local lastSection = nil

    _hoverConn = RunService.RenderStepped:Connect(function()
        if not _enabled or _isCutting then return end

        local target = Mouse.Target
        local plank  = FindOwnedPlank(target)

        if plank then
            local sec = GetPlankSection(plank)
            local tc  = GetPlankTreeClass(plank)
            if sec and IsPlankEligible(sec, tc) then
                if _currentTarget ~= plank then
                    _currentTarget = plank
                    SetOutlineTarget(plank)
                end
                if sec ~= lastSection then
                    lastSection = sec
                    RebuildCutPlanes(sec)
                end
            else
                if _currentTarget then
                    _currentTarget = nil
                    SetOutlineTarget(nil)
                    ClearCutPlanes()
                    lastSection = nil
                end
            end
        else
            -- Mouse hit nothing plank-related; only clear if we have a target
            -- and the hit part is not a descendant of it (guards against parts
            -- inside the plank model that FindOwnedPlank can't resolve).
            local clearOk = true
            if _currentTarget and target and target:IsDescendantOf(_currentTarget) then
                clearOk = false
            end
            if clearOk and _currentTarget then
                _currentTarget = nil
                SetOutlineTarget(nil)
                ClearCutPlanes()
                lastSection = nil
            end
        end
    end)

    _clickConn = Mouse.Button1Down:Connect(function()
        if not _enabled or _isCutting then return end
        local plank = FindOwnedPlank(Mouse.Target)
        if not plank then return end
        local sec = GetPlankSection(plank)
        local tc  = GetPlankTreeClass(plank)
        if not IsPlankEligible(sec, tc) then return end
        task.spawn(function() CutPlankIntoUnits(plank) end)
    end)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                        MODULE INIT                               │
-- └─────────────────────────────────────────────────────────────────┘
function PlankCutterModule.Init(Tab)
    Tab:CreateSection("1x1 Plank Cutter")
    Tab:CreateToggle("1x1 Cutter", false, function(state)
        if state then Start() else Stop() end
    end)
end

return PlankCutterModule
