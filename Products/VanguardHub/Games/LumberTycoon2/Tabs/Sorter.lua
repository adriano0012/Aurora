-- ============================================================
-- VANGUARD HUB - SORTER
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("sorter_title"), "11145825488")
    
    local ConfigSection = Tab:Section(Utils._("sorter_config"), true)
    local Actions = Tab:Section(Utils._("sorter_actions"), true)
    
    local playerList
    if type(Utils.GetPlayerNames) == "function" then
        playerList = Utils.GetPlayerNames()
    else
        playerList = {}
        for _, player in ipairs(Utils.GetPlayers()) do
            table.insert(playerList, player.Name)
        end
    end
    
    ConfigSection:Dropdown(Utils._("sorter_select_player"), "SortPlayer", playerList, function(v)
        Config.SortPlayer = v
    end)
    
    ConfigSection:Dropdown(Utils._("sorter_select_type"), "SortType", {"All", "Wood", "Items", "Vehicles"}, function(v)
        Config.SortType = v
    end)
    
    ConfigSection:Button(Utils._("sorter_truck_tp"), function()
        Utils.Notify("Sorter", "Teleportando truck...", 2)
    end)
    
    ConfigSection:Slider(Utils._("sorter_speed"), "SortSpeed", Config.SortSpeed or 0.3, 0.1, 0.5, true, function(v)
        Config.SortSpeed = v
    end)
    
    ConfigSection:Slider(Utils._("sorter_size_x"), "SizeX", Config.SizeX or 1, 1, 15, false, function(v)
        Config.SizeX = v
    end)
    
    ConfigSection:Slider(Utils._("sorter_size_y"), "SizeY", Config.SizeY or 1, 1, 15, false, function(v)
        Config.SizeY = v
    end)
    
    ConfigSection:Slider(Utils._("sorter_size_z"), "SizeZ", Config.SizeZ or 1, 1, 15, false, function(v)
        Config.SizeZ = v
    end)
    
    Actions:Button(Utils._("sorter_start"), function()
        Utils.Notify("Sorter", "Iniciando sorter...", 3)
    end)
end
