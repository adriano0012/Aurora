local GameLoader = {}

function GameLoader.Resolve(placeId, games, fallback)
    for _, gameDefinition in ipairs(games or {}) do
        for _, candidate in ipairs(gameDefinition.PlaceIds or {}) do
            if candidate == placeId then
                return gameDefinition.Module
            end
        end
    end

    return fallback or "Games/Universal/Init"
end

return GameLoader
