-- HoverValue.lua
-- Displays estimated value as a floating BillboardGui above the hovered tree or plank.
-- Never touches any existing UI text.

local HoverValue = {}

function HoverValue.Init(Tab, Library)
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local CoreGui    = game:GetService("CoreGui")

    local LocalPlayer = Players.LocalPlayer
    local Mouse       = LocalPlayer:GetMouse()

    -- ================================================================
    -- DYNXE THEME
    -- ================================================================
    local ACCENT   = Color3.fromRGB(74,  120, 255)
    local BG       = Color3.fromRGB(18,  18,  22)
    local SURFACE  = Color3.fromRGB(24,  24,  29)
    local STROKE   = Color3.fromRGB(40,  40,  48)
    local TEXT     = Color3.fromRGB(220, 220, 220)
    local MUTED    = Color3.fromRGB(120, 120, 130)

    -- ================================================================
    -- TREE VALUE RATES  (per cubic stud of WoodSection volume)
    -- Edit these to match your server's prices.
    -- ================================================================
    local TREE_RATES = {
        Generic       = 1.5,
        Cherry        = 1.3,
        Birch         = 2.25,
        Oak           = 0.75,
        Walnut        = 1.2,
        Koa           = 2.8,
        Pine          = 3.2,
        Palm          = 2.9,
        Fir           = 3.2,
        Volcano       = 3.5,
        Frost         = 9.0,
        GreenSwampy   = 4.4,
        GoldSwampy    = 5.7,
        SnowGlow      = 1.5,
        CaveCrawler   = 8.0,
        LoneCave      = 150.0,
        BlueSpruce    = 20.0,
        Spook         = 19.0,
        SpookNeon     = 25.0,
    }
    local PLANK_RATES = {
        Generic       = 10,
        Cherry        = 10.5,
        Birch         = 15,
        Oak           = 6,
        Walnut        = 11,
        Koa           = 26.4,
        Pine          = 18,
        Palm          = 32,
        Fir           = 18,
        Volcano       = 28,
        Frost         = 106.0,
        GreenSwampy   = 30.0,
        GoldSwampy    = 36.0,
        SnowGlow      = 10,
        CaveCrawler   = 36.0,
        LoneCave      = 420.0,
        BlueSpruce    = 40.0,
        Spook         = 54.0,
        SpookNeon     = 90.0,
    }
    local PLANK_RATE_DEFAULT = 1.0
    local TREE_RATE_DEFAULT  = 1.0

    -- ================================================================
    -- BILLBOARD MANAGEMENT
    -- One billboard at a time, destroyed and recreated only when the
    -- hovered model actually changes (not every frame).
    -- ================================================================
    local currentBillboard = nil
    local lastModel        = nil

    local function DestroyBillboard()
        if currentBillboard and currentBillboard.Parent then
            currentBillboard:Destroy()
        end
        currentBillboard = nil
        lastModel        = nil
    end

    local function CreateBillboard(adornPart, heightOffset, valueText, labelText)
        if currentBillboard then
            currentBillboard:Destroy()
            currentBillboard = nil
        end

        local bb = Instance.new("BillboardGui")
        bb.Name              = "DynxeHoverValue"
        bb.Size              = UDim2.new(0, 190, 0, 52)
        bb.StudsOffset       = Vector3.new(0, heightOffset, 0)
        bb.AlwaysOnTop       = true
        bb.MaxDistance       = 800
        bb.Adornee           = adornPart
        bb.Parent            = CoreGui

        -- Card background
        local bg = Instance.new("Frame")
        bg.Size                   = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3       = BG
        bg.BackgroundTransparency = 0.12
        bg.BorderSizePixel        = 0
        bg.Parent                 = bb
        local bgCorner = Instance.new("UICorner", bg)
        bgCorner.CornerRadius = UDim.new(0, 6)
        local bgStroke = Instance.new("UIStroke", bg)
        bgStroke.Color           = STROKE
        bgStroke.Thickness       = 1
        bgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- Accent top bar — sits inside bg, squared bottom corners clipped by bg's UICorner
        local topBar = Instance.new("Frame")
        topBar.Size             = UDim2.new(1, 0, 0, 3)
        topBar.Position         = UDim2.new(0, 0, 0, 0)
        topBar.BackgroundColor3 = ACCENT
        topBar.BorderSizePixel  = 0
        topBar.ZIndex           = 3
        topBar.Parent           = bg

        -- Value label (large, accent coloured)
        local valueLbl = Instance.new("TextLabel")
        valueLbl.Size                   = UDim2.new(1, -12, 0, 26)
        valueLbl.Position               = UDim2.new(0, 6, 0, 4)
        valueLbl.BackgroundTransparency = 1
        valueLbl.Text                   = valueText
        valueLbl.TextColor3             = ACCENT
        valueLbl.Font                   = Enum.Font.GothamBold
        valueLbl.TextSize               = 20
        valueLbl.TextXAlignment         = Enum.TextXAlignment.Center
        valueLbl.ZIndex                 = 4
        valueLbl.Parent                 = bg

        -- Sub-label (tree class / plank type, muted)
        local subLbl = Instance.new("TextLabel")
        subLbl.Size                   = UDim2.new(1, -12, 0, 16)
        subLbl.Position               = UDim2.new(0, 6, 0, 32)
        subLbl.BackgroundTransparency = 1
        subLbl.Text                   = labelText
        subLbl.TextColor3             = MUTED
        subLbl.Font                   = Enum.Font.Gotham
        subLbl.TextSize               = 12
        subLbl.TextXAlignment         = Enum.TextXAlignment.Center
        subLbl.ZIndex                 = 4
        subLbl.Parent                 = bg

        currentBillboard = bb
    end

    -- ================================================================
    -- VOLUME & VALUE HELPERS
    -- ================================================================
    local function GetWoodVolume(model)
        local total = 0
        for _, part in ipairs(model:GetChildren()) do
            if part.Name == "WoodSection" and part:IsA("BasePart") then
                total += part.Size.X * part.Size.Y * part.Size.Z
            end
        end
        return total
    end

    local function FormatMoney(n)
        local s      = tostring(math.floor(n + 0.5))
        local result = ""
        local len    = #s
        for i = 1, len do
            if i > 1 and (len - i + 1) % 3 == 0 then result ..= "," end
            result ..= s:sub(i, i)
        end
        return "$" .. result
    end

    -- Returns adornPart, heightOffset, valueText, subText — or nil if not applicable.
    local function EvaluateModel(model)
        if not model or not model.Parent then return nil end
    
        local parent = model.Parent
        if not parent then return nil end
    
        local mainPart = model:FindFirstChild("Main") or model:FindFirstChildWhichIsA("BasePart")
        if not mainPart then return nil end
    
        -- Anchor to the bounding box top so it sits just above the model
        -- regardless of how tall it is, using a fixed 3-stud gap.
        local bbCF, bbSize = model:GetBoundingBox()
        local topY         = bbCF.Position.Y + bbSize.Y * 0.5
        local partY        = mainPart.Position.Y
        local heightOffset = math.clamp((topY - partY) + 3, 3, 12)
    
        -- ── Tree ────────────────────────────────────────────────────
        if parent.Name:lower():match("treeregion") then
            local tc   = model:FindFirstChild("TreeClass")
            local cls  = tc and tc.Value or "Unknown"
            local rate = TREE_RATES[cls] or TREE_RATE_DEFAULT
            local vol  = GetWoodVolume(model)
            if vol <= 0 then return nil end
            return mainPart, heightOffset, FormatMoney(vol * rate), cls .. "  ·  Tree"
        end
    
        -- ── Cut plank / log in PlayerModels ─────────────────────────
        if parent.Name == "PlayerModels" then
            local vol = GetWoodVolume(model)
            if vol <= 0 then return nil end
            local tc   = model:FindFirstChild("TreeClass")
            local cls  = tc and tc.Value or nil
            local rate = (cls and PLANK_RATES[cls]) or PLANK_RATE_DEFAULT
            local sub  = (cls or "Unknown") .. "  ·  Plank"
            return mainPart, heightOffset, FormatMoney(vol * rate), sub
        end

        -- ── Chopped log in LogModels ─────────────────────────────────
        if parent.Name == "LogModels" then
            local vol = GetWoodVolume(model)
            if vol <= 0 then return nil end
            local tc   = model:FindFirstChild("TreeClass")
            local cls  = tc and tc.Value or nil
            local rate = (cls and TREE_RATES[cls]) or TREE_RATE_DEFAULT
            local sub  = (cls or "Unknown") .. "  ·  Log"
            return mainPart, heightOffset, FormatMoney(vol * rate), sub
        end

        return nil
    end

    -- ================================================================
    -- TOGGLE
    -- ================================================================
    local hoverConn = nil

    local function Enable()
        if hoverConn then hoverConn:Disconnect() end

        hoverConn = RunService.RenderStepped:Connect(function()
            local target = Mouse.Target
            local model  = target and target:FindFirstAncestorOfClass("Model")

            -- Only rebuild the billboard when the hovered model actually changes
            if model == lastModel then return end
            lastModel = model

            if not model then
                DestroyBillboard()
                return
            end

            local adornPart, heightOffset, valueText, subText = EvaluateModel(model)
            if adornPart then
                CreateBillboard(adornPart, heightOffset, valueText, subText)
            else
                DestroyBillboard()
            end
        end)
    end

    local function Disable()
        if hoverConn then hoverConn:Disconnect(); hoverConn = nil end
        DestroyBillboard()
    end

    Tab:CreateToggle("Hover Value Display", false, function(on)
        if on then Enable() else Disable() end
    end):AddTooltip("Hover over any tree or plank to see its estimated value floating above it.")
end

return HoverValue
