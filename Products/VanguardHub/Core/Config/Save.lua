local HttpService = game:GetService("HttpService")

local Save = {}

local function isColor3(value)
    local ok, kind = pcall(typeof, value)
    return ok and kind == "Color3"
end

local function encode(value)
    if isColor3(value) then
        return {r = value.R * 255, g = value.G * 255, b = value.B * 255}
    end

    if type(value) == "table" then
        local copy = {}
        for key, item in pairs(value) do
            copy[key] = encode(item)
        end
        return copy
    end

    return value
end

function Save.ToJson(data)
    return HttpService:JSONEncode(encode(data))
end

return Save
