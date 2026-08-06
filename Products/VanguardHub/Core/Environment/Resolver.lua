local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Studio = Registry["Core/Environment/Studio"]
local Executor = Registry["Core/Environment/Executor"]
local Capabilities = Registry["Core/Environment/Capabilities"]

local Resolver = {}

function Resolver.Resolve()
    local isStudio = Studio and Studio.IsStudio() or false
    local executorName = Executor and Executor.Detect() or "Universal"

    return {
        IsStudio = isStudio,
        Executor = isStudio and "Studio" or executorName,
        Capabilities = Capabilities and Capabilities.Scan() or {},
        Available = true
    }
end

return Resolver
