local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Slider = {}

function Slider.Create(tabContext, section, text, flag, default, min, max, precise, callback)
    local library = tabContext.Library
    local row = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 44)
    })
    Utils.CreateInstance("UICorner", {Parent = row, CornerRadius = UDim.new(0, 8)})
    local label = Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 0, 18),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local valueLabel = Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.fromOffset(48, 18),
        Font = Enum.Font.Gotham,
        Text = tostring(default),
        TextColor3 = library.Theme.TextDim,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    local track = Utils.CreateInstance("Frame", {
        Parent = row,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(12, 26),
        Size = UDim2.new(1, -24, 0, 6)
    })
    Utils.CreateInstance("UICorner", {Parent = track, CornerRadius = UDim.new(1, 0)})
    local fill = Utils.CreateInstance("Frame", {
        Parent = track,
        BackgroundColor3 = library.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0)
    })
    Utils.CreateInstance("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})

    local value = default or min
    local controller = {}
    local dragging = false

    local function normalize(newValue)
        if newValue == nil then
            newValue = value or min
        end
        newValue = math.clamp(newValue, min, max)
        if not precise then
            newValue = math.floor(newValue + 0.5)
        end
        return newValue
    end

    local function apply(newValue, skipCallback, skipBroadcast)
        value = normalize(newValue)
        local percent = (value - min) / math.max(max - min, 0.0001)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(value)
        library:SetFlag(flag, value)
        if not skipCallback then
            Utils.SafeCallback(callback, value)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, value, controller, not skipCallback)
        end
    end

    library:AddConnection(track, "InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    library:AddConnection(game:GetService("UserInputService"), "InputChanged", function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            apply(min + ((max - min) * percent), false, false)
        end
    end)
    library:AddConnection(game:GetService("UserInputService"), "InputEnded", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    controller.GetValue = function()
        return value
    end
    controller.SetValue = function(_, newValue, skipCallback)
        apply(newValue, skipCallback, false)
    end
    controller._ReceiveShared = function(_, sharedValue, triggerCallback)
        apply(sharedValue, not triggerCallback, true)
    end
    library:RegisterFlagControl(flag, controller)
    apply(value, true, true)
    return controller
end

return Slider
