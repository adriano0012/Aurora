local Profile = {}

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, item in pairs(value) do
        copy[key] = deepCopy(item)
    end
    return copy
end

function Profile.DeepCopy(value)
    return deepCopy(value)
end

function Profile.Merge(target, source)
    for key, value in pairs(source or {}) do
        if type(value) == "table" and type(target[key]) == "table" then
            Profile.Merge(target[key], value)
        else
            target[key] = deepCopy(value)
        end
    end
    return target
end

return Profile
