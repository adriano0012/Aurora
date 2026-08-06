local Start=os.time()

local UI=loadstring(game:HttpGetAsync'https://raw.githubusercontent.com/max9597/Scripts/lt2/uisD')():Initiate();
local demo=UI:CreateTab(5181994100,'UI-lib demo');
local HumanoidSectionTab=demo:CreateSection()
local HumanoidSection=HumanoidSectionTab:CreateSubSection('Options');
local DropSection=HumanoidSectionTab:CreateSubSection('Dropdown');
local PlotNameSettings=HumanoidSectionTab:CreateSubSection('Text Box');
local Settings=HumanoidSectionTab:CreateSubSection('GUI Settings');

slider = HumanoidSection:CreateSlider('Slider',function(Speed)
	_G.k:UpdateHeader('Set slider to 70, Current: '..Speed)
end,50,400,100,true,'Hint'); --min,max,basic,hint toggle,hint

_G.k = HumanoidSection:CreateButton('Set slider to 70, Current:100',function()
	slider:Set(70)
end,true,true,'Hint'); --animation,hint toggle,hint

--k:UpdateHeader('text') update button text

HumanoidSection:CreateKeybind('Key-bind',function(v)
    print(tostring(v)..' Pressed')
end,Enum.KeyCode.G,true,'Hint'); --basic,hint toggle,hint

HumanoidSection:CreateToggle('Toggle',false,function(toggle)
	print(tostring(toggle))
end,true,true,'Hint'); --basic,hint toggle,hint

HumanoidSection:CreateLabel('Text Label');

HumanoidSection:CreateButton('Button',function()
	print('clicked')
end,true,true,'Hint'); --animation,hint toggle,hint

DropSection:CreateDropDown(function(Location)
end,{'Spawn','Location 1','Location 2','Location 3'},'Spawn',false);

PlotNameSettings:CreateTextbox('Text',function(Name)
	print(Name)
end,'lol',false,true,'Hint',false); --players,hint toggle,hint,save text

Settings:CreateKeybind('Toggle UI',function(v)
    game.CoreGui.Ancestor.Enabled=not game.CoreGui.Ancestor.Enabled;
end,Enum.KeyCode.RightControl,true,'Hint');
Settings:CreateToggle('GUI hints',false,function(toggle)for i,v in next,UI:GetHelpSections()do v.Visible=toggle;end;end,true,true,'Toggles GUI Tips');

warn('Loaded AncestorV2 In '..tostring(os.time()-Start)..' Second/s =^w^=');