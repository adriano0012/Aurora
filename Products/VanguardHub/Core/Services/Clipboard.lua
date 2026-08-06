local Clipboard = {}

function Clipboard.Copy(text)
    if type(setclipboard) ~= "function" then
        return false
    end

    return pcall(setclipboard, tostring(text or ""))
end

function Clipboard.Paste()
    local reader = rawget(_G, "getclipboard")
    if type(reader) ~= "function" then
        return nil, "clipboard read is unavailable"
    end

    local ok, result = pcall(reader)
    if not ok then
        return nil, tostring(result)
    end

    return result
end

return Clipboard
