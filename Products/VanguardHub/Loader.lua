local Vanguard = {
    Version = "2.0.0",
    Branch = "main",
    CacheToken = nil,
    State = "idle",
    Debug = true,
    Modules = {},
    Tabs = {},
    FailedTabs = {},
    LoadedPlugins = {}
}

_G.__VanguardModuleRegistry = _G.__VanguardModuleRegistry or {}

local function safeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

local function log(level, message)
    local prefix = ({
        DEBUG = "[DEBUG]",
        INFO = "[INFO]",
        WARN = "[WARN]",
        ERROR = "[ERROR]",
        OK = "[OK]"
    })[level] or "[LOG]"

    print(string.format("[Vanguard] %s %s", prefix, message))
end

local function buildHttpClient()
    local clients = {}
    local syn = safeGlobal("syn")
    local request = safeGlobal("request")
    local httpRequest = safeGlobal("http_request")

    local function add(name, callback)
        table.insert(clients, {
            Name = name,
            Callback = callback
        })
    end

    if type(syn) == "table" and type(syn.request) == "function" then
        add("syn.request", function(url)
            local response = syn.request({Url = url, Method = "GET"})
            return response and response.Body
        end)
    end

    if type(request) == "function" then
        add("request", function(url)
            local response = request({Url = url, Method = "GET"})
            return response and response.Body
        end)
    end

    if type(httpRequest) == "function" then
        add("http_request", function(url)
            local response = httpRequest({Url = url, Method = "GET"})
            return response and response.Body
        end)
    end

    if type(game.HttpGet) == "function" then
        add("game.HttpGet", function(url)
            return game:HttpGet(url)
        end)
    end

    return function(url)
        local lastError = "No HTTP client available"

        for _, client in ipairs(clients) do
            local ok, body = pcall(client.Callback, url)
            if ok and type(body) == "string" and body ~= "" then
                return body
            end
            lastError = ok and "Empty response" or tostring(body)
        end

        return nil, lastError
    end
end

local httpGet = buildHttpClient()

function Vanguard:GetModuleUrl(modulePath)
    return string.format(
        "https://raw.githubusercontent.com/adriano0012/Aurora/%s/Products/VanguardHub/%s.lua?v=%s",
        self.Branch,
        modulePath,
        self.CacheToken or self.Version
    )
end

function Vanguard:LoadModule(modulePath, required)
    local registry = rawget(_G, "__VanguardModuleRegistry")
    if registry and registry[modulePath] ~= nil then
        return registry[modulePath]
    end

    local url = self:GetModuleUrl(modulePath)
    local source, err = httpGet(url)

    if not source then
        if required then
            error(string.format("Failed to download %s: %s", modulePath, tostring(err)))
        end
        return nil, err
    end

    if source:match("<!DOCTYPE html>") or source:match("^404:") then
        if required then
            error(string.format("Invalid response while loading %s", modulePath))
        end
        return nil, "Invalid response"
    end

    local chunk, compileErr = loadstring(source, "@Vanguard/" .. modulePath .. ".lua")
    if not chunk then
        if required then
            error(string.format("Compile error in %s: %s", modulePath, tostring(compileErr)))
        end
        return nil, compileErr
    end

    local ok, result = xpcall(chunk, function(loadErr)
        return debug.traceback(loadErr, 2)
    end)

    if not ok then
        if required then
            error(string.format("Execution error in %s:\n%s", modulePath, tostring(result)))
        end
        return nil, result
    end

    self.Modules[modulePath] = result
    if registry then
        registry[modulePath] = result
    end
    return result
end

function Vanguard:PreloadModules(modulePaths, required)
    for _, modulePath in ipairs(modulePaths or {}) do
        self:LoadModule(modulePath, required == true)
    end
end

