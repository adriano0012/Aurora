local Validation = {}

function Validation.Required(value, name)
    if value == nil then
        return false, tostring(name or "value") .. " is required"
    end
    return true
end

function Validation.Type(value, expectedType, name)
    if type(value) ~= expectedType then
        return false, string.format("%s must be %s", tostring(name or "value"), expectedType)
    end
    return true
end

return Validation
