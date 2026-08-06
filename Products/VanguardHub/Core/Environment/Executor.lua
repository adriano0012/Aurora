local Executor = {}

local function safeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

function Executor.Detect()
    local syn = safeGlobal("syn")

    if type(syn) == "table" then
        return "Synapse"
    end

    if type(safeGlobal("iswave")) == "function" then
        return "Wave"
    end

    if type(safeGlobal("identifyexecutor")) == "function" then
        local ok, name = pcall(safeGlobal("identifyexecutor"))
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end

    if type(safeGlobal("getexecutorname")) == "function" then
        local ok, name = pcall(safeGlobal("getexecutorname"))
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end

    return "Universal"
end

return Executor
