local Math = {}

function Math.Clamp(value, minValue, maxValue)
    value = tonumber(value) or 0
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

function Math.Round(value, decimals)
    local multiplier = 10 ^ (decimals or 0)
    return math.floor((value * multiplier) + 0.5) / multiplier
end

return Math
