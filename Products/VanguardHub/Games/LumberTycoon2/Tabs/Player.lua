\-- ============================================================
\-- VANGUARD HUB - PLAYER v1.0
\-- ============================================================

*return* *function*(UI, Config, Utils)
    -- ============================================================
    -- SERVICES
    -- ============================================================
    
    *local* Players *=* game\:GetService("Players")
    *local* RunService *=* game\:GetService("RunService")
    *local* UserInputService *=* game\:GetService("UserInputService")
    *local* Workspace *=* workspace
    *local* VirtualUser *=* game\:GetService("VirtualUser")
    
    -- ============================================================
    -- PLAYER REFERENCES
    -- ============================================================
    
    *local* LocalPlayer *=* Players.LocalPlayer
    *local* Character, Humanoid, RootPart
    
    -- ============================================================
    -- STATE
    -- ============================================================
    
    *local* Connections *=* {}
    *local* FeatureConnections *=* {}
    *local* CreatedInstances *=* {}
    
    *local* OriginalCollisions *=* {}
    *local* OriginalTransparency *=* {}
    *local* OriginalPhysics *=* {}
    
    *local* LastSafeCFrame
    *local* LastSafeUpdate *=* 0
    
    *local* Sprinting *=* false
    *local* InfiniteSprintActive *=* false
    *local* FlightArmed *=* Config.Flight *or* false
    *local* NoclipToggleControl
    *local* SetFly
    
    -- Fly state
    *local* FlyActive *=* false
    *local* FlyBodyGyro, FlyBodyVelocity
    *local* FlySteer *=* {Forward *=* 0, Back *=* 0, Left *=* 0, Right *=* 0, Up *=* 0, Down *=* 0}
    
    -- Hard Dragger tasks
    *local* DraggerTasks *=* {}
    
    -- ============================================================
    -- CONNECTION MANAGEMENT
    -- ============================================================
    
    *local* *function* AddConnection(name, connection)
        *if* FeatureConnections[name] *then*
            pcall(*function*() FeatureConnections[name]\:Disconnect() *end*)
        *end*
        FeatureConnections[name] *=* connection
        *return* connection
    *end*
    
    *local* *function* RemoveConnection(name)
        *local* connection *=* FeatureConnections[name]
        *if* connection *then*
            pcall(*function*() connection\:Disconnect() *end*)
            FeatureConnections[name] *=* nil
        *end*
    *end*
    
    *local* *function* TrackConnection(connection)
        table.insert(Connections, connection)
        *return* connection
    *end*
    
    *local* *function* TrackInstance(instance)
        table.insert(CreatedInstances, instance)
        *return* instance
    *end*
    
    -- ============================================================
    -- CHARACTER HELPERS
    -- ============================================================
    
    *local* *function* RefreshCharacter(character)
        Character *=* character *or* LocalPlayer.Character
        *if* *not* Character *then* *return* false *end*
        
        Humanoid *=* Character\:FindFirstChildOfClass("Humanoid")
        RootPart *=* Character\:FindFirstChild("HumanoidRootPart")
        
        *return* Humanoid *\~=* nil *and* RootPart *\~=* nil
    *end*
    
    *local* *function* GetCharacter()
        *if* *not* Character *or* *not* Character.Parent *then*
            RefreshCharacter()
        *end*
        *return* Character, Humanoid, RootPart
    *end*
    
    *local* *function* SafeTeleport(cframe)
        *local* \_, \_, root *=* GetCharacter()
        *if* *not* root *then* *return* false *end*
        
        root.CFrame *=* cframe
        *return* true
    *end*
    
    RefreshCharacter()
    
    -- ============================================================
    -- MOVEMENT FUNCTIONS
    -- ============================================================
    
    *local* *function* IsTextInputFocused()
        *return* UserInputService\:GetFocusedTextBox() *\~=* nil
    *end*

    *local* *function* KeyMatches(input, keyName)
        *local* keyCode *=* keyName *and* Enum.KeyCode[keyName]
        *return* keyCode *and* input.KeyCode *==* keyCode
    *end*

    *local* *function* ApplyMovementValues()
        *local* \_, hum, \_ *=* GetCharacter()
        *if* *not* hum *then* *return* *end*
        
        *if* Sprinting *then*
            hum.WalkSpeed *=* Config.SprintSpeed *or* 65
        *else*
            hum.WalkSpeed *=* Config.WalkSpeed *or* 16
        *end*
        
        hum.UseJumpPower *=* true
        hum.JumpPower *=* Config.JumpPower *or* 50
    *end*

    AddConnection("MovementLock", RunService.Heartbeat\:Connect(*function*()
        ApplyMovementValues()
    *end*))
    
    -- NOCLIP
    *local* *function* SetNoclip(enabled)
        RemoveConnection("NoclipLoop")
        
        *if* *not* enabled *then*
            *for* part, originalValue *in* pairs(OriginalCollisions) *do*
                *if* part *and* part.Parent *then*
                    pcall(*function*() part.CanCollide *=* originalValue *end*)
                *end*
            *end*
            OriginalCollisions *=* {}
            *return*
        *end*
        
        *local* *function* ApplyNoclip()
            *local* char *=* GetCharacter()
            *if* *not* char *then* *return* *end*
            
            *for* \_, part *in* ipairs(char\:GetDescendants()) *do*
                *if* part\:IsA("BasePart") *then*
                    *if* OriginalCollisions[part] *==* nil *then*
                        OriginalCollisions[part] *=* part.CanCollide
                    *end*
                    part.CanCollide *=* false
                *end*
            *end*
        *end*
        
        ApplyNoclip()
        AddConnection("NoclipLoop", RunService.Stepped\:Connect(ApplyNoclip))
    *end*
    
    -- INFINITE JUMP
    *local* *function* SetInfiniteJump(enabled)
        RemoveConnection("InfiniteJump")
        
        *if* *not* enabled *then* *return* *end*
        
        AddConnection("InfiniteJump", UserInputService.JumpRequest\:Connect(*function*()
            *local* \_, hum *=* GetCharacter()
            *if* hum *and* hum\:GetState() *\~=* Enum.HumanoidStateType.Dead *then*
                hum\:ChangeState(Enum.HumanoidStateType.Jumping)
            *end*
        *end*))
    *end*
    
    -- SPRINT (FIXED: dynamic key check)
    *local* *function* SetupSprint()
        RemoveConnection("SprintBegan")
        RemoveConnection("SprintEnded")
        
        AddConnection("SprintBegan", UserInputService.InputBegan\:Connect(*function*(input, gameProcessed)
            *if* gameProcessed *or* IsTextInputFocused() *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *if* KeyMatches(input, Config.SprintKey *or* "LeftShift") *then*
                Sprinting *=* true
                ApplyMovementValues()
            *end*
        *end*))
        
        AddConnection("SprintEnded", UserInputService.InputEnded\:Connect(*function*(input, gameProcessed)
            *if* gameProcessed *or* IsTextInputFocused() *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *if* KeyMatches(input, Config.SprintKey *or* "LeftShift") *then*
                Sprinting *=* false
                InfiniteSprintActive *=* false
                ApplyMovementValues()
            *end*
        *end*))
    *end*
    
    -- FLY CONTROLS (FIXED: dynamic key check)
    *local* *function* SetupFlyControls()
        RemoveConnection("FlyToggle")
        RemoveConnection("NoclipToggle")
        
        AddConnection("FlyToggle", UserInputService.InputBegan\:Connect(*function*(input, gameProcessed)
            *if* gameProcessed *or* IsTextInputFocused() *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *if* KeyMatches(input, Config.FlyKey *or* "F") *and* FlightArmed *then*
                SetFly(*not* FlyActive)
            *end*
        *end*))
        
        AddConnection("NoclipToggle", UserInputService.InputBegan\:Connect(*function*(input, gameProcessed)
            *if* gameProcessed *or* IsTextInputFocused() *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *if* KeyMatches(input, Config.NoclipKey *or* "LeftControl") *then*
                *if* NoclipToggleControl *and* NoclipToggleControl.SetState *then*
                    NoclipToggleControl\:SetState(*not* Config.Noclip)
                *else*
                    Config.Noclip *=* *not* Config.Noclip
                    SetNoclip(Config.Noclip)
                *end*
            *end*
        *end*))
    *end*
    
    SetFly *=* *function*(enabled)
        *if* enabled *==* FlyActive *then* *return* *end*
        
        *if* *not* enabled *then*
            FlyActive *=* false
            
            *if* FlyBodyGyro *then*
                FlyBodyGyro\:Destroy()
                FlyBodyGyro *=* nil
            *end*
            *if* FlyBodyVelocity *then*
                FlyBodyVelocity\:Destroy()
                FlyBodyVelocity *=* nil
            *end*
            
            *local* \_, hum *=* GetCharacter()
            *if* hum *then* hum.PlatformStand *=* false *end*
            
            FlySteer.Forward *=* 0
            FlySteer.Back *=* 0
            FlySteer.Left *=* 0
            FlySteer.Right *=* 0
            FlySteer.Up *=* 0
            FlySteer.Down *=* 0
            
            RemoveConnection("FlyLoop")
            RemoveConnection("FlyInputBegan")
            RemoveConnection("FlyInputEnded")
            *return*
        *end*
        
        *local* \_, \_, root *=* GetCharacter()
        *if* *not* root *then* *return* *end*
        
        FlyActive *=* true
        *local* hum *=* Humanoid
        *if* hum *then*
            hum.PlatformStand *=* true
            hum\:ChangeState(Enum.HumanoidStateType.Physics)
        *end*
        
        FlyBodyGyro *=* TrackInstance(Instance.new("BodyGyro"))
        FlyBodyGyro.P *=* 9e4
        FlyBodyGyro.maxTorque *=* Vector3.new(1e6, 1e6, 1e6)
        FlyBodyGyro.CFrame *=* root.CFrame
        FlyBodyGyro.Parent *=* root
        
        FlyBodyVelocity *=* TrackInstance(Instance.new("BodyVelocity"))
        FlyBodyVelocity.maxForce *=* Vector3.new(1e6, 1e6, 1e6)
        FlyBodyVelocity.Parent *=* root
        
        -- Input handling (FIXED: always check current Config values)
        AddConnection("FlyInputBegan", UserInputService.InputBegan\:Connect(*function*(input, gpe)
            *if* gpe *or* IsTextInputFocused() *or* *not* FlyActive *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *local* keyCode *=* input.KeyCode
            
            *if* keyCode *==* Enum.KeyCode.W *then* FlySteer.Forward *=* 1
            *elseif* keyCode *==* Enum.KeyCode.A *then* FlySteer.Left *=* 1
            *elseif* keyCode *==* Enum.KeyCode.S *then* FlySteer.Back *=* 1
            *elseif* keyCode *==* Enum.KeyCode.D *then* FlySteer.Right *=* 1
            *elseif* KeyMatches(input, Config.FlyUp *or* "E") *then* FlySteer.Up *=* 1
            *elseif* KeyMatches(input, Config.FlyDown *or* "Q") *then* FlySteer.Down *=* 1
            *end*
        *end*))
        
        AddConnection("FlyInputEnded", UserInputService.InputEnded\:Connect(*function*(input, gpe)
            *if* gpe *or* *not* FlyActive *then* *return* *end*
            *if* input.UserInputType *\~=* Enum.UserInputType.Keyboard *then* *return* *end*
            
            *local* keyCode *=* input.KeyCode
            
            *if* keyCode *==* Enum.KeyCode.W *then* FlySteer.Forward *=* 0
            *elseif* keyCode *==* Enum.KeyCode.A *then* FlySteer.Left *=* 0
            *elseif* keyCode *==* Enum.KeyCode.S *then* FlySteer.Back *=* 0
            *elseif* keyCode *==* Enum.KeyCode.D *then* FlySteer.Right *=* 0
            *elseif* KeyMatches(input, Config.FlyUp *or* "E") *then* FlySteer.Up *=* 0
            *elseif* KeyMatches(input, Config.FlyDown *or* "Q") *then* FlySteer.Down *=* 0
            *end*
        *end*))
        
        -- Flight loop
        AddConnection("FlyLoop", RunService.Heartbeat\:Connect(*function*()
            *if* *not* FlyActive *then* *return* *end*
            *local* \_, \_, r *=* GetCharacter()
            *if* *not* r *then* *return* *end*
            
            *local* camera *=* Workspace.CurrentCamera
            *if* *not* camera *then* *return* *end*
            
            *if* FlyBodyGyro *and* FlyBodyGyro.Parent *then*
                FlyBodyGyro.CFrame *=* camera.CFrame
            *end*
            
            *if* FlyBodyVelocity *and* FlyBodyVelocity.Parent *then*
                *local* speed *=* Config.FlySpeed *or* 200
                *local* direction *=* Vector3.new(0, 0, 0)
                
                direction *+=* camera.CFrame.LookVector *\** (FlySteer.Forward *-* FlySteer.Back)
                direction *+=* camera.CFrame.RightVector *\** (FlySteer.Right *-* FlySteer.Left)
                direction *+=* Vector3.new(0, FlySteer.Up *-* FlySteer.Down, 0)
                
                *if* direction.Magnitude *>* 0 *then*
                    direction *=* direction.Unit *\** speed
                *end*
                
                FlyBodyVelocity.Velocity *=* direction
            *end*
        *end*))
    *end*
    
    -- ============================================================
    -- UTILITY FUNCTIONS
    -- ============================================================
    
    -- FLASHLIGHT (FIXED: proper creation order)
    *local* *function* SetFlashlight(enabled)
        *local* char *=* GetCharacter()
        *if* *not* char *then* *return* *end*
        
        *local* head *=* char\:FindFirstChild("Head")
        *if* *not* head *then* *return* *end*
        
        *local* existing *=* head\:FindFirstChild("VanguardFlashlight")
        *if* existing *then* existing\:Destroy() *end*
        
        *if* *not* enabled *then* *return* *end*
        
        *local* light *=* TrackInstance(Instance.new("PointLight"))
        light.Name *=* "VanguardFlashlight"
        light.Range *=* 100
        light.Brightness *=* 2
        light.Parent *=* head
    *end*
    
    -- ANTI-AFK
    *local* *function* SetAntiAFK(enabled)
        RemoveConnection("AntiAFKIdle")
        
        *if* *not* enabled *then*
            *local* disabledConns *=* FeatureConnections.AntiAFKDisabled
            *if* disabledConns *then*
                *for* \_, conn *in* ipairs(disabledConns) *do*
                    pcall(*function*() conn\:Enable() *end*)
                *end*
                FeatureConnections.AntiAFKDisabled *=* nil
            *end*
            *return*
        *end*
        
        *local* disabled *=* false
        
        pcall(*function*()
            *local* idleConns *=* getconnections(LocalPlayer.Idled)
            *if* *#*idleConns *>* 0 *then*
                FeatureConnections.AntiAFKDisabled *=* {}
                *for* \_, conn *in* ipairs(idleConns) *do*
                    table.insert(FeatureConnections.AntiAFKDisabled, conn)
                    conn\:Disable()
                *end*
                disabled *=* true
            *end*
        *end*)
        
        *if* *not* disabled *then*
            AddConnection("AntiAFKIdle", LocalPlayer.Idled\:Connect(*function*()
                VirtualUser\:CaptureController()
                VirtualUser\:ClickButton2(Vector2.new())
            *end*))
        *end*
    *end*
    
    *local* *function* FindNearestSafeCFrame(origin)
        *local* params *=* RaycastParams.new()
        params.FilterType *=* Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances *=* Character *and* {Character} *or* {}
        params.IgnoreWater *=* true

        *local* bestResult, bestDistance
        *local* offsets *=* {
            Vector3.new(0, 0, 0),
            Vector3.new(8, 0, 0),
            Vector3.new(*-*8, 0, 0),
            Vector3.new(0, 0, 8),
            Vector3.new(0, 0, *-*8),
            Vector3.new(8, 0, 8),
            Vector3.new(*-*8, 0, 8),
            Vector3.new(8, 0, *-*8),
            Vector3.new(*-*8, 0, *-*8),
        }

        *for* \_, offset *in* ipairs(offsets) *do*
            *local* start *=* origin *+* offset *+* Vector3.new(0, 12, 0)
            *local* result *=* Workspace\:Raycast(start, Vector3.new(0, *-*300, 0), params)
            *local* part *=* result *and* result.Instance
            *if* part *and* part\:IsA("BasePart") *and* part.CanCollide *and* part.Transparency *<* 1 *and* part.Name *\~=* "Lava" *then*
                *local* distance *=* (result.Position *-* origin).Magnitude
                *if* *not* bestDistance *or* distance *<* bestDistance *then*
                    bestDistance *=* distance
                    bestResult *=* result
                *end*
            *end*
        *end*

        *if* bestResult *then*
            *return* CFrame.new(bestResult.Position *+* Vector3.new(0, 6, 0))
        *end*

        *return* nil
    *end*

    -- ANTI-VOID
    *local* *function* SetAntiVoid(enabled)
        RemoveConnection("AntiVoid")
        
        *if* *not* enabled *then* *return* *end*
        
        AddConnection("AntiVoid", RunService.Heartbeat\:Connect(*function*()
            *local* \_, \_, root *=* GetCharacter()
            *if* *not* root *then* *return* *end*
            
            *local* pos *=* root.Position
            
            *if* time() *-* LastSafeUpdate *>* 0.5 *then*
                LastSafeCFrame *=* FindNearestSafeCFrame(pos) *or* LastSafeCFrame
                LastSafeUpdate *=* time()
            *end*
            
            *if* *not* LastSafeCFrame *then*
                LastSafeCFrame *=* root.CFrame
            *end*
            
            *if* pos.Y *<* (Config.VoidHeight *or* *-*80) *then*
                SafeTeleport(LastSafeCFrame *+* Vector3.new(0, 10, 0))
            *end*
        *end*))
    *end*
    
    -- INVISIBLE
    *local* *function* SetInvisible(enabled)
        *local* char *=* GetCharacter()
        *if* *not* char *then* *return* *end*
        
        *if* *not* enabled *then*
            *for* obj, original *in* pairs(OriginalTransparency) *do*
                *if* obj *and* obj.Parent *then*
                    pcall(*function*() obj.Transparency *=* original *end*)
                *end*
            *end*
            OriginalTransparency *=* {}
            *return*
        *end*
        
        *for* \_, obj *in* ipairs(char\:GetDescendants()) *do*
            *if* (obj\:IsA("BasePart") *or* obj\:IsA("Decal") *or* obj\:IsA("Texture")) *and* obj.Name *\~=* "HumanoidRootPart" *then*
                *if* OriginalTransparency[obj] *==* nil *then*
                    OriginalTransparency[obj] *=* obj.Transparency
                *end*
                obj.Transparency *=* 0.5
            *end*
        *end*
    *end*
    
    -- ANTI-KNOCKBACK
    *local* *function* SetAntiKnockback(enabled)
        RemoveConnection("AntiKB")
        
        *if* *not* enabled *then*
            *for* part, original *in* pairs(OriginalPhysics) *do*
                *if* part *and* part.Parent *then*
                    pcall(*function*()
                        part.CustomPhysicalProperties *=* original.properties
                        part.Massless *=* original.massless
                    *end*)
                *end*
            *end*
            OriginalPhysics *=* {}
            *return*
        *end*
        
        *local* *function* ApplyAntiKB(part)
            *if* *not* part\:IsA("BasePart") *then* *return* *end*
            *if* OriginalPhysics[part] *==* nil *then*
                OriginalPhysics[part] *=* {
                    properties *=* part.CustomPhysicalProperties,
                    massless *=* part.Massless
                }
            *end*
            part.CustomPhysicalProperties *=* PhysicalProperties.new(100, 0.3, 0.5)
            part.Massless *=* false
        *end*
        
        *local* char *=* GetCharacter()
        *if* char *then*
            *for* \_, part *in* ipairs(char\:GetDescendants()) *do*
                ApplyAntiKB(part)
            *end*
            
            AddConnection("AntiKB", char.DescendantAdded\:Connect(*function*(part)
                ApplyAntiKB(part)
            *end*))
        *end*
    *end*
    
    -- HARD DRAGGER
    *local* *function* SetHardDragger(enabled)
        RemoveConnection("HardDragger")
        
        *for* \_, dragTask *in* ipairs(DraggerTasks) *do*
            dragTask.active *=* false
        *end*
        DraggerTasks *=* {}
        
        *if* *not* enabled *then* *return* *end*
        
        *local* *function* ApplyDragger(obj)
            *if* obj.Name *\~=* "Dragger" *then* *return* *end*
            
            *local* bodyGyro *=* obj\:WaitForChild("BodyGyro", 3)
            *local* bodyPosition *=* obj\:WaitForChild("BodyPosition", 3)
            
            *if* *not* bodyGyro *or* *not* bodyPosition *then* *return* *end*
            
            *local* originalBP *=* {P *=* bodyPosition.P, D *=* bodyPosition.D, maxForce *=* bodyPosition.maxForce}
            *local* originalBG *=* {maxTorque *=* bodyGyro.maxTorque, P *=* bodyGyro.P, D *=* bodyGyro.D}
            
            *local* dragTask *=* {active *=* true}
            table.insert(DraggerTasks, dragTask)
            
            task.spawn(*function*()
                *while* dragTask.active *and* obj *and* obj.Parent *and* Config.HardDragger *do*
                    pcall(*function*()
                        bodyPosition.P *=* 10000 *\** 8
                        bodyPosition.D *=* 1000
                        bodyPosition.maxForce *=* Vector3.new(1e6, 1e6, 1e6)
                        bodyGyro.maxTorque *=* Vector3.new(200, 200, 200)
                        bodyGyro.P *=* 1200
                        bodyGyro.D *=* 140
                    *end*)
                    task.wait(0.05)
                *end*
                
                *if* obj *and* obj.Parent *then*
                    pcall(*function*()
                        bodyPosition.P *=* originalBP.P
                        bodyPosition.D *=* originalBP.D
                        bodyPosition.maxForce *=* originalBP.maxForce
                        bodyGyro.maxTorque *=* originalBG.maxTorque
                        bodyGyro.P *=* originalBG.P
                        bodyGyro.D *=* originalBG.D
                    *end*)
                *end*
            *end*)
        *end*

        *for* \_, obj *in* ipairs(Workspace\:GetChildren()) *do*
            ApplyDragger(obj)
        *end*

        AddConnection("HardDragger", Workspace.ChildAdded\:Connect(*function*(obj)
            ApplyDragger(obj)
        *end*))
    *end*
    
    -- GOD MODE
    *local* *function* SetGodMode(enabled)
        RemoveConnection("GodModeLoop")

        *if* *not* enabled *then* *return* *end*

        *local* *function* ApplyGodMode()
            *local* \_, hum *=* GetCharacter()
            *if* hum *then*
                pcall(*function*()
                    hum.MaxHealth *=* math.max(hum.MaxHealth, 1e9)
                    hum.Health *=* hum.MaxHealth
                    *if* hum.BreakJointsOnDeath *\~=* nil *then*
                        hum.BreakJointsOnDeath *=* false
                    *end*
                *end*)
            *end*
        *end*

        ApplyGodMode()
        AddConnection("GodModeLoop", RunService.Heartbeat\:Connect(ApplyGodMode))
    *end*
    
    -- BTools
    *local* *function* CreateBTools()
        *local* backpack *=* LocalPlayer\:FindFirstChild("Backpack")
        *if* *not* backpack *then* *return* *end*
        
        *for* \_, toolName *in* ipairs({"VanguardDelete", "VanguardMove", "VanguardRotate", "VanguardResize", "VanguardUndo"}) *do*
            *local* existing *=* backpack\:FindFirstChild(toolName)
            *if* existing *then* existing\:Destroy() *end*
            *if* Character *then*
                *local* charExisting *=* Character\:FindFirstChild(toolName)
                *if* charExisting *then* charExisting\:Destroy() *end*
            *end*
        *end*
        
        *local* undoStack *=* {}

        *local* *function* PushUndo(part)
            table.insert(undoStack, {
                part *=* part,
                parent *=* part.Parent,
                cframe *=* part.CFrame,
                size *=* part.Size,
            })
        *end*

        *local* *function* CreateTool(name, callback)
            *local* tool *=* TrackInstance(Instance.new("Tool"))
            tool.Name *=* name
            tool.CanBeDropped *=* false
            tool.RequiresHandle *=* false
            tool.Parent *=* backpack

            TrackConnection(tool.Activated\:Connect(*function*()
                *local* target *=* LocalPlayer\:GetMouse().Target
                *if* *not* target *or* target\:IsDescendantOf(backpack) *or* *not* target\:IsA("BasePart") *then* *return* *end*
                callback(target)
            *end*))

            *return* tool
        *end*

        CreateTool("VanguardDelete", *function*(target)
            PushUndo(target)
            target.Parent *=* nil
        *end*)

        CreateTool("VanguardMove", *function*(target)
            PushUndo(target)
            target.CFrame *=* target.CFrame *+* Vector3.new(0, 4, 0)
        *end*)

        CreateTool("VanguardRotate", *function*(target)
            PushUndo(target)
            target.CFrame *=* target.CFrame *\** CFrame.Angles(0, math.rad(45), 0)
        *end*)

        CreateTool("VanguardResize", *function*(target)
            PushUndo(target)
            target.Size *=* target.Size *+* Vector3.new(1, 1, 1)
        *end*)

        *local* undoTool *=* TrackInstance(Instance.new("Tool"))
        undoTool.Name *=* "VanguardUndo"
        undoTool.CanBeDropped *=* false
        undoTool.RequiresHandle *=* false
        undoTool.Parent *=* backpack
        
        TrackConnection(undoTool.Activated\:Connect(*function*()
            *if* *#*undoStack *==* 0 *then* *return* *end*
            
            *local* snapshot *=* undoStack[*#*undoStack]
            *local* part *=* snapshot.part
            *if* part *then*
                part.Parent *=* snapshot.parent
                part.CFrame *=* snapshot.cframe
                part.Size *=* snapshot.size
            *end*
            
            table.remove(undoStack)
        *end*))
        
        Utils.Notify("BTools", "Ferramentas adicionadas!", 2)
    *end*
    
    -- SAFE DEATH
    *local* *function* SafeDeath()
        *local* \_, hum *=* GetCharacter()
        *if* *not* hum *then*
            Utils.Notify("Safe Death", "Personagem indisponível", 2)
            *return*
        *end*
        
        hum.Health *=* 0
    *end*
    
    -- ============================================================
    -- RESPAWN HANDLING
    -- ============================================================
    
    TrackConnection(LocalPlayer.CharacterAdded\:Connect(*function*(character)
        task.wait(0.5)
        RefreshCharacter(character)
        ApplyMovementValues()
        
        -- Handle death during fly
        *if* FlyActive *then*
            SetFly(false)
            task.wait(0.1)
            *if* Config.Flight *then*
                SetFly(true)
            *end*
        *end*
        
        *if* Config.Noclip *then*
            SetNoclip(true)
        *end*
        
        *if* Config.Flashlight *then*
            SetFlashlight(true)
        *end*
        
        *if* Config.Invisible *then*
            SetInvisible(true)
        *end*
        
        *if* Config.AntiKB *then*
            SetAntiKnockback(true)
        *end*
    *end*))
    
    -- ============================================================
    -- UI CREATION
    -- ============================================================
    
    *local* Tab *=* UI\:Tab(Utils.\_("player\_title"), "5012544693")
    
    *local* Movement *=* Tab\:Section(Utils.\_("player\_movement"), true)
    *local* CameraSection *=* Tab\:Section(Utils.\_("player\_camera"), false)
    *local* Utilities *=* Tab\:Section(Utils.\_("player\_utilities"), false)
    
    -- Setup controls (with RemoveConnection protection)
    SetupSprint()
    SetupFlyControls()
    
    -- Movement
    Movement\:Slider(Utils.\_("player\_walk"), "WalkSpeed", Config.WalkSpeed *or* 16, 16, 1000, false, *function*(v)
        Config.WalkSpeed *=* v
        ApplyMovementValues()
    *end*)
    
    Movement\:Slider(Utils.\_("player\_sprint"), "SprintSpeed", Config.SprintSpeed *or* 65, 16, 1000, false, *function*(v)
        Config.SprintSpeed *=* v
        ApplyMovementValues()
    *end*)
    
    Movement\:Toggle(Utils.\_("player\_sprint\_inf"), "SprintInf", Config.SprintInf *or* false, *function*(v)
        Config.SprintInf *=* v
    *end*)
    
    Movement\:Slider(Utils.\_("player\_jump"), "JumpPower", Config.JumpPower *or* 50, 50, 1000, false, *function*(v)
        Config.JumpPower *=* v
        ApplyMovementValues()
    *end*)
    
    Movement\:Slider(Utils.\_("player\_fly\_speed"), "FlySpeed", Config.FlySpeed *or* 200, 50, 800, false, *function*(v)
        Config.FlySpeed *=* v
    *end*)
    
    Movement\:Keybind(Utils.\_("player\_fly\_key"), "FlyKey", Config.FlyKey *or* "F", *function*(v)
        Config.FlyKey *=* v
    *end*)
    
    Movement\:Keybind(Utils.\_("player\_fly\_up"), "FlyUp", Config.FlyUp *or* "E", *function*(v)
        Config.FlyUp *=* v
    *end*)
    
    Movement\:Keybind(Utils.\_("player\_fly\_down"), "FlyDown", Config.FlyDown *or* "Q", *function*(v)
        Config.FlyDown *=* v
    *end*)
    
    Movement\:Keybind(Utils.\_("player\_noclip\_key"), "NoclipKey", Config.NoclipKey *or* "LeftControl", *function*(v)
        Config.NoclipKey *=* v
    *end*)
    
    NoclipToggleControl *=* Movement\:Toggle(Utils.\_("player\_noclip"), "Noclip", Config.Noclip *or* false, *function*(v)
        Config.Noclip *=* v
        SetNoclip(v)
    *end*)
    
    Movement\:Toggle(Utils.\_("player\_infinite\_jump"), "InfiniteJump", Config.InfiniteJump *or* false, *function*(v)
        Config.InfiniteJump *=* v
        SetInfiniteJump(v)
    *end*)
    
    Movement\:Toggle(Utils.\_("player\_flight"), "Flight", Config.Flight *or* false, *function*(v)
        FlightArmed *=* v
        Config.Flight *=* v
        *if* *not* v *then*
            SetFly(false)
        *end*
    *end*)
    
    Movement\:Toggle(Utils.\_("player\_invisible"), "Invisible", Config.Invisible *or* false, *function*(v)
        Config.Invisible *=* v
        SetInvisible(v)
    *end*)
    
    -- Camera
    *local* FOVSlider *=* CameraSection\:Slider(Utils.\_("player\_fov"), "FOV", Config.FOV *or* 70, 1, 120, false, *function*(v)
        *local* camera *=* Workspace.CurrentCamera
        *if* camera *then* camera.FieldOfView *=* v *end*
        Config.FOV *=* v
    *end*)
    
    *local* *function* ApplyZoom(v)
        LocalPlayer.CameraMode *=* Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance *=* math.min(LocalPlayer.CameraMinZoomDistance, v)
        LocalPlayer.CameraMaxZoomDistance *=* v
        Config.Zoom *=* v
    *end*

    CameraSection\:Slider(Utils.\_("player\_zoom"), "Zoom", Config.Zoom *or* 100, 100, 10000, false, ApplyZoom)
    ApplyZoom(Config.Zoom *or* 100)
    
    CameraSection\:Button(Utils.\_("player\_reset\_fov"), *function*()
        *local* camera *=* Workspace.CurrentCamera
        *if* camera *then* camera.FieldOfView *=* 70 *end*
        Config.FOV *=* 70
        FOVSlider\:SetValue(70)
        Utils.Notify("Camera", "FOV resetado!", 2)
    *end*)
    
    -- Utilities
    Utilities\:Toggle(Utils.\_("player\_flashlight"), "Flashlight", Config.Flashlight *or* false, *function*(v)
        Config.Flashlight *=* v
        SetFlashlight(v)
    *end*)
    
    Utilities\:Toggle(Utils.\_("player\_antiafk"), "AntiAFK", Config.AntiAFK *\~=* false, *function*(v)
        Config.AntiAFK *=* v
        SetAntiAFK(v)
    *end*)
    
    Utilities\:Toggle(Utils.\_("player\_godmode"), "GodMode", Config.GodMode *or* false, *function*(v)
        Config.GodMode *=* v
        SetGodMode(v)
    *end*)
    
    Utilities\:Toggle(Utils.\_("player\_antikb"), "AntiKB", Config.AntiKB *or* false, *function*(v)
        Config.AntiKB *=* v
        SetAntiKnockback(v)
    *end*)
    
    Utilities\:Toggle(Utils.\_("player\_antivoid"), "AntiVoid", Config.AntiVoid *or* false, *function*(v)
        Config.AntiVoid *=* v
        SetAntiVoid(v)
    *end*)
    
    Utilities\:Button(Utils.\_("player\_safe\_death"), SafeDeath)
    
    Utilities\:Button(Utils.\_("player\_btools"), CreateBTools)
    
    Utilities\:Toggle(Utils.\_("player\_hard\_dragger"), "HardDragger", Config.HardDragger *or* false, *function*(v)
        Config.HardDragger *=* v
        SetHardDragger(v)
        Utils.Notify("Hard Dragger", v *and* "Ativado!" *or* "Desativado!", 2)
    *end*)
    
*end*