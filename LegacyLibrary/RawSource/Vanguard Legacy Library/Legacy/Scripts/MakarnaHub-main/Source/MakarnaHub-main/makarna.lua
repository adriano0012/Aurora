-- 🌟 MAKARNA SEVERLER BİRLİĞİ HUB v20 [RAINBOW & EXPANDED] 🌟
-- Tuş: Insert (Aç/Kapat) | Rainbow Kenarlık + Devasa Işınlanma Listesi

local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- ⚙️ AYARLAR
local settings = {
    walkSpeed = 100,
    jumpPower = 150,
    flySpeed = 50,
    speedActive = false,
    jumpActive = false,
    flyActive = false,
    fullbrightActive = false,
    dayActive = false,
    autoCutActive = false,
    homePos = nil,
    isFarming = false
}

-- 📍 GENİŞLETİLMİŞ BÖLGELER LİSTESİ
local locations = {
    -- Önemli Noktalar
    ["🌲 Wood R Us (Odun Satış)"] = CFrame.new(315, 3, -85),
    ["🪵 Land Store (Arazi)"] = CFrame.new(160, 3, 408),
    ["🛋️ Fancy Furnishings (Mobilya)"] = CFrame.new(481, 3, -1720),
    ["🚗 Boxed Cars (Araba)"] = CFrame.new(509, 5, -1463),
    ["💡 Link's Logic (Kablolar)"] = CFrame.new(4607, 7, -798),
    ["🎨 Fine Arts (Resimci)"] = CFrame.new(5207, -166, 719),
    ["🚢 Feribot İskelesi"] = CFrame.new(1175, 4, -1000),
    
    -- Odun Bölgeleri
    ["🌋 Volkan (Ağzı)"] = CFrame.new(-1585, 622, 476),
    ["🌿 Bataklık"] = CFrame.new(-1209, 132, -801),
    ["❄️ Buz Bölgesi"] = CFrame.new(-1500, 400, 1100),
    ["🏖️ Palm Sahili"] = CFrame.new(2549, 3, -1),
    ["👻 Gizli Mağara (Mavi Odun)"] = CFrame.new(3581, -179, 430),
    ["🦁 Safari (Koa Ağacı)"] = CFrame.new(4720, 10, -580),
    
    -- Gizli Yerler
    ["🧟 Bob'un Yeri"] = CFrame.new(250, 8, -2500),
    ["❓ Strange Man (Gizemli Adam)"] = CFrame.new(1061, 16, 1131),
    ["🌉 Köprü Başlangıcı"] = CFrame.new(115, 5, -1125),
    ["🦅 Kartalın Tepesi"] = CFrame.new(1500, 450, 3100)
}

local woodTypes = {"Oak", "Cherry", "Birch", "Walnut", "Fir", "Pine", "Volcano", "Gold", "Frost", "Koa", "Spooky", "Palm"}

