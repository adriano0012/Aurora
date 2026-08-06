local HttpService = game:GetService("HttpService")

local Load = {}

local function decode(value)
    if type(value) == "table" then
        if value.r and value.g and value.b then
            return Color3.fromRGB(value.r, value.g, value.b)
        end

        local copy = {}
        for key, item in pairs(value) do
            copy[key] = decode(item)
        end
        return copy
    end

    return value
end

function Load.FromJson(text)
    return decode(HttpService:JSONDecode(text))
end

return Load
