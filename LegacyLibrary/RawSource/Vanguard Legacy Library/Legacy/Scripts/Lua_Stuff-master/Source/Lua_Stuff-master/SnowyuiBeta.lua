
local module = {};

module.tweenspeed = 0.28; --// like this numbre
module.newobj = function(obj,props)
	local product = Instance.new(obj);
	for e,b in pairs(props) do
    	product[e] = b; 
	end;
	return product;
end;
module.newrgb = function(red,green,blue)
    local product = Color3.new(red/255,green/255,blue/255);
	return product;
end;
module.newtween = function(obj,props,speed,...)
    local info = TweenInfo.new(speed,...); 
	local product = game:GetService("TweenService"):Create(obj,info,props);
	product:Play();
	return product;
end;
module.hasproperty = function(obj,prop)
	local product = ypcall(function()return obj[prop];end);
	return product;
end;

module.fadeallprops = function(obj,inout,bt,it,tt)
	ypcall(module.newtween,obj,{BackgroundTransparency = bt},module.tweenspeed,Enum.EasingStyle.Linear,inout);
	ypcall(module.newtween,obj,{ImageTransparency = it},module.tweenspeed,Enum.EasingStyle.Linear,inout);
	ypcall(module.newtween,obj,{TextTransparency = tt},module.tweenspeed,Enum.EasingStyle.Linear,inout);
end;

module.makescrollautoupdate = function(scroll,layout)
	spawn(function()
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
			scroll.CanvasSize = UDim2.new(0,layout.AbsoluteContentSize.X,0,layout.AbsoluteContentSize.Y+13);
		end);
	end)
end;
local newobj = function(objname,cool)
    local obj = module.newobj(objname, cool);
    return obj;
end
local globalsettings
--[[globalsettings = {
	-- Open gui
	["OpenGUI"] = Enum.KeyCode.Insert;
	-- Aimbot 
	["AimbotToggle"] = false;
	["Triggerbot"] = false;
	["Backtrack"] = false;
	["VisibiltyCheck"] = false;
	["Ffa"] = false;
	["AimbotSens"] = 0.5;
	["AimbotFov"] = 5;
	["AimbotKey"] = Enum.KeyCode.T;
	-- LT2
	["InstantCut"] = false;
	["InstantCutKey"] = Enum.KeyCode.T;
	["HardDragger"] = false;
	["StealAxes"] = false;
	["StealItems"] = false;
	["StealWood"] = false;
	["StealCars"] = false;
        -- Strucid
        ["StrucidFOV"] = 5;
		["StrucidFFA"] = false
}--]]
local defkeys = 'local globalsettings = {["OpenGUI"] = Enum.KeyCode.Insert;["AimbotToggle"] = false;["Triggerbot"] = false;["Backtrack"] = false;["VisibiltyCheck"] = false;["Ffa"] = false;["AimbotSens"] = 0.5;["AimbotFov"] = 5;["AimbotKey"] = Enum.KeyCode.T; ["aimbotmouse2"] = true; ["aimbotmouse1"] = true; ["InstantCut"] = false;["InstantCutKey"] = Enum.KeyCode.T;["HardDragger"] = false;["StealAxes"] = false;["StealItems"] = false;["StealWood"] = false;["StealCars"] = false;["StrucidFOV"] = 5;["StrucidFFA"] = false} return globalsettings;'
if not pcall(readfile,"presets.snowygui") then 
	writefile("presets.snowygui",defkeys);
end;
local globalsettings = loadfile("presets.snowygui")();
newobj("ScreenGui", {
Name = "SnowyGUIBeta";
Parent = game:GetService("CoreGui");
ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
});
local coregui = game:WaitForChild("CoreGui")
local gui = coregui.SnowyGUIBeta
function SendMessage(Text)
	game.StarterGui:SetCore("SendNotification", {
	Title = "SnowyGUI"; -- the title (ofc)
	Text = Text; -- what the text says (ofc)
	Duration = 1; -- how long the notification should in secounds
	})
end
local changeaimbotkey = false
local changeopenkey = false
game:GetService'UserInputService'.InputBegan:Connect(function(IO,GPE)
	if changeaimbotkey == true then
		if IO.KeyCode == Enum.KeyCode.Unknown then	
			changeaimbotkey = false
			SendMessage("You can't set mousebutton1 or mousebutton2 as keys!")
		else
			local keys = tostring(IO.KeyCode)
			globalsettings["AimbotKey"] = IO.KeyCode
			SendMessage("Key Changed")
			SendMessage("Key: "..string.sub(keys, 14, string.len(keys)))
			wait(0.1)
		end
		changeaimbotkey = false
		elseif changeopenkey == true then
		if IO.KeyCode == Enum.KeyCode.Unknown then	
			changeopenkey = false
			SendMessage("You can't set mousebutton1 or mousebutton2 as keys!")
		else
			local keys = tostring(IO.KeyCode)
			globalsettings["OpenGUI"] = IO.KeyCode
			SendMessage("Key Changed")
			SendMessage("Key: "..string.sub(keys, 14, string.len(keys)))
			wait(0.1)
		end
		changeopenkey = false
	end
end)
changeaimhotkey = function()
if changeaimbotkey == false then 
SendMessage("Press any key")
changeaimbotkey = true
end
end
changeopenhotkey = function()
if changeopenkey == false then 
SendMessage("Press any key")
changeopenkey = true
end
end
if game.PlaceId == 171391948 then 
tptocrate = function()
	for i,v in pairs(workspace:GetChildren()) do
	   if v:IsA("Model") then
	      for _,d in pairs(v:GetChildren()) do
	         if d:IsA("Model") then
	            for __,f in pairs(d:GetChildren()) do
	               if f:IsA("MeshPart") then
	                  if f:FindFirstChild("Beep") then
	                  pcall(function() 
		              game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(f.Position) 
		              end) 
	                  end
	               end
	            end
	         end
	      end
	   end
	end
end
end
if game.PlaceId == 404729070 then 
local fruit = "Apple"
changefruit = function()
local b = gui:FindFirstChild(string.gsub("treelandsinvisb", "invisb", "")) or gui:FindFirstChild("treelandsinvisb") 
fruit = b.holder.contents.optionscroll.FruitChosen.TextBox.Text
print(fruit)
end
spawnfruit = function()
	local spawn = Instance.new("Part", workspace.Fruits)
	spawn.Name = fruit
	spawn.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
	local Draggable = Instance.new("BoolValue", spawn)
	Draggable.Name = "Draggable"
	Draggable.Value = true
	local Tooltip = Instance.new("StringValue", spawn)
	Tooltip.Name = "Tooltip"
	Tooltip.Value = "Apple"
	local Action = Instance.new("StringValue", Tooltip)
	Action.Name = "Action"
	Action.Value = "Pickup Fruit"
end
dupefruit = function()
	for _,v in pairs(workspace.Fruits:GetChildren()) do 
	     if v.Name == fruit then 
			v:Clone().Parent = workspace.Fruits
		end
	end	
end
end
if game.PlaceId == 185655149 then
local remote
spawn(function()
local Metatable = getrawmetatable(game);
local OldNamecall = Metatable.__namecall;
SendMessage' Waiting to grab remote'
setreadonly(Metatable, false);

Metatable.__namecall = function(...)

    local Table = {...};
    local args = {...}
    if args[#args] == 'FireServer' then
        if not remote and type(args[2]) == 'table' and args[2]['Order'] then 
            print('Remote Found')
            remote = args[1]
        end
        return OldNamecall(...)
    else
        return OldNamecall(...)
    end
end;


repeat wait() until remote
SendMessage'Remote Caught'
end)

function GetStation()
    for i,v in pairs(workspace.BloxyBurgers.CashierWorkstations:GetChildren()) do
        if v.Occupied.Value ~= 'nil' and v.InUse.Value == game.Players.LocalPlayer then
            return v
        end
    end
end
function GrabOrder(thing)
	local Robloxian = thing.Occupied.Value
	if Robloxian then
	
		local order = {
			Robloxian.Order.Burger.Value,
			Robloxian.Order.Fries.Value,
			Robloxian.Order.Cola.Value,
		}
		return order
	end
end
function CompleteOrder()
    local GrabbedOrder = GrabOrder(GetStation())
    local something = {
        ["Order"] = {GrabbedOrder[1],
        GrabbedOrder[2],
        GrabbedOrder[3]},
        ["Workstation"] = GetStation()
    }
    remote:FireServer(something)
end
function GetStation2()
    for i,v in pairs(workspace.StylezHairStudio.HairdresserWorkstations:GetChildren()) do
        if v.Occupied.Value ~= nil then
            return v
        end
    end
end
function CompleteOrder2()
	local Workstation = GetStation2()
	local something = {
	['Order'] = {
	Workstation.Occupied.Value.Order.Style.Value,
	Workstation.Occupied.Value.Order.Color.Value
	},
	['Workstation'] = Workstation
	}
	remote:FireServer(something)
end

local autofarmbloxburg = false
local steppedburg;
runbloxautofarm = function() 
if autofarmbloxburg == false then
autofarmbloxburg  = true
steppedburg = game:GetService("RunService").RenderStepped:connect(function()
if GrabOrder(GetStation()) then
      CompleteOrder()
   end
end)
else
steppedburg:disconnect()
autofarmbloxburg  = false
end
end

local autofarmbloxburg2 = false
local steppedburg2;
runbloxautofarm2 = function() 
if autofarmbloxburg2 == false then
autofarmbloxburg2  = true
steppedburg2 = game:GetService("RunService").RenderStepped:connect(function()
   if GetStation2() then
      CompleteOrder2()
end
end)
else
steppedburg2:disconnect()
autofarmbloxburg2  = false
end
end
end



if game.PlaceId == 437253984 then 
aloneopgun = function()
game.Players.LocalPlayer.Events['InventoryItemEquipped']:Fire(20,{["SkinsAvailable"] = true,
			["Automatic"] = true,
            ["Ammo"] = 1000,
            ["FireRate"] = math.huge,
            ["MaxAmmo"] = 1000,
            ["Skin"] = "PinkBlock",
            ["EquippedSlot"] = "Primary",
            ["Equipped"] = true,
            ["Damage"] = math.huge,
            ["Type"] = "Rifle",
            ["Recoil"] = 0,
            ["EquipSlot"] = "Primary",
            ["RectOffset"] = Vector2.new(512,384),
            ["RectSize"] = Vector2.new(128,128),
            ["ReloadTime"] = -2e99,})
end
local itemfarmon = false
local itemthingyalone;
local alonestepped;
changeitemalonethingy = function()
local b = gui:FindFirstChild(string.gsub("aloneinvisb", "invisb", "")) or gui:FindFirstChild("aloneinvisb") 
itemthingyalone = b.holder.contents.optionscroll.ItemAloneChosen.TextBox.Text
print(itemthingyalone)
end
local lastpos
itemfarmalone = function()
if itemfarmon == false then
itemfarmon = true
alonestepped = game:GetService("RunService").RenderStepped:connect(function()
for i,v in pairs(workspace.WorldItems:GetChildren())do
lastpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    if itemthingyalone == v.Name then
		if v:IsA("Model") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.MainPart.Position)
		if game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.MainPart.Position) <= 35 then
		spawn(function()
		repeat
		wait()
		game.ReplicatedStorage.Remotes.Inventory:FireServer("RequestWorldItem", v)
		until game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.MainPart.Position) >= 35
		end)
		end
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastpos)
		else
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
		if game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Position) <= 35 then
		spawn(function()
		repeat
		wait()
		game.ReplicatedStorage.Remotes.Inventory:FireServer("RequestWorldItem", v)
		until game:GetService("Players").LocalPlayer:DistanceFromCharacter(v.Position) >= 35
		end)
		end
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastpos)
		end
    end
