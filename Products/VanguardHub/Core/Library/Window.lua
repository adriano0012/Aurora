local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]
local Sidebar = Registry["Core/Library/Sidebar"]
local Topbar = Registry["Core/Library/Topbar"]
local Tabs = Registry["Core/Library/Tabs"]

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Library = {
    Flags = {},
    CurrentTab = nil,
    Connections = {},
    Instances = {},
    ScreenGui = nil,
    Actions = {},
    FlagControls = {},
    ThemeBindings = {},
    ThemeCatalog = {},
    ActiveThemeName = "Dark",
    Options = {
        Subtitle = "Universal",
        Background = nil
    },
    Theme = {},
    Assets = {
        Background = nil
    }
}

function Library:TrackInstance(instance)
    table.insert(self.Instances, instance)
    return instance
end

function Library:AddConnection(obj, eventName, callback)
    local member = obj[eventName]
    local connection

    if typeof(member) == "RBXScriptSignal" then
        connection = member:Connect(callback)
    else
        connection = obj:GetPropertyChangedSignal(eventName):Connect(callback)
    end

    table.insert(self.Connections, connection)
    return connection
end

function Library:AddPropertyConnection(obj, property, callback)
    local connection = obj:GetPropertyChangedSignal(property):Connect(callback)
    table.insert(self.Connections, connection)
    return connection
end

function Library:RemoveConnection(target)
    for index, connection in ipairs(self.Connections) do
        if connection == target then
            pcall(function()
                connection:Disconnect()
            end)
            table.remove(self.Connections, index)
            break
        end
    end
end

function Library:SetFlag(flag, value)
    self.Flags[flag] = value
end

function Library:GetFlag(flag)
    return self.Flags[flag]
end

function Library:LoadFlags(flags)
    for key, value in pairs(flags or {}) do
        self.Flags[key] = value
    end
end

function Library:RegisterFlagControl(flag, controller)
    self.FlagControls[flag] = self.FlagControls[flag] or {}
    table.insert(self.FlagControls[flag], controller)
    return controller
end

function Library:BroadcastFlag(flag, value, source, triggerCallbacks)
    self.Flags[flag] = value
    for _, controller in ipairs(self.FlagControls[flag] or {}) do
        if controller ~= source and type(controller._ReceiveShared) == "function" then
            controller:_ReceiveShared(value, triggerCallbacks == true)
        end
    end
end

function Library:SetThemeCatalog(catalog)
    self.ThemeCatalog = catalog or {}
    if not next(self.Theme) and type(self.ThemeCatalog.Dark) == "table" then
        self.Theme = Utils.DeepCopy(self.ThemeCatalog.Dark)
    end
end

function Library:BindTheme(instance, property, themeKey)
    table.insert(self.ThemeBindings, {
        Instance = instance,
        Property = property,
        ThemeKey = themeKey
    })
    if self.Theme[themeKey] ~= nil then
        pcall(function()
            instance[property] = self.Theme[themeKey]
        end)
    end
    return instance
end

function Library:ApplyThemeBindings()
    for _, binding in ipairs(self.ThemeBindings) do
        local instance = binding.Instance
        if instance and instance.Parent ~= nil and self.Theme[binding.ThemeKey] ~= nil then
            pcall(function()
                instance[binding.Property] = self.Theme[binding.ThemeKey]
            end)
        end
    end
end

function Library:SetBackground(image)
    self.Assets.Background = image
    if self.BackgroundFrame then
        self.BackgroundFrame.Image = image or ""
        self.BackgroundFrame.Visible = image ~= nil and image ~= ""
    end
    return true
end

function Library:SetSubtitle(text)
    self.Options.Subtitle = text or "Universal"
    if self.SubtitleLabel then
        self.SubtitleLabel.Text = self.Options.Subtitle
    end
    return true
end

function Library:ApplyThemeByName(themeName)
    local theme = self.ThemeCatalog[themeName]
    if type(theme) ~= "table" then
        return false
    end
    self.Theme = Utils.DeepCopy(theme)
    if self.UIProxy then
        self.UIProxy.Theme = self.Theme
    end
    self.ActiveThemeName = themeName
    self:SetFlag("Theme", themeName)
    self:ApplyThemeBindings()
    return true
end

function Library:Destroy()
    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    self.Connections = {}
    self.FlagControls = {}
    self.Actions = {}
    self.ThemeBindings = {}
    if self.ScreenGui then
        pcall(function()
            self.ScreenGui:Destroy()
        end)
        self.ScreenGui = nil
    end
end

