local History = {
    Max = 250,
    Items = {}
}

function History.Push(entry)
    table.insert(History.Items, entry)
    while #History.Items > History.Max do
        table.remove(History.Items, 1)
    end
end

function History.All()
    local copy = {}
    for index, entry in ipairs(History.Items) do
        copy[index] = entry
    end
    return copy
end

function History.Clear()
    History.Items = {}
end

return History