end
end)
else
alonestepped:disconnect()
itemfarmon = false
end
end
end
-- Strucid --
if game.PlaceId == 2377868063 then
local strucidsilentaim = false


Camera = function()
	return game.workspace.CurrentCamera
end	
Character = function()
		return game.Players.LocalPlayer.Character
end
Mouse = game.Players.LocalPlayer:GetMouse()
function IsOnScreen(part)
    local vector, onscreen = Camera():WorldToScreenPoint(part.Position)
    return(vector.Z > 0)
end
function IsInFov(Part)
	if IsOnScreen(Part) then
		if Part then
			local thingy = math.huge
			local pos = workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
			local dist = (Vector2.new(Mouse.X,Mouse.Y)-Vector2.new(pos.X,pos.Y)).magnitude
			if pos.Z>0 and dist <= workspace.CurrentCamera.ViewportSize.X/(90/globalsettings["StrucidFOV"]) and dist < thingy then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function GetDistAwayFromCursor(Part)
	local X = Mouse.X
	local Y = Mouse.Y
	local x = Camera():WorldToScreenPoint(Part.Position)
	return(math.abs(X-x.X + Y-x.Y))
end
function ByDistance(partlist)
	print'============ Start ============'
	local Distance = {}
	for i,v in pairs(partlist) do
		table.insert(Distance,GetDistAwayFromCursor(v))
	end
	for i,v in pairs(Distance) do
		if v == math.min(unpack(Distance)) then
			print('Closest Part: '..partlist[i].Name)
			return partlist[i]
		end
	end
