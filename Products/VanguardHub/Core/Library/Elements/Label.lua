local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Label = {}

function Label.Create(tabContext, section, text, options)
    local library = tabContext.Library
    local label = Utils.CreateInstance("TextLabel", {
        Parent = section.Body,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options and options.Height or 22),
        Font = Enum.Font.Gotham,
        Text = text or "",
        TextColor3 = options and options.Color or library.Theme.TextDim,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return {
        Instance = label,
        SetText = function(_, value)
            label.Text = value
        end
    }
end

return Label
