-- WireArt.lua Module
local WireArt = {}

function WireArt.Init(Tab, Library)
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local UserInputService  = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService      = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer
    local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Mouse       = LocalPlayer:GetMouse()

    -- ================================================================
    --  STATE
    -- ================================================================
    local Settings  = { Scale = 6, Spacing = 5 }
    local PlaceMode = false
    local Placing   = false

    local PreviewModel    = Instance.new("Model")
    PreviewModel.Name     = "WireArtPreview"
    PreviewModel.Parent   = workspace

    -- ================================================================
    --  WIRE HELPERS
    -- ================================================================
    local function GetOwnedBoxedWires()
        local wires = {}
        local pm    = workspace:FindFirstChild("PlayerModels")
        if not pm then
            Library:Notify("Wire Art", "PlayerModels not found!", 3)
            return wires
        end
        for _, model in pairs(pm:GetChildren()) do
            local typeVal   = model:FindFirstChild("Type")
            local owner     = model:FindFirstChild("Owner")
            local ownerStr  = owner and owner:FindFirstChild("OwnerString")
            local boxedName = model:FindFirstChild("PurchasedBoxItemName")
            if typeVal   and typeVal.Value  == "Wire"
            and ownerStr and ownerStr.Value == LocalPlayer.Name
            and boxedName then
                table.insert(wires, model)
            end
        end
        Library:Notify("Wire Art", "Found " .. #wires .. " boxed wires!", 3)
        return wires
    end

    local function GetWireInfo(wireObj)
        local itemName = wireObj:FindFirstChild("ItemName")
                      or wireObj:FindFirstChild("PurchasedBoxItemName")
        if not itemName then return nil end
        local ClientItemInfo = ReplicatedStorage:FindFirstChild("ClientItemInfo")
        return ClientItemInfo and ClientItemInfo:FindFirstChild(itemName.Value, true)
    end

    -- ================================================================
    --  LETTER DEFINITIONS
    -- ================================================================
    local function GetLetterPoints(letter, origin)
        local s  = Settings.Scale
        local t  = s
        local m  = s * 0.5
        local b  = 0
        local l  = -s * 0.4
        local r  =  s * 0.4
        local c  =  0
        local v3 = Vector3.new

        local function o(...)
            local result = {}
            for _, v in ipairs({...}) do table.insert(result, origin + v) end
            return result
        end

        local map = {
            A = o(v3(l,b,0), v3(c,t,0), v3(r,b,0), v3(c*0.5+r*0.5,m,0), v3(c*0.5+l*0.5,m,0)),
            B = o(v3(l,b,0), v3(l,t,0), v3(r*0.6,t,0), v3(r,t*0.75,0), v3(r*0.6,m,0), v3(l,m,0), v3(r*0.6,m,0), v3(r,m*0.4,0), v3(r*0.6,b,0), v3(l,b,0)),
            C = o(v3(r,t,0), v3(l,t,0), v3(l,b,0), v3(r,b,0)),
            D = o(v3(l,t,0), v3(l,b,0), v3(r,b+m*0.3,0), v3(r,t-m*0.3,0), v3(l,t,0)),
            E = o(v3(r,t,0), v3(l,t,0), v3(l,b,0), v3(r,b,0), v3(l,b,0), v3(l,m,0), v3(r*0.7,m,0)),
            F = o(v3(l,b,0), v3(l,t,0), v3(r,t,0), v3(l,t,0), v3(l,m,0), v3(r*0.7,m,0)),
            G = o(v3(r,t,0), v3(l,t,0), v3(l,b,0), v3(r,b,0), v3(r,m,0), v3(c,m,0)),
            H = o(v3(l,t,0), v3(l,b,0), v3(l,m,0), v3(r,m,0), v3(r,t,0), v3(r,b,0)),
            I = o(v3(l,t,0), v3(r,t,0), v3(c,t,0), v3(c,b,0), v3(l,b,0), v3(r,b,0)),
            J = o(v3(l,t,0), v3(r,t,0), v3(c,t,0), v3(c,b+m*0.2,0), v3(l*0.7,b,0), v3(l,b+m*0.2,0)),
            K = o(v3(l,t,0), v3(l,b,0), v3(l,m,0), v3(r,t,0), v3(l,m,0), v3(r,b,0)),
            L = o(v3(l,t,0), v3(l,b,0), v3(r,b,0)),
            M = o(v3(l,b,0), v3(l,t,0), v3(c,m,0), v3(r,t,0), v3(r,b,0)),
            N = o(v3(l,b,0), v3(l,t,0), v3(r,b,0), v3(r,t,0)),
            O = o(v3(l,t,0), v3(r,t,0), v3(r,b,0), v3(l,b,0), v3(l,t,0)),
            P = o(v3(l,b,0), v3(l,t,0), v3(r,t,0), v3(r,m,0), v3(l,m,0)),
            Q = o(v3(l,t,0), v3(r,t,0), v3(r,b,0), v3(l,b,0), v3(l,t,0), v3(r,t,0), v3(r,b,0), v3(r*0.4,b+m*0.4,0)),
            R = o(v3(l,b,0), v3(l,t,0), v3(r,t,0), v3(r,m,0), v3(l,m,0), v3(r,b,0)),
            S = o(v3(r,t,0), v3(l,t,0), v3(l,m,0), v3(r,m,0), v3(r,b,0), v3(l,b,0)),
            T = o(v3(l,t,0), v3(r,t,0), v3(c,t,0), v3(c,b,0)),
            U = o(v3(l,t,0), v3(l,b,0), v3(r,b,0), v3(r,t,0)),
            V = o(v3(l,t,0), v3(c,b,0), v3(r,t,0)),
            W = o(v3(l,t,0), v3(l*0.5,b,0), v3(c,m,0), v3(r*0.5,b,0), v3(r,t,0)),
            X = o(v3(l,t,0), v3(r,b,0), v3(c,m,0), v3(l,b,0), v3(r,t,0)),
            Y = o(v3(l,t,0), v3(c,m,0), v3(r,t,0), v3(c,m,0), v3(c,b,0)),
            Z = o(v3(l,t,0), v3(r,t,0), v3(l,b,0), v3(r,b,0)),
        }

        return map[letter:upper()]
    end

    -- ================================================================
    --  PREVIEW
    -- ================================================================
    local function ClearPreview()
        for _, v in pairs(PreviewModel:GetChildren()) do v:Destroy() end
    end

    local function DrawPreviewLine(a, b)
        local dist = (b - a).Magnitude
        if dist < 0.01 then return end
        local part      = Instance.new("Part")
        part.Anchored   = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material   = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Cyan")
        part.Size       = Vector3.new(0.15, 0.15, dist)
        part.CFrame     = CFrame.new((a + b) / 2, b)
        part.Parent     = PreviewModel
    end

    local function DrawPreviewBall(pos)
        local part      = Instance.new("Part")
        part.Anchored   = true
        part.CanCollide = false
        part.Shape      = Enum.PartType.Ball
        part.Material   = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Cyan")
        part.Size       = Vector3.new(0.3, 0.3, 0.3)
        part.CFrame     = CFrame.new(pos)
        part.Parent     = PreviewModel
    end

    local function DrawLetterPreview(points)
        for i, point in ipairs(points) do
            if i < #points then DrawPreviewLine(point, points[i + 1]) end
            if i > 1 and i < #points then DrawPreviewBall(point) end
        end
    end

    local function UpdatePreview(origin, word)
        ClearPreview()
        if not word or word == "" then return end
        local posIndex = 0
        for i = 1, #word do
            local ch = word:sub(i, i)
            if ch ~= " " then
                local letterOrigin = origin + Vector3.new(posIndex * Settings.Spacing, 0, 0)
                local points = GetLetterPoints(ch, letterOrigin)
                if points then DrawLetterPreview(points) end
            end
            posIndex = posIndex + 1
        end
    end

    -- ================================================================
    --  RAYCAST
    -- ================================================================
    local RayParams      = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Exclude

    local function GetCursorWorldPos()
        RayParams.FilterDescendantsInstances = {PreviewModel, Character}
        local unitRay = workspace.CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local result  = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, RayParams)
        if result then return result.Position end
        local t = -unitRay.Origin.Y / unitRay.Direction.Y
        if t and t > 0 then return unitRay.Origin + unitRay.Direction * t end
        return unitRay.Origin + unitRay.Direction * 50
    end

    -- ================================================================
    --  PLACE LOGIC
    -- ================================================================
    local function FireWire(wireObj, points, Info)
        DrawLetterPreview(points)
        local attempts = 0
        repeat
            ReplicatedStorage.PlaceStructure.ClientPlacedWire:FireServer(
                Info, points, LocalPlayer, wireObj, true
            )
            task.wait(0.3)
            attempts = attempts + 1
        until wireObj.Parent == nil or attempts >= 10
        ClearPreview()
        task.wait(0.2)
    end

    local currentWord    = ""
    local ActionElement  = nil
    local PreviewActive  = false

    local function StopPlacing()
        PlaceMode      = false
        Placing        = false
        PreviewActive  = false
        ClearPreview()
        if ActionElement then
            ActionElement:SetText("Start")
            ActionElement:SetDisabled(false)
        end
    end

    local function StartPlacing()
        local word = currentWord:upper():gsub("[^A-Z ]", "")
        if word:gsub(" ", "") == "" then
            Library:Notify("Wire Art", "Enter a word first!", 3)
            return
        end

        local wires  = GetOwnedBoxedWires()
        local needed = 0
        for i = 1, #word do
            if word:sub(i,i) ~= " " then needed = needed + 1 end
        end

        if #wires < needed then
            Library:Notify("Wire Art", "Need " .. needed .. " boxed wires, found " .. #wires .. "!", 3)
            return
        end

        PlaceMode     = true
        PreviewActive = true
        Library:Notify("Wire Art", "Preview active — left-click to place!", 3)
        if ActionElement then
            ActionElement:SetText("Cancel")
        end
    end

    -- ================================================================
    --  UI ELEMENTS
    -- ================================================================
    Tab:CreateSection("Wire Art")

    -- Scale slider
    local ScaleSlider = Tab:CreateSlider("Scale", 2, 10, Settings.Scale, function(val)
        Settings.Scale = val
    end)

    -- Spacing slider
    local SpacingSlider = Tab:CreateSlider("Spacing", 1, 10, Settings.Spacing, function(val)
        Settings.Spacing = val
    end)

    -- Word input
    local WordInput = Tab:CreateInput("Text Field", "enter...", function(text)
        -- strip non-alpha/space, uppercase, clamp to 26
        text = text:upper():gsub("[^A-Z ]", "")
        if #text > 26 then text = text:sub(1, 26) end
        currentWord = text
        WordInput:SetText(text)
    end)

    -- Preview & Place action
    ActionElement = Tab:CreateAction("Wire Art", "Start", function()
        if PlaceMode then
            StopPlacing()
        else
            StartPlacing()
        end
    end)

    -- ================================================================
    --  CLICK TO CONFIRM PLACEMENT
    -- ================================================================
    Mouse.Button1Down:Connect(function()
        if not PlaceMode or Placing then return end

        Placing   = true
        PlaceMode = false
        PreviewActive = false
        ClearPreview()

        if ActionElement then
            ActionElement:SetText("Placing...")
            ActionElement:SetDisabled(true)
        end

        local origin = GetCursorWorldPos()
        local word   = currentWord:upper():gsub("[^A-Z ]", "")
        local wires  = GetOwnedBoxedWires()

        task.spawn(function()
            local wireIndex = 1
            local posIndex  = 0

            for i = 1, #word do
                local ch = word:sub(i, i)
                if ch == " " then
                    posIndex = posIndex + 1
                    continue
                end

                local wireObj = wires[wireIndex]
                if not wireObj then
                    Library:Notify("Wire Art", "Ran out of wires at letter " .. i .. "!", 3)
                    break
                end

                local Info = GetWireInfo(wireObj)
                if not Info then
                    wireIndex = wireIndex + 1
                    posIndex  = posIndex + 1
                    continue
                end

                local letterOrigin = origin + Vector3.new(posIndex * Settings.Spacing, 0, 0)
                local points       = GetLetterPoints(ch, letterOrigin)

                if not points then
                    wireIndex = wireIndex + 1
                    posIndex  = posIndex + 1
                    continue
                end

                FireWire(wireObj, points, Info)
                wireIndex = wireIndex + 1
                posIndex  = posIndex + 1
            end

            Library:Notify("Wire Art", "Placed '" .. word .. "'!", 4)
            StopPlacing()
        end)
    end)

    -- ================================================================
    --  RENDER LOOP — live preview while PlaceMode
    -- ================================================================
    RunService.RenderStepped:Connect(function()
        if PreviewActive and PlaceMode and not Placing then
            UpdatePreview(GetCursorWorldPos(), currentWord:upper())
        elseif not Placing then
            ClearPreview()
        end
    end)

    -- cleanup on character respawn
    LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        StopPlacing()
    end)
end

return WireArt
