local Registry = rawget(_G, "__VanguardModuleRegistry") or {}

local Assets = {
    Icons = Registry["Core/Assets/Icons"] or {},
    Fonts = Registry["Core/Assets/Fonts"] or {},
    Images = Registry["Core/Assets/Images"] or {},
    Sounds = Registry["Core/Assets/Sounds"] or {}
}

function Assets.Get(bucket, name)
    local group = Assets[bucket]
    if type(group) ~= "table" then
        return nil
    end
    return group[name]
end

return Assets