-- 🖥️ UI ANA YAPI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Makarna_Rainbow_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 750, 0, 550); MainFrame.Position = UDim2.new(0.5, -375, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- 🌈 RAINBOW KENARLIK EFEKTİ
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 4
Stroke.Transparency = 0

task.spawn(function()
    while true do
        for i = 0, 1, 0.005 do
            Stroke.Color = Color3.fromHSV(i, 1, 1) -- Renk döngüsü
            Title.TextColor3 = Color3.fromHSV(i, 0.5, 1) -- Yazı da hafif renk değiştirsin
            task.wait(0.01)
        end
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "🍝 MAKARNA SEVERLER BİRLİĞİ"
Title.TextSize = 26; Title.Font = Enum.Font.FredokaOne; Title.BackgroundTransparency = 1; Title.Parent = MainFrame

-- 📂 SEKME YÖNETİMİ
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1, 0, 0, 45); TabButtons.Position = UDim2.new(0, 0, 0, 70); TabButtons.BackgroundTransparency = 1; TabButtons.Parent = MainFrame

local function createTab(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 1, 0); btn.Position = UDim2.new(pos, 0, 0, 0); btn.Text = name; btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold
    btn.Parent = TabButtons; Instance.new("UICorner", btn); return btn
end

local bSettings = createTab("Ayarlar", 0.02)
local bLocs = createTab("Bölgeler", 0.21)
local bPlayers = createTab("Oyuncular", 0.40)
local bVisuals = createTab("Görsel", 0.59)
local bTrees = createTab("Ağaçlar", 0.78)

local function createPanel()
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(0.94, 0, 0.68, 0); p.Position = UDim2.new(0.03, 0, 0.25, 0); p.BackgroundTransparency = 1
    p.ScrollBarThickness = 4; p.Visible = false; p.Parent = MainFrame; Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end

local pSettings = createPanel(); pSettings.Visible = true
local pLocs = createPanel(); local pPlayers = createPanel(); local pVisuals = createPanel(); local pTrees = createPanel()

local function showPanel(panel)
    pSettings.Visible = false; pLocs.Visible = false; pPlayers.Visible = false; pVisuals.Visible = false; pTrees.Visible = false
    panel.Visible = true
end

bSettings.MouseButton1Click:Connect(function() showPanel(pSettings) end)
bLocs.MouseButton1Click:Connect(function() showPanel(pLocs) end)
bPlayers.MouseButton1Click:Connect(function() showPanel(pPlayers) end)
bVisuals.MouseButton1Click:Connect(function() showPanel(pVisuals) end)
bTrees.MouseButton1Click:Connect(function() showPanel(pTrees) end)

-- 🛠️ BİLEŞEN FABRİKASI
local function createAdjuster(text, varName, step, parent)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.95, 0, 0, 60); f.BackgroundTransparency = 0.7; f.BackgroundColor3 = Color3.fromRGB(40,40,55); f.Parent = parent
    Instance.new("UICorner", f)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0.05, 0, 0, 0); l.Text = text .. ": " .. settings[varName]
    l.TextSize = 18; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    local p = Instance.new("TextButton")
    p.Size = UDim2.new(0, 45, 0, 45); p.Position = UDim2.new(0.7, 0, 0.1, 0); p.Text = "+"; p.Parent = f
    local m = Instance.new("TextButton")
    m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0.85, 0, 0.1, 0); m.Text = "-"; m.Parent = f
    p.MouseButton1Click:Connect(function() settings[varName] = settings[varName] + step; l.Text = text .. ": " .. settings[varName] end)
    m.MouseButton1Click:Connect(function() settings[varName] = math.max(0, settings[varName] - step); l.Text = text .. ": " .. settings[varName] end)
end

local function createToggle(text, varName, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 50); btn.Text = text .. ": KAPALI"; btn.TextSize = 18; btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.Parent = parent
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        settings[varName] = not settings[varName]
        btn.Text = text .. (settings[varName] and ": AÇIK" or ": KAPALI")
        btn.BackgroundColor3 = settings[varName] and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(45, 45, 60)
    end)
end

-- 1. AYARLAR
createAdjuster("Koşma Hızı", "walkSpeed", 10, pSettings)
createAdjuster("Zıplama Gücü", "jumpPower", 10, pSettings)
createAdjuster("Fly Hızı", "flySpeed", 10, pSettings)
createToggle("Hız/Zıplama Aktif", "speedActive", pSettings)
createToggle("Fly (Uçma) Aktif", "flyActive", pSettings)

-- 2. BÖLGELER (SIRALI VE DÜZENLİ)
for n, cf in pairs(locations) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.95, 0, 0, 45); b.Text = n; b.TextSize = 16; b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.TextColor3 = Color3.new(0.9, 0.9, 0.9); b.Parent = pLocs; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() player.Character.HumanoidRootPart.CFrame = cf end)
end

-- 3. OYUNCULAR (YENİLEME SİSTEMLİ)
local function refreshPlayers()
    for _, c in pairs(pPlayers:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.95, 0, 0, 50); b.Text = p.DisplayName; b.Parent = pPlayers; Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() 
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame 
                end 
            end)
        end
    end
end
bPlayers.MouseButton1Click:Connect(refreshPlayers)

