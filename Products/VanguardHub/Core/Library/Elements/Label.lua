local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Label = {}

function Label.Create(tabContext, section, text, options)
    local library = tabContext.Library
    local label = Utils.CreateInstance("TextLabel", {
        Parent = section.Body,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, options and options.Height or 24),
        Font = options and options.Font or Enum.Font.GothamMedium,
        Text = options and options.NoPadding and (text or "") or ("  " .. tostring(text or "")),
        TextColor3 = options and options.Color or library.Theme.TextDim,
        TextSize = options and options.TextSize or 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = options and options.TextYAlignment or Enum.TextYAlignment.Center
    })
    return {
        Instance = label,
        SetText = function(_, value)
            label.Text = value
        end
    }
end

return Label
