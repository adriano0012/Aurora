local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Keybind = {}

function Keybind.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    local label = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -90, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local keyLabel = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -72, 0, 0),
        Size = UDim2.fromOffset(60, 34),
        Font = Enum.Font.GothamBold,
        Text = default or "None",
        TextColor3 = library.Theme.Accent,
        TextSize = 12
    })

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

    library:AddConnection(button, "MouseButton1Click", function()
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