end
function GetRandomPart(char)-- get part closest to cursor
    local ran = {}
    math.randomseed(os.time())
    for i,v in pairs(char:GetChildren()) do
        if v:IsA'BasePart' then
			if IsVisible(v) then
				if v.Name == 'Head' then
					for i=1,15 do
						table.insert(ran,v)
					end
				end
				table.insert(ran,v)
			end
        end
    end
	return ByDistance(ran)
    --return ran[math.random(1,#ran)]
end
function IsVisible(Part)
    if Part then
        local ScreenPos = Camera():WorldToScreenPoint(Part.Position)
        local unitRay = Camera():ScreenPointToRay(ScreenPos.X,ScreenPos.Y)
        local Rayy = Ray.new(unitRay.Origin, unitRay.Direction * 3000)
        local Ignore = Character():GetChildren()
        for i,v in pairs(Camera():GetChildren()) do
            table.insert(Ignore,v)
        end
        for i,v in pairs(Part.Parent:GetChildren()) do
            if not v:IsA'BasePart' then
                --print('Ignoring: '..v.Name)
                table.insert(Ignore,v)
            end
        end
        for i,v in pairs(workspace.IgnoreThese:GetChildren()) do
            table.insert(Ignore,v)
        end
        local Hit,Pos,Normal = workspace:FindPartOnRayWithIgnoreList(Rayy, Ignore)
        local ShouldReturn
        pcall(function()
            ShouldReturn = (Hit:IsDescendantOf(Part.Parent))
        end)
        --print(ShouldReturn)
        return (ShouldReturn or false)
    end
end
function GetFirstPlayer()
	local thing = {}
	for i,v in pairs(game:GetService'Players':GetChildren()) do
		if v.Character and v.Character:FindFirstChild'Head' and v.Character:FindFirstChild'Humanoid' and v ~= game.Players.LocalPlayer then
			if v.Team ~= game.Players.LocalPlayer.Team and v.Character.Humanoid.Health > 0 and globalsettings["StrucidFFA"] == false then
				if IsVisible(v.Character.Head) and IsInFov(v.Character.Head) then
					table.insert(thing,v)
				end
				elseif globalsettings["StrucidFFA"] == true and v.Character.Humanoid.Health > 0 then 
				if IsVisible(v.Character.Head) and IsInFov(v.Character.Head) then
					table.insert(thing,v)
				end
 			end
		end
	end
	if #thing > 0 then
		return thing[math.random(1,#thing)]
	else
		return nil
	end
end
local moduleB = require(game.ReplicatedStorage.GlobalStuff)
local _Cone = moduleB.ConeOfFire

strucidrunsilentaim = function()
 if strucidsilentaim == false then
strucidsilentaim = true
moduleB.ConeOfFire = function(Start, End, Inaccuracy)
    local target
    if GetFirstPlayer() then
        target = GetRandomPart(GetFirstPlayer().Character)
        target = (target.Position)
    end
    if not target then 
        target = game.Players.LocalPlayer:GetMouse().Hit.p
    end
    if strucidsilentaim == true then
	return (target)
	else
	return (game.Players.LocalPlayer:GetMouse().Hit.p)
	end
end
else
strucidsilentaim = false
end
end
end
-- End strucid --
-- Mining sim varaiables --
if game.PlaceId == 1417427737 then
local Player = game:GetService("Players").LocalPlayer
local Mousegaysim = Player:GetMouse()
Character = function()
return game.Players.LocalPlayer.Character 
end
SendMessage('Mining Simulator Network Loaded!')
network = { cache = {} }
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
local block;
changeblock = function()
local b = gui:FindFirstChild(string.gsub("miningsiminvisb", "invisb", "")) or gui:FindFirstChild("miningsiminvisb") 
block = b.holder.contents.optionscroll.BlockChosen.TextBox.Text
print(block)
end
function teleportToSell()
	local player = Player
	PlaceTeleport(Character().HumanoidRootPart)
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
	TeleportToPad()
end
function isnil(ting)
    return ting == nil
end
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
local mineblocks = false
local steppedformine;
function MineBlock()
if mineblocks == false then
	mineblocks = true
	steppedformine = game:GetService("RunService").RenderStepped:connect(function()
    local targ
	local mouse = Mousegaysim
	targ = mouse.Target
	if (mouse.Target.Position - Character().Head.Position).Magnitude <= 20 then
       local IsBlock = findFirstParent(targ, game.Workspace.Blocks)
       if IsBlock then
           network:FireServer('MineBlock',IsBlock)
       end
	end
end)
else
mineblocks = false
steppedformine:disconnect()
end
end
function RemovePad()
    network:FireServer("RemovePad")
end
function GetShit()
    local coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack = network:InvokeServer("GetStats")
    return {coins, inventory, equipped, ownedItems, offer, rebirths, skins, skinEquipped, pets, crates, favorites, hatInventory, wearing, visibleHats, eggHuntStuff, eggPackBought, quests, sortType, patriotBought, tokens, permanentItems, login, toolEnchantments, newQuests, lightPack}
end
local opencratesv = false
function OpenCrates()
    if opencratesv == false then
        opencratesv = true
        local a = {}
        for i,v in pairs(GetShit()[10]) do
            local crate,num = v[1],v[2]
            for i=1,num do
                if opencratesv == true then
                    network:FireServer('SpinCrate',crate)
              		wait(1)
                end
            end
        end
    else
        opencratesv = false
        return nil
    end
end
function TeleporterDown()
    if Character().Parent:FindFirstChild(Player.Name..'Teleporter',true) then
        return true
    else
        return false
    end
end
function PlaceTeleport(item)
    if TeleporterDown() then
        RemovePad()
        wait(0.1)
        Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    else
        Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
    end
   
    Player.PlayerGui.ScreenGui.ClientScript.Event:Fire("PlaceTeleporter", item.CFrame)
end
function TeleportToPad()
    wait(1)
    network:FireServer("TeleportToPad")
end
function TpToBlock()
    local isBlock = workspace.Blocks:FindFirstChild(block, true)
	if not isBlock then
	   SendMessage('Ore not found')
	   return
	end
    local primary = isBlock.PrimaryPart
   
    if primary then
        PlaceTeleport(primary)
        wait(0.5)
        TeleportToPad()
    end
	wait(.5)
	RemovePad()
end
end
-- End min9ing sim vbaraibles --
local HitPoints={
	['GoldAxe']= 50;
	['BasicHatchet']= 0.2;
	['Axe1']= 0.55;
	['Axe2']= 0.93;
	['AxeAlphaTesters']= 1.5;
	['Rukiryaxe']= 1.68;
	['Axe3']= 1.45;
	['AxeBetaTesters']= 1.45;
	['FireAxe']= 0.6;
	['SilverAxe']= 1.6;
	['EndTimesAxe']= 1.58;
	['AxeChicken']= 0.1;
	['CandyCaneAxe']= 0;
}

local thingy
local currentNPC
if game.PlaceId == 13822889 then
	function GetAxe()
	if game.Players.LocalPlayer.Character:FindFirstChild("Tool") then
	return game.Players.LocalPlayer.Character:FindFirstChild("Tool")
	elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Tool") then
	return game.Players.LocalPlayer.Backpack:FindFirstChild("Tool")
	end
end
local instantcuton = false
local ony = false
local clicked = false
toggleinscut = function()
if clicked == false then 
clicked = true
instantcuton = true
else
clicked = false
instantcuton  = false
end
end
	function cut(Height,Tool, Woodyes, sectionidyay)
	print("Fired")
	game.ReplicatedStorage.Interaction.RemoteProxy:FireServer(Woodyes.Parent.CutEvent,{
	["cuttingClass"] = "Axe",
	["cooldown"] = 0,
	["hitPoints"] = HitPoints[Tool.ToolName.Value],
	["sectionId"] = sectionidyay,
	["tool"] = Tool,
	["faceVector"] = Vector3.new(-1,0,0),
	["height"] = Height})
	end
	
	function poop(Tool)
		local mousepos = game:GetService("Players").LocalPlayer:GetMouse()
		local Tree=game.Players.LocalPlayer:GetMouse().Target
		local lastmousepos = mousepos.Hit.Position
		local lasttarget = Tree
		local lasttargetsection = Tree.Parent.WoodSection
		spawn(function()
		while  not lasttarget.Parent:FindFirstChild("RootCut") or not lasttarget.Parent:FindFirstChild("InnerWood") do
	    wait()
	    cut(lasttarget.CFrame:pointToObjectSpace(lastmousepos).Y + lasttarget.Size.Y / 2,Tool,lasttarget, lasttargetsection.ID.Value)
	    end
		end)
	end
	
	game:GetService('UserInputService').InputBegan:Connect(function(Input, gpe)
		if Input.KeyCode == globalsettings["InstantCutKey"] then
	        if ony == false and clicked == true then 
	        instantcuton = true
	        poop(GetAxe())
	        elseif ony == true and clicked == true  then 
	        instantcuton = false
	        end
	    end
	end)

print("Anti-Ban loaded LT2")
local currentpos = game.Players.LocalPlayer.Character.Head.Position
local postogo = workspace.Stores.WoodRUs.Thom.Head.Position
game.Players.LocalPlayer.Character:MoveTo(postogo)
while (not thingy) do
    for ind, F in next, getreg() do
        if type(F) == 'function' then 
            if not (thingy) then
                thingy = debug.getupvalue(F,'currentNPC');
				if thingy ~= nil then
				print("Current Shop ID: "..thingy.ID)
				currentNPC = tonumber(thingy.ID)
				end
            end
        end
end
	wait()
end
wait()
game.Players.LocalPlayer.Character:MoveTo(currentpos)
end

local targetythingy = "SoulessKnowledge"
local UserSetting = UserSettings():GetService("UserGameSettings")
local chosenitem = "USP"
changeitem = function()
local b = gui:FindFirstChild(string.gsub("SpawnItemsinvisb", "invisb", "")) or gui:FindFirstChild("SpawnItemsinvisb") 
chosenitem = b.holder.contents.optionscroll.ItemChosen.TextBox.Text
print(chosenitem)
end
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("damageNums") then
local dqaautofarm = false
local dqstepped;
function SwingWeapon()
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:FindFirstChild'swing' then
			v.swing:FireServer()
		end
	end
end
function UseAbility()
for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
    pcall(function()
        for _, f in pairs(v:GetChildren()) do 
            if f:IsA("RemoteEvent") then 
                f:FireServer()
            end
        end
    end)
end
end

function Hover(part)
if not part or not part.PrimaryPart then
	GetMob()
	return false
end
game.Players.LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
game.Players.LocalPlayer.Character.PrimaryPart.CFrame = part.PrimaryPart.CFrame * CFrame.Angles(4.5,0,0) * CFrame.new(0, 0, 5.5)
end
local Target
function GetMob()
	for i,v in pairs(workspace.dungeon:GetChildren()) do
		if v:FindFirstChild'enemyFolder' then
			for _,k in pairs(v:FindFirstChild'enemyFolder':GetChildren()) do
				if not Target and k.ClassName == 'Model' then
					Target = k
					return Target
				elseif Target then
					if Target:FindFirstChild'Humanoid' and Target.Humanoid.Health > 0 then
					
					else
						Target = nil
						return GetMob()
					end
				end
			end
		end
	end
end
autofarmdq = function()
if dqaautofarm == false then
dqaautofarm = true
dqstepped = game:GetService'RunService'.RenderStepped:connect(function()
	if not Target then
		GetMob()
	elseif Target then
		if Target:FindFirstChild'Humanoid' and Target.Humanoid.Health > 0 then
		else
			Target = nil
		end
	end
	Hover(Target)
	SwingWeapon()
	UseAbility()
end)
else
dqaautofarm = false
dqstepped:disconnect()
end
end
end
togglemousebutton1 = function()
print("cool")
if globalsettings["aimbotmouse1"] == false then
	globalsettings["aimbotmouse1"] = true
else
	globalsettings["aimbotmouse1"] = false
end
print(globalsettings["aimbotmouse1"])
end
togglemousebutton2 = function()
print("cool")
if globalsettings["aimbotmouse2"] == false then
	globalsettings["aimbotmouse2"] = true
else
	globalsettings["aimbotmouse2"] = false
end
print(globalsettings["aimbotmouse2"])
end
openframe = function(p)
if gui:FindFirstChild(p)  then
print(p)
end
  local b = gui:FindFirstChild(string.gsub(p, "invisb", "")) or gui:FindFirstChild(p) 
	if b.Visible == false then
		b.Name = string.gsub(p, "invisb", "")
		b.Visible = true
	else
		b.Name = p
		b.Visible = false
	end 
end

spawnitem = function()
    local realremote;
    for i,v in pairs(workspace.Water:GetChildren()) do 
       if v:IsA("RemoteEvent") and v.Name == "i" then
          if i == 29 then 
              realremote = v
          end
       end
    end
    local fressy = 100
    realremote:FireServer({chosenitem, fressy}, game:GetService("Players").LocalPlayer.Character["Left Leg"].Position, game.Workspace.conf.Value)
end
-- Ro ghoul start
if game.PlaceId == 914010731 then
local CCG = false
local Ghouls = true
local Humans = false
local Boss = false

-- lowkey keep this function
local char = function()
	return game.Players.LocalPlayer.Character
end
local Player = game:GetService'Players'.LocalPlayer
function GetChildOfType(parent,typ)
	for i,v in pairs(parent:GetChildren()) do
		if type(v) == typ or v:IsA(typ) then
			return v
		end
	end
end

function GetNPC()
	for i,v in pairs(game:GetService'Workspace'.NPCSpawns:GetChildren()) do
		if GetChildOfType(v,'Model') and GetChildOfType(v,'Model'):FindFirstChild'Humanoid' and GetChildOfType(v,'Model').Humanoid.Health > 0 then
			local npc = GetChildOfType(v,'Model')
			if CCG then
				if npc.Name:lower():find('investigator') then
					return npc
				end
			elseif Ghouls then
				if npc.Name:lower():find('aogiri') then
					return npc
				end
			elseif Humans then
				if npc.Name:lower():find('human') then
					return npc
				end
			elseif Boss then
				if v.Name == 'BossSpawns' then
					return npc
				end
			end
		end
	end
end



round = function(num)
	return math.floor(num + .5)
end

function Tp(pos)
    _G.Tp = true
	pos = pos + Vector3.new(0,3,0)
    local startpos = char().Head.CFrame
    local Distance = (pos - char().Head.Position).Magnitude
    local Skips = round(Distance/4)
    local VectorToSkip = (pos - char().Head.Position)/Skips
    local i = 0
    while i ~= Skips do
        if _G.Tp == false then
            break
        end
		pcall(function()
        char().HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        startpos = startpos + VectorToSkip
        char().HumanoidRootPart.CFrame = (startpos)
        i = i + 1
        char().HumanoidRootPart.Velocity = Vector3.new(0,0,0)
		char().HumanoidRootPart.CFrame =  char().HumanoidRootPart.CFrame
        end)
		wait()
    end
	_G.Tp = false
end

local emojipattern;
local gm = assert(getrawmetatable or debug.getmetatable)(game);
local gmn = gm.__namecall;
local gotdata = false;
gmn = hookfunction(gm.__namecall,newcclosure(function(self,...)
    local a = {...};
    if self.Name == "KeyEvent" and a[2] == "Q" and not gotdata then 
        emojipattern,gotdata = a[1],true;
        return;
    end;
    return gmn(self,...);
end));
repeat wait() until isrbxactive() == true;
keypress(81);
keyrelease(81); 
repeat wait() until emojipattern ~= nil; 
SendMessage('Remote Found');
_G.punch = function()
	pcall(function()
		game:GetService("Players").LocalPlayer.Character.Remotes.KeyEvent:FireServer(emojipattern, "Q", "Down", game:GetService("Players").LocalPlayer:GetMouse().Hit.Position)
	end)
end
_G.attack = function()
	pcall(function()
		game:GetService("Players").LocalPlayer.Character.Remotes.KeyEvent:FireServer(emojipattern, "Mouse1", "Down", game:GetService("Players").LocalPlayer:GetMouse().Hit.Position)
	end)
end
_G.equip = function()
	pcall(function()
		game:GetService("Players").LocalPlayer.Character.Remotes.KeyEvent:FireServer(emojipattern, "One", "Down", game:GetService("Players").LocalPlayer:GetMouse().Hit.Position)
	end)
end

function Equipt()
	local shouldequp = false
	if game.Players.LocalPlayer.PlayerFolder.Customization.Team.Value == 'Ghoul' then
		if char():FindFirstChild'Kagune' then
			shouldequp = true
		end
	else
		for i,v in pairs(char():GetChildren()) do
			if v:FindFirstChild'Glow' then
				shouldequp = true
			end
		end
	end
	if not shouldequp then
		_G.equip()
	end
end
local stepped;
local autofarmroghoul = false
autofarmroghoulf = function()
if autofarmroghoul  == false then
autofarmroghoul = true
Equipt()
npc = GetNPC()
stepped = game:GetService('RunService').RenderStepped:connect(function()
	if char().PrimaryPart then
		Equipt()
		if not _G.Tp then
			if npc then
				if npc:FindFirstChild'Humanoid' and npc.Humanoid.Health == 0 then
					npc = nil
				elseif not npc:FindFirstChild'Humanoid' then
					npc = nil
				end
			end
			if not npc then
				npc = GetNPC()
				SendMessage('Target: '..npc.Name)
			end
			
			if npc.Humanoid and npc.Humanoid.Health > 0 then
				if Player:DistanceFromCharacter(npc.PrimaryPart.Position) > 20 then
					Tp(npc.PrimaryPart.Position )
				else
					char():SetPrimaryPartCFrame(npc:GetPrimaryPartCFrame() * CFrame.new(0, 0.5, 5.5) * CFrame.Angles(-5,0,0))
					_G.attack()
				end
			end
		end
	end
end)
else
stepped:disconnect()
autofarmroghoul = false
end
end
end

-- Ro ghoul end
changetarget = function(fuckyay) 
targetythingy = fuckyay..""
end
local runserv,inputserv = game:GetService("RunService"),game:GetService("UserInputService");
local player = game:GetService("Players").LocalPlayer
local visible = true;
local mouse = player:GetMouse();

Togglestuff = function(t)
if globalsettings[t] == false then
	globalsettings[t] = true
else
	globalsettings[t] = false
end
end
local typey = ""
	function Steal()
	local clientIsDragging = game.ReplicatedStorage.Interaction.ClientIsDragging
	for _,StoledAh in pairs(game.Workspace.PlayerModels:GetChildren()) do
		if StoledAh:findFirstChild("Owner") and StoledAh:FindFirstChild("Type") or StoledAh:FindFirstChild("TreeClass") then
			if StoledAh.Owner.Value == game:GetService("Players")[targetythingy] then
		spawn(function()
		if StoledAh:FindFirstChild("Type") then
		if globalsettings["StealAxes"] == true then
		if StoledAh.Type.Value == "Tool" then
        StoledAh:FindFirstChild("Main")	.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
		game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
		clientIsDragging:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
		wait()
		end
		elseif globalsettings["StealItems"] == true then
		if StoledAh.Type.Value == "Items" or StoledAh.Type.Value == "Gift" then
        StoledAh:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
		game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
		clientIsDragging:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
		wait()
		end
		elseif globalsettings["StealCars"] == true then 
		if StoledAh.Type.Value == "Vehicle" then
        StoledAh:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
		game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
		clientIsDragging:FireServer(StoledAh:FindFirstChild("Main"))
		StoledAh:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
		wait()
		end
		end
		elseif StoledAh:FindFirstChild("TreeClass") then
        if globalsettings["StealWood"] == true then
	    if StoledAh:FindFirstChild("TreeClass") then
        StoledAh:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
		game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(StoledAh:FindFirstChild("WoodSection"))
		StoledAh:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
		clientIsDragging:FireServer(StoledAh:FindFirstChild("WoodSection"))
		StoledAh:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
		wait()
		end
		end
		end
		end)
		end
		end
		end
	end



harddraggerrun = function()
	if globalsettings["HardDragger"] == false then
		globalsettings["HardDragger"] = true
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.CarryItem.Parent = game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI
		game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger:Destroy()
local player = game.Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:wait()
local Humanoid = Character:WaitForChild("Humanoid")
local walkSpeed = Humanoid.WalkSpeed
local createfakedragger = Instance.new("Part")
createfakedragger.Name = "Dragger"
createfakedragger.Parent = player.PlayerGui
createfakedragger.Size = Vector3.new(0.2, 0.2, 0.2)
local dragPart = player.PlayerGui.Dragger:Clone()
player.CharacterAdded:connect(function()
	Character = player.Character
	Humanoid = Character:WaitForChild("Humanoid")
	Humanoid.Died:connect(function()
		dragPart.Parent = nil
	end)
end)
wait(1)
local dragRangeMax = 300
local dragRangeMin = 10
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local button1Down = false
local dragRange = dragRangeMax
local bodyPosition = Instance.new("BodyPosition", dragPart)
bodyPosition.maxForce = Vector3.new(1, 1, 1) * 2e99
bodyPosition.D = 400
local bodyGyro = Instance.new("BodyGyro", dragPart)
bodyGyro.maxTorque = Vector3.new(1, 1, 1) * 2e9
bodyGyro.P = 700
bodyGyro.D = 80
local rotateCFrame = CFrame.new()
local weld = Instance.new("Weld", dragPart)
local interactPermission = require(game.ReplicatedStorage.Interaction.InteractionPermission)
local clientIsDragging = game.ReplicatedStorage.Interaction.ClientIsDragging
local carryAnimationTrack
local draggingPart = false
function click()
	button1Down = true
	local targetObject = input.GetMouseTarget()
	if not canDrag(targetObject) then
		return
	end
	local mouseHit = input.GetMouseHit().p
	initializeDrag(targetObject, mouseHit)
	rotateCFrame = CFrame.new()
	carryAnimationTrack:Play(0.1, 1, 1)
	while button1Down and canDrag(targetObject) do
		local desiredPos = Character.Head.Position + (input.GetMouseHit().p - Character.Head.Position).unit * dragRange
		if part then
			desiredPos = pos
		end
		moveDrag(desiredPos)
		bodyGyro.cframe = CFrame.new(dragPart.Position, camera.CoordinateFrame.p) * rotateCFrame
		--bodyGyro.cframe = CFrame.new(dragPart.Position)
		local targParent = findHighestParent(targetObject) or targetObject
		local attemptingToSurf = false
         function findwhichclicked() 
		   for _no_,party in pairs(targParent.Parent:GetChildren()) do
		       if party.Name == "Main" or party.Name == "WoodSection" then 
			  return party.Name;
	              end
		   end
		end
	     	if player:DistanceFromCharacter(targParent.Parent[findwhichclicked()].position) > 21 then
          	   targParent.Parent[findwhichclicked()].CFrame = CFrame.new(desiredPos)
         	   game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(targParent.Parent[findwhichclicked()])
         	   targParent.Parent[findwhichclicked()].CFrame = CFrame.new(desiredPos)
        	   clientIsDragging:FireServer(targParent.Parent[findwhichclicked()])
       		   targParent.Parent[findwhichclicked()].CFrame = CFrame.new(desiredPos)
		   else
		   clientIsDragging:FireServer(targParent.Parent)
        end
		wait()
	end
	carryAnimationTrack:Stop()
	endDrag()
end
function findHighestParent(child)
	if not (child and child.Parent) or child.Parent == workspace then
		return nil
	end
	local ret = child.Parent:FindFirstChild("Owner") and child
	return findHighestParent(child.Parent) or ret
end
function clickEnded()
	button1Down = false
end
function holdDistanceChanged(dist)
	dragRange = dragRangeMin + (1 - dist) * (dragRangeMax - dragRangeMin)
end
function canDrag(targetObject)
	for _, instance in pairs(Character:GetChildren()) do
		if instance:IsA("Tool") then
			return false
		end
	end
	if not (targetObject and not targetObject.Anchored and targetObject.Parent) or not (Humanoid.Health > 0) then
		return false
	end
	if targetObject.Name == "LeafPart" then
		return false
	end
	for _, part in pairs(targetObject:GetConnectedParts()) do
		if part.Name == "HumanoidRootPart" or (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant then
			return true
		end
	end
	local originTargetObject = targetObject
	targetObject = findHighestParent(targetObject) or targetObject
	for _, part in pairs(targetObject.Parent:GetChildren()) do
		if (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant then
			return true
		end
	end
	if game.Players:GetPlayerFromCharacter(targetObject.Parent.Parent) then
		return false
	end
	bodyGyro.Parent = dragPart
	if not targetObject.Parent:FindFirstChild("Owner") then
		return otherDraggable(targetObject, originTargetObject)
	end
	if not interactPermission:UserCanInteract(player, targetObject.Parent) then
		return false
	end
	if targetObject.Parent:FindFirstChild("TreeClass") then
		return true
	end
	if targetObject.Parent:FindFirstChild("BoxItemName") then
		return true
	end
	if targetObject.Parent:FindFirstChild("PurchasedBoxItemName") then
		return true
	end
	if targetObject.Parent:FindFirstChild("Handle") then
		return true
	end
	return otherDraggable(targetObject, originTargetObject)
end
function otherDraggable(targetObject, originTargetObject)
	local draggable = targetObject and targetObject.Parent and targetObject.Parent:FindFirstChild("DraggableItem") or originTargetObject and originTargetObject.Parent and originTargetObject.Parent:FindFirstChild("DraggableItem")
	if draggable then
		if draggable:FindFirstChild("NoRotate") then
			bodyGyro.Parent = nil
		end
		return true
	end
end
function initializeDrag(targetObject, mouseHit)
	draggingPart = true
	mouse.TargetFilter = targetObject and findHighestParent(targetObject) and findHighestParent(targetObject).Parent or targetObject
	dragPart.CFrame = CFrame.new(mouseHit)
	weld.Part0 = dragPart
	weld.Part1 = targetObject
	weld.C0 = CFrame.new(mouseHit):inverse() * targetObject.CFrame
	weld.Parent = dragPart
	dragPart.Parent = workspace
end
function endDrag()
	mouse.TargetFilter = nil
	dragPart.Parent = nil
	draggingPart = false
end
local dragGuiState = ""
function interactLoop()
	while true do
		wait()
		local newState = ""
		local mouseHit = input.GetMouseHit().p
		local targetObject = input.GetMouseTarget()
		if draggingPart then
			newState = "Dragging"
		elseif canDrag(targetObject) and not button1Down then
			newState = "Mouseover"
		end
		dragGuiState = newState
		setPlatformControls()
		if dragGuiState == "" then
			player.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
			player.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
		elseif dragGuiState == "Mouseover" then
			player.PlayerGui.ItemDraggingGUI.CanDrag.Visible = true
			player.PlayerGui.ItemDraggingGUI.CanRotate.Visible = false
		elseif dragGuiState == "Dragging" then
			player.PlayerGui.ItemDraggingGUI.CanDrag.Visible = false
			player.PlayerGui.ItemDraggingGUI.CanRotate.Visible =  (not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 1)
		end
	end
end
function moveDrag(pos)
	bodyPosition.position = pos
end
local rotateSpeedReduce = 0.036
local lastRotateTick
function rotate(amount, speed)
	if not draggingPart then
		if not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 2 then
			Humanoid.WalkSpeed = walkSpeed
		end
		return
	end
	if Humanoid.WalkSpeed > 1 then
		walkSpeed = Humanoid.WalkSpeed
		Humanoid.WalkSpeed = 0
	end
	lastRotateTick = tick()
	local thisRotateTick = lastRotateTick
	while draggingPart and 0 < amount.magnitude and lastRotateTick == thisRotateTick do
		rotateCFrame = CFrame.Angles(0, -amount.X * rotateSpeedReduce, 0) * CFrame.Angles(amount.Y * rotateSpeedReduce, 0, 0) * rotateCFrame
		wait()
	end
	if amount.magnitude == 0 and (not player:FindFirstChild("IsChatting") or player.IsChatting.Value < 2) then
		Humanoid.WalkSpeed = walkSpeed
	end
end
wait(1)
carryAnimationTrack = Humanoid:LoadAnimation(player.PlayerGui.ItemDraggingGUI:WaitForChild("CarryItem"))
input = require(player.PlayerGui:WaitForChild("Scripts"):WaitForChild("UserInput"))
input.ClickBegan(click, holdDistanceChanged)
input.ClickEnded(clickEnded)
input.Rotate(rotate)
function setPlatformControls()
	if input.IsGamePadEnabled() then
		player.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.Image = player.PlayerGui.ItemDraggingGUI.PlatformButton.Gamepad.Value
		player.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.KeyLabel.Text = ""
		player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.Image = player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.Gamepad.Value
		player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.Text = ""
	else
		player.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.Image = player.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.PC.Value
		player.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.KeyLabel.Text = "CLICK"
		player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.Image = player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.PC.Value
		player.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.Text = "SHIFT + WASD"
	end
end
interactLoop()

	end
end

toggleaimbot = function()
	if globalsettings["AimbotToggle"] == false then
		globalsettings["AimbotToggle"] = true 
	else
		globalsettings["AimbotToggle"] = false
	end
end

toggleffa = function()
	if globalsettings["Ffa"] == false then
		globalsettings["Ffa"] = true 
	else
		globalsettings["Ffa"] = false
	end
end

togglevisibility = function()
	if globalsettings["VisibiltyCheck"] == false then
		globalsettings["VisibiltyCheck"] = true 
	else
		globalsettings["VisibiltyCheck"] = false
	end
end

togglebacktrack = function()
	if globalsettings["Backtrack"] == false then
		globalsettings["Backtrack"] = true 
	else
		globalsettings["Backtrack"] = false
	end
end
openspawnitem = function()
local b = gui:FindFirstChild("SpawnItems") or gui:FindFirstChild("SpawnItemsinvisb")
	if b.Visible == false then
		b.Name = "SpawnItems"
		b.Visible = true
	else
		b.Name = "SpawnItemsinvisb"
		b.Visible = false
	end
end
opencutwood = function()
local b = gui:FindFirstChild("LT2Cut") or gui:FindFirstChild("LT2Cutinvisb")
	if b.Visible == false then
		b.Name = "LT2Cut"
		b.Visible = true
	else
		b.Name = "LT2Cutinvisb"
		b.Visible = false
	end
end

openautobuy = function()
	local b = gui:FindFirstChild("LT2AutoBuy") or gui:FindFirstChild("LT2AutoBuyinvisb")
	if b.Visible == false then
		b.Name = "LT2AutoBuy"
		b.Visible = true
	else
		b.Name = "LT2AutoBuyinvisb"
		b.Visible = false
	end
end

opensteal = function()
	local b = gui:FindFirstChild("LT2Steal") or gui:FindFirstChild("LT2Stealinvisb")
	if b.Visible == false then
		b.Name = "LT2Steal"
		b.Visible = true
	else
		b.Name = "LT2Stealinvisb"
		b.Visible = false
	end
end
autobuy = function(item)
local iretem = nil
iretem = item
one = false
runbuyremote = function(arg)
print(currentNPC)
local Arguments = {
        [1] = {
            ["Character"] = Workspace.Stores.WoodRUs.Thom,
            ["Name"] = "Thom",
            ["ID"] = currentNPC,
            ["Dialog"] = Workspace.Stores.WoodRUs.Thom.Dialog
        },
        [2] = arg
}
game.ReplicatedStorage.NPCDialog['PlayerChatted']:InvokeServer(unpack(Arguments))
end
teleportitem = function()
for _, Item in pairs(workspace.PlayerModels:GetChildren()) do
   if Item:IsA("Model") then
       if Item.Name == iretem.." Purchased by "..game.Players.LocalPlayer.Name  then
	     local magnitude = (Workspace.Stores.WoodRUs.Thom.HumanoidRootPart.Position - Item.Main.Position).magnitude
		 if magnitude <= 25 then
			 spawn(function ()
			 for i= 1, 5 do
							     Item:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
			    Item:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,10,0))
			    game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Item:FindFirstChild("Main"))
				game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Item)
			     			     Item:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
				 Item:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,5,0))
			    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Item:FindFirstChild("Main"))
				game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Item)
			     Item:FindFirstChild("Main").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
				 Item:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position + Vector3.new(0,2,0))
		 wait()
		 end
		 end)
	wait()
	one = false
      end
	  end
   end
