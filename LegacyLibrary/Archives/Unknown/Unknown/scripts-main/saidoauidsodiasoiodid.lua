local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")


local GameName = "Arsenal"
if game.PlaceId ~= 286090429 then 
    return
end


if _G.AimBotScript then
    _G.AimBotScript:Destroy() 
end


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    return
end


local Window = Rayfield:CreateWindow({
    Name = "Simple Arsenal Script",
    LoadingTitle = "Loading Arsenal Script...",
    LoadingSubtitle = "by v5x",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AimBotConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink", 
        RememberJoins = true
    }
})


local Enabled = true
local FOV = 100
local Smoothing = 0.1
local ShowFOVCircle = true
local ShowESP = true
local ESPColor = Color3.new(1, 0, 0) -- Red by default


if not Drawing then
    return
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = ShowFOVCircle
FOVCircle.Radius = FOV
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)


local ESPDrawings = {}

local function CreateESP(player)
    if ESPDrawings[player] then return end

    local drawings = {}
    drawings.Box = Drawing.new("Square")
    drawings.Box.Visible = false
    drawings.Box.Color = ESPColor
    drawings.Box.Thickness = 2
    drawings.Box.Filled = false

    ESPDrawings[player] = drawings
end

local function RemoveESP(player)
    if not ESPDrawings[player] then return end

    for _, drawing in pairs(ESPDrawings[player]) do
        drawing:Remove()
    end
    ESPDrawings[player] = nil
end

local function UpdateESP()
    for player, drawings in pairs(ESPDrawings) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            
            if player.Team ~= LocalPlayer.Team then
                local head = player.Character.Head
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local scale = 1 / (screenPoint.Z * math.tan(math.rad(Camera.FieldOfView / 2)) * 1000)
                    local size = Vector2.new(4 * scale, 5 * scale)

                    
                    drawings.Box.Size = size
                    drawings.Box.Position = Vector2.new(screenPoint.X - size.X / 2, screenPoint.Y - size.Y / 2)
                    drawings.Box.Visible = ShowESP
                else
                    drawings.Box.Visible = false
                end
            else
                drawings.Box.Visible = false
            end
        else
            drawings.Box.Visible = false
        end
    end
end


local MainTab = Window:CreateTab("Main", 4483362458) 
local SettingsTab = Window:CreateTab("Settings", 4483362458) 

MainTab:CreateToggle({
    Name = "Enable Aim Bot",
    CurrentValue = Enabled,
    Flag = "EnabledToggle",
    Callback = function(value)
        Enabled = value
    end
})

MainTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = ShowFOVCircle,
    Flag = "ShowFOVToggle",
    Callback = function(value)
        ShowFOVCircle = value
        FOVCircle.Visible = value
    end
})

MainTab:CreateToggle({
    Name = "Show ESP",
    CurrentValue = ShowESP,
    Flag = "ShowESPToggle",
    Callback = function(value)
        ShowESP = value
    end
})

SettingsTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 300},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = FOV,
    Flag = "FOVSlider",
    Callback = function(value)
        FOV = value
        FOVCircle.Radius = value
    end
})

SettingsTab:CreateSlider({
    Name = "Smoothing",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = Smoothing,
    Flag = "SmoothingSlider",
    Callback = function(value)
        Smoothing = value
    end
})

SettingsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = ESPColor,
    Flag = "ESPColorPicker",
    Callback = function(value)
        ESPColor = value
        for _, drawings in pairs(ESPDrawings) do
            drawings.Box.Color = value
        end
    end
})


local function IsPlayerVisible(player)
    if not player.Character then return false end
    local target = player.Character:FindFirstChild("Head")
    if not target then return false end

    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin).Unit
    local ray = Ray.new(origin, direction * 1000)

    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})

    if hit and hit:IsDescendantOf(player.Character) then
        return true
    end
    return false
end

local function IsInFOVCircle(player)
    if not player.Character then return false end
    local target = player.Character:FindFirstChild("Head")
    if not target then return false end

    local screenPoint, onScreen = Camera:WorldToViewportPoint(target.Position)
    if not onScreen then return false end

    local circleCenter = FOVCircle.Position
    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - circleCenter).Magnitude

    return distance <= FOVCircle.Radius
end

local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            
            if player.Team ~= LocalPlayer.Team then
                
                if IsPlayerVisible(player) and IsInFOVCircle(player) then
                    local screenPoint = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    local circleCenter = FOVCircle.Position
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - circleCenter).Magnitude

                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function AimBot()
    if not Enabled then return end 
    local closestPlayer = GetClosestPlayerInFOV()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        local target = closestPlayer.Character.Head
        
        local currentLook = Camera.CFrame.LookVector
        local targetLook = (target.Position - Camera.CFrame.Position).Unit
        local adjustedLook = (currentLook + (targetLook - currentLook) * Smoothing).Unit
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + adjustedLook)
    end
end


local success, err = pcall(function()
    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        UpdateESP()
    end)
    RunService.RenderStepped:Connect(AimBot)
end)
if not success then
    warn("Error in RenderStepped connection: " .. err)
end


for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end


Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)


Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)


_G.AimBotScript = {
    Destroy = function()
        
        if FOVCircle then
            FOVCircle:Remove()
        end

        
        for player, drawings in pairs(ESPDrawings) do
            RemoveESP(player)
        end

        
        for _, connection in pairs(getconnections(RunService.RenderStepped)) do
            connection:Disconnect()
        end

        
        if Window then
            Window:Destroy()
        end
    end
}
