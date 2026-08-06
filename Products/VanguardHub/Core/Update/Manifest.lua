local Manifest = {}

function Manifest.Validate(data)
    if type(data) ~= "table" then
        return false, "manifest must be a table"
    end
    if type(data.Product) ~= "string" or data.Product == "" then
        return false, "manifest missing Product"
    end
    if type(data.Version) ~= "string" or data.Version == "" then
        return false, "manifest missing Version"
    end
    if data.Modules ~= nil and type(data.Modules) ~= "table" then
        return false, "manifest Modules must be a table"
    end
    return true
end

return Manifest
