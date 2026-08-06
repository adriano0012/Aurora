local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({
        _handlers = {},
        _destroyed = false
    }, Signal)
end

function Signal:Connect(callback)
    assert(type(callback) == "function", "Signal:Connect requires a function")
    if self._destroyed then
        return {Disconnect = function() end}
    end

    local handlers = self._handlers
    table.insert(handlers, callback)

    return {
        Disconnect = function()
            for index, handler in ipairs(handlers) do
                if handler == callback then
                    table.remove(handlers, index)
                    break
                end
            end
        end
    }
end

function Signal:Fire(...)
    if self._destroyed then
        return false
    end

    for _, callback in ipairs(self._handlers) do
        local ok, err = pcall(callback, ...)
        if not ok then
            warn("[Vanguard][Signal] " .. tostring(err))
        end
    end

    return true
end

function Signal:Destroy()
    self._destroyed = true
    self._handlers = {}
end

return Signal
