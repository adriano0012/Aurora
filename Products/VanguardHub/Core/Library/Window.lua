-- ============================================================
-- VANGUARD HUB - UI LIBRARY v1.0
-- ============================================================

local Library = {
    Flags = {},
    CurrentTab = nil,
    Connections = {},
    Instances = {},
    ScreenGui = nil,
    Actions = {},
    FlagControls = {},
    ThemeBindings = {},
    Theme = {
        Main = Color3.fromRGB(1, 6, 7),
        Secondary = Color3.fromRGB(7, 12, 14),
        Tertiary = Color3.fromRGB(18, 25, 28),
        Accent = Color3.fromRGB(128, 94, 245),
        AccentDark = Color3.fromRGB(90, 63, 190),
        Text = Color3.fromRGB(245, 245, 247),
        TextDim = Color3.fromRGB(163, 165, 167),
        Muted = Color3.fromRGB(119, 123, 126),
        Border = Color3.fromRGB(21, 25, 28),
        CardBorder = Color3.fromRGB(24, 32, 36),
        Selected = Color3.fromRGB(49, 38, 93),
        Success = Color3.fromRGB(63, 182, 29),
        Info = Color3.fromRGB(67, 165, 255),
        Danger = Color3.fromRGB(255, 65, 65),
        Warning = Color3.fromRGB(255, 196, 0),
        Hover = Color3.fromRGB(22, 28, 31),
        Glass = Color3.fromRGB(4, 10, 12)
    },
    Assets = {
        -- Official Lumber Tycoon 2 media image (close-up of the house/base).
        Background = "rbxassetid://16941499839"
    }
}

-- ============================================================
-- SERVICES
-- ============================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================

local function CreateInstance(class, properties)
    local obj = Instance.new(class)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    if properties.Parent then
        obj.Parent = properties.Parent
    end
    return obj
end

