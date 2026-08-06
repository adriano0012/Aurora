local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Sidebar = Registry["Core/Library/Sidebar"]
local Topbar = Registry["Core/Library/Topbar"]
local Tabs = Registry["Core/Library/Tabs"]

local UserInputService = game:GetService("UserInputService")

print("[Vanguard] Window AddConnection v2")

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
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    Utils.ProtectGui(screenGui)
    self.ScreenGui = screenGui

    local main = Utils.CreateInstance("Frame", {
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(1420, 860)
    })
    Utils.CreateInstance("UICorner", {Parent = main, CornerRadius = UDim.new(0, 18)})
    self:TrackInstance(main)

    local background = Utils.CreateInstance("ImageLabel", {
        Parent = main,
        BackgroundTransparency = 1,
        Image = self.Assets.Background or "",
        ImageTransparency = 0.1,
        Position = UDim2.fromOffset(280, 0),
        Size = UDim2.new(1, -280, 0, 320),
        ScaleType = Enum.ScaleType.Crop,
        Visible = self.Assets.Background ~= nil and self.Assets.Background ~= ""
    })
    self.BackgroundFrame = background

    local content = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(286, 118),
        Size = UDim2.new(1, -308, 1, -140)
    })
    local pageHost = Utils.CreateInstance("Frame", {
        Parent = content,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    local ui = {}
    local context = {
        Library = self,
        UI = ui,
        ScreenGui = screenGui,
        Main = main,
        Content = content,
        PageHost = pageHost,
        Minimized = false
    }

    context.ToggleMinimize = function()
        context.Minimized = not context.Minimized
        content.Visible = not context.Minimized
        if context.Sidebar then
            context.Sidebar.Root.Visible = not context.Minimized
        end
    end

    Sidebar.Build(context)
    Topbar.Build(context)
    Tabs.Attach(ui, context)

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

    local dragging = false
    local dragStart
    local startPosition
    self:AddConnection(main, "InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
