local Storage = {}

function Storage.Exists(path)
    return type(isfile) == "function" and isfile(path) or false
end

function Storage.Read(path)
    if type(readfile) ~= "function" or not Storage.Exists(path) then
        return nil
    end

    local ok, data = pcall(readfile, path)
    return ok and data or nil
end

function Storage.Write(path, data)
    if type(writefile) ~= "function" then
        return false
    end

    local directory = path:match("^(.*)[/\\][^/\\]+$")
    if directory and type(makefolder) == "function" and type(isfolder) == "function" and not isfolder(directory) then
        pcall(makefolder, directory)
    end

    return pcall(writefile, path, data)
end

return Storage
