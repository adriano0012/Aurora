local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]

local Dropdown = {}

function Dropdown.Create(tabContext, section, text, flag, options, callback)
    local library = tabContext.Library
    local values = options or {}
    local index = 1
    local button = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Font = Enum.Font.Gotham,
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})

    local function render()
        button.Text = string.format("%s: %s", text, tostring(values[index] or "None"))
    end

    local controller = {}
    local function apply(newValue, skipCallback, skipBroadcast)
        for candidateIndex, candidate in ipairs(values) do
            if candidate == newValue then
                index = candidateIndex
                break
            end
        end
        local value = values[index]
        library:SetFlag(flag, value)
        render()
        if not skipCallback then
            Utils.SafeCallback(callback, value)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, value, controller, not skipCallback)
        end
    end

    library:AddConnection(button, "MouseButton1Click", function()
        if #values == 0 then
            return
        end
        index = (index % #values) + 1
        apply(values[index], false, false)
    end)

    controller.GetValue = function()
        return values[index]
    end
    controller.SetValue = function(_, value, skipCallback)
        apply(value, skipCallback, false)
    end
    controller.Refresh = function(_, newOptions)
        values = newOptions or {}
        index = 1
        render()
    end
    controller._ReceiveShared = function(_, value, triggerCallback)
        apply(value, not triggerCallback, true)
    end

    library:RegisterFlagControl(flag, controller)
    render()
    return controller
end

return Dropdown
