RTable = {false,false,false,false,false,false}
function DrawLine(pos1,pos2,pos3,pos4)
surface.SetDrawColor(255,0,0,255)
surface.DrawLine(pos1,pos2,pos3,pos4)
end
function DrawLinePos(posa,posb)
surface.SetDrawColor(255,0,0,255)
pos1=posa:ToScreen()
pos2=posb:ToScreen()
surface.DrawLine(pos1.x,pos1.y,pos2.x,pos2.y)
end
function DrawCircle(pos1,pos2,size)
surface.DrawCircle(pos1,pos2,size,255,0,0,255)
end
hook.Add('HUDPaint','EspTest',function()
for i,v in pairs(ents:GetAll()) do
if v:GetPos():Distance(LocalPlayer():GetPos()) >0 then
if v:IsNPC() then
if v then
if RTable[1] then
if v == nil then return end
surface.SetDrawColor(255,0,0,255)
surface.DrawLine(ScrW()/2,ScrH(),v:GetPos():ToScreen().x,v:GetPos():ToScreen().y)
end
if RTable[2] then
if v == nil then return end
btr = v:OBBMaxs()+v:GetPos() -- top right
fbl = v:OBBMins()+v:GetPos() -- bottom left
x = btr.x
y= btr.y
z= btr.z
x1=fbl.x
y1=fbl.y
z1=fbl.z
rz = z1-z1
DrawLine(btr:ToScreen().x,btr:ToScreen().y,fbl:ToScreen().x,btr:ToScreen().y) -- Top
DrawLine(btr:ToScreen().x,btr:ToScreen().y,btr:ToScreen().x,fbl:ToScreen().y) -- Right
DrawLine(fbl:ToScreen().x,fbl:ToScreen().y,btr:ToScreen().x,fbl:ToScreen().y) -- Bottom
DrawLine(fbl:ToScreen().x,fbl:ToScreen().y,fbl:ToScreen().x,btr:ToScreen().y) -- Left
end
if RTable[3] then
if v == nil then return end
ent = v
btr = ent:OBBMaxs()+ent:GetPos()
fbl = ent:OBBMins()+ent:GetPos()
btl = btr+Vector(0,(fbl.y-btr.y),0)
fbr = fbl+Vector(0,(btr.y-fbl.y),0)
bbl = fbl+Vector(btr.x-fbl.x,0,0)
bbr = fbr+Vector(btl.x-fbr.x,0,0)
ftl = btl+Vector(fbl.x-btr.x,0,0)
ftr = ftl+Vector(0,btr.y-ftl.y,0)

DrawLinePos(btr,btl)
DrawLinePos(fbl,fbr)
DrawLinePos(ftl,btl)
DrawLinePos(bbr,bbl)
DrawLinePos(bbr,fbr)
DrawLinePos(bbl,fbl)
DrawLinePos(ftr,ftl)
DrawLinePos(ftr,btr)
DrawLinePos(btr,bbr)
DrawLinePos(btl,bbl)
DrawLinePos(ftr,fbr)
DrawLinePos(ftl,fbl)
DrawLinePos(ftl,fbr)
DrawLinePos(btl,bbr)
end
if RTable[4] then
if v == nil then return end
		surface.SetDrawColor(255,0,0,255)
		rshoulder = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_R_UpperArm') ):ToScreen()
        lshoulder = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_L_UpperArm') ):ToScreen()
        relbow = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_R_Forearm') ):ToScreen()
        lelbow = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_L_Forearm') ):ToScreen()
        lwrist = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_L_Hand') ):ToScreen()
        rwrist = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_R_Hand') ):ToScreen()
        head = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_Head1') ):ToScreen()
        pelvis = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_Pelvis') ):ToScreen()
        rthigh = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_R_Calf') ):ToScreen()
        lthigh = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_L_Calf') ):ToScreen()
        rfoot = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_R_Foot') ):ToScreen()
        lfoot = v:GetBonePosition( v:LookupBone('ValveBiped.Bip01_L_Foot') ):ToScreen()
        surface.DrawLine(rshoulder.x,rshoulder.y,lshoulder.x,lshoulder.y)
        surface.DrawLine(rshoulder.x,rshoulder.y,relbow.x,relbow.y)
        surface.DrawLine(lshoulder.x,lshoulder.y,lelbow.x,lelbow.y)
        surface.DrawLine(relbow.x,relbow.y,rwrist.x,rwrist.y)
        surface.DrawLine(lelbow.x,lelbow.y,lwrist.x,lwrist.y)
        surface.DrawLine(head.x,head.y,pelvis.x,pelvis.y)
        surface.DrawLine(pelvis.x,pelvis.y,rthigh.x,rthigh.y)
        surface.DrawLine(pelvis.x,pelvis.y,lthigh.x,lthigh.y)
        surface.DrawLine(rthigh.x,rthigh.y,rfoot.x,rfoot.y)
        surface.DrawLine(lthigh.x,lthigh.y,lfoot.x,lfoot.y)
end
if RTable[5] then
if v == nil then return end
ent = v
btr = ent:OBBMaxs()+ent:GetPos()
fbl = ent:OBBMins()+ent:GetPos()
btl = btr+Vector(0,(fbl.y-btr.y),0)
fbr = fbl+Vector(0,(btr.y-fbl.y),0)
bbl = fbl+Vector(btr.x-fbl.x,0,0)
bbr = fbr+Vector(btl.x-fbr.x,0,0)
ftl = btl+Vector(fbl.x-btr.x,0,0)
ftr = ftl+Vector(0,btr.y-ftl.y,0)
SomeRandomVar = v:EyePos()-Vector(0,0,5)
DrawCircle(SomeRandomVar:ToScreen().x,SomeRandomVar:ToScreen().y,(btr:ToScreen().y-fbl:ToScreen().y)/15)
end
if RTable[6] then
if v == nil then return end
surface.SetFont( "Default" )
surface.SetTextColor(255,0,0,255)
surface.SetTextPos(v:GetPos():ToScreen().x,v:GetPos():ToScreen().y)
surface.DrawText(math.Round(v:GetPos():Distance(LocalPlayer():GetPos())))
end
end
end
end
end
end)


