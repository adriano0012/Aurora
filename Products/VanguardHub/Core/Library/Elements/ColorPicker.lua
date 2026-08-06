local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local ColorPicker = {}

function ColorPicker.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local colors = {
        Color3.fromRGB(255, 65, 65),
        Color3.fromRGB(255, 150, 50),
        Color3.fromRGB(255, 230, 50),
        Color3.fromRGB(0, 230, 118),
        Color3.fromRGB(0, 180, 255),
        Color3.fromRGB(160, 60, 255),
        Color3.fromRGB(255, 255, 255)
    }
    local index = 1
    local button = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -56, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local swatch = Utils.CreateInstance("Frame", {
        Parent = button,
        BackgroundColor3 = default or colors[1],
        BorderSizePixel = 0,
        Position = UDim2.new(1, -36, 0.5, -10),
        Size = UDim2.fromOffset(20, 20)
    })
    Utils.CreateInstance("UICorner", {Parent = swatch, CornerRadius = UDim.new(0, 6)})

    local current = default or colors[1]
    local controller = {}
    local function apply(value, skipCallback, skipBroadcast)
        current = value
        swatch.BackgroundColor3 = value
        library:SetFlag(flag, value)
        if not skipCallback then
            Utils.SafeCallback(callback, value)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, value, controller, not skipCallback)
        end
    end
    library:AddConnection(button, "MouseButton1Click", function()
        index = (index % #colors) + 1
        apply(colors[index], false, false)
    end)
    controller.GetColor = function()
        return current
    end
    controller.SetColor = function(_, value, skipCallback)
        apply(value, skipCallback, false)
    end
    controller._ReceiveShared = function(_, value, triggerCallback)
        apply(value, not triggerCallback, true)
    end
    library:RegisterFlagControl(flag, controller)
    return controller
end

return ColorPicker