function Library:new(name, options)
    options = options or {}
    self.Options.Subtitle = options.Subtitle or self.Options.Subtitle or "Universal"
    self.Options.Background = options.Background or self.Options.Background
    if self.Options.Background then
        self.Assets.Background = self.Options.Background
    end
    if not next(self.Theme) then
        self.Theme = Utils.DeepCopy(self.ThemeCatalog.Dark or {})
    end

    local guiParent = Utils.ResolveGuiParent()
    for _, child in ipairs(guiParent:GetChildren()) do
        if child.Name == "VanguardHub" then
            child:Destroy()
        end
    end

    local screenGui = Utils.CreateInstance("ScreenGui", {
        Name = "VanguardHub",
        Parent = guiParent,
        DisplayOrder = 999,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    Utils.ProtectGui(screenGui)
    self.ScreenGui = screenGui

    local baseWidth = 1619
    local baseHeight = 972

    local main = Utils.CreateInstance("Frame", {
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(baseWidth, baseHeight),
        ClipsDescendants = true
    })
    Utils.CreateInstance("UICorner", {Parent = main, CornerRadius = UDim.new(0, 18)})
    local mainStroke = Utils.CreateInstance("UIStroke", {
        Parent = main,
        Color = self.Theme.Border,
        Thickness = 1,
        Transparency = 0.5
    })
    self:BindTheme(mainStroke, "Color", "Border")
    local mainScale = Utils.CreateInstance("UIScale", {
        Parent = main,
        Scale = 1
    })
    self:TrackInstance(main)
    self.MainScale = mainScale

    local function updateScale()
        local camera = workspace.CurrentCamera
        if not camera then
            return
        end

        local viewport = camera.ViewportSize
        local scale = math.min(
            (viewport.X - 16) / baseWidth,
            (viewport.Y - 16) / baseHeight
        )

        mainScale.Scale = math.clamp(scale, 0.25, 1)
    end

    local viewportConnection
    local function connectViewport(camera)
        if viewportConnection then
            self:RemoveConnection(viewportConnection)
            viewportConnection = nil
        end
        if camera then
            viewportConnection = self:AddPropertyConnection(camera, "ViewportSize", updateScale)
        end
        updateScale()
    end

    connectViewport(workspace.CurrentCamera)
    self:AddPropertyConnection(workspace, "CurrentCamera", function()
        connectViewport(workspace.CurrentCamera)
    end)

    local background = Utils.CreateInstance("ImageLabel", {
        Parent = main,
        Name = "LT2Backdrop",
        BackgroundColor3 = self.Theme.Main,
        BackgroundTransparency = 0,
        Image = self.Assets.Background or "",
        ImageColor3 = Color3.fromRGB(178, 192, 185),
        ImageTransparency = 0.08,
        Position = UDim2.fromOffset(300, 0),
        Size = UDim2.fromOffset(1100, 520),
        ScaleType = Enum.ScaleType.Crop
    })
    self.BackgroundFrame = background
    self:TrackInstance(background)

    local horizontalShade = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundColor3 = Color3.fromRGB(0, 4, 5),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    })
    Utils.CreateInstance("UIGradient", {
        Parent = horizontalShade,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.02),
            NumberSequenceKeypoint.new(0.22, 0.18),
            NumberSequenceKeypoint.new(0.47, 0.74),
            NumberSequenceKeypoint.new(0.76, 0.36),
            NumberSequenceKeypoint.new(1, 0.06)
        })
    })

    local verticalShade = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundColor3 = Color3.fromRGB(0, 5, 6),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    })
    Utils.CreateInstance("UIGradient", {
        Parent = verticalShade,
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(0.34, 0.68),
            NumberSequenceKeypoint.new(0.52, 0.22),
            NumberSequenceKeypoint.new(1, 0.02)
        })
    })

    local content = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(354, 116),
        Size = UDim2.fromOffset(1246, 770),
        ClipsDescendants = true
    })
    local pageHost = Utils.CreateInstance("Frame", {
        Parent = content,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    local ui = {}
    self.UIProxy = ui
    ui.Theme = self.Theme
    local context = {
        Library = self,
        UI = ui,
        ScreenGui = screenGui,
        Main = main,
        Content = content,
        PageHost = pageHost,
        Minimized = false,
        BaseHeight = baseHeight
    }

    context.ToggleMinimize = function()
        local previousScale = mainScale.Scale
        local positionDelta = ((baseHeight - 105) * previousScale) / 2
        local currentPosition = main.Position
        context.Minimized = not context.Minimized
        content.Visible = not context.Minimized
        if context.Sidebar then
            context.Sidebar.Root.Visible = not context.Minimized
            if context.Sidebar.Credits then
                context.Sidebar.Credits.Visible = not context.Minimized
            end
        end
        if context.Footer then
            context.Footer.Visible = not context.Minimized
        end
        if context.ThemePanel then
            context.ThemePanel.Visible = false
        end
        if Tween then
            Tween.Play(self, main, {
                Position = UDim2.new(
                    currentPosition.X.Scale,
                    currentPosition.X.Offset,
                    currentPosition.Y.Scale,
                    currentPosition.Y.Offset + (context.Minimized and -positionDelta or positionDelta)
                ),
                Size = UDim2.fromOffset(baseWidth, context.Minimized and 105 or baseHeight)
            }, 0.22, Enum.EasingStyle.Quart)
        else
            main.Position = UDim2.new(
                currentPosition.X.Scale,
                currentPosition.X.Offset,
                currentPosition.Y.Scale,
                currentPosition.Y.Offset + (context.Minimized and -positionDelta or positionDelta)
            )
            main.Size = UDim2.fromOffset(baseWidth, context.Minimized and 105 or baseHeight)
        end
        return context.Minimized
    end

    Sidebar.Build(context)
    Topbar.Build(context)
    Tabs.Attach(ui, context)

    local footer = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(354, 904),
        Size = UDim2.fromOffset(1212, 52)
    })
    context.Footer = footer
    Utils.CreateInstance("Frame", {
        Parent = footer,
        BackgroundColor3 = self.Theme.Success,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 20),
        Size = UDim2.fromOffset(12, 12)
    })
    local statusDot = footer:FindFirstChildOfClass("Frame")
    if statusDot then
        Utils.CreateInstance("UICorner", {Parent = statusDot, CornerRadius = UDim.new(1, 0)})
        self:BindTheme(statusDot, "BackgroundColor3", "Success")
    end
    Utils.CreateInstance("TextLabel", {
        Parent = footer,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(22, 0),
        RichText = true,
        Size = UDim2.fromOffset(180, 52),
        Text = 'Status: <font color="#3FB61D">Attached</font>',
        TextColor3 = self.Theme.TextDim,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local timeLabel = Utils.CreateInstance("TextLabel", {
        Parent = footer,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(204, 0),
        Size = UDim2.fromOffset(150, 52),
        Text = "Time:  00:00:00",
        TextColor3 = self.Theme.TextDim,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local fpsLabel = Utils.CreateInstance("TextLabel", {
        Parent = footer,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(363, 0),
        Size = UDim2.fromOffset(130, 52),
        Text = "FPS:  --",
        TextColor3 = self.Theme.TextDim,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local footerFrames = 0
    local footerLastUpdate = os.clock()
    local footerStartedAt = os.time()
    self:AddConnection(RunService, "RenderStepped", function()
        footerFrames = footerFrames + 1
        local now = os.clock()
        if now - footerLastUpdate < 1 then
            return
        end

        local fps = math.floor((footerFrames / (now - footerLastUpdate)) + 0.5)
        footerFrames = 0
        footerLastUpdate = now

        local elapsed = math.max(0, os.time() - footerStartedAt)
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        timeLabel.Text = string.format("Time:  %02d:%02d:%02d", hours, minutes, seconds)
        fpsLabel.Visible = self.Flags.FPSOverlay ~= false
        fpsLabel.Text = "FPS:  " .. tostring(fps)
    end)

    context.SelectPreferredMainTab = function()
        if context.LastMainTab then
            context.LastMainTab.Activate()
        elseif context.TabList and context.TabList[1] then
            context.TabList[1].Activate()
        end
    end
    context.SelectSettingsTab = function()
        local settings = context.TabRegistry and context.TabRegistry.settings
        if settings then
            settings.Activate()
        end
    end

    local dragTarget = context.DragHandle or main
    local dragging = false
    local dragStart
    local startPosition
    self:AddConnection(dragTarget, "InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragTarget ~= main then
                local relativeX = input.Position.X - dragTarget.AbsolutePosition.X
                if relativeX > (360 * mainScale.Scale) then
                    return
                end
            end
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)
    self:AddConnection(UserInputService, "InputEnded", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    self:AddConnection(UserInputService, "InputChanged", function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)

    local toggleKey = "RightShift"
    local visible = true
    local toggleConnection
    local function reconnectToggle()
        if toggleConnection then
            self:RemoveConnection(toggleConnection)
        end
        toggleConnection = self:AddConnection(UserInputService, "InputBegan", function(input, processed)
            if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[toggleKey] then
                visible = not visible
                screenGui.Enabled = visible
            end
        end)
    end
    reconnectToggle()

    function ui:BindTheme(instance, property, themeKey)
        return Library:BindTheme(instance, property, themeKey)
    end
    function ui:SetTheme(themeName)
        return Library:ApplyThemeByName(themeName)
    end
    function ui:SetFlag(flag, value)
        return Library:SetFlag(flag, value)
    end
    function ui:GetFlag(flag)
        return Library:GetFlag(flag)
    end
    function ui:LoadFlags(flags)
        return Library:LoadFlags(flags)
    end
    function ui:RegisterFlagControl(flag, controller)
        return Library:RegisterFlagControl(flag, controller)
    end
    function ui:BroadcastFlag(flag, value, source, triggerCallbacks)
        return Library:BroadcastFlag(flag, value, source, triggerCallbacks)
    end
    function ui:SetBackground(image)
        return Library:SetBackground(image)
    end
    function ui:SetSubtitle(text)
        return Library:SetSubtitle(text)
    end
    function ui:Destroy()
        return Library:Destroy()
    end
    function ui:SetVisible(value)
        visible = value == true
        screenGui.Enabled = visible
    end
    function ui:ToggleVisibility()
        visible = not visible
        screenGui.Enabled = visible
    end
    function ui:SetToggleKey(key)
        if type(key) == "string" and Enum.KeyCode[key] then
            toggleKey = key
            reconnectToggle()
        end
    end
    function ui:GetToggleKey()
        return toggleKey
    end
    function ui:IsVisible()
        return visible
    end

    return ui
end

return Library
