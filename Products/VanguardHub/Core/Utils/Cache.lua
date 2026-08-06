local Cache = {}
Cache.__index = Cache

function Cache.new()
    return setmetatable({_items = {}}, Cache)
end

function Cache:Get(key, factory)
    if self._items[key] == nil and type(factory) == "function" then
        self._items[key] = factory(key)
    end
    return self._items[key]
end

function Cache:Set(key, value)
    self._items[key] = value
    return value
end

function Cache:Clear()
    self._items = {}
end

return Cache