end
end
local function buy()
runbuyremote("Initiate")
wait()
game.ReplicatedStorage.NPCDialog['SetChattingValue']:InvokeServer(2)
runbuyremote("ConfirmPurchase")
wait()
game.ReplicatedStorage.NPCDialog['SetChattingValue']:InvokeServer(2)
runbuyremote("EndChat")
wait()
teleportitem()
game.ReplicatedStorage.NPCDialog['SetChattingValue']:InvokeServer(0)
game:GetService("RunService").Heartbeat:wait()
game.ReplicatedStorage.NPCDialog['SetChattingValue']:InvokeServer(1)
game:GetService("RunService").Heartbeat:wait()
game.ReplicatedStorage.NPCDialog['SetChattingValue']:InvokeServer(0)
end

for _, Item in pairs(workspace.Stores:GetChildren()) do
      if Item:FindFirstChild(iretem) then
		  local itemy = Item:FindFirstChild(iretem)
	if one == false then
	 one = true
	 Item:FindFirstChild(iretem).Main.CFrame = CFrame.new(Vector3.new(268.872101, 2.19999981, 67.3221741))
     game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Item:FindFirstChild(iretem))
	 game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Item:FindFirstChild(iretem).Main)
	 for no,obj in pairs(Item:FindFirstChild(iretem):GetChildren()) do 
		game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(obj)
	end
	game:GetService("RunService").Heartbeat:wait()
	 Item:FindFirstChild(iretem).Main.CFrame = CFrame.new(Vector3.new(268.872101, 2.19999981, 67.3221741))
	 game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Item:FindFirstChild(iretem))
	 game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Item:FindFirstChild(iretem).Main)
	 	 for no,obj in pairs(Item:FindFirstChild(iretem):GetChildren()) do 
		game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Item:FindFirstChild(obj))
	end
	  Item:FindFirstChild(iretem).Main.CFrame = CFrame.new(Vector3.new(268.872101, 2.19999981, 67.3221741))
	 wait(0.5)
	  buy()
      end
   end
