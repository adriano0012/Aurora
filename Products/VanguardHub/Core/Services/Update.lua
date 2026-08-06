local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Version = Registry["Core/Update/Version"]

local Update = {}

function Update.Check(currentVersion, manifest)
    if type(manifest) ~= "table" or type(manifest.Version) ~= "string" then
        return {
            Available = false,
            Reason = "missing manifest"
        }
    end

    local compare = Version and Version.Compare(currentVersion, manifest.Version) or 0
    return {
        Available = compare < 0,
        Current = currentVersion,
        Latest = manifest.Version,
        Channel = manifest.Channel or "Stable"
    }
end

return Update
