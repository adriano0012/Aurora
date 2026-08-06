-- settings

settings = {
	Aimbot = {},
	Esp = {},
	Misc = {}
}


-- Message --
-- Configs --

function SendMessage(Text)
	game.StarterGui:SetCore("SendNotification", {
	Title = "SnowyGUI";
	Text = Text; 
	Duration = 5; 
	})
end
-- Gui Module --
local module = {};

module.tweenspeed = 0.28;

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

-- UI libary --

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse();
local visible = true;
local runserv,inputserv = game:GetService("RunService"),game:GetService("UserInputService");
local globalsettings
local configversion = 1.641
local pathfolder = "SnowyGUI/"
local configfolder = "SnowyGUI/Configs/"
local customconfigname; 
local newconfigloaded = false;
if customconfigname == nil then
    customconfigname = "Default"
end
--globalsettings = loadfile(configfolder.."Default")();
newobj("ScreenGui", {
Name = "SnowyGUIBeta";
Parent = game:GetService("CoreGui");
ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
});

local loggedin = false
local coregui = game:WaitForChild("CoreGui")
local gui = coregui.SnowyGUIBeta
local savenewthingys;

local makebutton = function(buttonname, buttontext, Parentbutton, func, args)
    newobj("Frame", {
    Name = buttonname,
    Parent = Parentbutton,
    BackgroundColor3 = module.newrgb(255,255,255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    LayoutOrder = 0,
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
            
            module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed+ 0.12,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed+ 0.12,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(success,{ImageTransparency = 0},module.tweenspeed+ 0.12,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            
            wait(module.tweenspeed);
            
            module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(success,{ImageTransparency = 1},module.tweenspeed + 0.12,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(successdrop,{ImageTransparency = 0.8},module.tweenspeed + 0.12 ,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            func(unpack(args))
            buttonstatus = "click";
        end;
    end);
    end

    local makecheckbox = function(namey, texty, parenty, func, args, globalname)
    if globalname ~= nil then
        namey = globalname
    end
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
    local estep;
    local buttonstatus = "click";
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
            func(unpack(args))
            wait(module.tweenspeed);
            
            module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            buttonstatus = "click"
        end;
    end);
    end


local maketextbox = function(namey, txt, parenty)
    newobj("Frame", {
    Name = namey,
    Parent = parenty,
    BackgroundColor3 = module.newrgb(255,255,255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    LayoutOrder = 0,
    Size = UDim2.new(1, 0, 0, 28)
    });
    
    newobj("TextBox", {
    Name = "TextBox";
    Parent = parenty:FindFirstChild(namey);
    BackgroundColor3 = Color3.new(1, 1, 1);
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 1, 0);
    ZIndex = 7;
    Text = "";
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
            customconfigname = string.gsub(textthingy.Text, "%s+", "")
            module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            
            wait(module.tweenspeed);
            
            module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            else
            customconfigname = string.gsub(textthingy.Text, "%s+", "")  
            module.newtween(base,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(33,27,44)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            
            wait(module.tweenspeed);
            
            module.newtween(base,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
            module.newtween(baseglow,{ImageColor3 = module.newrgb(19,16,25)},module.tweenspeed*1.75,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
        end
    end)
    end

SendMessage("Welcome to SnowyGUI Beta")
SendMessage("Facts: "..game:HttpGet("http://snowygui.com/buyers/owo.php?type=fact"))
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

    
    

local makeslider = function(namey,texty,defvalue,Thingy,max,parenty)
--[[if not globalsettings[Thingy] then
    return SendMessage("Slider broken lol welp not my problem bye xd");
end--]]
namey = Thingy
newobj("Frame", {
Name = namey;
Parent = parenty;
BackgroundColor3 = module.newrgb(1, 1, 1);
BackgroundTransparency = 1;
BorderSizePixel = 0;
LayoutOrder = 0;
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
Text = Thingy,--globalsettings[Thingy];
TextColor3 = module.newrgb(133, 131, 136);
TextSize = 15;
TextXAlignment = Enum.TextXAlignment.Right;
});

newobj("NumberValue", {
    Name = "Max";
    Parent = parenty:FindFirstChild(namey).optionsens;
    Value = max;
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
Text = Thingy,--globalsettings[Thingy];
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
local loop;
button.MouseButton1Down:Connect(function()
	if buttonstatus == "ready" then
		
        buttonstatus = slider;
        
		module.newtween(base,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		module.newtween(baseglow,{ImageColor3 = module.newrgb(12,10,21)},module.tweenspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut);
		
		spawn(function()
            loop = runserv.Heartbeat:connect(function()
                
                if slider == buttonstatus then
					button.Position = UDim2.new(0,(mouse.X-bar.AbsolutePosition.X),0.5,-5);
			
					if button.Position.X.Offset < 0 then
						button.Position = UDim2.new(0,0,0.5,-5);
					elseif button.Position.X.Offset+button.Size.X.Offset > bar.AbsoluteSize.X then
						button.Position = UDim2.new(0,(bar.AbsoluteSize.X-button.Size.X.Offset),0.5,-5);
					end
			
	    			globalsettings[Thingy] = (button.AbsolutePosition.X-bar.AbsolutePosition.X)/(bar.AbsoluteSize.X-button.Size.X.Offset)*max;
	    			sens.Text = string.sub(tostring(globalsettings[Thingy]),1,5);
	    			sensdrop.Text = string.sub(tostring(globalsettings[Thingy]),1,5);
	
				end;
			end);
		end);
	
	end;
end);


inputserv.InputEnded:connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and slider == buttonstatus then
        loop:Disconnect()
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

makeframe('Aimbot','Aimbot Settings',UDim2.new(0,0,0,0),gui,true)
makecheckbox('Enabled','Enabled',gui.Aimbot.holder.contents.optionscroll,function() end,{},'yea')
makecheckbox('Team','Team Check',gui.Aimbot.holder.contents.optionscroll,function() end,{},'yeaa')
makecheckbox('Wall','Visibility Check',gui.Aimbot.holder.contents.optionscroll,function() end,{},'yeaaa')
--makecheckbox('Enabled','Enabled',gui.Aimbot.holder.contents.optionscroll,function() end,{},'yea')
--makecheckbox('Enabled','Enabled',gui.Aimbot.holder.contents.optionscroll,function() end,{},'yea')

--[[
local main = makeframe('main','Hey there!',UDim2.new(0,0,0,0),gui,true)
makecheckbox('fucka','Test 1',gui.main.holder.contents.optionscroll,function() end,{},'yea')
makebutton('yes','Test 2',gui.main.holder.contents.optionscroll,function() print('fuck') end, {})
makeslider('yesirz','Test 3',0,'wtf',10,gui.main.holder.contents.optionscroll)
makebutton('yeer','Test 4',gui.main.holder.contents.optionscroll,function() print('frick') end, {})
--]]
spawn(function() -- I wonder if that works lol @Eski try that lol I copied it from my old source really oold onme
    for i,v in pairs(gui:GetDescendants()) do
        if v:IsA("ScrollingFrame") and v.Name == "optionscroll"  then
            module.makescrollautoupdate(v,v.optionlayout);
            game:GetService("RunService").Heartbeat:wait()
            local frametest = Instance.new("Frame", v)
            frametest.Size = UDim2.new(0, 0,0, 0)
            wait(1)
            frametest:Destroy() -- readtederdas shit
        end
    end
end)
--maketextbox('yesir','Test 4',sg.main.holder.contents.optionscroll)