end
end
sellallwood = function()
for _, Log in pairs(workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1, 6) == "Loose_" and Log:findFirstChild("Owner") then
            if Log.Owner.Value == game.Players.LocalPlayer then
                for i,v in pairs(Log:GetChildren()) do
                    if v.Name=="WoodSection" then
						spawn(function()
						for i=1, 4 do
                                v.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(90),0,0)
			                    game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Log:FindFirstChild("WoodSection"))
				                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Log)
				                 v.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(90),0,0)
			                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log:FindFirstChild("WoodSection"))
				                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log)
				                v.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(90),0,0)
					      wait()
						  end
						end)
					end
                end
            end
        end
    end
end
woodselected = nil
local cutwood = true
local trees = {
	{"Generic", false},
	{"Oak", false},
	{"Koa", false},
	{"Elm", false},
	{"Walnut", false},
	{"Cherry", false},
	{"Birch", false},
	{"Fir", false},
	{"Pine", false},
	{"Volcano", false},
	{"GreenSwampy", false},
	{"CaveCrawler", false},
	{"GoldSwampy", false},
	{"Palm", false},
	{"SnowGlow", false},
	{"Phantom_Wood", false}
}

owo = function(Height,Tool,Wood)
	for i, v in pairs(game.Workspace:GetChildren()) do
	if v.Name == "TreeRegion" then
	for a, b in pairs(v:GetChildren()) do
	if b:FindFirstChild("TreeClass") then
	if b.TreeClass.Value == Wood then
		if game:GetService("Players").LocalPlayer:DistanceFromCharacter(b.WoodSection.Position) <= 25 then
	game.ReplicatedStorage.Interaction.RemoteProxy:FireServer(b.CutEvent,{
	["cuttingClass"] = "Axe",
	["cooldown"] = 0,
	["hitPoints"] = HitPoints[Tool.ToolName.Value],
	["sectionId"] = 1,
	["tool"] = Tool,
	["faceVector"] = Vector3.new(-1,0,0),
	["height"] = Height})
		end
	end
	end
	end
	end
end
end

poopyd = function(Tool,Woody)
	for i, v in pairs(game.Workspace:GetChildren()) do
	if v.Name == "TreeRegion" then
	for a, b in pairs(v:GetChildren()) do
	if b:FindFirstChild("TreeClass") then
	if b.TreeClass.Value == Woody or b.TreeClass.Value == "Phantom" and Tool.ToolName.Value == "EndTimesAxe" then
	if game:GetService("Players").LocalPlayer:DistanceFromCharacter(b.WoodSection.Position) <= 25 then
		while  not b:FindFirstChild("RootCut") or not b:FindFirstChild("InnerWood") do
		    owo(1,Tool,Woody)
			owo(1,Tool,Woody)
			owo(1,Tool,Woody)
		    game:GetService("RunService").Heartbeat:wait()
		    end
		for _, Log in pairs(game.Workspace.LogModels:GetChildren()) do
		   if Log.Name:sub(1, 6) == "Loose_" and Log:findFirstChild("Owner") then
			  if Log.Owner.Value == game.Players.LocalPlayer and  game:GetService("Players").LocalPlayer:DistanceFromCharacter(Log.WoodSection.Position) <= 15 then
				  --game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
			    for i=1, 5 do
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastpos)
							     Log:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position)
			    Log:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position)
			    game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Log:FindFirstChild("WoodSection"))
				game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Log)
			    Log:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position)
				 Log:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position)
			   game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log:FindFirstChild("WoodSection"))
				game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log)
			     Log:FindFirstChild("WoodSection").CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position)
				 Log:MoveTo(game:GetService("Players").LocalPlayer.Character.Head.Position)
			  wait()
			  end
				end
		        end
			end
		end
	end
	end
	end
	end
	end
end
cut = function(Texty)
				for _,d in pairs(trees) do
						if d[1] == Texty then
				           for _x,xd in pairs(game.Workspace:GetChildren()) do
						            if not GetAxe() then
							         game.StarterGui:SetCore("SendNotification", {
	                                   Title =  "Hatchet not found :(";
	                                   Text = "";
	                                   Duration = 5;
	                                  })  
	 					              return
						            end
						            local axe = GetAxe()
						            if axe.ToolName.Value == "BasicHatchet" then
						            else
						            return
						            end 
							            if xd.Name == "TreeRegion" then
								            for a, b in pairs(xd:GetChildren()) do
								            if b:FindFirstChild("TreeClass") then
								            if b.TreeClass.Value == d[1] and not b:FindFirstChild("InnerWood") then
								            lastpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
								            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(b.WoodSection.Position + Vector3.new(0,5,0 ))
											--game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
								            game:GetService("RunService").Heartbeat:wait()
											poopyd(GetAxe(),b.TreeClass.Value)
								  return
							   end
						    end
	  					end
					end
				end
			end
		end
end
local maketextbox = function(namey, txt, parenty, func, args)
newobj("Frame", {
Name = namey,
Parent = parenty,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
LayoutOrder = 3,
Size = UDim2.new(1, 0, 0, 28)
});

newobj("TextBox", {
Name = "TextBox";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = Color3.new(1, 1, 1);
BackgroundTransparency = 1;
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 7;
Font = Enum.Font.Gotham;
PlaceholderText = txt;
TextColor3 = Color3.new(1, 1, 1);
TextSize = 15;
});

newobj("ImageLabel",{
Name = "optionbase",
Parent = parenty:FindFirstChild(namey),
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 6,
Image = "rbxassetid://2884857737",
ImageColor3 = module.newrgb(19, 16, 25),
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(6, 6, 494, 494)
});

newobj("ImageLabel", {
Name = "optionbaseglow",
Parent = parenty:FindFirstChild(namey).optionbase,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, -14, 0, -14),
Size = UDim2.new(1, 28, 1, 28),
ZIndex = 5,
Image = "rbxassetid://2884762344",
ImageColor3 = module.newrgb(19, 16, 25),
ImageTransparency = 0.30000001192093,
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(21, 21, 479, 479)
});
local base = parenty:FindFirstChild(namey).optionbase
local baseglow = parenty:FindFirstChild(namey).optionbase.optionbaseglow
local textthingy = parenty:FindFirstChild(namey).TextBox
textthingy.FocusLost:connect(function(Enter)
    if Enter then
		if textthingy.Text == "" then 
		return
		end
		func(unpack(args))
        module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		wait(module.tweenspeed);
		
		module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
    end
end)
end

local makebutton = function(buttonname, buttontext, Parentbutton, func, args)
newobj("Frame", {
Name = buttonname,
Parent = Parentbutton,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
LayoutOrder = 3,
Size = UDim2.new(1, 0, 0, 28)
});
local holder = Parentbutton:FindFirstChild(buttonname);
newobj("TextLabel", {
Name = "optiontitle",
Parent = Parentbutton:FindFirstChild(buttonname),
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, 7, 0.5, -12),
Size = UDim2.new(1, -7, 0, 24),
ZIndex = 12,
Font = Enum.Font.Gotham,
Text = buttontext,
TextColor3 = module.newrgb(255,255,255),
TextSize = 15,
TextXAlignment = Enum.TextXAlignment.Left
});

newobj("TextLabel",{
Name = "optiontitledrop",
Parent = Parentbutton:FindFirstChild(buttonname).optiontitle,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, 0, 0, 1),
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 11,
Font = Enum.Font.Gotham,
Text = buttontext,
TextColor3 = module.newrgb(255,255,255),
TextSize = 15,
TextTransparency = 0.80000001192093,
TextXAlignment = Enum.TextXAlignment.Left
});

newobj("ImageLabel",{
Name = "optionbase",
Parent = Parentbutton:FindFirstChild(buttonname),
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 6,
Image = "rbxassetid://2884857737",
ImageColor3 = module.newrgb(19, 16, 25),
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(6, 6, 494, 494)
});

newobj("ImageLabel", {
Name = "optionbaseglow",
Parent = Parentbutton:FindFirstChild(buttonname).optionbase,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, -14, 0, -14),
Size = UDim2.new(1, 28, 1, 28),
ZIndex = 5,
Image = "rbxassetid://2884762344",
ImageColor3 = module.newrgb(19, 16, 25),
ImageTransparency = 0.30000001192093,
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(21, 21, 479, 479)
});
newobj("TextButton", {
Name = "actualbutton",
Parent = Parentbutton:FindFirstChild(buttonname),
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 16,
AutoButtonColor = false,
Font = Enum.Font.Gotham,
Text = "",
TextColor3 = module.newrgb(0,0,0),
TextSize = 1,
TextTransparency = 1,
TextWrapped = true
});

newobj("ImageLabel", {
Name = "success",
Parent = Parentbutton:FindFirstChild(buttonname),
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(1, -28, 0.5, -12),
Size = UDim2.new(0, 24, 0, 24),
ZIndex = 14,
Image = "rbxassetid://2978804676",
ImageColor3 = module.newrgb(239, 239, 239),
ImageTransparency = 1,
SliceCenter = Rect.new(17, 17, 19, 19)
});

