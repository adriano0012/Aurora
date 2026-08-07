local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Textbox = {}

function Textbox.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local row = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    Utils.CreateInstance("UICorner", {Parent = row, CornerRadius = UDim.new(0, 6)})
    Utils.CreateInstance("UIStroke", {
        Parent = row,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.35
    })
    Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0, 2),
        Size = UDim2.new(0.35, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = tostring(text or ""),
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local input = Utils.CreateInstance("TextBox", {
        Parent = row,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.43, 0, 0.5, -14),
        Size = UDim2.new(0.55, 0, 0, 28),
        Font = Enum.Font.GothamMedium,
        Text = default or "",
        TextColor3 = library.Theme.Text,
        TextSize = 11,
        PlaceholderText = "Enter text...",
        PlaceholderColor3 = library.Theme.TextDim,
        ClearTextOnFocus = false
    })
    Utils.CreateInstance("UICorner", {Parent = input, CornerRadius = UDim.new(0, 4)})
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