function Vanguard:LoadManifestModules(manifestPath, required)
    local manifest = self:LoadModule(manifestPath, required == true)
    if type(manifest) ~= "table" then
        return nil
    end

    local modulePaths = {}
    if type(manifest.Modules) == "table" then
        modulePaths = manifest.Modules
    else
        for _, modulePath in pairs(manifest) do
            if type(modulePath) == "string" then
                table.insert(modulePaths, modulePath)
            end
        end
    end

    self:PreloadModules(modulePaths, required == true)
    return manifest
end

function Vanguard:CreateGameContext(ui, gameDefinition)
    local context = {
        UI = ui,
        Definition = gameDefinition,
        Tabs = {},
        Plugins = {},
        Shared = {}
    }

    function context:AddTab(name, modulePath, options)
        table.insert(self.Tabs, {
            Name = name,
            ModulePath = modulePath,
            Options = options or {}
        })
        return self
    end

    function context:SetTheme(themeName)
        if type(ui.SetTheme) == "function" then
            ui:SetTheme(themeName)
        end
        return self
    end

    function context:SetBackground(image)
        if type(ui.SetBackground) == "function" then
            ui:SetBackground(image)
        end
        return self
    end

    function context:SetSubtitle(text)
        if type(ui.SetSubtitle) == "function" then
            ui:SetSubtitle(text)
        end
        return self
    end

    return context
end

function Vanguard:LoadPlugins(gameContext)
    local registry = self:LoadModule("Plugins/Registry", false)
    local pluginLoader = self:LoadModule("Plugins/Loader", false)
    if type(registry) ~= "table" or type(pluginLoader) ~= "table" or type(pluginLoader.Load) ~= "function" then
        return
    end

    local result = pluginLoader.Load(registry, function(modulePath, required)
        return self:LoadModule(modulePath, required)
    end, gameContext)

    for _, pluginPath in ipairs(result.Loaded or {}) do
        table.insert(self.LoadedPlugins, pluginPath)
    end

    for _, failed in ipairs(result.Failed or {}) do
        log("WARN", string.format("Plugin %s failed: %s", failed.Path, failed.Error))
    end
end

function Vanguard:LoadCore()
    local manifests = {
        "Core/Environment/Init",
        "Core/Events/Init",
        "Core/Logging/Init",
        "Core/Update/Init",
        "Core/Utils/Init",
        "Core/Config/Init",
        "Core/Assets/Init",
        "Core/Services/Init",
        "Core/Themes/Init",
        "Core/API/Init"
    }

    for _, manifestPath in ipairs(manifests) do
        local ok, err = pcall(function()
            self:LoadManifestModules(manifestPath, false)
        end)
        if not ok then
            log("WARN", string.format("Core manifest %s failed: %s", manifestPath, tostring(err)))
        end
    end
end

