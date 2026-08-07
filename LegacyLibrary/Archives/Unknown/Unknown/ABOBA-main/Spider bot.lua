wait()
c3 = {}
function c3.new(r,g,b)
	return Color3.new(r/255,g/255,b/255)
end

primary = c3.new(0,0,0)
secondary = c3.new(255,0,0)


local player = game.Players.LocalPlayer
repeat wait() until player.Character
char = player.Character

basesound = Instance.new("Sound")
basepart = Instance.new("Part")
baseexplosion = Instance.new("Explosion")

spawn(function()
	while wait() do
		if not basesound then
			print'basesound nil'
			basesound = Instance.new("Sound")
		end
		if not baseexplosion then
			baseexplosion = Instance.new("Explosion")
		end
		if not basepart then
			basepart = Instance.new("Part")
		end
	end
end)
CreateInstance = function()
	cors = {}
	mas = Instance.new("Model",game:GetService("Lighting"))
	Model0 = Instance.new("Model")
	Model1 = Instance.new("Model")
	Part2 = Instance.new("Part")
	Part3 = Instance.new("Part")
	Motor6D4 = Instance.new("Motor6D")
	Motor6D5 = Instance.new("Motor6D")
	Part6 = Instance.new("Part")
	Motor6D7 = Instance.new("Motor6D")
	Part8 = Instance.new("Part")
	Motor6D9 = Instance.new("Motor6D")
	Model10 = Instance.new("Model")
	Part11 = Instance.new("Part")
	Part12 = Instance.new("Part")
	Motor6D13 = Instance.new("Motor6D")
	Motor6D14 = Instance.new("Motor6D")
	Part15 = Instance.new("Part")
	Motor6D16 = Instance.new("Motor6D")
	Part17 = Instance.new("Part")
	Motor6D18 = Instance.new("Motor6D")
	Model19 = Instance.new("Model")
	Part20 = Instance.new("Part")
	Part21 = Instance.new("Part")
	Motor6D22 = Instance.new("Motor6D")
	Motor6D23 = Instance.new("Motor6D")
	Part24 = Instance.new("Part")
	Motor6D25 = Instance.new("Motor6D")
	Part26 = Instance.new("Part")
	Motor6D27 = Instance.new("Motor6D")
	Model28 = Instance.new("Model")
	Part29 = Instance.new("Part")
	Part30 = Instance.new("Part")
	Motor6D31 = Instance.new("Motor6D")
	Motor6D32 = Instance.new("Motor6D")
	Part33 = Instance.new("Part")
	Motor6D34 = Instance.new("Motor6D")
	Part35 = Instance.new("Part")
	Motor6D36 = Instance.new("Motor6D")
	Part37 = Instance.new("Part")
	Motor6D38 = Instance.new("Motor6D")
	Model0.Name = "Bot"
	Model0.Parent = mas
	Model1.Name = "LeftLowerLeg"
	Model1.Parent = Model0
	Part2.Name = "Leg"
	Part2.Parent = Model1
	Part2.Material = Enum.Material.Metal
	Part2.BrickColor = BrickColor.new("Really black")
	Part2.Rotation = Vector3.new(0, 45, -111.299995)
	Part2.CanCollide = false
	Part2.Size = Vector3.new(6, 1, 1)
	Part2.CFrame = CFrame.new(32.2574959, 2.97668099, 10.4622593, -0.2568883, 0.65879637, 0.707109034, -0.931675911, -0.363295883, 2.88365015e-07, 0.256890744, -0.65879631, 0.707109392)
	Part2.BottomSurface = Enum.SurfaceType.Smooth
	Part2.TopSurface = Enum.SurfaceType.Smooth
	Part2.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part2.Position = Vector3.new(32.2574959, 2.97668099, 10.4622593)
	Part2.Orientation = Vector3.new(0, 45, -111.299995)
	Part2.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part3.Name = "Base"
	Part3.Parent = Model1
	Part3.Material = Enum.Material.Neon
	Part3.BrickColor = BrickColor.new("Really red")
	Part3.Transparency = 1
	Part3.Rotation = Vector3.new(0, 45, -21.2999992)
	Part3.CanCollide = false
	Part3.Shape = Enum.PartType.Ball
	Part3.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part3.CFrame = CFrame.new(36.3001213, 3.82847285, 6.41962528, 0.65879637, 0.2568883, 0.707109034, -0.363295883, 0.931675911, 2.88365015e-07, -0.65879631, -0.256890744, 0.707109392)
	Part3.BottomSurface = Enum.SurfaceType.Smooth
	Part3.TopSurface = Enum.SurfaceType.Smooth
	Part3.Color = Color3.new(1, 0, 0)
	Part3.Position = Vector3.new(36.3001213, 3.82847285, 6.41962528)
	Part3.Orientation = Vector3.new(0, 45, -21.2999992)
	Part3.Color = Color3.new(1, 0, 0)
	Motor6D4.Name = "Joint"
	Motor6D4.Parent = Part3
	Motor6D4.C0 = CFrame.new(-5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D4.C1 = CFrame.new(-2.49999809, 1.43051147e-06, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D4.Part0 = Part3
	Motor6D4.Part1 = Part6
	Motor6D5.Parent = Part3
	Motor6D5.C1 = CFrame.new(-1.19987869, -0.671523809, 0.419622421, 0.658794224, 0.256887913, 0.707107604, -0.363295287, 0.931674659, 7.94126493e-07, -0.658793986, -0.256889552, 0.707107425)
	Motor6D5.Part0 = Part3
	Motor6D5.Part1 = Part37
	Part6.Name = "Leg"
	Part6.Parent = Model1
	Part6.Material = Enum.Material.Metal
	Part6.BrickColor = BrickColor.new("Really black")
	Part6.Rotation = Vector3.new(0, 45, -21.2999992)
	Part6.CanCollide = false
	Part6.Size = Vector3.new(5, 1, 1)
	Part6.CFrame = CFrame.new(34.6531296, 4.73671198, 8.06661797, 0.65879637, 0.2568883, 0.707109034, -0.363295883, 0.931675911, 2.88365015e-07, -0.65879631, -0.256890744, 0.707109392)
	Part6.BottomSurface = Enum.SurfaceType.Smooth
	Part6.TopSurface = Enum.SurfaceType.Smooth
	Part6.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part6.Position = Vector3.new(34.6531296, 4.73671198, 8.06661797)
	Part6.Orientation = Vector3.new(0, 45, -21.2999992)
	Part6.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Motor6D7.Parent = Part6
	Motor6D7.C0 = CFrame.new(2.5999999, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D7.C1 = CFrame.new(5.10000038, -2.38418579e-07, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D7.Part0 = Part6
	Motor6D7.Part1 = Part8
	Part8.Name = "Knee"
	Part8.Parent = Model1
	Part8.Material = Enum.Material.Neon
	Part8.BrickColor = BrickColor.new("Really red")
	Part8.Rotation = Vector3.new(0, 45, -21.2999992)
	Part8.CanCollide = false
	Part8.Shape = Enum.PartType.Ball
	Part8.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part8.CFrame = CFrame.new(33.0061378, 5.6449523, 9.71360874, 0.65879637, 0.2568883, 0.707109034, -0.363295883, 0.931675911, 2.88365015e-07, -0.65879631, -0.256890744, 0.707109392)
	Part8.BottomSurface = Enum.SurfaceType.Smooth
	Part8.TopSurface = Enum.SurfaceType.Smooth
	Part8.Color = Color3.new(1, 0, 0)
	Part8.Position = Vector3.new(33.0061378, 5.6449523, 9.71360874)
	Part8.Orientation = Vector3.new(0, 45, -21.2999992)
	Part8.Color = Color3.new(1, 0, 0)
	Motor6D9.Name = "Joint"
	Motor6D9.Parent = Part8
	Motor6D9.C1 = CFrame.new(-2.87059045, 0.0170345306, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)
	Motor6D9.Part0 = Part8
	Motor6D9.Part1 = Part2
	Model10.Name = "RightLowerLeg"
	Model10.Parent = Model0
	Part11.Name = "Leg"
	Part11.Parent = Model10
	Part11.Material = Enum.Material.Metal
	Part11.BrickColor = BrickColor.new("Really black")
	Part11.Rotation = Vector3.new(-180, 45, 68.6999969)
	Part11.CanCollide = false
	Part11.Size = Vector3.new(6, 1, 1)
	Part11.CFrame = CFrame.new(42.8043213, 2.97667575, 10.493145, 0.256888568, -0.658794105, 0.707109451, -0.93167609, -0.363294035, 1.54012838e-07, 0.256888628, -0.658795714, -0.707108974)
	Part11.BottomSurface = Enum.SurfaceType.Smooth
	Part11.TopSurface = Enum.SurfaceType.Smooth
	Part11.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part11.Position = Vector3.new(42.8043213, 2.97667575, 10.493145)
	Part11.Orientation = Vector3.new(0, 135, -111.299995)
	Part11.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part12.Name = "Base"
	Part12.Parent = Model10
	Part12.Material = Enum.Material.Neon
	Part12.BrickColor = BrickColor.new("Really red")
	Part12.Transparency = 1
	Part12.Rotation = Vector3.new(-180, 45, 158.699997)
	Part12.CanCollide = false
	Part12.Shape = Enum.PartType.Ball
	Part12.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part12.CFrame = CFrame.new(38.7617035, 3.82847738, 6.45052004, -0.658794105, -0.256888568, 0.707109451, -0.363294035, 0.93167609, 1.54012838e-07, -0.658795714, -0.256888628, -0.707108974)
	Part12.BottomSurface = Enum.SurfaceType.Smooth
	Part12.TopSurface = Enum.SurfaceType.Smooth
	Part12.Color = Color3.new(1, 0, 0)
	Part12.Position = Vector3.new(38.7617035, 3.82847738, 6.45052004)
	Part12.Orientation = Vector3.new(0, 135, -21.2999992)
	Part12.Color = Color3.new(1, 0, 0)
	Motor6D13.Name = "Joint"
	Motor6D13.Parent = Part12
	Motor6D13.C0 = CFrame.new(-5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D13.C1 = CFrame.new(-2.49999809, 1.43051147e-06, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D13.Part0 = Part12
	Motor6D13.Part1 = Part15
	Motor6D14.Parent = Part12
	Motor6D14.C1 = CFrame.new(1.26169586, -0.671518087, 0.450518131, -0.658792913, -0.256887645, 0.707107306, -0.363293976, 0.9316746, 2.46838681e-07, -0.658793926, -0.256887645, -0.707106411)
	Motor6D14.Part0 = Part12
	Motor6D14.Part1 = Part37
	Part15.Name = "Leg"
	Part15.Parent = Model10
	Part15.Material = Enum.Material.Metal
	Part15.BrickColor = BrickColor.new("Really black")
	Part15.Rotation = Vector3.new(-180, 45, 158.699997)
	Part15.CanCollide = false
	Part15.Size = Vector3.new(5, 1, 1)
	Part15.CFrame = CFrame.new(40.4086914, 4.73671198, 8.09751129, -0.658794105, -0.256888568, 0.707109451, -0.363294035, 0.93167609, 1.54012838e-07, -0.658795714, -0.256888628, -0.707108974)
	Part15.BottomSurface = Enum.SurfaceType.Smooth
	Part15.TopSurface = Enum.SurfaceType.Smooth
	Part15.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part15.Position = Vector3.new(40.4086914, 4.73671198, 8.09751129)
	Part15.Orientation = Vector3.new(0, 135, -21.2999992)
	Part15.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Motor6D16.Parent = Part15
	Motor6D16.C0 = CFrame.new(2.5999999, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D16.C1 = CFrame.new(5.10000038, -2.38418579e-07, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D16.Part0 = Part15
	Motor6D16.Part1 = Part17
	Part17.Name = "Knee"
	Part17.Parent = Model10
	Part17.Material = Enum.Material.Neon
	Part17.BrickColor = BrickColor.new("Really red")
	Part17.Rotation = Vector3.new(-180, 45, 158.699997)
	Part17.CanCollide = false
	Part17.Shape = Enum.PartType.Ball
	Part17.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part17.CFrame = CFrame.new(42.0556755, 5.64494753, 9.74450111, -0.658794105, -0.256888568, 0.707109451, -0.363294035, 0.93167609, 1.54012838e-07, -0.658795714, -0.256888628, -0.707108974)
	Part17.BottomSurface = Enum.SurfaceType.Smooth
	Part17.TopSurface = Enum.SurfaceType.Smooth
	Part17.Color = Color3.new(1, 0, 0)
	Part17.Position = Vector3.new(42.0556755, 5.64494753, 9.74450111)
	Part17.Orientation = Vector3.new(0, 135, -21.2999992)
	Part17.Color = Color3.new(1, 0, 0)
	Motor6D18.Name = "Joint"
	Motor6D18.Parent = Part17
	Motor6D18.C1 = CFrame.new(-2.87059045, 0.0170345306, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)
	Motor6D18.Part0 = Part17
	Motor6D18.Part1 = Part11
	Model19.Name = "RightUpperLeg"
	Model19.Parent = Model0
	Part20.Name = "Leg"
	Part20.Parent = Model19
	Part20.Material = Enum.Material.Metal
	Part20.BrickColor = BrickColor.new("Really black")
	Part20.Rotation = Vector3.new(-180, -45, 68.6999969)
	Part20.CanCollide = false
	Part20.Size = Vector3.new(6, 1, 1)
	Part20.CFrame = CFrame.new(42.8043251, 2.97667956, 1.56864583, 0.256889135, -0.658794999, -0.707108319, -0.931675553, -0.363295496, 1.16880165e-06, -0.256889671, 0.658795893, -0.707108676)
	Part20.BottomSurface = Enum.SurfaceType.Smooth
	Part20.TopSurface = Enum.SurfaceType.Smooth
	Part20.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part20.Position = Vector3.new(42.8043251, 2.97667956, 1.56864583)
	Part20.Orientation = Vector3.new(0, -135, -111.299995)
	Part20.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part21.Name = "Base"
	Part21.Parent = Model19
	Part21.Material = Enum.Material.Neon
	Part21.BrickColor = BrickColor.new("Really red")
	Part21.Transparency = 1
	Part21.Rotation = Vector3.new(-180, -45, 158.699997)
	Part21.CanCollide = false
	Part21.Shape = Enum.PartType.Ball
	Part21.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part21.CFrame = CFrame.new(38.7617035, 3.82847285, 5.61127424, -0.658794999, -0.256889135, -0.707108319, -0.363295496, 0.931675553, 1.16880165e-06, 0.658795893, 0.256889671, -0.707108676)
	Part21.BottomSurface = Enum.SurfaceType.Smooth
	Part21.TopSurface = Enum.SurfaceType.Smooth
	Part21.Color = Color3.new(1, 0, 0)
	Part21.Position = Vector3.new(38.7617035, 3.82847285, 5.61127424)
	Part21.Orientation = Vector3.new(0, -135, -21.2999992)
	Part21.Color = Color3.new(1, 0, 0)
	Motor6D22.Name = "Joint"
	Motor6D22.Parent = Part21
	Motor6D22.C0 = CFrame.new(-5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D22.C1 = CFrame.new(-2.49999809, 1.43051147e-06, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D22.Part0 = Part21
	Motor6D22.Part1 = Part24
	Motor6D23.Parent = Part21
	Motor6D23.C1 = CFrame.new(1.26169586, -0.671522856, -0.388725281, -0.658793211, -0.256887972, -0.707106888, -0.363295078, 0.931674182, 6.63038577e-07, 0.65879339, 0.256888986, -0.707106709)
	Motor6D23.Part0 = Part21
	Motor6D23.Part1 = Part37
	Part24.Name = "Leg"
	Part24.Parent = Model19
	Part24.Material = Enum.Material.Metal
	Part24.BrickColor = BrickColor.new("Really black")
	Part24.Rotation = Vector3.new(-180, -45, 158.699997)
	Part24.CanCollide = false
	Part24.Size = Vector3.new(5, 1, 1)
	Part24.CFrame = CFrame.new(40.4086914, 4.73671103, 3.96428299, -0.658794999, -0.256889135, -0.707108319, -0.363295496, 0.931675553, 1.16880165e-06, 0.658795893, 0.256889671, -0.707108676)
	Part24.BottomSurface = Enum.SurfaceType.Smooth
	Part24.TopSurface = Enum.SurfaceType.Smooth
	Part24.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part24.Position = Vector3.new(40.4086914, 4.73671103, 3.96428299)
	Part24.Orientation = Vector3.new(0, -135, -21.2999992)
	Part24.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Motor6D25.Parent = Part24
	Motor6D25.C0 = CFrame.new(2.5999999, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D25.C1 = CFrame.new(5.10000038, -2.38418579e-07, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D25.Part0 = Part24
	Motor6D25.Part1 = Part26
	Part26.Name = "Knee"
	Part26.Parent = Model19
	Part26.Material = Enum.Material.Neon
	Part26.BrickColor = BrickColor.new("Really red")
	Part26.Rotation = Vector3.new(-180, -45, 158.699997)
	Part26.CanCollide = false
	Part26.Shape = Enum.PartType.Ball
	Part26.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part26.CFrame = CFrame.new(42.0556793, 5.64494991, 2.31729317, -0.658794999, -0.256889135, -0.707108319, -0.363295496, 0.931675553, 1.16880165e-06, 0.658795893, 0.256889671, -0.707108676)
	Part26.BottomSurface = Enum.SurfaceType.Smooth
	Part26.TopSurface = Enum.SurfaceType.Smooth
	Part26.Color = Color3.new(1, 0, 0)
	Part26.Position = Vector3.new(42.0556793, 5.64494991, 2.31729317)
	Part26.Orientation = Vector3.new(0, -135, -21.2999992)
	Part26.Color = Color3.new(1, 0, 0)
	Motor6D27.Name = "Joint"
	Motor6D27.Parent = Part26
	Motor6D27.C1 = CFrame.new(-2.87059045, 0.0170345306, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)
	Motor6D27.Part0 = Part26
	Motor6D27.Part1 = Part20
	Model28.Name = "LeftUpperLeg"
	Model28.Parent = Model0
	Part29.Name = "Leg"
	Part29.Parent = Model28
	Part29.Material = Enum.Material.Metal
	Part29.BrickColor = BrickColor.new("Really black")
	Part29.Rotation = Vector3.new(0, -45, -111.299995)
	Part29.CanCollide = false
	Part29.Size = Vector3.new(6, 1, 1)
	Part29.CFrame = CFrame.new(32.2575073, 2.97668052, 1.53776193, -0.256887734, 0.658793867, -0.70710808, -0.931674898, -0.363295287, -5.81522841e-07, -0.256888896, 0.658794224, 0.707108021)
	Part29.BottomSurface = Enum.SurfaceType.Smooth
	Part29.TopSurface = Enum.SurfaceType.Smooth
	Part29.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part29.Position = Vector3.new(32.2575073, 2.97668052, 1.53776193)
	Part29.Orientation = Vector3.new(0, -45, -111.299995)
	Part29.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part30.Name = "Base"
	Part30.Parent = Model28
	Part30.Material = Enum.Material.Neon
	Part30.BrickColor = BrickColor.new("Really red")
	Part30.Transparency = 1
	Part30.Rotation = Vector3.new(0, -45, -21.2999992)
	Part30.CanCollide = false
	Part30.Shape = Enum.PartType.Ball
	Part30.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part30.CFrame = CFrame.new(36.3001213, 3.82847309, 5.58037996, 0.658793867, 0.256887734, -0.70710808, -0.363295287, 0.931674898, -5.81522841e-07, 0.658794224, 0.256888896, 0.707108021)
	Part30.BottomSurface = Enum.SurfaceType.Smooth
	Part30.TopSurface = Enum.SurfaceType.Smooth
	Part30.Color = Color3.new(1, 0, 0)
	Part30.Position = Vector3.new(36.3001213, 3.82847309, 5.58037996)
	Part30.Orientation = Vector3.new(0, -45, -21.2999992)
	Part30.Color = Color3.new(1, 0, 0)
	Motor6D31.Name = "Joint"
	Motor6D31.Parent = Part30
	Motor6D31.C0 = CFrame.new(-5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D31.C1 = CFrame.new(-2.49999809, 1.43051147e-06, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D31.Part0 = Part30
	Motor6D31.Part1 = Part33
	Motor6D32.Parent = Part30
	Motor6D32.C1 = CFrame.new(-1.19987869, -0.671523809, -0.419620514, 0.658793986, 0.256887794, -0.707107961, -0.363295197, 0.931674778, -5.81522897e-07, 0.658794165, 0.256888896, 0.707107723)
	Motor6D32.Part0 = Part30
	Motor6D32.Part1 = Part37
	Part33.Name = "Leg"
	Part33.Parent = Model28
	Part33.Material = Enum.Material.Metal
	Part33.BrickColor = BrickColor.new("Really black")
	Part33.Rotation = Vector3.new(0, -45, -21.2999992)
	Part33.CanCollide = false
	Part33.Size = Vector3.new(5, 1, 1)
	Part33.CFrame = CFrame.new(34.6531334, 4.73671055, 3.93339276, 0.658793867, 0.256887734, -0.70710808, -0.363295287, 0.931674898, -5.81522841e-07, 0.658794224, 0.256888896, 0.707108021)
	Part33.BottomSurface = Enum.SurfaceType.Smooth
	Part33.TopSurface = Enum.SurfaceType.Smooth
	Part33.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Part33.Position = Vector3.new(34.6531334, 4.73671055, 3.93339276)
	Part33.Orientation = Vector3.new(0, -45, -21.2999992)
	Part33.Color = Color3.new(0.0666667, 0.0666667, 0.0666667)
	Motor6D34.Parent = Part33
	Motor6D34.C0 = CFrame.new(2.5999999, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D34.C1 = CFrame.new(5.10000038, -2.38418579e-07, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	Motor6D34.Part0 = Part33
	Motor6D34.Part1 = Part35
	Part35.Name = "Knee"
	Part35.Parent = Model28
	Part35.Material = Enum.Material.Neon
	Part35.BrickColor = BrickColor.new("Really red")
	Part35.Rotation = Vector3.new(0, -45, -21.2999992)
	Part35.CanCollide = false
	Part35.Shape = Enum.PartType.Ball
	Part35.Size = Vector3.new(1.10000002, 1.10000002, 1.10000002)
	Part35.CFrame = CFrame.new(33.0061493, 5.64494896, 2.28640699, 0.658793867, 0.256887734, -0.70710808, -0.363295287, 0.931674898, -5.81522841e-07, 0.658794224, 0.256888896, 0.707108021)
	Part35.BottomSurface = Enum.SurfaceType.Smooth
	Part35.TopSurface = Enum.SurfaceType.Smooth
	Part35.Color = Color3.new(1, 0, 0)
	Part35.Position = Vector3.new(33.0061493, 5.64494896, 2.28640699)
	Part35.Orientation = Vector3.new(0, -45, -21.2999992)
	Part35.Color = Color3.new(1, 0, 0)
	Motor6D36.Name = "Joint"
	Motor6D36.Parent = Part35
	Motor6D36.C1 = CFrame.new(-2.87059045, 0.0170345306, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)
	Motor6D36.Part0 = Part35
	Motor6D36.Part1 = Part29
	Part37.Name = "FakeTorso"
	Part37.Parent = Model0
	Part37.Transparency = 1
	Part37.Size = Vector3.new(2, 2, 1)
	Part37.CFrame = CFrame.new(37.5000038, 4.49999714, 6.00000095, 1.0000025, -4.23265476e-07, -4.76837158e-07, -4.2326559e-07, 1.00000143, -2.91990006e-07, -4.17232513e-07, -2.77089043e-07, 1.00000322)
	Part37.BottomSurface = Enum.SurfaceType.Smooth
	Part37.TopSurface = Enum.SurfaceType.Smooth
	Part37.Position = Vector3.new(37.5000038, 4.49999714, 6.00000095)
	Motor6D38.Name = "Motor"
	Motor6D38.Parent = Part37
	Motor6D38.Part0 = Part37
	for i,v in pairs(mas:GetChildren()) do
		v.Parent = workspace
		pcall(function() v:MakeJoints() end)
	end
	mas:Destroy()
	for i,v in pairs(cors) do
		spawn(function()
			pcall(v)
		end)
	end
	return Model0
end

local spiderbot = CreateInstance()
spiderbot.Parent = char

for i,v in pairs (spiderbot:GetDescendants()) do
	if v:IsA("BasePart") then
		v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
	end
end

for i,v in pairs (char:GetDescendants()) do
	if v:IsA("Sound") then
		v.Volume = 0
	end
end

for i,v in pairs (spiderbot:GetDescendants()) do
	if v:IsA("BasePart") then
		if v.BrickColor == BrickColor.new("Really black") then
			v.Color = primary
		else
			v.Color = secondary
		end
	end
end

function tween(object,style,direction,t,goal)
	local tweenservice = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(t,Enum.EasingStyle[style],Enum.EasingDirection[direction])
	local tween = tweenservice:Create(object,tweenInfo,goal)
	tween:Play()
	return tween
end

local char = player.Character
torso = char.Torso
head = char.Head
hrp = char.HumanoidRootPart
hum = char.Humanoid
hum.WalkSpeed = 20
s = 0
rstep = game:GetService("RunService").RenderStepped

if char:FindFirstChild("Animate") then
	char.Animate:Destroy()
end
for i,v in pairs (hum:GetPlayingAnimationTracks()) do
	v:Stop()
end

local rl = torso['Right Hip']
local ll = torso['Left Hip']
local rs = torso['Right Shoulder']
local ls = torso['Left Shoulder']
local neck = torso.Neck
local rs0 = rs.C0
local ls0 = ls.C0
local rl0 = rl.C0
local ll0 = ll.C0
local n0 = neck.C0

function newSound(id,extrasettings)
	local soundy = basesound:Clone()
	if not soundy then soundy = Instance.new("Sound") end
	soundy.Parent = hrp
	soundy.Volume = 1
	soundy.SoundId = id
	if extrasettings then
		for i=1,#extrasettings do
			local sets = extrasettings[i]:gmatch("[%w%.]+")
			local set = {}
			for v in (sets) do
				table.insert(set,v)
			end
			
			soundy[set[1]] = set[2]
		end
	end
	soundy.Playing = true
	game.Debris:AddItem(soundy,5)
	return soundy
end

function woosh()
	local wooshes = {'rbxassetid://541909867','rbxassetid://541909814'}
	return newSound(wooshes[math.random(1,#wooshes)],{
		[1] = "PlaybackSpeed, "..tostring(1+math.random(-200,200)/1000);
		[2] = "Volume, 1";
		[3] = "PlaybackSpeed, 0.9";
	})
end

function hardhit()
	local wooshes = {'rbxassetid://565207203','rbxassetid://541909983','rbxassetid://541909913'}
	newSound(wooshes[math.random(1,#wooshes)],{
		[1] = "PlaybackSpeed, "..tostring(1+math.random(-100,100)/1000);
		[2] = "Volume, 2";
	})
end

function explosion()
	local wooshes = {'rbxassetid://262562442','rbxassetid://919941001','rbxassetid://539294959'}
	newSound(wooshes[math.random(1,#wooshes)],{
		[1] = "PlaybackSpeed, "..tostring(1+math.random(-100,100)/1000);
		[2] = "Volume, 2";
	})
end

function hit()
	local hitsounds = {"rbxassetid://220025741",
		"rbxassetid://220025689",
		"rbxassetid://220025689"
	}
	return newSound(hitsounds[math.random(1,#hitsounds)],{
		[1] = "PlaybackSpeed, "..tostring(1+math.random(-200,200)/1000);
		[2] = "Volume, 0.5";
	})
end

local csine = 0
rstep:connect(function()
	if not flying then
		csine = csine + 0.025
		local csin = math.sin(csine)
		rl.C0 = rl.C0:lerp(rl0 * CFrame.Angles(csin/25 + math.rad(-2),0,0), 0.2)
		ll.C0 = ll.C0:lerp(ll0 * CFrame.Angles(csin/25 + math.rad(-2),0,0), 0.2)
		rs.C0 = rs.C0:lerp(rs0 * CFrame.Angles(-csin/15 + math.rad(-6),0,0), 0.2)
		ls.C0 = ls.C0:lerp(ls0 * CFrame.Angles(-csin/15 + math.rad(-6),0,0), 0.2)
		neck.C0 = neck.C0:lerp(n0 * CFrame.Angles(csin/15 + math.rad(15),0,0), 0.2)
	else
		csine = csine + 0.025
		local csin = math.sin(csine)
		rl.C0 = rl.C0:lerp(rl0 * CFrame.Angles(csin/25 + math.rad(-2),0,0), 0.2)
		ll.C0 = ll.C0:lerp(ll0 * CFrame.Angles(csin/25 + math.rad(-2),0,0), 0.2)
		rs.C0 = rs.C0:lerp(rs0 * CFrame.Angles(-csin/10 + math.rad(-90),0,0) * CFrame.new(0,-0.5,-0.5), 0.2)
		ls.C0 = ls.C0:lerp(ls0 * CFrame.Angles(-csin/10 + math.rad(-90),0,0) * CFrame.new(0,-0.5,-0.5), 0.2)
		neck.C0 = neck.C0:lerp(n0 * CFrame.Angles(csin/15 + math.rad(5),0,0), 0.2)
	end
end)

hum.HipHeight = 1.25

center = spiderbot.FakeTorso
cmotor = center.Motor
cmotor.Part1 = torso

LLL = spiderbot.LeftLowerLeg
LUL = spiderbot.LeftUpperLeg
RLL = spiderbot.RightLowerLeg
RUL = spiderbot.RightUpperLeg

lll = LLL.Base.Motor6D
lul = LUL.Base.Motor6D
rll = RLL.Base.Motor6D
rul = RUL.Base.Motor6D

lll2 = LLL.Knee.Joint
lul2 = LUL.Knee.Joint
rll2 = RLL.Knee.Joint
rul2 = RUL.Knee.Joint

olll = lll.C0 * CFrame.new(-0.5,0,-1) * CFrame.new(-0.3,-0.75,0.3)
olul = lul.C0 * CFrame.new(-0.5,0,1) * CFrame.new(-0.3,-0.75,-0.3)
orll = rll.C0 * CFrame.new(-0.5,0,1) * CFrame.new(-0.3,-0.75,-0.3)
orul = rul.C0 * CFrame.new(-0.5,0,-1) * CFrame.new(-0.3,-0.75,0.3)

lll2.C0 = lll2.C0
lul2.C0 = lul2.C0
rll2.C0 = rll2.C0
rul2.C0 = rul2.C0

olll2 = lll2.C0
olul2 = lul2.C0
orll2 = rll2.C0
orul2 = rul2.C0


rstep:connect(function()
	local v = torso.Velocity
	local mag = math.sqrt(v.x^2 + v.z^2) / 15
	s = mag * 15
	if mag > 0.1 then
		pose = "Running"
	else
		pose = "Idle"
	end
end)

pose = "Idle"
local lsine = 1
local ksine = -1
local lsine2 = 2.7
local ksine2 = -2.7
hum.JumpPower = 0
movelegs = true
flying = false
bv = Instance.new("BodyVelocity",torso)


function sparkle(size,amt,pos,dur,thickness)
	for i = 1,amt do
		if thickness == nil then
			thickness = size/9
		end
		local p = basepart:Clone()
		p.Parent = workspace
		p.CanCollide = false
		p.Shape = "Ball"
		p.Anchored = true
		p.Material = "Neon"
		p.Color = secondary
		p.CFrame = CFrame.new(pos) * CFrame.Angles(math.random(-360,360)/360,math.random(-360,360)/360,math.random(-360,360)/360)
		p.Size = Vector3.new(1,1,1)
		local mesh = Instance.new("SpecialMesh",p)
		mesh.MeshType = Enum.MeshType.Sphere
		tween(p, "Sine", "Out", dur, {
			["Transparency"] = 1;
			["CFrame"] = p.CFrame * CFrame.Angles(math.random(-360,360)/360,math.random(-360,360)/360,math.random(-360,360)/360)
		})
		tween(mesh, "Sine", "Out", dur*2, {
			["Scale"] = Vector3.new(thickness,size*10,thickness);
		})
		game.Debris:AddItem(p,dur)
	end
end

sparkle(10,55,hrp.Position,3,1)

function push(part,vel)
	local bv2 = Instance.new("BodyVelocity",part)
	bv2.Velocity = (part.Position - torso.Position).unit  * 3 * (vel / 30000)
	bv2.MaxForce = Vector3.new(vel,vel,vel)
	game.Debris:AddItem(bv2,0.25)
end
local t = {}
function t.find(ta,element)
	for i = 1,#ta do
		if ta[i] == element then
			return true
		end
	end
	return false
end
function AOE(magnitude,damage,pos)
	coroutine.resume(coroutine.create(function()
		if not pos then
			pos = hrp.Position
		end
		local chars = {}
		local ex = baseexplosion:Clone()
		ex.Position = pos
		ex.Parent = workspace
		ex.BlastPressure = 0
		ex.Visible = false
		ex.DestroyJointRadiusPercent = 0
		ex.BlastRadius = magnitude
		ex.Hit:connect(function(pa)
			if pa.Parent:FindFirstChildOfClass("Humanoid") and pa.Parent ~= char and t.find(chars,pa.Parent) == false then
				table.insert(chars,pa.Parent)
			end
			if pa.Parent:FindFirstChildOfClass("Humanoid") and pa.Parent ~= char then
				push(pa, damage * 3000)
			end
		end)
		
		local p = basepart:Clone()
		p.Parent = workspace
		p.Shape = "Ball"
		p.Anchored = true
		p.CanCollide = false
		p.Material = "Neon"
		p.Color = secondary
		p.CFrame = CFrame.new(pos)
		p.Size = Vector3.new(0,0,0)
		tween(p, "Sine", "Out", 2, {
			["Size"] = Vector3.new(magnitude*5,magnitude*5,magnitude*5);
		})
		tween(p, "Sine", "Out", 0.75, {
			["Transparency"] = 1;
		})
		game.Debris:AddItem(p,0.75)
		spawn(function() sparkle(magnitude, 15, p.Position,1) end)
		wait()
		for i = 1,#chars do
			local hrp2 = chars[i]:FindFirstChildOfClass("Part")
			if hrp2 then
				local hum2 = chars[i]:FindFirstChildOfClass("Humanoid")
				if hum2 and hum2 ~= hum then
					hum2.Health = hum2.Health - (hum2.MaxHealth / (100 / damage))
					if hum2.MaxHealth == math.huge then
						chars[i]:BreakJoints()
					end
				end
			end
		end
	end))
end

function AOE2(magnitude,damage,pos)
	if not pos then
		pos = hrp.Position
	end
	local chars = {}
	local ex = baseexplosion:Clone()
	ex.Position = pos
	ex.Parent = workspace
	ex.BlastPressure = 0
	ex.Visible = false
	ex.DestroyJointRadiusPercent = 0
	ex.BlastRadius = magnitude
	ex.Hit:connect(function(pa)
		if pa.Parent:FindFirstChildOfClass("Humanoid") and pa.Parent ~= char and t.find(chars,pa.Parent) == false then
			table.insert(chars,pa.Parent)
		end
		if pa.Parent:FindFirstChildOfClass("Humanoid") and pa.Parent ~= char then
			push(pa, damage * 3000)
		end
	end)
	wait()
	for i = 1,#chars do
		if chars[i] ~= char then
			local hrp2 = chars[i]:FindFirstChild("HumanoidRootPart")
			if hrp2 then
				if (hrp2.Position - pos).magnitude < magnitude then
					local hum2 = chars[i]:FindFirstChildOfClass("Humanoid")
					if hum2 and hum2 ~= hum then
						push(hrp2, 10000)
						hum2.Health = hum2.Health - (hum2.MaxHealth / (100 / damage))
						hit().Volume = 0.3
						spawn(function() sparkle((magnitude - (hrp2.Position - pos).magnitude) / 5, 1, hrp2.Position,0.5) end)
					end
				end
			end
		end
	end
end
rstep:connect(function()
	for i,v in pairs (char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
		end
	end
	if not flying then
		bv.Velocity = Vector3.new(0,0,0)
		bv.MaxForce = Vector3.new(0,0,0)
	end
	local md = hum.MoveDirection
	hum.MaxHealth = math.huge
	hum.Health = math.huge
	hum:SetStateEnabled("Dead",false)
	if pose == "Running" and movelegs then
		tween(hum,"Sine","Out",0.1,{["HipHeight"] = 1.25})
		
		local tim = s / 300
		lsine = lsine + s / 20 / 10
		ksine = ksine + s / 20 / 10
		local lsin = math.sin(lsine)
		local ksin = math.sin(ksine)
		
		lsine2 = lsine2 + s / 20 / 10
		ksine2 = ksine2 + s / 20 / 10
		local lsin2 = math.sin(lsine2)
		local ksin2 = math.sin(ksine2)
		local Ru_Ll = CFrame.Angles(0,lsin/2.5,0)
		local Lu_Rl = CFrame.Angles(0,-lsin2/2.5,0)
		local e = 4 - s / 25
		if e < 1 then e = 1 end
		local Ru2_Ll2 = CFrame.Angles(ksin/2,0,-ksin/e)
		local Lu2_Rl2 = CFrame.Angles(-ksin2/2,0,-ksin2/e)
		
		lll.C0 = lll.C0:lerp(Ru_Ll * olll * CFrame.Angles(0,0,-ksin/5), tim)
		rul.C0 = rul.C0:lerp(Ru_Ll * orul * CFrame.Angles(0,0,ksin/5), tim)

		lul.C0 = lul.C0:lerp(Lu_Rl * olul * CFrame.Angles(0,0,-ksin2/5), tim)
		rll.C0 = rll.C0:lerp(Lu_Rl * orll * CFrame.Angles(0,0,ksin2/5), tim)
		
		lul2.C0 = lul2.C0:lerp(Ru2_Ll2 * olul2, tim)
		rll2.C0 = rll2.C0:lerp(Ru2_Ll2 * orll2, tim)
		
		lll2.C0 = lll2.C0:lerp(Lu2_Rl2 * olul2, tim)
		rul2.C0 = rul2.C0:lerp(Lu2_Rl2 * orll2, tim)
	end
	if pose == "Idle" and movelegs then
		tween(cmotor,"Sine","Out",0.2,{["C0"] = cm0})
		lsine = lsine + 0.1/2
		ksine = ksine + 0.1/2
		local lsin = math.sin(lsine)
		local ksin = math.sin(ksine)
		
		lsine2 = lsine2 + 0.1/2
		ksine2 = ksine2 + 0.1/2
		local lsin2 = math.sin(lsine2)
		local ksin2 = math.sin(ksine2)
		
		local Ru_Ll = CFrame.Angles(0,0,ksin/10 + math.rad(-5))
		local Lu_Rl = CFrame.Angles(0,0,ksin/10 + math.rad(-5))
		local Ru2_Ll2 = CFrame.Angles(0,0,-ksin2/5)
		local Lu2_Rl2 = CFrame.Angles(0,0,-ksin2/5)
		
		tween(hum,"Sine","Out",0.3,{["HipHeight"] = 1.4 - ksin/1.5})
		
		lll.C0 = lll.C0:lerp(Ru_Ll * olll, 0.05)
		rul.C0 = rul.C0:lerp(Ru_Ll * orul, 0.05)

		lul.C0 = lul.C0:lerp(Lu_Rl * olul, 0.05)
		rll.C0 = rll.C0:lerp(Lu_Rl * orll, 0.05)
		
		lul2.C0 = lul2.C0:lerp(Ru2_Ll2 * olul2, 0.05)
		rll2.C0 = rll2.C0:lerp(Ru2_Ll2 * orll2, 0.05)
		
		lll2.C0 = lll2.C0:lerp(Lu2_Rl2 * olul2, 0.05)
		rul2.C0 = rul2.C0:lerp(Lu2_Rl2 * orll2, 0.05)
	end
	if editws == false then return end
	if run == true then
		tween(hum,"Sine","Out",0.5,{["WalkSpeed"] = 40})
		jp = 100
	else
		tween(hum,"Sine","Out",0.5,{["WalkSpeed"] = 16})
		jp = 65
	end
end)

jp = 50

mouse = player:GetMouse()
UIS = game:GetService("UserInputService")
run = false
attacking = false
sdown = false

UIS.InputBegan:connect(function(k,g)
	local key = k.KeyCode
	if not g then
		if key == Enum.KeyCode.Space then
			sdown = true
			jump()
		end
		if key == Enum.KeyCode.Q then
			stomp()
		end
		if key == Enum.KeyCode.LeftShift then
			run = true
		end
		if key == Enum.KeyCode.E then
			backstomp()
		end
		if key == Enum.KeyCode.F then
			fdown = true
			spin()
		end
	end
end)
UIS.InputEnded:connect(function(k,g)
	local key = k.KeyCode
	if not g then
		if key == Enum.KeyCode.LeftShift then
			run = false
		end
		if key == Enum.KeyCode.Space then
			sdown = false
		end
		if key == Enum.KeyCode.F then
			fdown = false
		end
	end
end)

fdown = false

function stomp()
	if flying or attacking then return end
	attacking = true
	editws = false
	movelegs = false
	tween(hum,"Sine","InOut",0.6,{["WalkSpeed"] = 0})
	
	woosh()
	tween(lll,"Sine","InOut",0.2,{["C0"] = olll * CFrame.Angles(0,0,0)})
	tween(lul,"Sine","InOut",0.2,{["C0"] = olul * CFrame.Angles(math.rad(-40),math.rad(-40),math.rad(100)) * CFrame.new(0,-1,-1)})
	tween(rll,"Sine","InOut",0.2,{["C0"] = orll * CFrame.Angles(0,0,0)})
	tween(rul,"Sine","InOut",0.2,{["C0"] = orul * CFrame.Angles(math.rad(40),math.rad(40),math.rad(100)) * CFrame.new(0,-1,1)})
	
	tween(lll2,"Sine","InOut",0.2,{["C0"] = olll2 * CFrame.Angles(0,0,0)})
	tween(lul2,"Sine","InOut",0.2,{["C0"] = olul2 * CFrame.Angles(0,0,0)})
	tween(rll2,"Sine","InOut",0.2,{["C0"] = orll2 * CFrame.Angles(0,0,0)})
	tween(rul2,"Sine","InOut",0.2,{["C0"] = orul2 * CFrame.Angles(0,0,0)})
	wait(0.2)
	tween(lll,"Sine","In",0.15,{["C0"] = olll * CFrame.Angles(0,0,0)})
	tween(lul,"Sine","In",0.15,{["C0"] = olul * CFrame.Angles(math.rad(-20),math.rad(40),0)})
	tween(rll,"Sine","In",0.15,{["C0"] = orll * CFrame.Angles(0,0,0)})
	tween(rul,"Sine","In",0.15,{["C0"] = orul * CFrame.Angles(math.rad(20),math.rad(-40),0)})
	
	tween(lll2,"Sine","InOut",0.15,{["C0"] = olll2 * CFrame.Angles(0,0,0)})
	tween(lul2,"Sine","InOut",0.15,{["C0"] = olul2 * CFrame.Angles(0,0,0)})
	tween(rll2,"Sine","InOut",0.15,{["C0"] = orll2 * CFrame.Angles(0,0,0)})
	tween(rul2,"Sine","InOut",0.15,{["C0"] = orul2 * CFrame.Angles(0,0,0)})
	spawn(function()
		wait(0.08)
		hardhit()
		AOE(5, 20, (hrp.CFrame * CFrame.new(0,-3,-5)).p)
	end)
	wait(0.08)
	movelegs = true
	attacking = false
	editws = true
end

function backstomp()
	if flying or attacking then return end
	attacking = true
	editws = false
	movelegs = false
	tween(hum,"Sine","InOut",0.6,{["WalkSpeed"] = 0})
	
	woosh()
	tween(lll,"Sine","InOut",0.2,{["C0"] = olll * CFrame.Angles(math.rad(40),0,math.rad(70))})
	tween(lul,"Sine","InOut",0.2,{["C0"] = olul})
	tween(rll,"Sine","InOut",0.2,{["C0"] = orll * CFrame.Angles(math.rad(-40),0,math.rad(70))})
	tween(rul,"Sine","InOut",0.2,{["C0"] = orul})
	
	tween(lll2,"Sine","InOut",0.2,{["C0"] = olll2 * CFrame.Angles(0,0,0)})
	tween(lul2,"Sine","InOut",0.2,{["C0"] = olul2 * CFrame.Angles(0,0,0)})
	tween(rll2,"Sine","InOut",0.2,{["C0"] = orll2 * CFrame.Angles(0,0,0)})
	tween(rul2,"Sine","InOut",0.2,{["C0"] = orul2 * CFrame.Angles(0,0,0)})
	wait(0.2)
	tween(lll,"Sine","InOut",0.15,{["C0"] = olll * CFrame.Angles(math.rad(10),math.rad(-40),math.rad(-30))})
	tween(lul,"Sine","InOut",0.15,{["C0"] = olul})
	tween(rll,"Sine","InOut",0.15,{["C0"] = orll * CFrame.Angles(math.rad(-10),math.rad(40),math.rad(-30))})
	tween(rul,"Sine","InOut",0.15,{["C0"] = orul})
	
	tween(lll2,"Sine","InOut",0.15,{["C0"] = olll2 * CFrame.Angles(0,0,0)})
	tween(lul2,"Sine","InOut",0.15,{["C0"] = olul2 * CFrame.Angles(0,0,0)})
	tween(rll2,"Sine","InOut",0.15,{["C0"] = orll2 * CFrame.Angles(0,0,0)})
	tween(rul2,"Sine","InOut",0.15,{["C0"] = orul2 * CFrame.Angles(0,0,0)})
	spawn(function()
		wait(0.08)
		hardhit()
		AOE(5, 20, (hrp.CFrame * CFrame.new(0,-3,5)).p)
	end)
	wait(0.08)
	movelegs = true
	attacking = false
	editws = true
end

jdeb = true
function jump()
	if jdeb == false then return end
	--if hum.FloorMaterial == Enum.Material.Air then return end
	jdeb = false
	local issprint = false
	if jp == 100 then issprint = true end
	movelegs = false
	editws = false
	tween(hum,"Sine","Out",2,{["WalkSpeed"] = 0})
	woosh().Volume = 0.1
	tween(lll,"Sine","InOut",0.5,{["C0"] = olll * CFrame.Angles(0,0,math.rad(50))})
	tween(lul,"Sine","InOut",0.5,{["C0"] = olul * CFrame.Angles(0,0,math.rad(50))})
	tween(rll,"Sine","InOut",0.5,{["C0"] = orll * CFrame.Angles(0,0,math.rad(50))})
	tween(rul,"Sine","InOut",0.5,{["C0"] = orul * CFrame.Angles(0,0,math.rad(50))})
	
	tween(lll2,"Sine","InOut",0.5,{["C0"] = olll2 * CFrame.Angles(0,0,math.rad(70))})
	tween(lul2,"Sine","InOut",0.5,{["C0"] = olul2 * CFrame.Angles(0,0,math.rad(70))})
	tween(rll2,"Sine","InOut",0.5,{["C0"] = orll2 * CFrame.Angles(0,0,math.rad(70))})
	tween(rul2,"Sine","InOut",0.5,{["C0"] = orul2 * CFrame.Angles(0,0,math.rad(70))})
	tween(hum,"Sine","Out",0.5,{["HipHeight"] = 0})
	wait(0.2)
	local power = jp
	repeat rstep:Wait(0) tween(hum,"Sine","Out",0.5,{["HipHeight"] = 0}) power = power + 1 tween(hum,"Sine","Out",0.5,{["WalkSpeed"] = 0}) editws = false movelegs = false until not sdown
	spawn(function()
		jdeb = true
		if power > 200 then power = 200 end
		if power > 150 then hardhit() hardhit() woosh() woosh() sparkle(5,30,(torso.CFrame * CFrame.new(0,-2,0)).p, 1.5) end
		bv.Velocity = Vector3.new(0,power,0)
		bv.MaxForce = Vector3.new(0,4000000,0)
	end)
	tween(hum,"Sine","Out",0.1,{["HipHeight"] = 1.25})
	woosh()
	tween(lll,"Sine","Out",0.25,{["C0"] = olll * CFrame.Angles(0,0,-math.rad(50))})
	tween(lul,"Sine","Out",0.25,{["C0"] = olul * CFrame.Angles(0,0,-math.rad(50))})
	tween(rll,"Sine","Out",0.25,{["C0"] = orll * CFrame.Angles(0,0,-math.rad(50))})
	tween(rul,"Sine","Out",0.25,{["C0"] = orul * CFrame.Angles(0,0,-math.rad(50))})
	
	tween(lll2,"Sine","InOut",0.25,{["C0"] = olll2 * CFrame.Angles(0,0,-math.rad(30))})
	tween(lul2,"Sine","InOut",0.25,{["C0"] = olul2 * CFrame.Angles(0,0,-math.rad(30))})
	tween(rll2,"Sine","InOut",0.25,{["C0"] = orll2 * CFrame.Angles(0,0,-math.rad(30))})
	tween(rul2,"Sine","InOut",0.25,{["C0"] = orul2 * CFrame.Angles(0,0,-math.rad(30))})
	tween(hum,"Sine","Out",0.2,{["WalkSpeed"] = 25})
	wait(0.15)
	movelegs = true
	spawn(function()
		repeat rstep:Wait(0) tween(hum,"Sine","Out",3,{["WalkSpeed"] = 100}) until hum.FloorMaterial ~= Enum.Material.Air
		if power > 150 and issprint then AOE(15,99,hrp.Position - Vector3.new(0,2,0)) explosion() explosion() hardhit() sparkle(15,45,torso.Position - Vector3.new(0,5,0), 1, 10) end
		editws = true
	end)
end
cm0 = cmotor.C0

function unravel()
	tween(lll,"Sine","Out",0.1,{["C0"] = CFrame.new(-1,-0.5,-0.5) * CFrame.Angles(0,0,-0.3)})
	tween(lul,"Sine","Out",0.1,{["C0"] = CFrame.new(-1,-0.5,0.5) * CFrame.Angles(0,0,-0.3)})
	tween(rll,"Sine","Out",0.1,{["C0"] = CFrame.new(-1,-0.5,0.5) * CFrame.Angles(0,0,-0.3)})
	tween(rul,"Sine","Out",0.1,{["C0"] = CFrame.new(-1,-0.5,-0.5) * CFrame.Angles(0,0,-0.3)})
	
	tween(lll2,"Sine","Out",0.1,{["C0"] = olll2 * CFrame.Angles(0,0,math.rad(-90))})
	tween(lul2,"Sine","Out",0.1,{["C0"] = olul2 * CFrame.Angles(0,0,math.rad(-90))})
	tween(rll2,"Sine","Out",0.1,{["C0"] = orll2 * CFrame.Angles(0,0,math.rad(-90))})
	tween(rul2,"Sine","Out",0.1,{["C0"] = orul2 * CFrame.Angles(0,0,math.rad(-90))})
end

function spin()
	if attacking then return end
	flying = true
	attacking = true
	--editws = false
	movelegs = false
	tween(hum,"Sine","InOut",0.2,{["WalkSpeed"] = 0})
	repeat
		movelegs = false
		unravel()
		if fdown == false then flying = false end
		hum.HipHeight = 1 + math.sin(csine)/2
		rstep:Wait(0)
		rstep:Wait(0)
		rstep:Wait(0)
		bv.MaxForce = Vector3.new(0,2000,0)
		bv.Velocity = Vector3.new(0,50,0)
		local t = tween(cmotor, "Sine","Out",0.15,{
			["C0"] = cmotor.C0 * CFrame.Angles(0,2,0)
		})
		local sfx = woosh()
		sfx.Volume = 0.02
		sfx.PlaybackSpeed = sfx.PlaybackSpeed - 0.2
		spawn(function()
			AOE2(15, 3, (hrp.CFrame).p)
		end)
	until
		fdown == false
	bv.MaxForce = Vector3.new(0,0,0)
	tween(cmotor, "Sine","Out",0.5,{
		["C0"] = cm0
	})
	
	movelegs = true
	attacking = false
	flying = false
	--editws = true
end




function base()
	if flying or attacking then return end
	attacking = true
	editws = false
	movelegs = false
	tween(hum,"Sine","InOut",0.2,{["WalkSpeed"] = 0})
	
	woosh()
	tween(lll,"Sine","InOut",0.2,{["C0"] = olll * CFrame.Angles(0,0,0)})
	tween(lul,"Sine","InOut",0.2,{["C0"] = olul})
	tween(rll,"Sine","InOut",0.2,{["C0"] = orll * CFrame.Angles(0,0,0)})
	tween(rul,"Sine","InOut",0.2,{["C0"] = orul})
	
	tween(lll2,"Sine","InOut",0.2,{["C0"] = olll2 * CFrame.Angles(0,0,0)})
	tween(lul2,"Sine","InOut",0.2,{["C0"] = olul2 * CFrame.Angles(0,0,0)})
	tween(rll2,"Sine","InOut",0.2,{["C0"] = orll2 * CFrame.Angles(0,0,0)})
	tween(rul2,"Sine","InOut",0.2,{["C0"] = orul2 * CFrame.Angles(0,0,0)})
	wait(0.2)
	
	spawn(function()
		wait(0.08)
		hardhit()
		AOE2(5, 20, (hrp.CFrame * CFrame.new(0,-3,5)).p)
	end)
	wait(0.15)
	movelegs = true
	attacking = false
	editws = true
end
