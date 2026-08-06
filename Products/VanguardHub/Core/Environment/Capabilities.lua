local Capabilities = {}

local function safeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

function Capabilities.Scan()
    local syn = safeGlobal("syn")
    local request = safeGlobal("request") or safeGlobal("http_request")

    return {
        Clipboard = type(safeGlobal("setclipboard")) == "function",
        Filesystem = type(safeGlobal("readfile")) == "function"
            and type(safeGlobal("writefile")) == "function",
        Folders = type(safeGlobal("makefolder")) == "function",
        HTTP = type(request) == "function"
            or (type(syn) == "table" and type(syn.request) == "function")
            or type(game.HttpGet) == "function",
        Drawing = type(safeGlobal("Drawing")) == "table",
        GetHui = type(safeGlobal("gethui")) == "function",
        ProtectGui = type(safeGlobal("syn")) == "table"
            and type(syn.protect_gui) == "function",
        QueueOnTeleport = type(safeGlobal("queue_on_teleport")) == "function"
    }
end

return Capabilities