newobj("ImageLabel", {
Name = "successdrop",
Parent = Parentbutton:FindFirstChild(buttonname).success,
BackgroundColor3 = module.newrgb(255,255,255),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Position = UDim2.new(0, 0, 0, 1),
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 13,
Image = "rbxassetid://2978804676",
ImageColor3 = module.newrgb(239, 239, 239),
ImageTransparency = 0.80000001192093,
SliceCenter = Rect.new(17, 17, 19, 19)
});

local base,button = holder["optionbase"],holder["actualbutton"];
local baseglow = base["optionbaseglow"];
local success = holder["success"];
local successdrop = success["successdrop"];
local buttonstatus = "click"; --> IMPORTANT

button.MouseButton1Down:connect(function()
	if buttonstatus == "click" then
		module.newtween(base,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(success,{ImageTransparency = 0.61},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		buttonstatus = "ready";
	end;
end);

button.MouseButton1Up:connect(function()
	if buttonstatus == "ready" then
		buttonstatus = "delay";
		
		module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(success,{ImageTransparency = 0},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		wait(module.tweenspeed);
		
		module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(success,{ImageTransparency = 1},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(successdrop,{ImageTransparency = 0.8},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		if args ~= nil then 
          func(unpack(args))
		   else
		   loadstring(func.."()")()
		end
		buttonstatus = "click";
	end;
end);
end
local makeslider = function(namey,texty,defvalue,Thingy,max,parenty)
newobj("Frame", {
Name = namey;
Parent = parenty;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
LayoutOrder = 2;
Size = UDim2.new(1, 0, 0, 53);
});

newobj("Frame", {
Name = "sliderholder";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
ZIndex = 12;
Position = UDim2.new(0, 7, 1, -31);
Size = UDim2.new(1, -14, 0, 28);
});

newobj("ImageButton", {
Name = "slider";
Parent = parenty:FindFirstChild(namey).sliderholder;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0.5, -2, 0.5, -5);
Size = UDim2.new(0, 4, 0, 12);
ZIndex = 10;
Image = "rbxassetid://2956182859";
ImageColor3 = module.newrgb(239, 239, 239);
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(2, 2, 498, 498);
});

newobj("ImageLabel", {
Name = "sliderdrop";
Parent = parenty:FindFirstChild(namey).sliderholder.slider;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 9;
Image = "rbxassetid://2956182859";
ImageColor3 = module.newrgb(239, 239, 239);
ImageTransparency = 0.80000001192093;
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(2, 2, 498, 498);
});

newobj("ImageLabel", {
Name = "sliderbar";
Parent = parenty:FindFirstChild(namey).sliderholder;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0.5, 0);
Size = UDim2.new(1, 0, 0, 2);
ZIndex = 8;
Image = "rbxassetid://2956183284";
ImageColor3 = module.newrgb(126, 124, 129);
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(1, 1, 499, 499);
});

newobj("ImageLabel", {
Name = "sliderbardrop";
Parent =  parenty:FindFirstChild(namey).sliderholder.sliderbar;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 7;
Image = "rbxassetid://2956183284";
ImageColor3 = module.newrgb(126, 124, 129);
ImageTransparency = 0.80000001192093;
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(1, 1, 499, 499);
});

newobj("ImageLabel", {
Name = "optionbase";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 6;
Image = "rbxassetid://2884857737";
ImageColor3 = module.newrgb(19, 16, 25);
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(6, 6, 494, 494);
});

newobj("ImageLabel", {
Name = "optionbaseglow";
Parent = parenty:FindFirstChild(namey).optionbase;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, -14, 0, -14);
Size = UDim2.new(1, 28, 1, 28);
ZIndex = 5;
Image = "rbxassetid://2884762344";
ImageColor3 = module.newrgb(19, 16, 25);
ImageTransparency = 0.30000001192093;
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(21, 21, 479, 479);
});

newobj("TextLabel", {
Name = "optionsens";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(1, -27, 0, 3);
Size = UDim2.new(0, 20, 0, 24);
ZIndex = 12;
Font = Enum.Font.Gotham;
Text = defvalue[Thingy];
TextColor3 = module.newrgb(133, 131, 136);
TextSize = 15;
TextXAlignment = Enum.TextXAlignment.Right;
});

newobj("TextLabel", {
Name = "optionsensdrop";
Parent = parenty:FindFirstChild(namey).optionsens;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 11;
Font = Enum.Font.Gotham;
Text = defvalue[Thingy];
TextColor3 = module.newrgb(133, 131, 136);
TextSize = 15;
TextTransparency = 0.80000001192093;
TextXAlignment = Enum.TextXAlignment.Right;
});

newobj("TextLabel", {
Name = "optiontitle";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 7, 0, 2);
Size = UDim2.new(1, -34, 0, 24);
ZIndex = 12;
Font = Enum.Font.Gotham;
Text = texty;
TextColor3 = module.newrgb(255, 255, 255);
TextSize = 15;
TextXAlignment = Enum.TextXAlignment.Left;
});

newobj("TextLabel", {
Name = "optiontitledrop";
Parent = parenty:FindFirstChild(namey).optiontitle;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 11;
Font = Enum.Font.Gotham;
Text = texty;
TextColor3 = module.newrgb(255, 255, 255);
TextSize = 15;
TextTransparency = 0.80000001192093;
TextXAlignment = Enum.TextXAlignment.Left;
});

local holder = parenty:FindFirstChild(namey);
local base,slider = holder["optionbase"],holder["sliderholder"];
local baseglow = base["optionbaseglow"];

local bar = slider["sliderbar"];
local sens = holder["optionsens"];
local sensdrop = sens["optionsensdrop"];
local button = slider["slider"];
local buttonstatus = "ready";
button.MouseButton1Down:Connect(function()
	if buttonstatus == "ready" then
		
		buttonstatus = slider;
		module.newtween(base,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		spawn(function()
			runserv.Heartbeat:connect(function()
				if slider == buttonstatus then
					button.Position = UDim2.new(0,(mouse.X-bar.AbsolutePosition.X),0.5,-5);
			
					if button.Position.X.Offset < 0 then
						button.Position = UDim2.new(0,0,0.5,-5);
					elseif button.Position.X.Offset+button.Size.X.Offset > bar.AbsoluteSize.X then
						button.Position = UDim2.new(0,(bar.AbsoluteSize.X-button.Size.X.Offset),0.5,-5);
					end
			
	    			defvalue[Thingy] = (button.AbsolutePosition.X-bar.AbsolutePosition.X)/(bar.AbsoluteSize.X-button.Size.X.Offset)*max;
	print(defvalue[Thingy])
	    			sens.Text = string.sub(tostring(defvalue[Thingy]),1,5);
	    			sensdrop.Text = string.sub(tostring(defvalue[Thingy]),1,5);
	
				end;
			end);
		end);
	
	end;
end);


inputserv.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and slider == buttonstatus then
		buttonstatus = "delay";
		
		module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		wait(module.tweenspeed);
		
		module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		buttonstatus = "ready";
	end;
end)
end

local makeframe = function(namey,texty,pos,parenty, visiblilty)
	newobj("TextButton", {
    Name = namey;
	Parent = parenty;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = pos;
	Size = UDim2.new(0, 184, 0, 32);
	ZIndex = 30;
	Font = Enum.Font.Gotham;
	Text = "";
	Visible = visiblilty;
	TextColor3 = module.newrgb(0, 0, 0);
	TextSize = 1;
	TextTransparency = 1;
	});
	
	newobj("Frame", {
	Name = "holder";
	Parent = parenty:FindFirstChild(namey);
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Size = UDim2.new(1, 0, 0, 210);
	});
	
	newobj("Frame", {
	Name = "contents";
	Parent = parenty:FindFirstChild(namey).holder;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	ZIndex = 2;
	ClipsDescendants = true;
	Position = UDim2.new(0, 0, 0, 32);
	Size = UDim2.new(1, 0, 1, -32);
	});
	
	newobj("ScrollingFrame", {
	Name = "optionscroll";
	Parent = parenty:FindFirstChild(namey).holder.contents;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	ClipsDescendants = false;
	Position = UDim2.new(0, 13, 0, 13);
	Size = UDim2.new(1, -26, 1, -13);
	BottomImage = "";
	CanvasSize = UDim2.new(0, 0, 0, 0);
	MidImage = "";
	ScrollBarThickness = 0;
	TopImage = "";
	});
	
	newobj("UIListLayout", {
	Name = "optionlayout";
	Parent = parenty:FindFirstChild(namey).holder.contents.optionscroll;
	SortOrder = Enum.SortOrder.LayoutOrder;
	Padding = UDim.new(0, 11);
	});
	
	newobj("ImageLabel", {
	Name = "topbar";
	Parent = parenty:FindFirstChild(namey).holder;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Size = UDim2.new(1, 0, 0, 32);
	ZIndex = 20;
	Image = "rbxassetid://2949853693";
	ImageColor3 = module.newrgb(19, 16, 25);
	ScaleType = Enum.ScaleType.Slice;
	SliceCenter = Rect.new(6, 6, 494, 494);
	});
	
	newobj("Frame", {
	Name = "topbarholder";
	Parent = parenty:FindFirstChild(namey).holder.topbar;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 0, 0, 3);
	Size = UDim2.new(1, 0, 0, 28);
	});
	
	newobj("ImageLabel", {
	Name = "minmax";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarholder;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 6, 0.5, -12);
	Size = UDim2.new(0, 24, 0, 24);
	ZIndex = 22;
	Image = "rbxassetid://2949864066";
	});
	
	newobj("TextButton", {
	Name = "minmaxbutton";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarholder.minmax;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Size = UDim2.new(1, 0, 1, 0);
	ZIndex = 31;
	Font = Enum.Font.Gotham;
	Text = "";
	TextColor3 = module.newrgb(0, 0, 0);
	TextSize = 1;
	TextTransparency = 1;
	});
	
	newobj("ImageLabel", {
	Name = "minmaxdrop";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarholder.minmax;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 0, 0, 1);
	Size = UDim2.new(1, 0, 1, 0);
	ZIndex = 21;
	Image = "rbxassetid://2949864066";
	ImageTransparency = 0.80000001192093;
	});
	
	newobj("TextLabel", {
	Name = "title";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarholder;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 32, 0.5, -12);
	Size = UDim2.new(1, -45, 0, 24);
	ZIndex = 22;
	Font = Enum.Font.GothamSemibold;
	Text = texty;
	TextColor3 = module.newrgb(255, 255, 255);
	TextSize = 15;
	TextXAlignment = Enum.TextXAlignment.Left;
	});
	
	newobj("TextLabel", {
	Name = "titledrop";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarholder.title;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 0, 0, 1);
	Size = UDim2.new(1, 0, 1, 0);
	ZIndex = 21;
	Font = Enum.Font.GothamSemibold;
	Text = texty;
	TextColor3 = module.newrgb(255, 255, 255);
	TextSize = 15;
	TextTransparency = 0.80000001192093;
	TextXAlignment = Enum.TextXAlignment.Left;
	});
	
	newobj("Frame", {
	Name = "topbarclips";
	Parent = parenty:FindFirstChild(namey).holder.topbar;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	ClipsDescendants = true;
	Position = UDim2.new(0, 0, 0, 1);
	Size = UDim2.new(1, 0, 1, 13);
	});
	
	newobj("ImageLabel", {
	Name = "fadeobjects";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarclips;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, 1, 1, -14);
	Size = UDim2.new(1, -2, 0, 13);
	ZIndex = 18;
	Image = "rbxassetid://2956249613";
	ImageColor3 = module.newrgb(6, 5, 10);
	});
	
	newobj("ImageLabel", {
	Name = "topbarglow";
	Parent = parenty:FindFirstChild(namey).holder.topbar.topbarclips;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, -15, 0, 0);
	Size = UDim2.new(1, 30, 1, 0);
	ZIndex = 19;
	Image = "rbxassetid://2949901812";
	ImageColor3 = module.newrgb(19, 16, 25);
	ImageTransparency = 0.30000001192093;
	ScaleType = Enum.ScaleType.Slice;
	SliceCenter = Rect.new(6, 6, 494, 479);
	});
	
	newobj("ImageLabel", {
	Name = "base";
	Parent = parenty:FindFirstChild(namey).holder;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Size = UDim2.new(1, 0, 1, 0);
	Image = "rbxassetid://2884857737";
	ImageColor3 = module.newrgb(6, 5, 10);
	ScaleType = Enum.ScaleType.Slice;
	SliceCenter = Rect.new(6, 6, 494, 494);
	});
	
	newobj("ImageLabel", {
	Name = "baseglow";
	Parent = parenty:FindFirstChild(namey).holder.base;
	BackgroundColor3 = module.newrgb(1, 1, 1);
	BackgroundTransparency = 1;
	BorderSizePixel = 0;
	Position = UDim2.new(0, -14, 0, -14);
	Size = UDim2.new(1, 28, 1, 28);
	ZIndex = 0;
	Image = "rbxassetid://2884762344";
	ImageColor3 = module.newrgb(6, 5, 10);
	ImageTransparency = 0.30000001192093;
	ScaleType = Enum.ScaleType.Slice;
	SliceCenter = Rect.new(21, 21, 479, 479);
	});
	local shut = false;
	local holder = parenty:FindFirstChild(namey).holder
	local minmax = parenty:FindFirstChild(namey).holder.topbar.topbarholder.minmax;
