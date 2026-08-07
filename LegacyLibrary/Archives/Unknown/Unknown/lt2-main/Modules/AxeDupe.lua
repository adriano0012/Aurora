-- RespawnLoad.lua
local RespawnLoad = {}
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

function RespawnLoad.Init(Tab, Library)
    if not Tab then return warn("[RespawnLoad] Tab was nil!") end
    local LocalPlayer      = Players.LocalPlayer
    local loadSaveRequests = ReplicatedStorage:FindFirstChild("LoadSaveRequests")

    local function Notify(title, body, duration)
        if Library and Library.Notify then
            Library:Notify(title, body, duration or 4)
        else
            warn(("[RespawnLoad] %s — %s"):format(title, body))
        end
    end

    -- ================================================================
    --  CAMERA FIX
    --  Called for every new character. Waits until the character is
    --  physically out of the void before touching the camera — otherwise
    --  we'd "fix" it while the character is still at Y=-100 and it
    --  would immediately look wrong again.
    --  Also hard-resets cam.CFrame so the engine doesn't slowly
    --  interpolate up from the void position.
    -- ================================================================
    local function FixCameraForChar(char)
        task.spawn(function()
            local hum = char:WaitForChild("Humanoid", 10)
            local hrp = char:WaitForChild("HumanoidRootPart", 10)
            if not hum or not hrp then return end
    
            -- Wait until the character is above void.
            local giveUp = tick() + 20
            repeat task.wait(0.15) until hrp.Position.Y > -10 or tick() > giveUp
    
            -- Wait for the save/load cycle to fully finish before touching the
            -- camera. While CurrentlySavingOrLoading is true the game is showing
            -- the plot-selection preview; resetting the camera during that window
            -- would break the preview.
            local savingFlag = LocalPlayer:FindFirstChild("CurrentlySavingOrLoading")
            if savingFlag then
                local flagDeadline = tick() + 30
                repeat task.wait(0.1) until savingFlag.Value == false or tick() > flagDeadline
            end
    
            -- 1 s buffer so the plot-selection UI has time to finish its own
            -- camera work before we override it.
            task.wait(1)
    
            local cam = workspace.CurrentCamera
            if not cam then return end
    
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            cam.CameraType         = Enum.CameraType.Custom
            cam.CameraSubject      = hum
            cam.CFrame             = CFrame.new(hrp.Position + Vector3.new(0, 3, 8))
    
            local enforceUntil = tick() + 6
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if tick() > enforceUntil then conn:Disconnect(); return end
                local c   = LocalPlayer.Character
                local h   = c and c:FindFirstChildOfClass("Humanoid")
                local cam = workspace.CurrentCamera
                if not (cam and h) then return end
                if cam.CameraType ~= Enum.CameraType.Custom
                or cam.CameraSubject ~= h then
                    LocalPlayer.CameraMode = Enum.CameraMode.Classic
                    cam.CameraType         = Enum.CameraType.Custom
                    cam.CameraSubject      = h
                end
            end)
        end)
    end

    -- ================================================================
    --  CORE LOGIC
    -- ================================================================
    local function ReloadCurrentSlot()
        -- 1. Read active slot
        local slotObj = LocalPlayer:FindFirstChild("CurrentSaveSlot")
        if not slotObj or slotObj.Value == -1 then
            Notify("ERROR", "No save slot is currently loaded.", 5)
            return
        end
        local slot = slotObj.Value

        -- 2. Validate remotes
        if not loadSaveRequests then
            Notify("ERROR", "LoadSaveRequests folder not found.", 5)
            return
        end

        local RequestLoadRemote = loadSaveRequests:FindFirstChild("RequestLoad")
        local ClientMayLoad     = loadSaveRequests:FindFirstChild("ClientMayLoad")

        if not RequestLoadRemote or not ClientMayLoad then
            Notify("ERROR", "Necessary load remotes missing.", 5)
            return
        end

        -- 3. Pre-check: can we load right now?
        local success, result = pcall(function()
            return ClientMayLoad:InvokeServer(slot)
        end)

        if not success then
            Notify("ERROR", "ClientMayLoad failed to communicate.", 5)
            return
        elseif result ~= true then
            Notify("DENIED", "Server denied load request (Cooldown?).", 5)
            return
        end

        -- 4. Character validation
        local char     = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp      = char and char:FindFirstChild("HumanoidRootPart")

        if not humanoid or humanoid.Health <= 0 then
            Notify("ERROR", "Character not found or already dead.", 5)
            return
        end

        -- 5. Subscribe to CharacterAdded BEFORE killing the player.
        --    Using Connect (not Wait) means we never miss the event even if
        --    the server responds to InvokeServer while CharacterAdded is
        --    already firing. The connection covers both the auto-respawn after
        --    death and the second spawn triggered by the load itself.
        --    It self-cleans after 40 s to avoid leaking.
        local charConn
        charConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
            FixCameraForChar(newChar)
        end)
        task.delay(40, function()
            if charConn then charConn:Disconnect() end
        end)

        Notify("RELOADING", "Permissions valid. Reloading slot " .. slot .. "…", 4)

        -- 6. Drop into void and wait for death
        hrp.CFrame = CFrame.new(hrp.Position.X, -100, hrp.Position.Z)
        humanoid.Died:Wait()

        -- 7. Fire RequestLoad
        local ok, err = pcall(function()
            RequestLoadRemote:InvokeServer(slot)
        end)

        if not ok then
            Notify("FAILED", "RequestLoad failed: " .. tostring(err), 6)
            return
        end

        Notify("SUCCESS", "Slot " .. slot .. " reloaded!", 5)
    end

    -- ================================================================
    --  UI
    -- ================================================================
    Tab:CreateSection("Axe Duplication")
    Tab:CreateAction("Inventory Axes", "Dupe", function()
        task.spawn(ReloadCurrentSlot)
    end)
end

return RespawnLoad
