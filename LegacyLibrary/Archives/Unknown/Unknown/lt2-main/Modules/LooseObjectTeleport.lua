-- [[ LOOSE OBJECT TELEPORT MODULE ]] --
-- Designed for Dynxe LT2 UI Engine

local LooseObjectTeleport = {}

local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService   = game:GetService("GuiService")
local Players      = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player    = Players.LocalPlayer
local Camera    = workspace.CurrentCamera
local Mouse     = Player:GetMouse()

local ClientIsDragging = ReplicatedStorage:WaitForChild("Interaction"):WaitForChild("ClientIsDragging")

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                        SIGNAL UTILITY                           │
-- └─────────────────────────────────────────────────────────────────┘
local function NewSignal()
    local sig = { _listeners = {} }
    function sig:Connect(fn)
        local id = {}
        self._listeners[id] = fn
        return { Disconnect = function() self._listeners[id] = nil end }
    end
    function sig:Wait()
        local co = coroutine.running()
        local conn
        conn = self:Connect(function(...)
            conn:Disconnect()
            task.spawn(co, ...)
        end)
        return coroutine.yield()
    end
    function sig:_Fire(...)
        for _, fn in pairs(self._listeners) do
            task.spawn(fn, ...)
        end
    end
    return sig
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     CONFIGURATION & STATE                       │
-- └─────────────────────────────────────────────────────────────────┘
local Settings = {
    OwnershipTimeout = 1,
    FallbackWait     = 0.5,
    PreFireWait      = 0.05,
    PostObjectDelay  = 0.1,

    SelectionColor   = Color3.fromRGB(74, 120, 255),
    OutlineThickness = 0.05,

    StackX       = 5,
    StackY       = 1,
    StackZ       = 2,
    StackPadding = 0.1,

    PyramidMode  = false,
    KeepSelected   = false,
    ReturnToOrigin = true,
    MatchPlankSize = true,
}

local State = {
    SelectedObjects = {},
    SelectionBoxes  = {},
    Connections     = {},
    IsBusy          = false,
    BatchCancelled  = false,

    ClickSelectMode = false,
    GroupSelectMode = false,
    LassoMode       = false,
    LassoDragging   = false,
    LassoStartPos   = nil,
    LassoGui        = nil,
    LassoFrame      = nil,
    TpBtn           = nil,

    StackMode         = false,
    StackPreviewParts = {},
    StackPreviewBoxes = {},
    StackPreviewConn  = nil,
    StackStartBtn     = nil,
    StackRotation     = CFrame.new(),
    ItemRotation      = CFrame.new(),

    Library        = nil,
    BatchCompleted = NewSignal(),

    -- Set in Init once both action buttons exist.
    -- Called by UpdateVisuals on every selection change so button
    -- disabled-states always reflect the current selection.
    SyncButtons    = nil,
}

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                        HELPER FUNCTIONS                         │
-- └─────────────────────────────────────────────────────────────────┘
local function GetItemName(model)
    if not model then return nil end
    local iv = model:FindFirstChild("ItemName")
    return (iv and iv.Value ~= "") and iv.Value or model.Name
end

local function GetOwnerIdentity(model)
    if not model then return nil end
    local ownerValue = model:FindFirstChild("Owner")
    if ownerValue then
        local val = ownerValue.Value
        if typeof(val) == "Instance" and val:IsA("Player") then return val.Name end
        return tostring(val)
    end
    return nil
end

local function GetModelSignature(model)
    local mainPart  = model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    local mainClass = mainPart and mainPart.ClassName or "nil"
    local childKeys = {}
    for _, child in ipairs(model:GetChildren()) do
        if child.Name == "Type" then continue end
        table.insert(childKeys, child.ClassName .. ":" .. child.Name)
    end
    table.sort(childKeys)
    return mainClass .. "|" .. table.concat(childKeys, ",")
end

local function GetTreeClass(model)
    local tc = model:FindFirstChild("TreeClass")
    return tc and tostring(tc.Value) or nil
end

-- Single source of truth for object eligibility.
-- All three selection modes (click, group, lasso) run candidates through
-- this so their rules are always identical.
local function getObjectData(target)
    if not target or not target:IsA("BasePart") or target.Anchored then return nil end
    if target:IsDescendantOf(Player.Character) then return nil end

    local current = target.Parent
    while current and current ~= workspace do
        if current:IsA("Model") then
            local typeVal = current:FindFirstChild("Type")
            if typeVal and (typeVal.Value == "Vehicle" or typeVal.Value == "Structure")
            and not current:FindFirstChild("PurchasedBoxItemName") then
                return nil
            end
        end
        current = current.Parent
    end

    local model = target:FindFirstAncestorOfClass("Model")
    local main  = (model and model:FindFirstChild("Main")) or target
    if main:IsA("BasePart") and not main.Anchored then
        return main, (model and model.Name or target.Name), model
    end
    return nil
end

