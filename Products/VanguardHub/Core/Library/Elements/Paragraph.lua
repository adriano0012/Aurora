local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Paragraph = {}

function Paragraph.Create(tabContext, section, title, content)
    local library = tabContext.Library
    local frame = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0)
    })
    Utils.CreateInstance("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 8)})
    Utils.CreateInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 8),
        Size = UDim2.new(1, -24, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = title or "",
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Utils.CreateInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 28),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, -24, 0, 0),
        Font = Enum.Font.Gotham,
        Text = content or "",
        TextColor3 = library.Theme.TextDim,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return frame
end

return Paragraph
