local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Textbox = {}

function Textbox.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local row = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    Utils.CreateInstance("UICorner", {Parent = row, CornerRadius = UDim.new(0, 8)})
    Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.fromOffset(110, 40),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local input = Utils.CreateInstance("TextBox", {
        Parent = row,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -170, 0.5, -12),
        Size = UDim2.fromOffset(158, 24),
        Font = Enum.Font.Gotham,
        Text = default or "",
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        PlaceholderText = "Enter text...",
        ClearTextOnFocus = false
    })
    Utils.CreateInstance("UICorner", {Parent = input, CornerRadius = UDim.new(0, 6)})
    library:AddConnection(input, "FocusLost", function()
        library:SetFlag(flag, input.Text)
        Utils.SafeCallback(callback, input.Text)
    end)
    return {
        GetValue = function()
            return input.Text
        end,
        SetValue = function(_, value)
            input.Text = tostring(value)
            library:SetFlag(flag, value)
        end
    }
end

return Textbox
