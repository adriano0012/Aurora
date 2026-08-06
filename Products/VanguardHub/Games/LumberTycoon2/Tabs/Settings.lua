-- ============================================================
-- VANGUARD HUB - SETTINGS
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab("Settings", "6031280882", {
        id = "settings",
        displayName = Utils._("settings_title"),
        sidebar = false
    })

    local function BooleanOrDefault(value, fallback)
        if type(value) == "boolean" then
            return value
        end
        return fallback
    end

    local function GetUIBoolean(name, fallback)
        local flatValue = Config[name]
        if type(flatValue) == "boolean" then
            return flatValue
        end

        local uiConfig = Config.UI
        if type(uiConfig) == "table" and type(uiConfig[name]) == "boolean" then
            return uiConfig[name]
        end

        return fallback
    end

    local function SetUIBoolean(name, value)
        Config[name] = value

        local uiConfig = Config.UI
        if type(uiConfig) == "table" then
            uiConfig[name] = value
        end
    end

    local function RunConfigMethod(methodName, ...)
        local method = Config[methodName]
        if type(method) ~= "function" then
            return false, "Metodo indisponivel: " .. methodName
        end

        local success, result = pcall(method, Config, ...)
        if not success then
            return false, tostring(result)
        end

        if result == false then
            return false, "A operacao nao pode ser concluida"
        end

        return true, result
    end

    local function NotifyResult(successMessage, failureMessage, success, detail)
        if success then
            Utils.Notify("Settings", successMessage, 2)
        else
            local message = failureMessage
            if detail and detail ~= "" then
                message = message .. ": " .. tostring(detail)
            end
            Utils.Notify("Settings", message, 3)
        end
    end

    local function PrioritizeOption(options, preferred)
        if not preferred then
            return options
        end

        local ordered = {preferred}
        for _, option in ipairs(options) do
            if option ~= preferred then
                table.insert(ordered, option)
            end
        end
        return ordered
    end

    local function GetSortedKeys(source)
        local keys = {}
        if type(source) ~= "table" then
            return keys
        end

        for key in pairs(source) do
            table.insert(keys, key)
        end

        table.sort(keys, function(a, b)
            return tostring(a) > tostring(b)
        end)

        return keys
    end

    local function ApplyConfigToUI(triggerCallbacks)
        if type(UI.ApplyConfig) ~= "function" then
            return true
        end

        local success, result = pcall(UI.ApplyConfig, UI, Config, {
            triggerCallbacks = triggerCallbacks ~= false
        })

        if not success then
            return false, tostring(result)
        end

        if result == false then
            return false, "Falha ao sincronizar a interface"
        end

        return true
    end

    local function GetLatestBackupName()
        local backupNames = GetSortedKeys(Config.Backups)
        return backupNames[1]
    end

    local function BuildProfileName()
        local baseName = "Profile_" .. os.date("%Y%m%d_%H%M%S")
        local profileName = baseName
        local suffix = 2

        while type(Config.Profiles) == "table" and Config.Profiles[profileName] do
            profileName = string.format("%s_%02d", baseName, suffix)
            suffix += 1
        end

        return profileName
    end

    local function GetExecutorName()
        local registry = rawget(_G, "__VanguardModuleRegistry") or {}
        local environment = registry["Core/Environment/Environment"]
        if environment and type(environment.Get) == "function" then
            local current = environment.Get()
            if current and current.Executor then
                return tostring(current.Executor)
            end
        end
        return "Unknown"
    end

    local Interface = Tab:Section(Utils._("settings_ui"), true)
    local Configuration = Tab:Section(Utils._("settings_config"), true)
    local Colors = Tab:Section(Utils._("settings_colors"), true)
    local Profiles = Tab:Section(Utils._("settings_profiles"), true)
    local Backup = Tab:Section(Utils._("settings_backup"), true)
    local Info = Tab:Section(Utils._("settings_info"), true)

    local languageOptions = {"Portugues", "English"}
    if Config.Language == "en" then
        languageOptions = PrioritizeOption(languageOptions, "English")
    end

    Interface:Dropdown(Utils._("settings_language"), "Language", languageOptions, function(value)
        Config.Language = value == "Portugues" and "pt" or "en"
        Utils.Notify("Settings", "Idioma alterado para " .. value, 2)
    end)

    local themeIds = {
        ["Dark"] = "Dark",
        ["Purple"] = "Purple",
        ["Blue"] = "Blue",
        ["Green"] = "Green",
        ["Gold"] = "Gold",
        ["Light"] = "Light"
    }
    local themeLabels = {
        Dark = "Dark",
        Purple = "Purple",
        Blue = "Blue",
        Green = "Green",
        Gold = "Gold",
        Light = "Light",
        dark_purple = "Purple",
        dark_blue = "Blue",
        dark_green = "Green",
        dark_gold = "Gold"
    }
    local themeOptions = {"Dark", "Purple", "Blue", "Green", "Gold", "Light"}
    local currentThemeLabel = themeLabels[Config.Theme]
    if currentThemeLabel then
        themeOptions = PrioritizeOption(themeOptions, currentThemeLabel)
    end

    Interface:Dropdown(Utils._("settings_theme"), "Theme", themeOptions, function(value)
        local themeId = themeIds[value] or value
        Config.Theme = themeId

        if type(UI.SetTheme) == "function" then
            local success, err = pcall(UI.SetTheme, UI, themeId)
            if not success then
                Utils.Notify("Settings", "Falha ao aplicar tema: " .. tostring(err), 3)
                return
            end
        end

        Utils.Notify("Settings", "Tema alterado para " .. value, 2)
    end)

    local toggleKey = Config.ToggleUI
    if type(toggleKey) ~= "string" and type(Config.Keybinds) == "table" then
        toggleKey = Config.Keybinds.ToggleUI
    end

    Interface:Keybind(Utils._("settings_toggle_ui"), "ToggleUI", toggleKey or "RightShift", function(value)
        Config.ToggleUI = value

        if type(Config.Keybinds) == "table" then
            Config.Keybinds.ToggleUI = value
        end

        if type(UI.SetToggleKey) == "function" then
            local success, err = pcall(UI.SetToggleKey, UI, value)
            if not success then
                Utils.Notify("Settings", "Falha ao configurar tecla: " .. tostring(err), 3)
            end
        end
    end)

    Interface:Button(Utils._("settings_destroy"), function()
        Utils.Notify("Settings", "Destruindo UI...", 2)
        task.wait(0.2)

        if type(UI.InvokeAction) == "function" then
            local success, result = pcall(UI.InvokeAction, UI, "Close")
            if success and result ~= false then
                return
            end
        end

        if type(UI.Destroy) == "function" then
            UI:Destroy()
        end
    end)

    Interface:Toggle(Utils._("settings_animations"), "Animations", GetUIBoolean("Animations", true), function(value)
        SetUIBoolean("Animations", value)
    end)

    Interface:Toggle(Utils._("settings_notifications"), "Notifications", GetUIBoolean("Notifications", true), function(value)
        SetUIBoolean("Notifications", value)
    end)

    Interface:Toggle(Utils._("settings_fps_overlay"), "FPSOverlay", GetUIBoolean("FPSOverlay", true), function(value)
        SetUIBoolean("FPSOverlay", value)
    end)

    Interface:Paragraph("Layout", "O painel novo usa base escura fixa. Para mudar a identidade visual, use o seletor de Theme no topo.")

    Configuration:Button(Utils._("settings_save"), function()
        local success, detail = RunConfigMethod("Save")
        NotifyResult("Configuracao salva!", "Nao foi possivel salvar", success, detail)
    end)

    Configuration:Button(Utils._("settings_load"), function()
        local success, detail = RunConfigMethod("Load")
        if success then
            local uiSuccess, uiDetail = ApplyConfigToUI(true)
            if not uiSuccess then
                success = false
                detail = uiDetail
            end
        end

        NotifyResult("Configuracao carregada!", "Nao foi possivel carregar", success, detail)
    end)

    Configuration:Button(Utils._("settings_reset"), function()
        local success, detail = RunConfigMethod("Reset")
        if success then
            local uiSuccess, uiDetail = ApplyConfigToUI(true)
            if not uiSuccess then
                success = false
                detail = uiDetail
            end
        end

        NotifyResult("Configuracao resetada!", "Nao foi possivel resetar", success, detail)
    end)

    Configuration:Button(Utils._("settings_export"), function()
        local success, detail = RunConfigMethod("Export")
        NotifyResult("Configuracao exportada para a area de transferencia!", "Nao foi possivel exportar", success, detail)
    end)

    Configuration:Button(Utils._("settings_import"), function()
        local registry = rawget(_G, "__VanguardModuleRegistry") or {}
        local clipboard = registry["Core/Services/Clipboard"]
        if not clipboard or type(clipboard.Paste) ~= "function" then
            Utils.Notify("Settings", "Importacao indisponivel: o executor nao permite ler a area de transferencia.", 3)
            return
        end

        local json = clipboard.Paste()
        if type(json) ~= "string" or json == "" then
            Utils.Notify("Settings", "Nao foi possivel ler uma configuracao da area de transferencia.", 3)
            return
        end

        local success, detail = RunConfigMethod("Import", json)
        if success then
            local uiSuccess, uiDetail = ApplyConfigToUI(true)
            if not uiSuccess then
                success = false
                detail = uiDetail
            end
        end

        NotifyResult("Configuracao importada!", "Nao foi possivel importar", success, detail)
    end)

    Configuration:Toggle(Utils._("settings_auto_save"), "AutoSave", BooleanOrDefault(Config.AutoSave, true), function(value)
        Config.AutoSave = value
    end)

    Colors:Paragraph("Tema", "A paleta do layout novo e controlada pelo seletor de Theme. Os color pickers legados foram removidos para evitar conflito com a interface atual.")
    Colors:Button("Abrir seletor de Theme", function()
        if type(UI.OpenThemePanel) == "function" then
            UI:OpenThemePanel()
        else
            Utils.Notify("Settings", "Use o botao Theme no topo da janela.", 3)
        end
    end)

    Profiles:Button(Utils._("settings_new_profile"), function()
        local profileName = BuildProfileName()
        Config.CurrentProfile = profileName

        local success, detail = RunConfigMethod("SaveProfile", profileName)
        NotifyResult("Perfil " .. profileName .. " criado!", "Nao foi possivel criar o perfil", success, detail)
    end)

    Profiles:Button(Utils._("settings_load_profile"), function()
        local profileName = Config.CurrentProfile or "Default"
        local success, detail = RunConfigMethod("LoadProfile", profileName)
        if success then
            local uiSuccess, uiDetail = ApplyConfigToUI(true)
            if not uiSuccess then
                success = false
                detail = uiDetail
            end
        end

        NotifyResult("Perfil " .. profileName .. " carregado!", "Nao foi possivel carregar o perfil", success, detail)
    end)

    Profiles:Button(Utils._("settings_save_profile"), function()
        local profileName = Config.CurrentProfile or "Default"
        local success, detail = RunConfigMethod("SaveProfile", profileName)
        NotifyResult("Perfil " .. profileName .. " salvo!", "Nao foi possivel salvar o perfil", success, detail)
    end)

    Profiles:Button(Utils._("settings_delete_profile"), function()
        local profileName = Config.CurrentProfile or "Default"
        local success, detail = RunConfigMethod("DeleteProfile", profileName)
        NotifyResult("Perfil " .. profileName .. " deletado!", "Nao foi possivel deletar o perfil", success, detail)
    end)

    Backup:Button(Utils._("settings_create_backup"), function()
        local success, detail = RunConfigMethod("CreateBackup")
        if success then
            Utils.Notify("Settings", "Backup criado: " .. tostring(detail), 3)
        else
            NotifyResult("Backup criado!", "Nao foi possivel criar o backup", false, detail)
        end
    end)

    Backup:Button(Utils._("settings_restore_backup"), function()
        local backupName = GetLatestBackupName()
        if not backupName then
            Utils.Notify("Settings", "Nenhum backup disponivel.", 2)
            return
        end

        local success, detail = RunConfigMethod("RestoreBackup", backupName)
        if success then
            local uiSuccess, uiDetail = ApplyConfigToUI(true)
            if not uiSuccess then
                success = false
                detail = uiDetail
            end
        end

        NotifyResult("Backup " .. backupName .. " restaurado!", "Nao foi possivel restaurar o backup", success, detail)
    end)

    Backup:Button(Utils._("settings_list_backups"), function()
        local names = GetSortedKeys(Config.Backups)
        if #names == 0 then
            Utils.Notify("Settings", "Nenhum backup disponivel.", 2)
            return
        end

        local visibleNames = {}
        for index = 1, math.min(#names, 3) do
            table.insert(visibleNames, names[index])
        end

        Utils.Notify("Settings", "Backups recentes: " .. table.concat(visibleNames, ", "), 5)
    end)

    Backup:Button(Utils._("settings_delete_backup"), function()
        local backupName = GetLatestBackupName()
        if not backupName then
            Utils.Notify("Settings", "Nenhum backup disponivel.", 2)
            return
        end

        local success, detail = RunConfigMethod("DeleteBackup", backupName)
        NotifyResult("Backup " .. backupName .. " deletado!", "Nao foi possivel deletar o backup", success, detail)
    end)

    Info:Label(Utils._("settings_version"))
    Info:Label(Utils._("settings_executor") .. GetExecutorName())
    Info:Label(Utils._("settings_creators"))

    Info:Button(Utils._("settings_discord"), function()
        local registry = rawget(_G, "__VanguardModuleRegistry") or {}
        local clipboard = registry["Core/Services/Clipboard"]
        if not clipboard or type(clipboard.Copy) ~= "function" then
            Utils.Notify("Settings", Utils._("home_discord_link"), 4)
            return
        end

        local success, err = clipboard.Copy(Utils._("home_discord_link"))
        if success then
            Utils.Notify("Settings", "Discord copiado!", 2)
        else
            Utils.Notify("Settings", "Falha ao copiar Discord: " .. tostring(err), 3)
        end
    end)

    Info:Button(Utils._("settings_github"), function()
        Utils.Notify("Settings", "GitHub aberto!", 2)
    end)

    Info:Button(Utils._("settings_check_updates"), function()
        Utils.Notify("Settings", "Verificando atualizacoes...", 2)

        if type(UI.InvokeAction) == "function" then
            local success, err = pcall(UI.InvokeAction, UI, "Update")
            if not success then
                Utils.Notify("Settings", "Falha ao atualizar: " .. tostring(err), 3)
            end
        end
    end)
end
