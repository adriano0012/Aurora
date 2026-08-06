-- ============================================================
-- VANGUARD HUB - VEHICLE
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("vehicle_title"), "6034452660")
    
    local Options = Tab:Section(Utils._("vehicle_options"), true)
    local Spawner = Tab:Section(Utils._("vehicle_spawner"), true)
    
    Options:Slider(Utils._("vehicle_speed"), "VehicleSpeed", Config.VehicleSpeed or 1, 1, 10, false, function(v)
        Config.VehicleSpeed = v
        local player = game:GetService("Players").LocalPlayer
        for _, model in pairs(workspace.PlayerModels:GetChildren()) do
            if model:FindFirstChild("Owner") and model.Owner.Value == player then
                if model:FindFirstChild("Configuration") then
                    model.Configuration.MaxSpeed.Value = v
                end
            end
        end
    end)
    
    Options:Slider(Utils._("vehicle_pitch"), "VehiclePitch", Config.VehiclePitch or 1, 1, 10, false, function(v)
        Config.VehiclePitch = v
    end)
    
    Options:Button(Utils._("vehicle_unflip"), function()
        Utils.Notify("Vehicle", "Desvirando veiculo...", 2)
    end)
    
    Options:Toggle(Utils._("vehicle_fly"), "VehicleFly", Config.VehicleFly or false, function(v)
        Config.VehicleFly = v
    end)
    
    Options:Toggle(Utils._("vehicle_sit"), "SitAny", Config.SitAny or false, function(v)
        Config.SitAny = v
        local player = game:GetService("Players").LocalPlayer
        if v then
            player.PlayerGui.Scripts.SitPermissions.Disabled = true
        else
            player.PlayerGui.Scripts.SitPermissions.Disabled = false
        end
    end)
    
    Options:Button(Utils._("vehicle_teleport"), function()
        Utils.Notify("Vehicle", "Teleportando veiculo...", 2)
    end)
    
    Options:Button(Utils._("vehicle_delete"), function()
        Utils.Notify("Vehicle", "Deletando veiculo...", 2)
    end)
    
    Options:Button(Utils._("vehicle_boost"), function()
        Utils.Notify("Vehicle", "Boost ativado!", 2)
    end)
    
    Options:Button(Utils._("vehicle_jump"), function()
        Utils.Notify("Vehicle", "Pulo do veiculo!", 2)
    end)
    
    local vehicleColors = {
        "Silver", "Dark Red", "Sand Red", "Sand Yellow", "Lemon",
        "Gun Metal", "Earth Orange", "Earth Yellow", "Brick Yellow",
        "Rust", "Really Black", "Faded Green", "Sand Green",
        "Black Metallic", "Dark Grey Metallic", "Dark Grey",
        "Mid Grey", "Hot Pink", "Cyan", "Magenta"
    }
    
    Spawner:Dropdown(Utils._("vehicle_color"), "VehicleColor", vehicleColors, function(v)
        Config.VehicleColor = v
    end)
    
    Spawner:Button(Utils._("vehicle_spawn"), function()
        Utils.Notify("Vehicle", "Spawnando veiculo " .. Config.VehicleColor .. "...", 3)
    end)
    
    Spawner:Button(Utils._("vehicle_abort_spawn"), function()
        Utils.Notify("Vehicle", "Spawner abortado!", 2)
    end)
    
    Spawner:Toggle(Utils._("vehicle_stop_pink"), "StopPink", Config.StopPink or false, function(v)
        Config.StopPink = v
    end)
    
    Spawner:Toggle(Utils._("vehicle_delete_spot"), "DeleteSpot", Config.DeleteSpot or false, function(v)
        Config.DeleteSpot = v
    end)
end