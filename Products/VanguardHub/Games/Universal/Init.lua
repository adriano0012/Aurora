local Game = {
    Name = "Universal",
    DisplayName = "Universal",
    Theme = "Dark"
}

function Game:Register(game)
    game:SetSubtitle(self.DisplayName)
    game:SetTheme(self.Theme)
    game:AddTab("Home", "Games/Universal/Tabs/Home", {
        UniversalFallback = true
    })
end

return Game