local function UpdateVisuals()
    for _, v in pairs(State.SelectionBoxes) do v:Destroy() end
    State.SelectionBoxes = {}
    for _, obj in ipairs(State.SelectedObjects) do
        if obj and obj.Parent then
            local box         = Instance.new("SelectionBox")
            box.Color3        = Settings.SelectionColor
            box.LineThickness = Settings.OutlineThickness
            box.Adornee       = obj
            box.Parent        = game:GetService("CoreGui")
            table.insert(State.SelectionBoxes, box)
        end
    end
    -- Sync button disabled-states whenever selection changes.
    if State.SyncButtons then State.SyncButtons() end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                      CORE TELEPORT LOGIC                        │
-- └─────────────────────────────────────────────────────────────────┘
local function GetDynamicDelay()
    local samples = {}
    local last = workspace.DistributedGameTime
    for _ = 1, 5 do
        RunService.Heartbeat:Wait()
        local now = workspace.DistributedGameTime
        if now ~= last then
            table.insert(samples, now - last)
            last = now
        end
    end
    local avg = if #samples > 0
        then (function() local s = 0 for _, v in ipairs(samples) do s += v end return s / #samples end)()
        else 1/20  -- pessimistic fallback if no change was observed

    -- 60 hz server ≈ 0.016 s → ~0.25 s delay
    -- 20 hz server ≈ 0.050 s → ~0.75 s delay
    --  5 hz server ≈ 0.200 s → ~2.00 s delay (clamped)
    return math.clamp(avg * 20, 0.5, 1)
end

local function PlayerAlignedCFrame(position, root)
    local look     = root.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if flatLook.Magnitude < 0.001 then
        flatLook = Vector3.new(0, 0, -1)
    end
    flatLook = flatLook.Unit
    local yaw = math.atan2(-flatLook.X, -flatLook.Z)
    return CFrame.new(position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(math.rad(90), 0, 0)
end
    
local function FindLastInteraction(model)
    local ownerFolder = model:FindFirstChild("Owner")
    if ownerFolder then
        local li = ownerFolder:FindFirstChild("LastInteraction")
        if li then return li end
    end
    return model:FindFirstChild("LastInteraction")
end

local function TeleportSingle(target, goalCF, root)
    if not target or not target.Parent then return end

    local model          = target:FindFirstAncestorOfClass("Model") or target.Parent
    local lastInteracted = FindLastInteraction(model)

    root.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))

    local ownerFolder = model:FindFirstChild("Owner")
    local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
    if ownerString and ownerString.Value ~= Player.Name then
        local MAX_ATTEMPTS = 5
        local BASE_DELAY   = GetDynamicDelay()
    
        for attempt = 1, MAX_ATTEMPTS do
            local deadline = tick() + (BASE_DELAY * attempt)
            while tick() < deadline do
                pcall(ClientIsDragging.FireServer, ClientIsDragging, model)
                task.wait()
            end
    
            if target and target.Parent then
                target.CFrame = goalCF
            end
            task.wait(0.2)
    
            local dist = (target.Position - goalCF.Position).Magnitude
            if dist < 2 then break end
        end
    
        task.wait(Settings.PostObjectDelay)
        return
    end

    task.wait(Settings.PreFireWait)

    if lastInteracted then
        local co    = coroutine.running()
        local fired = false

        local conn = lastInteracted:GetPropertyChangedSignal("Value"):Connect(function()
            if not fired then
                fired = true
                task.spawn(co)
            end
        end)

        local fireLoop = task.spawn(function()
            local deadline = tick() + Settings.OwnershipTimeout

            local ok, err = pcall(function()
                while not fired and tick() < deadline do
                    ClientIsDragging:FireServer(model)
                    task.wait()
                end
            end)

            if not fired then
                fired = true
                task.spawn(co)
                if not ok then
                    warn(("[LOT] FireServer errored on '%s': %s")
                        :format(model.Name, tostring(err)))
                else
                    warn(("[LOT] LastInteraction on '%s' never changed within %.1fs — proceeding anyway.")
                        :format(model.Name, Settings.OwnershipTimeout))
                end
            end
        end)

        coroutine.yield()
        conn:Disconnect()
        pcall(task.cancel, fireLoop)
    else
        warn(("[LOT] No Owner.LastInteraction found on '%s' — using fallback wait."):format(model.Name))
        local deadline = tick() + Settings.FallbackWait
        while tick() < deadline do
            local ok, err = pcall(ClientIsDragging.FireServer, ClientIsDragging, model)
            if not ok then
                warn(("[LOT] Fallback FireServer errored on '%s': %s"):format(model.Name, tostring(err)))
                break
            end
            task.wait()
        end
    end

    if target and target.Parent then
        target.CFrame = goalCF
    end

    task.wait(Settings.PostObjectDelay)
end

