local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Button = {}

function Button.Create(tabContext, section, text, callback)
    local library = tabContext.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = section.Body,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Font = Enum.Font.GothamMedium,
        Text = text or "Button",
        TextColor3 = library.Theme.Text,
        TextSize = 12
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    library:AddConnection(button, "MouseEnter", function()
        Tween.Play(library, button, {BackgroundColor3 = library.Theme.Hover}, 0.15)
    end)
    library:AddConnection(button, "MouseLeave", function()
        Tween.Play(library, button, {BackgroundColor3 = library.Theme.Tertiary}, 0.15)
    end)
    library:AddConnection(button, "MouseButton1Click", function()
        Utils.SafeCallback(callback)
    end)
    return button
end

return Button
