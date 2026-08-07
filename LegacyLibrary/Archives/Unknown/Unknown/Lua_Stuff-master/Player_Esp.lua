local uip = game:GetService'UserInputService'
local chars = game:GetService'Workspace':WaitForChild('Characters')
local Target;
local PlrState = true
local PlrHealth = true
--local PlrChams = true

local Weapon = true

local esp = {}
local blacklist = ''
chars.ChildAdded:connect(function(char)
	local plr = char.Name

	if plr == game.Players.LocalPlayer.Name then
		print'My Plr Spawned'
		for nig,pig in pairs(chars:GetChildren()) do 
			for i,v in pairs(game:GetService'Teams':GetChildren()) do
				if v.Players:FindFirstChild(pig.Name) and v.Players:FindFirstChild(game.Players.LocalPlayer.Name) and not blacklist:find(pig.Name) then
					print(pig.Name..' Denied')
					blacklist = blacklist..pig.Name
				elseif v.Players:FindFirstChild(pig.Name) and not v.Players:FindFirstChild(game.Players.LocalPlayer.Name) then
					if not blacklist:find(pig.Name) then
						print(pig.Name..' Accepted')
						esp[pig] = Drawing.new('Text')
					end
				end
			end
		end
		else
		esp[char] = Drawing.new('Text')
	end
end)

game:GetService'RunService'.RenderStepped:connect(function()
	--if chars:FindFirstChild(game.Players.LocalPlayer.Name) then
		for i,v in pairs(esp) do
			if i.Parent == chars then
				local x = game.Workspace.CurrentCamera:WorldToViewportPoint(i:WaitForChild('Hitbox'):WaitForChild('Head').Position)
				v.Position = Vector2.new(x.X,x.Y)
				v.Visible = true
				if x.Z < 0 then
					v.Visible = false
				end
				v.Size = 14
				v.Color = Color3.new(1,1,1)
				v.Text = ""
				if PlrState then
					v.Text = ""
					for _,l in pairs(i.State:GetChildren()) do
						if l.Value and type(l.Value) ~= 'number' then
							v.Text = 'State: '..l.Name
						end
					end
				end
				if PlrHealth then
					v.Text = v.Text..[[

	Health: ]]..i.Health.Value
				end
				if Weapon then
					v.Text = v.Text..[[

	Equipped: ]]..tostring(i.Backpack.Equipped.Value)
				end
			else
				local a = 0
				for m,p in pairs(esp) do
					a = a + 1
					if m == i then
						table.remove(esp,a)
					end
				end
				v.Visible = false
			end
		end
	--end
end)
