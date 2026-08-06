


user = game:GetService'Players'.LocalPlayer




local asset = 2251689019
sg = Game:GetObjects("rbxassetid://"..asset)[1]
sg.drag.Text = "Mining Simulator Gui, Version: 1.1.1b - Dev Version"
drag = sg.drag
players = game:GetService('Players')
player = players.LocalPlayer
char = player.Character
Character = char
mouse = player:GetMouse()
sg.Parent = game.CoreGui
local paused = false
local Main,OreTp,Keybinds,Players

local chars = "abcdefghijklmnopqrstuvwxyz-_=+\|]}[{';:lL,<.>§¦¦¦æ¦"
local codes = {'Duckie','Valkyrie','Wings','Dominus','Accessories','MineAlot','Rainbowite','GetSlicked','Challenge','Adventure','Light','Oof','NewQuests','SummerParadise','HammieJammieSucksxInfinity','Sunscreen','BeachBall','SandCastles','July21st','sircfenner','Dreamy','Fluffy','Skies','Sandy','Scorch','BaconHair','HammieJammieDoesntSuck','NosniyIsCool','Vacation','Lemonaide','CoolWater','Patriot','PatrioticStars','America','HammieJammieSucksx2','Catman','Koala','Lucky','HammieJammieSucks','UnderTheSea','Summer','Sand','Water','Atlantis','LegendaryHatCode','LegendaryEggCode','SuperSecretCode','ILOVECODES','TheRamblingNation','GummyBears','Invasion','Trades','Sweets','Coal','DiggingDeep','Level','SecretEgg','Bonus','Golden','Grind','Gamer','Rebirths','100Million','Money','T-Rex','Dinosaur','Overhaul','Jam','Toast','Bread','Retro','NewStart','WeBreakRoblox','AppleJuice','StuffedAnimal','Train','PlushyScythe','PlushyShadowScythe','Bear','Arcade','Games','Plushy','Sandbox','Unobtainible','ToyChest','Exclusive','PinkArmySkin','PinkArmy','Mission','Silver','Español','Update!','Comic','HiddenTreasure','Defild','Lamb','Fans','Danger','Eggo!','TestingThing','Cool','Ore','JellyBean','Pumped','Awesome','Abstract','Lollipop','Candy','Pets','Bunny','Epic','Aliens','LotsOfCoins','Dino','Selfie','Cave','Eggs','Momma','Rare','EvenMoreHats','Morehats','Hats!','Easter','Dabbin','Isaac','Rebirth','Rumble','RumbleStudios','Quests','DefildPlays','DefildPlays2','Secret','Icecream','CrainerGamer','Crainer'}
local AutoMine,AutoRebirth,AutoCrate,AfkMine,AutoOre,AutoMineKey,AutoRebirthKey,AfkMineKey,CreateTpKey,TeleportTpKey,DestroyTpKey,TeleportSellKey,OpenCrateKey,DeleteKey,MaxOre = false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false

local KeyPressEquiv = mouse1click or leftclick or MOUSE_CLICK or PlaceHolder
 
if Synapse then KeyPressEquiv = Synapse.mouse1click end
if Input then KeyPressEquiv = Input.LeftClick end

local network = {
	cache = {}
}
function network:Initialize()
	local id = 0
	local runs = 0
	function key()
		id = id + 1
		if id > 100 then
			id = 0
		end
		return 2654 * (id * 3)
	end
	function network.new()
		local remote, func = game.ReplicatedStorage.Network:InvokeServer()
		runs = runs + 1
		if runs >= 2 then
			self:FireServer("KickSelf", "Bypassing Network")
		end
		network.RemoteEvent = remote
		network.RemoteFunction = func
	end
	network.new()
	function network:Cache(name, func)
		if not self.cache[name] then
			self.cache[name] = func
		else
			warn("Function '" .. name .. "' has previous cache.")
		end
	end
	function network:Function(name, ...)
		if not network.init then
			repeat
				wait(0.25)
			until network.init
		end
		if not self.cache[name] then
			warn("Function " .. name .. " has not been cached yet")
		else
			return self.cache[name](...)
		end
	end
	function network:FireServer(name, ...)
		self.RemoteEvent:FireServer(name, {
			{
				...
			}
		}, key())
	end
	function network:InvokeServer(name, ...)
		return self.RemoteFunction:InvokeServer(name, {
			{
				...
			}
		}, key())
	end
	function self.RemoteFunction.OnClientInvoke(...)
		return self:Function(...)
	end
	self.RemoteEvent.OnClientEvent:connect(function(...)
		self:Function(...)
	end)
	network.init = true