-- 4. GÖRSEL
createToggle("☀️ Her Zaman Gündüz", "dayActive", pVisuals)
createToggle("💡 Fullbright (Gece Görüş)", "fullbrightActive", pVisuals)

--- 🪓 GELİŞMİŞ BALTA VE OTO-FARM SİSTEMİ
local function getAxe()
    local axe = player.Character:FindFirstChildOfClass("Tool")
    if not axe then axe = player.Backpack:FindFirstChildOfClass("Tool") end
    if axe and (axe:FindFirstChild("RemoteEvent") or axe:FindFirstChild("ProcessClick")) then return axe end
    return nil
end

createToggle("🔥 OTO-KESME (YANINA GİDİNCE)", "autoCutActive", pTrees)

for _, wood in pairs(woodTypes) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.95, 0, 0, 50); b.Text = wood .. " [KÖKTEN KES & EVE GETİR]"; b.BackgroundColor3 = Color3.fromRGB(80, 50, 40); b.Parent = pTrees; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        local axe = getAxe()
        if not axe then 
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="⚠️ HATA", Text="Lütfen baltayı bir kez elinize alın!"})
            return 
        end
        if settings.isFarming then return end

        local root = player.Character.HumanoidRootPart
        settings.homePos = root.CFrame
        settings.isFarming = true

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("StringValue") and v.Value == wood and v.Parent and v.Parent:FindFirstChild("WoodSection") then
                local base = v.Parent.WoodSection
                root.CFrame = base.CFrame * CFrame.new(0, 2, 0)
                
                task.spawn(function()
                    local cutTime = tick()
                    local event = axe:FindFirstChild("RemoteEvent") or axe:FindFirstChild("ProcessClick")
                    
                    while tick() - cutTime < 3.8 and base.Parent do
                        event:FireServer({["Part"]=base,["Direction"]=Vector3.new(0, 1, 0),["Position"]=base.Position,["Damage"]=100})
                        task.wait(0.04)
                    end

                    task.wait(0.5); local lastPos = base.Position; root.CFrame = settings.homePos
                    
                    task.wait(0.4)
                    for _, region in pairs(workspace:GetChildren()) do
                        if region.Name == "WoodRegion" then
                            for _, section in pairs(region:GetChildren()) do
                                if (section.Position - lastPos).Magnitude < 60 then
                                    section.CFrame = settings.homePos * CFrame.new(0, 5, 0)
                                end
                            end
                        end
                    end
                    settings.isFarming = false
                end)
                break
            end
        end
    end)
end

--- ⚙️ FİZİK MOTORU
local bv, ba
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if hum then
            hum.WalkSpeed = settings.speedActive and settings.walkSpeed or 16
            hum.JumpPower = settings.speedActive and settings.jumpPower or 50
        end

        if settings.fullbrightActive then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
        if settings.dayActive then Lighting.ClockTime = 12 end

        if settings.flyActive and root then
            if not bv then
                hum.PlatformStand = true
                bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                ba = Instance.new("BodyAngularVelocity", root); ba.MaxTorque = Vector3.new(1e6, 1e6, 1e6); ba.AngularVelocity = Vector3.new(0,0,0)
            end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            bv.Velocity = dir * settings.flySpeed
        else
            if bv then bv:Destroy(); bv = nil; ba:Destroy(); ba = nil; hum.PlatformStand = false end
        end

        if settings.autoCutActive and not settings.isFarming then
            local axe = getAxe()
            if axe then
                local event = axe:FindFirstChild("RemoteEvent") or axe:FindFirstChild("ProcessClick")
                for _, region in pairs(workspace:GetChildren()) do
                    if region.Name == "WoodRegion" then
                        for _, s in pairs(region:GetChildren()) do
                            if s.Name == "WoodSection" and (s.Position - root.Position).Magnitude < 35 then
                                event:FireServer({["Part"]=s, ["Direction"]=Vector3.new(0,1,0), ["Position"]=s.Position, ["Damage"]=100})
                            end
                        end
                    end
                end
            end
        end
    end)
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Insert then MainFrame.Visible = not MainFrame.Visible end
end)
