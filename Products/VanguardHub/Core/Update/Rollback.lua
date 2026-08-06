local Rollback = {
    Snapshots = {}
}

function Rollback.Save(name, snapshot)
    if type(name) ~= "string" or name == "" then
        return false, "rollback name is required"
    end
    Rollback.Snapshots[name] = snapshot
    return true
end

function Rollback.Get(name)
    return Rollback.Snapshots[name]
end

return Rollback
