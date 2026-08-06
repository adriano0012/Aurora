local WindowManager = {
    Windows = {}
}

function WindowManager.Register(name, ui)
    if type(name) ~= "string" or name == "" then
        return false, "window name is required"
    end

    WindowManager.Windows[name] = ui
    return true
end

function WindowManager.Get(name)
    return WindowManager.Windows[name]
end

function WindowManager.Close(name)
    local ui = WindowManager.Windows[name]
    if ui and type(ui.Destroy) == "function" then
        pcall(function()
            ui:Destroy()
        end)
    end
    WindowManager.Windows[name] = nil
end

function WindowManager.CloseAll()
    for name in pairs(WindowManager.Windows) do
        WindowManager.Close(name)
    end
end

return WindowManager
