-- Farewell Infortality.
-- Version: 2.82
-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local TextButton_2 = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local Melee = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local Vests = Instance.new("TextButton")
local TextLabel_2 = Instance.new("TextLabel")
local Backpacks = Instance.new("TextButton")
local TextLabel_3 = Instance.new("TextLabel")
local Clothing = Instance.new("TextButton")
local TextLabel_4 = Instance.new("TextLabel")
local Consume = Instance.new("TextButton")
local TextLabel_5 = Instance.new("TextLabel")
local Medical = Instance.new("TextButton")
local TextLabel_6 = Instance.new("TextLabel")
local Attachments = Instance.new("TextButton")
local TextLabel_7 = Instance.new("TextLabel")
local Ammo = Instance.new("TextButton")
local TextLabel_8 = Instance.new("TextLabel")
local Firearms = Instance.new("TextButton")
local TextLabel_9 = Instance.new("TextLabel")
--Properties:
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.new(0.854902, 0.372549, 0.372549)
TextButton.BorderSizePixel = 0
TextButton.Draggable = true
TextButton.Position = UDim2.new(0.120178044, 0, 0.385518581, 0)
TextButton.Size = UDim2.new(0, 268, 0, 21)
TextButton.Font = Enum.Font.GothamBold
TextButton.Text = " AUTO LOOT"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextSize = 16
TextButton.TextXAlignment = Enum.TextXAlignment.Left

TextButton_2.Parent = TextButton
TextButton_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_2.BackgroundTransparency = 1
TextButton_2.Position = UDim2.new(0.906716347, 0, 0, 0)
TextButton_2.Size = UDim2.new(0, 25, 0, 21)
TextButton_2.Font = Enum.Font.GothamBold
TextButton_2.Text = "E"
TextButton_2.TextColor3 = Color3.new(1, 1, 1)
TextButton_2.TextSize = 14

ScrollingFrame.Parent = TextButton
ScrollingFrame.BackgroundColor3 = Color3.new(0.254902, 0.254902, 0.254902)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 1, 0)
ScrollingFrame.Size = UDim2.new(0, 268, 0, 107)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 20, 0)
ScrollingFrame.ScrollBarThickness = 0

Melee.Name = "Melee"
Melee.Parent = ScrollingFrame
Melee.BackgroundColor3 = Color3.new(1, 1, 1)
Melee.BorderSizePixel = 0
Melee.Position = UDim2.new(0, 10, 0, 224)
Melee.Size = UDim2.new(0, 20, 0, 20)
Melee.Font = Enum.Font.SourceSans
Melee.Text = ""
Melee.TextColor3 = Color3.new(0, 0, 0)
Melee.TextSize = 14

TextLabel.Parent = Melee
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(1, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 178, 0, 20)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = " Melee Weapons"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

Vests.Name = "Vests"
Vests.Parent = ScrollingFrame
Vests.BackgroundColor3 = Color3.new(1, 1, 1)
Vests.BorderSizePixel = 0
Vests.Position = UDim2.new(0, 10, 0, 198)
Vests.Size = UDim2.new(0, 20, 0, 20)
Vests.Font = Enum.Font.SourceSans
Vests.Text = ""
Vests.TextColor3 = Color3.new(0, 0, 0)
Vests.TextSize = 14

TextLabel_2.Parent = Vests
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(1, 0, 0, 0)
TextLabel_2.Size = UDim2.new(0, 178, 0, 20)
TextLabel_2.Font = Enum.Font.GothamBold
TextLabel_2.Text = " Vests"
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextSize = 16
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

Backpacks.Name = "Backpacks"
Backpacks.Parent = ScrollingFrame
Backpacks.BackgroundColor3 = Color3.new(1, 1, 1)
Backpacks.BorderSizePixel = 0
Backpacks.Position = UDim2.new(0, 10, 0, 172)
Backpacks.Size = UDim2.new(0, 20, 0, 20)
Backpacks.Font = Enum.Font.SourceSans
Backpacks.Text = ""
Backpacks.TextColor3 = Color3.new(0, 0, 0)
Backpacks.TextSize = 14

