local Permissions = {
    Known = {
        UI = true,
        Config = true,
        Storage = true,
        HTTP = true,
        Clipboard = true,
        Notifications = true
    }
}

function Permissions.Validate(requested)
    local denied = {}

    for _, permission in ipairs(requested or {}) do
        if Permissions.Known[permission] ~= true then
            table.insert(denied, permission)
        end
    end

    return #denied == 0, denied
end

return Permissions
