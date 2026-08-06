    local plr = game:GetService("Players").LocalPlayer
    game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):UnequipTools()
    function getGun()
        for i,v in pairs(plr.Backpack:GetChildren()) do
