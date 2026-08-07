-- ==========================================
--              LT2Axes
--  Shared axe data for Lumber Tycoon 2.
--
--  Usage:
--    local LT2Axes  = require(ReplicatedStorage.LT2Axes)
--    local dmg      = LT2Axes.GetDamage("Rukiryaxe", "Generic")
--    local rank     = LT2Axes.Rank["Amber Axe"]   -- lower = better
-- ==========================================
local LT2Axes = {}

-- ==========================================
--  DAMAGE TABLE
--  Each entry is  function(treeClass) → number
--  Context-sensitive axes return different
--  values depending on the tree being cut.
--  Base (non-boosted) damage is the fallback.
-- ==========================================
LT2Axes.Damage = {

    -- ── Joke / Novelty ─────────────────────
    ["Inverse Axe"]          = function(_)  return -1   end,
    ["Refined Axe"]          = function(_)  return  0   end,
    ["Candy Cane Axe"]       = function(_)  return  0   end,

    -- ── Standard Progression ───────────────
    ["Basic Hatchet"]        = function(_)  return  0.20 end,
    ["Plain Axe"]            = function(_)  return  0.55 end,
    ["Rusty Axe"]            = function(_)  return  0.55 end,
    ["Spearmint Axe"]        = function(_)  return  0.80 end,
    ["CHICKEN AXE"]          = function(_)  return  0.90 end,
    ["Steel Axe"]            = function(_)  return  0.93 end,
    ["Hardened Axe"]         = function(_)  return  1.45 end,
    ["Beta Axe of Bosses"]   = function(_)  return  1.45 end,
    ["Beesaxe"]              = function(_)  return  1.40 end,
    ["Alpha Axe of Testing"] = function(_)  return  1.50 end,
    ["Pig Axe"]              = function(_)  return  1.50 end,
    ["End Times Axe"]        = function(_)  return  1.58 end,  -- see context below
    ["Silver Axe"]           = function(_)  return  1.60 end,
    ["Rukiryaxe"]            = function(_)  return  1.68 end,
    ["Candy Corn Axe"]       = function(_)  return  1.75 end,
    ["Amber Axe"]            = function(_)  return  3.39 end,
    ["The Many Axe"]         = function(_)  return 10.2  end,

    -- ── Context-Sensitive ──────────────────
    ["Pie Axe"] = function(tc)
        if tc == "Cherry"      then return 1.90 end
        return 0.95
    end,
    ["Fire Axe"] = function(tc)
        if tc == "Volcano"     then return 6.35 end
        return 0.60
    end,
    ["Cave Axe"] = function(tc)
        if tc == "CaveCrawler" then return 7.20 end
        return 0.40
    end,
    ["Frost Axe"] = function(tc)
        if tc == "Frost"       then return 6.00 end
        return 0.36
    end,
    ["Bird Axe"] = function(tc)
        if tc == "CaveCrawler" then return 3.90
        elseif tc == "Volcano" then return 2.50 end
        return 1.65
    end,
    ["Bluesteel Axe"] = function(tc)
        if tc == "BlueSpruce"  then return 12.10 end
        return 2.80
    end,
    ["OverGrown Axe"] = function(tc)
        if tc == "GreenSwampy" then return 7.00
        elseif tc == "GoldSwampy" then return 5.30 end
        return 0.80
    end,
    ["Gingerbread Axe"] = function(tc)
        if tc == "Koa"         then return 11.00
        elseif tc == "Walnut"  then return  8.50 end
        return 1.20
    end,
    ["End Times Axe"] = function(tc)
        if tc == "LoneCave"    then return 1e7  end
        return 1.58
    end,
}

LT2Axes.Priority = {
    "The Many Axe",            -- 10.20
    "Amber Axe",               --  3.39
    "Bluesteel Axe",           --  2.80  base  (12.10 vs BlueSpruce)
    "Johiro",                  --  1.80
    "Candy Corn Axe",          --  1.75
    "Rukiryaxe",               --  1.68
    "Bird Axe",                --  1.65  base  (3.90 vs CaveCrawler)
    "Silver Axe",              --  1.60
    "End Times Axe",           --  1.58  base  (1e7  vs LoneCave)
    "Alpha Axe of Testing",    --  1.50
    "Pig Axe",                 --  1.50
    "Hardened Axe",            --  1.45
    "Beta Axe of Bosses",      --  1.45
    "Beesaxe",                 --  1.40
    "Gingerbread Axe",         --  1.20  base  (11.00 vs Koa)
    "Pie Axe",                 --  0.95  base  (1.90  vs Cherry)
    "Steel Axe",               --  0.93
    "CHICKEN AXE",             --  0.90
    "OverGrown Axe",           --  0.80  base  (7.00  vs GreenSwampy)
    "Spearmint Axe",           --  0.80
    "Fire Axe",                --  0.60  base  (6.35  vs Volcano)
    "Plain Axe",               --  0.55
    "Rusty Axe",               --  0.55
    "Cave Axe",                --  0.40  base  (7.20  vs CaveCrawler)
    "Frost Axe",               --  0.36  base  (6.00  vs Frost)
    "Basic Hatchet",           --  0.20
    "Candy Cane Axe",          --  0.00
    "Refined Axe",             --  0.00
    "Inverse Axe",             -- -1.00
}

-- ==========================================
--  RANK LOOKUP
--  Quick integer rank by name.
--  Lower = higher priority. Unknown → nil.
-- ==========================================
LT2Axes.Rank = {}
for rank, name in ipairs(LT2Axes.Priority) do
    LT2Axes.Rank[name] = rank
end

-- ==========================================
--  GetDamage(axeName, treeClass)
--  Returns damage for the given axe against
--  the given tree class.
--  Falls back to 1.0 for unknown axes.
-- ==========================================
function LT2Axes.GetDamage(axeName, treeClass)
    local fn = LT2Axes.Damage[axeName]
    return fn and fn(treeClass) or 1.0
end

return LT2Axes
