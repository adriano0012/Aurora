local Studio = {}

function Studio.IsStudio()
    local ok, result = pcall(function()
        return game:GetService("RunService"):IsStudio()
    end)
    return ok and result == true
end

return Studio
