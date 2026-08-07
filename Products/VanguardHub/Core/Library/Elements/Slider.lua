local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local UserInputService = game:GetService("UserInputService")

local Slider = {}

function Slider.Create(tabContext, section, text, flag, default, min, max, precise, callback)
    local library = tabContext.Library
    local row = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 46)
    })
    Utils.CreateInstance("UICorner", {Parent = row, CornerRadius = UDim.new(0, 6)})
    Utils.CreateInstance("UIStroke", {
        Parent = row,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.35
    })
    local label = Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0, 2),
        Size = UDim2.new(0.5, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = tostring(text or ""),
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local valueLabel = Utils.CreateInstance("TextLabel", {
        Parent = row,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.78, 0, 0, 2),
        Size = UDim2.new(0.2, 0, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextColor3 = library.Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    local track = Utils.CreateInstance("Frame", {
        Parent = row,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.02, 0, 0, 32),
        Size = UDim2.new(0.96, 0, 0, 4)
    })
    Utils.CreateInstance("UICorner", {Parent = track, CornerRadius = UDim.new(1, 0)})
    local fill = Utils.CreateInstance("Frame", {
        Parent = track,
        BackgroundColor3 = library.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, 4)
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
        if Tween then
            Tween.Play(library, fill, {Size = UDim2.new(percent, 0, 0, 4)}, 0.05)
        else
            fill.Size = UDim2.new(percent, 0, 0, 4)
        end
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
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            apply(min + ((max - min) * percent), false, false)
        end
    end)
    library:AddConnection(row, "InputBegan", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            apply(min + ((max - min) * percent), false, false)
        end
    end)
    library:AddConnection(UserInputService, "InputChanged", function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            apply(min + ((max - min) * percent), false, false)
        end
    end)
    library:AddConnection(UserInputService, "InputEnded", function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            Utils.SafeCallback(callback, value)
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
