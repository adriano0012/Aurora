local Config = {}

function Config.Bind(manager)
    Config.Manager = manager
    return manager
end

function Config.Get()
    return Config.Manager
end

return Config
