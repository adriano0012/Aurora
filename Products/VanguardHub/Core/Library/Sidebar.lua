local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Sidebar = {}

local function tween(library, instance, properties, duration)
    if Tween then
        Tween.Play(library, instance, properties, duration or 0.2)
        return
    end
    for property, value in pairs(properties) do
        instance[property] = value
    end
end

function Sidebar.Build(context)
    local library = context.Library
    local main = context.Main

    local root = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.04,
        Size = UDim2.fromOffset(325, 706),
        Position = UDim2.fromOffset(17, 112)
    })
    Utils.CreateInstance("UICorner", {Parent = root, CornerRadius = UDim.new(0, 10)})
    Utils.CreateInstance("UIStroke", {
        Parent = root,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.12
    })

    local title = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -36, 0, 30),
        Position = UDim2.fromOffset(19, 8),
        Font = Enum.Font.GothamMedium,
        Text = "CATEGORIES",
        TextColor3 = library.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(title, "TextColor3", "Accent")

    local list = Utils.CreateInstance("ScrollingFrame", {
        Parent = root,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(300, 656),
        Position = UDim2.fromOffset(7, 40),
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        CanvasSize = UDim2.new(),
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    local layout = Utils.CreateInstance("UIListLayout", {
        Parent = list,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3)
    })
    library:AddPropertyConnection(layout, "AbsoluteContentSize", function()
        list.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    local credits = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.04,
        Position = UDim2.fromOffset(17, 814),
        Size = UDim2.fromOffset(325, 128)
    })
    Utils.CreateInstance("UICorner", {Parent = credits, CornerRadius = UDim.new(0, 10)})
    Utils.CreateInstance("UIStroke", {
        Parent = credits,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.12
    })
    local creditsTitle = Utils.CreateInstance("TextLabel", {
        Parent = credits,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(18, 7),
        Size = UDim2.fromOffset(275, 23),
        Text = "CREDITS",
        TextColor3 = library.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(creditsTitle, "TextColor3", "Accent")

    local creditRows = {
        {"Owner:", "₳ĐⱤł₳₦Ø"},
        {"UI & Architecture:", "Vanguard Team"},
        {"Version:", "v1.0"}
    }
    for index, row in ipairs(creditRows) do
        Utils.CreateInstance("TextLabel", {
            Parent = credits,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(18, 29 + ((index - 1) * 24)),
            Size = UDim2.fromOffset(130, 21),
            Text = row[1],
            TextColor3 = library.Theme.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local valueLabel = Utils.CreateInstance("TextLabel", {
            Parent = credits,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(148, 29 + ((index - 1) * 24)),
            Size = UDim2.fromOffset(143, 21),
            Text = row[2],
            TextColor3 = library.Theme.Accent,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        library:BindTheme(valueLabel, "TextColor3", "Accent")
    end

    context.Sidebar = {
        Root = root,
        List = list,
        Credits = credits,
        Buttons = {}
    }
end

function Sidebar.AddTabButton(context, record)
    local library = context.Library

    local button = Utils.CreateInstance("TextButton", {
        Parent = context.Sidebar.List,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Main,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        LayoutOrder = record.Order,
        Size = UDim2.new(1, 0, 0, 50),
        Text = "",
        ClipsDescendants = true
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Name = "TabStroke",
        Parent = button,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 1
    })
    local indicator = Utils.CreateInstance("Frame", {
        Name = "Indicator",
        Parent = button,
        BackgroundColor3 = library.Theme.Accent,
        Size = UDim2.new(0, 3, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1
    })
    library:BindTheme(indicator, "BackgroundColor3", "Accent")

    local textOffset = 14
    local iconImage
    if tonumber(record.Icon) then
        iconImage = Utils.CreateInstance("ImageLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(28, 28),
            Position = UDim2.new(0, 14, 0.5, -14),
            Image = "rbxassetid://" .. tostring(record.Icon),
            ImageColor3 = library.Theme.TextDim,
            ScaleType = Enum.ScaleType.Fit
        })
        textOffset = 56
    else
        Utils.CreateInstance("TextLabel", {
            Parent = button,
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Position = UDim2.fromOffset(14, 0),
            Size = UDim2.fromOffset(34, 44),
            Text = "*",
            TextColor3 = library.Theme.TextDim,
            TextSize = 23
        })
        textOffset = 56
    end

    local label = Utils.CreateInstance("TextLabel", {
        Name = "TabText",
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(textOffset, 0),
        Size = UDim2.new(1, -(textOffset + 8), 1, 0),
        Font = Enum.Font.Gotham,
        Text = record.DisplayName,
        TextColor3 = library.Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    library:AddConnection(button, "MouseEnter", function()
        if not record.Selected then
            tween(library, button, {BackgroundTransparency = 0.64}, 0.15)
        end
    end)
    library:AddConnection(button, "MouseLeave", function()
        if not record.Selected then
            tween(library, button, {BackgroundTransparency = 0.82}, 0.15)
        end
    end)
    library:AddConnection(button, "MouseButton1Click", function()
        record.Activate()
    end)

    record.SidebarButton = button
    record.SidebarStroke = stroke
    record.SidebarIndicator = indicator
    record.SidebarIcon = iconImage
    record.SidebarLabel = label
    context.Sidebar.Buttons[record.Id] = record
end

function Sidebar.SetSelected(context, selectedRecord)
    local library = context.Library
    for _, record in pairs(context.Sidebar.Buttons) do
        local active = record == selectedRecord
        record.Selected = active
        tween(library, record.SidebarButton, {
            BackgroundColor3 = active and library.Theme.Selected or library.Theme.Main,
            BackgroundTransparency = active and 0 or 0.82
        }, 0.2)
        tween(library, record.SidebarIndicator, {
            BackgroundTransparency = active and 0 or 1
        }, 0.2)
        tween(library, record.SidebarStroke, {
            Color = active and library.Theme.Accent or library.Theme.CardBorder,
            Transparency = active and 0.08 or 1
        }, 0.2)
        if record.SidebarIcon then
            tween(library, record.SidebarIcon, {
                ImageColor3 = active and library.Theme.Accent or library.Theme.TextDim
            }, 0.2)
        end
        tween(library, record.SidebarLabel, {
            TextColor3 = active and library.Theme.Text or library.Theme.Text
        }, 0.2)
    end
end

return Sidebar
