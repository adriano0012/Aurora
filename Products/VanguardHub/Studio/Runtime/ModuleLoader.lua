local ModuleLoader = {}

function ModuleLoader.Resolve(root, modulePath)
    return {
        Root = root,
        ModulePath = modulePath,
        Path = tostring(root) .. "/" .. tostring(modulePath)
    }
end

return ModuleLoader
