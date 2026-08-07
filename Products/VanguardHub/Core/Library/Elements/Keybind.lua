local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Keybind = {}

function Keybind.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 6)})
    Utils.CreateInstance("UIStroke", {
        Parent = button,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.35
    })
    local label = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0, 2),
        Size = UDim2.new(0.5, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = tostring(text or ""),
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local keyLabel = Utils.CreateInstance("TextButton", {
        Parent = button,
        BackgroundColor3 = library.Theme.Tertiary,
        Position = UDim2.new(0.7, 0, 0.5, -13),
        Size = UDim2.fromOffset(70, 26),
        Font = Enum.Font.GothamMedium,
        Text = default or "None",
        TextColor3 = library.Theme.Text,
        TextSize = 11,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    Utils.CreateInstance("UICorner", {Parent = keyLabel, CornerRadius = UDim.new(0, 4)})

    local current = default or "None"
    local listening = false
    local controller = {}

    local function apply(value, skipCallback, skipBroadcast)
        current = value
        keyLabel.Text = value
        library:SetFlag(flag, value)
        if not skipCallback then
            Utils.SafeCallback(callback, value)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, value, controller, not skipCallback)
        end
    end

    library:AddConnection(keyLabel, "MouseButton1Click", function()
        listening = true
        keyLabel.Text = "..."
    end)
    library:AddConnection(game:GetService("UserInputService"), "InputBegan", function(input, processed)
        if processed or not listening then
            return
        end
        listening = false
        if input.UserInputType == Enum.UserInputType.Keyboard then
            apply(input.KeyCode.Name, false, false)
        end
    end)

    controller.GetKey = function()
        return current
    end
    controller.SetKey = function(_, value, skipCallback)
        apply(value, skipCallback, false)
    end
    controller._ReceiveShared = function(_, value, triggerCallback)
        apply(value, not triggerCallback, true)
    end
    library:RegisterFlagControl(flag, controller)
    return controller
end

return Keybind
