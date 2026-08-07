return function(UI, Config, Utils)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local localPlayer = Players.LocalPlayer
    local tab = UI:Tab("Home", "6026568198", {
        id = "home",
        displayName = "Home"
    })

    if type(tab.Canvas) ~= "function" then
        local fallback = tab:Section("VanguardHub", true)
        fallback:Label("Home dashboard indisponivel nesta versao da library.", {
            NoPadding = true,
            Height = 34,
            Color = UI.Theme.Warning
        })
        return
    end

    local canvas = tab:Canvas(500)
    local connections = {}

    local HUB_VERSION = rawget(_G, "VanguardHubVersion") or "v2.5.0"

    local function connect(object, eventName, callback)
        local connection = object[eventName]:Connect(callback)
        table.insert(connections, connection)
        return connection
    end

    local function create(className, properties)
        local object = Instance.new(className)
        for property, value in pairs(properties or {}) do
            if property ~= "Parent" then
                object[property] = value
            end
        end
        object.Parent = properties.Parent
        return object
    end

    local function round(object, radius)
        create("UICorner", {
            Parent = object,
            CornerRadius = UDim.new(0, radius or 10)
        })
    end

    local function stroke(object, color, thickness, transparency)
        return create("UIStroke", {
            Parent = object,
            Color = color or UI.Theme.CardBorder,
            Thickness = thickness or 1,
            Transparency = transparency or 0.88
        })
    end

    local function bindTheme(object, property, key)
        if type(UI.BindTheme) == "function" then
            UI:BindTheme(object, property, key)
        end
        return object
    end

    local function makeCard(name, x, y, width, height, transparency)
        local card = create("Frame", {
            Name = name,
            Parent = canvas,
            BackgroundColor3 = UI.Theme.Secondary,
            BackgroundTransparency = transparency or 0.06,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            ClipsDescendants = true
        })
        round(card, 12)
        stroke(card, UI.Theme.CardBorder, 1, 0.88)

        local origBg = card.BackgroundTransparency
        connect(card, "MouseEnter", function()
            TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = origBg - 0.02
            }):Play()
        end)
        connect(card, "MouseLeave", function()
            TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = origBg
            }):Play()
        end)

        return card
    end

    local function makeSectionTitle(parent, text)
        local container = create("Frame", {
            Parent = parent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 0, 28)
        })

        create("TextLabel", {
            Parent = container,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(20, 6),
            Size = UDim2.new(1, -40, 0, 16),
            Text = text,
            TextColor3 = UI.Theme.TextDim,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        return container
    end

    local function makeToggle(parent, y, text, flag, default, callback)
        local row = create("TextButton", {
            Parent = parent,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 24),
            Text = ""
        })

        create("TextLabel", {
            Parent = row,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -46, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local track = create("Frame", {
            Parent = row,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -30, 0.5, -6),
            Size = UDim2.fromOffset(28, 12)
        })
        round(track, 6)

        local knob = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Text,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(1, 1),
            Size = UDim2.fromOffset(10, 10)
        })
        round(knob, 5)

        local state = default == true
        local sharedControl

        local function render(animate)
            local targetColor = state and UI.Theme.Accent or UI.Theme.Tertiary
            local targetPos = state and UDim2.fromOffset(17, 1) or UDim2.fromOffset(1, 1)
            local targetKnob = state and UI.Theme.Accent or UI.Theme.Text

            if animate then
                TweenService:Create(track, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundColor3 = targetColor
                }):Play()
                TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = targetPos,
                    BackgroundColor3 = targetKnob
                }):Play()
            else
                track.BackgroundColor3 = targetColor
                knob.Position = targetPos
                knob.BackgroundColor3 = targetKnob
            end
        end

        local function apply(newState, runCallback, skipBroadcast)
            state = newState == true
            render(true)
            if type(UI.SetFlag) == "function" then UI:SetFlag(flag, state) end
            if runCallback and callback then task.spawn(callback, state) end
            if not skipBroadcast and type(UI.BroadcastFlag) == "function" then
                UI:BroadcastFlag(flag, state, sharedControl, runCallback)
            end
        end

        if type(UI.RegisterFlagControl) == "function" then
            sharedControl = UI:RegisterFlagControl(flag, function(value, triggerCallback)
                apply(value, triggerCallback, true)
            end)
        end

        render(false)
        if type(UI.SetFlag) == "function" then UI:SetFlag(flag, state) end

        connect(row, "MouseButton1Click", function()
            apply(not state, true, false)
        end)
    end

    local function makeSlider(parent, y, text, flag, default, min, max, callback)
        local container = create("Frame", {
            Parent = parent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 24)
        })

        create("TextLabel", {
            Parent = container,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(72, 24),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local track = create("Frame", {
            Parent = container,
            Active = true,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(78, 11),
            Size = UDim2.new(1, -120, 0, 2)
        })
        round(track, 1)

        local fill = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0)
        })
        round(fill, 1)
        bindTheme(fill, "BackgroundColor3", "Accent")

        local knob = create("Frame", {
            Parent = track,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(9, 9)
        })
        round(knob, 5)
        bindTheme(knob, "BackgroundColor3", "Accent")

        local valueLabel = create("TextLabel", {
            Parent = container,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.new(1, -38, 0, 0),
            Size = UDim2.fromOffset(38, 24),
            Text = tostring(default),
            TextColor3 = UI.Theme.Accent,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        bindTheme(valueLabel, "TextColor3", "Accent")

        local value = math.clamp(tonumber(default) or min, min, max)
        local dragging = false
        local sharedControl

        local function setValue(newValue, runCallback, skipBroadcast)
            value = math.clamp(math.floor((tonumber(newValue) or min) + 0.5), min, max)
            local pct = (value - min) / math.max(1, max - min)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            valueLabel.Text = tostring(value)
            if type(UI.SetFlag) == "function" then UI:SetFlag(flag, value) end
            if runCallback and callback then task.spawn(callback, value) end
            if not skipBroadcast and type(UI.BroadcastFlag) == "function" then
                UI:BroadcastFlag(flag, value, sharedControl, runCallback)
            end
        end

        local function setFromX(x)
            if track.AbsoluteSize.X <= 0 then return end
            local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setValue(min + ((max - min) * pct), true, false)
        end

        if type(UI.RegisterFlagControl) == "function" then
            sharedControl = UI:RegisterFlagControl(flag, function(sv, tc)
                setValue(sv, tc, true)
            end)
        end

        setValue(value, false, true)

        connect(track, "InputBegan", function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(input.Position.X)
            end
        end)
        connect(UserInputService, "InputChanged", function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setFromX(input.Position.X)
            end
        end)
        connect(UserInputService, "InputEnded", function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local function getExecutorName()
        local name = "Unknown"
        pcall(function()
            if type(identifyexecutor) == "function" then
                local d = identifyexecutor()
                if type(d) == "string" and d ~= "" then name = d end
            end
        end)
        return name
    end

    local executorName = getExecutorName()

    -- ==================== PROFILE ====================
    local profile = makeCard("Profile", 0, 10, 500, 108, 0.04)

    local avatarContainer = create("Frame", {
        Parent = profile,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(24, 18),
        Size = UDim2.fromOffset(72, 72)
    })

    local avatarRing = create("Frame", {
        Parent = avatarContainer,
        BackgroundColor3 = UI.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(-3, -3),
        Size = UDim2.fromOffset(78, 78),
        BackgroundTransparency = 0.12
    })
    round(avatarRing, 39)
    bindTheme(avatarRing, "BackgroundColor3", "Accent")

    local avatarImage = create("ImageLabel", {
        Parent = avatarContainer,
        BackgroundColor3 = UI.Theme.Tertiary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(68, 68),
        Image = Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    })
    round(avatarImage, 34)

    create("TextLabel", {
        Parent = profile,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(114, 22),
        Size = UDim2.fromOffset(268, 30),
        Text = localPlayer and localPlayer.Name or "VanguardHub",
        TextColor3 = UI.Theme.Text,
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local statusPill = create("Frame", {
        Parent = profile,
        BackgroundColor3 = Color3.fromRGB(67, 190, 39),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(114, 58),
        Size = UDim2.fromOffset(90, 20)
    })
    round(statusPill, 10)

    local statusDot = create("Frame", {
        Parent = statusPill,
        BackgroundColor3 = Color3.fromRGB(67, 190, 39),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(8, 6),
        Size = UDim2.fromOffset(8, 8)
    })
    round(statusDot, 4)

    create("TextLabel", {
        Parent = statusPill,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(20, 0),
        Size = UDim2.fromOffset(64, 20),
        Text = "CONNECTED",
        TextColor3 = Color3.fromRGB(67, 190, 39),
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local execBadge = create("Frame", {
        Parent = profile,
        BackgroundColor3 = UI.Theme.Accent,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -108, 0, 22),
        Size = UDim2.fromOffset(88, 20)
    })
    round(execBadge, 7)
    stroke(execBadge, UI.Theme.Accent, 1, 0.65)
    bindTheme(execBadge, "BackgroundColor3", "Accent")

    create("TextLabel", {
        Parent = execBadge,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromOffset(88, 20),
        Text = executorName,
        TextColor3 = UI.Theme.Accent,
        TextSize = 9,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local execOrig = execBadge.BackgroundTransparency
    connect(execBadge, "MouseEnter", function()
        TweenService:Create(execBadge, TweenInfo.new(0.2), {BackgroundTransparency = execOrig - 0.08}):Play()
    end)
    connect(execBadge, "MouseLeave", function()
        TweenService:Create(execBadge, TweenInfo.new(0.2), {BackgroundTransparency = execOrig}):Play()
    end)

    -- ==================== INFORMATION ====================
    local information = makeCard("Information", 0, 130, 300, 152, 0.07)

    makeSectionTitle(information, "INFORMATION")

    local infoRows = {
        {label = "USER", value = localPlayer and localPlayer.Name or "VanguardHub"},
        {label = "GAME", value = "Lumber Tycoon 2"},
        {label = "EXECUTOR", value = executorName},
        {label = "VERSION", value = HUB_VERSION}
    }

    for index, row in ipairs(infoRows) do
        local y = 30 + (index - 1) * 28

        create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(20, y),
            Size = UDim2.fromOffset(60, 12),
            Text = row.label,
            TextColor3 = UI.Theme.TextDim,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local vl = create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(20, y + 14),
            Size = UDim2.fromOffset(260, 14),
            Text = row.value,
            TextColor3 = UI.Theme.Accent,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        bindTheme(vl, "TextColor3", "Accent")
    end

    -- ==================== QUICK ACTIONS ====================
    local quickActions = makeCard("QuickActions", 314, 130, 186, 152, 0.07)

    makeSectionTitle(quickActions, "QUICK ACTIONS")

    makeToggle(quickActions, 30, "Noclip", "Noclip", Config.Noclip == true, function(v)
        Config.Noclip = v
    end)
    makeToggle(quickActions, 56, "Fly", "Flight", Config.Flight == true, function(v)
        Config.Flight = v
    end)
    makeToggle(quickActions, 82, "Auto Save", "AutoSave", Config.AutoSave ~= false, function(v)
        Config.AutoSave = v
    end)

    -- ==================== QUICK SETTINGS ====================
    local quickSettings = makeCard("QuickSettings", 0, 294, 500, 152, 0.07)

    makeSectionTitle(quickSettings, "QUICK SETTINGS")

    makeSlider(quickSettings, 32, "WalkSpeed", "WalkSpeed", Config.WalkSpeed or 120, 16, 1000, function(v)
        Config.WalkSpeed = v
        local c = localPlayer and localPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end)

    makeSlider(quickSettings, 60, "JumpPower", "JumpPower", Config.JumpPower or 250, 50, 1000, function(v)
        Config.JumpPower = v
        local c = localPlayer and localPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = true; h.JumpPower = v end
    end)

    makeSlider(quickSettings, 88, "FOV", "FOV", Config.FOV or 90, 1, 120, function(v)
        Config.FOV = v
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
    end)

    -- ==================== CLEANUP ====================
    return function()
        for _, c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(connections)
    end
end