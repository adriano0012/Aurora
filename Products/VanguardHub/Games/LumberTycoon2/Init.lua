local Game = {
    Name = "LumberTycoon2",
    DisplayName = "Lumber Tycoon 2",
    Theme = "Purple",
    Background = "Games/LumberTycoon2/Assets/Background",
    UtilsModule = "Games/LumberTycoon2/Modules/Utils",
    ConfigSchema = "Games/LumberTycoon2/Config/Schema",
    ConfigAdapter = "Games/LumberTycoon2/Config/Adapter"
}

function Game:Register(game)
    game:SetSubtitle(self.DisplayName)
    game:SetBackground(self.Background)
    game:SetTheme(self.Theme)

    game:AddTab("Home", "Games/LumberTycoon2/Tabs/Home")
    game:AddTab("Player", "Games/LumberTycoon2/Tabs/Player")
    game:AddTab("World", "Games/LumberTycoon2/Tabs/World")
    game:AddTab("Teleports", "Games/LumberTycoon2/Tabs/Teleports")
    game:AddTab("Wood", "Games/LumberTycoon2/Tabs/Wood")
    game:AddTab("Dupe", "Games/LumberTycoon2/Tabs/Dupe")
    game:AddTab("Build", "Games/LumberTycoon2/Tabs/Build")
    game:AddTab("Vehicle", "Games/LumberTycoon2/Tabs/Vehicle")
    game:AddTab("Item", "Games/LumberTycoon2/Tabs/Item")
    game:AddTab("Slot", "Games/LumberTycoon2/Tabs/Slot")
    game:AddTab("Autobuy", "Games/LumberTycoon2/Tabs/Autobuy")
    game:AddTab("Sorter", "Games/LumberTycoon2/Tabs/Sorter")
    game:AddTab("Settings", "Games/LumberTycoon2/Tabs/Settings")
end

return Game
