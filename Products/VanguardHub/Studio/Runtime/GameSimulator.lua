local GameSimulator = {}

function GameSimulator.Create(placeId)
    return {
        PlaceId = placeId or 13822889,
        Players = {},
        Objects = {},
        Services = {}
    }
end

return GameSimulator
