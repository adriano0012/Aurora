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

local function tween(library, instance, properties, duration)
    if Tween then
        Tween.Play(library, instance, properties, duration or 0.3)
        return
    end
    for property, value in pairs(properties) do
        instance[property] = value
    end
end

function Sections.Create(tabContext, name, defaultOpen)
    local library = tabContext.Library
    local parent = tabContext.Container

    local sectionFrame = Utils.CreateInstance("Frame", {
        Parent = parent,
        BackgroundColor3 = library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 42),
        ClipsDescendants = true
    })
    Utils.CreateInstance("UICorner", {Parent = sectionFrame, CornerRadius = UDim.new(0, 10)})
    Utils.CreateInstance("UIStroke", {
        Parent = sectionFrame,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.08
    })

    local header = Utils.CreateInstance("TextButton", {
        Parent = sectionFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 42),
        Font = Enum.Font.GothamBold,
        Text = "   " .. tostring(name or "Section"),
        TextColor3 = library.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    local arrow = Utils.CreateInstance("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.new(1, -32, 0, 10),
        Font = Enum.Font.GothamBold,
        Text = ">",
        TextColor3 = library.Theme.TextDim,
        TextSize = 13
    })
    local body = Utils.CreateInstance("Frame", {
        Parent = sectionFrame,
        BackgroundTransparency = 1,
        Name = "SectionContent",
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 46)
    })
    local layout = Utils.CreateInstance("UIListLayout", {
        Parent = body,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    local open = true

    local function updateSize()
        if open then
            local contentSize = layout.AbsoluteContentSize.Y
            tween(library, sectionFrame, {Size = UDim2.new(1, 0, 0, 46 + contentSize + 14)}, 0.3)
            arrow.Text = "v"
        else
            tween(library, sectionFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
            arrow.Text = ">"
        end
    end

    library:AddConnection(layout, "AbsoluteContentSize", function()
        if open then
            updateSize()
        end
    end)
    library:AddConnection(header, "MouseEnter", function()
        tween(library, header, {TextColor3 = library.Theme.Accent}, 0.15)
    end)
    library:AddConnection(header, "MouseLeave", function()
        tween(library, header, {TextColor3 = library.Theme.Text}, 0.15)
    end)
    library:AddConnection(header, "MouseButton1Click", function()
        open = not open
        updateSize()
    end)

    local section = {
        Frame = sectionFrame,
        Header = header,
        Body = body,
        Tab = tabContext.TabObject
    }

    function section:SetOpen(value)
        open = value == true
        updateSize()
    end

    function section:IsOpen()
        return open
    end

    function section:GetSection()
        return sectionFrame
    end

    function section:GetContainer()
        return body
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

    updateSize()
    return section
end

return Sections
