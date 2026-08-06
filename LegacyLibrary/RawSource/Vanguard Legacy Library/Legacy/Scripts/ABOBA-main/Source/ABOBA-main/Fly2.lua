local ScreenGui = Instance.new("ScreenGui")


local Main = Instance.new("Frame")


local Title = Instance.new("TextLabel")


local Credits = Instance.new("TextLabel")


local Toggle = Instance.new("TextButton")


local UICorner = Instance.new("UICorner")


local Open = Instance.new("TextButton")


local UICorner_2 = Instance.new("UICorner")



ScreenGui.Parent = game.CoreGui


ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling



Main.Name = "Main"


Main.Parent = ScreenGui


Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)


Main.BorderSizePixel = 0


Main.Position = UDim2.new(0.32475248, 0, 0.386086941, 0)


Main.Size = UDim2.new(0, 352, 0, 130)


Main.Visible = false


Main.Active = true


Main.Draggable = true



Title.Name = "Title"


Title.Parent = Main


Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)


Title.BorderSizePixel = 0


Title.Size = UDim2.new(0, 352, 0, 18)


Title.Font = Enum.Font.GothamBold


Title.Text = "Rice FE Fly "


Title.TextColor3 = Color3.fromRGB(255, 255, 255)


Title.TextSize = 14.000


Title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)



Credits.Name = "Credits"


Credits.Parent = Main


Credits.BackgroundColor3 = Color3.fromRGB(35, 35, 35)


Credits.BorderSizePixel = 0


Credits.Position = UDim2.new(0, 0, 0.815384626, 0)


Credits.Size = UDim2.new(0, 352, 0, 24)


Credits.Font = Enum.Font.GothamBold


Credits.Text = "Made By Negr"


Credits.TextColor3 = Color3.fromRGB(255, 255, 255)


Credits.TextSize = 14.000


Credits.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)



Toggle.Name = "Toggle"


Toggle.Parent = Main


Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


Toggle.BorderSizePixel = 0


Toggle.Position = UDim2.new(0.0307211448, 0, 0.228294492, 0)


Toggle.Size = UDim2.new(0, 332, 0, 66)


Toggle.Font = Enum.Font.GothamBold


Toggle.Text = "Enable Fly Toggle | On/Off = E Key"


Toggle.TextColor3 = Color3.fromRGB(65, 255, 135)


Toggle.TextSize = 16.000


Toggle.MouseButton1Down:connect(function()


	repeat wait() 


	until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Head") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid") 


	local mouse = game.Players.LocalPlayer:GetMouse() 


	repeat wait() until mouse


	local plr = game.Players.LocalPlayer 


	local torso = plr.Character.Head 


	local flying = false


	local deb = true 


	local ctrl = {f = 0, b = 0, l = 0, r = 0} 


	local lastctrl = {f = 0, b = 0, l = 0, r = 0} 


	local maxspeed = 50 


	local speed = 0 



	function Fly() 


		local bg = Instance.new("BodyGyro", torso) 


		bg.P = 9e4 


		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) 


		bg.cframe = torso.CFrame 


		local bv = Instance.new("BodyVelocity", torso) 


		bv.velocity = Vector3.new(0,0.1,0) 


		bv.maxForce = Vector3.new(9e9, 9e9, 9e9) 


		repeat wait() 


			plr.Character.Humanoid.PlatformStand = true 


			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then 


				speed = speed+.5+(speed/maxspeed) 


				if speed > maxspeed then 


					speed = maxspeed 


				end 


			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then 


				speed = speed-1 


				if speed < 0 then 


					speed = 0 


				end 


			end 


			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then 


				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed 


				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r} 


			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then 


				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed 


			else 


				bv.velocity = Vector3.new(0,0.1,0) 


			end 


			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0) 


		until not flying 


		ctrl = {f = 0, b = 0, l = 0, r = 0} 


		lastctrl = {f = 0, b = 0, l = 0, r = 0} 


		speed = 0 


		bg:Destroy() 


		bv:Destroy() 


		plr.Character.Humanoid.PlatformStand = false 


	end 


	mouse.KeyDown:connect(function(key) 


		if key:lower() == "e" then 


			if flying then flying = false 


			else 


				flying = true 


				Fly() 


			end 


		elseif key:lower() == "w" then 


			ctrl.f = 1 


		elseif key:lower() == "s" then 


			ctrl.b = -1 


		elseif key:lower() == "a" then 


			ctrl.l = -1 


		elseif key:lower() == "d" then 


			ctrl.r = 1 


		end 


	end) 


	mouse.KeyUp:connect(function(key) 


		if key:lower() == "w" then 


			ctrl.f = 0 


		elseif key:lower() == "s" then 


			ctrl.b = 0 


		elseif key:lower() == "a" then 


			ctrl.l = 0 


		elseif key:lower() == "d" then 


			ctrl.r = 0 


		end 


	end)


	Fly()


end)



UICorner.Parent = Toggle



Open.Name = "Open"


Open.Parent = ScreenGui


Open.BackgroundColor3 = Color3.fromRGB(45, 45, 45)


Open.Position = UDim2.new(0.387128711, 0, 0.933912992, 0)


Open.Size = UDim2.new(0, 227, 0, 31)


Open.Font = Enum.Font.GothamBold


Open.Text = "Open/Close"


Open.TextColor3 = Color3.fromRGB(255, 255, 255)


Open.TextSize = 14.000



UICorner_2.Parent = Open



-- Scripts:



local function KPCZX_fake_script() -- Open.LocalScript 


	local script = Instance.new('LocalScript', Open)



	local frame = script.Parent.Parent.Main


	


	script.Parent.MouseButton1Click:Connect(function()


		frame.Visible = not frame.Visible


	end)


	


end


coroutine.wrap(KPCZX_fake_script)()


