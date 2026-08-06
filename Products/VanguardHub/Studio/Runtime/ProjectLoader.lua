local ProjectLoader = {}

function ProjectLoader.Start(options)
    options = options or {}

    return {
        Started = true,
        ProductRoot = options.ProductRoot,
        Game = options.Game or "Universal",
        Mode = options.Mode or "UI"
    }
end

return ProjectLoader
