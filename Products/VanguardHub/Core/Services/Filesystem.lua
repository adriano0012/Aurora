local Filesystem = {}

local function has(name)
    return type(rawget(_G, name)) == "function"
end

function Filesystem.Exists(path)
    return has("isfile") and isfile(path) == true
end

function Filesystem.FolderExists(path)
    return has("isfolder") and isfolder(path) == true
end

function Filesystem.EnsureFolder(path)
    if path == nil or path == "" then
        return true
    end
    if Filesystem.FolderExists(path) then
        return true
    end
    if has("makefolder") then
        local ok = pcall(makefolder, path)
        return ok == true
    end
    return false
end

function Filesystem.Read(path)
    if not has("readfile") or not Filesystem.Exists(path) then
        return nil
    end
    local ok, result = pcall(readfile, path)
    return ok and result or nil
end

function Filesystem.Write(path, content)
    if not has("writefile") then
        return false
    end

    local folder = tostring(path):match("^(.*)[/\\][^/\\]+$")
    if folder and not Filesystem.EnsureFolder(folder) then
        return false
    end

    local ok = pcall(writefile, path, tostring(content or ""))
    return ok == true
end

return Filesystem
