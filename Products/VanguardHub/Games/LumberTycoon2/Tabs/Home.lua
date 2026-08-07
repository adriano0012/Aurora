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

    local canvas = tab:Canvas(530)
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
            CornerRadius = UDim.new(0, radius or 10)
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

    local function makeCard(name, x, y, width, height, transparency)
        local card = create("Frame", {
            Name = name,
            Parent = canvas,
            BackgroundColor3 = UI.Theme.Secondary,
            BackgroundTransparency = transparency or 0.05,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height)
        })
        round(card, 12)
        stroke(card, 0.08)
        return card
    end

    local function makeTitle(parent, text)
        local label = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(20, 14),
            Size = UDim2.new(1, -40, 0, 20),
            Text = text,
            TextColor3 = UI.Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        bindTheme(label, "TextColor3", "Accent")
        return label
    end

    local function makeToggle(parent, y, text, flag, default, callback)
        local row = create("TextButton", {
            Parent = parent,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(16, y),
            Size = UDim2.new(1, -32, 0, 22),
            Text = ""
        })
        create("TextLabel", {
            Parent = row,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -58, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local track = create("Frame", {
            Parent = row,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -38, 0.5, -9),
            Size = UDim2.fromOffset(36, 18)
        })
        round(track, 9)
        local knob = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Text,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.fromOffset(14, 14)
        })
        round(knob, 7)

        local state = default == true
        local sharedControl

        local function render(animate)
            local targetColor = state and UI.Theme.Accent or UI.Theme.Tertiary
            local targetPosition = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
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
            Position = UDim2.fromOffset(16, y),
            Size = UDim2.fromOffset(92, 22),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local track = create("Frame", {
            Parent = parent,
            Active = true,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(126, y + 9),
            Size = UDim2.fromOffset(378, 4)
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
            Size = UDim2.fromOffset(14, 14)
        })
        round(knob, 7)
        bindTheme(knob, "BackgroundColor3", "Accent")

        local valueLabel = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(520, y),
            Size = UDim2.fromOffset(50, 22),
            Text = tostring(default),
            TextColor3 = UI.Theme.Text,
            TextSize = 12,
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

    -- Home v3: dashboard intentionally starts lower to preserve the background artwork.\n    -- The empty upper area replaces the old hero without covering the image.
    local information = makeCard("Information", 0, 170, 310, 158)
    makeTitle(information, "INFORMACOES")

    local executorName = "Unknown"
    pcall(function()
        if type(identifyexecutor) == "function" then
            local detected = identifyexecutor()
            if type(detected) == "string" and detected ~= "" then
                executorName = detected
            end
        end
    end)

    local informationRows = {
        {"User", localPlayer and localPlayer.Name or "VanguardHub"},
        {"Game", "Lumber Tycoon 2"},
        {"Executor", executorName},
        {"Version", "v1.0"}
    }

    for index, row in ipairs(informationRows) do
        local y = 44 + ((index - 1) * 25)

        create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(20, y),
            Size = UDim2.fromOffset(78, 20),
            Text = row[1],
            TextColor3 = UI.Theme.TextDim,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local valueLabel = create("TextLabel", {
            Parent = information,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(100, y),
            Size = UDim2.new(1, -120, 0, 20),
            Text = row[2],
            TextColor3 = UI.Theme.Accent,
            TextSize = 13,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        bindTheme(valueLabel, "TextColor3", "Accent")
    end

    local quickStatus = makeCard("QuickStatus", 326, 170, 894, 158)
    makeTitle(quickStatus, "QUICK TOGGLES")

    local function makeHomeToggle(x, y, text, flag, default, callback)
        local holder = create("Frame", {
            Parent = quickStatus,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(421, 24)
        })
        makeToggle(holder, 0, text, flag, default, callback)
    end

    makeHomeToggle(4, 44, "Noclip", "Noclip", Config.Noclip == true, function(value)
        Config.Noclip = value
    end)
    makeHomeToggle(4, 76, "Fly", "Flight", Config.Flight == true, function(value)
        Config.Flight = value
    end)
    makeHomeToggle(4, 108, "God Mode", "GodMode", Config.GodMode == true, function(value)
        Config.GodMode = value
    end)
    makeHomeToggle(437, 44, "Anti Void", "AntiVoid", Config.AntiVoid == true, function(value)
        Config.AntiVoid = value
    end)
    makeHomeToggle(437, 76, "No Fog", "NoFog", Config.NoFog == true, function(value)
        Config.NoFog = value
    end)

    local quickSettings = makeCard("QuickSettings", 0, 344, 1220, 170)
    makeTitle(quickSettings, "CONFIGURACOES RAPIDAS")

    local function makeWideSlider(parent, y, text, flag, default, minimum, maximum, callback)
        create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(20, y),
            Size = UDim2.fromOffset(110, 22),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local valueLabel = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.new(1, -78, 0, y),
            Size = UDim2.fromOffset(58, 22),
            Text = tostring(default),
            TextColor3 = UI.Theme.Accent,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        bindTheme(valueLabel, "TextColor3", "Accent")

        local track = create("Frame", {
            Parent = parent,
            Active = true,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(146, y + 9),
            Size = UDim2.new(1, -244, 0, 4)
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
            Size = UDim2.fromOffset(14, 14)
        })
        round(knob, 7)
        bindTheme(knob, "BackgroundColor3", "Accent")

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

    makeWideSlider(quickSettings, 46, "WalkSpeed", "WalkSpeed", Config.WalkSpeed or 120, 16, 1000, function(value)
        Config.WalkSpeed = value
        local character = localPlayer and localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end)

    makeWideSlider(quickSettings, 76, "JumpPower", "JumpPower", Config.JumpPower or 250, 50, 1000, function(value)
        Config.JumpPower = value
        local character = localPlayer and localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end)

    makeWideSlider(quickSettings, 106, "FOV", "FOV", Config.FOV or 90, 1, 120, function(value)
        Config.FOV = value
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end)

    makeToggle(quickSettings, 136, "Auto Save Settings", "AutoSave", Config.AutoSave ~= false, function(value)
        Config.AutoSave = value
    end)

    return function()
        for _, connection in ipairs(connections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        table.clear(connections)
    end
end