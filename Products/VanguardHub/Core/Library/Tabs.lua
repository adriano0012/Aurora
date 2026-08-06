local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Sections = Registry["Core/Library/Sections"]
local Sidebar = Registry["Core/Library/Sidebar"]
local Topbar = Registry["Core/Library/Topbar"]
local Utils = Registry["Core/Library/Utils"]

local Tabs = {}

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
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(),
            ScrollBarImageTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })
        local columns = Utils.CreateInstance("Frame", {
            Parent = page,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -8, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        local left = Utils.CreateInstance("ScrollingFrame", {
            Parent = columns,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0.5, -6, 1, 0),
            CanvasSize = UDim2.new(),
            ScrollBarImageTransparency = 1,
            AutomaticCanvasSize = Enum.AutomaticSize.None
        })
        local right = Utils.CreateInstance("ScrollingFrame", {
            Parent = columns,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 6, 0, 0),
            Size = UDim2.new(0.5, -6, 1, 0),
            CanvasSize = UDim2.new(),
            ScrollBarImageTransparency = 1,
            AutomaticCanvasSize = Enum.AutomaticSize.None
        })
        for _, column in ipairs({left, right}) do
            Utils.CreateInstance("UIListLayout", {
                Parent = column,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
        end

        local tabObject = {
            Page = page
        }

        function tabObject:Canvas(height)
            local canvas = Utils.CreateInstance("Frame", {
                Parent = page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, height or 600)
            })
            return canvas
        end

        function tabObject:Title(text)
            return text
        end

        function tabObject:GetContainer()
            return page
        end

        function tabObject:Section(sectionName, defaultOpen)
            local section = Sections.Create({
                Library = library,
                UI = ui,
                TabObject = tabObject,
                LeftColumn = defaultOpen ~= false and left or right,
                RightColumn = right
            }, sectionName, defaultOpen)
            return section
        end

        local record = {
            Id = id,
            Name = name,
            DisplayName = options.displayName or name,
            Icon = tostring(icon or ""),
            Page = page,
            Order = #context.TabList + 1
        }
        record.Activate = function()
            for _, other in ipairs(context.TabList) do
                other.Page.Visible = false
            end
            page.Visible = true
            context.CurrentTab = record
            context.LastMainTab = id ~= "settings" and record or context.LastMainTab
            Sidebar.SetSelected(context, record)
            Topbar.SetSelected(context, id == "settings" and "Settings" or "Main")
        end

        context.TabRegistry[id] = record
        table.insert(context.TabList, record)
        if options.sidebar ~= false then
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
        if context.CurrentTab then
            context.CurrentTab.Activate()
        end
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
