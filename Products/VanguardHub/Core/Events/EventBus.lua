local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Signal = Registry["Core/Events/Signal"]

local EventBus = {
    _events = {}
}

function EventBus.Get(name)
    assert(type(name) == "string" and name ~= "", "EventBus.Get requires an event name")
    EventBus._events[name] = EventBus._events[name] or Signal.new()
    return EventBus._events[name]
end

function EventBus.On(name, callback)
    return EventBus.Get(name):Connect(callback)
end

function EventBus.Emit(name, ...)
    return EventBus.Get(name):Fire(...)
end

function EventBus.Clear(name)
    if name then
        if EventBus._events[name] then
            EventBus._events[name]:Destroy()
            EventBus._events[name] = nil
        end
        return
    end

    for _, signal in pairs(EventBus._events) do
        signal:Destroy()
    end
    EventBus._events = {}
end

return EventBus