TextLabel_3.Parent = Backpacks
TextLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Position = UDim2.new(1, 0, 0, 0)
TextLabel_3.Size = UDim2.new(0, 178, 0, 20)
TextLabel_3.Font = Enum.Font.GothamBold
TextLabel_3.Text = " Backpacks"
TextLabel_3.TextColor3 = Color3.new(1, 1, 1)
TextLabel_3.TextSize = 16
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left

Clothing.Name = "Clothing"
Clothing.Parent = ScrollingFrame
Clothing.BackgroundColor3 = Color3.new(1, 1, 1)
Clothing.BorderSizePixel = 0
Clothing.Position = UDim2.new(0, 10, 0, 146)
Clothing.Size = UDim2.new(0, 20, 0, 20)
Clothing.Font = Enum.Font.SourceSans
Clothing.Text = ""
Clothing.TextColor3 = Color3.new(0, 0, 0)
Clothing.TextSize = 14

TextLabel_4.Parent = Clothing
TextLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_4.BackgroundTransparency = 1
TextLabel_4.Position = UDim2.new(1, 0, 0, 0)
TextLabel_4.Size = UDim2.new(0, 178, 0, 20)
TextLabel_4.Font = Enum.Font.GothamBold
TextLabel_4.Text = " Clothing"
TextLabel_4.TextColor3 = Color3.new(1, 1, 1)
TextLabel_4.TextSize = 16
TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left

Consume.Name = "Consume"
Consume.Parent = ScrollingFrame
Consume.BackgroundColor3 = Color3.new(1, 1, 1)
Consume.BorderSizePixel = 0
Consume.Position = UDim2.new(0, 10, 0, 118)
Consume.Size = UDim2.new(0, 20, 0, 20)
Consume.Font = Enum.Font.SourceSans
Consume.Text = ""
Consume.TextColor3 = Color3.new(0, 0, 0)
Consume.TextSize = 14

TextLabel_5.Parent = Consume
TextLabel_5.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_5.BackgroundTransparency = 1
TextLabel_5.Position = UDim2.new(1, 0, 0, 0)
TextLabel_5.Size = UDim2.new(0, 178, 0, 20)
TextLabel_5.Font = Enum.Font.GothamBold
TextLabel_5.Text = " Consumables"
TextLabel_5.TextColor3 = Color3.new(1, 1, 1)
TextLabel_5.TextSize = 16
TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left

Medical.Name = "Medical"
Medical.Parent = ScrollingFrame
Medical.BackgroundColor3 = Color3.new(1, 1, 1)
Medical.BorderSizePixel = 0
Medical.Position = UDim2.new(0, 10, 0, 91)
Medical.Size = UDim2.new(0, 20, 0, 20)
Medical.Font = Enum.Font.SourceSans
Medical.Text = ""
Medical.TextColor3 = Color3.new(0, 0, 0)
Medical.TextSize = 14

TextLabel_6.Parent = Medical
TextLabel_6.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_6.BackgroundTransparency = 1
TextLabel_6.Position = UDim2.new(1, 0, 0, 0)
TextLabel_6.Size = UDim2.new(0, 178, 0, 20)
TextLabel_6.Font = Enum.Font.GothamBold
TextLabel_6.Text = " Medical"
TextLabel_6.TextColor3 = Color3.new(1, 1, 1)
TextLabel_6.TextSize = 16
TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left

Attachments.Name = "Attachments"
Attachments.Parent = ScrollingFrame
Attachments.BackgroundColor3 = Color3.new(1, 1, 1)
Attachments.BorderSizePixel = 0
Attachments.Position = UDim2.new(0, 10, 0, 65)
Attachments.Size = UDim2.new(0, 20, 0, 20)
Attachments.Font = Enum.Font.SourceSans
Attachments.Text = ""
Attachments.TextColor3 = Color3.new(0, 0, 0)
Attachments.TextSize = 14

TextLabel_7.Parent = Attachments
TextLabel_7.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_7.BackgroundTransparency = 1
TextLabel_7.Position = UDim2.new(1, 0, 0, 0)
TextLabel_7.Size = UDim2.new(0, 178, 0, 20)
TextLabel_7.Font = Enum.Font.GothamBold
TextLabel_7.Text = " Attachments"
TextLabel_7.TextColor3 = Color3.new(1, 1, 1)
TextLabel_7.TextSize = 16
TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left