end
network:Initialize()
function network:FireServer(name, ...)
	self.RemoteEvent:FireServer(name, {
		{
			...
		}
	}, key())
end

function GetShit()
	local coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack = network:InvokeServer("GetStats")
	return {coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack}
end
local atmine = false
function OpenCrates()
	if AutoCrate then
		local a = {}
		for i,v in pairs(GetShit()[10]) do
			local crate,num = v[1],v[2]
			for i=1,num do
				if AutoCrate then
					network:FireServer('SpinCrate',crate)
				wait(1)
				end
			end
		end
	else
		return nil
	end
end

function GenRan()
	local txt = ''
	for i=1,16 do
		local mat_ran = math.random(1,string.len(chars))
		txt = txt..chars:sub(mat_ran,mat_ran)
	end
	return txt
end


local Frame = sg.drag.frames
local main,misc,settings,Players,Logs,Settings,CloseB = Frame.Main,Frame.Ore,Frame.Keybinds,Frame.Players,Frame.Logs,Frame.Settings,sg.drag.close
main.Visible = true
local MainM = {
main.AutoMine.toggle,
main.AutoRebirth.toggle,
main.AutoCrate.toggle,
main.AfkMine.toggle,
main.RedeemCodes
}
LogsM = {
	Logs.Log
}

settingsM = {
	Settings.wait.txt,
	Settings.delete.key,
	Settings.delete.toggle,
	Settings.maxores.txt,
	Settings.maxores.toggle
}
local MiscM = {
misc.AutoOre.toggle,
misc.Ores,
misc.Added,
}
local laspos
settingsM[5].MouseButton1Down:connect(function()
	if MaxOre == true then
		MaxOre=false
		settingsM[5].BackgroundColor3=Color3.new(1,0,0)
	else
		MaxOre=true
		settingsM[5].BackgroundColor3=Color3.new(0,1,0)
	end
end)
CloseB.MouseButton1Down:connect(function()
	drag:TweenPosition(UDim2.new(1,0,0.5,0),'Out','Sine',.5)
	laspos = drag.Position
	local open = Instance.new('TextButton',sg)
	open.BackgroundColor3=Color3.fromRGB(95, 95, 95)
	open.Size = UDim2.new(0,23,0,23)
	open.Text = 'O'
	open.TextSize = 16
	open.Font = 'ArialBold'
	open.TextColor3=Color3.new(1,1,1)
	open.Position=UDim2.new(1,-23,0.5,-11.5)
	open.MouseButton1Down:connect(function()
		drag:TweenPosition(laspos,'Out','Sine',.5)
		open:Destroy()
	end)
end)

MiscM[1].MouseButton1Down:connect(function()
	if AutoOre then
		AutoOre = false
		MiscM[1].BackgroundColor3 = Color3.new(1,0,0)
	else
		AutoOre = true
		MiscM[1].BackgroundColor3 = Color3.new(0,1,0)
	end
end)
local keybinds = {
	['AutoMine']='key',
	['AutoRebirth']='key',
	['AfkMine']='key',
	['CreateTpPad']='key',
	['TeleportTpPad']='key',
	['DestroyPad']='key',
	['TeleportToSell']='key',
	['OpenCrates']='key',
	['ToggleFreeze']='key',
	['DeleteKey']='key',
	
}
local Lims = {
	['WaitTime']=1200,
	['MaxOres']=10,
}
function isnil(ting)
	return ting == nil
end
function IsFull()
	local base = player.PlayerGui.ScreenGui.StatsFrame.Inventory.Amount.Text
	if base:find'inf' then
		return true
	end
	for i=1,string.len(base) do
		if base:sub(i,i) == '/' then
			local min,max = base:sub(1,i-1):gsub(',',''),base:sub(i+1):gsub(',','')
			
			if MaxOre then
				if not isnil(tonumber(settingsM[4].Text)) then
					if tonumber(min) >= tonumber(settingsM[4].Text) then
						Log'Max Reached'
						Log('Current Custom Max: '..settingsM[4].Text)
						return false
					end
				end
			end
			if tonumber(min) >= tonumber(max) then
				return false
			else
				return true
			end
		end
	end
