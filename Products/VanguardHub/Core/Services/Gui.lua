local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Gui = {}

local function safeGlobal(name)
    local ok, value = pcall(function()
        return rawget(_G, name)
    end)
    return ok and value or nil
end

function Gui.GetParent()
    if RunService:IsStudio() then
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChild("PlayerGui")
        if playerGui then
            return playerGui
        end
    end

    local gethui = safeGlobal("gethui")
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result and typeof(result) == "Instance" then
            return result
        end
    end

    return CoreGui
end

function Gui.Protect(screenGui)
    local syn = safeGlobal("syn")
    if RunService:IsStudio() or type(syn) ~= "table" or type(syn.protect_gui) ~= "function" then
        return false
    end

    local ok = pcall(syn.protect_gui, screenGui)
    return ok == true
end

return Gui
