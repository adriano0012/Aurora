local Save = {}

function Save.BuildPath(gameName, sectionName)
    return string.format("Configs/%s/%s.json", tostring(gameName), tostring(sectionName))
end

return Save
