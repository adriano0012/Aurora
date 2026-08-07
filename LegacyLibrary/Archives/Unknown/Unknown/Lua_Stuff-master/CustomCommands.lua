if not getgenv().MTAPIMutex then loadstring(game:HttpGet("https://pastebin.com/raw/UwFCVrhS", true))() end
--[[getgenv().DumpFunction(func)
	if type(func) == 'function' then
		local tbl = {}
		tbl.Parent = func
		for i,v in pairs(getupvalues(func)) do
			if type(v) == 'function' then
				tbl[i] = {}
				for l,k in pairs(getupvalues(v)) do
					tbl[i][l] = [k]
				end
			else
				tbl[i]=v
			end
		end
		return tbl
	else
		return nil
	end
end--]]
getgenv().print = warn
getgenv().httpget = function(url) return game:HttpGet(url,true) end
getgenv().loadhttp = function(url) loadstring(httpget(url))() end
getgenv().Players = game:GetService'Players'
getgenv().Player = Players.LocalPlayer
getgenv().Character = Player.Character
getgenv().moveplr = function(pos) Character:MoveTo(pos) end
getgenv().round = function(num) return math.floor(num+ .05) end
getgenv().tp = false
getgenv().tpplr = function(pos,skip)
	tp = false
	function Tp(pos)
		tp = true
		pos = pos + Vector3.new(0,3,0)
		local startpos = Character.Head.CFrame
		local Distance = (pos - Character.Head.Position).Magnitude
		local Skips = round(Distance/skip)
		local VectorToSkip = (pos - Character.Head.Position)/Skips
		local i = 0
		while i ~= Skips do
			if tp == false then
				break
			end
			pcall(function()
			Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			startpos = startpos + VectorToSkip
			Character.HumanoidRootPart.CFrame = (startpos)
			i = i + 1
			Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
			Character.HumanoidRootPart.CFrame =  Character.HumanoidRootPart.CFrame
			end)
			wait()
		end
		tp = false
	end
end
getgenv().tptoplr = function(name)
	for i,v in pairs(Players:GetChildren()) do
		if v.Name:lower():find(name:lower()) then
			if v.Character and v.Character.PrimaryPart then
				Character:MoveTo(v.Character.PrimaryPart.Position)
			end
		end
	end
end
getgenv().reset = function() Character:BreakJoints() end
getgenv().setwalkspeed = function(num) game.Players.LocalPlayer.Character.Humanoid:AddSetHook("WalkSpeed"); Character.Humanoid.WalkSpeed = num end
getgenv().setjumppower = function(num) game.Players.LocalPlayer.Character.Humanoid:AddSetHook("JumpPower"); Character.Humanoid.JumpPower = num end
getgenv().renderstepped = game:GetService'RunService'.RenderStepped
getgenv().creator = 'Eski#0420/ Akem Manah'












getgenv().ur_retarded = function()
	print'Yep, ur retarded :)'
end



