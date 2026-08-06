local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Levels = Registry["Core/Logging/Levels"] or {DEBUG = 10, INFO = 20, WARN = 30, ERROR = 40}
local History = Registry["Core/Logging/History"]

local Logger = {
    Level = Levels.DEBUG
}

local function write(level, message, context)
    local entry = {
        Level = level,
        Message = tostring(message or ""),
        Context = context,
        Time = os.time()
    }

    if History then
        History.Push(entry)
    end

    local text = string.format("[Vanguard][%s] %s", level, entry.Message)
    if level == "WARN" or level == "ERROR" then
        warn(text)
    else
        print(text)
    end

    return entry
end

function Logger.SetLevel(level)
    if Levels[level] then
        Logger.Level = Levels[level]
        return true
    end
    return false
end

function Logger.Log(level, message, context)
    if (Levels[level] or Levels.INFO) < Logger.Level then
        return nil
    end
    return write(level, message, context)
end

function Logger.Debug(message, context) return Logger.Log("DEBUG", message, context) end
function Logger.Info(message, context) return Logger.Log("INFO", message, context) end
function Logger.Warn(message, context) return Logger.Log("WARN", message, context) end
function Logger.Error(message, context) return Logger.Log("ERROR", message, context) end

return Logger
