local TweenService = game:GetService("TweenService")

local Tween = {}

function Tween.Play(library, instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.2
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out

    if not instance then
        return nil
    end

    if library and library.Flags and library.Flags.Animations == false then
        for property, value in pairs(properties or {}) do
            pcall(function()
                instance[property] = value
            end)
        end
        return nil
    end

    local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

return Tween
