items = game:GetService(“Workspace”).GameObjects.Physical.Items
for i, v in pairs(items:GetDescendants()) do
if v:IsA(“MeshPart”) then
if true then
local BillboardGui = Instance.new(‘BillboardGui’)
local TextLabel = Instance.new(‘TextLabel’)BillboardGui.Parent = v.Parent
BillboardGui.AlwaysOnTop = true
BillboardGui.Size = UDim2.new(0, 50, 0, 50)
BillboardGui.Enabled = true
BillboardGui.Active =true
BillboardGui.StudsOffset = Vector3.new(0,2,0)TextLabel.Parent = BillboardGui
TextLabel.BackgroundColor3 = Color3.new(1,1,1)
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = “[ “..tostring(v.Parent) .. ” ]”
TextLabel.TextColor3 = Color3.fromRGB(0,0,238)
TextLabel.TextScaled = false
end
end
end 
