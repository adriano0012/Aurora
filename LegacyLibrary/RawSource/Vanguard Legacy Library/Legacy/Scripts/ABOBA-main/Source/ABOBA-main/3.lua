    local folder = Instance.new("Folder", game.CoreGui.esp)
    folder.Name = "sharks"
    for i,v in pairs(game.Workspace.Sharks:GetChildren()) do
    if v ~= nil then
    sharks = {}
    table.insert(sharks, v.Name)
    for i = 1, #sharks do
    sdir = game.Workspace.Sharks[v.Name]
