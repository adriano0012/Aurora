local Signals = {}

function Signals.new()
    local listeners = {}

    return {
        Connect = function(_, callback)
            table.insert(listeners, callback)
            return {
                Disconnect = function()
                    for index, listener in ipairs(listeners) do
                        if listener == callback then
                            table.remove(listeners, index)
                            break
                        end
                    end
                end
            }
        end,
        Fire = function(_, ...)
            for _, listener in ipairs(listeners) do
                task.spawn(listener, ...)
            end
        end
    }
end

return Signals