end
local SettingsM = {
settings.AutoMine.key,
settings.AutoRebirth.key,
settings.AfkMine.key,
settings.CreateTp.key,
settings.TeleportTp.key,
settings.DestroyTp.key,
settings.TpToSell.key,
settings.OpenCrates.key,
settings.Freeze.key,
}
function GetNumm(inp)
	if type(inp) == 'number' then
		return tonumber(inp) 
	else
		return 1200
	end
end
settingsM[1].Changed:connect(function()
	Lims ['WaitTime']=GetNumm(settingsM[1].Text)
end)
settingsM[2].Changed:connect(function()
	keybinds['DeleteKey']=settingsM[2].Text
end)
settingsM[4].Changed:connect(function()
	Lims['MaxOres']=settingsM[4].Text
end)
settingsM[3].MouseButton1Down:connect(function()
	if DeleteKey then
		DeleteKey=false
	else
		DeleteKey=true
	end
end)
SettingsM[1].Changed:connect(function()
	keybinds['AutoMine']=SettingsM[1].Text
end)
SettingsM[2].Changed:connect(function()
	keybinds['AutoRebirth']=SettingsM[2].Text
end)
SettingsM[3].Changed:connect(function()
	keybinds['AfkMine']=SettingsM[3].Text
end)
SettingsM[4].Changed:connect(function()
	keybinds['CreateTpPad']=SettingsM[4].Text
end)
SettingsM[5].Changed:connect(function()
	keybinds['TeleportTpPad']=SettingsM[5].Text
end)
SettingsM[6].Changed:connect(function()
	keybinds['DestroyPad']=SettingsM[6].Text
end)
SettingsM[7].Changed:connect(function()
	keybinds['TeleportToSell']=SettingsM[7].Text
end)
SettingsM[8].Changed:connect(function()
	keybinds['OpenCrates']=SettingsM[8].Text
end)
SettingsM[9].Changed:connect(function()
	keybinds['ToggleFreeze']=SettingsM[9].Text
end)
local guipos
local drag = sg.drag
local MainB,OreB,KeyB,PlayB,LogB,SettB=drag.buttons.main,drag.buttons.tpore,drag.buttons.keybinds,drag.buttons.plrs,drag.buttons.logs,drag.buttons.settings
MainB.MouseButton1Down:connect(function()
	main.Visible = true
	settings.Visible = false
	Players.Visible = false
	misc.Visible = false
	Logs.Visible = false
	Settings.Visible = false
end)
	main.Visible = true
	settings.Visible = false
	Players.Visible = false
	misc.Visible = false
	Logs.Visible = false
	Settings.Visible = false
OreB.MouseButton1Down:connect(function()
	main.Visible = false
	settings.Visible = false
	Players.Visible = false
	misc.Visible = true
	Logs.Visible = false
	Settings.Visible = false
end)
KeyB.MouseButton1Down:connect(function()
	main.Visible = false
	settings.Visible = true
	Players.Visible = false
	misc.Visible = false
	Logs.Visible = false
	Settings.Visible = false
end)
PlayB.MouseButton1Down:connect(function()
	main.Visible = false
	settings.Visible = false
	Players.Visible = true
	misc.Visible = false
	Logs.Visible = false
	Settings.Visible = false
end)
LogB.MouseButton1Down:connect(function()
	main.Visible = false
	settings.Visible = false
	Players.Visible = false
	misc.Visible = false
	Logs.Visible = true
	Settings.Visible = false
end)
SettB.MouseButton1Down:connect(function()
	main.Visible = false
	settings.Visible = false
	Players.Visible = false
	misc.Visible = false
	Logs.Visible = false
	Settings.Visible = true
end)
local mines = {
	['Earth']=Vector3.new(1,13.4,5),
	['Candy']=Vector3.new(30,12,3036),
	['Toy']=Vector3.new(36,13,5669),
	['Food']=Vector3.new(35.45,13,8748.03),
	['Dino']=Vector3.new(30,12,10524),
	['Atlantis']=Vector3.new(35.5,13,11939),
	['Beach']=Vector3.new(29,12,14345),
	['Vip']=Vector3.new(0,13,-1229),
	
}
function TpToMine()
	Log'Teleporting To Mine'
	if player.Character.HumanoidRootPart.Position.Z > game.Workspace.BeachPosition.Value.Z then
		Tp(mines["Beach"])
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.SeaPosition.Value.Z then
		Tp(mines["Atlantis"])
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.DinoPosition.Value.Z then
		Tp(mines["Dino"])
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.FoodPosition.Value.Z then
		Tp(mines["Food"])
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.ToyPosition.Value.Z then
		Tp(mines["Toy"])
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.CandyPosition.Value.Z then
		Tp(mines["Candy"])
	else
		Tp(mines["Earth"])
	end
