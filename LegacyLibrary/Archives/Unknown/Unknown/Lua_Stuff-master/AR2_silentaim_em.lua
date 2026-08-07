game:GetService("ReplicatedStorage")["AdminRE"]:ClearAllChildren()
		local module = require(game.ReplicatedStorage.NetworkModule)
		
		function GetFirstPlayer()
			local thing = {}
			for i,v in pairs(game:GetService'Players':GetChildren()) do
				if v.Character and v.Character:FindFirstChild'Head' and v.Character:FindFirstChild'Humanoid' then
					if v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 then
						table.insert(thing,v)
					end
				end
			end
			if #thing > 0 then
				return thing[math.random(1,#thing)]
			else
				return nil
			end
		end
		
		_fireclient = module.FireClient
			module.FireClient = function(Player,Action,...) 
			return _fireclient(Player,Action,...)
		end
		_fireserver = module.FireServer
			module.FireServer = function(Player,Action,...) 
			--[[print(Action)
			for i,v in pairs({...}) do 
				print(i,v)
			end--]]
			local a = {...}
			if Action == 'Damage' then 
				if game:GetService("ReplicatedStorage"):FindFirstChild"AdminRE" then
					game:GetService("ReplicatedStorage")["AdminRE"]:Destroy()
				end
				if GetFirstPlayer() and CanShoot then
					local plr = GetFirstPlayer()
					SendMessage('Sent SilentAim Shot at: '..plr.Name)
					CanShoot = false
					WaitedST = 0
					a[1],a[2] = (plr.Character.Humanoid or Instance.new('Part')),(plr.Character.Head or Instance.new('Part'))
					a[3],a[4] = (plr.Character.Head.Position or Vector3.new(0,0,0)),(plr.Character.Head.Position or Vector3.new(0,0,0))
				end
				for i,v in pairs(a) do 
					if type(v) == 'Part' then 
						print(i,v:GetFullName())
					else
						print(i,v)
					end
				end
				return _fireserver(Player,Action,unpack(a))
			end
		--	print(Player,Action)
			return _fireserver(Player,Action,unpack(a))
		end
		SendMessage('Im lazy, so you cant turn this off xd')
		SendMessage('Potential Ban!')
