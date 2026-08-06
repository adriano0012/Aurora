local Loader = {}

function Loader.Load(registry, loadModule, context)
    local loaded = {}
    local failed = {}

    for _, pluginPath in ipairs(registry or {}) do
        local plugin, loadErr = loadModule(pluginPath, false)
        if type(plugin) == "table" and type(plugin.Init) == "function" then
            local ok, initErr = pcall(plugin.Init, plugin, context)
            if ok then
                table.insert(loaded, pluginPath)
            else
                table.insert(failed, {Path = pluginPath, Error = tostring(initErr)})
            end
        else
            table.insert(failed, {Path = pluginPath, Error = tostring(loadErr or "invalid plugin")})
        end
    end

    return {
        Loaded = loaded,
        Failed = failed
    }
end

return Loader
