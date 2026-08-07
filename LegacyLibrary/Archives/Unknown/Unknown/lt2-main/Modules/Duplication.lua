local Duplication = {}

function Duplication.Init(Tab, LOT)
    local Players           = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer       = Players.LocalPlayer

    -- ===========================
    -- REMOTES
    -- ===========================
    local ClientPlacedStructure = nil
    local ClientPlacedWire      = nil

    task.spawn(function()
        ClientPlacedStructure = ReplicatedStorage
            :WaitForChild("PlaceStructure")
            :WaitForChild("ClientPlacedStructure")
        ClientPlacedWire = ReplicatedStorage
            :WaitForChild("PlaceStructure")
            :WaitForChild("ClientPlacedWire")
    end)

    -- ===========================
    -- STATE
    -- ===========================
    local env = getgenv and getgenv() or _G
    env.DupeSource     = nil
    env.DupeTarget     = nil
    env.DupeTimeout    = 5
    env.PM_Connections = env.PM_Connections or {}
    env.DupeItems = {
        Structures = false,
        Blueprints = false,
        Furniture  = false,
        Wires      = false,
    }

    local sourceItemCounts = { Structures = 0, Furniture = 0, Wires = 0 }

    local UpdateButtonState
    local isProcessing = false
    local shouldStop   = false

    -- ===========================
    -- HELPERS
    -- ===========================
    local function GetPlayerNames()
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            table.insert(names, p.Name)
        end
        return names
    end

    local function GetPropertyModel(playerName)
        local propertiesFolder = workspace:FindFirstChild("Properties")
        if not propertiesFolder then
            warn("[Dupe] workspace.Properties not found")
            return nil
        end
        for _, propertyModel in pairs(propertiesFolder:GetChildren()) do
            local owner = propertyModel:FindFirstChild("Owner")
            if owner and owner.Value and owner.Value.Name == playerName then
                return propertyModel
            end
        end
        warn("[Dupe] No property found for: " .. playerName)
        return nil
    end

    local function GetPlotCFrame(propertyModel)
        if propertyModel.PrimaryPart then
            return propertyModel.PrimaryPart.CFrame
        end
        return propertyModel:GetPivot()
    end

    local function GetPlotSquareCount(playerName)
        local propertiesFolder = workspace:FindFirstChild("Properties")
        if not propertiesFolder then return 0 end
        for _, propertyModel in pairs(propertiesFolder:GetChildren()) do
            local owner = propertyModel:FindFirstChild("Owner")
            if owner and owner.Value and owner.Value.Name == playerName then
                local count = 0
                for _, obj in pairs(propertyModel:GetDescendants()) do
                    if obj.Name == "Square" or obj.Name == "OriginSquare" then
                        count = count + 1
                    end
                end
                return count
            end
        end
        return 0
    end

    local function GetPlayerStructures(playerName)
        local playerModels = workspace:FindFirstChild("PlayerModels")
        if not playerModels then return {} end
        local results = {}
        for _, model in pairs(playerModels:GetChildren()) do
            local typeVal = model:FindFirstChild("Type")
            if not typeVal or typeVal.Value ~= "Structure" then continue end
            if model:FindFirstChild("PurchasedBoxItemName") then continue end
            local ownerFolder = model:FindFirstChild("Owner")
            local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
            if ownerString and ownerString.Value == playerName then
                table.insert(results, model)
            end
        end
        return results
    end

    local function GetPlayerFurniture(playerName)
        local playerModels = workspace:FindFirstChild("PlayerModels")
        if not playerModels then return {} end
        local results = {}
        for _, model in pairs(playerModels:GetChildren()) do
            local typeVal = model:FindFirstChild("Type")
            if not typeVal or typeVal.Value ~= "Furniture" then continue end
            if model:FindFirstChild("PurchasedBoxItemName") then continue end
            local ownerFolder = model:FindFirstChild("Owner")
            local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
            if ownerString and ownerString.Value == playerName then
                table.insert(results, model)
            end
        end
        return results
    end

    local function GetPlayerWires(playerName)
        local playerModels = workspace:FindFirstChild("PlayerModels")
        if not playerModels then return {} end
        local results = {}
        for _, model in pairs(playerModels:GetChildren()) do
            local typeVal = model:FindFirstChild("Type")
            if not typeVal or typeVal.Value ~= "Wire" then continue end
            if model:FindFirstChild("PurchasedBoxItemName") then continue end
            local ownerFolder = model:FindFirstChild("Owner")
            local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
            if ownerString and ownerString.Value == playerName then
                table.insert(results, model)
            end
        end
        return results
    end

    local function GetStructureCFrame(model)
        return (model:FindFirstChild("MainCFrame")         and model.MainCFrame.Value)
            or (model:FindFirstChild("BuildDependentWood") and model.BuildDependentWood.CFrame)
            or (model.PrimaryPart                          and model.PrimaryPart.CFrame)
    end

    local function GetItemName(model)
        local obj = model:FindFirstChild("ItemName")
        if obj then return tostring(obj.Value) end
        return model.Name
    end

    local function RefreshSourceCounts()
        if not env.DupeSource then
            sourceItemCounts = { Structures = 0, Furniture = 0, Wires = 0 }
            return
        end
        sourceItemCounts.Structures = #GetPlayerStructures(env.DupeSource)
        sourceItemCounts.Furniture  = #GetPlayerFurniture(env.DupeSource)
        sourceItemCounts.Wires      = #GetPlayerWires(env.DupeSource)
    end

    local function AnyToggleEnabled()
        for _, v in pairs(env.DupeItems) do
            if v then return true end
        end
        return false
    end

    local function SourceHasEnabledItems()
        local map = {
            Structures = "Structures",
            Furniture  = "Furniture",
            Wires      = "Wires",
        }
        for key, countKey in pairs(map) do
            if env.DupeItems[key] and sourceItemCounts[countKey] > 0 then
                return true
            end
        end
        return false
    end

    -- ===========================
    -- EVENT-DRIVEN PLACEMENT
    -- ===========================
    local function PlaceWithConfirmation(fireFunc, matchFunc)
        local playerModels = workspace:FindFirstChild("PlayerModels")
        if not playerModels then return false end

        local success = false

        local conn = playerModels.ChildAdded:Connect(function(model)
            if success then return end
            task.wait()
            if matchFunc(model) then
                success = true
            end
        end)

        local deadline = tick() + env.DupeTimeout
        repeat
            fireFunc()
            task.wait(0.3)
        until success or tick() >= deadline or shouldStop

        conn:Disconnect()
        return success
    end

    local function MatchStructure(model, targetName, itemName)
        local typeVal = model:FindFirstChild("Type")
        if not typeVal or typeVal.Value ~= "Structure" then return false end
        if model:FindFirstChild("PurchasedBoxItemName") then return false end
        local ownerFolder = model:FindFirstChild("Owner")
        local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
        if not ownerString or ownerString.Value ~= targetName then return false end
        return GetItemName(model) == itemName
    end

    local function MatchFurniture(model, targetName, itemName)
        local typeVal = model:FindFirstChild("Type")
        if not typeVal or typeVal.Value ~= "Furniture" then return false end
        if model:FindFirstChild("PurchasedBoxItemName") then return false end
        local ownerFolder = model:FindFirstChild("Owner")
        local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
        if not ownerString or ownerString.Value ~= targetName then return false end
        return GetItemName(model) == itemName
    end

    local function MatchWire(model, targetName, itemName)
        local typeVal = model:FindFirstChild("Type")
        if not typeVal or typeVal.Value ~= "Wire" then return false end
        if model:FindFirstChild("PurchasedBoxItemName") then return false end
        local ownerFolder = model:FindFirstChild("Owner")
        local ownerString = ownerFolder and ownerFolder:FindFirstChild("OwnerString")
        if not ownerString or ownerString.Value ~= targetName then return false end
        return GetItemName(model) == itemName
    end

    -- ===========================
    -- UI — BASE DUPLICATION
    -- ===========================
    Tab:CreateSection("BASE DUPLICATION")

    local SourceDropdown = Tab:CreateDropdown(
        "Base To Duplicate:", GetPlayerNames(), "Select Owner",
        function(sel)
            env.DupeSource = sel
            RefreshSourceCounts()
            if UpdateButtonState then UpdateButtonState() end
        end
    )
    local TargetDropdown = Tab:CreateDropdown(
        "Base To Drop To:", GetPlayerNames(), "Select Target",
        function(sel)
            env.DupeTarget = sel
            if UpdateButtonState then UpdateButtonState() end
        end
    )

    local function RefreshLists()
        local names = GetPlayerNames()
        SourceDropdown:SetOptions(names)
        TargetDropdown:SetOptions(names)
    end
    table.insert(env.PM_Connections, Players.PlayerAdded:Connect(RefreshLists))
    table.insert(env.PM_Connections, Players.PlayerRemoving:Connect(RefreshLists))

    local StartButton

    StartButton = Tab:CreateAction("Duplicate", "Start", function()
        if isProcessing then
            shouldStop = true
            StartButton:SetText("Stopping...")
            StartButton:SetDisabled(true)
            return
        end

        if not ClientPlacedStructure then
            warn("[Dupe] Remotes not ready yet, please wait a moment.")
            return
        end

        isProcessing = true
        shouldStop   = false
        StartButton:SetText("Stop")

        local sourceProp = GetPropertyModel(env.DupeSource)
        local targetProp = GetPropertyModel(env.DupeTarget)

        if not sourceProp or not targetProp then
            warn("[Dupe] Could not resolve one or both plots. Aborting.")
            isProcessing = false
            StartButton:SetText("Start")
            UpdateButtonState()
            return
        end

        local sourcePlotCF = GetPlotCFrame(sourceProp)
        local targetPlotCF = GetPlotCFrame(targetProp)

        local placed, failed, timedOut = 0, 0, 0

        -- ---- STRUCTURES ----
        if env.DupeItems.Structures and not shouldStop then
            local structures = GetPlayerStructures(env.DupeSource)
            print(("[Dupe] Processing %d structures"):format(#structures))

            local jobs = {}
            for _, model in ipairs(structures) do
                local structCF = GetStructureCFrame(model)
                if not structCF then
                    warn("[Dupe] Skipping structure (no CFrame): " .. model.Name)
                    failed = failed + 1
                    continue
                end
                table.insert(jobs, {
                    model     = model,
                    targetCF  = targetPlotCF * (sourcePlotCF:Inverse() * structCF),
                    itemName  = GetItemName(model),
                    woodClass = model:FindFirstChild("BlueprintWoodClass")
                                and model.BlueprintWoodClass.Value or nil,
                })
            end

            for _, job in ipairs(jobs) do
                if shouldStop then break end
                local success = PlaceWithConfirmation(
                    function()
                        ClientPlacedStructure:FireServer(
                            job.itemName, job.targetCF, LocalPlayer, job.woodClass, job.model, true
                        )
                    end,
                    function(m) return MatchStructure(m, env.DupeTarget, job.itemName) end
                )
                if success then
                    placed = placed + 1
                    print(("[Dupe] Placed structure: %s (%d done)"):format(job.itemName, placed))
                else
                    timedOut = timedOut + 1
                    warn(("[Dupe] Timed out structure: %s"):format(job.itemName))
                end
            end
        end

        -- ---- FURNITURE ----
        if env.DupeItems.Furniture and not shouldStop then
            local furniture = GetPlayerFurniture(env.DupeSource)
            print(("[Dupe] Processing %d furniture"):format(#furniture))

            local jobs = {}
            for _, model in ipairs(furniture) do
                table.insert(jobs, {
                    model    = model,
                    targetCF = targetPlotCF * (sourcePlotCF:Inverse() * model:GetPivot()),
                    itemName = GetItemName(model),
                })
            end

            for _, job in ipairs(jobs) do
                if shouldStop then break end
                local success = PlaceWithConfirmation(
                    function()
                        ClientPlacedStructure:FireServer(
                            job.itemName, job.targetCF, LocalPlayer, false, job.model, true
                        )
                    end,
                    function(m) return MatchFurniture(m, env.DupeTarget, job.itemName) end
                )
                if success then
                    placed = placed + 1
                    print(("[Dupe] Placed furniture: %s (%d done)"):format(job.itemName, placed))
                else
                    timedOut = timedOut + 1
                    warn(("[Dupe] Timed out furniture: %s"):format(job.itemName))
                end
            end
        end

        -- ---- WIRES ----
        if env.DupeItems.Wires and not shouldStop then
            local wires = GetPlayerWires(env.DupeSource)
            print(("[Dupe] Processing %d wires"):format(#wires))

            local jobs = {}
            for _, model in ipairs(wires) do
                local wireCF = GetStructureCFrame(model)
                if not wireCF then
                    warn("[Dupe] Skipping wire (no CFrame): " .. model.Name)
                    failed = failed + 1
                    continue
                end
                table.insert(jobs, {
                    model    = model,
                    targetCF = targetPlotCF * (sourcePlotCF:Inverse() * wireCF),
                    itemName = GetItemName(model),
                })
            end

            for _, job in ipairs(jobs) do
                if shouldStop then break end
                local success = PlaceWithConfirmation(
                    function()
                        ClientPlacedWire:FireServer(
                            job.itemName, job.targetCF, LocalPlayer, job.model, true
                        )
                    end,
                    function(m) return MatchWire(m, env.DupeTarget, job.itemName) end
                )
                if success then
                    placed = placed + 1
                    print(("[Dupe] Placed wire: %s (%d done)"):format(job.itemName, placed))
                else
                    timedOut = timedOut + 1
                    warn(("[Dupe] Timed out wire: %s"):format(job.itemName))
                end
            end
        end

        if shouldStop then
            print(("[Dupe] Stopped early — placed %d, timed out %d, failed %d")
                :format(placed, timedOut, failed))
        else
            print(("[Dupe] Complete — placed %d, timed out %d, failed %d")
                :format(placed, timedOut, failed))
        end

        isProcessing = false
        shouldStop   = false
        StartButton:SetDisabled(false)
        StartButton:SetText("Start")
        UpdateButtonState()
    end)

    UpdateButtonState = function()
        if isProcessing then return end
        local plotsMatch = false
        if env.DupeSource and env.DupeTarget then
            local sourceSquares = GetPlotSquareCount(env.DupeSource)
            local targetSquares = GetPlotSquareCount(env.DupeTarget)
            plotsMatch = sourceSquares > 0
                      and targetSquares >= sourceSquares
            if not plotsMatch and env.DupeSource ~= env.DupeTarget then
                print(("[Dupe] Plot too small — %s has %d squares, %s only has %d squares")
                    :format(env.DupeSource, sourceSquares, env.DupeTarget, targetSquares))
            end
        end
        local ready = env.DupeSource ~= nil
                   and env.DupeTarget ~= nil
                   and env.DupeSource ~= env.DupeTarget
                   and AnyToggleEnabled()
                   and SourceHasEnabledItems()
                   and plotsMatch
        StartButton:SetDisabled(not ready)
    end

    StartButton:SetDisabled(true)

    -- ===========================
    -- UI — OBJECT SELECTION
    -- ===========================
    Tab:CreateSection("Object Selection")

    Tab:CreateToggle("Structures", false, function(s)
        env.DupeItems.Structures = s
        UpdateButtonState()
    end)

    local BlueprintToggle = Tab:CreateToggle("Blueprints", false, function(s)
        env.DupeItems.Blueprints = s
        UpdateButtonState()
    end)
    BlueprintToggle:SetDisabled(true)
    BlueprintToggle:AddTooltip("Blueprints are not supported yet.")

    Tab:CreateToggle("Furniture", false, function(s)
        env.DupeItems.Furniture = s
        UpdateButtonState()
    end)

    Tab:CreateToggle("Wires", false, function(s)
        env.DupeItems.Wires = s
        UpdateButtonState()
    end)

    -- ===========================
    -- UI — SETTINGS
    -- ===========================
    Tab:CreateSection("Settings")
    local Notice = Tab:CreateInfoBox()
    Notice:AddText("⚠ PLEASE READ!", {
        Bold = true,
        Size = 14,
    })
    Notice:AddDivider()
    Notice:AddText(
        "This is in its early developement phase and doesnt currently 'dupe' anything. " ..
        "It will only move the objects from one plot to another. Im currently working " ..
        "on some methods to improve this process.",
        {
            Size    = 13,
            Opacity = 0.80,
            Italic  = true,
            Wrap    = true,
        }
    )
    Tab:CreateSlider("Place Timeout (s)", 1, 10, 3, function(val)
        env.DupeTimeout = val
    end)
end

return Duplication
