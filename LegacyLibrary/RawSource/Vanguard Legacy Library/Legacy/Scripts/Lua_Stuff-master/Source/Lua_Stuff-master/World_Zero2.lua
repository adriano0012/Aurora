-- Services
local ts = game:GetService'TextService'
local uis = game:GetService'UserInputService'
local HttpService = game:GetService("HttpService")
local ui = setmetatable({sg = Instance.new('ScreenGui',game.CoreGui),opened=true},{__metatable = function(a) print(a) end})

-- Data
local Settings = {}
if isfile('eski.json') then
	Settings = HttpService:JSONDecode(readfile('eski.json'))
end
local Keybinds = {}
local ExcludeFromMinimize = {}
-- Functions
local function tabletostring(tbl)
  local a = ''
  for i,v in pairs(tbl) do
    a = a..tostring(v)..','
  end
  return a
end
local KeybindHandler = uis.InputBegan:connect(function(key)
  for i,v in pairs(Keybinds) do
    if key.KeyCode == Enum.KeyCode[i] then
      for _,k in pairs(v) do
        for _,func in pairs(k) do
          spawn(func)
        end
      end
    end
  end
end)
local function AddKeybind(Key,name,func)
  if not Keybinds[Key] then
    Keybinds[Key] = {{[name]=func}}
  else
    table.insert(Keybinds[Key],{[name]=func})
  end
end
local function RemoveKeybind(name)
  for i,v in pairs(Keybinds) do
    for c,k in pairs(v) do
      for namee,func in pairs(k) do
        if namee == name then
          table.remove(v,c)
        end
      end
    end
  end
end

--AddKeybind('F','Eski',function() print'hi' end)
--RemoveKeybind('Eski')

local function new(obj,props)
	local _obj = Instance.new(obj)
	for Index,Value in pairs(props) do
		if type(Value) == 'function' then
			Value(_obj)
		else
			_obj[Index]=Value
		end
	end
	return _obj
end
-- new('Frame',{Size=UDim2.new()})
function Roundify(gui,px)
	local Frame = new('ImageLabel',{
		ZIndex = gui.ZIndex,
		Name = math.random(1420420,99999999),
		ImageColor3 = gui.BackgroundColor3,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1,0,1,0),
		Image = "rbxassetid://3570695787",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = (px and px/100 or .06),
		Parent = gui,
	})
	gui.ZIndex = gui.ZIndex + 1
	gui.BackgroundTransparency = 1
end
-- Roundify(GUIObj, pixels)
local function FixPosition() -- for multiple ui:new() objs
	local ScreenSize = workspace.CurrentCamera.ViewportSize
	local x,y = ScreenSize.X, ScreenSize.Y
	local curx,cury = 10,10
	for i,v in pairs(ui.sg:GetChildren()) do
		if not ((curx + v.AbsoluteSize.X + 10) > x) then
			v.Position = UDim2.new(0,curx,0,cury)
			curx = curx + v.AbsoluteSize.X + 10
		else
			curx = 10
			cury = cury + 260
			v.Position = UDim2.new(0,curx,0,cury)
			curx = curx + v.AbsoluteSize.X + 10
		end
	end
