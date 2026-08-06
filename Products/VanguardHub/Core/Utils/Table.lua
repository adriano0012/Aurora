local Table = {}

function Table.DeepCopy(value, seen)
    if type(value) ~= "table" then
        return value
    end

    seen = seen or {}
    if seen[value] then
        return seen[value]
    end

    local copy = {}
    seen[value] = copy
    for key, item in pairs(value) do
        copy[Table.DeepCopy(key, seen)] = Table.DeepCopy(item, seen)
    end
    return copy
end

function Table.Merge(base, override)
    local result = Table.DeepCopy(base or {})
    for key, value in pairs(override or {}) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = Table.Merge(result[key], value)
        else
            result[key] = Table.DeepCopy(value)
        end
    end
    return result
end

return Table