local function CreateTween(obj, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.2
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out

    if Library.Flags and Library.Flags.Animations == false then
        for property, value in pairs(properties) do
            pcall(function()
                obj[property] = value
            end)
        end
        return nil
    end
    
    local tween = TweenService:Create(obj, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

local function SafeCallback(callback, ...)
    if not callback then return end
    
    local args = table.pack(...)
    
    task.spawn(function()
        local success, err = xpcall(function()
            callback(table.unpack(args, 1, args.n))
        end, debug.traceback)
        
        if not success then
            warn("[Vanguard Library] Callback error:", err)
        end
    end)
end

local function HasGlobal(name)
    local success, value = pcall(function()
        return rawget(_G, name)
    end)
    return success and value ~= nil
end

-- ============================================================
-- CONNECTION & INSTANCE MANAGEMENT
-- ============================================================

function Library:TrackInstance(instance)
    if instance then
        table.insert(self.Instances, instance)
    end
    return instance
end

function Library:AddConnection(obj, event, callback)
    if not obj or not event then return end
    local member = obj[event]
    local connection
    if typeof(member) == "RBXScriptSignal" then
        connection = member:Connect(callback)
    else
        connection = obj:GetPropertyChangedSignal(event):Connect(callback)
    end
    table.insert(self.Connections, connection)
    return connection
end

function Library:AddPropertyConnection(obj, property, callback)
    if not obj or not property then return end
    local connection = obj:GetPropertyChangedSignal(property):Connect(callback)
    table.insert(self.Connections, connection)
    return connection
end

function Library:RemoveConnection(connection)
    if not connection then return end
    for i, conn in ipairs(self.Connections) do
        if conn == connection then
            pcall(function() conn:Disconnect() end)
            table.remove(self.Connections, i)
            break
        end
    end
end

function Library:Destroy()
    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    self.Connections = {}
    
    self.Flags = {}
    self.CurrentTab = nil
    self.Actions = {}
    self.FlagControls = {}
    self.ThemeBindings = {}
    
    if self.ScreenGui then
        pcall(function()
            self.ScreenGui:Destroy()
        end)
        self.ScreenGui = nil
    end
    
    self.Instances = {}
end

function Library:BindTheme(instance, property, themeKey)
    if not instance or not property or not themeKey then return instance end

    table.insert(self.ThemeBindings, {
        Instance = instance,
        Property = property,
        ThemeKey = themeKey
    })

    local value = self.Theme[themeKey]
    if value ~= nil then
        pcall(function()
            instance[property] = value
        end)
    end

    return instance
end

function Library:ApplyThemeBindings()
    for i = #self.ThemeBindings, 1, -1 do
        local binding = self.ThemeBindings[i]
        local instance = binding.Instance

        if not instance or instance.Parent == nil then
            table.remove(self.ThemeBindings, i)
        else
            local value = self.Theme[binding.ThemeKey]
            if value ~= nil then
                pcall(function()
                    instance[binding.Property] = value
                end)
            end
        end
    end
end

function Library:RegisterFlagControl(flag, controller)
    if not flag or type(controller) ~= "table" then return nil end
    self.FlagControls[flag] = self.FlagControls[flag] or {}
    table.insert(self.FlagControls[flag], controller)
    return controller
end

function Library:BroadcastFlag(flag, value, source, triggerCallbacks)
    if not flag then return end
    self.Flags[flag] = value

    local controls = self.FlagControls[flag]
    if not controls then return end

    for index = #controls, 1, -1 do
        local controller = controls[index]
        if type(controller) ~= "table" then
            table.remove(controls, index)
        elseif controller ~= source and type(controller._ReceiveShared) == "function" then
            controller:_ReceiveShared(value, triggerCallbacks == true)
        end
    end
end

-- ============================================================
-- FLAG SYSTEM
-- ============================================================

function Library:SetFlag(flag, value)
    if not flag then return end
    self.Flags[flag] = value
end

function Library:GetFlag(flag)
    return self.Flags[flag]
end

function Library:GetAllFlags()
    local flags = {}
    for k, v in pairs(self.Flags) do
        flags[k] = v
    end
    return flags
end

function Library:LoadFlags(flags)
    if type(flags) ~= "table" then return end
    for k, v in pairs(flags) do
        self.Flags[k] = v
    end
end

-- ============================================================
-- ELEMENT BUILDERS
-- ============================================================

local ELEMENT_SIZES = {
    Label = UDim2.new(1, 0, 0, 24),
    Button = UDim2.new(1, 0, 0, 36),
    Toggle = UDim2.new(1, 0, 0, 36),
    Slider = UDim2.new(1, 0, 0, 46),
    Dropdown = UDim2.new(1, 0, 0, 40),
    Keybind = UDim2.new(1, 0, 0, 40),
    ColorPicker = UDim2.new(1, 0, 0, 40),
    TextBox = UDim2.new(1, 0, 0, 40),
    Paragraph = UDim2.new(1, 0, 0, 0)
}

local function ApplyHoverEffect(btn, lib)
    local originalColor = btn.BackgroundColor3
    
    lib:AddConnection(btn, "MouseEnter", function()
        CreateTween(btn, {BackgroundColor3 = lib.Theme.Hover}, 0.15)
    end)
    
    lib:AddConnection(btn, "MouseLeave", function()
        CreateTween(btn, {BackgroundColor3 = originalColor}, 0.15)
    end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================

function Library:new(name)
    -- Destroy existing instance
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "VanguardHub" then
            v:Destroy()
        end
    end
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "VanguardHub",
        Parent = CoreGui,
        DisplayOrder = 999,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    self.ScreenGui = ScreenGui
    
    if HasGlobal("syn") then
        local syn = rawget(_G, "syn")
        if type(syn) == "table" and syn.protect_gui then
            syn.protect_gui(ScreenGui)
        end
    end
    
    local lib = self
    lib.Actions = {}
    lib.FlagControls = {}
    lib.ThemeBindings = {}

    local BASE_WIDTH = 1619
    local BASE_HEIGHT = 780
    local MAX_UI_SCALE = 0.64
    
    -- Main Frame
    local Main = CreateInstance("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = lib.Theme.Main,
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(BASE_WIDTH, BASE_HEIGHT),
        ClipsDescendants = true
    })
    lib:TrackInstance(Main)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 18),
        Parent = Main
    })
    
    CreateInstance("UIStroke", {
        Parent = Main,
        Color = lib.Theme.Border,
        Thickness = 1,
        Transparency = 0.5
    })

    local MainScale = CreateInstance("UIScale", {
        Parent = Main,
        Scale = 1
    })

    local function UpdateScale()
        local camera = workspace.CurrentCamera
        if not camera then return end

        local viewport = camera.ViewportSize
        local scale = math.min(
            (viewport.X - 16) / BASE_WIDTH,
            (viewport.Y - 16) / BASE_HEIGHT
        )

        MainScale.Scale = math.clamp(scale, 0.25, MAX_UI_SCALE)
    end

    local viewportConnection
    local function ConnectViewport(camera)
        if viewportConnection then
            lib:RemoveConnection(viewportConnection)
            viewportConnection = nil
        end
        if camera then
            viewportConnection = lib:AddPropertyConnection(camera, "ViewportSize", UpdateScale)
        end
        UpdateScale()
    end

    ConnectViewport(workspace.CurrentCamera)
    lib:AddPropertyConnection(workspace, "CurrentCamera", function()
        ConnectViewport(workspace.CurrentCamera)
    end)

    local Backdrop = CreateInstance("ImageLabel", {
        Name = "LT2Backdrop",
        Parent = Main,
        BackgroundColor3 = lib.Theme.Main,
        BackgroundTransparency = 0,
        Image = lib.Assets.Background,
        ImageColor3 = Color3.fromRGB(178, 192, 185),
        ImageTransparency = 0.08,
        ScaleType = Enum.ScaleType.Crop,
        Position = UDim2.fromOffset(280, 0),
        Size = UDim2.fromOffset(1330, 780),
        ZIndex = 0
    })
    lib:TrackInstance(Backdrop)

    local HorizontalShade = CreateInstance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(0, 4, 5),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1
    })
    CreateInstance("UIGradient", {
        Parent = HorizontalShade,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.02),
            NumberSequenceKeypoint.new(0.22, 0.18),
            NumberSequenceKeypoint.new(0.47, 0.55),
            NumberSequenceKeypoint.new(0.76, 0.36),
            NumberSequenceKeypoint.new(1, 0.06)
        })
    })

    local VerticalShade = CreateInstance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(0, 5, 6),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2
    })
    CreateInstance("UIGradient", {
        Parent = VerticalShade,
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(0.34, 0.68),
            NumberSequenceKeypoint.new(0.52, 0.22),
            NumberSequenceKeypoint.new(1, 0.18)
        })
    })

    -- Top bar
    local Top = CreateInstance("Frame", {
        Name = "Top",
        Parent = Main,
        Active = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 92),
        ZIndex = 20
    })
    lib:TrackInstance(Top)

    local LogoShield = CreateInstance("Frame", {
        Parent = Top,
        BackgroundColor3 = Color3.fromRGB(4, 9, 11),
        BackgroundTransparency = 0.25,
        Position = UDim2.fromOffset(22, 19),
        Size = UDim2.fromOffset(56, 56),
        ZIndex = 21
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 14), Parent = LogoShield})
    CreateInstance("UIStroke", {
        Parent = LogoShield,
        Color = Color3.fromRGB(219, 221, 223),
        Thickness = 3,
        Transparency = 0.08
    })
    CreateInstance("TextLabel", {
        Parent = LogoShield,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(0, -1),
        Size = UDim2.fromScale(1, 1),
        Text = "V",
        TextColor3 = lib.Theme.Text,
        TextSize = 36,
        ZIndex = 22
    })

    local Brand = CreateInstance("TextLabel", {
        Parent = Top,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(94, 20),
        RichText = true,
        Size = UDim2.fromOffset(238, 34),
        Text = '<b>Vanguard</b><font color="#805EF5"><b>Hub</b></font>',
        TextColor3 = lib.Theme.Text,
        TextSize = 28,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    })
    CreateInstance("TextLabel", {
        Parent = Top,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(95, 52),
        Size = UDim2.fromOffset(220, 20),
        Text = "Lumber Tycoon 2",
        TextColor3 = lib.Theme.TextDim,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    })

    local topButtonRecords = {}
    local function CreateTopButton(text, icon, x, width)
        local btn = CreateInstance("TextButton", {
            Parent = Top,
            BackgroundColor3 = lib.Theme.Glass,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(x, 28),
            Size = UDim2.fromOffset(width, 42),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 22
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
        local stroke = CreateInstance("UIStroke", {
            Parent = btn,
            Color = lib.Theme.CardBorder,
            Thickness = 1,
            Transparency = 0.26
        })
        local iconLabel = CreateInstance("TextLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.fromOffset(24, 42),
            Text = icon,
            TextColor3 = lib.Theme.Text,
            TextSize = 14,
            ZIndex = 23
        })
        local textLabel = CreateInstance("TextLabel", {
            Parent = btn,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(34, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Text = text,
            TextColor3 = lib.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 23
        })

        lib:AddConnection(btn, "MouseEnter", function()
            CreateTween(btn, {BackgroundColor3 = lib.Theme.Hover}, 0.16)
        end)
        lib:AddConnection(btn, "MouseLeave", function()
            if not topButtonRecords[btn].Selected then
                CreateTween(btn, {BackgroundColor3 = lib.Theme.Glass}, 0.16)
            end
        end)

        topButtonRecords[btn] = {
            Button = btn,
            Icon = iconLabel,
            Label = textLabel,
            Stroke = stroke,
            Selected = false
        }
        return btn
    end

    local TopMainButton = CreateTopButton("Main", "⌂", 394, 113)
    local TopSettingsButton = CreateTopButton("Settings", "⚙", 526, 135)
    local TopThemeButton = CreateTopButton("Theme", "◉", 681, 128)

    TopMainButton.Position = UDim2.fromOffset(366, 28)
    TopMainButton.Size = UDim2.fromOffset(104, 42)
    TopSettingsButton.Position = UDim2.fromOffset(484, 28)
    TopSettingsButton.Size = UDim2.fromOffset(118, 42)
    TopThemeButton.Position = UDim2.fromOffset(616, 28)
    TopThemeButton.Size = UDim2.fromOffset(108, 42)
    topButtonRecords[TopMainButton].Icon.Text = "⌂"
    topButtonRecords[TopSettingsButton].Icon.Text = "⚙"
    topButtonRecords[TopThemeButton].Icon.Text = "◉"

    local function SetTopSelected(selectedButton)
        for button, record in pairs(topButtonRecords) do
            local selected = button == selectedButton
            record.Selected = selected
            CreateTween(button, {
                BackgroundColor3 = selected and lib.Theme.Selected or lib.Theme.Glass
            }, 0.16)
            CreateTween(record.Stroke, {
                Color = selected and lib.Theme.Accent or lib.Theme.CardBorder,
                Transparency = selected and 0.08 or 0.26
            }, 0.16)
            CreateTween(record.Icon, {
                TextColor3 = selected and lib.Theme.Accent or lib.Theme.Text
            }, 0.16)
            CreateTween(record.Label, {
                TextColor3 = selected and lib.Theme.Accent or lib.Theme.Text
            }, 0.16)
        end
    end
    SetTopSelected(TopMainButton)

    local Profile = CreateInstance("Frame", {
        Parent = Top,
        BackgroundColor3 = lib.Theme.Glass,
        BackgroundTransparency = 0.05,
        Position = UDim2.fromOffset(1361, 18),
        Size = UDim2.fromOffset(238, 62),
        ZIndex = 22
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Profile})
    CreateInstance("UIStroke", {
        Parent = Profile,
        Color = lib.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.2
    })

    local ProfileAvatar = CreateInstance("ImageLabel", {
        Parent = Profile,
        BackgroundColor3 = lib.Theme.Selected,
        Image = localPlayer and ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150") or "",
        Position = UDim2.fromOffset(7, 7),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromOffset(48, 48),
        ZIndex = 23
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ProfileAvatar})
    local ProfileAvatarStroke = CreateInstance("UIStroke", {
        Parent = ProfileAvatar,
        Color = lib.Theme.Accent,
        Thickness = 1.6,
        Transparency = 0.1
    })
    lib:BindTheme(ProfileAvatarStroke, "Color", "Accent")

    CreateInstance("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(67, 10),
        Size = UDim2.fromOffset(82, 20),
        Text = localPlayer and localPlayer.DisplayName or "VanguardHub",
        TextColor3 = lib.Theme.Text,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 23
    })
    local ProfileVersion = CreateInstance("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(67, 31),
        Size = UDim2.fromOffset(72, 16),
        Text = "v1.0",
        TextColor3 = lib.Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 23
    })
    lib:BindTheme(ProfileVersion, "TextColor3", "Accent")

    local function CreateWindowButton(text, x)
        local button = CreateInstance("TextButton", {
            Parent = Profile,
            AutoButtonColor = false,
            BackgroundColor3 = lib.Theme.Glass,
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(x, 9),
            Size = UDim2.fromOffset(34, 44),
            Text = text,
            TextColor3 = lib.Theme.Text,
            TextSize = 22,
            ZIndex = 24
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = button})
        CreateInstance("UIStroke", {
            Parent = button,
            Color = lib.Theme.CardBorder,
            Thickness = 1,
            Transparency = 0.32
        })
        ApplyHoverEffect(button, lib)
        return button
    end

    local MinimizeButton = CreateWindowButton("−", 244)
    local CloseButton = CreateWindowButton("×", 302)
    MinimizeButton.Position = UDim2.fromOffset(160, 9)
    CloseButton.Position = UDim2.fromOffset(197, 9)
    MinimizeButton.Text = "−"
    CloseButton.Text = "×"
    local minimized = false
    lib:AddConnection(MinimizeButton, "MouseButton1Click", function()
        local positionDelta = ((BASE_HEIGHT - 105) * MainScale.Scale) / 2
        local currentPosition = Main.Position
        minimized = not minimized
        task.defer(function()
            if MinimizeButton and MinimizeButton.Parent then
                MinimizeButton.Text = minimized and "+" or "−"
            end
        end)
        MinimizeButton.Text = minimized and "+" or "−"
        CreateTween(Main, {
            Position = UDim2.new(
                currentPosition.X.Scale,
                currentPosition.X.Offset,
                currentPosition.Y.Scale,
                currentPosition.Y.Offset + (minimized and -positionDelta or positionDelta)
            ),
            Size = UDim2.fromOffset(BASE_WIDTH, minimized and 105 or BASE_HEIGHT)
        }, 0.22, Enum.EasingStyle.Quart)
    end)
    lib:AddConnection(CloseButton, "MouseButton1Click", function()
        local closeAction = lib.Actions.Close
        if closeAction then
            SafeCallback(closeAction)
        else
            lib:Destroy()
        end
    end)

    local ThemePanel = CreateInstance("Frame", {
        Parent = Main,
        BackgroundColor3 = lib.Theme.Secondary,
        BackgroundTransparency = 0.02,
        Position = UDim2.fromOffset(616, 76),
        Size = UDim2.fromOffset(248, 76),
        Visible = false,
        ZIndex = 80
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 9), Parent = ThemePanel})
    CreateInstance("UIStroke", {
        Parent = ThemePanel,
        Color = lib.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.05
    })
    CreateInstance("TextLabel", {
        Parent = ThemePanel,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(12, 6),
        Size = UDim2.fromOffset(224, 18),
        Text = "COR DE DESTAQUE",
        TextColor3 = lib.Theme.TextDim,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 81
    })

    local themeChoices = {
        {"dark_purple", Color3.fromRGB(128, 94, 245), Color3.fromRGB(49, 38, 93)},
        {"dark_blue", Color3.fromRGB(67, 165, 255), Color3.fromRGB(27, 57, 91)},
        {"dark_red", Color3.fromRGB(241, 82, 96), Color3.fromRGB(84, 31, 39)},
        {"dark_green", Color3.fromRGB(70, 196, 116), Color3.fromRGB(26, 73, 46)},
        {"dark_gold", Color3.fromRGB(239, 177, 58), Color3.fromRGB(84, 61, 24)}
    }

    for index, choice in ipairs(themeChoices) do
        local swatch = CreateInstance("TextButton", {
            Parent = ThemePanel,
            AutoButtonColor = false,
            BackgroundColor3 = choice[2],
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(14 + ((index - 1) * 44), 31),
            Size = UDim2.fromOffset(32, 32),
            Text = "",
            ZIndex = 81
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = swatch})
        CreateInstance("UIStroke", {
            Parent = swatch,
            Color = Color3.fromRGB(235, 235, 235),
            Thickness = 1,
            Transparency = 0.42
        })
        lib:AddConnection(swatch, "MouseButton1Click", function()
            lib.Theme.Accent = choice[2]
            lib.Theme.Selected = choice[3]
            lib.Theme.AccentDark = choice[3]
            lib:ApplyThemeBindings()
            ThemePanel.Visible = false
            SetTopSelected(TopMainButton)
            lib:SetFlag("Theme", choice[1])
            if lib.Actions.ThemeChanged then
                SafeCallback(lib.Actions.ThemeChanged, choice[1])
            end
        end)
    end

    lib:AddConnection(TopThemeButton, "MouseButton1Click", function()
        ThemePanel.Visible = not ThemePanel.Visible
        SetTopSelected(ThemePanel.Visible and TopThemeButton or TopMainButton)
    end)
    
    -- FIXED: Drag System connected to Top only
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    lib:AddConnection(Top, "InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            local relativeX = input.Position.X - Top.AbsolutePosition.X
            if relativeX > (360 * MainScale.Scale) then return end
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    lib:AddConnection(UserInputService, "InputEnded", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    lib:AddConnection(UserInputService, "InputChanged", function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- ============================================================
    -- VISIBILITY TOGGLE SYSTEM
    -- ============================================================
    
    local toggleKey = "RightShift"
    local isVisible = true
    local toggleConnection = nil
    local isBindingKey = false
    
    local function UpdateVisibility()
        Main.Visible = isVisible
    end
    
    local function ConnectToggleKey()
        if toggleConnection then
            lib:RemoveConnection(toggleConnection)
            toggleConnection = nil
        end
        
        toggleConnection = lib:AddConnection(UserInputService, "InputBegan", function(input, gameProcessed)
            if gameProcessed then return end
            if isBindingKey then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            
            local targetKey = Enum.KeyCode[toggleKey]
            if not targetKey or input.KeyCode ~= targetKey then return end
            
            -- FIXED: Use UserInputService:GetFocusedTextBox()
            local focusedTextBox = UserInputService:GetFocusedTextBox()
            if focusedTextBox then return end
            
            isVisible = not isVisible
            UpdateVisibility()
        end)
    end
    
    ConnectToggleKey()
    
    local sidebarWidth = 320

    -- Tab Background
    local TabBG = CreateInstance("Frame", {
        Parent = Main,
        BackgroundColor3 = lib.Theme.Glass,
        BackgroundTransparency = 0.04,
        Size = UDim2.fromOffset(sidebarWidth, 500),
        Position = UDim2.fromOffset(17, 102),
        ZIndex = 10
    })
    lib:TrackInstance(TabBG)

    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBG})
    CreateInstance("UIStroke", {
        Parent = TabBG,
        Color = lib.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.12
    })

    local CategoriesTitle = CreateInstance("TextLabel", {
        Parent = TabBG,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -28, 0, 24),
        Position = UDim2.fromOffset(16, 8),
        Font = Enum.Font.GothamMedium,
        Text = "CATEGORIES",
        TextColor3 = lib.Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11
    })
    lib:BindTheme(CategoriesTitle, "TextColor3", "Accent")
    
    -- Tab Holder
    local TabHolder = CreateInstance("ScrollingFrame", {
        Parent = TabBG,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(280, 456),
        Position = UDim2.fromOffset(10, 34),
        ScrollBarThickness = 0,
        ScrollBarImageColor3 = lib.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarImageTransparency = 1,
        ZIndex = 11
    })
    lib:TrackInstance(TabHolder)
    
    local TabHolderLL = CreateInstance("UIListLayout", {
        Parent = TabHolder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3)
    })
    
    lib:AddPropertyConnection(TabHolderLL, "AbsoluteContentSize", function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolderLL.AbsoluteContentSize.Y + 8)
    end)

    local Credits = CreateInstance("Frame", {
        Parent = Main,
        BackgroundColor3 = lib.Theme.Glass,
        BackgroundTransparency = 0.04,
        Position = UDim2.fromOffset(17, 608),
        Size = UDim2.fromOffset(300, 165),
        ZIndex = 10
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Credits})
    CreateInstance("UIStroke", {
        Parent = Credits,
        Color = lib.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.12
    })
    local CreditsTitle = CreateInstance("TextLabel", {
        Parent = Credits,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(18, 10),
        Size = UDim2.fromOffset(264, 28),
        Text = "CREDITS",
        TextColor3 = lib.Theme.Accent,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11
    })
    lib:BindTheme(CreditsTitle, "TextColor3", "Accent")

    local creditRows = {
        {"Owner:", "₳ĐⱤł₳₦Ø"},
        {"UI & Architecture:", "Vanguard Team"},
        {"Version:", "v1.0"}
    }
    for index, row in ipairs(creditRows) do
        CreateInstance("TextLabel", {
            Parent = Credits,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(18, 48 + ((index - 1) * 32)),
            Size = UDim2.fromOffset(128, 24),
            Text = row[1],
            TextColor3 = lib.Theme.TextDim,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11
        })
        local valueLabel = CreateInstance("TextLabel", {
            Parent = Credits,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(150, 48 + ((index - 1) * 32)),
            Size = UDim2.fromOffset(132, 24),
            Text = row[2],
            TextColor3 = lib.Theme.Accent,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11
        })
        lib:BindTheme(valueLabel, "TextColor3", "Accent")
    end
    
    -- Content Area
    local ContentArea = CreateInstance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(1250, 640),
        Position = UDim2.fromOffset(346, 102),
        ClipsDescendants = true,
        ZIndex = 10
    })
    lib:TrackInstance(ContentArea)

    local Footer = CreateInstance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(346, 736),
        Size = UDim2.fromOffset(1276, 34),
        ZIndex = 15
    })

    local function CopyDiscord()
        local copy = rawget(_G, "setclipboard")
        if type(copy) == "function" then
            pcall(copy, "dsc.gg/VanguardHub")
        else
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "VanguardHub",
                    Text = "Discord: dsc.gg/VanguardHub",
                    Duration = 4
                })
            end)
        end
    end

    local function CreateFooterButton(text, icon, x, width, callback)
        local buttonText = text
        if type(icon) == "string" and icon ~= "" then
            buttonText = icon .. "   " .. text
        end
        local button = CreateInstance("TextButton", {
            Parent = Footer,
            AutoButtonColor = false,
            BackgroundColor3 = lib.Theme.Glass,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamMedium,
            Position = UDim2.fromOffset(x, 0),
            Size = UDim2.fromOffset(width, 34),
            Text = buttonText,
            TextColor3 = lib.Theme.Text,
            TextSize = 13,
            ZIndex = 16
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = button})
        CreateInstance("UIStroke", {
            Parent = button,
            Color = lib.Theme.CardBorder,
            Thickness = 1,
            Transparency = 0.22
        })
        ApplyHoverEffect(button, lib)
        lib:AddConnection(button, "MouseButton1Click", function()
            SafeCallback(callback)
        end)
        return button
    end

    CreateFooterButton("Discord", "", 1130, 110, CopyDiscord)

    -- ============================================================
    -- TAB SYSTEM
    -- ============================================================
    
    local Tabs = {
        Theme = lib.Theme,
        Assets = lib.Assets
    }
    local currentTab = nil
    local allTabButtons = {}
    local allTabContents = {}
    local tabRegistry = {}

    local function SelectTopButtonForCurrentTab()
        for _, record in pairs(tabRegistry) do
            if record.Holder == currentTab then
                if string.lower(tostring(record.Id)) == "settings" then
                    SetTopSelected(TopSettingsButton)
                else
                    SetTopSelected(TopMainButton)
                end
                return
            end
        end

        SetTopSelected(TopMainButton)
    end

    local sidebarOrder = {
        Home = 1,
        Player = 2,
        World = 3,
        Teleports = 4,
        Wood = 5,
        Dupe = 6,
        Build = 7,
        Vehicle = 8,
        Item = 9,
        Slot = 10,
        Autobuy = 11,
        Sorter = 12,
        Troll = 13,
        Fun = 14
    }

    local sidebarLabels = {
        Wood = "Wood / Mod Wood",
        Build = "Auto Build"
    }

    local function CreateComingSoonRow(label, icon, order)
        local button = CreateInstance("TextButton", {
            Parent = TabHolder,
            AutoButtonColor = false,
            BackgroundColor3 = lib.Theme.Main,
            BackgroundTransparency = 0.82,
            BorderSizePixel = 0,
            LayoutOrder = order,
            Size = UDim2.new(1, 0, 0, 32),
            Text = "",
            ZIndex = 12
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = button})
        CreateInstance("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.fromOffset(22, 32),
            Text = icon,
            TextColor3 = lib.Theme.TextDim,
            TextSize = 15,
            ZIndex = 13
        })
        CreateInstance("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(42, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Text = label,
            TextColor3 = lib.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        })
        lib:AddConnection(button, "MouseButton1Click", function()
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = label,
                    Text = "Esta categoria chega em breve.",
                    Duration = 3
                })
            end)
        end)
    end

    CreateComingSoonRow("Troll", "☺", 13)
    CreateComingSoonRow("Fun", "✧", 14)
    
    function Tabs:Tab(name, icon, options)
        options = options or {}
        local id = options.id or name
        local displayName = options.displayName or sidebarLabels[name] or name
        local sidebarVisible = options.sidebar ~= false and name ~= "Settings"
        local TabBtn = CreateInstance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = lib.Theme.Main,
            BackgroundTransparency = 0.82,
            Size = sidebarVisible and UDim2.new(1, 0, 0, 32) or UDim2.fromOffset(0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            AutoButtonColor = false,
            BorderSizePixel = 0,
            LayoutOrder = sidebarOrder[name] or 100,
            Visible = sidebarVisible,
            ZIndex = 12,
            Text = "",
            ClipsDescendants = true
        })
        lib:TrackInstance(TabBtn)
        table.insert(allTabButtons, TabBtn)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabBtn
        })

        local TabStroke = CreateInstance("UIStroke", {
            Name = "TabStroke",
            Parent = TabBtn,
            Color = lib.Theme.CardBorder,
            Thickness = 1,
            Transparency = 1
        })
        
        local TabIndicator = CreateInstance("Frame", {
            Name = "Indicator",
            Parent = TabBtn,
            BackgroundColor3 = lib.Theme.Accent,
            Size = UDim2.new(0, 3, 1, -10),
            Position = UDim2.new(0, 0, 0, 5),
            BackgroundTransparency = 1,
            ZIndex = 13
        })
        lib:BindTheme(TabIndicator, "BackgroundColor3", "Accent")
        
        if icon then
            CreateInstance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Name = "TabIcon",
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 12, 0.5, -9),
                Image = "rbxassetid://" .. icon,
                ImageColor3 = lib.Theme.TextDim,
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = 13
            })
        end
        
        local TabText = CreateInstance("TextLabel", {
            Name = "TabText",
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, icon and -52 or -20, 1, 0),
            Position = UDim2.new(0, icon and 42 or 12, 0, 0),
            Font = Enum.Font.Gotham,
            Text = displayName,
            TextColor3 = lib.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13
        })
        
        local Holder = CreateInstance("ScrollingFrame", {
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromOffset(0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = lib.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarImageTransparency = 0.28,
            ZIndex = 11
        })
        lib:TrackInstance(Holder)
        table.insert(allTabContents, Holder)
        
        local HolderLL = CreateInstance("UIListLayout", {
            Parent = Holder,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12)
        })
        
        lib:AddPropertyConnection(HolderLL, "AbsoluteContentSize", function()
            Holder.CanvasSize = UDim2.new(0, 0, 0, HolderLL.AbsoluteContentSize.Y + 20)
        end)
        
        lib:AddConnection(TabBtn, "MouseEnter", function()
            if currentTab ~= Holder then
                CreateTween(TabBtn, {BackgroundTransparency = 0.64}, 0.15)
            end
        end)
        
        lib:AddConnection(TabBtn, "MouseLeave", function()
            if currentTab ~= Holder then
                CreateTween(TabBtn, {BackgroundTransparency = 0.82}, 0.15)
            end
        end)
        
        local function ActivateTab()
            for _, btn in ipairs(allTabButtons) do
                CreateTween(btn, {BackgroundColor3 = lib.Theme.Main, BackgroundTransparency = 0.82}, 0.2)
                local ind = btn:FindFirstChild("Indicator")
                if ind then CreateTween(ind, {BackgroundTransparency = 1}, 0.2) end
                local txt = btn:FindFirstChild("TabText")
                if txt then CreateTween(txt, {TextColor3 = lib.Theme.Text}, 0.2) end
                local ico = btn:FindFirstChild("TabIcon")
                if ico then CreateTween(ico, {ImageColor3 = lib.Theme.TextDim}, 0.2) end
                local stroke = btn:FindFirstChild("TabStroke")
                if stroke then CreateTween(stroke, {Transparency = 1}, 0.2) end
            end
            
            CreateTween(TabBtn, {BackgroundColor3 = lib.Theme.Selected, BackgroundTransparency = 0}, 0.2)
            CreateTween(TabIndicator, {BackgroundTransparency = 0}, 0.2)
            CreateTween(TabText, {TextColor3 = lib.Theme.Text}, 0.2)
            CreateTween(TabStroke, {Color = lib.Theme.Accent, Transparency = 0.08}, 0.2)
            local activeIcon = TabBtn:FindFirstChild("TabIcon")
            if activeIcon then CreateTween(activeIcon, {ImageColor3 = lib.Theme.Accent}, 0.2) end
            
            for _, content in ipairs(allTabContents) do
                content.Visible = false
            end
            
            Holder.Visible = true
            currentTab = Holder
            lib.CurrentTab = Holder
            ThemePanel.Visible = false
            if name == "Settings" then
                SetTopSelected(TopSettingsButton)
            else
                SetTopSelected(TopMainButton)
            end
        end

        local tabRecord = {
            Id = id,
            Name = name,
            DisplayName = displayName,
            Button = TabBtn,
            Holder = Holder,
            Activate = ActivateTab
        }
        tabRegistry[string.lower(tostring(id))] = tabRecord
        tabRegistry[string.lower(tostring(name))] = tabRecord
        tabRegistry[string.lower(tostring(displayName))] = tabRecord

        lib:AddConnection(TabBtn, "MouseButton1Click", ActivateTab)

        if name == "Home" then
            lib:AddConnection(TopMainButton, "MouseButton1Click", ActivateTab)
        elseif name == "Settings" then
            lib:AddConnection(TopSettingsButton, "MouseButton1Click", ActivateTab)
        end
        
        if not currentTab then
            TabBtn.BackgroundColor3 = lib.Theme.Selected
            TabBtn.BackgroundTransparency = 0
            TabIndicator.BackgroundTransparency = 0
            TabText.TextColor3 = lib.Theme.Text
            TabStroke.Color = lib.Theme.Accent
            TabStroke.Transparency = 0.08
            local initialIcon = TabBtn:FindFirstChild("TabIcon")
            if initialIcon then initialIcon.ImageColor3 = lib.Theme.Accent end
            Holder.Visible = true
            currentTab = Holder
            lib.CurrentTab = Holder
        end
        
        -- ============================================================
        -- SECTION SYSTEM
        -- ============================================================
        
        local Sections = {}
        local sectionControllers = {}

        function Sections:Title(text)
            local Title = CreateInstance("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Font = Enum.Font.GothamBold,
                Text = text,
                TextColor3 = lib.Theme.Text,
                TextSize = 21,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                ZIndex = 1
            })
            lib:TrackInstance(Title)
            return Title
        end

        function Sections:Canvas(height)
            local Canvas = CreateInstance("Frame", {
                Name = "DashboardCanvas",
                Parent = Holder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, height or 770),
                ZIndex = 12
            })
            lib:TrackInstance(Canvas)
            Holder.ScrollBarThickness = 0
            Holder.ScrollingEnabled = false
            Holder.CanvasPosition = Vector2.new(0, 0)
            return Canvas
        end

        function Sections:GetContainer()
            return Holder
        end
        
        function Sections:Section(name, defaultOpen)
            local Section = CreateInstance("Frame", {
                Parent = Holder,
                BackgroundColor3 = lib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 42),
                ClipsDescendants = true,
                ZIndex = 1
            })
            lib:TrackInstance(Section)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = Section
            })

            CreateInstance("UIStroke", {
                Parent = Section,
                Color = lib.Theme.CardBorder,
                Thickness = 1,
                Transparency = 0.08
            })
            
            local SectionTitle = CreateInstance("TextButton", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 42),
                Font = Enum.Font.GothamBold,
                Text = "   " .. name,
                TextColor3 = lib.Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = 2
            })
            
            lib:AddConnection(SectionTitle, "MouseEnter", function()
                CreateTween(SectionTitle, {TextColor3 = lib.Theme.Accent}, 0.15)
            end)
            
            lib:AddConnection(SectionTitle, "MouseLeave", function()
                CreateTween(SectionTitle, {TextColor3 = lib.Theme.Text}, 0.15)
            end)
            
            local SectionArrow = CreateInstance("TextLabel", {
                Parent = SectionTitle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -32, 0, 10),
                Font = Enum.Font.GothamBold,
                Text = "▶",
                TextColor3 = lib.Theme.TextDim,
                TextSize = 13,
                ZIndex = 3
            })
            
            local SectionContent = CreateInstance("Frame", {
                Parent = Section,
                BackgroundTransparency = 1,
                Name = "SectionContent",
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 12, 0, 46),
                ZIndex = 1
            })
            
            local SectionContentLL = CreateInstance("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            local open = defaultOpen == true
            SectionArrow.Text = open and "▼" or "▶"
            
            local function UpdateSize()
                if open then
                    local contentSize = SectionContentLL.AbsoluteContentSize.Y
                    CreateTween(Section, {Size = UDim2.new(1, 0, 0, 46 + contentSize + 14)}, 0.3)
                else
                    CreateTween(Section, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
                end
            end
            
            local controller = {}
            
            function controller:SetOpen(value)
                open = value
                if open then
                    UpdateSize()
                    SectionArrow.Text = "▼"
                else
                    CreateTween(Section, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
                    SectionArrow.Text = "▶"
                end
            end
            
            function controller:IsOpen()
                return open
            end
            
            function controller:GetSection()
                return Section
            end
            
            table.insert(sectionControllers, controller)
            
            if open then
                task.spawn(function()
                    task.wait()
                    controller:SetOpen(true)
                end)
            end
            
            lib:AddPropertyConnection(SectionContentLL, "AbsoluteContentSize", function()
                if open then UpdateSize() end
            end)
            
            lib:AddConnection(SectionTitle, "MouseButton1Click", function()
                controller:SetOpen(not controller:IsOpen())
            end)
            
            -- ============================================================
            -- ELEMENTS
            -- ============================================================
            
            local Elements = {}
            
            function Elements:Label(text, options)
                options = options or {}
                local Label = CreateInstance("TextLabel", {
                    Parent = SectionContent,
                    BackgroundTransparency = 1,
                    Size = options.Size or UDim2.new(1, 0, 0, options.Height or ELEMENT_SIZES.Label.Y.Offset),
                    Font = options.Font or Enum.Font.GothamMedium,
                    Text = options.NoPadding and text or "  " .. text,
                    TextColor3 = options.Color or lib.Theme.TextDim,
                    TextSize = options.TextSize or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = options.TextYAlignment or Enum.TextYAlignment.Center,
                    ZIndex = 1
                })
                return Label
            end
            
            function Elements:Button(text, callback)
                local Btn = CreateInstance("TextButton", {
                    Parent = SectionContent,
                    BackgroundColor3 = lib.Theme.Main,
                    Size = ELEMENT_SIZES.Button,
                    AutoButtonColor = false,
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                lib:TrackInstance(Btn)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Btn
                })

                CreateInstance("UIStroke", {
                    Parent = Btn,
                    Color = lib.Theme.CardBorder,
                    Thickness = 1,
                    Transparency = 0.35
                })
                
                ApplyHoverEffect(Btn, lib)
                
                lib:AddConnection(Btn, "MouseButton1Click", function()
                    SafeCallback(callback)
                end)
                
                return Btn
            end
            
            function Elements:Toggle(text, flag, default, callback)
                local Toggle = Elements:Button(text, nil)
                Toggle.Size = ELEMENT_SIZES.Toggle
                Toggle.Text = "  " .. text
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                
                local TogBtn = CreateInstance("TextButton", {
                    Parent = Toggle,
                    BackgroundColor3 = lib.Theme.Tertiary,
                    Size = UDim2.new(0, 38, 0, 20),
                    Position = UDim2.new(1, -42, 0.5, -10),
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    Text = ""
                })
                lib:TrackInstance(TogBtn)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = TogBtn
                })
                
                local TogInner = CreateInstance("Frame", {
                    Parent = TogBtn,
                    BackgroundColor3 = lib.Theme.Text,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 2, 0, 2),
                    ZIndex = 3
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = TogInner
                })
                
                local controller = {}
                local state = false
                lib:SetFlag(flag, state)
                
                local function SetState(s, skipCallback, skipBroadcast)
                    if s == nil then s = not state end
                    s = s == true
                    local changed = s ~= state
                    state = s
                    
                    if state then
                        CreateTween(TogBtn, {BackgroundColor3 = lib.Theme.Accent}, 0.2)
                        CreateTween(TogInner, {Position = UDim2.new(1, -18, 0, 2)}, 0.2)
                    else
                        CreateTween(TogBtn, {BackgroundColor3 = lib.Theme.Tertiary}, 0.2)
                        CreateTween(TogInner, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                    end
                    
                    lib:SetFlag(flag, state)
                    if changed and not skipCallback then
                        SafeCallback(callback, state)
                    end
                    if not skipBroadcast then
                        lib:BroadcastFlag(flag, state, controller, changed and not skipCallback)
                    end
                end

                controller.SetState = function(first, second, third)
                    if first == controller then
                        SetState(second, third)
                    else
                        SetState(first, second)
                    end
                end
                controller.GetState = function()
                    return state
                end
                controller._ReceiveShared = function(_, value, triggerCallback)
                    SetState(value, not triggerCallback, true)
                end
                lib:RegisterFlagControl(flag, controller)
                
                if default then
                    SetState(true)
                end
                
                lib:AddConnection(Toggle, "MouseButton1Click", function()
                    SetState()
                end)

                lib:AddConnection(TogBtn, "MouseButton1Click", function()
                    SetState()
                end)
                return controller
            end
            
            function Elements:Slider(text, flag, default, min, max, precise, callback)
                local Slider = Elements:Button("", nil)
                Slider.Size = ELEMENT_SIZES.Slider
                Slider.AutoButtonColor = false
                
                CreateInstance("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0.02, 0, 0, 2),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })
                
                local Value = CreateInstance("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.2, 0, 0, 20),
                    Position = UDim2.new(0.78, 0, 0, 2),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default or min),
                    TextColor3 = lib.Theme.Accent,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 2
                })
                
                local BarBG = CreateInstance("Frame", {
                    Parent = Slider,
                    BackgroundColor3 = lib.Theme.Tertiary,
                    Size = UDim2.new(0.96, 0, 0, 4),
                    Position = UDim2.new(0.02, 0, 0, 32),
                    ZIndex = 2
                })
                lib:TrackInstance(BarBG)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = BarBG
                })
                
                local Bar = CreateInstance("Frame", {
                    Parent = BarBG,
                    BackgroundColor3 = lib.Theme.Accent,
                    Size = UDim2.new(0, 0, 0, 4),
                    ZIndex = 3
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Bar
                })
                
                local value = default or min
                lib:SetFlag(flag, value)
                
                local lastCallback = 0
                local callbackThrottle = 0.05
                
                local funcs
                funcs = {
                    SetValue = function(self, v, skipCallback, skipBroadcast)
                        local percent
                        if v then
                            percent = (v - min) / (max - min)
                        elseif BarBG.AbsoluteSize.X > 0 then
                            local mousePos = UserInputService:GetMouseLocation()
                            percent = (mousePos.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X
                        else
                            percent = 0
                        end
                        
                        percent = math.clamp(percent, 0, 1)
                        
                        if precise then
                            v = tonumber(string.format("%.1f", min + (max - min) * percent))
                        else
                            v = math.floor(min + (max - min) * percent)
                        end
                        
                        value = v
                        Value.Text = tostring(v)
                        CreateTween(Bar, {Size = UDim2.new(percent, 0, 0, 4)}, 0.05)
                        
                        lib:SetFlag(flag, value)
                        
                        if not skipCallback and callback then
                            local now = tick()
                            if now - lastCallback >= callbackThrottle then
                                lastCallback = now
                                SafeCallback(callback, value)
                            end
                        end

                        if not skipBroadcast then
                            lib:BroadcastFlag(flag, value, funcs, not skipCallback)
                        end
                    end
                }

                funcs._ReceiveShared = function(_, sharedValue, triggerCallback)
                    funcs:SetValue(sharedValue, not triggerCallback, true)
                end
                lib:RegisterFlagControl(flag, funcs)
                
                funcs:SetValue(default or min, true, true)
                
                local sliderDragging = false
                
                lib:AddConnection(BarBG, "InputBegan", function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                       input.UserInputType == Enum.UserInputType.Touch then
                        funcs:SetValue()
                        sliderDragging = true
                    end
                end)

                lib:AddConnection(Slider, "InputBegan", function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or
                       input.UserInputType == Enum.UserInputType.Touch then
                        funcs:SetValue()
                        sliderDragging = true
                    end
                end)
                
                lib:AddConnection(UserInputService, "InputEnded", function(input)
                    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                                          input.UserInputType == Enum.UserInputType.Touch) then
                        sliderDragging = false
                        SafeCallback(callback, value)
                    end
                end)
                
                lib:AddConnection(UserInputService, "InputChanged", function(input)
                    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                          input.UserInputType == Enum.UserInputType.Touch) then
                        funcs:SetValue()
                    end
                end)
                
                return funcs
            end
            
            function Elements:Dropdown(text, flag, options, callback)
                -- FIXED: Dropdown expands Section height instead of overlapping
                local Dropdown = CreateInstance("Frame", {
                    Parent = SectionContent,
                    BackgroundColor3 = lib.Theme.Main,
                    Size = ELEMENT_SIZES.Dropdown,
                    ClipsDescendants = false,
                    ZIndex = 10
                })
                lib:TrackInstance(Dropdown)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Dropdown
                })
                
                local DropBtn = CreateInstance("TextButton", {
                    Parent = Dropdown,
                    BackgroundColor3 = lib.Theme.Main,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    Font = Enum.Font.GothamMedium,
                    Text = "",
                    BorderSizePixel = 0,
                    ZIndex = 11
                })
                
                CreateInstance("TextLabel", {
                    Parent = DropBtn,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0.02, 0, 0, 7),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 12
                })
                
                local Selected = CreateInstance("TextLabel", {
                    Parent = DropBtn,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.4, 0, 0, 20),
                    Position = UDim2.new(0.56, 0, 0, 7),
                    Font = Enum.Font.GothamMedium,
                    Text = options[1] or "Select",
                    TextColor3 = lib.Theme.TextDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 12
                })
                
                local Arrow = CreateInstance("TextLabel", {
                    Parent = DropBtn,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -22, 0, 7),
                    Font = Enum.Font.GothamBold,
                    Text = "▼",
                    TextColor3 = lib.Theme.TextDim,
                    TextSize = 12,
                    ZIndex = 12
                })
                
                local DropdownContent = CreateInstance("ScrollingFrame", {
                    Parent = Dropdown,
                    BackgroundColor3 = lib.Theme.Main,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 34),
                    ClipsDescendants = true,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    ZIndex = 10
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = DropdownContent
                })
                
                local DropdownContentLL = CreateInstance("UIListLayout", {
                    Parent = DropdownContent,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                lib:AddPropertyConnection(DropdownContentLL, "AbsoluteContentSize", function()
                    DropdownContent.CanvasSize = UDim2.new(0, 0, 0, DropdownContentLL.AbsoluteContentSize.Y + 6)
                end)
                
                local open = false
                local selected = options[1] or ""
                local controller = {}
                lib:SetFlag(flag, selected)
                
                local dropdownConnections = {}
                
                local function CreateOption(option)
                    local OptionBtn = CreateInstance("TextButton", {
                        Parent = DropdownContent,
                        BackgroundColor3 = lib.Theme.Secondary,
                        Size = UDim2.new(1, -10, 0, 26),
                        Position = UDim2.new(0, 5, 0, 0),
                        Font = Enum.Font.GothamMedium,
                        Text = option,
                        TextColor3 = lib.Theme.Text,
                        TextSize = 11,
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        ZIndex = 11,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    })
                    
                    CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = OptionBtn
                    })
                    
                    ApplyHoverEffect(OptionBtn, lib)
                    
                    local conn = lib:AddConnection(OptionBtn, "MouseButton1Click", function()
                        controller:SetValue(option)
                        open = false
                        Dropdown.Size = ELEMENT_SIZES.Dropdown
                        CreateTween(DropdownContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        CreateTween(Arrow, {Rotation = 0}, 0.2)
                    end)
                    
                    table.insert(dropdownConnections, conn)
                    
                    return OptionBtn
                end
                
                local maxOptions = math.min(#options, 200)
                for i = 1, maxOptions do
                    CreateOption(options[i])
                end
                
                lib:AddConnection(DropBtn, "MouseButton1Click", function()
                    open = not open
                    if open then
                        local contentSize = DropdownContentLL.AbsoluteContentSize.Y
                        local expandedHeight = math.min(contentSize + 6, 200)
                        Dropdown.Size = UDim2.new(1, 0, 0, 34 + expandedHeight)
                        CreateTween(DropdownContent, {Size = UDim2.new(1, 0, 0, expandedHeight)}, 0.2)
                        CreateTween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Dropdown.Size = ELEMENT_SIZES.Dropdown
                        CreateTween(DropdownContent, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        CreateTween(Arrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                local function ApplyValue(value, skipCallback, skipBroadcast)
                    if value == nil then
                        return
                    end

                    local changed = value ~= selected
                    selected = value
                    Selected.Text = tostring(value)
                    lib:SetFlag(flag, selected)

                    if changed and not skipCallback then
                        SafeCallback(callback, selected)
                    end

                    if not skipBroadcast then
                        lib:BroadcastFlag(flag, selected, controller, changed and not skipCallback)
                    end
                end

                controller = {
                    SetOptions = function(self, newOptions)
                        for _, conn in ipairs(dropdownConnections) do
                            lib:RemoveConnection(conn)
                        end
                        dropdownConnections = {}
                        
                        for _, child in pairs(DropdownContent:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        
                        local maxNew = math.min(#newOptions, 200)
                        for i = 1, maxNew do
                            CreateOption(newOptions[i])
                        end
                    end,
                    GetValue = function() return selected end,
                    SetValue = function(self, value, skipCallback, skipBroadcast)
                        ApplyValue(value, skipCallback, skipBroadcast)
                    end
                }

                controller._ReceiveShared = function(_, value, triggerCallback)
                    ApplyValue(value, not triggerCallback, true)
                end

                lib:RegisterFlagControl(flag, controller)
                
                return controller
            end
            
            function Elements:Keybind(text, flag, default, callback)
                local Keybind = Elements:Button("", nil)
                Keybind.Size = ELEMENT_SIZES.Keybind
                Keybind.AutoButtonColor = false
                
                CreateInstance("TextLabel", {
                    Parent = Keybind,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Position = UDim2.new(0.02, 0, 0, 2),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })
                
                local KeyDisplay = CreateInstance("TextButton", {
                    Parent = Keybind,
                    BackgroundColor3 = lib.Theme.Tertiary,
                    Size = UDim2.new(0, 70, 0, 26),
                    Position = UDim2.new(0.7, 0, 0.5, -13),
                    Font = Enum.Font.GothamMedium,
                    Text = default or "None",
                    TextColor3 = lib.Theme.Text,
                    TextSize = 11,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    ZIndex = 2,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                lib:TrackInstance(KeyDisplay)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = KeyDisplay
                })
                
                ApplyHoverEffect(KeyDisplay, lib)
                
                local currentKey = default or "None"
                local controller = {}
                lib:SetFlag(flag, currentKey)
                
                local binding = false
                local bindingConnection = nil
                
                -- FIXED: Cancel binding safely
                local function CancelBinding()
                    binding = false
                    isBindingKey = false
                    KeyDisplay.Text = currentKey
                    if bindingConnection then
                        lib:RemoveConnection(bindingConnection)
                        bindingConnection = nil
                    end
                end
                
                local function ApplyKey(value, skipCallback, skipBroadcast)
                    if type(value) ~= "string" or value == "" then
                        return
                    end

                    local changed = value ~= currentKey
                    currentKey = value
                    KeyDisplay.Text = value
                    lib:SetFlag(flag, value)

                    if changed and not skipCallback then
                        SafeCallback(callback, value)
                    end

                    if not skipBroadcast then
                        lib:BroadcastFlag(flag, value, controller, changed and not skipCallback)
                    end
                end

                lib:AddConnection(KeyDisplay, "MouseButton1Click", function()
                    if binding then
                        CancelBinding()
                        return
                    end
                    
                    binding = true
                    isBindingKey = true
                    KeyDisplay.Text = "..."
                    
                    bindingConnection = lib:AddConnection(UserInputService, "InputBegan", function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        -- FIXED: Escape cancels binding
                        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
                            CancelBinding()
                            return
                        end
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode.Name
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                            currentKey = "MB1"
                        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                            currentKey = "MB2"
                        else
                            return
                        end
                        
                        ApplyKey(currentKey)
                        
                        binding = false
                        isBindingKey = false
                        if bindingConnection then
                            lib:RemoveConnection(bindingConnection)
                            bindingConnection = nil
                        end
                    end)
                end)
                
                controller = {
                    GetKey = function() return currentKey end,
                    SetKey = function(key, skipCallback, skipBroadcast)
                        ApplyKey(key, skipCallback, skipBroadcast)
                    end
                }

                controller._ReceiveShared = function(_, value, triggerCallback)
                    ApplyKey(value, not triggerCallback, true)
                end

                lib:RegisterFlagControl(flag, controller)

                return controller
            end
            
            function Elements:ColorPicker(text, flag, default, callback)
                local Picker = Elements:Button("", nil)
                Picker.Size = ELEMENT_SIZES.ColorPicker
                Picker.AutoButtonColor = false
                
                CreateInstance("TextLabel", {
                    Parent = Picker,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 0, 20),
                    Position = UDim2.new(0.02, 0, 0, 2),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })
                
                local ColorPreview = CreateInstance("Frame", {
                    Parent = Picker,
                    BackgroundColor3 = default or Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 30, 0, 26),
                    Position = UDim2.new(0.85, 0, 0.5, -13),
                    ZIndex = 2
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ColorPreview
                })
                
                CreateInstance("UIStroke", {
                    Parent = ColorPreview,
                    Color = lib.Theme.Border,
                    Thickness = 1
                })
                
                local currentColor = default or Color3.fromRGB(255, 255, 255)
                local controller = {}
                lib:SetFlag(flag, currentColor)
                
                local colors = {
                    Color3.fromRGB(255, 65, 65),
                    Color3.fromRGB(255, 150, 50),
                    Color3.fromRGB(255, 230, 50),
                    Color3.fromRGB(0, 230, 118),
                    Color3.fromRGB(0, 180, 255),
                    Color3.fromRGB(160, 60, 255),
                    Color3.fromRGB(255, 80, 180),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(150, 150, 150),
                    Color3.fromRGB(30, 30, 30),
                }
                
                local colorIndex = 1
                for i, color in ipairs(colors) do
                    if color == currentColor then
                        colorIndex = i
                        break
                    end
                end
                
                local function ApplyColor(color, skipCallback, skipBroadcast)
                    if typeof(color) ~= "Color3" then
                        return
                    end

                    local changed = color ~= currentColor
                    currentColor = color
                    CreateTween(ColorPreview, {BackgroundColor3 = currentColor}, 0.2)
                    lib:SetFlag(flag, currentColor)

                    if changed and not skipCallback then
                        SafeCallback(callback, currentColor)
                    end

                    if not skipBroadcast then
                        lib:BroadcastFlag(flag, currentColor, controller, changed and not skipCallback)
                    end
                end

                lib:AddConnection(Picker, "MouseButton1Click", function()
                    colorIndex = (colorIndex % #colors) + 1
                    ApplyColor(colors[colorIndex])
                end)
                
                controller = {
                    SetColor = function(color, skipCallback, skipBroadcast)
                        ApplyColor(color, skipCallback, skipBroadcast)
                    end,
                    GetColor = function() return currentColor end
                }

                controller._ReceiveShared = function(_, value, triggerCallback)
                    ApplyColor(value, not triggerCallback, true)
                end

                lib:RegisterFlagControl(flag, controller)

                return controller
            end
            
            function Elements:TextBox(text, flag, default, callback)
                local TextBox = Elements:Button("", nil)
                TextBox.Size = ELEMENT_SIZES.TextBox
                TextBox.AutoButtonColor = false
                
                CreateInstance("TextLabel", {
                    Parent = TextBox,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.35, 0, 0, 20),
                    Position = UDim2.new(0.02, 0, 0, 2),
                    Font = Enum.Font.GothamMedium,
                    Text = text,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })
                
                local Input = CreateInstance("TextBox", {
                    Parent = TextBox,
                    BackgroundColor3 = lib.Theme.Tertiary,
                    Size = UDim2.new(0.55, 0, 0, 28),
                    Position = UDim2.new(0.43, 0, 0.5, -14),
                    Font = Enum.Font.GothamMedium,
                    Text = default or "",
                    PlaceholderText = "Enter text...",
                    PlaceholderColor3 = lib.Theme.TextDim,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 11,
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    ClearTextOnFocus = false
                })
                lib:TrackInstance(Input)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = Input
                })
                
                lib:SetFlag(flag, default or "")
                
                lib:AddConnection(Input, "FocusLost", function(enterPressed)
                    lib:SetFlag(flag, Input.Text)
                    SafeCallback(callback, Input.Text)
                end)
                
                return {
                    GetValue = function() return Input.Text end,
                    SetValue = function(value)
                        Input.Text = value
                        lib:SetFlag(flag, value)
                    end
                }
            end
            
            function Elements:Paragraph(title, content)
                local Paragraph = CreateInstance("Frame", {
                    Parent = SectionContent,
                    BackgroundColor3 = lib.Theme.Secondary,
                    Size = ELEMENT_SIZES.Paragraph,
                    ZIndex = 1
                })
                lib:TrackInstance(Paragraph)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Paragraph
                })
                
                CreateInstance("TextLabel", {
                    Parent = Paragraph,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 0, 24),
                    Position = UDim2.new(0, 10, 0, 6),
                    Font = Enum.Font.GothamBold,
                    Text = title,
                    TextColor3 = lib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2
                })
                
                local ContentLabel = CreateInstance("TextLabel", {
                    Parent = Paragraph,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 15, 0, 30),
                    Font = Enum.Font.GothamMedium,
                    Text = content or "",
                    TextColor3 = lib.Theme.TextDim,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    LineHeight = 1.2,
                    ZIndex = 2
                })
                
                local baseWidth = 500
                local textSize = TextService:GetTextSize(
                    content or "",
                    11,
                    Enum.Font.GothamMedium,
                    Vector2.new(baseWidth, math.huge)
                )
                
                ContentLabel.Size = UDim2.new(1, -20, 0, textSize.Y + 10)
                Paragraph.Size = UDim2.new(1, 0, 0, textSize.Y + 46)
                
                return Paragraph
            end
            
            return Elements
        end
        
        return Sections
    end

    local configFlagAliases = {
        TreePriority = "TreeSize",
        MainColor = {"UI", "Colors", "Main"},
        SecondaryColor = {"UI", "Colors", "Secondary"},
        AccentColor = {"UI", "Colors", "Accent"},
        TextColor = {"UI", "Colors", "Text"}
    }

    local function ResolveConfigValue(config, flag)
        if type(config) ~= "table" or flag == nil then
            return nil, false
        end

        local directValue = config[flag]
        if directValue ~= nil then
            return directValue, true
        end

        if type(config.UI) == "table" and config.UI[flag] ~= nil then
            return config.UI[flag], true
        end

        local alias = configFlagAliases[flag]
        if type(alias) == "string" then
            local aliasValue = config[alias]
            if aliasValue ~= nil then
                return aliasValue, true
            end
        elseif type(alias) == "table" then
            local current = config
            for _, key in ipairs(alias) do
                if type(current) ~= "table" then
                    current = nil
                    break
                end
                current = current[key]
            end
            if current ~= nil then
                return current, true
            end
        end

        return nil, false
    end
    
    -- ============================================================
    -- PUBLIC API METHODS
    -- ============================================================

    function Tabs:SelectTab(id)
        if id == nil then return false end
        local record = tabRegistry[string.lower(tostring(id))]
        if not record then return false end
        record.Activate()
        return true
    end

    function Tabs:RegisterAction(name, callback)
        if type(name) ~= "string" or type(callback) ~= "function" then
            return false
        end
        lib.Actions[name] = callback
        return true
    end

    function Tabs:InvokeAction(name, ...)
        local callback = lib.Actions[name]
        if type(callback) ~= "function" then return false end
        SafeCallback(callback, ...)
        return true
    end

    function Tabs:BindTheme(instance, property, themeKey)
        return lib:BindTheme(instance, property, themeKey)
    end

    function Tabs:SetThemePanelVisible(visible)
        ThemePanel.Visible = visible == true
        if ThemePanel.Visible then
            SetTopSelected(TopThemeButton)
        else
            SelectTopButtonForCurrentTab()
        end
        return ThemePanel.Visible
    end

    function Tabs:OpenThemePanel()
        return self:SetThemePanelVisible(true)
    end

    function Tabs:RegisterFlagControl(flag, receiver)
        if not flag or type(receiver) ~= "function" then return nil end
        local controller = {}
        controller._ReceiveShared = function(_, value, triggerCallback)
            receiver(value, triggerCallback)
        end
        return lib:RegisterFlagControl(flag, controller)
    end

    function Tabs:BroadcastFlag(flag, value, source, triggerCallbacks)
        lib:BroadcastFlag(flag, value, source, triggerCallbacks)
    end

    function Tabs:ApplyConfig(config, options)
        options = options or {}
        if type(config) ~= "table" then
            return false
        end

        local triggerCallbacks = options.triggerCallbacks ~= false

        if type(config.Theme) == "string" then
            self:SetTheme(config.Theme)
        end

        local toggleKey = config.ToggleUI
        if type(toggleKey) ~= "string" and type(config.Keybinds) == "table" then
            toggleKey = config.Keybinds.ToggleUI
        end
        if type(toggleKey) == "string" then
            self:SetToggleKey(toggleKey)
        end

        local syncedFlags = {}
        for flag in pairs(lib.FlagControls) do
            local value, exists = ResolveConfigValue(config, flag)
            if exists then
                syncedFlags[flag] = true
                if lib.Flags[flag] ~= value then
                    lib:BroadcastFlag(flag, value, nil, triggerCallbacks)
                else
                    lib:SetFlag(flag, value)
                end
            end
        end

        for flag in pairs(lib.Flags) do
            if not syncedFlags[flag] then
                local value, exists = ResolveConfigValue(config, flag)
                if exists then
                    lib:SetFlag(flag, value)
                end
            end
        end

        return true
    end

    function Tabs:SetTheme(themeName)
        local normalized = string.lower(tostring(themeName or "dark_purple"))
        local aliases = {
            ["dark roxo"] = "dark_purple",
            ["dark blue"] = "dark_blue",
            ["dark red"] = "dark_red",
            ["dark green"] = "dark_green",
            ["dark gold"] = "dark_gold",
            ["light"] = "dark_purple"
        }
        normalized = aliases[normalized] or normalized

        for _, choice in ipairs(themeChoices) do
            if choice[1] == normalized then
                lib.Theme.Accent = choice[2]
                lib.Theme.Selected = choice[3]
                lib.Theme.AccentDark = choice[3]
                lib:SetFlag("Theme", normalized)
                lib:ApplyThemeBindings()

                for _, record in pairs(tabRegistry) do
                    if record.Holder == currentTab then
                        record.Activate()
                        break
                    end
                end
                return true
            end
        end

        return false
    end

    function Tabs:SetFlag(flag, value)
        lib:SetFlag(flag, value)
    end

    function Tabs:GetFlag(flag)
        return lib:GetFlag(flag)
    end
    
    function Tabs:Destroy()
        return lib:Destroy()
    end
    
    function Tabs:SetVisible(visible)
        isVisible = visible
        UpdateVisibility()
    end
    
    function Tabs:ToggleVisibility()
        isVisible = not isVisible
        UpdateVisibility()
    end
    
    function Tabs:SetToggleKey(key)
        if type(key) ~= "string" then return end
        
        local keyCode = Enum.KeyCode[key]
        if not keyCode then
            warn("[Vanguard Library] Invalid toggle key:", key)
            return
        end
        
        toggleKey = key
        ConnectToggleKey()
    end
    
    function Tabs:GetToggleKey()
        return toggleKey
    end
    
    function Tabs:IsVisible()
        return isVisible
    end
    
    return Tabs
end

return Library