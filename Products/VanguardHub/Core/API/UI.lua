local UI = {}

function UI.Attach(window)
    return {
        SetTheme = function(_, ...)
            return window.SetTheme and window:SetTheme(...)
        end,
        SetBackground = function(_, ...)
            return window.SetBackground and window:SetBackground(...)
        end,
        SetSubtitle = function(_, ...)
            return window.SetSubtitle and window:SetSubtitle(...)
        end
    }
end

return UI
