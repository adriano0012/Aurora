local Cleanup = {}
Cleanup.__index = Cleanup

function Cleanup.new()
    return setmetatable({_tasks = {}}, Cleanup)
end

function Cleanup:Add(task)
    table.insert(self._tasks, task)
    return task
end

function Cleanup:Run()
    for _, task in ipairs(self._tasks) do
        if type(task) == "function" then
            pcall(task)
        elseif type(task) == "table" and type(task.Disconnect) == "function" then
            pcall(function() task:Disconnect() end)
        elseif type(task) == "table" and type(task.Destroy) == "function" then
            pcall(function() task:Destroy() end)
        end
    end
    self._tasks = {}
end

return Cleanup
