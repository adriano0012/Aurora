local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Paragraph = {}

function Paragraph.Create(tabContext, section, title, content)
    local library = tabContext.Library
    local frame = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0)
    })
    Utils.CreateInstance("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})
    Utils.CreateInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 6),
        Size = UDim2.new(1, -10, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = title or "",
        TextColor3 = library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local contentLabel = Utils.CreateInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -20, 0, 0),
        Font = Enum.Font.GothamMedium,
        Text = content or "",
        TextColor3 = library.Theme.TextDim,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LineHeight = 1.2
    })
    local lines = math.max(1, math.ceil(#tostring(content or "") / 70))
    local contentHeight = (lines * 14) + 10
    contentLabel.Size = UDim2.new(1, -20, 0, contentHeight)
    frame.Size = UDim2.new(1, 0, 0, contentHeight + 46)
    return frame
end

return Paragraph
