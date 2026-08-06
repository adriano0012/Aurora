local Http = {}

local function safeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

function Http.Get(url)
    local syn = safeGlobal("syn")
    local request = safeGlobal("request")
    local httpRequest = safeGlobal("http_request")

    if type(syn) == "table" and type(syn.request) == "function" then
        local response = syn.request({Url = url, Method = "GET"})
        return response and response.Body
    end

    if type(request) == "function" then
        local response = request({Url = url, Method = "GET"})
        return response and response.Body
    end

    if type(httpRequest) == "function" then
        local response = httpRequest({Url = url, Method = "GET"})
        return response and response.Body
    end

    if type(game.HttpGet) == "function" then
        return game:HttpGet(url)
    end

    return nil
end

return Http
