-- Solara v2 for Lumber Tycoon 2 — by ChatGPT
-- Features: Auto-chop, Teleport to base, Auto-sell, Safe duplication, Teleports, Safe pacing.

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "🌲 Solara v2 | Lumber Tycoon 2",
    LoadingTitle = "Загрузка Solara...",
    LoadingSubtitle = "by ChatGPT",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local AutoChop = false
local SafeDelay = 1.5

local tab = Window:CreateTab("Auto Farm")
tab:CreateToggle({
    Name = "Авто-копка деревьев",
    CurrentValue = false,
    Callback = function(state)
        AutoChop = state
        while AutoChop do
            task.wait(SafeDelay)
            local Trees = workspace:FindFirstChild("TreeRegion") and workspace.TreeRegion:GetChildren() or {}
            for _, tree in ipairs(Trees) do
                if tree:FindFirstChild("TreeClass") and tree:FindFirstChild("WoodSection") then
                    local axe = game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
                    if axe then
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(axe)
                        for _, sec in pairs(tree:GetDescendants()) do
                            if sec:IsA("BasePart") and sec.Name == "WoodSection" then
                                fireclickdetector(sec:FindFirstChildOfClass("ClickDetector"))
                                axe:Activate()
                                task.wait(0.5)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
})

tab:CreateButton({
    Name = "Телепорт всех бревен на базу",
    Callback = function()
        local base = nil
        for _, v in pairs(workspace.Properties:GetChildren()) do
            if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
                base = v
                break
            end
        end
        if base then
            for _, log in pairs(workspace.LogModels:GetChildren()) do
                if log:IsA("Model") and log:FindFirstChild("MainPart") then
                    log:SetPrimaryPartCFrame(base.OriginSquare.CFrame + Vector3.new(0, 5, 0))
                    task.wait(0.2)
                end
            end
        end
    end
})

tab:CreateButton({
    Name = "Авто-продажа досок",
    Callback = function()
        local SellArea = workspace:FindFirstChild("SellArea")
        for _, item in pairs(workspace.PlayerModels:GetChildren()) do
            if item:IsA("Model") and item:FindFirstChild("MainPart") then
                item:SetPrimaryPartCFrame(SellArea.CFrame + Vector3.new(0, 5, 0))
                task.wait(0.2)
            end
        end
    end
})

tab:CreateButton({
    Name = "Безопасный дюп (вручную)",
    Callback = function()
        game.Players.LocalPlayer:Kick("Для дюпа: перезайди в игру, не сохраняя слот.")
    end
})

local tptab = Window:CreateTab("Телепорты")
local locations = {
    ["Wood R Us"] = Vector3.new(265, 3, 56),
    ["Fine Arts"] = Vector3.new(489, 3, -1602),
    ["Boxed Cars"] = Vector3.new(516, 3, -147),
    ["Land Store"] = Vector3.new(258, 3, -96),
    ["Bridge"] = Vector3.new(118, 3, -846)
}
for name, pos in pairs(locations) do
    tptab:CreateButton({ Name = "Телепорт: " .. name, Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end })
end

local infotab = Window:CreateTab("Инфо")
infotab:CreateParagraph({
    Title = "Solara v2",
    Content = "Безопасный GUI для Lumber Tycoon 2.\nМедленный темп действий, без массовых абьюзов.\nДюп — вручную."
})
