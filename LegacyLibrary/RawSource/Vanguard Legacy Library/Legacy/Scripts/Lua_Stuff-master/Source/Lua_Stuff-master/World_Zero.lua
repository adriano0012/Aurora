--settings
local IAm = 'Sword'
_G.Settings = {
['KillAura'] = false,
['AuraDistance'] = 25,
['Trails'] = true
}
_G.ToggleTrails = function(tog)
	_G.Settings['Trails'] = not _G.Settings['Trails']
end
_G.OpenChest = function()
	for i,v in pairs(workspace.ChestSpawns:GetChildren()) do 
		game.ReplicatedStorage.Shared.Chests['OpenChest']:InvokeServer(v)
	end
end
local mod = require(game.ReplicatedStorage.Shared.Combat)
mod.BroadcastDamageNumber = function()
end





local DualWield = {'DualWield1','DualWield2','DualWield3','DualWield4','DualWield5',
'Leap1','Leap2',
'WhirlwindSpin1','WhirlwindSpin2','WhirlwindSpin3','WhirlwindSpin4','AWhirlwindSpin','BWhirlwindSpin',
'DualWieldUltimateHit1','DualWieldUltimateHit2','DualWieldUltimateHit3','DualWieldUltimateHit4','DualWieldUltimateHit5','DualWieldUltimateSlam',
}
local Mage = {
'IcefireMage1',
'IcySpikes1','IcySpikes2','IcySpikes3','IcySpikes4','IcySpikes5',
'IceFireMageFireball','IceFireMageFireballBlast',
'IcefireMageUltimateMeteor1','IcefireMageUltimateMeteor2','IcefireMageUltimateMeteor3','IcefireMageUltimateMeteor4','IcefireMageUltimateMeteor5','IcefireMageUltimateMeteor6','IcefireMageUltimateMeteor7','IcefireMageUltimateMeteor8','IcefireMageUltimateMeteor9',
}
local mod = require(game.ReplicatedStorage.Shared.Combat)
mod.RenderDamageNumber = function()
end
function GetTarget()
	for i,v in pairs(workspace.Mobs:GetChildren()) do
		if v:FindFirstChild'Model' and (v.Model.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < _G.Settings['AuraDistance'] and v.HealthProperties.Health.Value > 0 then
		    return v
		end
	end
end
function Attack(mob,pos,role)
	local args = {
		[1] = {
			[1] = mob,
		},
		[2] = {
			[1] = pos,
		},
		[3] = 'DualWield1'
	}
	if role == 'Mage' then
		for i,v in pairs(Mage) do
			args[3] = v
			game.ReplicatedStorage.Shared.Combat.AttackTarget:FireServer(unpack(args))
		end
	elseif role == 'Sword' then
		for i,v in pairs(DualWield) do
			args[3] = v
			print(unpack(args))
			game.ReplicatedStorage.Shared.Combat.AttackTarget:FireServer(unpack(args))
		end
	end
end

spawn(function()
	while wait() do
		game.ReplicatedStorage.Shared.Combat['SetTrails']:FireServer(_G.Settings['Trails'])
	end
end)

spawn(function()
	while wait() do 
		if _G.Settings['KillAura'] then
			local mob = GetTarget()
			if mob then 
				Attack(mob,mob.Model.PrimaryPart.Position,IAm)
			end
		end
	end
end)
