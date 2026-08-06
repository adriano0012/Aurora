local Queue = {}
Queue.__index = Queue

function Queue.new()
    return setmetatable({_items = {}, _first = 1, _last = 0}, Queue)
end

function Queue:Push(value)
    self._last = self._last + 1
    self._items[self._last] = value
end

function Queue:Pop()
    if self._first > self._last then
        return nil
    end
    local value = self._items[self._first]
    self._items[self._first] = nil
    self._first = self._first + 1
    return value
end

return Queue
