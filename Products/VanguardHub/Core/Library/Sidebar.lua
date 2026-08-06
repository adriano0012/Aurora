local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Sidebar = {}

function Sidebar.Build(context)
    local library = context.Library
    local main = context.Main

    local sidebar = Utils.CreateInstance("Frame", {
        Name = "Sidebar",
        Parent = main,
        BackgroundColor3 = library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(22, 118),
        Size = UDim2.fromOffset(252, 804)
    })
    Utils.CreateInstance("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 14)})
    Utils.CreateInstance("UIPadding", {
        Parent = sidebar,
        PaddingTop = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14),
        PaddingBottom = UDim.new(0, 14)
    })
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = sidebar,
        Color = library.Theme.CardBorder,
        Transparency = 0.15
    })
    library:BindTheme(stroke, "Color", "CardBorder")
    library:TrackInstance(sidebar)

    local title = Utils.CreateInstance("TextLabel", {
        Parent = sidebar,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 26),
        Text = "Navigation",
        TextColor3 = library.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(title, "TextColor3", "Text")

    local listHost = Utils.CreateInstance("ScrollingFrame", {
        Name = "List",
        Parent = sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        CanvasSize = UDim2.new(),
        ScrollBarImageTransparency = 1,
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    local layout = Utils.CreateInstance("UIListLayout", {
        Parent = listHost,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    library:AddConnection(layout, "AbsoluteContentSize", function()
        listHost.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    context.Sidebar = {
        Root = sidebar,
        List = listHost,
        Buttons = {}
    }
end

function Sidebar.AddTabButton(context, record)
    local library = context.Library
    local sidebar = context.Sidebar

    local button = Utils.CreateInstance("TextButton", {
        Parent = sidebar.List,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Main,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        LayoutOrder = record.Order,
        Size = UDim2.new(1, 0, 0, 44),
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 10)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = button,
        Color = library.Theme.Border,
        Transparency = 0.3
    })
    library:BindTheme(stroke, "Color", "Border")

    local iconLabel = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.fromOffset(28, 44),
        Text = record.Icon ~= "" and "•" or "•",
        TextColor3 = library.Theme.TextDim,
        TextSize = 18
    })
    local label = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(38, 0),
        Size = UDim2.new(1, -46, 1, 0),
        Text = record.DisplayName,
        TextColor3 = library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(label, "TextColor3", "Text")

    library:AddConnection(button, "MouseEnter", function()
        Tween.Play(library, button, {BackgroundColor3 = library.Theme.Hover}, 0.15)
    end)
    library:AddConnection(button, "MouseLeave", function()
        if not record.Selected then
            Tween.Play(library, button, {BackgroundColor3 = library.Theme.Main}, 0.15)
        end
    end)
    library:AddConnection(button, "MouseButton1Click", function()
        record.Activate()
    end)

    record.SidebarButton = button
    record.SidebarStroke = stroke
    record.SidebarIcon = iconLabel
    record.SidebarLabel = label
    sidebar.Buttons[record.Id] = record
end

function Sidebar.SetSelected(context, selectedRecord)
    local library = context.Library
    for _, record in pairs(context.Sidebar.Buttons) do
        local active = record == selectedRecord
        record.Selected = active
        Tween.Play(library, record.SidebarButton, {
            BackgroundColor3 = active and library.Theme.Selected or library.Theme.Main
        }, 0.15)
        Tween.Play(library, record.SidebarStroke, {
            Color = active and library.Theme.Accent or library.Theme.Border
        }, 0.15)
        Tween.Play(library, record.SidebarIcon, {
            TextColor3 = active and library.Theme.Accent or library.Theme.TextDim
        }, 0.15)
        Tween.Play(library, record.SidebarLabel, {
            TextColor3 = active and library.Theme.Accent or library.Theme.Text
        }, 0.15)
    end
end

return Sidebar