end
-- UI
local Menus = {}
function ui:new(name,double)
  local Title = new('TextButton',{
		Draggable = true,
		BackgroundColor3 = Color3.fromRGB(53,138,242),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = '  Eski Meme '..name[1]..' - '..name[2],
		TextColor3 = Color3.new(1,1,1),
		TextXAlignment = 'Left',
		Font = 'Arial',
		TextSize = 15,
		Size = UDim2.new(0,220,0,30),
		Position = UDim2.new(0,20+230*#self.sg:GetChildren(),0.1,0),
		Parent = self.sg
	})
  table.insert(Menus,Title)
  FixPosition()
  local Background = new('ScrollingFrame',{
		Size = UDim2.new(1,0,0,220),
		Position = UDim2.new(0,0,1,0),
		BackgroundColor3 = Color3.fromRGB(40,40,40),
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.fromRGB(99,99,99),
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		CanvasSize = UDim2.new(1,0,0,600),
		Parent = Title,
	})
	if double then
		Title.Size = UDim2.new(0,220*2+10,0,30)
		local Left = new('Frame',{
		  BackgroundTransparency = 1,
		  Size = UDim2.new(.5,0,1,0),
		  Parent = Background,
		  Name = 'Left',
		})
		local Right = Left:Clone()
		Right.Parent = Background
		Right.Position = UDim2.new(0.5,0,0,0)
		Right.Name = 'Right'
	end
  local Close = new('TextButton',{
		Size = UDim2.new(0,30,0,30),
		Position = UDim2.new(1,-30,0,0),
		BackgroundTransparency = 1,
		Text = '-',
		TextColor3 = Color3.new(1,1,1),
		Font = 'Arial',
		TextSize = 15,
		Parent = Title,
	})
	Close.MouseButton1Down:connect(function() Background.Visible = not Background.Visible end)
	Close.MouseButton2Down:connect(function()
		if ExcludeFromMinimize[Title] then
			ExcludeFromMinimize[Title] = false
			Title.BackgroundColor3 = Color3.fromRGB(53,138,242)
		else
			ExcludeFromMinimize[Title] = true
			Title.BackgroundColor3 = Color3.fromRGB(30,110,220)
		end
	end)
  local function SetNextPos(Gui)
    if not double then
      if #Background:GetChildren() == 1 then
        Gui.Position = UDim2.new(0,5,0,5)
      else
        local DroppedPos = 0
        for i,v in pairs(Background:GetChildren()) do
          local num = (v.AbsoluteSize.Y + v.Position.Y.Offset) + 5
          if num > DroppedPos and v ~= Gui  then
           DroppedPos = num
          end
        end
        Gui.Position = UDim2.new(0,5,0,DroppedPos)
        Gui.Parent.CanvasSize = UDim2.new(1,0,0,DroppedPos + Gui.AbsoluteSize.Y + 10)
      end
    else
        if #Gui.Parent:GetChildren() == 1 then
          Gui.Position = UDim2.new(0,5,0,5)
        else
          local DroppedPos = 0
          for i,v in pairs(Gui.Parent:GetChildren()) do
            local num = (v.AbsoluteSize.Y + v.Position.Y.Offset) + 5
            if num > DroppedPos and v ~= Gui then
             DroppedPos = num
            end
          end
          Gui.Position = UDim2.new(0,5,0,DroppedPos)
        end
        if Gui.Parent.Name == 'Right' then
          Gui.Position = Gui.Position - UDim2.new(0,8,0,0)
        end
    end
  end
  local ui = {}
    ui.Button = function(name,callback,Side)
			local Re = new('Frame',{
				Size = UDim2.new(1,-20,0,25),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				Parent = Background
			})
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
			Roundify(Re,3)
			local Toggle = new('TextButton',{
				Size = UDim2.new(1,-2,1,-2),
				Position = UDim2.new(0,1,0,1),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = name,
				TextColor3 = Color3.new(1,1,1),
				TextSize = 8,
				Parent = Re,
			})
			Roundify(Toggle,3)
      Toggle.MouseButton1Down:connect(callback)
		end
    ui.Label = function(Name,Side)
      local Re = new('TextLabel',{
				Size = UDim2.new(1,-15,0,15),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
        Text=Name,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 8,
				Parent = Background
			})
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
    end
    ui.Toggle = function(name,global,Side)
      local Toggle = new('TextButton',{
				Size = UDim2.new(0,15,0,15),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = '',
        Font = 'GothamBold',
        TextSize = 14,
        TextColor3 = Color3.fromRGB(40,40,40),
				Parent = Background,
			})
      Roundify(Toggle,3)
      if double then
        Toggle.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Toggle)
			local RToggle = new('Frame',{
				Size = UDim2.new(0.9,0,.9,0),
				Position = UDim2.new(0.05,0,.05,0),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				Parent = Toggle
			})
      Roundify(RToggle,3)
			local Label = new('TextLabel',{
				Size = UDim2.new(0,ts:GetTextSize(name,12,'Arial',Vector2.new(999,999)).X,0,15),
				Position = UDim2.new(1,5,0,1),
				Text = name,
				TextSize = 12,
				Font = 'Arial',
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Parent = Toggle
			})
			Toggle.MouseButton1Down:connect(function()
				RToggle.Visible = not RToggle.Visible
        Settings[global]= not RToggle.Visible
        print(not RToggle.Visible)
			end)
    end
    ui.Slider = function(name,global,float,Max,Side)
      local Bg = new('Frame',{
        Size = UDim2.new(1,-20,0,55),
        BackgroundColor3=Color3.fromRGB(53,138,242),--Color3.fromRGB(53,138,242)
        Parent = Background
      })
      Roundify(Bg,3)
      local BG = new('Frame',{
        Size = UDim2.new(1,-2,1,-2),
        Position = UDim2.new(0,1,0,1),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Parent = Bg,
      })
      local Label = new('TextLabel',{
        Position = UDim2.new(0,10,0,2),
        Size = UDim2.new(.8,0,0,15),
        Text = name,
        TextXAlignment = 'Left',
        TextSize = 8,
        TextColor3 = Color3.new(1,1,1),
        Parent = BG
      })
      Label.Text = string.format(name,0)
      Roundify(BG,3)
      Roundify(Label,3)
      if double then
        Bg.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Bg)

      local SliderBar = new('Frame',{
        Size = UDim2.new(.9,0,0,3),
        Position = UDim2.new(.05,0,.6,0),
        BackgroundColor3 = Color3.fromRGB(100,100,100),
        Parent = BG,
      })
      Roundify(SliderBar,3)
      local SliderBall = new('Frame',{
        BackgroundColor3=Color3.fromRGB(53,138,242),
        Position = UDim2.new(0,0,0.5,-7.5),
        Size = UDim2.new(0,15,0,15),
        Parent = SliderBar
      })
      Roundify(SliderBall,10)
      SliderBall.Active = true
      SliderBall.Draggable = true
      SliderBall:GetPropertyChangedSignal'Position':connect(function()
        SliderBall.Position = UDim2.new(0,math.clamp(SliderBall.Position.X.Offset,0,SliderBar.AbsoluteSize.X-10),0,-6.5)
        if float then
          local val = math.floor((SliderBall.Position.X.Offset/(SliderBar.AbsoluteSize.X-10))*Max)
          Label.Text = string.format(name,val)
          Settings[global]=val
        else
          local val = SliderBall.Position.X.Offset/(SliderBar.AbsoluteSize.X-10)
          val = math.floor(val*Max*10)/10
          Label.Text = string.format(name,val)
          Settings[global]=val
        end
      end)
    end
    ui.CheckSlider = function(name,global,global2,float,Max,Side)
      local Bg = new('Frame',{
        Size = UDim2.new(1,-20,0,55),
        BackgroundColor3=Color3.fromRGB(53,138,242),
        Parent = Background
      })
      Roundify(Bg,3)
      local BG = new('Frame',{
        Size = UDim2.new(1,-2,1,-2),
        Position = UDim2.new(0,1,0,1),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Parent = Bg,
      })
      local Label = new('TextLabel',{
        Position = UDim2.new(.15,0,0,5),
        Size = UDim2.new(.8,0,0,15),
        Text = name,
        TextXAlignment = 'Left',
        TextSize = 8,
        TextColor3 = Color3.new(1,1,1),
        Parent = BG
      })
      Label.Text = string.format(name,0)
      Roundify(Label,3)
      Roundify(BG,3)
      if double then
        Bg.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Bg)

      local SliderBar = new('Frame',{
        Size = UDim2.new(.9,0,0,3),
        Position = UDim2.new(.05,0,.6,0),
        BackgroundColor3 = Color3.fromRGB(100,100,100),
        Parent = BG,
      })
      Roundify(SliderBar,3)
      local SliderBall = new('Frame',{
        BackgroundColor3=Color3.fromRGB(53,138,242),
        Position = UDim2.new(0,0,0.5,-7.5),
        Size = UDim2.new(0,15,0,15),
        Parent = SliderBar
      })
      Roundify(SliderBall,10)
      SliderBall.Active = true
      SliderBall.Draggable = true
      SliderBall:GetPropertyChangedSignal'Position':connect(function()
        SliderBall.Position = UDim2.new(0,math.clamp(SliderBall.Position.X.Offset,0,SliderBar.AbsoluteSize.X-10),0,-6.5)
        if float then
          local val = math.floor((SliderBall.Position.X.Offset/(SliderBar.AbsoluteSize.X-10))*Max)
          Label.Text = string.format(name,val)
          Settings[global2]=val
        else
          local val = SliderBall.Position.X.Offset/(SliderBar.AbsoluteSize.X-10)
          val = math.floor(val*Max*10)/10
          Label.Text = string.format(name,val)
          Settings[global2]=val
        end
      end)
      local Toggle = new('TextButton',{
				Size = UDim2.new(0,15,0,15),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = '',
        Position = UDim2.new(0,5,0,5),
				Parent = BG,
			})
      Roundify(Toggle,3)
			local RToggle = new('Frame',{
				Size = UDim2.new(0.9,0,.9,0),
				Position = UDim2.new(0.05,0,.05,0),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				Parent = Toggle
			})
      Roundify(RToggle,3)
			Toggle.MouseButton1Down:connect(function()
				RToggle.Visible = not RToggle.Visible
        Settings[global]= not RToggle.Visible
        print(not RToggle.Visible)
			end)
    end
    ui.Keybind = function(name,func,Side)
      local Toggle = new('TextButton',{
				Size = UDim2.new(0,15,0,15),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Text = '',
				Parent = Background,
			})
      Roundify(Toggle,3)
      if double then
        Toggle.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Toggle)
			local RToggle = new('Frame',{
				Size = UDim2.new(0.9,0,.9,0),
				Position = UDim2.new(0.05,0,.05,0),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				Parent = Toggle
			})
      Roundify(RToggle,3)
			local Label = new('TextLabel',{
				Size = UDim2.new(0,ts:GetTextSize(name,12,'Arial',Vector2.new(999,999)).X,0,15),
				Position = UDim2.new(1,5,0,1),
				Text = name,
				TextSize = 12,
				Font = 'Arial',
				TextColor3 = Color3.new(1,1,1),
				BackgroundTransparency = 1,
				Parent = Toggle
			})
      local Key = new('TextLabel',{
        Size = UDim2.new(0,30,1,0),
        Position = UDim2.new(1,10,0,0),
        BackgroundTransparency = 1,
        Text = '',
        TextXAlignment = 'Left',
				TextSize = 12,
				Font = 'Arial',
				TextColor3 = Color3.new(1,1,1),
        Parent = Label,
      })
      local newfunc = function()
        if not RToggle.Visible then
          spawn(func)
        end
      end
      Toggle.MouseButton2Down:connect(function()
        Key.Text = ''
        local a = uis.InputBegan:wait()
        local a = uis.InputBegan:wait()
        for i=1,#tostring(a.KeyCode) do
          if tostring(a.KeyCode):sub(i,i) == '.' then
            Key.Text = tostring(a.KeyCode):sub(i+1)
          end
        end
        RemoveKeybind(name)
        AddKeybind(Key.Text,name,newfunc)
      end)
			Toggle.MouseButton1Down:connect(function()
				RToggle.Visible = not RToggle.Visible
			end)
    end
    ui.Input = function(name,global,numsonly,Side)
      local Re = new('TextBox',{
				Size = UDim2.new(0,60,0,23),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
        Text = name,
				TextColor3 = Color3.new(1,1,1),
				TextSize = 12,
        Font='Arial',
				Parent = Background
			})
      Re.Size = UDim2.new(0,60+ts:GetTextSize(Re.Text,12,'Arial',Vector2.new(999,999)).X,0,23)
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
			Roundify(Re,3)
			local Toggle = new('Frame',{
				Size = UDim2.new(1,2,1,2),
				Position = UDim2.new(0,-1,0,-1),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				Parent = Re,
			})
			Roundify(Toggle,3)
      Re.ZIndex = Re.ZIndex + 1
      Re:GetChildren()[1].ZIndex = Re.ZIndex
      Re.ZIndex = Re.ZIndex + 1
      Re:GetPropertyChangedSignal'Text':connect(function()
        if numsonly then
          if type(tonumber(Re.Text)) ~= 'number' then
            Re.PlaceholderText = '0'
            Re.Text = ''
          end
        end
        Re.Size = UDim2.new(0,60+ts:GetTextSize(Re.Text,12,'Arial',Vector2.new(999,999)).X,0,23)
        Settings[global]=Re.Text
      end)
		end
    ui.Label = function(Name,Side)
      local Re = new('TextLabel',{
				Size = UDim2.new(1,-15,0,15),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
        Text=Name,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 8,
				Parent = Background
			})
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
    end
    ui.Selection = function(name,global,data,Checkboxes,func)
      local selected = {}
      local Re = new('Frame',{
				Size = UDim2.new(1,-20,0,75),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				Parent = Background
			})
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
			Roundify(Re,3)
			local Toggle = new('Frame',{
				Size = UDim2.new(1,-2,1,-2),
				Position = UDim2.new(0,1,0,1),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				Parent = Re,
			})
      local Label = new('TextLabel',{
        Size = UDim2.new(1,0,0,10),
        Position = UDim2.new(0,5,0,7),
        BackgroundTransparency = 1,
        Text = name:format('nil'),
        TextColor3 = Color3.new(1,1,1),
				TextSize = 8,
        TextWrapped = true,
        TextXAlignment = 'Left',
        Parent = Re,
      })
      Label.ZIndex = Re.ZIndex
      local Scroll = new('ScrollingFrame',{
        Size = UDim2.new(1,0,1,-20),
        Position = UDim2.new(0,0,0,20),
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = Color3.fromRGB(99,99,99),
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
    		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        Parent = Re,
      })
      for i,v in pairs(data) do
        if not Checkboxes then
          local a = new('TextButton',{
            Size = UDim2.new(1,0,0,15),
            Position = UDim2.new(0,0,0,17*(#Scroll:GetChildren())+3),
            Text = v,
            TextColor3 = Color3.new(1,1,1),
    				TextSize = 8,
            BackgroundTransparency=1,
            Parent = Scroll,
          })
          a.MouseButton1Down:connect(function()
            Label.Text = name:format(a.Text)
            Settings[global]=a.Text
          end)
          Scroll.CanvasSize = UDim2.new(1,0,0,20*(#Scroll:GetChildren()))
        else
          local Toggle = new('TextButton',{
    				Size = UDim2.new(0,15,0,15),
            Position = UDim2.new(0,5,0,20*#Scroll:GetChildren()+5),
    				BackgroundColor3 = Color3.fromRGB(53,138,242),
    				BorderSizePixel = 0,
    				AutoButtonColor = false,
    				Text = '',
    				Parent = Scroll,
    			})
          Scroll.CanvasSize = UDim2.new(1,0,0,25*(#Scroll:GetChildren()))
          Roundify(Toggle,3)
          if double then
            Toggle.Parent = (Side and Background['Left'] or Background['Right'])
          end
    			local RToggle = new('Frame',{
    				Size = UDim2.new(0.9,0,.9,0),
    				Position = UDim2.new(0.05,0,.05,0),
    				BackgroundColor3 = Color3.fromRGB(40,40,40),
    				BorderSizePixel = 0,
    				Parent = Toggle
    			})
          Roundify(RToggle,3)
    			local Labell = new('TextLabel',{
    				Size = UDim2.new(0,ts:GetTextSize(name,12,'Arial',Vector2.new(999,999)).X,0,15),
    				Position = UDim2.new(1,5,0,1),
    				Text = v,
    				TextSize = 12,
    				Font = 'Arial',
    				TextColor3 = Color3.new(1,1,1),
    				BackgroundTransparency = 1,
    				Parent = Toggle
    			})
    			Toggle.MouseButton1Down:connect(function()
    				RToggle.Visible = not RToggle.Visible
            if not RToggle.Visible then
              local db = false
              for i,v in pairs(selected) do
                if v == Labell.Name then
                  db = true
                end
              end
              if not db then selected[i]=v end
            else
              for i,k in pairs(selected) do
                if k == v then
                  table.remove(selected,i)
                end
              end
            end
            Settings[global]= selected
            local a = ts:GetTextSize(name:format(tabletostring(selected)),12,'Arial',Vector2.new(300,10))
            if a.X > Label.AbsoluteSize.X then
              Label.Text = name:format(#selected)
            else
              Label.Text = name:format(tabletostring(selected))
            end

    			end)
        end
      end
    end
    ui.ColorPicker = function(name,global,ObjsToChange)
      local Re = new('Frame',{
				Size = UDim2.new(1,-20,0,125),
				BackgroundColor3 = Color3.fromRGB(53,138,242),
				BorderSizePixel = 0,
				Parent = Background
			})
      if double then
        Re.Parent = (Side and Background['Left'] or Background['Right'])
      end
			SetNextPos(Re)
			Roundify(Re,3)
			local Toggle = new('Frame',{
				Size = UDim2.new(1,-2,1,-2),
				Position = UDim2.new(0,1,0,1),
				BackgroundColor3 = Color3.fromRGB(40,40,40),
				BorderSizePixel = 0,
				Parent = Re,
			})
      local Label = new('TextLabel',{
        Size = UDim2.new(1,0,0,10),
        Position = UDim2.new(0,5,0,7),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Color3.new(1,1,1),
				TextSize = 8,
        TextXAlignment = 'Left',
        Parent = Re,
      })
    end
  return ui
end
--[[
ui:new( table{game (string),section (string)}, doublesized (bool))
ui.Label(name)
ui.Button(name,callback (function),Side (bool))
ui.Toggle(name,global,Side (bool))
ui.Slider(name,global,float (bool),Max (int),Side (bool))
ui.CheckSlider(name,globalForToggle ,globalForValue ,float (bool),Max (int),Side (bool))
ui.Keybind(name, function)
ui.Input(name, global, Numbers Only)

]]

-- I still need a Color Selector ,

AddKeybind('Insert','MenuToggle',function() ui.opened = not ui.opened for i,v in pairs(Menus) do if not ExcludeFromMinimize[v] then v.Visible = ui.opened end end end)

game.Workspace.Characters.ChildAdded:connect(function(chr)

	local hp = chr:WaitForChild('HealthProperties')
	local te = Instance.new('Vector3Value')
	te.Parent = hp
	local h = chr:WaitForChild'Health':Destroy()
	te.Name = 'Health'
end)

local plr = game:GetService'ReplicatedStorage'.Profiles[game.Players.LocalPlayer.Name]
Class = plr.Class.Value

local Ar = ui:new({'WZ','Main'},false)
Ar.Label(Class)
--Ar.Toggle('Attack Players','AP')
Ar.Toggle('Remove Damage Tags','Damage')
Ar.CheckSlider('Kill Aura (%s)','WZAura','Distance',true,200)
Ar.Slider('Vector (Down - Up)','AVector',true,20)
Ar.Slider('Vector (Infront - Behind)','BVector',true,20)
Ar.Toggle('Teleport To Mobs','TpMobs')
Ar.Button('Freeze Mobs',function() for i,v in pairs(workspace.Mobs:GetChildren()) do pcall(function() v:FindFirstChild'Collider':FindFirstChild'Walker':Destroy() end) end end)
Ar = ui:new({'WZ','Misc'},false)
Ar.Toggle('Weapon Trails','Trails')
Ar.Toggle('Auto collect Coins','ACoins')
Ar.Slider('Sprint Speed (%s)','Walkspeed',true,10)
Ar.CheckSlider('Weapon Size (%s)','WSize','Size',false,2)
local ws = require(game.ReplicatedStorage.Shared.WalkspeedManager)
wsfunc = ws.AddWalkspeedMultiplier
ws.AddWalkspeedMultiplier = function(...)
	if ({...})[3] == 'Sprinting' then 
		a = {...}
		return wsfunc(a[1],a[2],a[3],(Settings['Walkspeed'] or 1.4))
	end
end
local _a = require(game:GetService("ReplicatedStorage").Shared.Coins).ReceiveCoinInfo
local CoinCache = {}
require(game:GetService("ReplicatedStorage").Shared.Coins).ReceiveCoinInfo = function(...)
	for i,v in pairs(({...})) do
		if type(v) == 'table' then
			if v.id and Settings['ACoins'] then
				game:GetService("ReplicatedStorage").Shared.Coins.CoinEvent:FireServer(v.id)
				for i,v in pairs(CoinCache) do
					game:GetService("ReplicatedStorage").Shared.Coins.CoinEvent:FireServer(v)
					table.remove(CoinCache,i)
				end
			elseif v.id and not Settings['ACoins'] then
				table.insert(CoinCache,v.id)
			end
		end
	end
	_a(...)
end
function GetTarget()
  local mobs = {}
  local poss = {}
	for i,v in pairs(workspace.Mobs:GetChildren()) do
		if v:FindFirstChild'Model' and (v.Model.PrimaryPart.Position - game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < (Settings['Distance'] or 0) and v.HealthProperties.Health.Value > 0 then
        table.insert(mobs,v)
        table.insert(poss,Settings['Damage'] and Vector3.new(9999,9999,9999) or v.Model.PrimaryPart.Position)
		end
	end
  return {mobs,poss}
end


local Shared = game:GetService'ReplicatedStorage'.Shared
local Combat = Shared.Combat
local Skillsets = Combat.Skillsets
Swordmaster = {
  'CrescentStrike1','CrescentStrike2','CrescentStrike3','Swordmaster1','Swordmaster2','Swordmaster3','Swordmaster4','Swordmaster5','Swordmaster6','Leap'--,
}
DualWielder = {
 'Leap1','Leap2','DualWield1','DualWield2','DualWield3','DualWield4','DualWield5','WhirlwindSpin1','WhirlwindSpin2','WhirlwindSpin3','WhirlwindSpin4','AWhirlwindSpin','BWhirlwindSpin','DualWieldUltimateHit1','DualWieldUltimateHit2','DualWieldUltimateHit3','DualWieldUltimateHit4','DualWieldUltimateHit5','DualWieldUltimateSlam',
}
Paladin = {
	'Paladin1','Paladin2','Paladin3','Paladin4','LightThrust1','LightThrust2','LightPaladin1','LightPaladin2'
}

Mage = {
'Mage1','ArcaneWave1','ArcaneWave2','ArcaneWave3','ArcaneWave4','ArcaneWave5','ArcaneWave6','ArcaneWave7','ArcaneWave8','ArcaneWave9','ArcaneWave10','ArcaneWave11','ArcaneWave12','ArcaneBlast','ArcaneBlastAOE'
}
IcefireMage = {
	'IcefireMage1','IcySpikes1','IcySpikes2','IcySpikes3','IcySpikes4','IcySpikes5','IceFireMageFireball','IceFireMageFireballBlast','IcefireMageUltimateMeteor1','IcefireMageUltimateMeteor2','IcefireMageUltimateMeteor3','IcefireMageUltimateMeteor4','IcefireMageUltimateMeteor5','IcefireMageUltimateMeteor6','IcefireMageUltimateMeteor7','IcefireMageUltimateMeteor8','IcefireMageUltimateMeteor9'
}
MageOfLight = {
	'MageOfLight','MageOfLightBlast'
}
Defender = {
  'Defender1','Defender2','Defender3','Defender4','Defender5','Spin1','Spin2','Spin3','Spin4','Spin5','Groundbreaker',
}
Guardian = {
	'RockSpikes1','RockSpikes2','RockSpikes3','RockSpikes4','RockSpikes5','Guardian1','Guardian2','Guardian3','Guardian4','SlashFury1','SlashFury2','SlashFury3','SlashFury4','SlashFury5','SlashFury6','SlashFury7','SlashFury8','SlashFury9','SlashFury10','SlashFury11','SlashFury12','SlashFury13','SlashFury14','SwordPrison1','SwordPrison2','SwordPrison3','SwordPrison4','SwordPrison5','SwordPrison6','SwordPrison7','SwordPrison8','SwordPrison9','SwordPrison10','SwordPrison11','SwordPrison12',
}
Berserker = {
	'Berserker1','Berserker2','Berserker3','Berserker4','Berserker5','Berserker6','AggroSlam','GigaSpin1','GigaSpin2','GigaSpin3','GigaSpin4','GigaSpin5','GigaSpin6','GigaSpin7','GigaSpin8','Fissure1','Fissure2','FissureErupt1','FissureErupt2','FissureErupt3','FissureErupt4','FissureErupt5','FissureErupt6',
}

function Attack(mob,pos,role)
	local combat = require(game.ReplicatedStorage.Shared.Combat)
	--combat:AttackTargets(mobs, positions, attack)
	local args = {
		mob,
		pos,
		[3] = 'DualWield1'
	}
	for i,v in pairs(getfenv()[Class]) do
		args[3] = v
		combat:AttackTargets(unpack(args))
	end
end

local chars = workspace.Characters
local plr = chars[game.Players.LocalPlayer.Name]
for i,v in pairs(getconnections(plr.Collider.Changed)) do
    v:Disable()
end
for i,v in pairs(plr:GetChildren()) do
    if v:IsA'BasePart' then
        for i,k in pairs(getconnections(v.Changed)) do
            k:Disable()
        end
    end
end
local props = plr.Properties
spawn(function()
	while wait() do
		if Settings['WZAura'] then
			local mob = GetTarget()
			if #mob[1] > 0 then
				Attack(mob[1],mob[2])
			end
		end
	end
end)
while wait() do
	writefile('eski.json',HttpService:JSONEncode(Settings))
	if  Settings['TpMobs'] then
		for i,v in pairs(workspace.Mobs:GetChildren()) do
			if v.HealthProperties.Health.Value > 0 and not v:FindFirstChild'NoHealthbar' then
				local pos = (v.PrimaryPart or v:FindFirstChild'Model')
				if pos then 
					if not plr then plr = workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name) break end
					pos = pos.CFrame * CFrame.new(math.random(1,10)/math.random(6,9)*.069,(Settings['AVector'] or 0 ) - 5,(Settings['BVector'] or 0) -5)
					plr:FindFirstChild'Collider'.CFrame = pos-- = CFrame.new(pos)
					plr:FindFirstChild'Collider'.Velocity = Vector3.new()
					break
				end
			end
		end
	end
	if props then
		props.RigScale.Value = (Settings['WSize'] and (1 + (Settings['Size'] or 0)))
		props.WeaponTrails.Value = (Settings['Trails'])
	else
		if plr then props = plr:FindFirstChild'Properties' end
	end
end