end
function TeleportToPad()
	wait(1)
    network:FireServer("TeleportToPad")
end
function RemovePad()
    network:FireServer("RemovePad")
end
function TeleporterDown()
	if char.Parent:FindFirstChild(player.Name..'Teleporter',true) then
		return true
	else
		return false
	end
end
function PlaceTeleport(item)
    if TeleporterDown() then
        RemovePad()
        wait(0.1)
        player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    else
        player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    end
    
    player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
end
function TpToBlock(block)
	local isBlock = workspace.Blocks:FindFirstChild(block, true)
	local primary = isBlock.PrimaryPart
    
    if primary then
        PlaceTeleport(primary)
        wait(0.5)
        TeleportToPad()
    end
end
function UpdateOres()
	for i,v in pairs(workspace.Blocks:GetChildren()) do
		local scroll = MiscM[2]
		if not scroll:FindFirstChild(v.Name) then
			local ting = Instance.new('TextButton',scroll)
			ting.Size = UDim2.new(1,0,0,20)
			ting.Position = UDim2.new(0,0,0,(#scroll:GetChildren()-1)*20)
			ting.Text = v.Name
			ting.Name = v.Name
			ting.TextColor3=Color3.new(1,1,1)
			ting.BorderColor3=Color3.new(1,1,1)
			ting.BackgroundColor3=Color3.fromRGB(112, 112, 112)
			scroll.CanvasSize = UDim2.new(0,166,0,#scroll:GetChildren()*25+20)
			ting.MouseButton1Down:connect(function()
				local ting = Instance.new('TextButton',MiscM[3])
				ting.Size = UDim2.new(1,0,0,20)
				ting.Position = UDim2.new(0,0,0,(#MiscM[3]:GetChildren()-1)*20)
				ting.BackgroundColor3=Color3.fromRGB(112, 112, 112)
				MiscM[3].CanvasSize = UDim2.new(0,166,0,#scroll:GetChildren()*20+20)
				ting.Name = v.Name
				ting.Text = v.Name
				ting.TextColor3=Color3.new(1,1,1)
				ting.BorderColor3=Color3.new(1,1,1)
				ting.MouseButton1Down:connect(function()
					ting:Destroy()
				end)
			end)
		end
	end
end
function round(n)
	return math.floor(n + 0.5)
end

function Tp(pos)
	_G.Tp = false
	local startpos = char.Head.CFrame
	local Distance = (pos - char.Head.Position).Magnitude
	local Skips = round(Distance/2)
	local VectorToSkip = (pos - char.Head.Position)/Skips
	local i = 0
	_G.Tp = true
	while i ~= Skips do
		if _G.Tp == false then
			break
		end
		char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
		startpos = startpos + VectorToSkip
		char.HumanoidRootPart.CFrame = (startpos)
		i = i + 1
		char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
		wait()
	end
end
MainM[1].MouseButton1Down:connect(function()
if AutoMine == false then
AutoMine = true
MainM[1].BackgroundColor3 = Color3.new(0,1,0)
else
AutoMine = false
MainM[1].BackgroundColor3 = Color3.new(1,0,0)
end
end)
MainM[2].MouseButton1Down:connect(function()
if AutoRebirth == false then
AutoRebirth = true
MainM[2].BackgroundColor3 = Color3.new(0,1,0)
else
AutoRebirth = false
MainM[2].BackgroundColor3 = Color3.new(1,0,0)
end
end)
MainM[3].MouseButton1Down:connect(function()
if AutoCrate == false then
AutoCrate = true
MainM[3].BackgroundColor3 = Color3.new(0,1,0)
else
AutoCrate = false
MainM[3].BackgroundColor3 = Color3.new(1,0,0)
end
end)

MainM[4].MouseButton1Down:connect(function()
if AfkMine == false then
AfkMine = true
atmine = false
MainM[4].BackgroundColor3 = Color3.new(0,1,0)
else
AfkMine = false
MainM[4].BackgroundColor3 = Color3.new(1,0,0)
end
end)
drag.Draggable = true
local frozen = false
function FreezeChar()
	if frozen then
		frozen = false
		for i,v in pairs(char:GetChildren()) do
			if v:IsA'BasePart' then
				v.Anchored = false
			end
		end
	else
		frozen = true
		for i,v in pairs(char:GetChildren()) do
			if v:IsA'BasePart' then
				v.Anchored = true
			end
		end
	end
end
function teleportToSell()
	paused = true
	wait(1)
	local zone
	if player.Character.HumanoidRootPart.Position.Z > game.Workspace.BeachPosition.Value.Z then
		network:FireServer("MoveTo", "BeachSell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.SeaPosition.Value.Z then
		network:FireServer("MoveTo", "SeaSell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.DinoPosition.Value.Z then
		network:FireServer("MoveTo", "DinoSell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.FoodPosition.Value.Z then
		network:FireServer("MoveTo", "FoodSell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.ToyPosition.Value.Z then
		network:FireServer("MoveTo", "ToySell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.CandyPosition.Value.Z then
		zone = "Candy"
		network:FireServer("MoveTo", "CandySell")
	elseif player.Character.HumanoidRootPart.Position.Z > game.Workspace.SpacePosition.Value.Z then
		zone = "Space"
		network:FireServer("MoveTo", "SpaceSell")
	else
		zone = "Earth"
		network:FireServer("MoveTo", "SellSpawn")
	end
	wait(2)
	paused = false
end
mouse.KeyDown:connect(function(key)
	for i,v in pairs(keybinds) do
		if v:lower() == key:lower() then
			if i == 'AutoMine' then
				if AutoMine then
					AutoMine = false
				else
					AutoMine = true
				end
			elseif i == 'AutoRebirth' then
				if AutoRebirth then
					AutoRebirth = false
				else
					AutoRebirth = true
				end
			elseif i == 'AfkMine' then
				if AfkMine then
					AfkMine = false
				else
					AfkMine = true
				end
			elseif i == 'CreateTpPad' then
				PlaceTeleport(char.LowerTorso)
			elseif i == 'TeleportToPad' then
				TeleportToPad()
			elseif i == 'DestroyPad' then
				RemovePad()
			elseif i == 'TeleportToSell' then
					teleportToSell()
			elseif i == 'OpenCrates' then
				if AutoCrate then
					AutoCrate = false
				else
					AutoCrate = true
				end
			elseif i == 'ToggleFreeze' then
					FreezeChar()
			end
		end
	end
end)
local added = {}
local check = math.huge
function findFirstParent(obj, parent)
    local function find(current)
        if not isnil(current) and current.Parent == parent then
            return current
        elseif not isnil(current) and current.Parent == game then
            return nil
        elseif not isnil(current) then
            return find(current.Parent)
        end
    end
    return find(obj)
end
function MineBlock()
	local targ
	pcall(function()
		targ = mouse.Target
	if (mouse.Target.Position - Character.Head.Position).Magnitude <= 20 then
		local IsBlock = findFirstParent(targ, game.Workspace.Blocks)
		if IsBlock then
			network:FireServer('MineBlock',IsBlock)
		end
	end
	end)
end
function MineBlock2(block)
	local targ = block.PrimaryPart
	local IsBlock = findFirstParent(targ, game.Workspace.Blocks)
	if (targ.Position - Character.Head.Position).Magnitude <= 20 then
		network:FireServer('MineBlock',IsBlock)
	end
end
function MineBlock3(block)
	pcall(function()
		if not (block == nil) then
			local targ = block
			local IsBlock = findFirstParent(targ, game.Workspace.Blocks)
			if IsBlock then
				network:FireServer('MineBlock',IsBlock)
			end
		end
	end)
end
MainM[5].MouseButton1Down:connect(function()
	for i,v in pairs(codes) do
		wait(1.5)
		network:FireServer('RedeemCode',v)
		Log('Redeeming code: '..v)
	end
end)
function Rebirth()
	paused = true
	wait(.5)
	network:FireServer('Rebirth')
	paused =false
end
local LogFolder = Logs.Log
function Log(info)
	local Info = Instance.new('TextLabel',LogFolder)
	Info.Name = info
	Info.TextColor3=Color3.new(1,1,1)
	Info.BorderColor3 = Color3.new(1,1,1)
	Info.Text = tostring(info)
	Info.Size = UDim2.new(0,347,0,20)
	Info.Parent = LogFolder
	Info.Visible=true
	Info.ZIndex=10
	Info.Position = UDim2.new(0,0,0,(#LogFolder:GetChildren()-1)*20)
	Info.BackgroundColor3=Color3.fromRGB(112, 112, 112)
	Info.Visible=true
	LogFolder.CanvasSize = UDim2.new(1,0,0,#LogFolder:GetChildren()*20+25)
	
end

for i,v in pairs(sg:GetDescendants()) do
	v.Name = GenRan()
end
sg.Name = GenRan()
local check = 1200
local waits = 0
local function callback(text)
	if text == "Ok" then
	end
end
local bindableFunction = Instance.new("BindableFunction")
bindableFunction.OnInvoke = callback
game.StarterGui:SetCore("SendNotification", {
	Title = "Thanks for choosing my GUI :)"; -- Required. Has to be a string!
	Text = "If you have any problems, please join the discord posted on the thread!"; -- Required. Has to be a string!
	Icon = ""; -- Optional, defaults to "" (no icon)
	Duration = 5; -- Optional, defaults to 5 seconds
	Callback = bindableFunction; -- Optional, gets invoked with the text of the button the user pressed
	Button1 = "Ok"; -- Optional, makes a button appear with the given text that, when clicked, fires the Callback if it's given
})

game:GetService('RunService').RenderStepped:connect(function()
	check = check +1
	if check > 1200 then
		UpdateOres()
		check = 0
	end
	if AutoMine then
		if not paused and workspace:FindFirstChild('Collapse') == nil then
		if IsFull() then
			wait(1)
			MineBlock()
		else
			teleportToSell()
		end
		end
	end
end)
local PartStandingOn 
char.LeftFoot.Touched:connect(function(toucher)
	PartStandingOn = toucher
end)
char.RightFoot.Touched:connect(function(toucher)
	PartStandingOn = toucher
end)

function IsCollapsed()
	return workspace:FindFirstChild'Collapsed' == nil
end
local waiting = false
local clickdelay = 0
while wait() do
	clickdelay = clickdelay+1
	waits = waits + 1
	if AutoOre then
		paused = true
		if IsFull() then
			for i,v in pairs(MiscM[3]:GetChildren()) do
				wait()
				if workspace.Blocks:FindFirstChild(v.Name) then
					wait()
					pcall(function()
						if IsFull() and AutoOre then
							wait()
							if workspace.Blocks:FindFirstChild(v.Name) then
								local block = workspace.Blocks:FindFirstChild(v.Name)
								Log'Creating Teleporting'
								PlaceTeleport(block.PrimaryPart)
								wait(1)
								Log'Teleporting, and freezing character'
								TeleportToPad()
								for i,v in pairs(char:GetChildren()) do
									if v:IsA'BasePart' then
										v.Anchored = true
										end
									end
								wait(1)
								Log('Mining Block '..block.Name)
								MineBlock2(block)
								Log'Unfreezing Char'
								for i,v in pairs(char:GetChildren()) do
									if v:IsA'BasePart' then
										v.Anchored = false
									end
								end
							end
						end
						
					end)
				end
			end
		else
			teleportToSell()
		end
		paused = false
	end
	if AutoCrate then
		OpenCrates()
	end
	if AutoRebirth then
		if waits > 120 then
			Rebirth()
			waits = 0
		end
	end
	if AfkMine then
		if not IsCollapsed() then
			if atmine then
				if clickdelay > 120 then
					KeyPressEquiv()
					clickdelay = 0
				end
				if IsFull() and PartStandingOn ~= nil then
					pcall(function()
					MineBlock3(PartStandingOn.Parent)
					end)
				elseif not IsFull() then
					teleportToSell()
					atmine = false
				end
			else
				atmine = true
				TpToMine()
				wait()
				char.HumanoidRootPart.Velocity = Vector3.new(15,-15,15)
			end
		else
			atmine = false
			wait()
		end
	end
end





