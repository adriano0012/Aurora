local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Tween = Registry["Core/Library/Tween"]

local Animation = {}

function Animation.Fade(library, instance, transparency, duration)
    local property = "BackgroundTransparency"
    if instance:IsA("TextLabel") or instance:IsA("TextButton") then
        property = "TextTransparency"
    end
    return Tween and Tween.Play(library, instance, {[property] = transparency}, duration) or nil
end

function Animation.Highlight(library, instance, color, duration)
    return Tween and Tween.Play(library, instance, {BackgroundColor3 = color}, duration) or nil
end

return Animation
