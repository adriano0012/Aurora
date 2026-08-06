local Migration = {}

function Migration.Run(snapshot, migrations, fromVersion)
    snapshot = snapshot or {}
    local current = fromVersion or snapshot.Version or "0.0.0"

    for _, migration in ipairs(migrations or {}) do
        if type(migration) == "table" and type(migration.Apply) == "function" then
            local ok, result = pcall(migration.Apply, snapshot, current)
            if ok and type(result) == "table" then
                snapshot = result
            elseif not ok then
                return nil, tostring(result)
            end
            current = migration.Version or current
            snapshot.Version = current
        end
    end

    return snapshot
end

return Migration