function create_menu()
local frame = vgui.Create('DFrame')
frame:SetSize(150,160)
frame:Center()
frame:MakePopup()
frame:SetTitle('Visual Menu')
frame:SetVisible(true)
frame:ShowCloseButton(false)
frame.Paint = function( self, w, h )
   draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 150, 250 ) )
end
local Minimize = vgui.Create( "DButton", frame )
Minimize:SetText( "X" )
Minimize:SetPos( 130, 00 )
Minimize:SetSize( 20, 20 )
Minimize:SetTextColor( Color( 255, 255, 255, 255 ) )
Minimize.Paint = function( self, w, h )
draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 150, 250 ) )
end
Minimize.DoClick = function()
frame:Remove()
end

local t = vgui.Create( "DCheckBoxLabel" ,frame)
t:SetPos(10,30)
t:SetText('Tracers')
t:SetValue( RTable[1] )
t:SizeToContents()    
function t:OnChange(bVal)
RTable[1]=t:GetChecked()
chat.AddText("Player Tracers : "..tostring(bVal))
end

local d = vgui.Create( "DCheckBoxLabel" ,frame)
d:SetPos(10,50)
d:SetText('Dynamic')
d:SetValue( RTable[2] )
d:SizeToContents()    
function d:OnChange(bVal)
RTable[2]=d:GetChecked()
chat.AddText("Player Dynamic Esp : "..tostring(bVal))
end

local tb = vgui.Create( "DCheckBoxLabel" ,frame)
tb:SetPos(10,70)
tb:SetText('3d Box')
tb:SetValue( RTable[3] )
tb:SizeToContents()    
function tb:OnChange(bVal)
RTable[3]=tb:GetChecked()
chat.AddText("Player 3d Box Esp : "..tostring(bVal))
end

local s = vgui.Create( "DCheckBoxLabel" ,frame)
s:SetPos(10,90)
s:SetText('Skeleton Esp')
s:SetValue( RTable[4] )
s:SizeToContents()    
function s:OnChange(bVal)
RTable[4]=s:GetChecked()
chat.AddText("Skeleton Esp : "..tostring(bVal))
end

local h = vgui.Create( "DCheckBoxLabel" ,frame)
h:SetPos(10,110)
h:SetText('Head Esp')
h:SetValue( RTable[5] )
h:SizeToContents()    
function h:OnChange(bVal)
RTable[5]=h:GetChecked()
chat.AddText("Head Esp : "..tostring(bVal))
end

local d = vgui.Create( "DCheckBoxLabel" ,frame)
d:SetPos(10,130)
d:SetText('Distance Esp')
d:SetValue( RTable[6] )
d:SizeToContents()    
function d:OnChange(bVal)
RTable[6]=d:GetChecked()
chat.AddText("Distance Esp : "..tostring(bVal))
end

local d = vgui.Create( "DCheckBoxLabel" ,frame)
d:SetPos(10,130)
d:SetText('Distance Esp')
d:SetValue( RTable[6] )
d:SizeToContents()    
function d:OnChange(bVal)
RTable[6]=d:GetChecked()
chat.AddText("Distance Esp : "..tostring(bVal))
end






end
concommand.Add('Menu_Open',create_menu)
