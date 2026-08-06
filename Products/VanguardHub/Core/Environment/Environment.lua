local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Resolver = Registry["Core/Environment/Resolver"]

local Environment = {
    Current = nil
}

function Environment.Refresh()
    local ok, result = pcall(function()
        return Resolver.Resolve()
    end)

    Environment.Current = ok and result or {
        IsStudio = false,
        Executor = "Unknown",
        Capabilities = {},
        Available = false,
        Error = tostring(result)
    }

    return Environment.Current
end

function Environment.Get()
    return Environment.Current or Environment.Refresh()
end

function Environment.Has(capability)
    local current = Environment.Get()
    return current.Capabilities and current.Capabilities[capability] == true
end

return Environment
