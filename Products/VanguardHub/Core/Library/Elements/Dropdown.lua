local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Dropdown = {}

function Dropdown.Create(tabContext, section, text, flag, options, callback)
    local library = tabContext.Library
    local values = options or {}
    local index = 1
    local root = Utils.CreateInstance("Frame", {
        Parent = section.Body,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        ClipsDescendants = false
    })
    Utils.CreateInstance("UICorner", {Parent = root, CornerRadius = UDim.new(0, 4)})
    local button = Utils.CreateInstance("TextButton", {
        Parent = root,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Main,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Font = Enum.Font.GothamMedium,
        Text = ""
    })
    Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0.02, 0, 0, 7),
        Font = Enum.Font.GothamMedium,
        Text = tostring(text or ""),
        TextColor3 = library.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local selected = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 0, 20),
        Position = UDim2.new(0.56, 0, 0, 7),
        Font = Enum.Font.GothamMedium,
        Text = tostring(values[1] or "Select"),
        TextColor3 = library.Theme.TextDim,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    local arrow = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -22, 0, 7),
        Font = Enum.Font.GothamBold,
        Text = "v",
        TextColor3 = library.Theme.TextDim,
        TextSize = 12
    })
    local content = Utils.CreateInstance("ScrollingFrame", {
        Parent = root,
        BackgroundColor3 = library.Theme.Main,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 34),
        ClipsDescendants = true,
        CanvasSize = UDim2.new(),
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = true
    })
    Utils.CreateInstance("UICorner", {Parent = content, CornerRadius = UDim.new(0, 4)})
    local list = Utils.CreateInstance("UIListLayout", {
        Parent = content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    library:AddConnection(list, "AbsoluteContentSize", function()
        content.CanvasSize = UDim2.fromOffset(0, list.AbsoluteContentSize.Y + 6)
    end)

    local open = false
    local optionButtons = {}

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
        selected.Text = tostring(value)
        if not skipCallback then
            Utils.SafeCallback(callback, value)
        end
        if not skipBroadcast then
            library:BroadcastFlag(flag, value, controller, not skipCallback)
        end
    end

    local function setOpen(state)
        open = state == true
        local expandedHeight = open and math.min(list.AbsoluteContentSize.Y + 6, 200) or 0
        root.Size = UDim2.new(1, 0, 0, open and (34 + expandedHeight) or 40)
        if Tween then
            Tween.Play(library, content, {Size = UDim2.new(1, 0, 0, expandedHeight)}, 0.2)
        else
            content.Size = UDim2.new(1, 0, 0, expandedHeight)
        end
        arrow.Text = open and "^" or "v"
    end

    local function rebuildOptions()
        for _, optionButton in ipairs(optionButtons) do
            optionButton:Destroy()
        end
        optionButtons = {}
        for _, value in ipairs(values) do
            local optionButton = Utils.CreateInstance("TextButton", {
                Parent = content,
                AutoButtonColor = false,
                BackgroundColor3 = library.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 26),
                Position = UDim2.new(0, 5, 0, 0),
                BorderSizePixel = 0,
                Font = Enum.Font.GothamMedium,
                Text = tostring(value),
                TextColor3 = library.Theme.Text,
                TextSize = 11
            })
            Utils.CreateInstance("UICorner", {Parent = optionButton, CornerRadius = UDim.new(0, 4)})
            library:AddConnection(optionButton, "MouseEnter", function()
                if Tween then
                    Tween.Play(library, optionButton, {BackgroundColor3 = library.Theme.Hover}, 0.15)
                end
            end)
            library:AddConnection(optionButton, "MouseLeave", function()
                if Tween then
                    Tween.Play(library, optionButton, {BackgroundColor3 = library.Theme.Secondary}, 0.15)
                end
            end)
            library:AddConnection(optionButton, "MouseButton1Click", function()
                apply(value, false, false)
                setOpen(false)
            end)
            table.insert(optionButtons, optionButton)
        end
    end

    library:AddConnection(button, "MouseButton1Click", function()
        setOpen(not open)
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
        rebuildOptions()
        selected.Text = tostring(values[index] or "Select")
    end
    controller._ReceiveShared = function(_, value, triggerCallback)
        apply(value, not triggerCallback, true)
    end

    library:RegisterFlagControl(flag, controller)
    rebuildOptions()
    selected.Text = tostring(values[index] or "Select")
    setOpen(false)
    return controller
end

return Dropdown
