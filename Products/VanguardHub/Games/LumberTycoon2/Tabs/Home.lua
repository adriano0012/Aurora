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

    local canvas = tab:Canvas(420)
    local connections = {}

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
            CornerRadius = UDim.new(0, radius or 8)
        })
    end

    local function stroke(object, transparency)
        return create("UIStroke", {
            Parent = object,
            Color = UI.Theme.CardBorder,
            Thickness = 1,
            Transparency = transparency or 0.12
        })
    end

    local function bindTheme(object, property, key)
        if type(UI.BindTheme) == "function" then
            UI:BindTheme(object, property, key)
        end
        return object
    end

    local function notify(title, message)
        if Utils and type(Utils.Notify) == "function" then
            Utils.Notify(title, message, 3)
        end
    end

    local function makeCard(name, x, y, width, height, transparency)
        local card = create("Frame", {
            Name = name,
            Parent = canvas,
            BackgroundColor3 = UI.Theme.Secondary,
            BackgroundTransparency = transparency or 0.04,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height)
        })
        round(card, 10)
        stroke(card)
        return card
    end

    local function makeTitle(parent, text)
        local label = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(18, 10),
            Size = UDim2.new(1, -36, 0, 22),
            Text = text,
            TextColor3 = UI.Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        bindTheme(label, "TextColor3", "Accent")
        return label
    end

    local function makeActionButton(parent, text, icon, iconColor, x, y, width, height, callback)
        local button = create("TextButton", {
            Parent = parent,
            AutoButtonColor = false,
            BackgroundColor3 = UI.Theme.Glass,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            Text = ""
        })
        round(button, 7)
        stroke(button, 0.24)

        create("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.fromOffset(22, height),
            Text = icon,
            TextColor3 = iconColor,
            TextSize = 14
        })
        create("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(32, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        connect(button, "MouseEnter", function()
            TweenService:Create(
                button,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = UI.Theme.Hover}
            ):Play()
        end)
        connect(button, "MouseLeave", function()
            TweenService:Create(
                button,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = UI.Theme.Glass}
            ):Play()
        end)
        connect(button, "MouseButton1Click", function()
            if callback then
                callback()
            end
        end)
        return button
    end

    local function makeToggle(parent, y, text, flag, default, callback)
        local row = create("TextButton", {
            Parent = parent,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(18, y),
            Size = UDim2.new(1, -36, 0, 26),
            Text = ""
        })
        create("TextLabel", {
            Parent = row,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -64, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local track = create("Frame", {
            Parent = row,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -42, 0.5, -10),
            Size = UDim2.fromOffset(40, 20)
        })
        round(track, 10)
        local knob = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Text,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.fromOffset(16, 16)
        })
        round(knob, 8)

        local state = default == true
        local sharedControl

        local function render(animate)
            local targetColor = state and UI.Theme.Accent or UI.Theme.Tertiary
            local targetPosition = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
            if animate then
                TweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(knob, TweenInfo.new(0.18), {Position = targetPosition}):Play()
            else
                track.BackgroundColor3 = targetColor
                knob.Position = targetPosition
            end
        end

        local function apply(newState, runCallback, skipBroadcast)
            state = newState == true
            render(true)
            if type(UI.SetFlag) == "function" then
                UI:SetFlag(flag, state)
            end
            if runCallback and callback then
                task.spawn(callback, state)
            end
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
        if type(UI.SetFlag) == "function" then
            UI:SetFlag(flag, state)
        end

        connect(row, "MouseButton1Click", function()
            apply(not state, true, false)
        end)
    end

    local function makeSlider(parent, y, text, flag, default, minimum, maximum, callback)
        create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(18, y),
            Size = UDim2.fromOffset(108, 28),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local track = create("Frame", {
            Parent = parent,
            Active = true,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(132, y + 12),
            Size = UDim2.fromOffset(250, 5)
        })
        round(track, 3)
        local fill = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0)
        })
        round(fill, 3)
        bindTheme(fill, "BackgroundColor3", "Accent")
        local knob = create("Frame", {
            Parent = track,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(16, 16)
        })
        round(knob, 8)
        bindTheme(knob, "BackgroundColor3", "Accent")
        local valueLabel = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(394, y),
            Size = UDim2.fromOffset(56, 28),
            Text = tostring(default),
            TextColor3 = UI.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right
        })

        local value = math.clamp(tonumber(default) or minimum, minimum, maximum)
        local dragging = false
        local sharedControl

        local function setValue(newValue, runCallback, skipBroadcast)
            value = math.clamp(math.floor((tonumber(newValue) or minimum) + 0.5), minimum, maximum)
            local percent = (value - minimum) / math.max(1, maximum - minimum)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, 0, 0.5, 0)
            valueLabel.Text = tostring(value)
            if type(UI.SetFlag) == "function" then
                UI:SetFlag(flag, value)
            end
            if runCallback and callback then
                task.spawn(callback, value)
            end
            if not skipBroadcast and type(UI.BroadcastFlag) == "function" then
                UI:BroadcastFlag(flag, value, sharedControl, runCallback)
            end
        end

        local function setFromX(x)
            if track.AbsoluteSize.X <= 0 then
                return
            end
            local percent = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setValue(minimum + ((maximum - minimum) * percent), true, false)
        end

        if type(UI.RegisterFlagControl) == "function" then
            sharedControl = UI:RegisterFlagControl(flag, function(sharedValue, triggerCallback)
                setValue(sharedValue, triggerCallback, true)
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

    local hero = makeCard("Hero", 0, 0, 1072, 108, 0.38)
    create("UIGradient", {
        Parent = hero,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 5, 7)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 17, 18))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.02),
            NumberSequenceKeypoint.new(0.6, 0.26),
            NumberSequenceKeypoint.new(1, 0.68)
        })
    })
    create("TextLabel", {
        Parent = hero,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(26, 22),
        Size = UDim2.fromOffset(520, 36),
        Text = "✦ VANGUARD HUB ✦",
        TextColor3 = UI.Theme.Text,
        TextSize = 28,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    create("TextLabel", {
        Parent = hero,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(26, 60),
        Size = UDim2.fromOffset(320, 28),
        Text = "Se rodou, amem.\nSe nao rodou, Discord.",
        TextColor3 = UI.Theme.Text,
        TextSize = 15,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    local information = makeCard("Information", 0, 126, 248, 122)
    makeTitle(information, "INFORMACOES")
    local informationRows = {
        {"User:", localPlayer and localPlayer.Name or "VanguardHub", UI.Theme.Accent},
        {"Game:", "Lumber Tycoon 2", UI.Theme.Accent},
        {"Version:", "v1.0", UI.Theme.Accent}
    }
    for index, row in ipairs(informationRows) do
        local y = 40 + ((index - 1) * 24)
        create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(18, y),
            Size = UDim2.fromOffset(82, 22),
            Text = row[1],
            TextColor3 = UI.Theme.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local valueLabel = create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(96, y),
            Size = UDim2.fromOffset(134, 22),
            Text = row[2],
            TextColor3 = row[3],
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        bindTheme(valueLabel, "TextColor3", "Accent")
    end

    local quickStatus = makeCard("QuickStatus", 262, 126, 322, 168)
    makeTitle(quickStatus, "QUICK TOGGLES")
    makeToggle(quickStatus, 38, "Noclip", "Noclip", Config.Noclip == true, function(value)
        Config.Noclip = value
    end)
    makeToggle(quickStatus, 66, "God Mode", "GodMode", Config.GodMode == true, function(value)
        Config.GodMode = value
    end)
    makeToggle(quickStatus, 94, "Fly", "Flight", Config.Flight == true, function(value)
        Config.Flight = value
    end)
    makeToggle(quickStatus, 122, "Anti Void", "AntiVoid", Config.AntiVoid == true, function(value)
        Config.AntiVoid = value
    end)
    makeToggle(quickStatus, 150, "No Fog", "NoFog", Config.NoFog == true, function(value)
        Config.NoFog = value
    end)

    local quickSettings = makeCard("QuickSettings", 598, 126, 474, 168)
    makeTitle(quickSettings, "CONFIGURACOES RAPIDAS")
    makeSlider(quickSettings, 38, "WalkSpeed", "WalkSpeed", Config.WalkSpeed or 120, 16, 1000, function(value)
        Config.WalkSpeed = value
        local character = localPlayer and localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end)
    makeSlider(quickSettings, 66, "JumpPower", "JumpPower", Config.JumpPower or 250, 50, 1000, function(value)
        Config.JumpPower = value
        local character = localPlayer and localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end)
    makeSlider(quickSettings, 94, "FOV", "FOV", Config.FOV or 90, 1, 120, function(value)
        Config.FOV = value
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end)
    makeToggle(quickSettings, 126, "Auto Save Settings", "AutoSave", Config.AutoSave ~= false, function(value)
        Config.AutoSave = value
    end)

    local quickAccess = makeCard("QuickAccess", 0, 308, 1072, 96)
    makeTitle(quickAccess, "ACESSO RAPIDO")
    local quickButtons = {
        {"Player", "👤", UI.Theme.Accent, "Player"},
        {"World", "🌎", UI.Theme.Accent, "World"},
        {"Teleports", "📍", UI.Theme.Accent, "Teleports"},
        {"Wood", "🪵", UI.Theme.Accent, "Wood"},
        {"Build", "🏗️", UI.Theme.Accent, "Build"},
        {"Vehicle", "🚗", UI.Theme.Accent, "Vehicle"},
        {"Item", "📦", UI.Theme.Accent, "Item"},
        {"Settings", "⚙", UI.Theme.Accent, "Settings"}
    }
    for index, item in ipairs(quickButtons) do
        local column = (index - 1) % 4
        local row = math.floor((index - 1) / 4)
        makeActionButton(
            quickAccess,
            item[1],
            item[2],
            item[3],
            18 + (column * 260),
            38 + (row * 24),
            246,
            22,
            function()
                if type(UI.SelectTab) ~= "function" or not UI:SelectTab(item[4]) then
                    notify("VanguardHub", "Nao foi possivel abrir " .. item[4] .. ".")
                end
            end
        )
    end

    return function()
        for _, connection in ipairs(connections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        table.clear(connections)
    end
end
