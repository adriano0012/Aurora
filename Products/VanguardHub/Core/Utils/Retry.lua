local Retry = {}

function Retry.Run(callback, attempts)
    attempts = attempts or 3
    local lastError

    for _ = 1, attempts do
        local ok, result = pcall(callback)
        if ok then
            return true, result
        end
        lastError = result
    end

    return false, lastError
end

return Retry