Ammo.Name = "Ammo"
Ammo.Parent = ScrollingFrame
Ammo.BackgroundColor3 = Color3.new(1, 1, 1)
Ammo.BorderSizePixel = 0
Ammo.Position = UDim2.new(0, 10, 0, 37)
Ammo.Size = UDim2.new(0, 20, 0, 20)
Ammo.Font = Enum.Font.SourceSans
Ammo.Text = ""
Ammo.TextColor3 = Color3.new(0, 0, 0)
Ammo.TextSize = 14

TextLabel_8.Parent = Ammo
TextLabel_8.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_8.BackgroundTransparency = 1
TextLabel_8.Position = UDim2.new(1, 0, 0, 0)
TextLabel_8.Size = UDim2.new(0, 178, 0, 20)
TextLabel_8.Font = Enum.Font.GothamBold
TextLabel_8.Text = " Ammo"
TextLabel_8.TextColor3 = Color3.new(1, 1, 1)
TextLabel_8.TextSize = 16
TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left

Firearms.Name = "Firearms"
Firearms.Parent = ScrollingFrame
Firearms.BackgroundColor3 = Color3.new(1, 1, 1)
Firearms.BorderSizePixel = 0
Firearms.Position = UDim2.new(0, 10, 0, 10)
Firearms.Size = UDim2.new(0, 20, 0, 20)
Firearms.Font = Enum.Font.SourceSans
Firearms.Text = ""
Firearms.TextColor3 = Color3.new(0, 0, 0)
Firearms.TextSize = 14

