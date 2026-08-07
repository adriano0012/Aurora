local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Toggle = {}

function Toggle.Create(tabContext, section, text, flag, default, callback)
    local library = tabContext.Library
    local row = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Text = ""
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
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = "  " .. tostring(text or ""),
        TextColor3 = library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local track = Utils.CreateInstance("Frame", {
        Parent = row,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -42, 0.5, -10),
        Size = UDim2.fromOffset(38, 20)
    })
    Utils.CreateInstance("UICorner", {Parent = track, CornerRadius = UDim.new(1, 0)})
    local knob = Utils.CreateInstance("Frame", {
        Parent = track,
        BackgroundColor3 = library.Theme.Text,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(16, 16)
    })
    Utils.CreateInstance("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

    local state = default == true
    local controller = {}

    local function apply(value, skipCallback, skipBroadcast)
        state = value == true
        library:SetFlag(flag, state)
        Tween.Play(library, track, {BackgroundColor3 = state and library.Theme.Accent or library.Theme.Tertiary}, 0.2)
        Tween.Play(library, knob, {Position = state and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)}, 0.2)
        if not skipCallback then
            Utils.SafeCallback(callback, state)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, state, controller, not skipCallback)
        end
    end

    library:AddConnection(row, "MouseButton1Click", function()
        apply(not state)
    end)

    controller.GetState = function()
        return state
    end
    controller.SetState = function(_, value, skipCallback)
        apply(value, skipCallback, false)
    end
    controller._ReceiveShared = function(_, value, triggerCallback)
        apply(value, not triggerCallback, true)
    end

    library:RegisterFlagControl(flag, controller)
    apply(state, true, true)
    return controller
end

return Toggle
