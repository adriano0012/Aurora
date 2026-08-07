local Screen = Instance.new('ScreenGui',game.CoreGui)
getgenv().Screen = Screen
Screen.Enabled = false
syn.protect_gui(Screen)
local Background = Instance.new('TextButton')
Background.Size = UDim2.new(1,0,1,0)
Background.AutoButtonColor = false
Background.BackgroundColor3 = Color3.fromRGB(33,33,33)
Background.Text = ''
Background.Transparency = .5
Background.Modal = true
Background.BorderSizePixel = 0
Background.Parent = Screen
uis.InputBegan:connect(function(keycode)
    if not rawget(Settings,'MenuKey') then return error'Gui No menu Key'  end
    if keycode.KeyCode == Enum.KeyCode[Settings.MenuKey] then
        Screen.Enabled = not Screen.Enabled
    end
end)

spawn(function()
    wait(5)
    Screen:Destroy()
end)


--[[
function MakeDraggable(Gui)
    local Smooth = 6.9
	if Gui.ClassName == 'TextButton' and Gui.Draggable then
		Gui.Draggable = false
	end
	local IsHovered = false;
	local IsDragging = false
	local HoveredOffset = Vector2.new();
	Gui.MouseEnter:connect(function() IsHovered = true end)
	Gui.MouseLeave:connect(function() IsHovered = false end)
	uis.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and IsHovered then
			HoveredOffset = Gui.AbsolutePosition - Vector2.new(Mouse.X,Mouse.Y)
			IsDragging = true
		end
	end)
	uis.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			HoveredOffset = Vector2.new()
			IsDragging = false
		end
	end)
	game:GetService('RunService').RenderStepped:connect(function()
		if IsDragging and Gui then
			local moveto = Gui.AbsolutePosition + ((Vector2.new(Mouse.X,Mouse.Y) + HoveredOffset) - Gui.AbsolutePosition)/Smooth
			local Clip = Vector2.new(math.clamp(moveto.X,0,Mouse.ViewSizeX-Gui.AbsoluteSize.X),math.clamp(moveto.Y,0,Mouse.ViewSizeY-(Gui.Contents.AbsoluteSize.Y+Gui.AbsoluteSize.Y)))
			Gui.Position = UDim2.new(0,Clip.X,0,Clip.Y)
		end
	end)
end


local Screen = Instance.new('ScreenGui',game.CoreGui)
Screen.Enabled = false
syn.protect_gui(Screen)
local Background = Instance.new('TextButton')
Background.Size = UDim2.new(1,0,1,0)
Background.AutoButtonColor = false
Background.BackgroundColor3 = Color3.fromRGB(33,33,33)
Background.Text = ''
Background.Transparency = .5
Background.Modal = true
Background.BorderSizePixel = 0
Background.Parent = Screen
uis.InputBegan:connect(function(keycode)
    if not rawget(Settings,'MenuKey') then return error'Gui No menu Key'  end
    if keycode.KeyCode == Enum.KeyCode[Settings.MenuKey] then
        Screen.Enabled = not Screen.Enabled
    end
end)

TopBar = new('Frame',{Size = UDim2.new(1,0,0,20),BackgroundColor3 = Color3.fromRGB(22,22,22),BorderSizePixel = 0, Transparency = .3},Screen)

function AddTopBarToggle(Name,Gui)
    local TopBarInstance = new('TextButton',{Size=UDim2.new(0,40,1,0),Text=Name,BackgroundColor3 = Color3.fromRGB(22,22,22),TextColor3 = Color3.new(1,1,1),BorderSizePixel = 0,},TopBar)
    TopBarInstance.MouseButton1Down:connect(function()
        Gui.Visible = not Gui.Visible
    end)
end

local Gui = {}
Gui.TopBar = {}
Gui.Debug = {}

local TGuiDefault = {
    Size = UDim2.new(0,250,0,18),
    BorderSizePixel = 0,
    AutoButtonColor = false,

    -- Color

    BackgroundColor3 = Color3.fromRGB(22,22,22),
    TextColor3 = Color3.new(1,1,1),

}
local BGuiDefault = {
    Size = UDim2.new(1,0,0,150),
    Position = UDim2.new(0,0,1,0),
    BorderSizePixel = 0,
    Name = 'Contents',
    BackgroundColor3 = Color3.fromRGB(33,33,33),
}

function Gui:AddSection(Name)
    if not self.TopBar[Name] then
        -- new Gui
        local iSection = new('TextButton',TGuiDefault,Screen)
        iSection.Position = UDim2.new(0,(#Screen:GetChildren())*270,0,20)
        self.TopBar[Name] = iSection
        iSection.Text = Name
        local iContents = new('ScrollingFrame',BGuiDefault,iSection)
        MakeDraggable(iSection)
        AddTopBarToggle(Name,iSection)
        MakeResizeable(iContents,iSection)
    else
        return out('Section %s already created!',Name)
    end
end

function Gui:Clear()
    Screen:Destroy()
end

return Gui--]]