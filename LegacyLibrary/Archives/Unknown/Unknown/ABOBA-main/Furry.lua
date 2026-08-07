local Player = game.Players.LocalPlayer
local c = Player.Character
if not c or not c.Parent then
  c = Player.CharacterAdded:wait()
end
local radio = Instance.new("Part", c)
radio.Name = "Radio"
radio.CanCollide = false
radio.Anchored = true
radio.FormFactor = "Custom"
radio.Size = Vector3.new(2.5, 1, 0.4)
radio.CFrame = c.Torso.CFrame * CFrame.new(-3.5, 2, 0.2)
radio.CFrame = radio.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, 0)
radio.CFrame = radio.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, -0.1)
radio.Transparency = 1
local sound = Instance.new("Sound", radio)
sound.Name = "Music"
sound.Looped = true
sound.Volume = 5
local weld = Instance.new("Weld", radio)
weld.Part0 = c.Torso
weld.Part1 = radio
weld.C0 = c.Torso.CFrame:inverse()
weld.C1 = radio.CFrame:inverse()
radio.Anchored = false
player = game:service("Players").LocalPlayer
char2 = player.Character
Glow1 = Color3.new(0, 0, 0)
Glow2 = Color3.new(1, 0, 0)
Glow3 = Color3.new(0, 1, 0)
Glow4 = Color3.new(0, 0, 1)
GlowParticle = Instance.new("ParticleEmitter", radio)
GlowParticle.LightEmission = 1
GlowParticle.Color = ColorSequence.new(Glow2, Glow1)
GlowParticle.Size = NumberSequence.new(0.4)
GlowParticle.Texture = "http://www.roblox.com/asset/?id=118641183"
GlowParticle.Transparency = NumberSequence.new(1)
GlowParticle.LockedToPart = false
GlowParticle.Lifetime = NumberRange.new(0.5, 1)
GlowParticle.Rate = 200
GlowParticle.Speed = NumberRange.new(1.5)
GlowParticle.Acceleration = Vector3.new(0, 1, 0)
GlowParticle.VelocitySpread = 100
GlowParticle2 = Instance.new("ParticleEmitter", radio)
GlowParticle2.LightEmission = 1
GlowParticle2.Color = ColorSequence.new(Glow3, Glow1)
GlowParticle2.Size = NumberSequence.new(0.4)
GlowParticle2.Texture = "http://www.roblox.com/asset/?id=118641183"
GlowParticle2.Transparency = NumberSequence.new(1)
GlowParticle2.LockedToPart = false
GlowParticle2.Lifetime = NumberRange.new(0.5, 1)
GlowParticle2.Rate = 200
GlowParticle2.Speed = NumberRange.new(1.5)
GlowParticle2.Acceleration = Vector3.new(0, 1, 0)
GlowParticle2.VelocitySpread = 100
GlowParticle3 = Instance.new("ParticleEmitter", radio)
GlowParticle3.LightEmission = 1
GlowParticle3.Color = ColorSequence.new(Glow4, Glow1)
GlowParticle3.Size = NumberSequence.new(0.4)
GlowParticle3.Texture = "http://www.roblox.com/asset/?id=118641183"
GlowParticle3.Transparency = NumberSequence.new(1)
GlowParticle3.LockedToPart = false
GlowParticle3.Lifetime = NumberRange.new(0.5, 1)
GlowParticle3.Rate = 200
GlowParticle3.Speed = NumberRange.new(1.5)
GlowParticle3.Acceleration = Vector3.new(0, 1, 0)
GlowParticle3.VelocitySpread = 100
wait(0)
fat = Instance.new("BindableEvent", script)
fat.Name = "Heartbeat"
local charge = false
P = game.Players.LocalPlayer
char = P.Character
torso = char.Torso
neck = char.Torso.Neck
hum = char.Humanoid
hum.MaxHealth = 9.876543219876543E44
wait()
hum.Health = hum.MaxHealth
char.Head.face.Texture = "rbxassetid://176206791"
p2 = game.Players.LocalPlayer
char049 = p2.Character
for i, v in pairs(char049:children()) do
  if v:IsA("Accessory") then
    v:Destroy()
  end
end
local M69 = Instance.new("SpecialMesh")
M69.Parent = torso
M69.MeshId = "rbxassetid://456901040"
M69.Scale = Vector3.new(1, 1, 1)
char049.Shirt:Remove()
for i, v in pairs(char049:GetChildren()) do
  if v:IsA("Pants") then
    v:Remove()
  end
