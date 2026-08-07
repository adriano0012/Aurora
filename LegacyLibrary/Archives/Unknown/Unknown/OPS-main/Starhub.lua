local v26 = loadstring(game:HttpGet("https://pastebin.com/raw/87ESbY5w"))();
local v27 = v26:MakeWindow({
    ["Name"] = "Starkiel Scripts | Brookhaven\240\159\143\160\240\159\140\179",
    ["HidePremium"] = false,
    ["SaveConfig"] = true,
    ["ConfigFolder"] = "SSB2"
});
local v28 = game.CoreGui.HiddenUI.Orion;
for v56, v57 in pairs(v28:GetChildren()) do
    if ((v57.Name == "Frame") and v57:FindFirstChild("UICorner")) then
        for v111, v112 in pairs(v57:GetChildren()) do
            if v112:FindFirstChild("UICorner") then
                for v134, v135 in pairs(v112:GetChildren()) do
                    if v135:FindFirstChild("TextLabel") then
                        v135:Destroy();
                    end;
                end;
            end;
        end;
    end;
end;
local v29 = {};
local v30 = 16;
local v31 = 7.199999999999989;
local v32 = 40;
local v33 = 196;
local v34 = false;
local v35 = false;
local v36 = false;
local v37 = false;
local v38 = false;
local v39 = false;
local v40 = "BannedBlock";
local v41 = "";
local function v42()
    local v58 = 0;
    local v59;
    while true do
        if (v58 == 0) then
            v59 = 0;
            while true do
                if (2 == v59) then
                    tool.Activated:connect(function()
                        local v140 = 0;
                        local v141;
                        while true do
                            if (1 == v140) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v141;
                                break;
                            end;
                            if (v140 == (0)) then
                                v141 = mouse.Hit + Vector3.new(0, 2.5, 0);
                                v141 = CFrame.new(v141.X, v141.Y, v141.Z);
                                v140 = 1;
                            end;
                        end;
                    end);
                    tool.Parent = game.Players.LocalPlayer.Backpack;
                    break;
                end;
                if (v59 == 0) then
                    mouse = game.Players.LocalPlayer:GetMouse();
                    tool = Instance.new("Tool");
                    v59 = 1;
                end;
                if (v59 == (1)) then
                    tool.RequiresHandle = false;
                    tool.Name = "Tp tool(Equip to Click TP)";
                    v59 = 2;
                end;
            end;
            break;
        end;
    end;
end
local function v43()
    return game.Players.LocalPlayer;
end
local function v44()
    local v60 = 0;
    local v61;
    while true do
        if (v60 == (1)) then
            return nil;
        end;
        if (v60 == (0)) then
            local v113 = 0;
            local v114;
            while true do
                if (v113 == (0)) then
                    v114 = 0;
                    while true do
                        if (v114 == 1) then
                            v60 = 1;
                            break;
                        end;
                        if (v114 == (0)) then
                            v61 = game.Players.LocalPlayer.Character;
                            if v61 then
                                return v61:FindFirstChild("Humanoid");
                            end;
                            v114 = 1;
                        end;
                    end;
                    break;
                end;
            end;
        end;
    end;
end
TP = function(v62)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v62.CFrame;
end;
TPCF = function(v65)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v65;
end;
local function v45()
    local v67 = game.Players.LocalPlayer.Character;
    if v67 then
        return v67:FindFirstChild("HumanoidRootPart");
    end;
    return nil;
end
local function v46()
    local v68 = 0;
    local v69;
    while true do
        if (v68 == (1)) then
            return nil;
        end;
        if (v68 == (0)) then
            v69 = game.Players.LocalPlayer.Character;
            if v69 then
                return v69;
            end;
            v68 = 1;
        end;
    end;
end
for v70 = 1, 37, 1 do
    local v71 = 0;
    local v72;
    while true do
        if (v71 == (0)) then
            v72 = v40 .. tostring(v70);
            table.insert(v29, v72);
            break;
        end;
    end;
