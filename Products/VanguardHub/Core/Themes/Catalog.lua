local function merge(baseTheme, overrides)
    local merged = {}
    for key, value in pairs(baseTheme) do
        merged[key] = value
    end
    for key, value in pairs(overrides or {}) do
        merged[key] = value
    end
    return merged
end

local dark = {
    Main = Color3.fromRGB(1, 6, 7),
    Secondary = Color3.fromRGB(7, 12, 14),
    Tertiary = Color3.fromRGB(18, 25, 28),
    Accent = Color3.fromRGB(128, 94, 245),
    AccentDark = Color3.fromRGB(90, 63, 190),
    Text = Color3.fromRGB(245, 245, 247),
    TextDim = Color3.fromRGB(163, 165, 167),
    Muted = Color3.fromRGB(119, 123, 126),
    Border = Color3.fromRGB(21, 25, 28),
    CardBorder = Color3.fromRGB(24, 32, 36),
    Selected = Color3.fromRGB(49, 38, 93),
    Success = Color3.fromRGB(63, 182, 29),
    Info = Color3.fromRGB(67, 165, 255),
    Danger = Color3.fromRGB(255, 65, 65),
    Warning = Color3.fromRGB(255, 196, 0),
    Hover = Color3.fromRGB(22, 28, 31),
    Glass = Color3.fromRGB(4, 10, 12)
}

return {
    Dark = dark,
    Purple = merge(dark, {Accent = Color3.fromRGB(128, 94, 245), AccentDark = Color3.fromRGB(90, 63, 190), Selected = Color3.fromRGB(49, 38, 93)}),
    Blue = merge(dark, {Accent = Color3.fromRGB(67, 165, 255), AccentDark = Color3.fromRGB(46, 112, 184), Selected = Color3.fromRGB(27, 57, 91)}),
    Green = merge(dark, {Accent = Color3.fromRGB(70, 196, 116), AccentDark = Color3.fromRGB(45, 132, 77), Selected = Color3.fromRGB(26, 73, 46)}),
    Gold = merge(dark, {Accent = Color3.fromRGB(239, 177, 58), AccentDark = Color3.fromRGB(183, 125, 28), Selected = Color3.fromRGB(84, 61, 24)}),
    Light = {
        Main = Color3.fromRGB(235, 239, 244),
        Secondary = Color3.fromRGB(246, 248, 250),
        Tertiary = Color3.fromRGB(220, 225, 230),
        Accent = Color3.fromRGB(89, 102, 255),
        AccentDark = Color3.fromRGB(63, 75, 201),
        Text = Color3.fromRGB(25, 28, 34),
        TextDim = Color3.fromRGB(93, 102, 114),
        Muted = Color3.fromRGB(132, 141, 154),
        Border = Color3.fromRGB(193, 200, 210),
        CardBorder = Color3.fromRGB(181, 188, 198),
        Selected = Color3.fromRGB(203, 210, 255),
        Success = Color3.fromRGB(35, 154, 76),
        Info = Color3.fromRGB(53, 143, 227),
        Danger = Color3.fromRGB(220, 68, 68),
        Warning = Color3.fromRGB(223, 173, 32),
        Hover = Color3.fromRGB(225, 230, 236),
        Glass = Color3.fromRGB(255, 255, 255)
    }
}
