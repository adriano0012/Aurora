--[[
	PSilent_Testing
	AcidNShrooms

	Base Wars
	Silent Aim
	No Spread
	Weapon Stats ( Infinite Ammo )

	18164449.lua
]]

local pla = Require('Player',false)
local Old_Camera;
local Mouse = Require('Mouse',false)
function NewCamera()
	local Real_Camera = workspace.CurrentCamera
	local Camera = {lookVector = Instance.new('Part').CFrame.lookVector}
	local Camera_Meta = {__index = function(self,key)
		if self[key] then
			return self[key]
		else
			return Real_Camera[key]
		end
	end,}
	Camera = setmetatable(Camera,Camera_Meta)
	Old_Camera = Camera

	return Camera;
end

local BaseWars = function(UI,Camera)
	local Func = function(Wep)
		local stats = get(Wep)
		
		--tbl(stats,false,'Weapon Stuff'..tick())
		return stats
	end
	function Clone(Table)
		local newtable = {}
		for i,v in pairs(Table) do
				newtable[i]=v
		end
		return newtable
	end
	local NewGun;
	local NewVehicle;
	spawn(function()
		for i,v in pairs(getgc()) do
			if type(v) == 'function' then
			
				local upvs = debug.getupvalues(v)
				for index,value in pairs( upvs ) do
					if type(value) == 'table' then
						if rawget(value,'NewControl') then
							NewGun = rawget(value,'NewControl')
							print('Gun Controller loaded')
						elseif rawget(value,'SetGunnerType') then
							NewVehicle = value
							print('Vehicle Controller loaded')
							--tbl(value,false,'Vehicle Controller')
						end
					end
				end
			end
		end
	end)
	repeat wait() until NewGun and NewVehicle
	local Weapon;
	--[[]]
	function GetWeapon()
		for i,v in pairs(getupvalues(NewGun)) do
			if rawget(v,'__index') then
				if rawget(v.__index,'SetAimingPosition') then
					Weapon = v
				end
			end
		end
	end
	repeat wait() GetWeapon() until Weapon
	local fire = Weapon.__index.FireWeapon -- FiringStep
	local SpoofedAccuracy = function()
		return 0,0
	end
	local Players = Require('Players',false)
	local HasBeenSpoofed = false;
	Weapon.__index.FireWeapon = function(Weapon, StartPart, ViewAngle, ...)

		local FakeAngle;
		local Camera = Old_Camera and Old_Camera or NewCamera()
		local ShouldDetourBullet =  Mouse:GetClosestPlayerToCrosshair(Players:GetVisiblePlayers(Players:GetEnemyPlayers(Players:get())))
		--Players:GetClosestPlayer(Players:GetVisiblePlayers(Players:GetEnemyPlayers(Players:get())))
		local InRadius = Players:GetPlayersInRadius(Players:GetEnemyPlayers(Players:get()),50)
		if InRadius then
			local closest = Players:GetClosestPlayer(InRadius)
			if closest then
				local LookAtPos = closest.Character.Head.Position-- + ((closest.Character.HumanoidRootPart.Velocity * (Character:Distance(closest.Character.Head.Position/Weapon.CurrentProperties.CurrentVelocity))))
				ViewAngle = CFrame.new(Vector3.new(0,0,0),(StartPart.Position - LookAtPos)).lookVector*-1
			end
		end
		if uis:IsKeyDown(Enum.KeyCode.E) and ShouldDetourBullet then
			local LookAtPos = ShouldDetourBullet.Character.Head.Position -- + ((ShouldDetourBullet.Character.HumanoidRootPart.Velocity * (Character:Distance(ShouldDetourBullet.Character.Head.Position/Weapon.CurrentProperties.CurrentVelocity))))
			ViewAngle = CFrame.new(Vector3.new(0,0,0),(StartPart.Position - LookAtPos)).lookVector*-1
		end
		Weapon.CurrentProperties.CurrentAmmo = 100
		Weapon.CurrentProperties.CurrentFireRate = 968
		Weapon.CurrentProperties.IsSniper = false -- removes waiting for bolt for snipers, still plays animations
		Weapon.CurrentProperties.DropMultiplier = 0
		--[[BaseWarseapon.CurrentProperties.
		Weapon.CurrentProperties.--]]

		--Weapon.CurrentProperties.CurrentFireRat
		rawset(Weapon,'GetAccuracy',SpoofedAccuracy)
		rawset(Weapon,'CheckIfDeadOrNot',function() return true end)
		--rawset(Weapon,'CheckCanFireNextShot',function() return true end)
		if not HasBeenSpoofed then
			HasBeenSpoofed = true
			Notify:SendMessage'Weapon data has been spoofed.'
		end
		return fire(Weapon, StartPart, ViewAngle, ...)
	end
	Notify:SendMessage'Base wars loaded'
	return true
end
--[[
	Weapon Stuff
for i,v in pairs(worksapce.ReplicatedStorage.ClientSideEngine.EquipmentStatsSystem.Vehicle.Weapons:GetChildren()) do
	a = require(v)
	a.Reload = 0
	a.EmptyReload = 0
	a.RoF = 900
	ammo = a.AmmoInfo[1]
	ammo.DirectDamage = {9999,9999,9999,9999}
	ammo.MaxSpread = 0
	ammo.Pellets = 10
end
--]]
return BaseWars











