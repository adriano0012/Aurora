local HelpModule = {}

-- ============================================================
-- HELP MODULE  —  Dynxe LT2
-- Uses Tab:CreateInfoBox() to render categorised help cards.
-- Add this tab in main.lua:
--   local HelpTab = HubWindow:CreateTab("Help")
--   ...
--   local HelpModule = LoadModule("Help")
--   if HelpModule and HelpModule.Init then HelpModule.Init(HelpTab) end
-- ============================================================

function HelpModule.Init(Tab)

    -- ══════════════════════════════════════════════════════════
    -- Duplcation
    -- ══════════════════════════════════════════════════════════
    Tab:CreateSection("Tree Modding")
    local selBox = Tab:CreateInfoBox()
    selBox:AddText("Instructions", { Bold = true, Size = 12 })
    selBox:AddDivider()
    selBox:AddText("1. Click on a chopped tree that you own.", { Size = 12, Opacity = 0.85, Wrap = true })
    selBox:AddText("2. Click on a sawmill that you own", { Size = 12, Opacity = 0.85, Wrap = true })
    selBox:AddText("3. wait!", { Size = 12, Opacity = 0.85, Wrap = true })
    Tab:CreateAction("Youtube Tutorial", "Copy", function()
        setclipboard("https://www.youtube.com/watch?v=D4gesqw_8VE")
        Library:Notify("Dynxe LT2", "Link coppied to clipboard!", 3)
    end)
    
    -- ══════════════════════════════════════════════════════════
    -- PROTECTION
    -- ══════════════════════════════════════════════════════════
    Tab:CreateSection("Protection")

    local protBox = Tab:CreateInfoBox()
    protBox:AddText("Anti-Cheats & Safeguards", { Bold = true, Size = 12 })
    protBox:AddDivider()
    protBox:AddText("Anti-Void  —  Catches your character if it falls below the map and returns it to a safe height.", { Size = 12, Opacity = 0.85, Wrap = true })
    protBox:AddText("Anti-Ragdoll  —  Stops ragdoll states from being forced on your character by other players.", { Size = 12, Opacity = 0.85, Wrap = true })
    protBox:AddText("Anti-AFK  —  Sends periodic inputs so the server does not kick you for inactivity.", { Size = 12, Opacity = 0.85, Wrap = true })
    protBox:AddText("Axe Recovery  —  Recovers all of the players axes that was in the inventory before death.", { Size = 12, Opacity = 0.85, Wrap = true })
end

return HelpModule