end;
local v47 = v27:MakeTab({
    ["Name"] = "Home \240\159\143\160",
    ["Icon"] = "rbxassetid://98389898506367",
    ["PremiumOnly"] = false
});
v47:AddButton({
    ["Name"] = "Destroy Gui",
    ["Callback"] = function()
        v26:Destroy();
    end
});
v47:AddLabel("Creator YT: @Un Robloxxer or Starkield");
v47:AddLabel("Script Version: 1.0");
v47:AddLabel("Last Update: 12/22/2024");
local v48 = v27:MakeTab({
    ["Name"] = "Scripts \240\159\167\176",
    ["Icon"] = "rbxassetid://11982227466",
    ["PremiumOnly"] = false
});
v48:AddButton({
    ["Name"] = "Infinity Yield",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
    end
});
v48:AddButton({
    ["Name"] = "Dex",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0", true))();
    end
});
v48:AddButton({
    ["Name"] = "Bombox Gui By Starkield",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/BvyGGrs1"))();
    end
});
v48:AddButton({
    ["Name"] = "Btools",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))();
    end
});
v48:AddButton({
    ["Name"] = "Copy You Actual Position",
    ["Callback"] = function()
        setclipboard(game.Players.LocalPlayer.Character.HumanoidRootPart.Position);
    end
});
v48:AddButton({
    ["Name"] = "Copy You Actual CFrame",
    ["Callback"] = function()
        setclipboard(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame);
    end
});
local v49 = v27:MakeTab({
    ["Name"] = "Player \240\159\143\131\226\128\141\226\153\130\239\184\143\240\159\143\131\226\128\141\226\153\128\239\184\143",
    ["Icon"] = "rbxassetid://13289762854",
    ["PremiumOnly"] = false
});
v49:AddToggle({
    ["Name"] = "Noclip",
    ["Default"] = false,
    ["Callback"] = function(v73)
        v38 = v73;
    end
});
v49:AddSlider({
    ["Name"] = "Player Speed",
    ["Min"] = 0,
    ["Max"] = 100,
    ["Default"] = 16,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v74)
        local v75 = 0;
        local v76;
        while true do
            if (v75 == (0)) then
                v76 = v44();
                v76.WalkSpeed = v74;
                v75 = 1;
            end;
            if (v75 == (1)) then
                v30 = v74;
                break;
            end;
        end;
    end
});
v49:AddToggle({
    ["Name"] = "Auto Set Speed",
    ["Default"] = false,
    ["Callback"] = function(v77)
        v34 = v77;
    end
});
v49:AddSlider({
    ["Name"] = "Player Jump Power",
    ["Min"] = 0,
    ["Max"] = 1000,
    ["Default"] = 40,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v78)
        local v79 = 0;
        local v80;
        while true do
            if (v79 == (0)) then
                v80 = v44();
                v80.JumpPower = v78;
                v79 = 1;
            end;
            if ((1) == v79) then
                v32 = v78;
                break;
            end;
        end;
    end
});
v49:AddToggle({
    ["Name"] = "Auto Set Jump Power",
    ["Default"] = false,
    ["Callback"] = function(v81)
        v36 = v81;
    end
});
v49:AddSlider({
    ["Name"] = "Gravity",
    ["Min"] = 0,
    ["Max"] = 1000,
    ["Default"] = 196,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v82)
        workspace.Gravity = v82;
        v33 = v82;
    end
});
v49:AddToggle({
    ["Name"] = "Auto Set Gravity",
    ["Default"] = false,
    ["Callback"] = function(v84)
        v37 = v84;
    end
});
v49:AddSlider({
    ["Name"] = "Player Jump Height",
    ["Min"] = 0,
    ["Max"] = 1000,
    ["Default"] = 7,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v85)
        local v86 = v44();
        v86.JumpHeight = v85;
        v31 = v85;
    end
});
v49:AddToggle({
    ["Name"] = "Auto Set Jump Height",
    ["Default"] = false,
    ["Callback"] = function(v88)
        v35 = v88;
    end
});
local v50 = v27:MakeTab({
    ["Name"] = "Teleports \240\159\140\141\240\159\154\128",
    ["Icon"] = "rbxassetid://6723742959",
    ["PremiumOnly"] = false
});
v50:AddLabel("Scroll down to find Easter Eggs Teleports \240\159\165\154\240\159\154\128");
v50:AddLabel("Misc Teleports \240\159\154\128");
local v51 = v50:AddDropdown({
    ["Name"] = "Teleport To A Player",
    ["Default"] = "No Player Selected",
    ["Options"] = {
        "x"
    },
    ["Callback"] = function(v89)
        local v90 = 0;
        local v91;
        local v92;
        while true do
            if (v90 == (0)) then
                v91 = game.Players.LocalPlayer.Character.HumanoidRootPart;
                v92 = game.Players:FindFirstChild(v89).Character.HumanoidRootPart;
                v90 = 1;
            end;
            if ((1) == v90) then
                if (v91 and v92) then
                    TP(v92);
                end;
                break;
            end;
        end;
    end
});
v50:AddButton({
    ["Name"] = "Get TP Toowl",
    ["Callback"] = function()
        v42();
    end
});
v50:AddLabel("Main Teleports \240\159\154\128");
v50:AddButton({
    ["Name"] = "Motel",
    ["Callback"] = function()
        TPCF(CFrame.new(158.085372924804688, 3.398021936416626, 170.459426879882812));
    end
});
v50:AddButton({
    ["Name"] = "Burger Barn",
    ["Callback"] = function()
        TPCF(CFrame.new(151.18011474609375, 4.498026371002197, 51.954029083251953));
    end
});
v50:AddButton({
    ["Name"] = "Airport",
    ["Callback"] = function()
        TPCF(CFrame.new(312.24310302734375, 4.397835731506348, 59.092521667480469));
    end
});
v50:AddButton({
    ["Name"] = "Airplane",
    ["Callback"] = function()
        TPCF(CFrame.new(452.382232666015625, -107.797004699707031, 108.323814392089844));
    end
});
v50:AddButton({
    ["Name"] = "Grocery Store",
    ["Callback"] = function()
        TPCF(CFrame.new(3.350229978561401, 3.498025178909302, -141.728240966796875));
    end
});
v50:AddButton({
    ["Name"] = "Hair & Nails",
    ["Callback"] = function()
        TPCF(CFrame.new(-74.5167236328125, 3.498025178909302, -116.717361450195312));
    end
});
v50:AddButton({
    ["Name"] = "Club Broks",
    ["Callback"] = function()
        TPCF(CFrame.new(-76.319068908691406, 19.798025131225586, -131.453292846679688));
    end
});
v50:AddButton({
    ["Name"] = "Party Planner",
    ["Callback"] = function()
        TPCF(CFrame.new(-128.382308959960938, 20.998031616210938, -131.419052124023438));
    end
});
v50:AddButton({
    ["Name"] = "Lobby",
    ["Callback"] = function()
        TPCF(CFrame.new(-60.647506713867188, 3.29802680015564, -0.652792096138));
    end
});
v50:AddButton({
    ["Name"] = "Police Station",
    ["Callback"] = function()
        TPCF(CFrame.new(-135.430328369140625, 3.489161729812622, 13.206703186035156));
    end
});
v50:AddButton({
    ["Name"] = "Ice Cream",
    ["Callback"] = function()
        TPCF(CFrame.new(-128.151123046875, 3.498025178909302, -123.130722045898438));
    end
});
v50:AddButton({
    ["Name"] = "Arcade",
    ["Callback"] = function()
        TPCF(CFrame.new(-171.35302734375, 3.498025178909302, -124.514442443847656));
    end
});
v50:AddButton({
    ["Name"] = "Breakfast or Party Salon or Tanning Salon",
    ["Callback"] = function()
        TPCF(CFrame.new(-188.032333374023438, 19.398027420043945, -127.09283447265625));
    end
});
v50:AddButton({
    ["Name"] = "Hospital",
    ["Callback"] = function()
        TPCF(CFrame.new(-305.19085693359375, 3.484274625778198, 28.018157958984375));
    end
});
v50:AddButton({
    ["Name"] = "Fire Station",
    ["Callback"] = function()
        TPCF(CFrame.new(-495.49822998046875, 3.498024940490723, -106.510543823242188));
    end
});
v50:AddButton({
    ["Name"] = "Town Hall",
    ["Callback"] = function()
        TPCF(CFrame.new(-356.260711669921875, 7.398018836975098, -111.637161254882812));
    end
});
v50:AddButton({
    ["Name"] = "Post Office",
    ["Callback"] = function()
        TPCF(CFrame.new(-166.215057373046875, 3.498025178909302, 256.248382568359375));
    end
});
v50:AddButton({
    ["Name"] = "Museum or Restaurant or Empty",
    ["Callback"] = function()
        TPCF(CFrame.new(-168.84027099609375, 19.998029708862305, 259.2425537109375));
    end
});
v50:AddButton({
    ["Name"] = "Phone Store or Gun Store or Auto Parts",
    ["Callback"] = function()
        TPCF(CFrame.new(-127.286239624023438, 19.998029708862305, 250.016448974609375));
    end
});
v50:AddButton({
    ["Name"] = "Starbooks",
    ["Callback"] = function()
        TPCF(CFrame.new(-94.953872680664062, 3.498025178909302, 253.5635986328125));
    end
});
v50:AddButton({
    ["Name"] = "Veterinary",
    ["Callback"] = function()
        TPCF(CFrame.new(-84.488037109375, 20.998023986816406, 270.7176513671875));
    end
});
v50:AddButton({
    ["Name"] = "Dentist",
    ["Callback"] = function()
        TPCF(CFrame.new(-54.336090087890625, 20.998027801513672, 270.0113525390625));
    end
});
v50:AddButton({
    ["Name"] = "Rock Star",
    ["Callback"] = function()
        TPCF(CFrame.new(-38.822452545166016, 3.498025178909302, 252.252578735351562));
    end
});
v50:AddButton({
    ["Name"] = "Bank",
    ["Callback"] = function()
        TPCF(CFrame.new(0.635948300361633, 3.498025178909302, 248.060256958007812));
    end
});
v50:AddButton({
    ["Name"] = "Bank Money Vault",
    ["Callback"] = function()
        TPCF(CFrame.new(-4.55881404876709, 17.748025894165039, 254.990890502929688));
    end
});
v50:AddButton({
    ["Name"] = "Bank Basement",
    ["Callback"] = function()
        TPCF(CFrame.new(-23.327791213989258, -51.301975250244141, 222.8165283203125));
    end
});
v50:AddButton({
    ["Name"] = "Subway",
    ["Callback"] = function()
        TPCF(CFrame.new(60.516056060791016, -21.201976776123047, 65.689933776855469));
    end
});
v50:AddButton({
    ["Name"] = "Mall",
    ["Callback"] = function()
        TPCF(CFrame.new(159.8292236328125, 3.598029375076294, -164.216064453125));
    end
});
v50:AddButton({
    ["Name"] = "Gas",
    ["Callback"] = function()
        TPCF(CFrame.new(116.788658142089844, 3.398025274276733, -298.08197021484375));
    end
});
v50:AddButton({
    ["Name"] = "Food Mart",
    ["Callback"] = function()
        TPCF(CFrame.new(143.8507080078125, 4.398026466369629, -362.882110595703125));
    end
});
v50:AddButton({
    ["Name"] = "Auto Mall ( inside )",
    ["Callback"] = function()
        TPCF(CFrame.new(-15.822882652282715, 3.498025178909302, -338.634307861328125));
    end
});
v50:AddButton({
    ["Name"] = "Auto Repair",
    ["Callback"] = function()
        TPCF(CFrame.new(4.965291023254395, 3.398024797439575, -377.305908203125));
    end
});
v50:AddButton({
    ["Name"] = "Stable",
    ["Callback"] = function()
        TPCF(CFrame.new(-823.871826171875, 2.998025178909302, -60.357021331787109));
    end
});
v50:AddButton({
    ["Name"] = "Ranch",
    ["Callback"] = function()
        TPCF(CFrame.new(-840.34649658203125, 2.99802565574646, -395.07183837890625));
    end
});
v50:AddButton({
    ["Name"] = "Port 1",
    ["Callback"] = function()
        TPCF(CFrame.new(66.111373901367188, 3.998025178909302, -1548.33251953125));
    end
});
v50:AddButton({
    ["Name"] = "Port 2",
    ["Callback"] = function()
        TPCF(CFrame.new(53.100692749023438, 3.998025178909302, 1585.4400634765625));
    end
});
v50:AddButton({
    ["Name"] = "Island 1",
    ["Callback"] = function()
        TPCF(CFrame.new(215.209457397460938, 22.78215217590332, -2297.74267578125));
    end
});
v50:AddButton({
    ["Name"] = "Island 2",
    ["Callback"] = function()
        TPCF(CFrame.new(-28.538030624389648, 1.924685955047607, 2209.734130859375));
    end
});
v50:AddButton({
    ["Name"] = "Terrorific House",
    ["Callback"] = function()
        TPCF(CFrame.new(1002.68511962890625, 2.998025178909302, 64.572555541992188));
    end
});
v50:AddButton({
    ["Name"] = "Solar Panels",
    ["Callback"] = function()
        TPCF(CFrame.new(429.5360107421875, 2.998025178909302, 756.43511962890625));
    end
});
v50:AddButton({
    ["Name"] = "Drones",
    ["Callback"] = function()
        TPCF(CFrame.new(-670.0989990234375, 250.2216796875, 762.00775146484375));
    end
});
v50:AddButton({
    ["Name"] = "Lake",
    ["Callback"] = function()
        TPCF(CFrame.new(-239.027236938476562, -0.015772372484207, 762.54754638671875));
    end
});
v50:AddButton({
    ["Name"] = "Camp",
    ["Callback"] = function()
        TPCF(CFrame.new(-330.793853759765625, 2.998025178909302, 530.429443359375));
    end
});
v50:AddButton({
    ["Name"] = "School",
    ["Callback"] = function()
        TPCF(CFrame.new(-319.934814453125, 3.598026514053345, 210.265243530273438));
    end
});
v50:AddButton({
    ["Name"] = "Ring",
    ["Callback"] = function()
        TPCF(CFrame.new(-588.82171630859375, 140.844696044921875, -63.174579620361328));
    end
});
v50:AddButton({
    ["Name"] = "Daycare",
    ["Callback"] = function()
        TPCF(CFrame.new(-168.263259887695312, 3.598023891448975, 128.96380615234375));
    end
});
v50:AddButton({
    ["Name"] = "Pool",
    ["Callback"] = function()
        TPCF(CFrame.new(-59.038372039794922, 3.871989488601685, 136.710891723632812));
    end
});
v50:AddButton({
    ["Name"] = "Church",
    ["Callback"] = function()
        TPCF(CFrame.new(-72.7413330078125, 36.998020172119141, -198.99969482421875));
    end
});
v50:AddButton({
    ["Name"] = "Camp House",
    ["Callback"] = function()
        TPCF(CFrame.new(-261.74481201171875, 7.092472553253174, 1099.1263427734375));
    end
});
v50:AddButton({
    ["Name"] = "Yatch",
    ["Callback"] = function()
        TPCF(CFrame.new(-112.951774597167969, 5.680488586425781, 864.67547607421875));
    end
});
v50:AddLabel("Easter Eggs \240\159\165\154");
v50:AddButton({
    ["Name"] = "Hospital Easter Egg",
    ["Callback"] = function()
        TPCF(CFrame.new(-287.39581298828125, 16.584323883056641, 60.408054351806641));
    end
});
v50:AddButton({
    ["Name"] = "Town Hall Easter Egg",
    ["Callback"] = function()
        TPCF(CFrame.new(-355.673309326171875, 44.398014068603516, -118.516868591308594));
    end
});
v50:AddButton({
    ["Name"] = "Bank Easter Egg",
    ["Callback"] = function()
        TPCF(CFrame.new(-89.200408935546875, -10.701983451843262, 262.9344482421875));
    end
});
local v52 = v27:MakeTab({
    ["Name"] = "Op & Troll \240\159\146\170\240\159\152\185",
    ["Icon"] = "rbxassetid://14006914595",
    ["PremiumOnly"] = false
});
v52:AddSlider({
    ["Name"] = "Car Top Speed",
    ["Min"] = 0,
    ["Max"] = 1000,
    ["Default"] = 25,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v93)
        pcall(function()
            local v96 = 0;
            local v97;
            local v98;
            while true do
                if (v96 == (0)) then
                    local v128 = 0;
                    while true do
                        if (v128 == 1) then
                            v96 = 1;
                            break;
                        end;
                        if (v128 == 0) then
                            v97 = game.Players.LocalPlayer.Name .. "Car";
                            v98 = game.workspace.Vehicles:FindFirstChild(v97);
                            v128 = 1;
                        end;
                    end;
                end;
                if (v96 == (1)) then
                    v98.Body.VehicleSeat.TopSpeed.Value = v93;
                    break;
                end;
            end;
        end);
    end
});
v52:AddSlider({
    ["Name"] = "Car Turbo",
    ["Min"] = 0,
    ["Max"] = 1000,
    ["Default"] = 11,
    ["Color"] = Color3.fromRGB(255, 255, 255),
    ["Increment"] = 1,
    ["ValueName"] = "",
    ["Callback"] = function(v94)
        pcall(function()
            local v99 = game.Players.LocalPlayer.Name .. "Car";
            local v100 = game.workspace.Vehicles:FindFirstChild(v99);
            v100.Body.VehicleSeat.Turbo.Value = v94;
        end);
    end
});
local v53 = v27:MakeTab({
    ["Name"] = "Misc \240\159\148\167",
    ["Icon"] = "rbxassetid://",
    ["PremiumOnly"] = false
});
v53:AddButton({
    ["Name"] = "Destroy All Ban Barrier",
    ["Callback"] = function()
        local v95 = 0;
        while true do
            if ((0) == v95) then
                for v130, v131 in pairs(game.workspace:GetChildren()) do
                    if table.find(v29, v131.Name) then
                        v131:Destroy();
                    end;
                end;
                for v132, v133 in pairs(game.workspace:FindFirstChild("001_Lots"):GetDescendants()) do
                    if table.find(v29, v133.Name) then
                        v133:Destroy();
                    end;
                end;
                v95 = 1;
            end;
            if (v95 == (1)) then
                game.ReplicatedStorage.BannedLots:ClearAllChildren();
                break;
            end;
        end;
    end
});
local v54 = v53:AddSection({
    ["Name"] = "Bank Stuff"
});
v54:AddButton({
    ["Name"] = "Steal All Bank Money",
    ["Callback"] = function()
        pcall(function()
            local v102 = 0;
            while true do
                if (v102 == (0)) then
                    fireclickdetector(game.workspace.WorkspaceCom:FindFirstChild("001_Bank").FakeBankVaultMoneyBag.DuffleBagMoneyButton.ClickDetector, 0);
                    fireclickdetector(game.workspace.WorkspaceCom:FindFirstChild("001_ElevatorBank").DuffleBagBitcoin.ClickDetector, 0);
                    v102 = 1;
                end;
                if ((1) == v102) then
                    fireclickdetector(game.workspace.WorkspaceCom:FindFirstChild("001_ElevatorBank").DuffleBagDiamonds.ClickDetector, 0);
                    fireclickdetector(game.workspace.WorkspaceCom:FindFirstChild("001_ElevatorBank").DuffleBagGold.ClickDetector, 0);
                    break;
                end;
            end;
        end);
    end
});
v54:AddButton({
    ["Name"] = "Anti Laser",
    ["Callback"] = function()
        game.workspace.WorkspaceCom:FindFirstChild("001_ElevatorBank").LeftRob.LazerLeft:ClearAllChildren();
    end
});
local v55 = v53:AddSection({
    ["Name"] = "House Stuff"
});
v55:AddButton({
    ["Name"] = "No Props",
    ["Callback"] = function()
        pcall(function()
            local v103 = game.Players.LocalPlayer.Name .. "House";
            fireclickdetector(workspace["001_Lots"]:FindFirstChild(v103).HousePickedByPlayer.HouseModel["001_HouseControlGuiOpen"].CampingButton.ClickDetector);
        end);
    end
});
spawn(function()
    while wait(0.1) do
        if v37 then
            workspace.Gravity = v33;
        end;
        local v104 = v44();
        if (v36 and v104) then
            v104.JumpPower = v32;
        end;
        if (v35 and v104) then
            v104.JumpHeight = v31;
        end;
        if (v34 and v104) then
            v104.WalkSpeed = v30;
        end;
        if not v26 then
            break;
        end;
    end;
end);
spawn(function()
    while wait(0.7) do
        if v38 then
            local v124 = 0;
            local v125;
            while true do
                if (v124 == (0)) then
                    v125 = v46();
                    if v125 then
                        for v143, v144 in pairs(v125:GetChildren()) do
                            if v144:IsA("BasePart") then
                                v144.CanCollide = false;
                            end;
                        end;
                    end;
                    break;
                end;
            end;
        else
            local v126 = 0;
            local v127;
            while true do
                if (v126 == (0)) then
                    v127 = v46();
                    if v127 then
                        for v145, v146 in pairs(v127:GetChildren()) do
                            if v146:IsA("BasePart") then
                                v146.CanCollide = true;
                            end;
                        end;
                    end;
                    break;
                end;
            end;
        end;
        if not v26 then
            break;
        end;
    end;
end);
