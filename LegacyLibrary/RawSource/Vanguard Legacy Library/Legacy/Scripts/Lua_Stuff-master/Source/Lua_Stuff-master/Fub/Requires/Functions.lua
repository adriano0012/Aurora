getgenv().readonly = setreadonly and setreadonly or make_writeable
getgenv().isReadonly = isreadonly and isreadonly or is_readonly
getgenv().isRewrite = is_synapse_function and is_synapse_function or is_protosmasher_closure
getgenv().isLua = islclosure and islclosure or is_l_closure
getgenv().newcclosure = newcclosure and newcclosure or protect_function
getgenv().getservice = game.GetService
getgenv().uis = getservice(game,'UserInputService')
getgenv().Mouse = game.Players.LocalPlayer:GetMouse()
getgenv().Camera = workspace.CurrentCamera
getgenv().isFile = isfile and isfile or function(path)
    return pcall(readfile,path)
end
getgenv().out = function(str,...)
    local subs = {...}
    if #subs <= 0 then return print(str:format('Error')) end
    for i,v in pairs(subs) do
        str = str:format(v)
    end
    print(str)
end
getgenv().new = function(Class,tbl,parent)
    local Instance = Instance.new(Class)
    for i,v in pairs(tbl) do
        Instance[i]=v
    end
    Instance.Parent = parent
    return Instance
end
getgenv().gettextsize = function(str,size,font,size2)
    local ts = game:GetService'TextService'
    return ts:GetTextSize(str,size,font,size2)
end
getgenv().MakeDraggable = function(Gui)
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
            local Clip = Vector2.new(math.clamp(moveto.X,0,Mouse.ViewSizeX-Gui.AbsoluteSize.X),math.clamp(moveto.Y,0,Mouse.ViewSizeY-((Gui:FindFirstChild'Contents' and Gui.Contents.AbsoluteSize.Y or 0)+Gui.AbsoluteSize.Y)))
            Gui.Position = UDim2.new(0,Clip.X,0,Clip.Y)
        end
    end)
end
getgenv().Strip = function(Gui)
    function Set(Gui,Prop,Value)
        Gui[Prop] = Value
    end
    pcall(Set,Gui,'BorderSizePixel',0)
    pcall(Set,Gui,'TextColor3',Color3.new(1,1,1))
end
getgenv().Toggle = function(Name)
    local Toggle = Instance.new('TextButton')
    local Text = Instance.new('TextLabel',Toggle)
    Toggle.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Toggle.Size = UDim2.new(0,20,0,20)
    Text.Size = UDim2.new(0,gettextsize(Name,14,'Arial',Vector2.new(999,999)).X+10,1,0)
    Text.TextXAlignment = 'Left'
    Text.Position = UDim2.new(1,5,0,0)
    Toggle.Text = ''
    Text.Text = Name
    Text.TextColor3 = Color3.new(1,1,1)
    Text.BorderSizePixel = 0
    Toggle.BorderSizePixel = 0
    Text.Transparency = 1
    return Toggle
end
return print"Global Functions Loaded"