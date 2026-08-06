local UserInputService = game:GetService("UserInputService")

local Input = {}

function Input.IsTextBoxFocused()
    return UserInputService:GetFocusedTextBox() ~= nil
end

function Input.BindBegan(callback)
    return UserInputService.InputBegan:Connect(callback)
end

function Input.BindEnded(callback)
    return UserInputService.InputEnded:Connect(callback)
end

return Input
