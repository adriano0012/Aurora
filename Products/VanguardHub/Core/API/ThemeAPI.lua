local ThemeAPI = {}

function ThemeAPI.Apply(ui, themeName)
    if type(ui) == "table" and type(ui.SetTheme) == "function" then
        return ui:SetTheme(themeName)
    end
    return false
end

return ThemeAPI
