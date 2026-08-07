local User = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local GuiService = game:GetService("StarterGui")
local mouse = game.Players.LocalPlayer:GetMouse()

local holdingWKey = false
local holdingSKey = false
local holdingAKey = false
local holdingDKey = false
local holdingSpaceKey = false
local holdingControlKey = false

Speed_1 = -1

mouse.KeyDown:connect(function(key)
   if key == "-" then
       Speed_1 = Speed_1 + 0.2
       GuiService:SetCore("SendNotification", {Title = "Speed", Text = "Speed has gone down";})
   end
end)

mouse.KeyDown:connect(function(key)
   if key == "=" then
       Speed_1 = Speed_1 - 0.2
       GuiService:SetCore("SendNotification", {Title = "Speed", Text = "Speed has gone up";})
   end
end)

mouse.KeyDown:connect(function(key)
   if key == "m" then
       if startup  == true then
           startup = false
           GuiService:SetCore("SendNotification", {Title = "Speed", Text = "Speed is now disabled";})
       else
           startup = true
           GuiService:SetCore("SendNotification", {Title = "Speed", Text = "Speed is now enabled";})
           
           local brick = Instance.new("Part", workspace)
           brick.Size = Vector3.new(3, 2, 3)
           brick.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, -4, 0)
           brick.Transparency = 1
           brick.Anchored = true
           brick.Name = "Brick"
           mouse.KeyDown:connect(function(key)
               if key == "m" then
                   brick:remove()
               end
           end)
           for i = 1, math.huge do
               brick.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, -4, 0)
               wait(0)
           end
       end
   end
end)

game:GetService('RunService').Stepped:connect(function()
   if startup then
       if WHeld == true then
         player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,Speed_1)

       end
   end
end)

game:GetService('RunService').Stepped:connect(function()
   if startup then
   if SHeld == true then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-Speed_1)
   end
   end
end)

game:GetService('RunService').Stepped:connect(function()
   if startup then
   if AHeld == true then
   player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(Speed_1,0,0)
   end
   end
end)


game:GetService('RunService').Stepped:connect(function()
   if startup then
   if DHeld == true then
   player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(-Speed_1,0,0)
   end
   end
end)


game:GetService('RunService').Stepped:connect(function()
   if startup then
   if SpaceHeld == true then
    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,-Speed_1,0)
   end
   end
end)

game:GetService('RunService').Stepped:connect(function()
   if startup then
    if ControlHeld == true then
    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,Speed_1,0)
       end
   end

end)

User.InputBegan:Connect(function(inputObject)
   if(inputObject.KeyCode==Enum.KeyCode.W) then
       holdingWKey = true WHeld = true
   end
   
   if(inputObject.KeyCode==Enum.KeyCode.S) then
       holdingSKey = true SHeld = true
   end

   if(inputObject.KeyCode==Enum.KeyCode.A) then
       holdingAKey = true AHeld = true
   end

   if(inputObject.KeyCode==Enum.KeyCode.D) then
       holdingDKey = true DHeld = true
   end
   if(inputObject.KeyCode==Enum.KeyCode.LeftControl) then
       holdingControlKey = true ControlHeld = true
   end

   if(inputObject.KeyCode==Enum.KeyCode.Space) then
       holdingSpaceKey = true SpaceHeld= true
   end

   if(inputObject.KeyCode==Enum.KeyCode.W) then
       holdingUKey = true WHeld = true
   end
end)

User.InputEnded:Connect(function(inputObject)
   if(inputObject.KeyCode==Enum.KeyCode.W) then
       holdingWKey = false WHeld = false
   end

   if(inputObject.KeyCode==Enum.KeyCode.S) then
       holdingSKey = false SHeld = false    
   end

   if(inputObject.KeyCode==Enum.KeyCode.A) then
       holdingAKey = false AHeld = false    
   end

   if(inputObject.KeyCode==Enum.KeyCode.D) then
       holdingDKey = false DHeld = false    
   end

   if(inputObject.KeyCode==Enum.KeyCode.LeftControl) then
       holdingShiftKey = false ControlHeld = false    
   end

   if(inputObject.KeyCode==Enum.KeyCode.Space) then
       holdingSpaceKey = false SpaceHeld = false
   end
end)
[Image: Untitled_design.png]