end
wait()
shirt = Instance.new("Shirt", char049)
shirt.Name = "Shirt"
pants = Instance.new("Pants", char049)
pants.Name = "Pants"
char049.Shirt.ShirtTemplate = "rbxassetid://"
char049.Pants.PantsTemplate = "rbxassetid://"
local BC = char["Body Colors"]
BC.HeadColor = BrickColor.new("Fossil")
BC.LeftArmColor = BrickColor.new("Fossil")
BC.LeftLegColor = BrickColor.new("Fossil")
BC.RightArmColor = BrickColor.new("Fossil")
BC.RightLegColor = BrickColor.new("Fossil")
BC.TorsoColor = BrickColor.new("Plum")
Player = game:GetService("Players").LocalPlayer
Character = Player.Character
local Orbd = Instance.new("Part", Character)
Orbd.Name = "Orbd"
Orbd.Shape = Enum.PartType.Ball
Orbd.CanCollide = false
Orbd.BrickColor = BrickColor.new("Really black")
Orbd.Transparency = 1
Orbd.Material = "Neon"
Orbd.Size = Vector3.new(0.2, 0.2, 0.2)
Orbd.TopSurface = Enum.SurfaceType.Smooth
Orbd.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", Orbd)
Weld.Part0 = Character.Head
Weld.Part1 = Orbd
Weld.C1 = CFrame.new(-0.01, 0.2, 0.51)
local Mask = Instance.new("Part", Character)
Mask.Name = "Mask"
Mask.CanCollide = false
Mask.BrickColor = BrickColor.new("Sunrise")
Mask.Transparency = 1
Mask.Material = "Neon"
Mask.Size = Vector3.new(0.1, 0.1, 0.1)
Mask.TopSurface = Enum.SurfaceType.Smooth
Mask.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", Mask)
Weld.Part0 = Character.Head
Weld.Part1 = Mask
Weld.C1 = CFrame.new(0, 0.03, 0.5)
local M1 = Instance.new("SpecialMesh")
M1.Parent = Mask
M1.MeshId = "http://www.roblox.com/asset/?id=430736398"
M1.Scale = Vector3.new(0.3, 0.03, 0.099)
local Hood = Instance.new("Part", Character)
Hood.Name = "Hair"
Hood.CanCollide = false
Hood.BrickColor = BrickColor.new("Dark indigo")
Hood.Transparency = 1
Hood.Material = "Neon"
Hood.Size = Vector3.new(0.1, 0.1, 0.1)
Hood.TopSurface = Enum.SurfaceType.Smooth
Hood.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", Hood)
Weld.Part0 = Character.Head
Weld.Part1 = Hood
Weld.C1 = CFrame.new(0, -0.5, 0)
local M2 = Instance.new("SpecialMesh")
M2.Parent = Hood
M2.MeshId = "http://www.roblox.com/asset/?id=362013001"
M2.Scale = Vector3.new(1, 1.06, 1.1)
local skin = Instance.new("Part", Character)
skin.Name = "skin"
skin.CanCollide = false
skin.BrickColor = BrickColor.new("Fossil")
skin.Transparency = 1
skin.Material = "SmoothPlastic"
skin.Size = Vector3.new(0.1, 0.1, 0.1)
skin.TopSurface = Enum.SurfaceType.Smooth
skin.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", skin)
Weld.Part0 = Character.Torso
Weld.Part1 = skin
Weld.C1 = CFrame.new(0, -0.83, 0.5)
local M3 = Instance.new("SpecialMesh")
M3.Parent = skin
M3.MeshId = "http://www.roblox.com/asset/?id=518429841"
M3.Scale = Vector3.new(0.0054, 0.0014, 1.0E-4)
local hair2 = Instance.new("Part", Character)
hair2.Name = "Hair2"
hair2.CanCollide = false
hair2.BrickColor = BrickColor.new("Dark indigo")
hair2.Transparency = 1
hair2.Material = "Neon"
hair2.Size = Vector3.new(0.1, 0.1, 0.1)
hair2.TopSurface = Enum.SurfaceType.Smooth
hair2.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", hair2)
Weld.Part0 = Character.Head
Weld.Part1 = hair2
Weld.C1 = CFrame.new(0, 0.65, -0.05)
local M2 = Instance.new("SpecialMesh")
M2.Parent = hair2
M2.MeshId = "http://www.roblox.com/asset/?id=164382853"
M2.Scale = Vector3.new(1.1, 1.1, 1)
local hat2 = Instance.new("Part", Character)
hat2.Name = "hat2"
hat2.CanCollide = false
hat2.BrickColor = BrickColor.new("Plum")
hat2.Transparency = 1
hat2.Material = "SmoothPlastic"
hat2.Size = Vector3.new(0.1, 0.1, 0.1)
hat2.TopSurface = Enum.SurfaceType.Smooth
hat2.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", hat2)
Weld.Part0 = Character.Head
Weld.Part1 = hat2
Weld.C1 = CFrame.new(0, -1, 0)
local M4 = Instance.new("SpecialMesh")
M4.Parent = hat2
M4.MeshId = "http://www.roblox.com/asset/?id=110852069"
M4.Scale = Vector3.new(0.8, 1, 1)
local hat3 = Instance.new("Part", Character)
hat3.Name = "SmoothPlastic"
hat3.CanCollide = false
hat3.BrickColor = BrickColor.new("Plum")
hat3.Transparency = 1
hat3.Material = "Neon"
hat3.Size = Vector3.new(0.1, 0.1, 0.1)
hat3.TopSurface = Enum.SurfaceType.Smooth
hat3.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", hat3)
Weld.Part0 = Character.Head
Weld.Part1 = hat3
Weld.C1 = CFrame.new(0, -0.8, 0)
local M5 = Instance.new("SpecialMesh")
M5.Parent = hat3
M5.MeshId = "http://www.roblox.com/asset/?id=104780903"
M5.Scale = Vector3.new(1.25, 1.1, 1.25)
local tail2 = Instance.new("Part", Character)
tail2.Name = "tail2"
tail2.CanCollide = false
tail2.BrickColor = BrickColor.new("White")
tail2.Transparency = 1
tail2.Material = "SmoothPlastic"
tail2.Size = Vector3.new(0.1, 0.1, 0.1)
tail2.TopSurface = Enum.SurfaceType.Smooth
tail2.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", tail2)
Weld.Part0 = Character.Torso
Weld.Part1 = tail2
Weld.C1 = CFrame.new(0, 0.63, -0.6)
local M7 = Instance.new("SpecialMesh")
M7.Parent = tail2
M7.MeshId = "http://www.roblox.com/asset/?id=518429841"
M7.Scale = Vector3.new(0.0028, 0.0028, 0.0028)
local tail3 = Instance.new("Part", Character)
tail3.Name = "tail3"
tail3.CanCollide = false
tail3.BrickColor = BrickColor.new("Plum")
tail3.Transparency = 1
tail3.Material = "Neon"
tail3.Size = Vector3.new(0.1, 0.1, 0.1)
tail3.TopSurface = Enum.SurfaceType.Smooth
tail3.BottomSurface = Enum.SurfaceType.Smooth
local Weld = Instance.new("Weld", tail3)
Weld.Part0 = Character.Torso
Weld.Part1 = tail3
Weld.C1 = CFrame.new(-0.2, -0.2, -1.8)
local M2 = Instance.new("SpecialMesh")
M2.Parent = tail3
M2.MeshId = "http://www.roblox.com/asset/?id=170939831"
M2.Scale = Vector3.new(1, 1, 1)
local Player = game.Players.localPlayer
local Character = Player.Character
local red = 255
local green = 255
local blue = 255
local Humanoid = Character.Humanoid
local mouse = Player:GetMouse()
local m = Instance.new("Model", Character)
m.Name = "WeaponModel"
local LeftArm = Character["Left Arm"]
local RightArm = Character["Right Arm"]
local LeftLeg = Character["Left Leg"]
local RightLeg = Character["Right Leg"]
local Head = Character.Head
local Torso = Character.Torso
local cam = game.Workspace.CurrentCamera
local RootPart = Character.HumanoidRootPart
local RootJoint = RootPart.RootJoint
local equipped = false
local attack = false
local Anim = "Idle"
local idle = 0
local attacktype = 1
local Torsovelocity = RootPart.Velocity.y * Vector3.new(1, 0, 1).magnitude
local velocity = RootPart.Velocity.y
local sine = 0
local change = 1
local grabbed = false
local cn = CFrame.new
local mr = math.rad
local angles = CFrame.Angles
local ud = UDim2.new
local c3 = Color3.new
local lim = 0
local st = 0
local necko = cn(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
local attacktype = 1
local ZTarget, RocketTarget
local euler = CFrame.fromEulerAnglesXYZ
function clerp(a, b, t)
  local qa = {
    QuaternionFromCFrame(a)
  }
  local qb = {
    QuaternionFromCFrame(b)
  }
  local ax, ay, az = a.x, a.y, a.z
  local bx, by, bz = b.x, b.y, b.z
  local _t = 1 - t
  return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end
function QuaternionFromCFrame(cf)
  local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
  local trace = m00 + m11 + m22
  if trace > 0 then
    local s = math.sqrt(1 + trace)
    local recip = 0.5 / s
    return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
  else
    local i = 0
    if m00 < m11 then
      i = 1
    end
    if m22 > (i == 0 and m00 or m11) then
      i = 2
    end
    if i == 0 then
      local s = math.sqrt(m00 - m11 - m22 + 1)
      local recip = 0.5 / s
      return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
    elseif i == 1 then
      local s = math.sqrt(m11 - m22 - m00 + 1)
      local recip = 0.5 / s
      return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
    elseif i == 2 then
      local s = math.sqrt(m22 - m00 - m11 + 1)
      local recip = 0.5 / s
      return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
    end
  end
end
function QuaternionToCFrame(px, py, pz, x, y, z, w)
  local xs, ys, zs = x + x, y + y, z + z
  local wx, wy, wz = w * xs, w * ys, w * zs
  local xx = x * xs
  local xy = x * ys
  local xz = x * zs
  local yy = y * ys
  local yz = y * zs
  local zz = z * zs
  return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end
function QuaternionSlerp(a, b, t)
  local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
  local startInterp, finishInterp
  if cosTheta >= 1.0E-4 then
    if 1 - cosTheta > 1.0E-4 then
      local theta = math.acos(cosTheta)
      local invSinTheta = 1 / math.sin(theta)
      startInterp = math.sin((1 - t) * theta) * invSinTheta
      finishInterp = math.sin(t * theta) * invSinTheta
    else
      startInterp = 1 - t
      finishInterp = t
    end
  elseif 1 + cosTheta > 1.0E-4 then
    local theta = math.acos(-cosTheta)
    local invSinTheta = 1 / math.sin(theta)
    startInterp = math.sin((t - 1) * theta) * invSinTheta
    finishInterp = math.sin(t * theta) * invSinTheta
  else
    startInterp = t - 1
    finishInterp = t
  end
  return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end
function rayCast(Position, Direction, Range, Ignore)
  return game:service("Workspace"):FindPartOnRay(Ray.new(Position, Direction.unit * (Range or 999.999)), Ignore)
end
local v = game.Players.localPlayer
local torso = v.Character.Torso
wait(0)
local p = Instance.new("Part", v.Character)
p.Name = "kit"
p.BrickColor = BrickColor.new("Plum")
p.Anchored = true
p.Transparency = 1
p.Material = "Plastic"
p.CanCollide = false
p.TopSurface = 0
p.BottomSurface = 0
p.Size = Vector3.new(0.2, 0.2, 0.2)
p.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local msh = Instance.new("SpecialMesh", p)
msh.Scale = Vector3.new(0.55, 0.55, 0.55)
msh.MeshId = "http://www.roblox.com/asset/?id=430736398"
msh.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn = Instance.new("Part", v.Character.kit)
pn.Name = "D"
pn.BrickColor = BrickColor.new("Plum")
pn.Anchored = true
pn.Transparency = 1
pn.Material = "Plastic"
pn.CanCollide = false
pn.TopSurface = 0
pn.BottomSurface = 0
pn.Size = Vector3.new(0.2, 0.2, 0.2)
pn.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn = Instance.new("SpecialMesh", pn)
mshn.Scale = Vector3.new(0.55, 0.55, 0.55)
mshn.MeshId = "http://www.roblox.com/asset/?id=430736398"
mshn.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn3 = Instance.new("Part", v.Character.kit)
pn3.Name = "B"
pn3.BrickColor = BrickColor.new("Fossil")
pn3.Anchored = true
pn3.Transparency = 1
pn3.Material = "Plastic"
pn3.CanCollide = false
pn3.TopSurface = 0
pn3.BottomSurface = 0
pn3.Size = Vector3.new(0.2, 0.2, 0.2)
pn3.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn3 = Instance.new("SpecialMesh", pn3)
mshn3.Scale = Vector3.new(0.0054, 0.0054, 0.0054)
mshn3.MeshId = "http://www.roblox.com/asset/?id=518429841"
mshn3.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn4 = Instance.new("Part", v.Character.kit)
pn4.Name = "B"
pn4.BrickColor = BrickColor.new("Fossil")
pn4.Anchored = true
pn4.Transparency = 1
pn4.Material = "Plastic"
pn4.CanCollide = false
pn4.TopSurface = 0
pn4.BottomSurface = 0
pn4.Size = Vector3.new(0.2, 0.2, 0.2)
pn4.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn4 = Instance.new("SpecialMesh", pn4)
mshn4.Scale = Vector3.new(0.0054, 0.0054, 0.0054)
mshn4.MeshId = "http://www.roblox.com/asset/?id=518429841"
mshn4.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn5 = Instance.new("Part", v.Character.kit)
pn5.Name = "tail"
pn5.Anchored = true
pn5.Transparency = 1
pn5.BrickColor = BrickColor.new("Plum")
pn5.Material = "Plastic"
pn5.CanCollide = false
pn5.TopSurface = 0
pn5.BottomSurface = 0
pn5.Size = Vector3.new(0.2, 0.2, 0.2)
pn5.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn5 = Instance.new("SpecialMesh", pn5)
mshn5.Scale = Vector3.new(2, 2, 2)
mshn5.MeshId = "http://www.roblox.com/asset/?id=188635159"
mshn5.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn6 = Instance.new("Part", v.Character.kit)
pn6.Name = "B-Hair"
pn6.Anchored = true
pn6.Transparency = 1
pn6.BrickColor = BrickColor.new("Dark indigo")
pn6.Material = "Plastic"
pn6.CanCollide = false
pn6.TopSurface = 0
pn6.BottomSurface = 0
pn6.Size = Vector3.new(0.2, 0.2, 0.2)
pn6.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn6 = Instance.new("SpecialMesh", pn6)
mshn6.Scale = Vector3.new(0.015, 0.03, 0.001)
mshn6.MeshId = "http://www.roblox.com/asset/?id=521338357"
local pn7 = Instance.new("Part", v.Character.kit)
pn7.Name = "tail"
pn7.Anchored = true
pn7.Transparency = 1
pn7.BrickColor = BrickColor.new("Plum")
pn7.Material = "Plastic"
pn7.CanCollide = false
pn7.TopSurface = 0
pn7.BottomSurface = 0
pn7.Size = Vector3.new(0.2, 0.2, 0.2)
pn7.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn7 = Instance.new("SpecialMesh", pn7)
mshn7.Scale = Vector3.new(2, 2, 2)
mshn7.MeshId = "http://www.roblox.com/asset/?id=188635159"
mshn7.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn8 = Instance.new("Part", v.Character.kit)
pn8.Name = "tail"
pn8.Anchored = true
pn8.Transparency = 1
pn8.BrickColor = BrickColor.new("Plum")
pn8.Material = "Plastic"
pn8.CanCollide = false
pn8.TopSurface = 0
pn8.BottomSurface = 0
pn8.Size = Vector3.new(0.2, 0.2, 0.2)
pn8.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn8 = Instance.new("SpecialMesh", pn8)
mshn8.Scale = Vector3.new(2, 2, 2)
mshn8.MeshId = "http://www.roblox.com/asset/?id=188635159"
mshn8.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn9 = Instance.new("Part", v.Character.kit)
pn9.Name = "tail"
pn9.Anchored = true
pn9.Transparency = 1
pn9.BrickColor = BrickColor.new("Plum")
pn9.Material = "Plastic"
pn9.CanCollide = false
pn9.TopSurface = 0
pn9.BottomSurface = 0
pn9.Size = Vector3.new(0.2, 0.2, 0.2)
pn9.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn9 = Instance.new("SpecialMesh", pn9)
mshn9.Scale = Vector3.new(2, 2, 2)
mshn9.MeshId = "http://www.roblox.com/asset/?id=188635159"
mshn9.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
local pn0 = Instance.new("Part", v.Character.kit)
pn0.Name = "ears"
pn0.Anchored = true
pn0.Transparency = 1
pn0.BrickColor = BrickColor.new("Plum")
pn0.Material = "Plastic"
pn0.CanCollide = false
pn0.TopSurface = 0
pn0.BottomSurface = 0
pn0.Size = Vector3.new(0.2, 0.2, 0.2)
pn0.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
local mshn0 = Instance.new("SpecialMesh", pn0)
mshn0.Scale = Vector3.new(0.5, 0.5, 0.5)
mshn0.MeshId = "http://www.roblox.com/asset/?id=361948302"
mshn0.VertexColor = Vector3.new(torso.BrickColor.r, torso.BrickColor.g, torso.BrickColor.b)
p.Anchored = false
local motor1 = Instance.new("Weld", torso)
motor1.Part0 = p
motor1.Part1 = torso
motor1.C0 = CFrame.new(2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor1.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn.Anchored = false
local motor2 = Instance.new("Weld", torso)
motor2.Part0 = pn
motor2.Part1 = torso
motor2.C0 = CFrame.new(-2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor2.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn3.Anchored = false
local motor3 = Instance.new("Weld", torso)
motor3.Part0 = pn3
motor3.Part1 = torso
motor3.C0 = CFrame.new(-2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor3.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn4.Anchored = false
local motor4 = Instance.new("Weld", torso)
motor4.Part0 = pn4
motor4.Part1 = torso
motor4.C0 = CFrame.new(2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor4.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn5.Anchored = false
local motor5 = Instance.new("Weld", pn5)
motor5.Part0 = pn5
motor5.Part1 = torso
motor5.C0 = CFrame.new(-2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor5.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn6.Anchored = false
local motor6 = Instance.new("Weld", pn6)
motor6.Part0 = pn6
motor6.Part1 = Head
motor6.C0 = CFrame.new(-2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor6.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn7.Anchored = false
local motor7 = Instance.new("Weld", pn7)
motor7.Part0 = pn7
motor7.Part1 = torso
motor7.C0 = CFrame.new(-2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor7.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn8.Anchored = false
local motor8 = Instance.new("Weld", pn8)
motor8.Part0 = pn8
motor8.Part1 = torso
motor8.C0 = CFrame.new(2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor8.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn9.Anchored = false
local motor9 = Instance.new("Weld", pn9)
motor9.Part0 = pn9
motor9.Part1 = torso
motor9.C0 = CFrame.new(2.36, -1.8, -0.87) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
motor9.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
pn0.Anchored = false
local motor0 = Instance.new("Weld", pn0)
motor0.Part0 = pn0
motor0.Part1 = v.Character.Head
motor0.C0 = CFrame.new(0, -0.8, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
game:GetService("RunService").Stepped:connect(function()
  Torsovelocity = RootPart.Velocity.y * Vector3.new(1, 0, 1).magnitude
  velocity = RootPart.Velocity.y
  sine = sine + change
  local hit, pos = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)
  if equipped == true or equipped == false then
    if 1 < RootPart.Velocity.y and hit == nil then
      Anim = "Jump"
      if attack == false then
        motor1.C0 = clerp(motor1.C0, CFrame.new(0.45, -1.4, 0.85) * angles(math.rad(2 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor2.C0 = clerp(motor2.C0, CFrame.new(-0.45, -1.4, 0.85) * angles(math.rad(2 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor3.C0 = clerp(motor3.C0, CFrame.new(0.4, -1.45, 0.75) * angles(math.rad(2 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor4.C0 = clerp(motor3.C0, CFrame.new(-7.6, -1.45, 0.73) * angles(math.rad(2 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor5.C0 = clerp(motor5.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-60 + 0 * math.cos(sine / 10)), math.rad(90 + 0 * math.cos(sine / 10)), math.rad(-80 + 0 * math.cos(sine / 25))), 0.1)
        motor6.C0 = clerp(motor6.C0, CFrame.new(-0.28, 0.27, 1.38) * angles(math.rad(-26.3 + -1 * math.cos(sine / 20)), math.rad(10 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor7.C0 = clerp(motor7.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-60 + 0 * math.cos(sine / 10)), math.rad(90 + 0 * math.cos(sine / 10)), math.rad(-80 + 0 * math.cos(sine / 25))), 0.1)
        motor8.C0 = clerp(motor8.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 0 * math.cos(sine / -30)), math.rad(110 + 0 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
        motor9.C0 = clerp(motor9.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 0 * math.cos(sine / -30)), math.rad(110 + 0 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
      end
    elseif RootPart.Velocity.y < -1 and hit == nil then
      Anim = "Fall"
      if attack == false then
        motor1.C0 = clerp(motor1.C0, CFrame.new(0.45, -1.4, 0.85) * angles(math.rad(-3 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor2.C0 = clerp(motor2.C0, CFrame.new(-0.45, -1.4, 0.85) * angles(math.rad(-3 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor3.C0 = clerp(motor3.C0, CFrame.new(0.4, -1.45, 0.75) * angles(math.rad(-3 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor4.C0 = clerp(motor3.C0, CFrame.new(-7.6, -1.45, 0.73) * angles(math.rad(-3 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor5.C0 = clerp(motor5.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-45 + 0 * math.cos(sine / 10)), math.rad(0 + 0 * math.cos(sine / 10)), math.rad(-70 + 0 * math.cos(sine / 25))), 0.1)
        motor6.C0 = clerp(motor6.C0, CFrame.new(-0.28, 0.27, 1.38) * angles(math.rad(-26.3 + -1 * math.cos(sine / 20)), math.rad(10 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor7.C0 = clerp(motor7.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-45 + 0 * math.cos(sine / 10)), math.rad(0 + 0 * math.cos(sine / 10)), math.rad(-70 + 0 * math.cos(sine / 25))), 0.1)
        motor8.C0 = clerp(motor8.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 0 * math.cos(sine / -30)), math.rad(180 + 0 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
        motor9.C0 = clerp(motor9.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 0 * math.cos(sine / -30)), math.rad(180 + 0 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
      end
    elseif (Torso.Velocity*Vector3.new(1, 0, 1)).magnitude < 1 and hit ~= nil then
      Anim = "Idle"
      if attack == false then
        change = 1
        motor1.C0 = clerp(motor1.C0, CFrame.new(0.45, -1.4, 0.85) * angles(math.rad(0 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor2.C0 = clerp(motor2.C0, CFrame.new(-0.45, -1.4, 0.85) * angles(math.rad(0 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor3.C0 = clerp(motor3.C0, CFrame.new(0.4, -1.45, 0.75) * angles(math.rad(0 + 0 * math.cos(sine / 50)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor4.C0 = clerp(motor3.C0, CFrame.new(-7.6, -1.45, 0.73) * angles(math.rad(0 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 80)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor5.C0 = clerp(motor5.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-50 + 5 * math.cos(sine / 60)), math.rad(0 + 5 * math.cos(sine / 65)), math.rad(10 + 0 * math.cos(sine / 25))), 0.1)
        motor6.C0 = clerp(motor6.C0, CFrame.new(-0.28, 0.27, 1.38) * angles(math.rad(-26.3 + -1 * math.cos(sine / 20)), math.rad(10 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor7.C0 = clerp(motor7.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-50 + 5 * math.cos(sine / 70)), math.rad(0 + 5 * math.cos(sine / 35)), math.rad(-45 + 0 * math.cos(sine / 25))), 0.1)
        motor8.C0 = clerp(motor8.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-10 + 5 * math.cos(sine / 55)), math.rad(0 + 5 * math.cos(sine / 55)), math.rad(-150 + 0 * math.cos(sine / 25))), 0.1)
        motor9.C0 = clerp(motor9.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-20 + 5 * math.cos(sine / 65)), math.rad(0 + 5 * math.cos(sine / 60)), math.rad(-100 + 0 * math.cos(sine / 25))), 0.1)
      end
    elseif (Torso.Velocity*Vector3.new(1, 0, 1)).magnitude > 2 and hit ~= nil then
      Anim = "Walk"
      if attack == false then
        motor1.C0 = clerp(motor1.C0, CFrame.new(0.45, -1.4, 0.85) * angles(math.rad(2 + 2 * math.cos(sine / 5)), math.rad(0 + -1 * math.cos(sine / 5)), math.rad(0 + 1 * math.cos(sine / 5))), 0.1)
        motor2.C0 = clerp(motor2.C0, CFrame.new(-0.45, -1.4, 0.85) * angles(math.rad(2 + -2 * math.cos(sine / 5)), math.rad(0 + -1 * math.cos(sine / 5)), math.rad(0 + 1 * math.cos(sine / 5))), 0.1)
        motor3.C0 = clerp(motor3.C0, CFrame.new(0.4, -1.45, 0.75) * angles(math.rad(0 + 0 * math.cos(sine / 5)), math.rad(0 + 0 * math.cos(sine / 5)), math.rad(0 + 0 * math.cos(sine / 5))), 0.1)
        motor4.C0 = clerp(motor3.C0, CFrame.new(-7.6, -1.45, 0.73) * angles(math.rad(0 + 0 * math.cos(sine / 5)), math.rad(0 + 0 * math.cos(sine / 5)), math.rad(0 + 0 * math.cos(sine / 5))), 0.1)
        motor5.C0 = clerp(motor5.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-60 + 10 * math.cos(sine / 30)), math.rad(45 + 10 * math.cos(sine / 20)), math.rad(-45 + 0 * math.cos(sine / 10))), 0.1)
        motor6.C0 = clerp(motor6.C0, CFrame.new(-0.28, 0.27, 1.38) * angles(math.rad(-26.3 + -1 * math.cos(sine / 20)), math.rad(10 + 0 * math.cos(sine / 70)), math.rad(0 + 0 * math.cos(sine / 25))), 0.1)
        motor7.C0 = clerp(motor7.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(-60 + 10 * math.cos(sine / 30)), math.rad(45 + 10 * math.cos(sine / 20)), math.rad(-45 + 0 * math.cos(sine / 10))), 0.1)
        motor8.C0 = clerp(motor8.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 10 * math.cos(sine / -30)), math.rad(135 + -10 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
        motor9.C0 = clerp(motor9.C0, CFrame.new(-2.36, -1.8, -0.87) * angles(math.rad(120 + 10 * math.cos(sine / -30)), math.rad(135 + -10 * math.cos(sine / 20)), math.rad(115 + 0 * math.cos(sine / 10))), 0.1)
      end
    end
  end
end)
newface = Instance.new("Decal", Head)
newface.Texture = "rbxassetid://186681690"
maincolor = game.Players.LocalPlayer.Character.Torso.BrickColor.Name
secondcolor = "Really black"
wait(0.016666666666666666)
Effects = {}
local Player = game.Players.localPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local mouse = Player:GetMouse()
local LeftArm = Character["Left Arm"]
local RightArm = Character["Right Arm"]
local LeftLeg = Character["Left Leg"]
local RightLeg = Character["Right Leg"]
local Head = Character.Head
local Torso = Character.Torso
local cam = game.Workspace.CurrentCamera
local RootPart = Character.HumanoidRootPart
local RootJoint = RootPart.RootJoint
local equipped = true
local attack = false
local Anim = "Idle"
local idle = 0
local attacktype = 1
local Torsovelocity = RootPart.Velocity.y * Vector3.new(1, 0, 1).magnitude
local velocity = RootPart.Velocity.y
local sine = 0
local change = 1
local grabbed = false
local cn = CFrame.new
local mr = math.rad
local angles = CFrame.Angles
local ud = UDim2.new
local c3 = Color3.new
local NeckCF = cn(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
Humanoid.Animator:Destroy()
Character.Animate:Destroy()
local RootCF = CFrame.fromEulerAnglesXYZ(-1.57, 0, 3.14)
local RHCF = CFrame.fromEulerAnglesXYZ(0, 1.6, 0)
local LHCF = CFrame.fromEulerAnglesXYZ(0, -1.6, 0)
RSH, LSH = nil, nil
RW = Instance.new("Weld")
LW = Instance.new("Weld")
RH = Torso["Right Hip"]
LH = Torso["Left Hip"]
RSH = Torso["Right Shoulder"]
LSH = Torso["Left Shoulder"]
RSH.Parent = nil
LSH.Parent = nil
RW.Name = "RW"
RW.Part0 = Torso
RW.C0 = cn(1.5, 0.5, 0)
RW.C1 = cn(0, 0.5, 0)
RW.Part1 = RightArm
RW.Parent = Torso
LW.Name = "LW"
LW.Part0 = Torso
LW.C0 = cn(-1.5, 0.5, 0)
LW.C1 = cn(0, 0.5, 0)
LW.Part1 = LeftArm
LW.Parent = Torso
function clerp(a, b, t)
  local qa = {
    QuaternionFromCFrame(a)
  }
  local qb = {
    QuaternionFromCFrame(b)
  }
  local ax, ay, az = a.x, a.y, a.z
  local bx, by, bz = b.x, b.y, b.z
  local _t = 1 - t
  return QuaternionToCFrame(_t * ax + t * bx, _t * ay + t * by, _t * az + t * bz, QuaternionSlerp(qa, qb, t))
end
function QuaternionFromCFrame(cf)
  local mx, my, mz, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:components()
  local trace = m00 + m11 + m22
  if trace > 0 then
    local s = math.sqrt(1 + trace)
    local recip = 0.5 / s
    return (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip, s * 0.5
  else
    local i = 0
    if m00 < m11 then
      i = 1
    end
    if m22 > (i == 0 and m00 or m11) then
      i = 2
    end
    if i == 0 then
      local s = math.sqrt(m00 - m11 - m22 + 1)
      local recip = 0.5 / s
      return 0.5 * s, (m10 + m01) * recip, (m20 + m02) * recip, (m21 - m12) * recip
    elseif i == 1 then
      local s = math.sqrt(m11 - m22 - m00 + 1)
      local recip = 0.5 / s
      return (m01 + m10) * recip, 0.5 * s, (m21 + m12) * recip, (m02 - m20) * recip
    elseif i == 2 then
      local s = math.sqrt(m22 - m00 - m11 + 1)
      local recip = 0.5 / s
      return (m02 + m20) * recip, (m12 + m21) * recip, 0.5 * s, (m10 - m01) * recip
    end
  end
end
function QuaternionToCFrame(px, py, pz, x, y, z, w)
  local xs, ys, zs = x + x, y + y, z + z
  local wx, wy, wz = w * xs, w * ys, w * zs
  local xx = x * xs
  local xy = x * ys
  local xz = x * zs
  local yy = y * ys
  local yz = y * zs
  local zz = z * zs
  return CFrame.new(px, py, pz, 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy))
end
function QuaternionSlerp(a, b, t)
  local cosTheta = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
  local startInterp, finishInterp
  if cosTheta >= 1.0E-4 then
    if 1 - cosTheta > 1.0E-4 then
      local theta = math.acos(cosTheta)
      local invSinTheta = 1 / math.sin(theta)
      startInterp = math.sin((1 - t) * theta) * invSinTheta
      finishInterp = math.sin(t * theta) * invSinTheta
    else
      startInterp = 1 - t
      finishInterp = t
    end
  elseif 1 + cosTheta > 1.0E-4 then
    local theta = math.acos(-cosTheta)
    local invSinTheta = 1 / math.sin(theta)
    startInterp = math.sin((t - 1) * theta) * invSinTheta
    finishInterp = math.sin(t * theta) * invSinTheta
  else
    startInterp = t - 1
    finishInterp = t
  end
  return a[1] * startInterp + b[1] * finishInterp, a[2] * startInterp + b[2] * finishInterp, a[3] * startInterp + b[3] * finishInterp, a[4] * startInterp + b[4] * finishInterp
end
function swait(num)
  if num == 0 or num == nil then
    game:service("RunService").RenderStepped:wait(0)
  else
    for i = 0, num do
      game:service("RunService").RenderStepped:wait(0)
    end
  end
end
local RbxUtility = LoadLibrary("RbxUtility")
local Create = RbxUtility.Create
function RemoveOutlines(part)
  part.TopSurface, part.BottomSurface, part.LeftSurface, part.RightSurface, part.FrontSurface, part.BackSurface = 10, 10, 10, 10, 10, 10
end
function CreatePart(FormFactor, Parent, Material, Reflectance, Transparency, BColor, Name, Size)
  local Part = Create("Part")({
    formFactor = FormFactor,
    Parent = Parent,
    Reflectance = Reflectance,
    Transparency = Transparency,
    CanCollide = false,
    Locked = true,
    BrickColor = BrickColor.new(tostring(BColor)),
    Name = Name,
    Size = Size,
    Material = Material
  })
  RemoveOutlines(Part)
  return Part
end
function CreateMesh(Mesh, Part, MeshType, MeshId, OffSet, Scale)
  local Msh = Create(Mesh)({
    Parent = Part,
    Offset = OffSet,
    Scale = Scale
  })
  if Mesh == "SpecialMesh" then
    Msh.MeshType = MeshType
    Msh.MeshId = MeshId
  end
  return Msh
end
function CreateWeld(Parent, Part0, Part1, C0, C1)
  local Weld = Create("Weld")({
    Parent = Parent,
    Part0 = Part0,
    Part1 = Part1,
    C0 = C0,
    C1 = C1
  })
  return Weld
end
function rayCast(Position, Direction, Range, Ignore)
  return game:service("Workspace"):FindPartOnRay(Ray.new(Position, Direction.unit * (Range or 999.999)), Ignore)
end
function CreateSound(id, par, vol, pit)
  coroutine.resume(coroutine.create(function()
    local sou = Instance.new("Sound", par or workspace)
    sou.Volume = vol
    sou.Pitch = pit or 1
    sou.SoundId = id
    wait()
    sou:play()
    game:GetService("Debris"):AddItem(sou, 6)
  end))
end
local function getclosest(obj, distance)
  local last, lastx = distance + 1, nil
  for i, v in pairs(workspace:GetChildren()) do
    if v:IsA("Model") and v ~= Character and v:findFirstChild("Humanoid") and v:findFirstChild("Torso") and v:findFirstChild("Humanoid").Health > 0 then
      local t = v.Torso
      local dist = (t.Position - obj.Position).magnitude
      if distance >= dist and last > dist then
        last = dist
        lastx = v
      end
    end
  end
  return lastx
end
function BlockEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay, Type)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
  prt.Anchored = true
  prt.CFrame = cframe
  local msh = CreateMesh("BlockMesh", prt, "", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  if Type == 1 or Type == nil then
    table.insert(Effects, {
      prt,
      "Block1",
      delay,
      x3,
      y3,
      z3,
      msh
    })
  elseif Type == 2 then
    table.insert(Effects, {
      prt,
      "Block2",
      delay,
      x3,
      y3,
      z3,
      msh
    })
  end
end
function SphereEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
  prt.Anchored = true
  prt.CFrame = cframe
  local msh = CreateMesh("SpecialMesh", prt, "Sphere", "nil", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Cylinder",
    delay,
    x3,
    y3,
    z3,
    msh
  })
end
function RingEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
  prt.Anchored = true
  prt.CFrame = cframe * CFrame.new(x1, y1, z1)
  local msh = CreateMesh("SpecialMesh", prt, "FileMesh", "3270017", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Cylinder",
    delay,
    x3,
    y3,
    z3,
    msh
  })
end
function CylinderEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
  prt.Anchored = true
  prt.CFrame = cframe
  local msh = CreateMesh("CylinderMesh", prt, "", "", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Cylinder",
    delay,
    x3,
    y3,
    z3,
    msh
  })
end
function WaveEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
  prt.Anchored = true
  prt.CFrame = cframe
  local msh = CreateMesh("SpecialMesh", prt, "FileMesh", "20329976", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Cylinder",
    delay,
    x3,
    y3,
    z3,
    msh
  })
end
function SpecialEffect(brickcolor, cframe, x1, y1, z1, x3, y3, z3, delay)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new())
  prt.Anchored = true
  prt.CFrame = cframe
  local msh = CreateMesh("SpecialMesh", prt, "FileMesh", "24388358", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Cylinder",
    delay,
    x3,
    y3,
    z3,
    msh
  })
end
function BreakEffect(brickcolor, cframe, x1, y1, z1)
  local prt = CreatePart(3, workspace, "SmoothPlastic", 0, 0, brickcolor, "Effect", Vector3.new(0.5, 0.5, 0.5))
  prt.Anchored = true
  prt.CFrame = cframe * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
  local msh = CreateMesh("SpecialMesh", prt, "Sphere", "nil", Vector3.new(0, 0, 0), Vector3.new(x1, y1, z1))
  local num = math.random(10, 50) / 1000
  game:GetService("Debris"):AddItem(prt, 10)
  table.insert(Effects, {
    prt,
    "Shatter",
    num,
    prt.CFrame,
    math.random() - math.random(),
    0,
    math.random(50, 100) / 100
  })
end
for i = 0, 1, 0.05 do
  swait()
  RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(0), math.rad(0), math.rad(0)), 0.1)
  Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(5), math.rad(0), math.rad(0)), 0.1)
  RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, -0.1) * angles(math.rad(5), math.rad(0), math.rad(5)), 0.1)
  LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(20), math.rad(0), math.rad(-10)), 0.3)
  if Torsovelocity > 2 then
    RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-50 * math.cos(sine / 4)), math.rad(0), math.rad(4 * math.cos(sine / 4))), 0.2)
    RH.C0 = clerp(RH.C0, cn(1, -1 + 0.1 * math.cos(sine / 5), 0) * RHCF * angles(math.rad(-2), math.rad(0), math.rad(30 * math.cos(sine / 4))), 0.3)
    LH.C0 = clerp(LH.C0, cn(-1, -1 + 0.1 * math.cos(sine / 5), 0) * LHCF * angles(math.rad(-2), math.rad(0), math.rad(30 * math.cos(sine / 4))), 0.3)
  elseif Torsovelocity < 1 then
    RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, -0.1) * angles(math.rad(5), math.rad(0), math.rad(5)), 0.1)
    RH.C0 = clerp(RH.C0, cn(1, -1, 0) * RHCF * angles(math.rad(-2), math.rad(5), math.rad(0)), 0.1)
    LH.C0 = clerp(LH.C0, cn(-1, -1, 0) * LHCF * angles(math.rad(-2), math.rad(5), math.rad(0)), 0.1)
  end
end
attack = false
game:GetService("RunService").Stepped:connect(function()
 -- Torsovelocity = --RootPart.Velocity.y * Vector3.new(1, 0, 1).magnitude
  Torsovelocity = (torso.Velocity*Vector3.new(1, 0, 1)).magnitude
  velocity = RootPart.Velocity.y
  sine = sine + change
  local hit, pos = rayCast(RootPart.Position, CFrame.new(RootPart.Position, RootPart.Position - Vector3.new(0, 1, 0)).lookVector, 4, Character)
  if equipped == true or equipped == false then
    if 1 < RootPart.Velocity.y and hit == nil then
      Anim = "Jump"
      if attack == false and Anim2 == false then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-40), math.rad(0), math.rad(30)), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-40), math.rad(0), math.rad(-30)), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -0.9, -0.3) * RHCF * angles(math.rad(3), math.rad(0), math.rad(0)), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.7, -0.5) * LHCF * angles(math.rad(-3), math.rad(0), math.rad(0)), 0.1)
      end
    elseif RootPart.Velocity.y < -1 and hit == nil then
      Anim = "Fall"
      if attack == false and Anim2 == false then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-20), math.rad(0), math.rad(50)), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), math.rad(0), math.rad(-50)), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -1, -0.3) * RHCF * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.8, -0.3) * LHCF * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
      end
    elseif Torsovelocity < 1 and hit ~= nil then
      Anim = "Idle"
      if attack == false and Anim2 == false then
        change = 0.8
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.1 * math.cos(sine / 25)) * angles(math.rad(0), math.rad(-5), math.rad(5)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(5 - 2 * math.cos(sine / 50)), math.rad(8), math.rad(-5)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.3, 0.6, 0.3) * angles(math.rad(30), math.rad(150), math.rad(-200 + 3 * math.cos(sine / 25))), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.54, 0.5, 0.1) * angles(math.rad(0), math.rad(10), math.rad(0 - 4 * math.cos(sine / 25))), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -0.93 - 0.1 * math.cos(sine / 25), 0) * RHCF * angles(math.rad(-10 + 2 * math.cos(sine / 25)), math.rad(-15), math.rad(6 + 2 * math.cos(sine / 45))), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.93 - 0.1 * math.cos(sine / 25), 0) * LHCF * angles(math.rad(-5 + 2 * math.cos(sine / 25)), math.rad(-5), math.rad(7 + 2 * math.cos(sine / 25))), 0.1)
      end
    elseif Torsovelocity > 1 and hit ~= nil then
      Anim = "Walk"
      if attack == false and Anim2 == false then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.02 + 0.1 * math.cos(sine / 3)) * angles(math.rad(5), math.rad(0) + RootPart.RotVelocity.Y / 30, math.rad(7 * math.cos(sine / 5))), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-3), math.rad(0), math.rad(-5 * math.cos(sine / 5)) + RootPart.RotVelocity.Y / 9), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-50 * math.cos(sine / 4)), math.rad(-7), math.rad(4 * math.cos(sine / 4))), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(50 * math.cos(sine / 4)), math.rad(7), math.rad(4 * math.cos(sine / 4))), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -1 + 0.2 * math.cos(sine / 3), 0) * RHCF * angles(math.rad(-2), math.rad(7), math.rad(50 * math.cos(sine / 4))), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -1 + 0.1 * math.cos(sine / 3), 0) * LHCF * angles(math.rad(-2), math.rad(-7), math.rad(50 * math.cos(sine / 4))), 0.1)
      end
    end
  end
  if equipped == true or equipped == false then
    if 1 < RootPart.Velocity.y and hit == nil then
      Anim = "Jump"
      if attack == false and Anim2 == true then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-40), math.rad(0), math.rad(30)), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-40), math.rad(0), math.rad(-30)), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -0.9, -0.3) * RHCF * angles(math.rad(3), math.rad(0), math.rad(0)), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.7, -0.5) * LHCF * angles(math.rad(-3), math.rad(0), math.rad(0)), 0.1)
      end
    elseif RootPart.Velocity.y < -1 and hit == nil then
      Anim = "Fall"
      if attack == false and Anim2 == true then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, 0) * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(10), math.rad(0), math.rad(0)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-20), math.rad(0), math.rad(50)), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(-20), math.rad(0), math.rad(-50)), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -1, -0.3) * RHCF * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.8, -0.3) * LHCF * angles(math.rad(-5), math.rad(0), math.rad(0)), 0.1)
      end
    elseif Torsovelocity < 1 and hit ~= nil then
      Anim = "Idle"
      if attack == false and Anim2 == true then
        change = 0.8
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.1 + 0.1 * math.cos(sine / 25)) * angles(math.rad(0), math.rad(0), math.rad(5)), 0.1)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(1 - 1 * math.cos(sine / 25)), math.rad(0), math.rad(-5)), 0.1)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(5 + 3 * math.cos(sine / 25))), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(0), math.rad(0), math.rad(-5 - 3 * math.cos(sine / 25))), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -0.9 - 0.1 * math.cos(sine / 25), 0) * RHCF * angles(math.rad(-2 + 2 * math.cos(sine / 25)), math.rad(-5), math.rad(0 + 2 * math.cos(sine / 25))), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -0.9 - 0.1 * math.cos(sine / 25), 0) * LHCF * angles(math.rad(-2 + 2 * math.cos(sine / 25)), math.rad(-5), math.rad(0 + 2 * math.cos(sine / 25))), 0.1)
      end
    elseif Torsovelocity > 1 and hit ~= nil then
      Anim = "Walk"
      if attack == false and Anim2 == true then
        RootJoint.C0 = clerp(RootJoint.C0, RootCF * cn(0, 0, -0.02 + 0.1 * math.cos(sine / 3)) * angles(math.rad(5), math.rad(0) + RootPart.RotVelocity.Y / 30, math.rad(5 * math.cos(sine / 5))), 0.2)
        Torso.Neck.C0 = clerp(Torso.Neck.C0, NeckCF * angles(math.rad(-3), math.rad(0), math.rad(-5 * math.cos(sine / 5)) + RootPart.RotVelocity.Y / 9), 0.2)
        RW.C0 = clerp(RW.C0, CFrame.new(1.5, 0.5, 0) * angles(math.rad(-50 * math.cos(sine / 4)), math.rad(0), math.rad(4 * math.cos(sine / 4))), 0.1)
        LW.C0 = clerp(LW.C0, CFrame.new(-1.5, 0.5, 0) * angles(math.rad(50 * math.cos(sine / 4)), math.rad(0), math.rad(4 * math.cos(sine / 4))), 0.1)
        RH.C0 = clerp(RH.C0, cn(1, -1 + 0.2 * math.cos(sine / 3), 0) * RHCF * angles(math.rad(-2), math.rad(0), math.rad(50 * math.cos(sine / 4))), 0.1)
        LH.C0 = clerp(LH.C0, cn(-1, -1 + 0.1 * math.cos(sine / 3), 0) * LHCF * angles(math.rad(-2), math.rad(0), math.rad(50 * math.cos(sine / 4))), 0.1)
      end
    end
  end
  if 0 < #Effects then
    for e = 1, #Effects do
      if Effects[e] ~= nil then
        local Thing = Effects[e]
        if Thing ~= nil then
          local Part = Thing[1]
          local Mode = Thing[2]
          local Delay = Thing[3]
          local IncX = Thing[4]
          local IncY = Thing[5]
          local IncZ = Thing[6]
          if 1 >= Thing[1].Transparency then
            if Thing[2] == "Block1" then
              Thing[1].CFrame = Thing[1].CFrame * CFrame.fromEulerAnglesXYZ(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
              local Mesh = Thing[1].Mesh
              Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Block2" then
              Thing[1].CFrame = Thing[1].CFrame
              local Mesh = Thing[7]
              Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Cylinder" then
              local Mesh = Thing[1].Mesh
              Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Blood" then
              local Mesh = Thing[7]
              Thing[1].CFrame = Thing[1].CFrame * Vector3.new(0, 0.5, 0)
              Mesh.Scale = Mesh.Scale + Vector3.new(Thing[4], Thing[5], Thing[6])
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Elec" then
              local Mesh = Thing[1].Mesh
              Mesh.Scale = Mesh.Scale + Vector3.new(Thing[7], Thing[8], Thing[9])
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Disappear" then
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
            elseif Thing[2] == "Shatter" then
              Thing[1].Transparency = Thing[1].Transparency + Thing[3]
              Thing[4] = Thing[4] * CFrame.new(0, Thing[7], 0)
              Thing[1].CFrame = Thing[4] * CFrame.fromEulerAnglesXYZ(Thing[6], 0, 0)
              Thing[6] = Thing[6] + Thing[5]
            end
          else
            Part.Parent = nil
            table.remove(Effects, e)
          end
        end
      end
    end
  end
end)
Pressed = false
MaskOn = false
MaskOff = true
Anim2 = true
eye1 = false
eye2 = false
eye3 = true
mouth1 = false
mouth2 = true
mouth3 = false
mouth4 = false
mouth5 = false
mouth6 = false
mouth7 = false
bkit0 = true
bkit1 = false
bkit2 = false
torso1 = false
torso2 = true
Tail0 = true
Tail1 = false
Tail2 = false
Tail3 = false
Hair0 = true
Hair1 = false
Hair2 = false
Hair3 = false
Hat0 = true
Hat1 = false
Hat2 = false
Hat3 = false
local Playing = false
char2 = game.Players.LocalPlayer.Character
iPlayer = game.Players.LocalPlayer.Name
local Gui = Instance.new("ScreenGui", game.Players[iPlayer].PlayerGui)
Gui.Name = "Gui test"
local Pull = Instance.new("Frame", Gui)
Pull.Name = "Grab"
Pull.Active = true
Pull.BackgroundColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
Pull.BackgroundTransparency = 0
Pull.BorderSizePixel = 4
Pull.Position = UDim2.new(0.5, -318, 0.5, -92)
Pull.Size = UDim2.new(0, 120, 0, 50)
Pull.Draggable = true
Pull.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
local Close = Instance.new("TextButton", Pull)
Close.Name = "Close"
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(1, -23, 0, 1)
Close.Size = UDim2.new(0, 22, 0, 22)
Close.Font = "SourceSans"
Close.FontSize = "Size24"
Close.TextColor3 = Color3.new(255, 255, 255)
Close.Text = "X"
Close.TextStrokeTransparency = 0.8
local Body = Instance.new("Frame", Pull)
Body.Name = "Body"
Body.BackgroundColor3 = Color3.new(0.23529411764705882, 0.23529411764705882, 0.23529411764705882)
Body.BackgroundTransparency = 0
Body.BorderSizePixel = 4
Body.Position = UDim2.new(0, 0, 0, 52)
Body.Size = UDim2.new(0, 547, 0, 212)
Body.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
local Line = Instance.new("Frame", Body)
Line.Name = "Line"
Line.BackgroundColor3 = Color3.new(0.23529411764705882, 0.23529411764705882, 0.23529411764705882)
Line.BackgroundTransparency = 0
Line.BorderSizePixel = 2
Line.Position = UDim2.new(0, 152.5, 0, 0)
Line.Size = UDim2.new(0, 0.01, 0, 212)
Line.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
local Line2 = Instance.new("Frame", Body)
Line2.Name = "Line2"
Line2.BackgroundColor3 = Color3.new(0.23529411764705882, 0.23529411764705882, 0.23529411764705882)
Line2.BackgroundTransparency = 0
Line2.BorderSizePixel = 2
Line2.Position = UDim2.new(0, 306.5, 0, 0)
Line2.Size = UDim2.new(0, 0.01, 0, 212)
Line2.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
local Title = Instance.new("TextLabel", Pull)
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, -50, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = "SourceSansLight"
Title.FontSize = "Size48"
Title.Text = "Menu"
Title.TextColor3 = Color3.new(0.5, 0, 1)
Title.TextStrokeColor3 = Color3.new(0.2901960784313726, 0.2901960784313726, 0.2901960784313726)
Title.TextStrokeTransparency = 0
local PlayerName = Instance.new("TextBox", Body)
PlayerName.Name = "PlayerName"
PlayerName.BorderSizePixel = 0
PlayerName.Position = UDim2.new(0, 8, 0, 10)
PlayerName.Size = UDim2.new(0, 135, 0, 30)
PlayerName.Font = "SourceSans"
PlayerName.FontSize = "Size18"
PlayerName.Text = "Name of the color"
PlayerName.BackgroundColor3 = Color3.new(255, 255, 255)
PlayerName.TextColor3 = Color3.new(0, 0, 0)
PlayerName.TextWrapped = true
local ColTex2 = Instance.new("TextBox", Body)
ColTex2.Name = "ColTex2"
ColTex2.BorderSizePixel = 0
ColTex2.Position = UDim2.new(0, 318.5, 0, 10)
ColTex2.Size = UDim2.new(0, 135, 0, 30)
ColTex2.Font = "SourceSans"
ColTex2.FontSize = "Size18"
ColTex2.Text = "Song id"
ColTex2.BackgroundColor3 = Color3.new(255, 255, 255)
ColTex2.TextColor3 = Color3.new(0, 0, 0)
ColTex2.TextWrapped = true
local ColTex3 = Instance.new("TextBox", Body)
ColTex3.Name = "ColTex3"
ColTex3.BorderSizePixel = 2
ColTex3.Position = UDim2.new(0, 10, 0, 130)
ColTex3.Size = UDim2.new(0, 57.5, 0, 30)
ColTex3.Font = "SourceSans"
ColTex3.FontSize = "Size10"
ColTex3.Text = "Shirt id"
ColTex3.BackgroundColor3 = Color3.new(255, 255, 255)
ColTex3.TextColor3 = Color3.new(0, 0, 0)
ColTex3.TextWrapped = true
local ColTex4 = Instance.new("TextBox", Body)
ColTex4.Name = "ColTex4"
ColTex4.BorderSizePixel = 2
ColTex4.Position = UDim2.new(0, 10, 0, 170)
ColTex4.Size = UDim2.new(0, 57.5, 0, 30)
ColTex4.Font = "SourceSans"
ColTex4.FontSize = "Size10"
ColTex4.Text = "Pants id"
ColTex4.BackgroundColor3 = Color3.new(255, 255, 255)
ColTex4.TextColor3 = Color3.new(0, 0, 0)
ColTex4.TextWrapped = true
local Chattext = Instance.new("TextBox", Body)
Chattext.Name = "Chattext"
Chattext.BorderSizePixel = 2
Chattext.Position = UDim2.new(0, 125, 0, -45)
Chattext.Size = UDim2.new(0, 157.5, 0, 40)
Chattext.Font = "SourceSans"
Chattext.FontSize = "Size12"
Chattext.Text = "Beter chat ^-^ "
Chattext.BackgroundColor3 = Color3.new(255, 255, 255)
Chattext.TextColor3 = Color3.new(0, 0, 0)
Chattext.TextWrapped = true
Chattext.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
local God = Instance.new("TextButton", Body)
God.Name = "God"
God.BackgroundColor3 = Color3.new(0.08235294117647059, 0.5568627450980392, 255)
God.BackgroundTransparency = 0
God.BorderSizePixel = 2
God.Position = UDim2.new(0, 10, 0, 50)
God.Size = UDim2.new(0, 57.5, 0, 30)
God.Font = "SourceSansBold"
God.FontSize = "Size18"
God.Text = "Skin col"
God.TextColor3 = Color3.new(255, 255, 255)
God.TextWrapped = true
God.BorderColor3 = Color3.new(0.3803921568627451, 0.3803921568627451, 0.3803921568627451)
God.TextStrokeTransparency = 1
local Saypress = God:Clone()
Saypress.Name = "Saypress"
Saypress.Parent = Body
Saypress.Position = UDim2.new(0, 285.5, 0, -35)
Saypress.Text = "Say"
Saypress.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
local TpTo = God:Clone()
TpTo.Name = "TpTo"
TpTo.Parent = Body
TpTo.Position = UDim2.new(0, 468.5, 0, 10)
TpTo.Text = "Play"
TpTo.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
local KillPlr = God:Clone()
KillPlr.Name = "Shirtcol"
KillPlr.Parent = Body
KillPlr.Position = UDim2.new(0, 10, 0, 90)
KillPlr.Text = "Shirt col"
KillPlr.Size = UDim2.new(0, 130, 0, 30)
local Haircol = God:Clone()
Haircol.Name = "Haircol"
Haircol.Parent = Body
Haircol.Position = UDim2.new(0, 82.5, 0, 50)
Haircol.Text = "Hair col"
local TpMe = God:Clone()
TpMe.Name = "Hat"
TpMe.Parent = Body
TpMe.Position = UDim2.new(0, 164, 0, 90)
TpMe.Text = "Hat 1"
TpMe.Size = UDim2.new(0, 57.5, 0, 30)
TpMe.FontSize = "Size18"
local TpMe2 = God:Clone()
TpMe2.Name = "Hair"
TpMe2.Parent = Body
TpMe2.Position = UDim2.new(0, 236.5, 0, 50)
TpMe2.Text = "Hair 1"
TpMe2.Size = UDim2.new(0, 57.5, 0, 30)
TpMe2.FontSize = "Size18"
local G36K = God:Clone()
G36K.Name = "SpawnG36k"
G36K.Parent = Body
G36K.Position = UDim2.new(0, 162, 0, 10)
G36K.Text = "Idle Pose"
G36K.Size = UDim2.new(0, 135, 0, 30)
G36K.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
G36K.FontSize = "Size28"
local Tail = God:Clone()
Tail.Name = "Tail"
Tail.Parent = Body
Tail.Position = UDim2.new(0, 164, 0, 50)
Tail.Text = "Tail 0"
local Torso2 = God:Clone()
Torso2.Name = "Hair"
Torso2.Parent = Body
Torso2.Position = UDim2.new(0, 236.5, 0, 90)
Torso2.Text = "Torso 2"
Torso2.Size = UDim2.new(0, 57.5, 0, 30)
Torso2.FontSize = "Size18"
local Bkit = God:Clone()
Bkit.Name = "Bkit"
Bkit.Parent = Body
Bkit.Position = UDim2.new(0, 164, 0, 130)
Bkit.Text = "Bkit 0"
Bkit.Size = UDim2.new(0, 57.5, 0, 30)
Bkit.FontSize = "Size18"
local Mouth = God:Clone()
Mouth.Name = "Mouth"
Mouth.Parent = Body
Mouth.Position = UDim2.new(0, 164, 0, 170)
Mouth.Text = "Mouth 2"
Mouth.FontSize = "Size18"
local Eyes = God:Clone()
Eyes.Name = "Eyes"
Eyes.Parent = Body
Eyes.Position = UDim2.new(0, 236, 0, 130)
Eyes.Text = "Eye 3"
Eyes.FontSize = "Size18"
local mask = God:Clone()
mask.Name = "mask"
mask.Parent = Body
mask.Position = UDim2.new(0, 236, 0, 170)
mask.Text = "Shy"
mask.FontSize = "Size18"
mask.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
local Shirtset = God:Clone()
Shirtset.Name = "Shirtset"
Shirtset.Parent = Body
Shirtset.Position = UDim2.new(0, 82.5, 0, 130)
Shirtset.Text = "Set"
local Pantsset = God:Clone()
Pantsset.Name = "Pantsset"
Pantsset.Parent = Body
Pantsset.Position = UDim2.new(0, 82.5, 0, 170)
Pantsset.Text = "Set"
local Bunny = God:Clone()
Bunny.Name = "Bunny"
Bunny.Parent = Body
Bunny.Position = UDim2.new(0, 318.5, 0, 50)
Bunny.Text = "Bunny"
local Noob = God:Clone()
Noob.Name = "Noob"
Noob.Parent = Body
Noob.Position = UDim2.new(0, 318.5, 0, 90)
Noob.Text = "Noob"
local Kitty = God:Clone()
Kitty.Name = "Kitty"
Kitty.Parent = Body
Kitty.Position = UDim2.new(0, 318.5, 0, 130)
Kitty.Text = "Kitty"
Saypress.MouseButton1Down:connect(function()
  local ChatService = game:GetService("Chat")
  ChatService:Chat(char.Head, "" .. Chattext.Text)
end)
God.MouseButton1Down:connect(function()
  BC.HeadColor = BrickColor.new(PlayerName.Text)
  BC.LeftArmColor = BrickColor.new(PlayerName.Text)
  BC.LeftLegColor = BrickColor.new(PlayerName.Text)
  BC.RightArmColor = BrickColor.new(PlayerName.Text)
  BC.RightLegColor = BrickColor.new(PlayerName.Text)
  pn3.BrickColor = BrickColor.new(PlayerName.Text)
  pn4.BrickColor = BrickColor.new(PlayerName.Text)
  skin.BrickColor = BrickColor.new(PlayerName.Text)
end)
KillPlr.MouseButton1Down:connect(function()
  pn.BrickColor = BrickColor.new(PlayerName.Text)
  p.BrickColor = BrickColor.new(PlayerName.Text)
  pn0.BrickColor = BrickColor.new(PlayerName.Text)
  BC.TorsoColor = BrickColor.new(PlayerName.Text)
  hat2.BrickColor = BrickColor.new(PlayerName.Text)
  hat3.BrickColor = BrickColor.new(PlayerName.Text)
  pn5.BrickColor = BrickColor.new(PlayerName.Text)
  pn7.BrickColor = BrickColor.new(PlayerName.Text)
  pn8.BrickColor = BrickColor.new(PlayerName.Text)
  pn9.BrickColor = BrickColor.new(PlayerName.Text)
  tail3.BrickColor = BrickColor.new(PlayerName.Text)
end)
TpTo.MouseButton1Down:connect(function()
  if Playing == false and Pressed == false then
    TpTo.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
    TpTo.Text = "Stop"
    Pressed = true
    radio.Transparency = 0
    GlowParticle.Transparency = NumberSequence.new(0.3, 0.8)
    GlowParticle2.Transparency = NumberSequence.new(0.3, 0.8)
    GlowParticle3.Transparency = NumberSequence.new(0.3, 0.8)
    wait()
    sound:Play()
    Playing = true
  end
  if Playing == true and Pressed == false then
    TpTo.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
    TpTo.Text = "Play"
    Pressed = true
    radio.Transparency = 1
    GlowParticle.Transparency = NumberSequence.new(1)
    GlowParticle2.Transparency = NumberSequence.new(1)
    GlowParticle3.Transparency = NumberSequence.new(1)
    wait()
    sound:Stop()
    Playing = false
  end
  wait()
  Pressed = false
end)
TpMe.MouseButton1Down:connect(function()
  if Hat1 == true and Pressed == false then
    TpMe.Text = "Hat 2"
    pn0.Transparency = 1
    hat2.Transparency = 0
    Pressed = true
    wait()
    Hat1 = false
    Hat2 = true
  end
  if Hat2 == true and Pressed == false then
    TpMe.Text = "Hat 3"
    hat2.Transparency = 1
    hat3.Transparency = 0
    Pressed = true
    wait()
    Hat2 = false
    Hat3 = true
  end
  if Hat3 == true and Pressed == false then
    TpMe.Text = "Hat 0"
    hat3.Transparency = 1
    Pressed = true
    wait()
    Hat3 = false
    Hat0 = true
  end
  if Hat0 == true and Pressed == false then
    TpMe.Text = "Hat 1"
    pn0.Transparency = 0
    Pressed = true
    wait()
    Hat3 = false
    Hat1 = true
  end
  wait()
  Pressed = false
end)
G36K.MouseButton1Down:connect(function()
  if Anim2 == false and Pressed == false then
    G36K.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
    Pressed = true
    wait()
    Anim2 = true
  end
  if Anim2 == true and Pressed == false then
    G36K.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
    Pressed = true
    wait()
    Anim2 = false
  end
  wait()
  Pressed = false
end)
TpMe2.MouseButton1Down:connect(function()
  if Hair1 == true and Pressed == false then
    TpMe2.Text = "Hair 2"
    Hood.Transparency = 1
    pn6.Transparency = 1
    hair2.Transparency = 0
    Pressed = true
    wait()
    Hair1 = false
    Hair2 = true
  end
  if Hair2 == true and Pressed == false then
    TpMe2.Text = "Hair 3"
    Hood.Transparency = 0
    pn6.Transparency = 1
    hair2.Transparency = 1
    Pressed = true
    wait()
    Hair2 = false
    Hair3 = true
  end
  if Hair3 == true and Pressed == false then
    TpMe2.Text = "Hair 0"
    Hood.Transparency = 1
    pn6.Transparency = 1
    hair2.Transparency = 1
    Pressed = true
    wait()
    Hair3 = false
    Hair0 = true
  end
  if Hair0 == true and Pressed == false then
    TpMe2.Text = "Hair 1"
    Hood.Transparency = 0
    pn6.Transparency = 0
    hair2.Transparency = 0
    Pressed = true
    wait()
    Hair0 = false
    Hair1 = true
  end
  wait()
  Pressed = false
end)
Haircol.MouseButton1Down:connect(function()
  hair2.BrickColor = BrickColor.new(PlayerName.Text)
  Hood.BrickColor = BrickColor.new(PlayerName.Text)
  pn6.BrickColor = BrickColor.new(PlayerName.Text)
end)
Tail.MouseButton1Down:connect(function()
  if Tail1 == true and Pressed == false then
    Tail.Text = "Tail 2"
    pn5.Transparency = 1
    pn7.Transparency = 1
    pn8.Transparency = 1
    pn9.Transparency = 1
    tail2.Transparency = 0
    Pressed = true
    wait()
    Tail1 = false
    Tail2 = true
  end
  if Tail2 == true and Pressed == false then
    Tail.Text = "Tail 3"
    tail2.Transparency = 1
    tail3.Transparency = 0
    Pressed = true
    wait()
    Tail2 = false
    Tail3 = true
  end
  if Tail3 == true and Pressed == false then
    Tail.Text = "Tail 0"
    tail3.Transparency = 1
    Pressed = true
    wait()
    Tail3 = false
    Tail0 = true
  end
  if Tail0 == true and Pressed == false then
    Tail.Text = "Tail 1"
    pn5.Transparency = 0
    pn7.Transparency = 0
    pn8.Transparency = 0
    pn9.Transparency = 0
    Pressed = true
    wait()
    Tail0 = false
    Tail1 = true
  end
  wait()
  Pressed = false
end)
Torso2.MouseButton1Down:connect(function()
  if torso1 == true and Pressed == false then
    Pressed = true
    M69.MeshId = "rbxassetid://456901040"
    M69.Scale = Vector3.new(1, 1, 1)
    Torso2.Text = "Torso 2"
    wait()
    torso1 = false
    torso2 = true
  end
  if torso2 == true and Pressed == false then
    Pressed = true
    M69.MeshId = "rbxassetid://48112070"
    M69.Scale = Vector3.new(1.093, 1, 1)
    Torso2.Text = "Torso 1"
    wait()
    torso1 = true
    torso2 = false
  end
  wait()
  Pressed = false
end)
Bkit.MouseButton1Down:connect(function()
  if bkit1 == true and Pressed == false then
    Pressed = true
    p.Transparency = 0
    pn.Transparency = 0
    pn3.Transparency = 1
    pn4.Transparency = 1
    skin.Transparency = 1
    Bkit.Text = "Bkit 2"
    wait()
    bkit1 = false
    bkit2 = true
  end
  if bkit2 == true and Pressed == false then
    Pressed = true
    p.Transparency = 1
    pn.Transparency = 1
    pn3.Transparency = 1
    pn4.Transparency = 1
    skin.Transparency = 1
    Bkit.Text = "Bkit 0"
    wait()
    bkit2 = false
    bkit0 = true
  end
  if bkit0 == true and Pressed == false then
    Pressed = true
    p.Transparency = 0
    pn.Transparency = 0
    pn3.Transparency = 0
    pn4.Transparency = 0
    skin.Transparency = 0
    Bkit.Text = "Bkit 1"
    wait()
    bkit0 = false
    bkit1 = true
  end
  wait()
  Pressed = false
end)
Mouth.MouseButton1Down:connect(function()
  if mouth1 == true and Pressed == false then
    Mouth.Text = "Mouth 2"
    newface.Texture = "rbxassetid://186681690"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth1 = false
    mouth2 = true
  end
  if mouth2 == true and Pressed == false then
    Mouth.Text = "Mouth 3"
    newface.Texture = "rbxassetid://322781877"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth2 = false
    mouth3 = true
  end
  if mouth3 == true and Pressed == false then
    Mouth.Text = "Mouth 4"
    newface.Texture = "rbxassetid://186682603"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth3 = false
    mouth4 = true
  end
  if mouth4 == true and Pressed == false then
    Mouth.Text = "Mouth 5"
    newface.Texture = "rbxassetid://133379869"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth4 = false
    mouth5 = true
  end
  if mouth5 == true and Pressed == false then
    Mouth.Text = "Mouth 6"
    newface.Texture = "rbxassetid://186683091"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth5 = false
    mouth6 = true
  end
  if mouth6 == true and Pressed == false then
    Mouth.Text = "Mouth 7"
    newface.Texture = "rbxassetid://186682277"
    Orbd.Transparency = 1
    Pressed = true
    wait()
    mouth6 = false
    mouth7 = true
  end
  if mouth7 == true and Pressed == false then
    Mouth.Text = "Mouth 1"
    newface.Texture = "rbxassetid://"
    Orbd.Transparency = 0
    Pressed = true
    wait()
    mouth6 = false
    mouth1 = true
  end
  wait()
  Pressed = false
end)
Eyes.MouseButton1Down:connect(function()
  if eye3 == true and Pressed == false then
    Pressed = true
    char.Head.face.Texture = "rbxassetid://176204308"
    Eyes.Text = "Eye 1"
    wait()
    eye3 = false
    eye1 = true
  end
  if eye1 == true and Pressed == false then
    Pressed = true
    char.Head.face.Texture = "rbxassetid://176210835"
    Eyes.Text = "Eye 2"
    wait()
    eye1 = false
    eye2 = true
  end
  if eye2 == true and Pressed == false then
    Pressed = true
    char.Head.face.Texture = "rbxassetid://176206791"
    Eyes.Text = "Eye 3"
    wait()
    eye2 = false
    eye3 = true
  end
  wait()
  Pressed = false
end)
mask.MouseButton1Down:connect(function()
  if MaskOn == true and Pressed == false then
    Mask.Transparency = 1
    Pressed = true
    mask.BackgroundColor3 = Color3.new(1, 0.5, 0.5)
    wait()
    MaskOn = false
    MaskOff = true
  end
  if MaskOff == true and Pressed == false then
    Mask.Transparency = 0
    Pressed = true
    mask.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
    wait()
    MaskOn = true
    MaskOff = false
  end
  wait()
  Pressed = false
end)
Shirtset.MouseButton1Down:connect(function()
  char049.Shirt.ShirtTemplate = "rbxassetid://" .. ColTex3.Text
end)
Pantsset.MouseButton1Down:connect(function()
  char049.Pants.PantsTemplate = "rbxassetid://" .. ColTex4.Text
end)
Close.MouseButton1Down:connect(function()
  if Body.Visible == true then
    Body.Visible = false
    Close.Text = "+"
    Title.FontSize = "Size24"
    Pull.Size = UDim2(0, 125, 0, 12.5)
  elseif Body.Visible == false then
    Body.Visible = true
    Close.Text = "X"
    Title.FontSize = "Size48"
    Graf_f.Size = UDim2(0, 500, 0, 50)
  end
end)
local mesh = Instance.new("SpecialMesh", radio)
mesh.MeshId = "http://www.roblox.com/asset/?id=151760030"
mesh.TextureId = "rbxassetid://151760072"
mesh.Scale = Vector3.new(0.7, 0.7, 0.7)
ColTex2.Changed:connect(function()
  sound.SoundId = "rbxassetid://" .. ColTex2.Text
end)
while true do
  if Playing then
    mesh.Scale = Vector3.new(0.71, 0.71, 0.71)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.709, 0.709, 0.709)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.708, 0.708, 0.708)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.707, 0.707, 0.707)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.706, 0.706, 0.706)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.705, 0.705, 0.705)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.704, 0.704, 0.704)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.703, 0.703, 0.703)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.702, 0.702, 0.702)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.701, 0.701, 0.701)
    wait(1.0E-6)
    mesh.Scale = Vector3.new(0.7, 0.7, 0.7)
  end
  wait(0.2)
end
