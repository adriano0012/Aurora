-- ============================================================
-- VANGUARD HUB - HOME DASHBOARD (CLEAN)
-- ============================================================

return function(UI, Config, Utils)
    local Players = game:GetService("Players")
    local Stats = game:GetService("Stats")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local Tab = UI:Tab("Home", "6026568198", {
        id = "home",
        displayName = "Home"
    })

    if type(Tab.Canvas) ~= "function" then
        local Fallback = Tab:Section("VANGUARDHUB", true)
        Fallback:Label("Atualize Library.lua para carregar o novo dashboard.", {
            NoPadding = true,
            Height = 34,
            Color = UI.Theme.Warning
        })
        return
    end

    local Canvas = Tab:Canvas(770)
    local connections = {}

    local function connect(object, eventName, callback)
        local connection = object[eventName]:Connect(callback)
        table.insert(connections, connection)
        return connection
    end

    local function create(className, properties)
        local object = Instance.new(className)
        for property, value in pairs(properties) do
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
            Parent = Canvas,
            BackgroundColor3 = UI.Theme.Secondary,
            BackgroundTransparency = transparency or 0.04,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            ZIndex = 13
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
            Position = UDim2.fromOffset(20, 12),
            Size = UDim2.new(1, -40, 0, 24),
            Text = text,
            TextColor3 = UI.Theme.Accent,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 14
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
            Position = UDim2.fromOffset(18, y),
            Size = UDim2.new(1, -36, 0, 32),
            Text = "",
            ZIndex = 15
        })
        create("TextLabel", {
            Name = "ToggleLabel",
            Parent = row,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(30, 0),
            Size = UDim2.new(1, -88, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 16
        })

        local symbols = {
            ["Infinite Yield"] = "</>",
            ["Noclip"] = "♙",
            ["God Mode"] = "◇",
            ["Fly"] = "△",
            ["Anti Void"] = "◇",
            ["No Fog"] = "☁"
        }
        create("TextLabel", {
            Name = "ToggleIcon",
            Parent = row,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(26, 32),
            Text = symbols[text] or "•",
            TextColor3 = UI.Theme.Text,
            TextSize = text == "Infinite Yield" and 13 or 21,
            ZIndex = 16
        })

        local track = create("Frame", {
            Name = "ToggleTrack",
            Parent = row,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -44, 0.5, -12),
            Size = UDim2.fromOffset(42, 24),
            ZIndex = 16
        })
        round(track, 12)
        local knob = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Text,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.fromOffset(18, 18),
            ZIndex = 17
        })
        round(knob, 9)

        local state = default == true
        local function render(animate)
            local tweenService = game:GetService("TweenService")
            local targetColor = state and UI.Theme.Accent or UI.Theme.Tertiary
            local targetPosition = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)
            if animate then
                tweenService:Create(track, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
                tweenService:Create(knob, TweenInfo.new(0.18), {Position = targetPosition}):Play()
            else
                track.BackgroundColor3 = targetColor
                knob.Position = targetPosition
            end
        end
        render(false)

        if type(UI.SetFlag) == "function" then
            UI:SetFlag(flag, state)
        end

        local sharedControl
        if type(UI.RegisterFlagControl) == "function" then
            sharedControl = UI:RegisterFlagControl(flag, function(value, triggerCallback)
                local newState = value == true
                local changed = newState ~= state
                state = newState
                render(true)
                if changed and triggerCallback and callback then
                    task.spawn(callback, state)
                end
            end)
        end

        connect(row, "MouseButton1Click", function()
            state = not state
            render(true)
            if callback then
                task.spawn(callback, state)
            end
            if type(UI.BroadcastFlag) == "function" then
                UI:BroadcastFlag(flag, state, sharedControl, true)
            elseif type(UI.SetFlag) == "function" then
                UI:SetFlag(flag, state)
            end
        end)

        return {
            GetState = function()
                return state
            end,
            SetState = function(_, value, skipCallback)
                state = value == true
                render(true)
                if not skipCallback and callback then
                    task.spawn(callback, state)
                end
                if type(UI.BroadcastFlag) == "function" then
                    UI:BroadcastFlag(flag, state, sharedControl, not skipCallback)
                end
            end
        }
    end

    local function makeSlider(parent, y, text, flag, default, minimum, maximum, callback)
        local label = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(20, y),
            Size = UDim2.fromOffset(112, 30),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        local track = create("Frame", {
            Parent = parent,
            Active = true,
            BackgroundColor3 = UI.Theme.Tertiary,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(138, y + 13),
            Size = UDim2.fromOffset(270, 5),
            ZIndex = 15
        })
        round(track, 3)
        local fill = create("Frame", {
            Parent = track,
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            ZIndex = 16
        })
        round(fill, 3)
        bindTheme(fill, "BackgroundColor3", "Accent")
        local knob = create("Frame", {
            Parent = track,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = UI.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(17, 17),
            ZIndex = 17
        })
        round(knob, 9)
        bindTheme(knob, "BackgroundColor3", "Accent")
        local valueLabel = create("TextLabel", {
            Parent = parent,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(420, y),
            Size = UDim2.fromOffset(52, 30),
            Text = tostring(default),
            TextColor3 = UI.Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 15
        })

        local value = math.clamp(tonumber(default) or minimum, minimum, maximum)
        local dragging = false
        local sharedControl
        local function setValue(newValue, runCallback, skipBroadcast)
            value = math.clamp(math.floor((newValue or minimum) + 0.5), minimum, maximum)
            local percent = (value - minimum) / math.max(1, maximum - minimum)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, 0, 0.5, 0)
            valueLabel.Text = tostring(value)
            if runCallback and callback then
                task.spawn(callback, value)
            end
            if not skipBroadcast and type(UI.BroadcastFlag) == "function" then
                UI:BroadcastFlag(flag, value, sharedControl, runCallback)
            elseif type(UI.SetFlag) == "function" then
                UI:SetFlag(flag, value)
            end
        end
        local function setFromX(x)
            if track.AbsoluteSize.X <= 0 then return end
            local percent = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setValue(minimum + ((maximum - minimum) * percent), true)
        end

        if type(UI.RegisterFlagControl) == "function" then
            sharedControl = UI:RegisterFlagControl(flag, function(sharedValue, triggerCallback)
                setValue(sharedValue, triggerCallback, true)
            end)
        end
        setValue(value, false, true)
        connect(track, "InputBegan", function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(input.Position.X)
            end
        end)
        connect(UserInputService, "InputChanged", function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                setFromX(input.Position.X)
            end
        end)
        connect(UserInputService, "InputEnded", function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        return {
            Label = label,
            SetValue = function(_, newValue, skipCallback)
                setValue(newValue, not skipCallback, false)
            end,
            GetValue = function()
                return value
            end
        }
    end

    local function getExecutorName()
        local registry = rawget(_G, "__VanguardModuleRegistry") or {}
        local environment = registry["Core/Environment/Environment"]
        if environment and type(environment.Get) == "function" then
            local current = environment.Get()
            if current and current.Executor then
                return tostring(current.Executor)
            end
        end
        return "Unknown"
    end

    local function getPing()
        local ping = 0
        pcall(function()
            local network = Stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
            if dataPing then
                ping = math.floor(dataPing:GetValue() + 0.5)
            end
        end)
        return ping
    end

    -- Hero (Reduzido) --------------------------------------------
    local Hero = makeCard("Hero", 0, 0, 754, 200, 0.48)
    create("UIGradient", {
        Parent = Hero,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 5, 7)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 17, 18))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.02),
            NumberSequenceKeypoint.new(0.6, 0.32),
            NumberSequenceKeypoint.new(1, 0.72)
        })
    })
    create("TextLabel", {
        Parent = Hero,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(28, 29),
        Size = UDim2.fromOffset(520, 51),
        Text = "VANGUARDHUB",
        TextColor3 = UI.Theme.Text,
        TextSize = 41,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    })
    local HeroPremium = create("TextLabel", {
        Parent = Hero,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(28, 86),
        Size = UDim2.fromOffset(420, 38),
        Text = "PREMIUM EDITION",
        TextColor3 = UI.Theme.Accent,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    })
    bindTheme(HeroPremium, "TextColor3", "Accent")
    create("TextLabel", {
        Parent = Hero,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(28, 133),
        Size = UDim2.fromOffset(698, 48),
        Text = "O hub mais completo e otimizado para Lumber Tycoon 2.",
        TextColor3 = UI.Theme.Text,
        TextSize = 18,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 15
    })

    -- Information & Quick Status (Lado a lado) ------------------
    local Information = makeCard("Information", 0, 212, 348, 260)
    makeTitle(Information, "INFORMAÇÕES")
    local informationRows = {
        {"Executor:", getExecutorName(), UI.Theme.Accent},
        {"User:", LocalPlayer and LocalPlayer.Name or "VanguardHub", UI.Theme.Accent},
        {"Game:", "Lumber Tycoon 2", UI.Theme.Accent},
        {"Place ID:", tostring(game.PlaceId), UI.Theme.Accent},
        {"Ping:", "-- ms", UI.Theme.Success},
        {"FPS:", "--", UI.Theme.Success},
        {"Version:", "v2.5.0", UI.Theme.Accent}
    }
    local infoValueLabels = {}
    for index, row in ipairs(informationRows) do
        local y = 49 + ((index - 1) * 28)
        create("TextLabel", {
            Parent = Information,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(20, y),
            Size = UDim2.fromOffset(104, 24),
            Text = row[1],
            TextColor3 = UI.Theme.TextDim,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        local valueLabel = create("TextLabel", {
            Parent = Information,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(123, y),
            Size = UDim2.fromOffset(205, 24),
            Text = row[2],
            TextColor3 = row[3],
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        infoValueLabels[index] = valueLabel
        if index <= 4 or index == 7 then
            bindTheme(valueLabel, "TextColor3", "Accent")
        end
    end

    local QuickStatus = makeCard("QuickStatus", 361, 212, 393, 260)
    makeTitle(QuickStatus, "STATUS RÁPIDO")
    makeToggle(QuickStatus, 45, "Infinite Yield", "HomeInfiniteYield", Config.HomeInfiniteYield ~= false, function(value)
        Config.HomeInfiniteYield = value
        notify("Infinite Yield", "Indicador visual apenas. Esta build nao inclui um modulo local do Infinite Yield.")
    end)
    makeToggle(QuickStatus, 79, "Noclip", "Noclip", Config.Noclip == true, function(value)
        Config.Noclip = value
    end)
    makeToggle(QuickStatus, 113, "God Mode", "GodMode", Config.GodMode == true, function(value)
        Config.GodMode = value
    end)
    makeToggle(QuickStatus, 147, "Fly", "Flight", Config.Flight == true, function(value)
        Config.Flight = value
    end)
    makeToggle(QuickStatus, 181, "Anti Void", "AntiVoid", Config.AntiVoid == true, function(value)
        Config.AntiVoid = value
    end)
    makeToggle(QuickStatus, 215, "No Fog", "NoFog", Config.NoFog == true, function(value)
        Config.NoFog = value
    end)

    -- News & Quick Settings (Lado a lado) ------------------------
    local News = makeCard("News", 0, 484, 348, 286)
    makeTitle(News, "NOTÍCIAS")
    local newsRows = {
        {"Nova atualização v2.5.0", "24/05", UI.Theme.Success},
        {"Correções e melhorias", "22/05", UI.Theme.Accent},
        {"Dupe otimizado", "20/05", UI.Theme.Accent},
        {"Novo sistema de temas", "18/05", UI.Theme.Accent}
    }
    for index, row in ipairs(newsRows) do
        local y = 53 + ((index - 1) * 43)
        create("TextLabel", {
            Parent = News,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(21, y),
            Size = UDim2.fromOffset(18, 28),
            Text = "•",
            TextColor3 = UI.Theme.TextDim,
            TextSize = 15,
            ZIndex = 15
        })
        create("TextLabel", {
            Parent = News,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(40, y),
            Size = UDim2.fromOffset(200, 28),
            Text = row[1],
            TextColor3 = UI.Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        local dateLabel = create("TextLabel", {
            Parent = News,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(245, y),
            Size = UDim2.fromOffset(80, 28),
            Text = row[2],
            TextColor3 = row[3],
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 15
        })
        if index > 1 then bindTheme(dateLabel, "TextColor3", "Accent") end
    end
    local AllNews = create("TextButton", {
        Parent = News,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(21, 240),
        Size = UDim2.fromOffset(120, 30),
        Text = "Ver todas",
        TextColor3 = UI.Theme.Accent,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    })
    bindTheme(AllNews, "TextColor3", "Accent")
    connect(AllNews, "MouseButton1Click", function()
        notify("Notícias", "Você já está na versão mais recente do painel.")
    end)

    local QuickSettings = makeCard("QuickSettings", 361, 484, 393, 286)
    makeTitle(QuickSettings, "CONFIGURAÇÕES RÁPIDAS")
    makeSlider(QuickSettings, 48, "WalkSpeed", "WalkSpeed", Config.WalkSpeed or 120, 16, 1000, function(value)
        Config.WalkSpeed = value
        local character = LocalPlayer and LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end)
    makeSlider(QuickSettings, 84, "JumpPower", "JumpPower", Config.JumpPower or 250, 50, 1000, function(value)
        Config.JumpPower = value
        local character = LocalPlayer and LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end)
    makeSlider(QuickSettings, 120, "FOV", "FOV", Config.FOV or 90, 1, 120, function(value)
        Config.FOV = value
        local camera = workspace.CurrentCamera
        if camera then camera.FieldOfView = value end
    end)

    local AutoSave = makeToggle(
        QuickSettings,
        157,
        "Auto Save Settings",
        "AutoSave",
        Config.AutoSave ~= false,
        function(value)
            Config.AutoSave = value
        end
    )
    local autoSaveRow = QuickSettings:FindFirstChildWhichIsA("TextButton")
    if autoSaveRow then
        local icon = autoSaveRow:FindFirstChild("ToggleIcon")
        local textLabel = autoSaveRow:FindFirstChild("ToggleLabel")
        if icon then icon.Visible = false end
        if textLabel then
            textLabel.Position = UDim2.fromOffset(0, 0)
        end
    end

    local ConfigureKeys = create("TextButton", {
        Parent = QuickSettings,
        AutoButtonColor = false,
        BackgroundColor3 = UI.Theme.Glass,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(20, 205),
        Size = UDim2.fromOffset(353, 40),
        Text = "Configurar Teclas",
        TextColor3 = UI.Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    })
    round(ConfigureKeys, 8)
    stroke(ConfigureKeys, 0.24)
    create("UIPadding", {
        Parent = ConfigureKeys,
        PaddingLeft = UDim.new(0, 12)
    })
    create("TextLabel", {
        Parent = ConfigureKeys,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.fromOffset(28, 40),
        Text = "›",
        TextColor3 = UI.Theme.Text,
        TextSize = 24,
        ZIndex = 16
    })
    connect(ConfigureKeys, "MouseButton1Click", function()
        if type(UI.SelectTab) ~= "function" or not UI:SelectTab("Settings") then
            notify("Configurações", "Abra Settings para configurar as teclas.")
        end
    end)

    -- Shared live statistics (apenas Info card) -----------------
    local renderedFrames = 0
    local lastPerformanceUpdate = os.clock()
    connect(RunService, "RenderStepped", function()
        renderedFrames += 1
        local now = os.clock()
        if now - lastPerformanceUpdate < 1 then return end

        local fps = math.max(1, math.floor((renderedFrames / (now - lastPerformanceUpdate)) + 0.5))
        renderedFrames = 0
        lastPerformanceUpdate = now

        local ping = getPing()

        infoValueLabels[5].Text = tostring(ping) .. " ms"
        infoValueLabels[6].Text = tostring(fps)
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
