print("Request recieved!")

local RunService = game:GetService("RunService")
local gamePlayers = game:GetService("Players")
local localUser = gamePlayers.LocalPlayer
local localCharacter = localUser.Character

print("Loaded local values")

local playerValues = {
    walkSpeed = 16,
    jumpPwr = 60,
    flySpeed = 80
}

print("Loaded player values")

RunService.Heartbeat:Connect(function()
	localCharacter:FindFirstChildWhichIsA("Humanoid").WalkSpeed = playerValues.walkSpeed
    localCharacter:FindFirstChildWhichIsA("Humanoid").JumpPower = playerValues.jumpPwr
end)