-- `returnToOrigin`: nil → use Settings.ReturnToOrigin (the toggle).
--                  true/false → explicit per-call override; toggle unchanged.
local function RunBatch(jobs, returnToOrigin)
    if returnToOrigin == nil then
        returnToOrigin = Settings.ReturnToOrigin
    end

    if #jobs == 0 then
        State.BatchCompleted:_Fire(true, 0)
        return true
    end

    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then
        State.BatchCompleted:_Fire(false, 0)
        return false
    end

    State.IsBusy         = true
    State.BatchCancelled = false

    local savedCFrame = root.CFrame

    for _, job in ipairs(jobs) do
        if State.BatchCancelled then break end
        if job.target and job.target.Parent then
            local ok, err = pcall(TeleportSingle, job.target, job.goalCF, root)
            if not ok then
                warn(("[LOT] TeleportSingle failed, skipping object: %s"):format(tostring(err)))
            end
        end
    end

    if returnToOrigin and root and root.Parent then
        root.CFrame = savedCFrame
    end

    State.IsBusy = false

    local success = not State.BatchCancelled
    State.BatchCompleted:_Fire(success, #jobs)
    return success
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                         LASSO ENGINE                            │
-- └─────────────────────────────────────────────────────────────────┘
local function InitLassoGui()
    if State.LassoGui then State.LassoGui:Destroy() end
    local sg = Instance.new("ScreenGui")
    sg.Name           = "LassoDragGui"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent         = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.BackgroundColor3       = Color3.fromRGB(60, 130, 255)
    frame.BackgroundTransparency = 0.75
    frame.BorderSizePixel        = 0
    frame.Visible                = false
    frame.ZIndex                 = 10
    frame.Parent                 = sg

    local stroke           = Instance.new("UIStroke")
    stroke.Color           = Color3.fromRGB(120, 180, 255)
    stroke.Thickness       = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent          = frame

    State.LassoGui   = sg
    State.LassoFrame = frame
end

local function UpdateLassoFrame(currentPos)
    if not State.LassoFrame or not State.LassoStartPos then return end
    local minX = math.min(State.LassoStartPos.X, currentPos.X)
    local minY = math.min(State.LassoStartPos.Y, currentPos.Y)
    local maxX = math.max(State.LassoStartPos.X, currentPos.X)
    local maxY = math.max(State.LassoStartPos.Y, currentPos.Y)
    State.LassoFrame.Position = UDim2.fromOffset(minX, minY)
    State.LassoFrame.Size     = UDim2.fromOffset(maxX - minX, maxY - minY)
    State.LassoFrame.Visible  = true
end

-- Searches PlayerModels using the same getObjectData eligibility rules
-- as Click Selection. `seen` prevents the same resolved Main part from
-- being toggled more than once across nested model paths.
local function SelectObjectsInLassoRect(startPos, endPos)
    local minX = math.min(startPos.X, endPos.X)
    local minY = math.min(startPos.Y, endPos.Y)
    local maxX = math.max(startPos.X, endPos.X)
    local maxY = math.max(startPos.Y, endPos.Y)
    if (maxX - minX) < 6 or (maxY - minY) < 6 then return end

    local playerModels = workspace:FindFirstChild("PlayerModels")
    if not playerModels then return end

    local inset = GuiService:GetGuiInset()
    local seen  = {}

    for _, obj in ipairs(playerModels:GetDescendants()) do
        if obj:IsA("BasePart") then
            local main = getObjectData(obj)   -- same rules as click selection
            if main and not seen[main] then
                seen[main] = true
                local screenPos, onScreen = Camera:WorldToScreenPoint(main.Position)
                local sx = screenPos.X + inset.X
                local sy = screenPos.Y + inset.Y
                if onScreen and screenPos.Z > 0
                    and sx >= minX and sx <= maxX
                    and sy >= minY and sy <= maxY then
                    local idx = table.find(State.SelectedObjects, main)
                    if idx then
                        table.remove(State.SelectedObjects, idx)
                    else
                        table.insert(State.SelectedObjects, main)
                    end
                end
            end
        end
    end

    UpdateVisuals()
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                         STACK ENGINE                            │
-- └─────────────────────────────────────────────────────────────────┘

local function GetMainPartSizeY(model)
    local main = model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
    if not main then return nil end
    return math.round(main.Size.Y * 100) / 100
end
    
local function AllSelectedSameType()
    if #State.SelectedObjects == 0 then return false, "Queue is empty." end
    local refName, refSig, refTreeClass, refSizeY
    for _, obj in ipairs(State.SelectedObjects) do
        if not (obj and obj.Parent) then continue end
        local model     = obj:FindFirstAncestorOfClass("Model")
        local name      = model and GetItemName(model) or obj.Name
        local sig       = model and GetModelSignature(model) or (obj.ClassName .. ":" .. obj.Name)
        local treeClass = model and GetTreeClass(model) or nil
        local sizeY     = model and GetMainPartSizeY(model) or nil

        if not refName then
            refName = name; refSig = sig
            refTreeClass = treeClass; refSizeY = sizeY
        else
            if name ~= refName or sig ~= refSig then
                return false, "Mixed item types — all items must be identical."
            end
            if treeClass ~= refTreeClass then
                return false, "Mixed wood types — all items must be the same tree class."
            end
            if sizeY ~= nil and refSizeY ~= nil then
                if Settings.MatchPlankSize and math.abs(sizeY - refSizeY) > 1 then
                    return false, "Mixed sizes — all items must be the same size."
                end
            end
        end
    end
    return true, "OK"
end

local function GetStackPositions(origin, itemSize, countX, countY, countZ, totalItems, stackRotation)
    stackRotation = stackRotation or CFrame.new()
    local stepX = itemSize.X + Settings.StackPadding
    local stepY = itemSize.Y
    local stepZ = itemSize.Z + Settings.StackPadding

    local raw = {}
    for y = 0, countY - 1 do
        for z = 0, countZ - 1 do
            for x = 0, countX - 1 do
                table.insert(raw, Vector3.new(x * stepX, y * stepY, z * stepZ))
                if #raw >= totalItems then break end
            end
            if #raw >= totalItems then break end
        end
        if #raw >= totalItems then break end
    end

    local sumX, sumZ = 0, 0
    for _, p in ipairs(raw) do sumX += p.X; sumZ += p.Z end
    local cx = sumX / #raw
    local cz = sumZ / #raw

    local positions = {}
    for _, p in ipairs(raw) do
        local centered = Vector3.new(p.X - cx, p.Y, p.Z - cz)
        table.insert(positions, origin + stackRotation:VectorToWorldSpace(centered))
    end
    return positions
end

local function GetPyramidCapacity(countX, countZ)
    local total, layer = 0, 0
    while true do
        local lx = countX - layer
        local lz = countZ - layer
        if lx <= 0 or lz <= 0 then break end
        total += lx * lz
        layer += 1
    end
    return math.max(total, 1)
end

local function GetPyramidPositions(origin, itemSize, countX, countZ, totalItems, stackRotation)
    stackRotation = stackRotation or CFrame.new()
    local stepX = itemSize.X + Settings.StackPadding
    local stepY = itemSize.Y
    local stepZ = itemSize.Z + Settings.StackPadding

    local raw   = {}
    local layer = 0

    while #raw < totalItems do
        local lx = countX - layer
        local lz = countZ - layer
        if lx <= 0 or lz <= 0 then break end

        -- Each layer shrinks inward so it sits centred on the one below
        local offsetX = layer * stepX * 0.5
        local offsetZ = layer * stepZ * 0.5

        for z = 0, lz - 1 do
            for x = 0, lx - 1 do
                table.insert(raw, Vector3.new(
                    x * stepX + offsetX,
                    layer * stepY,
                    z * stepZ + offsetZ
                ))
                if #raw >= totalItems then break end
            end
            if #raw >= totalItems then break end
        end
        layer += 1
    end

    local sumX, sumZ = 0, 0
    for _, p in ipairs(raw) do sumX += p.X; sumZ += p.Z end
    local cx = sumX / #raw
    local cz = sumZ / #raw

    local positions = {}
    for _, p in ipairs(raw) do
        local centered = Vector3.new(p.X - cx, p.Y, p.Z - cz)
        table.insert(positions, origin + stackRotation:VectorToWorldSpace(centered))
    end
    return positions
end
    
local function ClearStackPreview()
    if State.StackPreviewConn then State.StackPreviewConn:Disconnect() State.StackPreviewConn = nil end
    for _, box in ipairs(State.StackPreviewBoxes) do if box and box.Parent then box:Destroy() end end
    State.StackPreviewBoxes = {}
    for _, p in ipairs(State.StackPreviewParts) do if p and p.Parent then p:Destroy() end end
    State.StackPreviewParts = {}
end

local function SetTpBtnLabel(label)
    if State.TpBtn and State.TpBtn.SetText then
        State.TpBtn:SetText(label)
    end
end

local function SetStackBtnLabel(label)
    if State.StackStartBtn and State.StackStartBtn.SetText then
        State.StackStartBtn:SetText(label)
    end
end

local function StopStackMode(silent)
    State.StackMode     = false
    State.StackRotation = CFrame.new()
    State.ItemRotation  = CFrame.new()
    ClearStackPreview()
    if not silent then
        SetStackBtnLabel("Start")
        if State.SyncButtons then State.SyncButtons() end
    end
end

-- Returns the world-space bounding box size of an object after
-- applying a rotation. Used so stack steps match the rotated dimensions.
local function RotatedBoundingSize(size, rotation)
    local c1 = rotation.RightVector
    local c2 = rotation.UpVector
    local c3 = -rotation.LookVector
    return Vector3.new(
        math.abs(c1.X)*size.X + math.abs(c2.X)*size.Y + math.abs(c3.X)*size.Z,
        math.abs(c1.Y)*size.X + math.abs(c2.Y)*size.Y + math.abs(c3.Y)*size.Z,
        math.abs(c1.Z)*size.X + math.abs(c2.Z)*size.Y + math.abs(c3.Z)*size.Z
    )
end
    
-- silent=true → called from PerformStackExecute, which owns its label lifecycle.
-- Don't reset the label or call SyncButtons here in that case.
local function StartStackMode()
    if State.StackMode then StopStackMode() return end

    local ok = AllSelectedSameType()
    if not ok then return end

    local capacity = Settings.PyramidMode
        and GetPyramidCapacity(Settings.StackX, Settings.StackZ)
        or  (Settings.StackX * Settings.StackY * Settings.StackZ)
    local stackCount = math.min(capacity, #State.SelectedObjects)

    -- Reference model + sizes
    local refModel  = nil
    local refSize   = Vector3.new(4, 4, 4)
    local refBBSize = Vector3.new(4, 4, 4)
    for _, obj in ipairs(State.SelectedObjects) do
        if obj and obj.Parent then
            refModel = obj:FindFirstAncestorOfClass("Model") or obj.Parent
            refSize  = obj.Size
            local _, bbSize = refModel:GetBoundingBox()
            refBBSize = bbSize
            break
        end
    end
    if not refModel then return end

    ClearStackPreview()
    for i = 1, stackCount do
        local clone = refModel:Clone()
        for _, desc in ipairs(clone:GetDescendants()) do
            if desc:IsA("BasePart") then
                desc.Transparency = 0.55
                desc.Anchored     = true
                desc.CanCollide   = false
                desc.CanTouch     = false
                desc.CastShadow   = false
            end
        end
        local main = clone:FindFirstChild("Main") or clone:FindFirstChildWhichIsA("BasePart")
        if main then clone.PrimaryPart = main end
        clone.Parent = workspace
        table.insert(State.StackPreviewParts, clone)

        local box         = Instance.new("SelectionBox")
        box.Color3        = Color3.fromRGB(140, 180, 255)
        box.LineThickness = 0.03
        box.Adornee       = clone
        box.Parent        = game:GetService("CoreGui")
        table.insert(State.StackPreviewBoxes, box)
    end

    State.StackMode = true
    SetStackBtnLabel("Stop")
    if State.SyncButtons then State.SyncButtons() end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    State.StackPreviewConn = RunService.RenderStepped:Connect(function()
        if not State.StackMode then return end

        local excludeList = {}
        if Player.Character then table.insert(excludeList, Player.Character) end
        for _, preview in ipairs(State.StackPreviewParts) do
            for _, part in ipairs(preview:GetDescendants()) do
                if part:IsA("BasePart") then table.insert(excludeList, part) end
            end
        end
        rayParams.FilterDescendantsInstances = excludeList

        local unitRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local result  = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, rayParams)
        -- Use bounding box height so the full model sits on the ground, not just the Main part
        local effectiveSize = RotatedBoundingSize(refSize, State.ItemRotation)
        local groundOrigin  = result
            and (result.Position + Vector3.new(0, RotatedBoundingSize(refBBSize, State.ItemRotation).Y * 0.5, 0))
            or  (unitRay.Origin + unitRay.Direction * 40)
        
        local positions = Settings.PyramidMode
            and GetPyramidPositions(
                    groundOrigin, effectiveSize,
                    Settings.StackX, Settings.StackZ,
                    #State.StackPreviewParts, State.StackRotation)
            or  GetStackPositions(
                    groundOrigin, effectiveSize,
                    Settings.StackX, Settings.StackY, Settings.StackZ,
                    #State.StackPreviewParts, State.StackRotation)

        for i, preview in ipairs(State.StackPreviewParts) do
            if positions[i] then
                preview:PivotTo(CFrame.new(positions[i]) * State.StackRotation * State.ItemRotation)
            end
        end
    end)
end

-- Keeps "Stop" on the stack button while the batch runs, resets to "Start" after.
local function PerformStackExecute(hitPos)
    if not State.StackMode then return end
    local ok = AllSelectedSameType()
    if not ok then StopStackMode() return end

    local refModel  = nil
    local refSize   = Vector3.new(4, 4, 4)
    local refBBSize = Vector3.new(4, 4, 4)
    for _, obj in ipairs(State.SelectedObjects) do
        if obj and obj.Parent then
            refModel = obj:FindFirstAncestorOfClass("Model") or obj.Parent
            refSize  = obj.Size
            local _, bbSize = refModel:GetBoundingBox()
            refBBSize = bbSize
            break
        end
    end
    
    local capacity = Settings.PyramidMode
        and GetPyramidCapacity(Settings.StackX, Settings.StackZ)
        or  (Settings.StackX * Settings.StackY * Settings.StackZ)
    local stackCount = math.min(capacity, #State.SelectedObjects)
    
    local capturedRotation     = State.StackRotation
        local capturedItemRotation = State.ItemRotation
    
        local effectiveSize = RotatedBoundingSize(refSize, capturedItemRotation)
        local groundOrigin  = hitPos + Vector3.new(0, RotatedBoundingSize(refBBSize, capturedItemRotation).Y * 0.5, 0)
        local goalPositions = Settings.PyramidMode
            and GetPyramidPositions(
                    groundOrigin, effectiveSize,
                    Settings.StackX, Settings.StackZ,
                    stackCount, capturedRotation)
            or  GetStackPositions(
                    groundOrigin, effectiveSize,
                    Settings.StackX, Settings.StackY, Settings.StackZ,
                    stackCount, capturedRotation)
    
    -- silent=true: don't let StopStackMode reset the label; we manage it below.
    StopStackMode(true)

    local jobs = {}
    for i = 1, stackCount do
        local obj = State.SelectedObjects[i]
        if obj and obj.Parent then
            table.insert(jobs, {
                target = obj,
                goalCF = CFrame.new(goalPositions[i] or groundOrigin) * capturedRotation * capturedItemRotation
            })
        end
    end

    task.spawn(function()
        SetStackBtnLabel("Stop")
        -- IsBusy is about to become true; ensure button stays enabled for cancel.
        if State.SyncButtons then State.SyncButtons() end

        RunBatch(jobs)

        SetStackBtnLabel("Start")
        if not Settings.KeepSelected then State.SelectedObjects = {} end
        UpdateVisuals()   -- also calls SyncButtons
    end)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                     BUTTON / HOTKEY ACTIONS                     │
-- └─────────────────────────────────────────────────────────────────┘
local function PerformSingleSelect()
    local main = getObjectData(Mouse.Target)
    if main then
        local idx = table.find(State.SelectedObjects, main)
        if not idx then
            table.insert(State.SelectedObjects, main)
        else
            table.remove(State.SelectedObjects, idx)
        end
        UpdateVisuals()
    end
end
    
-- Searches PlayerModels using the same getObjectData eligibility rules
-- as Click Selection. `seen` prevents double-toggling the same Main part.
local function PerformGroupSelect()
    local _, _, targetModel = getObjectData(Mouse.Target)
    if not targetModel then return end

    local targetItemName  = GetItemName(targetModel)
    local targetOwnerIden = GetOwnerIdentity(targetModel)
    local targetSig       = GetModelSignature(targetModel)
    local targetTreeClass = GetTreeClass(targetModel)
    local targetSizeY = targetModel and GetMainPartSizeY(targetModel) or nil

    if not targetItemName then return end

    local playerModels = workspace:FindFirstChild("PlayerModels")
    if not playerModels then return end

    local seen = {}
    local i    = 0
    for _, obj in ipairs(playerModels:GetDescendants()) do
        i += 1
        if i % 1000 == 0 then task.wait() end

        if obj:IsA("Model")
            and GetItemName(obj) == targetItemName
            and GetOwnerIdentity(obj) == targetOwnerIden
            and GetModelSignature(obj) == targetSig
            and GetTreeClass(obj) == targetTreeClass
            and (not Settings.MatchPlankSize
                or targetSizeY == nil
                or (GetMainPartSizeY(obj) ~= nil and math.abs(GetMainPartSizeY(obj) - targetSizeY) <= 1))
        then  -- <-- this was missing
            local rawPart = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
            if rawPart then
                local main = getObjectData(rawPart)
                if main and not seen[main] then
                    seen[main] = true
                    local idx = table.find(State.SelectedObjects, main)
                    if idx then
                        table.remove(State.SelectedObjects, idx)
                    else
                        table.insert(State.SelectedObjects, main)
                    end
                end
            end
        end
    end
    UpdateVisuals()
end

local function PerformClear()
    if State.StackMode then StopStackMode() end
    State.SelectedObjects = {}
    State.BatchCancelled  = true
    UpdateVisuals()
end

local function PerformExecute()
    if State.IsBusy then
        State.BatchCancelled = true
        return
    end

    if #State.SelectedObjects == 0 or not Player.Character then return end
    local char = Player.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local finalPos = root.Position

    local jobs = {}
    for _, obj in ipairs(State.SelectedObjects) do
        if obj and obj.Parent then
            table.insert(jobs, {
                target = obj,
                goalCF = PlayerAlignedCFrame(finalPos, root)
            })
        end
    end

    task.spawn(function()
        SetTpBtnLabel("Stop")
        -- IsBusy is about to become true; keep button enabled for cancel.
        if State.SyncButtons then State.SyncButtons() end

        RunBatch(jobs)

        SetTpBtnLabel("Start")
        if not Settings.KeepSelected then State.SelectedObjects = {} end
        UpdateVisuals()   -- also calls SyncButtons
    end)
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                         PUBLIC API                              │
-- └─────────────────────────────────────────────────────────────────┘
function LooseObjectTeleport.Select(part)
    assert(typeof(part) == "Instance" and part:IsA("BasePart"), "LOT.Select: expected BasePart")
    if State.IsBusy then warn("LOT.Select: ignored — batch running.") return end
    if not table.find(State.SelectedObjects, part) then
        table.insert(State.SelectedObjects, part)
        UpdateVisuals()
    end
end

function LooseObjectTeleport.Deselect(part)
    local idx = table.find(State.SelectedObjects, part)
    if idx then table.remove(State.SelectedObjects, idx) UpdateVisuals() end
end

function LooseObjectTeleport.Clear()
    PerformClear()
end

function LooseObjectTeleport.TeleportTo(goalCF, returnToOrigin)
    assert(typeof(goalCF) == "CFrame", "LOT.TeleportTo: expected CFrame")
    if #State.SelectedObjects == 0 then return false end
    if State.IsBusy then warn("LOT.TeleportTo: ignored — batch running.") return false end
    local jobs = {}
    for _, obj in ipairs(State.SelectedObjects) do
        if obj and obj.Parent then table.insert(jobs, { target = obj, goalCF = goalCF }) end
    end
    local success = RunBatch(jobs, returnToOrigin)
    State.SelectedObjects = {}
    UpdateVisuals()
    return success
end

function LooseObjectTeleport.TeleportObjectTo(part, goalCF, returnToOrigin)
    assert(typeof(part) == "Instance" and part:IsA("BasePart"), "LOT.TeleportObjectTo: expected BasePart")
    assert(typeof(goalCF) == "CFrame", "LOT.TeleportObjectTo: expected CFrame")
    if State.IsBusy then warn("LOT.TeleportObjectTo: ignored — batch running.") return false end
    return RunBatch({ { target = part, goalCF = goalCF } }, returnToOrigin)
end

function LooseObjectTeleport.TeleportMany(jobs, returnToOrigin)
    assert(type(jobs) == "table", "LOT.TeleportMany: expected table of jobs")
    if State.IsBusy then warn("LOT.TeleportMany: ignored — batch running.") return false end
    return RunBatch(jobs, returnToOrigin)
end

function LooseObjectTeleport.WaitForBatch()
    if not State.IsBusy then return true, 0 end
    return State.BatchCompleted:Wait()
end

function LooseObjectTeleport.IsBusy()
    return State.IsBusy
end

function LooseObjectTeleport.GetQueueSize()
    return #State.SelectedObjects
end

LooseObjectTeleport.BatchCompleted = nil

-- ┌─────────────────────────────────────────────────────────────────┐
-- │                          INITIALIZE                             │
-- └─────────────────────────────────────────────────────────────────┘
function LooseObjectTeleport.Init(Tab, LibraryInstance)
    State.Library = LibraryInstance
    LooseObjectTeleport.BatchCompleted = State.BatchCompleted

    for _, conn in ipairs(State.Connections) do conn:Disconnect() end
    State.Connections = {}

    InitLassoGui()

    local ClickToggle, GroupToggle, LassoToggle

    local function DisableOtherSelectionModes(except)
        if except ~= "click" and State.ClickSelectMode then
            State.ClickSelectMode = false
            if ClickToggle then ClickToggle:SetState(false) end
        end
        if except ~= "group" and State.GroupSelectMode then
            State.GroupSelectMode = false
            if GroupToggle then GroupToggle:SetState(false) end
        end
        if except ~= "lasso" and State.LassoMode then
            State.LassoMode     = false
            State.LassoDragging = false
            if State.LassoFrame then State.LassoFrame.Visible = false end
            if LassoToggle then LassoToggle:SetState(false) end
        end
    end

    local Notice = Tab:CreateInfoBox()
    Notice:AddText("⚠  Server Performance Notice", {
        Bold = true,
        Size = 14,
    })
    Notice:AddDivider()
    Notice:AddText(
        "You may experience delays or failures in heavily populated servers " ..
        "or on low tick-rate servers. If objects fail to move, try increasing " ..
        "the Ownership Timeout slider below.",
        {
            Size    = 13,
            Opacity = 0.80,
            Italic  = true,
            Wrap    = true,
        }
    )
    
    Tab:CreateSection("Teleportation Tools")
    ClickToggle = Tab:CreateToggle("Click Selection", false, function(val)
        State.ClickSelectMode = val
        if val then DisableOtherSelectionModes("click") end
    end)
    GroupToggle = Tab:CreateToggle("Group Selection", false, function(val)
        State.GroupSelectMode = val
        if val then DisableOtherSelectionModes("group") end
    end)
    LassoToggle = Tab:CreateToggle("Lasso Tool", false, function(val)
        State.LassoMode = val
        if val then
            DisableOtherSelectionModes("lasso")
        else
            State.LassoDragging = false
            if State.LassoFrame then State.LassoFrame.Visible = false end
        end
    end)

    local MainRow = Tab:CreateRow()
    MainRow:CreateAction("Clear Selection", "Clear", PerformClear)
    State.TpBtn = MainRow:CreateAction("Teleport Selection", "Start", function()
        task.spawn(PerformExecute)
    end)

    Tab:CreateSection("Sorting")
    local xSlider       = Tab:CreateSlider("X", 1, 40, Settings.StackX, function(val) Settings.StackX = val end)
    local ySlider       = Tab:CreateSlider("Y", 1, 20, Settings.StackY, function(val) Settings.StackY = val end)
    local zSlider       = Tab:CreateSlider("Z", 1, 40, Settings.StackZ, function(val) Settings.StackZ = val end)
    local paddingSlider = Tab:CreateSlider("Padding", 0, 1, Settings.StackPadding, function(val)
        Settings.StackPadding = val
    end, 2)

    local StackRow = Tab:CreateRow()
    State.StackStartBtn = StackRow:CreateAction("Sort Selected Objects", "Start", function()
        if State.StackMode then
            StopStackMode()
        elseif State.IsBusy then
            State.BatchCancelled = true
        else
            StartStackMode()
        end
    end)

    -- ── Button disabled-state logic ──────────────────────────────────────
    -- Defined here (after both action elements exist) and stored in State so
    -- UpdateVisuals and mode-change helpers can call it without forward-ref issues.
    --
    -- TpBtn:
    --   Disabled  → nothing selected AND not currently executing
    --   Enabled   → something selected OR currently executing (shows "Stop" to cancel)
    --
    -- StackBtn:
    --   Disabled  → selection empty or mixed types, AND not in preview/exec
    --   Enabled   → valid same-type selection, OR in stack-preview, OR executing
    --               (in both active states it must stay clickable to cancel/stop)
    local function syncButtons()
        local stackLocked = State.IsBusy or State.StackMode
    
        if State.TpBtn then
            State.TpBtn:SetDisabled(not State.IsBusy and #State.SelectedObjects == 0)
        end
    
        if State.StackStartBtn then
            local disable
            if State.IsBusy or State.StackMode then
                disable = false
            else
                local ok = AllSelectedSameType()
                disable  = not ok
            end
            State.StackStartBtn:SetDisabled(disable)
        end
    
        -- Lock all sorting sliders while preview is active or batch is running
        xSlider:SetDisabled(stackLocked)
        -- Y slider has its own disabled state from Pyramid Mode toggle;
        -- only re-enable it if pyramid mode is also off
        if not stackLocked then
            ySlider:SetDisabled(Settings.PyramidMode)
        else
            ySlider:SetDisabled(true)
        end
        zSlider:SetDisabled(stackLocked)
        paddingSlider:SetDisabled(stackLocked)
    end

    State.SyncButtons = syncButtons
    syncButtons()   -- apply correct initial state (both disabled; nothing selected yet)

    Tab:CreateSection("Settings")
    local RotRow = Tab:CreateRow()
    RotRow:CreateKeybind("Rotate (X)", Enum.KeyCode.R, function()
        if State.StackMode then
            State.ItemRotation = State.ItemRotation * CFrame.Angles(0, math.rad(90), 0)
        end
    end)
    RotRow:CreateKeybind("Rotate (Y)", Enum.KeyCode.T, function()
        if State.StackMode then
            State.ItemRotation = State.ItemRotation * CFrame.Angles(math.rad(90), 0, 0)
        end
    end)
    Tab:CreateToggle("Pyramid Sorter", false, function(val)
        Settings.PyramidMode = val
        ySlider:SetDisabled(val)
    end):AddTooltip("Stacks objects into a pyramid shape. Y layer is unused in pyramid mode.")
    Tab:CreateToggle("Keep Selection After TP", false, function(val)
        Settings.KeepSelected = val
    end)
    Tab:CreateToggle("Return To Origin After TP", true, function(val)
        Settings.ReturnToOrigin = val
    end)
    Tab:CreateToggle("Match Plank Y Size (Group Select)", true, function(val)
    Settings.MatchPlankSize = val
    end):AddTooltip("When on, group selection only picks planks within 1 stud of the target's Y size. When off, Y size is ignored.")
    Tab:CreateSlider("Ownership Timeout (s)", 1, 6, Settings.OwnershipTimeout, function(val)
        Settings.OwnershipTimeout = val
    end):AddTooltip("Max amount of seconds to attempt obtaining ownership of the object.")

    table.insert(State.Connections, UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
                    
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if State.IsBusy then return end

        if State.StackMode then
            local excludeList = {}
            if Player.Character then table.insert(excludeList, Player.Character) end
            for _, preview in ipairs(State.StackPreviewParts) do
                for _, part in ipairs(preview:GetDescendants()) do
                    if part:IsA("BasePart") then table.insert(excludeList, part) end
                end
            end
            local rayParams = RaycastParams.new()
            rayParams.FilterType                 = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = excludeList
            local unitRay = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
            local result  = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, rayParams)
            local hitPos  = result and result.Position or (unitRay.Origin + unitRay.Direction * 40)
            task.spawn(PerformStackExecute, hitPos)

        elseif State.LassoMode then
            State.LassoDragging = true
            State.LassoStartPos = UIS:GetMouseLocation()
            if State.LassoFrame then State.LassoFrame.Size = UDim2.fromOffset(0, 0) State.LassoFrame.Visible = false end

        elseif State.GroupSelectMode then
            PerformGroupSelect()

        elseif State.ClickSelectMode then
            PerformSingleSelect()
        end
    end))

    table.insert(State.Connections, UIS.InputChanged:Connect(function(input)
        if State.LassoDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateLassoFrame(UIS:GetMouseLocation())
        end
    end))

    table.insert(State.Connections, UIS.InputEnded:Connect(function(input)
        if State.LassoDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.LassoDragging = false
            if State.LassoFrame then State.LassoFrame.Visible = false end
            SelectObjectsInLassoRect(State.LassoStartPos, UIS:GetMouseLocation())
            State.LassoStartPos = nil
        end
    end))

    UpdateVisuals()
end

function LooseObjectTeleport.Unload()
    StopStackMode(true)
    for _, conn in ipairs(State.Connections) do conn:Disconnect() end
    for _, v in pairs(State.SelectionBoxes) do v:Destroy() end
    if State.LassoGui then State.LassoGui:Destroy() end
end

return LooseObjectTeleport