local minmaxbutton,minmaxdrop = minmax.minmaxbutton,minmax.minmaxdrop;
local topbarglow,fadeobjects = parenty:FindFirstChild(namey).holder.topbar.topbarclips.topbarglow,parenty:FindFirstChild(namey).holder.topbar.topbarclips.fadeobjects;
minmaxbutton.MouseButton1Up:connect(function()
	if shut == false and mousedown then
		shut = "delay";
		
		minmax.Rotation = 0;
		module.newtween(minmax,{Rotation = 180,ImageTransparency = 0},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(minmaxdrop,{ImageTransparency = 0.8},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		module.newtween(fadeobjects,{ImageTransparency = 1},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		fadeobjects.Name = "fadeobjectsinvis";
		module.newtween(topbarglow,{ImageTransparency = 1},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		topbarglow.Name = "topbarglowinvis";
		
		module.newtween(holder,{Size = UDim2.new(1,0,0,39)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		shut = true;
	elseif shut == true and mousedown then
		shut = "delay";
		
		module.newtween(minmax,{Rotation = 360,ImageTransparency = 0},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(minmaxdrop,{ImageTransparency = 0.8},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		module.newtween(fadeobjects,{ImageTransparency = 0},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		fadeobjects.Name = "fadeobjects";
		module.newtween(topbarglow,{ImageTransparency = 0.3},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		topbarglow.Name = "topbarglow";
		
		module.newtween(holder,{Size = UDim2.new(1,0,0,210)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		wait(module.tweenspeed);
		
		shut = false;
	end;
	mousedown = false;
end);

minmaxbutton.MouseButton1Down:connect(function()
	if shut ~= "delay" then
		mousedown = true;
		if visible == true then
			module.newtween(minmax,{ImageTransparency = 0.61},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
			module.newtween(minmaxdrop,{ImageTransparency = 0.96},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		end;
	end;
end);

minmaxbutton.MouseLeave:connect(function()
	if visible and mousedown then
		module.newtween(minmax,{ImageTransparency = 0},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(minmaxdrop,{ImageTransparency = 0.8},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
	end;
	mousedown = false;
end);

local dragging = false
local draggable = parenty:FindFirstChild(namey)
draggable.MouseButton1Down:connect(function()
	dragging = true;
end);
inputserv.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false;
	end;
end);
spawn(function()
	local oldx,oldy,newp,drag;
	runserv.Heartbeat:connect(function()
		if dragging and visible then
			if newp ~= UDim2.new(0,mouse.X-oldx,0,mouse.Y-oldy) then
				newp = UDim2.new(0,mouse.X-oldx,0,mouse.Y-oldy);
				ypcall(function()drag:Cancel()end);
				drag = module.newtween(draggable,{Position = newp},module.tweenspeed*(module.tweenspeed*(1+module.tweenspeed)),Enum.EasingStyle.Linear,Enum.EasingDirection.In);
			end;
		elseif not dragging and visible then
			oldx,oldy = mouse.X-draggable.AbsolutePosition.X,mouse.Y-draggable.AbsolutePosition.Y;
		end;
	end);
end);
end

local makecheckbox = function(namey, texty, parenty, func, args)
	newobj("Frame", {
Name = namey;
Parent = parenty;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Size = UDim2.new(1, 0, 0, 28);
});

newobj("ImageLabel", {
Name = "boxicon";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(1, -28, 0.5, -12);
Size = UDim2.new(0, 24, 0, 24);
ZIndex = 14;
Image = "rbxassetid://2893818227";
ImageColor3 = module.newrgb(239, 239, 239);
SliceCenter = Rect.new(17, 17, 19, 19);
});

newobj("ImageLabel", {
Name = "boxdrop";
Parent = parenty:FindFirstChild(namey).boxicon;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 13;
Image = "rbxassetid://2893818227";
ImageColor3 = module.newrgb(239, 239, 239);
ImageTransparency = 0.80000001192093;
SliceCenter = Rect.new(17, 17, 19, 19);
});

newobj("ImageLabel", {
Name = "checkboxinvis";
Parent = parenty:FindFirstChild(namey).boxicon;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 15;
Image = "rbxassetid://2893818613";
ImageColor3 = module.newrgb(239, 239, 239);
SliceCenter = Rect.new(17, 17, 19, 19);
});

newobj("TextButton", {
Name = "checkbutton";
Parent = parenty:FindFirstChild(namey).boxicon;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 16;
AutoButtonColor = false;
Font = Enum.Font.Gotham;
Text = "";
TextColor3 = module.newrgb(0, 0, 0);
TextSize = 1;
TextTransparency = 1;
TextWrapped = true;
});

newobj("ImageLabel", {
Name = "optionbase";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 6;
Image = "rbxassetid://2884857737";
ImageColor3 = module.newrgb(19, 16, 25);
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(6, 6, 494, 494);
});

newobj("ImageLabel", {
Name = "optionbaseglow";
Parent = parenty:FindFirstChild(namey).optionbase;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, -14, 0, -14);
Size = UDim2.new(1, 28, 1, 28);
ZIndex = 5;
Image = "rbxassetid://2884762344";
ImageColor3 = module.newrgb(19, 16, 25);
ImageTransparency = 0.30000001192093;
ScaleType = Enum.ScaleType.Slice;
SliceCenter = Rect.new(21, 21, 479, 479);
});

newobj("TextLabel", {
Name = "optiontitle";
Parent = parenty:FindFirstChild(namey);
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 7, 0.5, -12);
Size = UDim2.new(1, -34, 0, 24);
ZIndex = 12;
Font = Enum.Font.Gotham;
Text = texty;
TextColor3 = module.newrgb(255, 255, 255);
TextSize = 15;
TextXAlignment = Enum.TextXAlignment.Left;
});

newobj("TextLabel", {
Name = "optiontitledrop";
Parent = parenty:FindFirstChild(namey).optiontitle;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
Position = UDim2.new(0, 0, 0, 1);
Size = UDim2.new(1, 0, 1, 0);
ZIndex = 11;
Font = Enum.Font.Gotham;
Text = texty;
TextColor3 = module.newrgb(255, 255, 255);
TextSize = 15;
TextTransparency = 0.80000001192093;
TextXAlignment = Enum.TextXAlignment.Left;
});

local holder = parenty:FindFirstChild(namey);
local base,boxicon = holder["optionbase"],holder["boxicon"];
local baseglow = base["optionbaseglow"];

local button = boxicon["checkbutton"];
local boxdrop,checkbox = boxicon["boxdrop"],boxicon["checkboxinvis"];

local buttonstatus = "click"; --> IMPORTANT
module.newtween(checkbox,{ImageTransparency = 1},module.tweenspeed*1.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In);
button.MouseButton1Down:connect(function()
	if buttonstatus == "click" then
		module.newtween(base,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(checkbox,{ImageTransparency = 0.61},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		buttonstatus = "ready";
	end;
end);

button.MouseButton1Up:Connect(function()
	if buttonstatus == "ready" then
		buttonstatus = "delay";
		
		module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		if checkbox.Name == "checkboxinvis" then
			checkbox.Name = "checkbox";
			module.newtween(checkbox,{ImageTransparency = 0},module.tweenspeed*1.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out);
		else
			checkbox.Name = "checkboxinvis";
			module.newtween(checkbox,{ImageTransparency = 1},module.tweenspeed*1.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In);
		end;
		
		wait(module.tweenspeed);
		
		module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		func(unpack(args))
		buttonstatus = "click"
	end;
end);
end
removebutton = function(p, n)
    if p:FindFirstChild(n) then 
		p:FindFirstChild(n):Destroy()
	end
end

makeframe("Main", "Main Menu",UDim2.new(0, 16,0, 16), gui, true)
makeframe("HotKeysinvisb", "Keys",UDim2.new(0, 16,0, 764), gui, false)
--makecheckbox("AimbotCheckbox", "Aimbot", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"Aiminvisb"})
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("damageNums") then
makeframe("dqinvisb", "Dungeon Quest", UDim2.new(0, 404,0, 16),gui,false) 
makecheckbox("autofarmdq", "Auto farm", gui:FindFirstChild("dqinvisb").holder.contents.optionscroll, autofarmdq, {"Gay"})
makecheckbox("dqcheckbox", "Dungeon Quest", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"dqinvisb"})
end
if game.PlaceId == 171391948 then 
makeframe("vsinvisb", "Vehicle simulator", UDim2.new(0, 404,0, 16),gui,false)
makebutton("tptocrate", "Tp to crate", gui:FindFirstChild("vsinvisb").holder.contents.optionscroll, "tptocrate")
makecheckbox("vscheckbox", "Vehicle simulator", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"vsinvisb"})
elseif game.PlaceId == 404729070 then 
makeframe("treelandsinvisb", "Tree lands", UDim2.new(0, 404,0, 16),gui,false)
makebutton("spawnfruit", "Spawn fruit", gui:FindFirstChild("treelandsinvisb").holder.contents.optionscroll, "spawnfruit")
makebutton("dupefruit", "Dupe fruit", gui:FindFirstChild("treelandsinvisb").holder.contents.optionscroll, "dupefruit")
maketextbox("FruitChosen", "Fruit name", gui:FindFirstChild("treelandsinvisb").holder.contents.optionscroll, changefruit, {"Gay"})
makecheckbox("treelandscheckbox", "Tree lands", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"treelandsinvisb"})
elseif game.PlaceId == 185655149 then
makeframe("bloxinvisb", "Blox burg", UDim2.new(0, 404,0, 16),gui,false)
makecheckbox("AutofarmCashier ", "Cashier farm", gui:FindFirstChild("bloxinvisb").holder.contents.optionscroll, runbloxautofarm, {"Gay"})
makecheckbox("AutofarmHairdresser", "Hairdresser farm", gui:FindFirstChild("bloxinvisb").holder.contents.optionscroll, runbloxautofarm2, {"Gay"})
makecheckbox("bloxcheckbox", "Blox burg", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"bloxinvisb"})
elseif game.PlaceId == 437253984 then
makeframe("aloneinvisb", "Alone", UDim2.new(0, 404,0, 16),gui,false)
makecheckbox("Itemfarmalone", "Item farm", gui:FindFirstChild("aloneinvisb").holder.contents.optionscroll, itemfarmalone, {"Gay"})
maketextbox("ItemAloneChosen", "Item name", gui:FindFirstChild("aloneinvisb").holder.contents.optionscroll, changeitemalonethingy, {"Gay"})
makebutton("OPGUN", "OP Gun", gui:FindFirstChild("aloneinvisb").holder.contents.optionscroll, "aloneopgun")
makecheckbox("alonecheckbox", "Alone", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"aloneinvisb"})
elseif game.PlaceId == 2377868063 then
makeframe("strucidinvisb", "Strucid", UDim2.new(0, 404,0, 16),gui,false) 
makecheckbox("silentaimstrucid", "Silent aim", gui:FindFirstChild("strucidinvisb").holder.contents.optionscroll, strucidrunsilentaim, {"Gay"})
makeslider("fovstrucid", "Field of view",globalsettings,"StrucidFOV",20, gui:FindFirstChild("strucidinvisb").holder.contents.optionscroll)
makecheckbox("acd", "Free for all", gui:FindFirstChild("strucidinvisb").holder.contents.optionscroll, Togglestuff, {"StrucidFFA"})
makecheckbox("strucidcheckbox", "Strucid", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"strucidinvisb"})
elseif game.PlaceId == 1417427737 then
makeframe("miningsiminvisb", "Mining simulator", UDim2.new(0, 404,0, 16),gui,false) 
maketextbox("BlockChosen", "Ore name", gui:FindFirstChild("miningsiminvisb").holder.contents.optionscroll, changeblock, {"Gay"})
makecheckbox("Opencrates", "Open crates", gui:FindFirstChild("miningsiminvisb").holder.contents.optionscroll, OpenCrates, {"Gay"})
makecheckbox("Mineblock", "Mine blocks", gui:FindFirstChild("miningsiminvisb").holder.contents.optionscroll, MineBlock, {"Gay"})
makebutton("Teleportosell", "Tp to sell", gui:FindFirstChild("miningsiminvisb").holder.contents.optionscroll, "teleportToSell")
makebutton("Teleporttoblock", "Tp to ore", gui:FindFirstChild("miningsiminvisb").holder.contents.optionscroll, "TpToBlock")
makecheckbox("miningsimcheckbox", "Mining simulator", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"miningsiminvisb"})
elseif game.PlaceId == 914010731 then
makeframe("roghoulinvisb", "Ro ghoul", UDim2.new(0, 404,0, 16),gui,false) 
makecheckbox("roghoulCheckbox", "Ro ghoul", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"roghoulinvisb"})
makecheckbox("Autofarm", "Auto farm", gui:FindFirstChild("roghoulinvisb").holder.contents.optionscroll, autofarmroghoulf, {"Gay"})
elseif game.PlaceId == 13822889 then
makeframe("LT2invisb", "Lumber tycoon 2",UDim2.new(0, 404,0, 16), gui, false)
makeframe("LT2Stealinvisb", "Steal",UDim2.new(0, 1348 ,0, 764), gui, false)
makeframe("LT2Cutinvisb", "Cut wood",UDim2.new(0, 1539,0, 764), gui, false)
makeframe("LT2AutoBuyinvisb", "Auto buy",UDim2.new(0, 1730,0, 764), gui, false)
makecheckbox("LT2Checkbox", "Lumber tycoon 2", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"LT2invisb"})
makecheckbox("HardDragger", "Hard dragger", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, harddraggerrun, {"Gay"})
makecheckbox("Instantcut", "Instant cut", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, toggleinscut, {"Gay"})
makecheckbox("CutWood", "Cut wood", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, opencutwood, {"Gay"})
makecheckbox("Autobuy", "Auto buy", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, openautobuy, {"Gay"})
makecheckbox("StealCheck", "Steal", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, opensteal, {"Gay"})
for i,v in pairs(trees) do
makebutton(v[1], v[1], gui:FindFirstChild("LT2Cutinvisb").holder.contents.optionscroll, cut, {v[1]..""})
end
makecheckbox("Axes", "Axes", gui:FindFirstChild("LT2Stealinvisb").holder.contents.optionscroll, Togglestuff, {"StealAxes"})
makecheckbox("Items", "Items", gui:FindFirstChild("LT2Stealinvisb").holder.contents.optionscroll, Togglestuff, {"StealItems"})
makecheckbox("Wood", "Wood", gui:FindFirstChild("LT2Stealinvisb").holder.contents.optionscroll, Togglestuff, {"StealWood"})
makecheckbox("Cars", "Cars", gui:FindFirstChild("LT2Stealinvisb").holder.contents.optionscroll, Togglestuff, {"StealCars"})
makebutton("Steal", "Steal", gui:FindFirstChild("LT2Stealinvisb").holder.contents.optionscroll, "Steal")
makebutton("Sellwood", "Sell all wood", gui:FindFirstChild("LT2invisb").holder.contents.optionscroll, "sellallwood")
if workspace:FindFirstChild("Stores") then
for _, Item in pairs(workspace.Stores:GetChildren()) do
for i,v in pairs(game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools:GetChildren()) do 
if Item:FindFirstChild(v.Name) then
makebutton(v.Name, v.Name, gui:FindFirstChild("LT2AutoBuyinvisb").holder.contents.optionscroll, autobuy, {v.Name..""})
end
end
end
end
makeframe("Playersinvisb", "Players",UDim2.new(0, 598,0, 16), gui, false)
makecheckbox("CheckPlayers", "Players", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"Playersinvisb"})
for i,v in pairs(game:GetService("Players"):GetPlayers()) do
if gui:FindFirstChild("Players") then
makebutton(v.Name, v.Name, gui:FindFirstChild("Players").holder.contents.optionscroll, changetarget, {v.Name..""})
else
makebutton(v.Name, v.Name, gui:FindFirstChild("Playersinvisb").holder.contents.optionscroll, changetarget, {v.Name..""})
end
end
game:GetService("Players").PlayerAdded:Connect(function(player)
if gui:FindFirstChild("Players") then
makebutton(player.Name, player.Name, gui:FindFirstChild("Players").holder.contents.optionscroll, changetarget, {player.Name..""})
else
makebutton(player.Name, player.Name, gui:FindFirstChild("Playersinvisb").holder.contents.optionscroll, changetarget, {player.Name..""})
end
end)
game:GetService("Players").PlayerRemoving:Connect(function(player)
if gui:FindFirstChild("Players") then
    removebutton(gui:FindFirstChild("Players").holder.contents.optionscroll, player.Name)
else
removebutton(gui:FindFirstChild("Playersinvisb").holder.contents.optionscroll, player.Name)
end
end)
elseif game.PlaceId == 550571085 then
makeframe("DeadMist2invisb", "Dead Mist 2",UDim2.new(0, 404,0, 16), gui, false)
makeframe("SpawnItemsinvisb", "Spawn items",UDim2.new(0, 598,0, 16), gui, false)
makecheckbox("CheckDeadMist2", "Dead mist 2", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"DeadMist2invisb"})
makecheckbox("SpawnItem", "Spawn Item", gui:FindFirstChild("DeadMist2invisb").holder.contents.optionscroll, openspawnitem, {"Gay"})
maketextbox("ItemChosen", "Item name", gui:FindFirstChild("SpawnItemsinvisb").holder.contents.optionscroll, changeitem, {"Gay"})
makebutton("SpawnTheItem", "Spawn Item", gui:FindFirstChild("SpawnItemsinvisb").holder.contents.optionscroll, spawnitem, {"Gay"})
end
makecheckbox("HotKeysCheckbox", "Hotkeys", gui:FindFirstChild("Main").holder.contents.optionscroll, openframe, {"HotKeysinvisb"})
makebutton("Aimkey", "Aimbot key", gui:FindFirstChild("HotKeysinvisb").holder.contents.optionscroll, changeaimhotkey, {"Gay"})
makebutton("Openkey", "OpenGUI key", gui:FindFirstChild("HotKeysinvisb").holder.contents.optionscroll, changeopenhotkey, {"Gay"})
spawn(function()
	for i,v in pairs(gui:GetDescendants()) do
	if v:IsA("ScrollingFrame") and v.Name == "optionscroll"  then
	module.makescrollautoupdate(v,v.optionlayout);
	game:GetService("RunService").Heartbeat:wait()
	local frametest = Instance.new("Frame", v)
	frametest.Size = UDim2.new(0, 0,0, 0)
	wait(1)
	frametest:Destroy()
	end
	end
end)
local defaultpositions = {}
for i,v in pairs(gui:GetChildren()) do
	if v:IsA("TextButton") then
		if string.find(v.Name, "invisb") then
			local str = v.Name
			local s = string.gsub(str, "invisb", "")
			table.insert(defaultpositions, {s, v.Position.X, v.Position.Y})
		    else
			table.insert(defaultpositions, {v.Name, v.Position.X, v.Position.Y})
		end
	end
end
inputserv.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		
		if input.KeyCode == globalsettings["OpenGUI"] then
			if visible == true then
				
				visible = "delay";
				for e,b in pairs(gui:GetDescendants()) do
					if string.find(b.ClassName,"Button") then
						b.Visible = false;
					end
					if b.Name == "boxicon" and not b:FindFirstChild("checkboxinvis") then
						b.ImageTransparency = 1;
					end;
					module.fadeallprops(b,Enum.EasingDirection.In,1,1,1);
				end;
				visible = false; 
			
			elseif visible == false then
				
				visible = "delay";
				for e,b in pairs(gui:GetDescendants()) do
					if string.find(b.ClassName,"Button") and not string.find(b.Name,"invisb") then
						b.Visible = true;
					end;
					if string.find(b.Name,"glow") then
						module.fadeallprops(b,Enum.EasingDirection.Out,1,0.3,0.3);
					elseif string.find(b.Name,"drop") then
						module.fadeallprops(b,Enum.EasingDirection.Out,1,0.8,0.8);
					elseif string.find(b.Name,"invis") then
						module.fadeallprops(b,Enum.EasingDirection.Out,1,1,1);
					else
						module.fadeallprops(b,Enum.EasingDirection.Out,1,0,0);
					end;
				end;
				visible = true;
				
			end;
		end;
		
		if input.KeyCode == Enum.KeyCode.E and visible then
			for i,v in pairs(gui:GetChildren()) do
			  if v:IsA("TextButton")then
					for ___,f in pairs(defaultpositions) do
					   if f[1] == v.Name then
						print("cool")
			           module.newtween(v,{Position = UDim2.new(f[2], f[3])},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.In);
			        end    
			     end
			  end
		   end
		end
	end;
end)
print("Loaded")
