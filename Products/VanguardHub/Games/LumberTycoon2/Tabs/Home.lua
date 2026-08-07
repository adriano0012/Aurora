-- ============================================================
-- VANGUARD HUB - HOME DASHBOARD
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

    local function makeActionButton(parent, text, icon, iconColor, x, y, width, height, callback)
        local button = create("TextButton", {
            Parent = parent,
            AutoButtonColor = false,
            BackgroundColor3 = UI.Theme.Glass,
            BackgroundTransparency = 0.06,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            Text = "",
            ZIndex = 15
        })
        round(button, 8)
        stroke(button, 0.2)

        create("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.fromOffset(38, height),
            Text = icon,
            TextColor3 = iconColor,
            TextSize = 26,
            ZIndex = 16
        })
        create("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(50, 0),
            Size = UDim2.new(1, -56, 1, 0),
            Text = text,
            TextColor3 = UI.Theme.Text,
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 16
        })

        connect(button, "MouseEnter", function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = UI.Theme.Hover}
            ):Play()
        end)
        connect(button, "MouseLeave", function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = UI.Theme.Glass}
            ):Play()
        end)
        connect(button, "MouseButton1Click", callback)
        return button
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
        local identify = rawget(_G, "identifyexecutor") or rawget(_G, "getexecutorname")
        if type(identify) == "function" then
            local success, result = pcall(identify)
            if success and result then
                return tostring(result)
            end
        end
        if rawget(_G, "syn") then return "Synapse X" end
        if rawget(_G, "krnl") then return "KRNL" end
        if rawget(_G, "fluxus") then return "Fluxus" end
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

    -- Hero -------------------------------------------------------
    local Hero = makeCard("Hero", 0, 0, 754, 271, 0.48)
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
        Size = UDim2.fromOffset(475, 62),
        Text = "O hub mais completo e otimizado\npara Lumber Tycoon 2.",
        TextColor3 = UI.Theme.Text,
        TextSize = 20,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 15
    })
    local PremiumButton = makeActionButton(
        Hero,
        "Premium Ativo",
        "♛",
        UI.Theme.Accent,
        28,
        209,
        169,
        42,
        function()
            notify("VanguardHub", "Premium ativo.")
        end
    )
    bindTheme(PremiumButton:FindFirstChildOfClass("TextLabel"), "TextColor3", "Accent")

    -- Information ------------------------------------------------
    local Information = makeCard("Information", 0, 282, 348, 260)
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

    -- Quick status -----------------------------------------------
    local QuickStatus = makeCard("QuickStatus", 361, 282, 378, 260)
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

    -- Quick access -----------------------------------------------
    local QuickAccess = makeCard("QuickAccess", 0, 554, 739, 216)
    makeTitle(QuickAccess, "ACESSO RÁPIDO")
    local quickButtons = {
        {"Bring Tree", "♠", Color3.fromRGB(72, 194, 43), "Wood"},
        {"Bring Logs", "◒", Color3.fromRGB(206, 126, 69), "Wood"},
        {"Sell Logs", "$", Color3.fromRGB(63, 201, 44), "Wood"},
        {"Autofarm", "◆", Color3.fromRGB(198, 132, 83), "Wood"},
        {"Dupe", "◇", UI.Theme.Accent, "Dupe"},
        {"Auto Build", "⌂", Color3.fromRGB(239, 90, 75), "Build"},
        {"Vehicle Spawner", "▰", UI.Theme.TextDim, "Vehicle"},
        {"Teleport Menu", "●", Color3.fromRGB(245, 76, 87), "Teleports"}
    }
    for index, item in ipairs(quickButtons) do
        local column = (index - 1) % 4
        local row = math.floor((index - 1) / 4)
        local button = makeActionButton(
            QuickAccess,
            item[1],
            item[2],
            item[3],
            20 + (column * 174),
            43 + (row * 62),
            165,
            53,
            function()
                if type(UI.SelectTab) ~= "function" or not UI:SelectTab(item[4]) then
                    notify(item[1], "Abra a categoria " .. item[4] .. ".")
                end
            end
        )
        if index == 5 then
            local iconLabel = button:FindFirstChildOfClass("TextLabel")
            if iconLabel then bindTheme(iconLabel, "TextColor3", "Accent") end
        end
    end
    create("TextLabel", {
        Parent = QuickAccess,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(22, 171),
        RichText = true,
        Size = UDim2.fromOffset(695, 32),
        Text = '<font color="#FFC400">◉  Dica:</font>  Passe o mouse sobre qualquer opção para ver mais informações.',
        TextColor3 = UI.Theme.TextDim,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    })

    -- Performance ------------------------------------------------
    local Performance = makeCard("Performance", 753, 0, 493, 204)
    makeTitle(Performance, "PERFORMANCE")

    local function makeGauge(parent, x, color, caption, initialText, initialPercent)
        local gauge = create("Frame", {
            Parent = parent,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(x, 49),
            Size = UDim2.fromOffset(105, 128),
            ZIndex = 15
        })
        local segments = {}
        local segmentCount = 42
        local radius = 40
        local centerX = 52
        local centerY = 48
        for index = 1, segmentCount do
            local ratio = (index - 1) / (segmentCount - 1)
            local angle = -225 + (270 * ratio)
            local radians = math.rad(angle)
            local segment = create("Frame", {
                Parent = gauge,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = UI.Theme.Tertiary,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(
                    centerX + (math.cos(radians) * radius),
                    centerY + (math.sin(radians) * radius)
                ),
                Rotation = angle,
                Size = UDim2.fromOffset(4, 10),
                ZIndex = 16
            })
            round(segment, 2)
            segments[index] = segment
        end
        local valueLabel = create("TextLabel", {
            Parent = gauge,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(7, 28),
            Size = UDim2.fromOffset(90, 30),
            Text = initialText,
            TextColor3 = UI.Theme.Text,
            TextSize = 22,
            ZIndex = 17
        })
        create("TextLabel", {
            Parent = gauge,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(7, 57),
            Size = UDim2.fromOffset(90, 24),
            Text = caption,
            TextColor3 = UI.Theme.TextDim,
            TextSize = 12,
            ZIndex = 17
        })

        local function update(percent, text)
            percent = math.clamp(percent or 0, 0, 1)
            local activeCount = math.floor((segmentCount * percent) + 0.5)
            for index, segment in ipairs(segments) do
                segment.BackgroundColor3 = index <= activeCount and color or UI.Theme.Tertiary
            end
            valueLabel.Text = text
        end
        update(initialPercent, initialText)
        return update
    end

    local updateCPU = makeGauge(Performance, 5, UI.Theme.Accent, "CPU", "47%", 0.47)
    local updateMemory = makeGauge(Performance, 125, UI.Theme.Info, "MEM", "36%", 0.36)
    local updateFPS = makeGauge(Performance, 245, Color3.fromRGB(67, 190, 39), "FPS", "60", 0.5)
    local updatePing = makeGauge(Performance, 365, UI.Theme.Accent, "PING", "18ms", 0.82)
    bindTheme(Performance, "BackgroundColor3", "Secondary")

    -- News -------------------------------------------------------
    local News = makeCard("News", 753, 218, 493, 284)
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
            Size = UDim2.fromOffset(330, 28),
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
            Position = UDim2.fromOffset(390, y),
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
        Position = UDim2.fromOffset(21, 238),
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

    -- Quick settings --------------------------------------------
    local QuickSettings = makeCard("QuickSettings", 753, 515, 493, 255)
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
        Size = UDim2.fromOffset(453, 40),
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

    -- Shared live statistics ------------------------------------
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
        local memoryMb = 0
        pcall(function()
            memoryMb = Stats:GetTotalMemoryUsageMb()
        end)
        local memoryPercent = math.clamp(math.floor((memoryMb / 2048) * 100 + 0.5), 1, 99)

        infoValueLabels[5].Text = tostring(ping) .. " ms"
        infoValueLabels[6].Text = tostring(fps)
        updateCPU(0.47, "47%")
        updateMemory(memoryPercent / 100, tostring(memoryPercent) .. "%")
        updateFPS(math.clamp(fps / 120, 0, 1), tostring(fps))
        updatePing(math.clamp(1 - (ping / 120), 0.08, 1), tostring(ping) .. "ms")
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
