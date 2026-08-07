local Player = {}

function Player.Init(Tab)
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local LocalPlayer      = Players.LocalPlayer
    local Mouse            = LocalPlayer:GetMouse()
    local Camera           = Workspace.CurrentCamera

    local env = getgenv and getgenv() or _G

    if env.PM_Connections then
        for _, conn in pairs(env.PM_Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
    end
    env.PM_Connections = {}

    -- ===========================
    -- STATE VARIABLES
    -- ===========================
    env.WalkSpeed     = 16
    env.SprintEnabled = false
    env.SprintSpeed   = 32
    env.IsSprinting   = false

    env.JumpHeight = 50
    env.InfJump    = false

    env.FlyMasterSwitch = true
    env.IsFlying        = false
    env.FlySpeed        = 100

    env.Noclip      = false
    env.WaterWalk   = false
    env.ClickTP     = false
    env.HardDragger = false

    local flyVelocity     = nil
    local flyGyro         = nil
    local hardDraggerConn = nil

    -- Freecam state
    local freecamActive = false
    local freecamPos    = Vector3.new(0, 50, 0)
    local freecamYaw    = 0
    local freecamPitch  = 0
    local freecamRMB    = false
    local freecamConn   = nil
    local FREECAM_SENS  = 0.003

    -- ===========================
    -- CLEANUP ORPHANED OBJECTS
    -- ===========================
    local function CleanupOrphanedFlyObjects()
        local char = LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "ExploitFlyVelocity" or v.Name == "ExploitFlyGyro" then
                    v:Destroy()
                end
            end
            pcall(function() hrp.Velocity    = Vector3.new(0, 0, 0) end)
            pcall(function() hrp.RotVelocity = Vector3.new(0, 0, 0) end)
        end

        if hum then
            hum.PlatformStand = false
            task.delay(0.05, function()
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end)
        end

        env.IsFlying = false
        env.Noclip   = false
        flyVelocity  = nil
        flyGyro      = nil

        -- Disable freecam on character reset so camera returns to normal
        if freecamActive then
            freecamActive                  = false
            if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
            Camera.CameraType              = Enum.CameraType.Custom
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            freecamRMB                     = false
        end
    end

    CleanupOrphanedFlyObjects()

    table.insert(env.PM_Connections, LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.1)
        CleanupOrphanedFlyObjects()
    end))

    -- ===========================
    -- PHYSICS & UTILS
    -- ===========================
    local function UpdateFlyPhysics(state)
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        if state and hrp and hum then
            if not flyVelocity or not flyVelocity.Parent then
                flyVelocity = Instance.new("BodyVelocity")
                flyVelocity.Name     = "ExploitFlyVelocity"
                flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                flyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyVelocity.Parent   = hrp
            end
            if not flyGyro or not flyGyro.Parent then
                flyGyro = Instance.new("BodyGyro")
                flyGyro.Name      = "ExploitFlyGyro"
                flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                flyGyro.P         = 10000
                flyGyro.Parent    = hrp
            end
            hum.PlatformStand = true
        else
            if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
            if flyGyro     then flyGyro:Destroy();     flyGyro     = nil end
            if hum then
                hum.PlatformStand = false
                task.wait(0.05)
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
    end

    -- ===========================
    -- FREECAM
    -- ===========================
    local function SetFreecam(state)
        freecamActive = state

        if freecamConn then freecamConn:Disconnect(); freecamConn = nil end

        if not state then
            Camera.CameraType              = Enum.CameraType.Custom
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            freecamRMB                     = false
            return
        end

        -- Seed position and angles from where the camera currently sits
        freecamPos    = Camera.CFrame.Position
        local lookVec = Camera.CFrame.LookVector
        freecamYaw    = math.atan2(-lookVec.X, -lookVec.Z)
        freecamPitch  = math.asin(math.clamp(lookVec.Y, -1, 1))

        Camera.CameraType = Enum.CameraType.Scriptable

        freecamConn = RunService.RenderStepped:Connect(function(dt)
            if not freecamActive then return end

            -- Rotation: sample GetMouseDelta every frame while RMB is held
            if freecamRMB then
                local delta  = UserInputService:GetMouseDelta()
                freecamYaw   = freecamYaw   - delta.X * FREECAM_SENS
                freecamPitch = math.clamp(
                    freecamPitch - delta.Y * FREECAM_SENS,
                    math.rad(-89), math.rad(89)
                )
            end

            local speed = env.FlySpeed * dt
            local rot   = CFrame.Angles(0, freecamYaw, 0) * CFrame.Angles(freecamPitch, 0, 0)

            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W)         then moveDir += rot.LookVector       end
            if UserInputService:IsKeyDown(Enum.KeyCode.S)         then moveDir -= rot.LookVector       end
            if UserInputService:IsKeyDown(Enum.KeyCode.A)         then moveDir -= rot.RightVector      end
            if UserInputService:IsKeyDown(Enum.KeyCode.D)         then moveDir += rot.RightVector      end
            if UserInputService:IsKeyDown(Enum.KeyCode.E)         then moveDir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                freecamPos += moveDir.Unit * speed
            end

            Camera.CFrame = CFrame.new(freecamPos)
                * CFrame.Angles(0, freecamYaw, 0)
                * CFrame.Angles(freecamPitch, 0, 0)
        end)
    end

    -- ===========================
    -- HARD DRAGGER
    -- ===========================
    local function SetHardDragger(state)
        if hardDraggerConn then
            hardDraggerConn:Disconnect()
            hardDraggerConn = nil
        end
        if not state then return end
    
        hardDraggerConn = RunService.Stepped:Connect(function()
            local dragger = Workspace:FindFirstChild("Dragger")
            if dragger then
                local bp = dragger:FindFirstChild("BodyPosition")
                local bg = dragger:FindFirstChild("BodyGyro")
                if bp then
                    bp.P        = 120000
                    bp.D        = 1000
                    bp.maxForce = Vector3.new(1, 1, 1) * math.huge
                end
                if bg then
                    bg.maxTorque = Vector3.new(1, 1, 1) * math.huge
                    bg.P         = 1200
                    bg.D         = 140
                end
            end
        end)
    end

    -- ===========================
    -- INPUT CONNECTIONS
    -- ===========================
    table.insert(env.PM_Connections, UserInputService.InputBegan:Connect(function(input, processed)
        -- Ctrl + Click TP
        if not processed and env.ClickTP
            and input.UserInputType == Enum.UserInputType.MouseButton1
            and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end

        -- Freecam: lock mouse position while RMB held for smooth rotation
        if freecamActive and input.UserInputType == Enum.UserInputType.MouseButton2 then
            freecamRMB                     = true
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        end
    end))

    table.insert(env.PM_Connections, UserInputService.InputEnded:Connect(function(input)
        -- Freecam: unlock mouse when RMB released
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            freecamRMB = false
            if freecamActive then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end
    end))

    table.insert(env.PM_Connections, UserInputService.JumpRequest:Connect(function()
        if env.InfJump then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end))

    -- ===========================
    -- UI SECTIONS
    -- ===========================
    Tab:CreateSection("Movement")
    Tab:CreateSlider("Walk Speed",   16,  500,  16,  function(v) env.WalkSpeed   = v end)
    Tab:CreateSlider("Jump Height",  50,  800,  50,  function(v) env.JumpHeight  = v end)
    Tab:CreateSlider("Sprint Speed", 32,  1000, 32,  function(v) env.SprintSpeed = v end)
    Tab:CreateSlider("Fly Speed",    50,  1000, 100, function(v) env.FlySpeed    = v end)

    local SprintRow = Tab:CreateRow()
    SprintRow:CreateToggle("Sprint", false, function(s) env.SprintEnabled = s end)
    SprintRow:CreateKeybind("KeyBind", Enum.KeyCode.LeftShift, function()
        env.IsSprinting = not env.IsSprinting
    end)

    local FlyRow = Tab:CreateRow()
    FlyRow:CreateToggle("Fly", true, function(s)
        env.FlyMasterSwitch = s
        if not s and env.IsFlying then
            env.IsFlying = false
            UpdateFlyPhysics(false)
        end
    end)
    FlyRow:CreateKeybind("KeyBind", Enum.KeyCode.Q, function()
        if env.FlyMasterSwitch and not freecamActive then
            env.IsFlying = not env.IsFlying
            UpdateFlyPhysics(env.IsFlying)
        end
    end)

    Tab:CreateSection("Camera")
    Tab:CreateSlider("Field of View", 60, 120, 70, function(v) Camera.FieldOfView = v end)
    Tab:CreateToggle("Infinite Zoom", false, function(s)
        LocalPlayer.CameraMaxZoomDistance = s and 10000 or 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end):AddTooltip("Disable fog in world tab for the best results. At extreme distances, fog can block your view.")
    Tab:CreateToggle("Freecam", false, function(s)
        SetFreecam(s)
    end):AddTooltip("WASD = move  |  E / Shift = up / down  |  Hold right-click to rotate  |  Speed uses Fly Speed slider.")
    
    Tab:CreateSection("Utility")
    Tab:CreateToggle("Infinite Jump",   false, function(s) env.InfJump   = s end)
    Tab:CreateToggle("Noclip",          false, function(s) env.Noclip    = s end)
    Tab:CreateToggle("Water Walk",      false, function(s) env.WaterWalk = s end)
    Tab:CreateToggle("Ctrl + Click TP", false, function(s) env.ClickTP   = s end)
    Tab:CreateToggle("Hard Dragger",    false, function(s)
        env.HardDragger = s
        SetHardDragger(s)
    end)
    Tab:CreateAction("Reset Character", "Kill", function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end)

    -- ===========================
    -- MASTER LOOP
    -- ===========================
    table.insert(env.PM_Connections, RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and not env.IsFlying then
            hum.PlatformStand = false
        end

        if env.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        if hum then
            hum.UseJumpPower = true
            if freecamActive then
                -- Freeze the character completely while freecam is active
                hum.WalkSpeed = 0
                hum.JumpPower = 0
            else
                hum.JumpPower = env.JumpHeight
                if env.SprintEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    hum.WalkSpeed = env.SprintSpeed
                else
                    hum.WalkSpeed = env.WalkSpeed
                end
            end
        end

        if env.WaterWalk and hrp then
            if hrp.Position.Y <= 1 and hrp.Position.Y >= -5 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                hrp.CFrame   = hrp.CFrame + Vector3.new(0, 0.1, 0)
            end
        end

        if env.IsFlying and hrp then
            if not hrp:FindFirstChild("ExploitFlyVelocity") then UpdateFlyPhysics(true) end
            if flyVelocity and flyGyro then
                local moveVector = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector  end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector  end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
                local vel = (moveVector.Magnitude > 0) and (moveVector.Unit * env.FlySpeed) or Vector3.new(0, 0, 0)
                flyVelocity.Velocity = vel
                flyGyro.CFrame       = Camera.CFrame
            end
        end
    end))
end

return Player
