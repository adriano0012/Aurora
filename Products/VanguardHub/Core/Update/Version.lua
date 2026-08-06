local Version = {}

function Version.Parse(value)
    local major, minor, patch = tostring(value or "0.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
    return {
        Major = tonumber(major) or 0,
        Minor = tonumber(minor) or 0,
        Patch = tonumber(patch) or 0,
        Raw = tostring(value or "0.0.0")
    }
end

function Version.Compare(left, right)
    left = type(left) == "table" and left or Version.Parse(left)
    right = type(right) == "table" and right or Version.Parse(right)

    for _, key in ipairs({"Major", "Minor", "Patch"}) do
        if left[key] < right[key] then return -1 end
        if left[key] > right[key] then return 1 end
    end

    return 0
end

return Version