TextLabel_9.Parent = Firearms
TextLabel_9.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_9.BackgroundTransparency = 1
TextLabel_9.Position = UDim2.new(1, 0, 0, 0)
TextLabel_9.Size = UDim2.new(0, 178, 0, 20)
TextLabel_9.Font = Enum.Font.GothamBold
TextLabel_9.Text = " Firearms"
TextLabel_9.TextColor3 = Color3.new(1, 1, 1)
TextLabel_9.TextSize = 16
TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left

	local parent = ScreenGui.TextButton.ScrollingFrame
	local _a = parent.Ammo
	local _at = parent.Attachments
	local _b = parent.Backpacks
	local _c = parent.Clothing
	local _co = parent.Consume
	local _f = parent.Firearms
	local _m = parent.Medical
	local _me = parent.Melee
	local _v = parent.Vests
	
	local Dea = function(func)
		local funcv = function() return 'fuck off lol' end
		return func.BackgroundColor3 == Color3.new(0,1,0)
	end
	local setupvalue = secret500 or debug.setupvalue
	local getupvalues = secret953 or debug.getupvalues
	local api;
	local framework; do
		local renv = getrenv();
		local fag = renv._G.ClientFramework
		api = debug.getupvalue(fag,'api')
		renv.settings = error;
	end
	local library = api.PreRequire('Libraries','Network')
	pcall(function()
	setupvalue(debug.getupvalues(library.Send).getKey, 'stop', error)
	end)
	debug.setupvalue(library.Add,'uhOH',library.Kill)
	function GetServerSends()
	    return getupvalue(library.Kill,'serverSends')
	end
	function FixServerSends()
	    debug.setupvalue(library.Kill,'serverSends',getupvalues(library.Kill).serverSends+1)
	end
	function PickUpItem(id,name)
	FixServerSends()
	local tbl_main = {
	        GetServerSends(), 
	        "Inventory Pickup Item", 
	        id
	}
	game:GetService("ReplicatedStorage").Networking.Event:FireServer(unpack(tbl_main))
	end
	
	function AutoLootContainers()
	    for i,v in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.Containers) do
	        for ID in pairs(v.Occupants) do
	            PickUpItem(ID)
	        end
	    end
	end
	function AutoLootGround()
	    for ID,v in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.GroundContainer.Occupants) do
	        PickUpItem(ID)
	    end
	end
	local cAmmo={"9x19mm 15rd Magazine Model 459",".45 ACP 6rd Speedloader M1909 Snubnose","9x19mm 8rd Magazine P38",".44 Magnum Ammo Pack 50rd","12 Gauge Ammo Pack 24rd",".45 ACP 7rd Magazine M1911","5.56x45mm 20rd Magazine Mini-14",".44 Magnum 6rd Speedloader Model 29",".45 ACP Ammo Pack 50rd","9x19mm Ammo Pack 50rd","7.62x63mm 5rd Clip M1903","7.62x63mm 8rd Clip M1 Garand","5.56mm STANAG 30rd Magazine","5.56mm STANAG 20rd Magazine","5.56mm STANAG 50rd Extended Magazine","9x19mm 30rd Magazine MP5","12 Gauge Ammo Pack 24rd","9x19mm Ammo Pack 50rd","5.56x45mm Ammo Pack 50rd","7.62x51mm Ammo Pack 50rd","5.56x45mm 100rd Box Magazine M249","7.62x51mm 100rd Box Magazine M60","9x19mm 15rd Magazine Hi-Power","9x19mm 32rd Extended Magazine M9","9x19mm 17rd Magazine M9",".45 ACP 30rd Magazine MAC-10","9x19mm 20rd Magazine TEC-9","9x19mm 32rd Extended Magazine TEC-9",".44 Magnum 8rd Magazine Desert Eagle","5.56x45mm Ammo Pack 50rd","5.56x45mm Ammo Pack 50rd","9x19mm Ammo Pack 50rd","9x19mm 30rd Magazine MP5","9x19mm 17rd Magazine M9","5.56mm STANAG 30rd Magazine","5.56mm STANAG 20rd Magazine","7.62x39mm AK 30rd Magazine","7.62x39mm AK 75rd Drum Magazine","7.62x39mm AK 40rd Extended Magazine","7.62x39mm Ammo Pack 50rd","7.62x39mm 10rd Clip SKS","7.62x51mm Ammo Pack 50rd","9x19mm 20rd Magazine Uzi","7.62x51mm STANAG 20rd Magazine","7.62x51mm STANAG 30rd Extended Magazine","7.62x51mm STANAG 50rd Drum Magazine","9x19mm 32rd Extended Magazine Uzi","7.62x51mm 10rd Magazine PSG-1","7.62x51mm 10rd Magazine L96A1","9x19mm Ammo Pack 50rd",".45 ACP 30rd Magazine M3A1","7.62x63mm Ammo Pack 50rd",".45 ACP 20rd Magazine M1 Thompson","7.62x63mm 20rd Magazine BAR",".45 ACP Ammo Pack 50rd","7.62x63mm 5rd Clip M1903",".45 ACP 50rd Magazine M1 Thompson","7.62x63mm 8rd Clip M1 Garand","7.62x63mm Ammo Pack 50rd","9x19mm 32rd Magazine MP-40","7.62x54mmR Ammo Pack 50rd",".357 Magnum Ammo Pack 50rd",".357 Magnum 6rd Speedloader Python","9x18mm 8rd Magazine Makarov","9x18mm Ammo Pack 50rd","7.62x63mm 100rd Box Magazine M1919A6",}
	local cFirearms={"Mini-14","Winchester 1894","Coach Gun","Remington 788","Maverick 88","Camp Carbine","M1903","M1 Garand","Auto-5","M16A2","M60","M249","XM177","Walther P38","Model 29","M1911","Model 459","M1909 Snubnose","Lupara","Hi-Power","M9","M16","XM177","Mini-14","Camp Carbine","M14","M1918 BAR","M1 Thompson","M3A1","M1903","M1 Garand","MAC-10","Desert Eagle","TEC-9","Uzi","MP5K","FAL","SPAS-12","PSG-1","AUG","L96A1","G3","XM177","MP5","M9","AK-47","SKS","M14","Mosin PU","Python","Makarov","M1919A6","MP-40",}
	local cAttachments={"Rifle Scope","Oil Filter Suppressor","Reflex","Holographic","M68 CCO","ACOG","Pelican Scope","Standard Suppressor","Foregrip","Underbarrel Flashlight","Laser","Holographic","Kobra","AAC Suppressor","Osprey Suppressor","SUSAT",}
	local cMedical={"Military Stamina Booster","Military Health Booster","Military MedKit","Health Booster","Small MedKit","Stamina Booster","Large MedKit",}
	local cConsumables={"Military Ration","Beef Jerky","Canned Fish","Canned Meat","Canned Soup","Candy Bar","Salty Chips","Salty Crackers","Peanut Butter","Soda Orange","Soda Purple","Soda Red","Water Bottle",}
	local cClothing={"Pants Militarycamo 01","Shirt Militarycamo 01","Pants SpaceLaunch 01","Shirt Operator 01","Shirt Stuntman 01","Pants Mobster 01","Shirt Mobster 01","Shirt Marshal 01","Pants WWII Pilot 01","Pants Marshal 01","Shirt Lumberjack 01","Pants SlavTracksuit 01","Shirt Tuxedo 01","Pants Football 01","Pants Operator 01","Shirt WWII Pilot 01","Pants Lumberjack 01","Shirt Football 01","Pants Stuntman 01","Shirt SpaceLaunch 01","Shirt SlavTracksuit 01","Pants Tuxedo 01","Pants TigerStripe 01","Shirt TigerStripe 01","Pants Cargoshorts Blue 01","Pants Cargoshorts Brown 01","Pants Cargoshorts Olive 01","Pants Cargoshorts Tan 01","Pants Jeans Black 01","Pants Jeans Blue 01","Pants Jeans Brown 01","Shirt Polo Green 01","Shirt Polo Blue 01","Pants ShortSkirt Black 01","Pants ShortSkirt Orange 01","Shirt Polostriped 02","Shirt Polostriped 01","Shirt Polo Yellow 01","Shirt Polo Red 01","Pants Overalls 01","Shirt Vneck White 01","Shirt Argyle Red 01","Shirt Argyle Blue 01","Pants LongSkirt Grey 01","Shirt Blazer 01","Pants Slacks 01","Shirt Polostriped 04","Pants ShortSkirt Pink 01","Pants ShortSkirt Blue 01","Shirt Argyle Brown 01","Shirt Raincoat Blue 01","Shirt Argyle Black 01","Shirt Baseball Black 01","Shirt Baseball Blue 01","Shirt Baseball Green 01","Shirt Baseball Red 01","Shirt Cargojacket Black 01","Shirt Cargojacket Brown 01","Shirt Cargojacket Grey 01","Shirt Cargojacket Olive 01","Shirt Cargojacket Red 01","Shirt Vneck Blue 01","Shirt Polostriped 03","Shirt Sweater Grey 01","Shirt Sweater Cream 01","Shirt Sweater Brown 01","Shirt Sweater Maroon 01","Shirt StripedHoodie 02","Shirt StripedHoodie 01","Pants LongSkirt Green 01","Pants LongSkirt Red 01","Shirt Raincoat Red 01","Pants LongSkirt Blue 01","Shirt Vneck Red 01","Shirt Vneck Black 01","Shirt Raincoat Yellow 01","Shirt Raincoat Green 01","Shirt Varsity Red 01","Shirt Varsity Green 01","Shirt Varsity Blue 01","Shirt Tanktop White 01","Shirt Varsity Black 01","Shirt Tanktop Black 01","Shirt Sweater Navyblue 01","Shirt Firefighter 01","Pants Firefighter 01","Pants Sheriff 01","Shirt Sheriff 01","Pants Cargoshorts Blue 01","Pants Cargoshorts Brown 01","Pants Cargoshorts Olive 01","Pants Cargoshorts Tan 01","Pants Jeans Black 01","Pants Jeans Blue 01","Pants Jeans Brown 01","Pants Overalls 01","Shirt DenimJacket 02","Shirt Denimjacket 01","Shirt Leatherjacket Black 01","Shirt Leatherjacket Brown 01","Shirt Overalls Green 01","Shirt Overalls Red 01","Shirt Overalls Tan 01","Shirt Overalls White 01","Shirt Sweater Brown 01","Shirt Sweater Cream 01","Shirt Sweater Grey 01","Shirt Sweater Maroon 01","Shirt Sweater Navyblue 01","Pants LongSkirt Grey 01","Pants LongSkirt Blue 01","Pants LongSkirt Red 01","Pants LongSkirt Green 01","Pants GrassSkirt 01","Shirt Hawaii Black 01","Shirt Hawaii Blue 01","Shirt Hawaii Green 01","Shirt Hawaii Orange 01","Shirt Hawaii Pink 01","Shirt Hawaii Red 01","Pants Track 01","Pants Track 02","Pants Track 03","Pants Track 04","Pants Trackshorts Black 01","Pants Trackshorts Blue 01","Pants Trackshorts Green 01","Pants Trackshorts Red 01","Pants Trackstriped 01","Pants Trackstriped 02","Pants Trackstriped 03","Pants Trackstriped 04","Shirt Hoodie Black 01","Shirt Hoodie Blue 01","Shirt Hoodie Green 01","Shirt Hoodie Red 01","Shirt Hoodie White 01","Shirt Windbreaker 01","Shirt Windbreaker 02","Shirt Windbreaker 03","Shirt Windbreaker 04","Shirt Mechanic Blue 01","Shirt Mechanic Brown 01","Shirt Mechanic Green 01","Shirt Mechanic Grey 01","Shirt Mechanicstained Blue 01","Shirt Mechanicstained Brown 01","Shirt Mechanicstained Green 01","Shirt Mechanicstained Grey 01","Pants Mechanicstained Blue 01","Pants Mechanicstained Brown 01","Pants Mechanicstained Green 01","Pants Mechanicstained Grey 01","Pants Mechanic Blue 01","Pants Mechanic Brown 01","Pants Mechanic Green 01","Pants Mechanic Grey 01","Pants Chef 01","Shirt Chef 01","Shirt MilitaryGhillie Green 01","Pants MilitaryGhillie Green 01","Ghillie Hat",}
	local cBackpacks={"Backpack Military Pack Green","Backpack Military Pack Brown","Backpack Military Pack Tan","Backpack Military Duffel Bag Tan","Backpack Military Duffel Bag Green","Backpack Military Duffel Bag White","Backpack Military Duffel Bag Black","Military SeaBag Black","Military SeaBag Green","Military SeaBag Gray","Backpack Vintage Military Green","Backpack Vintage Military Tan","Backpack Vintage Radio Green","Backpack Briefcase Black","Backpack Briefcase Brown","Backpack Briefcase Gray","Backpack Daypack Black","Backpack Daypack Blue","Backpack Daypack Gray","Backpack Hiking Pack Blue","Backpack Hiking Pack Green","Backpack Hiking Pack Red","Backpack Hiking Pack Tan","Backpack Knapsack Dusty Brown","Backpack Knapsack Green","Backpack Knapsack Rich Brown","Backpack Daypack Orange","Backpack Guide Pack Blue","Backpack Guide Pack Yellow","Backpack Rucksack Brown","Backpack Rucksack Tan","Backpack Guide Pack Green","Backpack Guide Pack Lime","Backpack College Pink","Backpack College Purple","Backpack College Teal","Backpack College Yellow","Backpack Guitar Case Black","Backpack Guitar Case Brown","Backpack Weaved Basket Brown","Backpack Rifle Bag Dusty Brown","Backpack Rifle Bag Gray","Backpack Rifle Bag Rich Brown","Backpack Heavy Spec Ops Tan","Backpack Heavy Spec Ops Green","Backpack Heavy Spec Ops Black","Backpack Spec Ops Black","Backpack Spec Ops Tan","Backpack Spec Ops Green","Backpack Suitcase Hard White","Backpack Suitcase Soft White","Backpack Suitcase Soft Green","Backpack Suitcase Soft Pink","Backpack Suitcase Soft Teal","Backpack Suitcase Hard Black","Backpack Suitcase Hard Brown","Backpack Suitcase Hard Rust","Backpack School01 Black","Backpack School01 Blue","Backpack School01 Orange","Backpack School02 Green","Backpack School02 Red","Backpack School02 Purple","Backpack School01 Red","Backpack School02 White","Backpack Vintage Soviet Brown","Backpack Vintage Soviet Green","Backpack Duffel Bag Blue","Backpack Duffel Bag Red","Backpack Duffel Bag Brown","Backpack Duffel Bag Black",}
	local cVests={"Vest Operator Webbing","Vest WWII Pilot","Vest Green Beret","Vest Militia Bandolier Green","Vest Militia Bandolier Gray","Vest Militia Bandolier Brown","Vest Militia Green","Vest Militia Grime","Vest Militia Flint","Vest Construction Green","Vest Construction Orange","Vest Construction Yellow","Vest Military Ammo Black","Vest Military Ammo Green","Vest Military Ammo Tan","Vest Military Ammo Webbing Green","Vest Military Ammo Webbing Tan","Vest Tactical Black","Vest Tactical Green","Vest Tactical Tan","Vest Tactical Black","Vest Safari Gray","Vest Safari Green","Vest Safari Light","Vest Safari Tan","Vest Hunting Tan","Vest Hunting Green","Vest Hunting Brown","Vest Leather Flint","Vest Hunting Gray","Vest Leather Black","Vest Leather Brown","Vest Quilted Blue","Vest Quilted Navy","Vest Quilted Orange","Vest Quilted Pink","Vest Quilted Red","Vest Quilted White","Vest Quilted Red","Vest Vintage Ammo Webbing Brown","Vest Vintage Ammo Webbing Gray",}
	local cMeleeWeapons={"Officers Sword","NCO Katana","Entrenchment Shovel","Combat Knife","Hatchet","Fire Axe","Pocket Knife","Chef Knife","Crowbar",}
	
	spawn(function()
		while wait(2) do
			pcall(function()
				for ni,v in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.Containers) do
			        for ID,Item in pairs(v.Occupants) do
						if Dea(_a) then
							for i,v in pairs(cAmmo) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_f) then
							for i,v in pairs(cFirearms) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_at) then
							for i,v in pairs(cAttachments) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_m) then
							for i,v in pairs(cMedical) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_co) then
							for i,v in pairs(cConsumables) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_c) then
							for i,v in pairs(cClothing) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_b) then
							for i,v in pairs(cBackpacks) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_v) then
							for i,v in pairs(cVests) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						if Dea(_me) then
							for i,v in pairs(cMeleeWeapons) do
								if v == Item.Name then
									PickUpItem(ID,Item.Name)
								end
							end
						end
						
			        end
				end
				for ID,Item in pairs(api.Libraries.Interface.Modules.Inventory.Inventory.GroundContainer.Occupants) do
			        if Dea(_a) then
						for i,v in pairs(cAmmo) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_f) then
						for i,v in pairs(cFirearms) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_at) then
						for i,v in pairs(cAttachments) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_m) then
						for i,v in pairs(cMedical) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_co) then
						for i,v in pairs(cConsumables) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_c) then
						for i,v in pairs(cClothing) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_b) then
						for i,v in pairs(cBackpacks) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_v) then
						for i,v in pairs(cVests) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
					if Dea(_me) then
						for i,v in pairs(cMeleeWeapons) do
							if v == Item.Name then
								PickUpItem(ID,Item.Name)
							end
						end
					end
				end
			end)
		end
	end)


	Melee.MouseButton1Down:connect(function()
		if Melee.BackgroundColor3 == Color3.new(1,1,1) then
			Melee.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Melee.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)

	Vests.MouseButton1Down:connect(function()
		if Vests.BackgroundColor3 == Color3.new(1,1,1) then
			Vests.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Vests.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)


	Backpacks.MouseButton1Down:connect(function()
		if Backpacks.BackgroundColor3 == Color3.new(1,1,1) then
			Backpacks.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Backpacks.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)

	Clothing.MouseButton1Down:connect(function()
		if Clothing.BackgroundColor3 == Color3.new(1,1,1) then
			Clothing.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Clothing.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)


	Consume.MouseButton1Down:connect(function()
		if Consume.BackgroundColor3 == Color3.new(1,1,1) then
			Consume.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Consume.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)


	Medical.MouseButton1Down:connect(function()
		if Medical.BackgroundColor3 == Color3.new(1,1,1) then
			Medical.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Medical.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)

	Attachments.MouseButton1Down:connect(function()
		if Attachments.BackgroundColor3 == Color3.new(1,1,1) then
			Attachments.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Attachments.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)


	Ammo.MouseButton1Down:connect(function()
		if Ammo.BackgroundColor3 == Color3.new(1,1,1) then
			Ammo.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Ammo.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)


	Firearms.MouseButton1Down:connect(function()
		if Firearms.BackgroundColor3 == Color3.new(1,1,1) then
			Firearms.BackgroundColor3 = Color3.new(0,1,0) 
		else
			Firearms.BackgroundColor3 = Color3.new(1,1,1)
		end
	end)

