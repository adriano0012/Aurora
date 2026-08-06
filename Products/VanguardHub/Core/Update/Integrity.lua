local Integrity = {}

function Integrity.HasRequiredModules(manifest, registry)
    local missing = {}
    for _, modulePath in ipairs((manifest and manifest.Modules) or {}) do
        if not registry or registry[modulePath] == nil then
            table.insert(missing, modulePath)
        end
    end
    return #missing == 0, missing
end

return Integrity
