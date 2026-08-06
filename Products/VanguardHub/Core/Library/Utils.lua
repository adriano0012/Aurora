local StarterGui = game:GetService("StarterGui")

local Utils = {}

local function registry()
    return rawget(_G, "__VanguardModuleRegistry") or {}
end

function Utils.SafeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

function Utils.GetGlobalFunction(name)
    local value = Utils.SafeGlobal(name)
    return type(value) == "function" and value or nil
end

function Utils.CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utils.DeepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, item in pairs(value) do
        copy[key] = Utils.DeepCopy(item)
    end
    return copy
end

function Utils.SafeCallback(callback, ...)
    if type(callback) ~= "function" then
        return
    end

    local args = table.pack(...)
    task.spawn(function()
        local ok, err = xpcall(function()
            callback(table.unpack(args, 1, args.n))
        end, debug.traceback)
        if not ok then
            warn("[Vanguard Library] Callback error:", err)
        end
    end)
end

function Utils.ResolveGuiParent()
    local gui = registry()["Core/Services/Gui"]
    if gui and type(gui.GetParent) == "function" then
        return gui.GetParent()
    end

    return game:GetService("CoreGui")
end

function Utils.ProtectGui(screenGui)
    local gui = registry()["Core/Services/Gui"]
    if gui and type(gui.Protect) == "function" then
        return gui.Protect(screenGui)
    end
    return false
end

function Utils.CopyToClipboard(text)
    local clipboard = registry()["Core/Services/Clipboard"]
    if clipboard and type(clipboard.Copy) == "function" then
        return clipboard.Copy(text)
    end

    return pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "VanguardHub",
            Text = tostring(text),
            Duration = 4
        })
    end)
end

return Utils
