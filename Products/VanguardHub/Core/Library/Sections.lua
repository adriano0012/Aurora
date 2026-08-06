local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local SectionElements = {
    Label = Registry["Core/Library/Elements/Label"],
    Button = Registry["Core/Library/Elements/Button"],
    Toggle = Registry["Core/Library/Elements/Toggle"],
    Slider = Registry["Core/Library/Elements/Slider"],
    Dropdown = Registry["Core/Library/Elements/Dropdown"],
    Keybind = Registry["Core/Library/Elements/Keybind"],
    ColorPicker = Registry["Core/Library/Elements/ColorPicker"],
    TextBox = Registry["Core/Library/Elements/Textbox"],
    Paragraph = Registry["Core/Library/Elements/Paragraph"]
}

local Sections = {}

local function updateCanvas(column)
    local holder = column.Parent
    if holder:IsA("ScrollingFrame") then
        local layout = column:FindFirstChildOfClass("UIListLayout")
        if layout then
            holder.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 24)
        end
    end
end

function Sections.Create(tabContext, name, leftSide)
    local library = tabContext.Library
    local parentColumn = leftSide ~= false and tabContext.LeftColumn or tabContext.RightColumn

    local sectionFrame = Utils.CreateInstance("Frame", {
        Parent = parentColumn,
        BackgroundColor3 = library.Theme.Secondary,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0)
    })
    Utils.CreateInstance("UICorner", {Parent = sectionFrame, CornerRadius = UDim.new(0, 12)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = sectionFrame,
        Color = library.Theme.CardBorder,
        Transparency = 0.18
    })
    library:BindTheme(stroke, "Color", "CardBorder")

    local header = Utils.CreateInstance("TextButton", {
        Parent = sectionFrame,
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        Text = ""
    })
    local title = Utils.CreateInstance("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(title, "TextColor3", "Text")
    local chevron = Utils.CreateInstance("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0, 0),
        Size = UDim2.fromOffset(20, 38),
        Font = Enum.Font.GothamBold,
        Text = "v",
        TextColor3 = library.Theme.TextDim,
        TextSize = 14
    })
    library:BindTheme(chevron, "TextColor3", "TextDim")

    local body = Utils.CreateInstance("Frame", {
        Parent = sectionFrame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 40),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, -24, 0, 0)
    })
    local layout = Utils.CreateInstance("UIListLayout", {
        Parent = body,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    library:AddConnection(layout, "AbsoluteContentSize", function()
        body.Size = UDim2.new(1, -24, 0, layout.AbsoluteContentSize.Y)
        updateCanvas(parentColumn)
    end)

    local open = true
    local function setOpen(value)
        open = value == true
        body.Visible = open
        chevron.Text = open and "v" or ">"
        updateCanvas(parentColumn)
    end

    library:AddConnection(header, "MouseButton1Click", function()
        setOpen(not open)
    end)

    local section = {
        Frame = sectionFrame,
        Header = header,
        Body = body,
        Tab = tabContext.TabObject
    }

    function section:Title(text)
        title.Text = text
        return title
    end

    function section:GetContainer()
        return body
    end

    function section:SetOpen(value)
        setOpen(value)
    end

    function section:Label(...)
        return SectionElements.Label.Create(tabContext, self, ...)
    end

    function section:Button(...)
        return SectionElements.Button.Create(tabContext, self, ...)
    end

    function section:Toggle(...)
        return SectionElements.Toggle.Create(tabContext, self, ...)
    end

    function section:Slider(...)
        return SectionElements.Slider.Create(tabContext, self, ...)
    end

    function section:Dropdown(...)
        return SectionElements.Dropdown.Create(tabContext, self, ...)
    end

    function section:Keybind(...)
        return SectionElements.Keybind.Create(tabContext, self, ...)
    end

    function section:ColorPicker(...)
        return SectionElements.ColorPicker.Create(tabContext, self, ...)
    end

    function section:TextBox(...)
        return SectionElements.TextBox.Create(tabContext, self, ...)
    end

    section.Textbox = section.TextBox

    function section:Paragraph(...)
        return SectionElements.Paragraph.Create(tabContext, self, ...)
    end

    setOpen(true)
    return section
end

return Sections
