local ConfigManager = {}

function ConfigManager.new(options)
    local schema = assert(options.schema, "ConfigManager requires schema")
    local adapter = assert(options.adapter, "ConfigManager requires adapter")
    local storage = assert(options.storage, "ConfigManager requires storage")
    local saveCodec = assert(options.saveCodec, "ConfigManager requires save codec")
    local loadCodec = assert(options.loadCodec, "ConfigManager requires load codec")
    local profile = assert(options.profile, "ConfigManager requires profile helpers")

    local metaPath = string.format("Configs/%s/UI.json", options.gameName or "Universal")

    local function writeSection(sectionName, payload)
        local path = string.format("Configs/%s/%s.json", options.gameName or "Universal", sectionName)
        return storage.Write(path, saveCodec.ToJson(payload))
    end

    local function readSection(sectionName)
        local path = string.format("Configs/%s/%s.json", options.gameName or "Universal", sectionName)
        local raw = storage.Read(path)
        if not raw then
            return nil
        end

        local ok, decoded = pcall(loadCodec.FromJson, raw)
        return ok and decoded or nil
    end

    function schema:Save()
        local sections = adapter.ExportSections(self)
        for sectionName, payload in pairs(sections) do
            writeSection(sectionName, payload)
        end

        local meta = adapter.ExportMeta(self)
        return storage.Write(metaPath, saveCodec.ToJson(meta))
    end

    function schema:Load()
        local sections = {}
        for _, sectionName in ipairs(adapter.SectionOrder) do
            local payload = readSection(sectionName)
            if payload ~= nil then
                sections[sectionName] = payload
            end
        end

        local meta = storage.Read(metaPath)
        if meta then
            local ok, decoded = pcall(loadCodec.FromJson, meta)
            if ok then
                adapter.ImportMeta(self, decoded)
            end
        end

        adapter.ImportSections(self, sections)
        return true
    end

    function schema:Export()
        return saveCodec.ToJson(adapter.ExportSnapshot(self))
    end

    function schema:Import(json)
        local ok, decoded = pcall(loadCodec.FromJson, json)
        if not ok then
            return false
        end

        adapter.ImportSnapshot(self, decoded)
        return self:Save()
    end

    function schema:Reset()
        adapter.Reset(self, profile.DeepCopy(options.defaults or {}))
        return self:Save()
    end

    function schema:SaveProfile(name)
        local profileName = name or self.CurrentProfile or "Default"
        self.Profiles = self.Profiles or {}
        self.Profiles[profileName] = adapter.ExportSnapshot(self)
        self.CurrentProfile = profileName
        return self:Save()
    end

    function schema:LoadProfile(name)
        local profileName = name or self.CurrentProfile or "Default"
        local snapshot = self.Profiles and self.Profiles[profileName]
        if not snapshot then
            return false
        end

        adapter.ImportSnapshot(self, profile.DeepCopy(snapshot))
        self.CurrentProfile = profileName
        return self:Save()
    end

    function schema:DeleteProfile(name)
        local profileName = name or self.CurrentProfile or "Default"
        if profileName == "Default" then
            return false
        end

        if type(self.Profiles) == "table" then
            self.Profiles[profileName] = nil
        end

        if self.CurrentProfile == profileName then
            self.CurrentProfile = "Default"
        end

        return self:Save()
    end

    function schema:CreateBackup()
        self.Backups = self.Backups or {}
        local backupName = "backup_" .. os.date("%Y%m%d_%H%M%S")
        self.Backups[backupName] = adapter.ExportSnapshot(self)
        self:Save()
        return backupName
    end

    function schema:RestoreBackup(name)
        local snapshot = self.Backups and self.Backups[name]
        if not snapshot then
            return false
        end

        adapter.ImportSnapshot(self, profile.DeepCopy(snapshot))
        return self:Save()
    end

    function schema:DeleteBackup(name)
        if type(self.Backups) ~= "table" or not self.Backups[name] then
            return false
        end

        self.Backups[name] = nil
        return self:Save()
    end

    return schema
end

return ConfigManager
