local Registry = rawget(_G, "__VanguardModuleRegistry") or {}

return Registry["Core/Assets/Fonts"] or {
    Primary = Enum.Font.Gotham,
    Heading = Enum.Font.GothamBold,
    Display = Enum.Font.GothamBlack
}
