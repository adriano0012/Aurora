    local esp = Instance.new("BillboardGui", game.CoreGui.esp.survivors)
    esp.Adornee = game.Players[v.Name].Character
    esp.AlwaysOnTop=true
    esp.ResetOnSpawn=false
    esp.Size = UDim2.new(1,1,1,1)
    esp.Name = v.Name

    local tag = Instance.new("TextLabel", esp)
    tag.Size = UDim2.new(5,5,5,5)
    tag.Text = "Survivor"
    tag.TextColor3 = Color3.new(0, 255, 0)
    tag.BackgroundTransparency = 1
    end end end end
