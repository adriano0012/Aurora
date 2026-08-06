local v8 = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))();
local v9 = v8:MakeWindow({
    Name = 'Infernium Blade Ball',
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = 'OrionTest'
});
local v10 = v9:MakeTab({
    Name = 'Blade Ball',
    Icon = 'rbxassetid://4483345998',
    PremiumOnly = false
});
v10:AddParagraph('Sorry, there is no button', 'AutoParry activates automatically.');
local v11 = v9:MakeTab({
    Name = 'Misc',
    Icon = 'rbxassetid://4483345998',
    PremiumOnly = false
});
v11:AddButton({
    Name = 'Infinite Yield',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))();
    end
});
v11:AddButton({
    Name = 'CombatSpy',
    Callback = function()
        local v31 = 0;
        local v32;
        while true do
            if (v31 == (0)) then
                v32 = game:HttpGet('https://raw.githubusercontent.com/shibbylol/Combatspy/main/spy.lua');
                loadstring(v32)();
                break
            end
        end
    end
});
local v12 = v9:MakeTab({
    Name = 'Credits',
    Icon = 'rbxassetid://4483345998',
    PremiumOnly = false
});
v12:AddParagraph('Credits', 'r0gzarii & voltrivax');
local v19 = game:GetService('RunService') or game:FindFirstDescendant('RunService') ;
local v20 = game:GetService('Players') or game:FindFirstDescendant('Players') ;
local v21 = game:GetService('VirtualInputManager') or game:FindFirstDescendant('VirtualInputManager') ;
local v22 = v20.LocalPlayer;
local v23 = tick();
local v24 = false;
local v25;
local function v26()
    for v41, v42 in ipairs(workspace.Balls:GetChildren()) do
        if v42:GetAttribute('realBall') then
            return v42
        end
    end
end
local function v27()
    if v25 then
        local v43 = 0;
        while true do
            if (v43 == (0)) then
                v25:Disconnect();
                v25 = nil;
                break
            end
        end
    end
end
workspace.Balls.ChildAdded:Connect(function()
    local v33 = 0;
    local v34;
    while true do
        if (v33 == 0) then
            v34 = v26();
            if not v34 then
                return
            end
            v33 = 1;
        end
        if (v33 == (1)) then
            v27();
            v25 = v34:GetAttributeChangedSignal('target'):Connect(function()
                Parried = false;
            end);
            break
        end
    end
end);
v19.PreSimulation:Connect(function()
    local v35 = 0;
    local v36;
    local v37;
    local v38;
    local v39;
    while true do
        if (v35 == (2)) then
            if ((v36:GetAttribute('target') == v22.Name) and not Parried and ((v39 / v38) <= (0.5499999999999545))) then
                local v47 = 0;
                while true do
                    if (1 == v47) then
                        v23 = tick();
                        if ((tick() - v23) >= (1)) then
                            Partied = false;
                        end
                        break
                    end
                    if (v47 == (0)) then
                        v21:SendMouseButtonEvent(0, 0, 0, true, game, 0);
                        Parried = true;
                        v47 = 1;
                    end
                end
            end
            break
        end
        if (v35 == (0)) then
            v36, v37 = v26(), v22.Character.HumanoidRootPart;
            if (not v36 or not v37) then
                return
            end
            v35 = 1;
        end
        if ((1) == v35) then
            v38 = v36.zoomies.VectorVelocity.Magnitude;
            v39 = (v37.Position - v36.Position).Magnitude;
            v35 = 2;
        end
    end
end);
