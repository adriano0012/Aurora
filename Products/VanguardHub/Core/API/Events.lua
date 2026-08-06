local Events = {}

function Events.new()
    local listeners = {}

    return {
        Connect = function(_, callback)
            table.insert(listeners, callback)
            return {
                Disconnect = function()
                    for index, item in ipairs(listeners) do
                        if item == callback then
                            table.remove(listeners, index)
                            break
                        end
                    end
                end
            }
        end,
        Fire = function(_, ...)
            for _, callback in ipairs(listeners) do
                task.spawn(callback, ...)
            end
        end
    }
end

return Events
