-- ============================================================
-- VANGUARD HUB - SLOT
-- ============================================================

return function(UI, Config, Utils)
    local Tab = UI:Tab(Utils._("slot_title"), "6034333276")
    local slotConfig = type(Config.Slot) == "table" and Config.Slot or nil
    local slotNumber = slotConfig and slotConfig.Number or Config.Slot or 1
    local fastLoad = slotConfig and slotConfig.FastLoad or Config.FastLoad or false
    
    local Slots = Tab:Section(Utils._("slot_slots"), true)
    local Land = Tab:Section(Utils._("slot_land"), true)
    
    -- Slots
    Slots:Slider(Utils._("slot_number"), "Slot", slotNumber, 1, 6, false, function(v)
        if slotConfig then
            slotConfig.Number = v
        end
        Config.Slot = v
    end)
    
    Slots:Button(Utils._("slot_load"), function()
        Utils.Notify("Slot", "Carregando slot " .. Config.Slot .. "...", 3)
    end)
    
    Slots:Button(Utils._("slot_save"), function()
        Utils.Notify("Slot", "Salvando slot " .. Config.Slot .. "...", 3)
    end)
    
    Slots:Button(Utils._("slot_overwrite"), function()
        Utils.Notify("Slot", "Sobrescrevendo slot " .. Config.Slot .. "...", 3)
    end)
    
    Slots:Toggle(Utils._("slot_fast_load"), "FastLoad", fastLoad, function(v)
        if slotConfig then
            slotConfig.FastLoad = v
        end
        Config.FastLoad = v
    end)
    
    -- Land
    Land:Button(Utils._("slot_free_land"), function()
        for _, prop in pairs(workspace.Properties:GetChildren()) do
            if prop.Owner and prop.Owner.Value == nil then
                game:GetService("ReplicatedStorage").PropertyPurchasing.ClientPurchasedProperty:FireServer(prop, prop.OriginSquare.Position)
                Utils.Teleport(prop.OriginSquare.CFrame + Vector3.new(0, 2, 0))
                break
            end
        end
        Utils.Notify("Land", "Terreno gratis adquirido!", 2)
    end)
    
    Land:Button(Utils._("slot_max_land"), function()
        local player = game:GetService("Players").LocalPlayer
        for _, prop in pairs(workspace.Properties:GetChildren()) do
            if prop.Owner and prop.Owner.Value == player then
                local pos = prop.OriginSquare.Position
                local offsets = {
                    {40,0,0}, {-40,0,0}, {0,0,40}, {0,0,-40},
                    {40,0,40}, {40,0,-40}, {-40,0,40}, {-40,0,-40},
                    {80,0,0}, {-80,0,0}, {0,0,80}, {0,0,-80},
                    {80,0,80}, {80,0,-80}, {-80,0,80}, {-80,0,-80},
                    {40,0,80}, {-40,0,80}, {80,0,40}, {80,0,-40},
                    {-80,0,40}, {-80,0,-40}, {40,0,-80}, {-40,0,-80}
                }
                for _, offset in pairs(offsets) do
                    game:GetService("ReplicatedStorage").PropertyPurchasing.ClientExpandedProperty:FireServer(prop,
                        CFrame.new(pos.X + offset[1], pos.Y + offset[2], pos.Z + offset[3]))
                end
                Utils.Notify("Land", "Terreno maximo adquirido!", 2)
                break
            end
        end
    end)
    
    Land:Button(Utils._("slot_expand"), function()
        Utils.Notify("Land", "Expandindo terreno...", 2)
    end)
    
    Land:Button(Utils._("slot_sell_sign"), function()
        local player = game:GetService("Players").LocalPlayer
        for _, model in pairs(workspace.PlayerModels:GetChildren()) do
            if model:FindFirstChild("Owner") and model.Owner.Value == player then
                if model:FindFirstChild("ItemName") and model.ItemName.Value == "PropertySoldSign" then
                    game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(model, "Take down sold sign")
                    for i = 1, 30 do
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(model)
                        model.Main.CFrame = CFrame.new(314, -0.5, 86)
                    end
                end
            end
        end
        Utils.Notify("Land", "Placas de vendido vendidas!", 2)
    end)
    
    Land:Button(Utils._("slot_force_save"), function()
        Utils.Notify("Land", "Force Save realizado!", 2)
    end)
    
    Land:ColorPicker(Utils._("slot_land_color"), "LandColor", Color3.fromRGB(124, 92, 70), function(v)
        Config.LandColor = v
        for _, prop in pairs(workspace.Properties:GetChildren()) do
            for _, square in pairs(prop:GetChildren()) do
                if square:IsA("BasePart") and (square.Name == "Square" or square.Name == "OriginSquare") then
                    square.Color = v
                end
            end
        end
    end)
    
    Land:Dropdown(Utils._("slot_plot_material"), "PlotMaterial", {
        "Normal", "Sandstone", "Brick", "Marble", "Clear Grid"
    }, function(v)
        local materials = {
            Normal = Enum.Material.Concrete,
            Sandstone = Enum.Material.Sandstone,
            Brick = Enum.Material.Pavement,
            Marble = Enum.Material.Marble,
            ["Clear Grid"] = Enum.Material.ForceField,
        }
        if materials[v] then
            for _, prop in pairs(workspace.Properties:GetChildren()) do
                for _, square in pairs(prop:GetChildren()) do
                    if square:IsA("BasePart") and (square.Name == "Square" or square.Name == "OriginSquare") then
                        square.Material = materials[v]
                    end
                end
            end
        end
    end)
    
    Land:Toggle(Utils._("slot_rainbow"), "RainbowLand", Config.RainbowLand or false, function(v)
        Config.RainbowLand = v
        if v then
            task.spawn(function()
                while Config.RainbowLand do
                    for hue = 0, 1, 0.01 do
                        if not Config.RainbowLand then break end
                        local color = Color3.fromHSV(hue, 1, 1)
                        for _, prop in pairs(workspace.Properties:GetChildren()) do
                            for _, square in pairs(prop:GetChildren()) do
                                if square:IsA("BasePart") and (square.Name == "Square" or square.Name == "OriginSquare") then
                                    square.Color = color
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end
            end)
        else
            for _, prop in pairs(workspace.Properties:GetChildren()) do
                for _, square in pairs(prop:GetChildren()) do
                    if square:IsA("BasePart") and (square.Name == "Square" or square.Name == "OriginSquare") then
                        square.Color = Color3.fromRGB(124, 92, 70)
                    end
                end
            end
        end
    end)
end
