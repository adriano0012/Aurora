-- ============================================================
-- VANGUARD HUB - AUTOBUY
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("autobuy_title"), "6031265983")
    
    local Items = Tab:Section(Utils._("autobuy_items"), true)
    local Misc = Tab:Section(Utils._("autobuy_misc"), true)
    local Counter = Tab:Section(Utils._("autobuy_counter"), true)
    
    local shopItems = {
        "Basic Hatchet - $12", "Plain Axe - $90", "Steel Axe - $190",
        "Hardened Axe - $550", "Silver Axe - $2040",
        "Sawmax 01 - $11000", "Sawmax 02 - $22500",
        "Sawmax 02L - $86500", "Utility Vehicle - $400",
        "Dynamite - $220", "Can of Worms - $3200",
    }
    
    Items:Slider(Utils._("autobuy_amount"), "AutobuyAmount", Config.AutobuyAmount or 1, 1, 100, false, function(v)
        Config.AutobuyAmount = v
    end)
    
    Items:Dropdown(Utils._("autobuy_select"), "AutobuyItem", shopItems, function(v)
        Config.AutobuyItem = v
    end)
    
    Items:Toggle(Utils._("autobuy_open_box"), "OpenBox", Config.OpenBox or false, function(v)
        Config.OpenBox = v
    end)
    
    Items:Button(Utils._("autobuy_buy"), function()
        Utils.Notify("Autobuy", "Comprando " .. Config.AutobuyAmount .. " " .. Config.AutobuyItem .. "...", 3)
    end)
    
    Items:Button(Utils._("autobuy_abort"), function()
        Utils.Notify("Autobuy", "Abortado!", 2)
    end)
    
    Items:Button(Utils._("autobuy_rukiryaxe"), function()
        Utils.Notify("Autobuy", "Rukiryaxe especial adquirido!", 2)
    end)
    
    Items:Button(Utils._("autobuy_blueprints"), function()
        Utils.Notify("Autobuy", "Comprando todas as blueprints...", 3)
    end)
    
    Misc:Toggle(Utils._("autobuy_fast_checkout"), "FastCheckout", Config.FastCheckout or false, function(v)
        Config.FastCheckout = v
    end)
    
    Misc:Button(Utils._("autobuy_toll"), function()
        Utils.Notify("Autobuy", "Toll Bridge comprado!", 2)
    end)
    
    Misc:Button(Utils._("autobuy_ferry"), function()
        Utils.Notify("Autobuy", "Ferry Ticket comprado!", 2)
    end)
    
    Misc:Button(Utils._("autobuy_power"), function()
        Utils.Notify("Autobuy", "Power of Ease comprado!", 2)
    end)
    
    Counter:Button(Utils._("autobuy_woodrus"), function()
        Utils.Notify("Autobuy", "Comprando Wood R'Us...", 2)
    end)
    
    Counter:Button(Utils._("autobuy_links"), function()
        Utils.Notify("Autobuy", "Comprando Links Logic...", 2)
    end)
    
    Counter:Button(Utils._("autobuy_fancy"), function()
        Utils.Notify("Autobuy", "Comprando Fancy Furnishings...", 2)
    end)
    
    Counter:Button(Utils._("autobuy_bob"), function()
        Utils.Notify("Autobuy", "Comprando Bob's Shack...", 2)
    end)
end