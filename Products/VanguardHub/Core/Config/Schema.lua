local Schema = {}

function Schema.ApplyDefaults(target, defaults)
    target = target or {}

    for key, value in pairs(defaults or {}) do
        if type(value) == "table" then
            target[key] = Schema.ApplyDefaults(type(target[key]) == "table" and target[key] or {}, value)
        elseif target[key] == nil then
            target[key] = value
        end
    end

    return target
end

function Schema.Validate(data, rules)
    local errors = {}

    for key, expectedType in pairs(rules or {}) do
        if data[key] ~= nil and type(data[key]) ~= expectedType then
            table.insert(errors, string.format("%s expected %s, got %s", key, expectedType, type(data[key])))
        end
    end

    return #errors == 0, errors
end

return Schema
