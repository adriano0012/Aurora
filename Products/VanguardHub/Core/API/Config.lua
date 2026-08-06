local ConfigAPI = {}

function ConfigAPI.Attach(config)
    return {
        Save = function()
            return config.Save and config:Save()
        end,
        Load = function()
            return config.Load and config:Load()
        end
    }
end

return ConfigAPI
