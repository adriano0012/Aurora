-- ============================================================
-- VANGUARD HUB - ITEM (LASSO + SELECT + TP)
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("item_title"), "6034767620")
    
    local Lasso = Tab:Section(Utils._("item_lasso"), true)
    local Select = Tab:Section(Utils._("item_select"), true)
    local TP = Tab:Section(Utils._("item_tp"), true)
    
    -- Lasso
    Lasso:Toggle(Utils._("item_lasso_tool"), "LassoTool", Config.LassoTool or false, function(v)
        Config.LassoTool = v
    end)
    
    -- Select
    Select:Toggle(Utils._("item_click_select"), "ClickSelect", Config.ClickSelect or false, function(v)
        Config.ClickSelect = v
    end)
    
    Select:Button(Utils._("item_select_group"), function()
        Utils.Notify("Item", "Selecionando grupo...", 2)
    end)
    
    Select:Button(Utils._("item_deselect"), function()
        Utils.Notify("Item", "Deselecionando todos...", 2)
    end)
    
    -- TP
    TP:Button(Utils._("item_tp_facing"), function()
        Utils.Notify("Item", "Teleportando para onde esta virado...", 2)
    end)
    
    TP:Button(Utils._("item_mark_waypoint"), function()
        Utils.Notify("Item", "Waypoint marcado!", 2)
    end)
    
    TP:Button(Utils._("item_tp_waypoint"), function()
        Utils.Notify("Item", "Teleportando para waypoint...", 2)
    end)
    
    TP:Dropdown(Utils._("item_direction"), "Direction", {"X", "Y", "Z", "All"}, function(v)
        Config.Direction = v
    end)
end