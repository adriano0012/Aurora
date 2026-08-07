local HardDragger = {}

function HardDragger.Init(Tab)
    local workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local connection = nil

    Tab:CreateToggle("Hard Dragger", false, function(state)
        -- Clean up existing connection first
        if connection then
            connection:Disconnect()
            connection = nil
        end

        if not state then return end

        connection = workspace.ChildAdded:Connect(function(child)
            if tostring(child) ~= "Dragger" then return end

            local BodyGyro     = child:WaitForChild("BodyGyro")
            local BodyPosition = child:WaitForChild("BodyPosition")

            -- Wait until Dragger exists in workspace
            repeat RunService.Stepped:Wait() until workspace:FindFirstChild("Dragger")

            -- Apply hard drag values every step while dragging
            repeat
                RunService.Stepped:Wait()
                BodyPosition.P        = 120000
                BodyPosition.D        = 1000
                BodyPosition.maxForce = Vector3.new(1, 1, 1) * 1000000
                BodyGyro.maxTorque    = Vector3.new(1, 1, 1) * 200
                BodyGyro.P            = 1200
                BodyGyro.D            = 140
            until not workspace:FindFirstChild("Dragger")

            -- Revert to default values after drag ends
            BodyPosition.P        = 10000
            BodyPosition.D        = 800
            BodyPosition.maxForce = Vector3.new(17000, 17000, 17000)
            BodyGyro.maxTorque    = Vector3.new(200, 200, 200)
            BodyGyro.P            = 1200
            BodyGyro.D            = 140
        end)
    end)
end

return HardDragger
