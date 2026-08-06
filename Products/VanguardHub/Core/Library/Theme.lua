local Registry = rawget(_G, "__VanguardModuleRegistry") or {}

local Theme = {
    Catalog = Registry["Core/Themes/Catalog"] or {}
}

function Theme.Get(name)
    return Theme.Catalog[name or "Dark"] or Theme.Catalog.Dark
end

function Theme.Exists(name)
    return Theme.Catalog[name] ~= nil
end

return Theme
