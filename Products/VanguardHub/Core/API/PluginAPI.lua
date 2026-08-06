local PluginAPI = {}

function PluginAPI.Attach(gameContext)
    return {
        AddTab = function(_, ...)
            return gameContext:AddTab(...)
        end,
        SetTheme = function(_, ...)
            return gameContext:SetTheme(...)
        end,
        SetBackground = function(_, ...)
            return gameContext:SetBackground(...)
        end
    }
end

return PluginAPI
