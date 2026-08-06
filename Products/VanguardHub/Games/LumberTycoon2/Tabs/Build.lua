-- ============================================================
-- VANGUARD HUB - BUILD (AUTO BUILD)
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("build_title"), "6035067834")
    
    local Base = Tab:Section(Utils._("build_base"), true)
    local BuildUI = Tab:Section(Utils._("build_ui"), true)
    local Wood = Tab:Section(Utils._("build_wood"), true)
    
    local playerList
    if type(Utils.GetPlayerNames) == "function" then
        playerList = Utils.GetPlayerNames()
    else
        playerList = {}
        for _, player in ipairs(Utils.GetPlayers()) do
            table.insert(playerList, player.Name)
        end
    end
    local treeTypes = {
        "Generic", "Walnut", "Cherry", "SnowGlow", "Oak", "Birch",
        "Koa", "Fir", "Volcano", "GreenSwampy", "CaveCrawler", "Palm",
        "GoldSwampy", "Frost", "Spooky", "LoneCave"
    }
    
    Base:Dropdown(Utils._("build_base_wood"), "BuildBaseWood", playerList, function(v)
        Config.BuildBaseWood = v
    end)
    
    Base:Dropdown(Utils._("build_base_target"), "BuildBaseTarget", playerList, function(v)
        Config.BuildBaseTarget = v
    end)
    
    BuildUI:Toggle(Utils._("build_mode"), "BuildMode", Config.BuildMode or false, function(v)
        Config.BuildMode = v
    end)
    
    BuildUI:Button(Utils._("build_load"), function()
        Utils.Notify("Build", "Carregando schematic...", 3)
    end)
    
    BuildUI:Button(Utils._("build_unload"), function()
        Utils.Notify("Build", "Unload Preview...", 2)
    end)
    
    BuildUI:Button(Utils._("build_start"), function()
        Utils.Notify("Build", "Iniciando construcao...", 3)
    end)
    
    BuildUI:Button(Utils._("build_stop"), function()
        Utils.Notify("Build", "Construcao parada!", 2)
    end)
    
    Wood:Dropdown(Utils._("build_select_wood"), "BuildWood", treeTypes, function(v)
        Config.BuildWood = v
    end)
    
    Wood:Toggle(Utils._("build_auto_fill"), "AutoFill", Config.AutoFill or false, function(v)
        Config.AutoFill = v
    end)
    
    Wood:Button(Utils._("build_click_fill"), function()
        Utils.Notify("Build", "Click to Fill ativado!", 2)
    end)
    
    Wood:Button(Utils._("build_fill_bps"), function()
        Utils.Notify("Build", "Preenchendo blueprints...", 3)
    end)
end