function Vanguard:Init()
    if self.State == "loading" then
        return
    end

    _G.__VanguardModuleRegistry = {}

    self.State = "loading"
    self.CacheToken = tostring(math.floor(((tick and tick()) or os.clock()) * 1000))
    self.FailedTabs = {}
    self.Tabs = {}

    log("INFO", "Bootstrapping Vanguard Hub 2.0")

    local bootstrap = self:LoadModule("Loader/Bootstrap", true)
    local gameLoader = self:LoadModule("Loader/GameLoader", true)
    self:LoadCore()
    local libraryManifest = self:LoadModule("Core/Library/Init", true)
    for _, modulePath in ipairs(libraryManifest.Modules or {}) do
        self:LoadModule(modulePath, true)
    end
    local library = self:LoadModule(libraryManifest.Entry or "Core/Library/Window", true)
    local themeCatalog = self:LoadModule("Core/Themes/Catalog", true)
    local storage = self:LoadModule("Core/Services/Storage", true)
    local saveCodec = self:LoadModule("Core/Config/Save", true)
    local loadCodec = self:LoadModule("Core/Config/Load", true)
    local profile = self:LoadModule("Core/Config/Profile", true)
    local configManager = self:LoadModule("Core/Config/ConfigManager", true)

    if type(library.SetThemeCatalog) == "function" then
        library:SetThemeCatalog(themeCatalog)
    end

    local gameModulePath = gameLoader.Resolve(game.PlaceId, bootstrap.Games, bootstrap.Fallback)
    local gameDefinition = self:LoadModule(gameModulePath, true)
    local gameUtils = self:LoadModule(gameDefinition.UtilsModule or (gameModulePath:gsub("/Init$", "/Modules/Utils")), false) or {}
    local configSchema = self:LoadModule(gameDefinition.ConfigSchema or (gameModulePath:gsub("/Init$", "/Config/Schema")), false)
    local configAdapter = self:LoadModule(gameDefinition.ConfigAdapter or (gameModulePath:gsub("/Init$", "/Config/Adapter")), false)

    local config = configSchema
    if configSchema and configAdapter then
        config = configManager.new({
            gameName = gameDefinition.Name or "Universal",
            schema = configSchema,
            adapter = configAdapter,
            storage = storage,
            saveCodec = saveCodec,
            loadCodec = loadCodec,
            profile = profile,
            defaults = profile.DeepCopy(configAdapter.ExportSnapshot and configAdapter.ExportSnapshot(configSchema) or {})
        })
    end

    if config and type(config.Load) == "function" then
        pcall(config.Load, config)
    end

    if type(gameUtils.SetConfig) == "function" then
        pcall(gameUtils.SetConfig, config)
    end

    local background = gameDefinition.Background
    if type(background) == "string" and background:find("/") then
        local resolvedBackground = self:LoadModule(background, false)
        if type(resolvedBackground) == "string" then
            background = resolvedBackground
        end
    end

    local ui = library:new("Vanguard Hub", {
        Subtitle = gameDefinition.DisplayName or gameDefinition.Name or "Universal",
        Background = background
    })

    if type(ui.SetTheme) == "function" then
        ui:SetTheme((config and config.Theme) or gameDefinition.Theme or "Dark")
    end

    local gameContext = self:CreateGameContext(ui, gameDefinition)
    self.Game = gameContext
    self.UI = ui
    self.Config = config
    self.Utils = gameUtils

    if type(gameDefinition.Register) == "function" then
        gameDefinition:Register(gameContext)
    end

    self:LoadPlugins(gameContext)

    for _, tab in ipairs(gameContext.Tabs) do
        local module, loadErr = self:LoadModule(tab.ModulePath, false)
        if not module then
            table.insert(self.FailedTabs, {name = tab.Name, error = tostring(loadErr)})
        else
            local ok, initErr = xpcall(function()
                return module(ui, config, gameUtils, gameContext, tab.Options)
            end, function(tabErr)
                return debug.traceback(tabErr, 2)
            end)

            if ok then
                table.insert(self.Tabs, tab.Name)
            else
                table.insert(self.FailedTabs, {name = tab.Name, error = tostring(initErr)})
            end
        end
    end

    self.State = #self.FailedTabs == 0 and "loaded" or "partial"
    log("OK", string.format("Game loader: %s", gameModulePath))
    log("OK", string.format("Tabs loaded: %d", #self.Tabs))

    if #self.FailedTabs > 0 then
        for _, failed in ipairs(self.FailedTabs) do
            log("WARN", string.format("Tab %s failed: %s", failed.name, failed.error))
        end
    end

    return self
end

function Vanguard:Destroy()
    if self.UI and type(self.UI.Destroy) == "function" then
        pcall(function()
            self.UI:Destroy()
        end)
    end

    self.State = "idle"
    self.Modules = {}
    self.Tabs = {}
    self.UI = nil
end

local ok, result = pcall(function()
    return Vanguard:Init()
end)

if not ok then
    Vanguard.State = "failed"
    log("ERROR", tostring(result))
    error(result, 0)
end

return result
