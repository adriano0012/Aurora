local String = {}

function String.Trim(value)
    return tostring(value or ""):match("^%s*(.-)%s*$")
end

function String.IsBlank(value)
    return String.Trim(value) == ""
end

return String
