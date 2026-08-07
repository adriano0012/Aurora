local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Sections = Registry["Core/Library/Sections"]
local Sidebar = Registry["Core/Library/Sidebar"]
local Topbar = Registry["Core/Library/Topbar"]
local Utils = Registry["Core/Library/Utils"]

local Tabs = {}

local sidebarOrder = {
    home = 1,
    player = 2,
    world = 3,
    teleports = 4,
    wood = 5,
    dupe = 6,
    build = 7,
    vehicle = 8,
    item = 9,
    slot = 10,
    autobuy = 11,
    sorter = 12,
    troll = 13,
    fun = 14
}

local sidebarLabels = {
    wood = "Wood / Mod Wood",
    build = "Auto Build"
}

local function resolveConfigValue(config, flag)
    if type(config) ~= "table" or flag == nil then
        return nil, false
    end
    if config[flag] ~= nil then
        return config[flag], true
    end
    if type(config.UI) == "table" and config.UI[flag] ~= nil then
        return config.UI[flag], true
    end
    return nil, false
end

function Tabs.Attach(ui, context)
    local library = context.Library
    context.TabRegistry = {}
    context.TabList = {}

    function ui:Tab(name, icon, options)
        options = options or {}
        local id = string.lower(tostring(options.id or name))
        local page = Utils.CreateInstance("ScrollingFrame", {
            Parent = context.PageHost,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = library.Theme.Accent,
            ScrollBarImageTransparency = 0.28,
            Visible = false,
            BorderSizePixel = 0,
            ScrollingDirection = Enum.ScrollingDirection.Y
        })
        local layout = Utils.CreateInstance("UIListLayout", {
            Parent = page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12)
        })
        library:AddConnection(layout, "AbsoluteContentSize", function()
            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 20)
        end)

        local tabObject = {
            Page = page
        }

        function tabObject:Canvas(height)
            local canvas = Utils.CreateInstance("Frame", {
                Name = "DashboardCanvas",
                Parent = page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, height or 770)
            })
            page.ScrollBarThickness = 0
            page.ScrollingEnabled = false
            page.CanvasPosition = Vector2.new()
            return canvas
        end

        function tabObject:Title(text)
            local title = Utils.CreateInstance("TextLabel", {
                Parent = page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Font = Enum.Font.GothamBold,
                Text = text,
                TextColor3 = library.Theme.Text,
                TextSize = 21,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom
            })
            library:TrackInstance(title)
            return title
        end

        function tabObject:GetContainer()
            return page
        end

        function tabObject:Section(sectionName, defaultOpen)
            return Sections.Create({
                Library = library,
                UI = ui,
                TabObject = tabObject,
                Container = page
            }, sectionName, defaultOpen)
        end

        local record = {
            Id = id,
            Name = name,
            DisplayName = options.displayName or sidebarLabels[id] or name,
            Icon = tostring(icon or ""),
            Page = page,
            Order = sidebarOrder[id] or (#context.TabList + 100)
        }

        record.Activate = function()
            for _, other in ipairs(context.TabList) do
                other.Page.Visible = false
            end
            page.Visible = true
            context.CurrentTab = record
            context.LastMainTab = id ~= "settings" and record or context.LastMainTab
            if context.ThemePanel then
                context.ThemePanel.Visible = false
            end
            Sidebar.SetSelected(context, record)
            Topbar.SetSelected(context, id == "settings" and "Settings" or "Main")
        end

        context.TabRegistry[id] = record
        table.insert(context.TabList, record)

        if options.sidebar ~= false and id ~= "settings" then
            Sidebar.AddTabButton(context, record)
        end

        if not context.CurrentTab then
            record.Activate()
        end

        return tabObject
    end

    function ui:SelectTab(id)
        local record = context.TabRegistry[string.lower(tostring(id or ""))]
        if not record then
            return false
        end
        record.Activate()
        return true
    end

    function ui:RegisterAction(name, callback)
        if type(name) ~= "string" or type(callback) ~= "function" then
            return false
        end
        library.Actions[name] = callback
        return true
    end

    function ui:InvokeAction(name, ...)
        local callback = library.Actions[name]
        if type(callback) ~= "function" then
            return false
        end
        Utils.SafeCallback(callback, ...)
        return true
    end

    function ui:SetThemePanelVisible(visible)
        context.ThemePanel.Visible = visible == true
        Topbar.SetSelected(context, context.ThemePanel.Visible and "Theme" or (context.CurrentTab and context.CurrentTab.Id == "settings" and "Settings" or "Main"))
        return context.ThemePanel.Visible
    end

    function ui:OpenThemePanel()
        return self:SetThemePanelVisible(true)
    end

    function ui:RegisterFlagControl(flag, receiver)
        local controller = {
            _ReceiveShared = function(_, value, triggerCallback)
                receiver(value, triggerCallback)
            end
        }
        return library:RegisterFlagControl(flag, controller)
    end

    function ui:BroadcastFlag(flag, value, source, triggerCallbacks)
        library:BroadcastFlag(flag, value, source, triggerCallbacks)
    end

    function ui:ApplyConfig(config, options)
        options = options or {}
        if type(config) ~= "table" then
            return false
        end
        if type(config.Theme) == "string" then
            self:SetTheme(config.Theme)
        end
        if type(config.ToggleUI) == "string" then
            self:SetToggleKey(config.ToggleUI)
        elseif type(config.Keybinds) == "table" and type(config.Keybinds.ToggleUI) == "string" then
            self:SetToggleKey(config.Keybinds.ToggleUI)
        end
        for flag in pairs(library.FlagControls) do
            local value, exists = resolveConfigValue(config, flag)
            if exists then
                library:BroadcastFlag(flag, value, nil, options.triggerCallbacks ~= false)
            end
        end
        return true
    end

    function ui:SetTheme(themeName)
        local aliases = {
            dark_purple = "Purple",
            dark_blue = "Blue",
            dark_green = "Green",
            dark_gold = "Gold",
            dark_red = "Dark",
            dark = "Dark",
            purple = "Purple",
            blue = "Blue",
            green = "Green",
            gold = "Gold",
            light = "Light"
        }
        local normalized = aliases[string.lower(tostring(themeName or "Dark"))] or tostring(themeName or "Dark")
        if not library:ApplyThemeByName(normalized) then
            return false
        end
        ui.Theme = library.Theme
        return true
    end

    function ui:SetBackground(image)
        return library:SetBackground(image)
    end

    function ui:SetSubtitle(text)
        return library:SetSubtitle(text)
    end

    function ui:SetFlag(flag, value)
        library:SetFlag(flag, value)
    end

    function ui:GetFlag(flag)
        return library:GetFlag(flag)
    end
end

return Tabs
