-- ============================================================
-- VANGUARD HUB - DUPE
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("dupe_title"), "6035053278")
    
    local Base = Tab:Section(Utils._("dupe_base"), true)
    local Items = Tab:Section(Utils._("dupe_items"), true)
    local Actions = Tab:Section(Utils._("dupe_actions"), true)
    local Settings = Tab:Section(Utils._("dupe_settings"), true)
    
    local playerList
    if type(Utils.GetPlayerNames) == "function" then
        playerList = Utils.GetPlayerNames()
    else
        playerList = {}
        for _, player in ipairs(Utils.GetPlayers()) do
            table.insert(playerList, player.Name)
        end
    end
    
    -- Base
    Base:Dropdown(Utils._("dupe_select_base"), "DupeBase", playerList, function(v)
        Config.DupeBase = v
    end)
    
    Base:Dropdown(Utils._("dupe_select_slot"), "DupeSlot", {"1", "2", "3", "4", "5", "6"}, function(v)
        Config.DupeSlot = tonumber(v)
    end)
    
    Base:Dropdown(Utils._("dupe_type"), "DupeType", {"Normal", "Fast", "Turbo"}, function(v)
        Config.DupeType = v
    end)
    
    -- Items
    Items:Toggle(Utils._("dupe_truck"), "DupeTruck", Config.DupeTruck or false, function(v)
        Config.DupeTruck = v
    end)
    
    Items:Toggle(Utils._("dupe_empty"), "DupeEmpty", Config.DupeEmpty or false, function(v)
        Config.DupeEmpty = v
    end)
    
    Items:Toggle(Utils._("dupe_woods"), "DupeWoods", Config.DupeWoods or false, function(v)
        Config.DupeWoods = v
    end)
    
    Items:Toggle(Utils._("dupe_gifts"), "DupeGifts", Config.DupeGifts or false, function(v)
        Config.DupeGifts = v
    end)
    
    Items:Toggle(Utils._("dupe_blueprints"), "DupeBlueprints", Config.DupeBlueprints or false, function(v)
        Config.DupeBlueprints = v
    end)
    
    Items:Toggle(Utils._("dupe_paintings"), "DupePaintings", Config.DupePaintings or false, function(v)
        Config.DupePaintings = v
    end)
    
    Items:Toggle(Utils._("dupe_wires"), "DupeWires", Config.DupeWires or false, function(v)
        Config.DupeWires = v
    end)
    
    Items:Toggle(Utils._("dupe_vehicles"), "DupeVehicles", Config.DupeVehicles or false, function(v)
        Config.DupeVehicles = v
    end)
    
    Items:Button(Utils._("dupe_select_all"), function()
        Config.DupeTruck = true
        Config.DupeEmpty = true
        Config.DupeWoods = true
        Config.DupeGifts = true
        Config.DupeBlueprints = true
        Config.DupePaintings = true
        Config.DupeWires = true
        Config.DupeVehicles = true
        Utils.Notify("Dupe", "Todos selecionados!", 2)
    end)
    
    Items:Button(Utils._("dupe_deselect_all"), function()
        Config.DupeTruck = false
        Config.DupeEmpty = false
        Config.DupeWoods = false
        Config.DupeGifts = false
        Config.DupeBlueprints = false
        Config.DupePaintings = false
        Config.DupeWires = false
        Config.DupeVehicles = false
        Utils.Notify("Dupe", "Todos deselecionados!", 2)
    end)
    
    -- Actions
    Actions:Button(Utils._("dupe_start"), function()
        Utils.Notify("Dupe", "Iniciando dupe...", 3)
    end)
    
    Actions:Button(Utils._("dupe_abort"), function()
        Utils.Notify("Dupe", "Abortado!", 2)
    end)
    
    Actions:Button(Utils._("dupe_save_config"), function()
        Utils.Notify("Dupe", "Configuracao salva!", 2)
    end)
    
    Actions:Button(Utils._("dupe_load_config"), function()
        Utils.Notify("Dupe", "Configuracao carregada!", 2)
    end)
    
    -- Settings
    Settings:Slider(Utils._("dupe_slot"), "DupeSlot", Config.DupeSlot or 1, 1, 6, false, function(v)
        Config.DupeSlot = v
    end)
    
    Settings:Slider(Utils._("dupe_speed"), "DupeSpeed", Config.DupeSpeed or 5, 1, 10, false, function(v)
        Config.DupeSpeed = v
    end)
    
    Settings:Slider(Utils._("dupe_wait_time"), "DupeWaitTime", Config.DupeWaitTime or 1, 0.5, 10, true, function(v)
        Config.DupeWaitTime = v
    end)
end
