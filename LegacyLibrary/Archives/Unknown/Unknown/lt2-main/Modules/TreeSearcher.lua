local TreeSearcher = {}

function TreeSearcher.Init(Tab, Library)
    local Players          = game:GetService("Players")
    local TeleportService  = game:GetService("TeleportService")
    local HttpService      = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui          = game:GetService("CoreGui")
    local TweenService     = game:GetService("TweenService")
    local player           = Players.LocalPlayer

    local FOLDER         = "Dynxe"
    local ACTIVE_FILE    = FOLDER .. "/cc_active.txt"
    local TREETYPE_FILE  = FOLDER .. "/cc_treetype.txt"
    local SIZE_FILE      = FOLDER .. "/cc_size.txt"
    local BOOTSTRAP_FILE = FOLDER .. "/cc_bootstrap.lua"
    local HOPPER_FILE    = FOLDER .. "/cc_hopper.lua"
    local QUEUE_LINE     = "pcall(function() loadstring(readfile('Dynxe/cc_bootstrap.lua'))() end)"
    local HUD_NAME       = "TreeSearcherHUD"

    local LOAD_WAIT   = 6
    local RETRY_WAIT  = 5
    local HOP_TIMEOUT = 20

    local SIZE_THRESHOLDS = {
        CaveCrawler = { Small = 0, Medium = 1000, Large = 2000 },
        LoneCave    = { Small = 0, Medium = 1000, Large = 2000 },
    }

    if not isfolder(FOLDER) then makefolder(FOLDER) end

    local function DestroyHUD()
        local existing = CoreGui:FindFirstChild(HUD_NAME)
        if existing then existing:Destroy() end
    end

    local function CreateHUD(treeType)
        DestroyHUD()

        local gui = Instance.new("ScreenGui")
        gui.Name            = HUD_NAME
        gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder    = 998
        gui.ResetOnSpawn    = false
        gui.IgnoreGuiInset  = true
        gui.Parent          = CoreGui

        local bar = Instance.new("Frame")
        bar.Name                   = "Bar"
        bar.Size                   = UDim2.new(1, 0, 0, 58)
        bar.Position               = UDim2.new(0, 0, 0.9, -29)
        bar.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
        bar.BackgroundTransparency = 0.45
        bar.BorderSizePixel        = 0
        bar.Parent                 = gui

        local topLine = Instance.new("Frame")
        topLine.Size             = UDim2.new(1, 0, 0, 1)
        topLine.BackgroundColor3 = Color3.fromRGB(74, 120, 255)
        topLine.BackgroundTransparency = 0.5
        topLine.BorderSizePixel  = 0
        topLine.Parent           = bar

        local botLine = Instance.new("Frame")
        botLine.Size             = UDim2.new(1, 0, 0, 1)
        botLine.Position         = UDim2.new(0, 0, 1, -1)
        botLine.BackgroundColor3 = Color3.fromRGB(74, 120, 255)
        botLine.BackgroundTransparency = 0.5
        botLine.BorderSizePixel  = 0
        botLine.Parent           = bar

        local topRow = Instance.new("Frame")
        topRow.Name                   = "TopRow"
        topRow.Size                   = UDim2.new(1, 0, 0, 28)
        topRow.Position               = UDim2.new(0, 0, 0, 2)
        topRow.BackgroundTransparency = 1
        topRow.Parent                 = bar

        local badge = Instance.new("TextLabel")
        badge.Size                   = UDim2.new(0, 160, 1, 0)
        badge.Position               = UDim2.new(0, 16, 0, 0)
        badge.BackgroundTransparency = 1
        badge.Text                   = "TREE SEARCHER"
        badge.TextColor3             = Color3.fromRGB(74, 120, 255)
        badge.Font                   = Enum.Font.GothamBold
        badge.TextSize               = 13
        badge.TextXAlignment         = Enum.TextXAlignment.Left
        badge.Parent                 = topRow

        local treeLabel = Instance.new("TextLabel")
        treeLabel.Name               = "TreeLabel"
        treeLabel.Size               = UDim2.new(1, -340, 1, 0)
        treeLabel.Position           = UDim2.new(0, 180, 0, 0)
        treeLabel.BackgroundTransparency = 1
        treeLabel.Text               = treeType or "Unknown"
        treeLabel.TextColor3         = Color3.fromRGB(220, 220, 220)
        treeLabel.Font               = Enum.Font.GothamMedium
        treeLabel.TextSize           = 13
        treeLabel.TextXAlignment     = Enum.TextXAlignment.Center
        treeLabel.Parent             = topRow

        local f1hint = Instance.new("TextLabel")
        f1hint.Size                  = UDim2.new(0, 140, 1, 0)
        f1hint.AnchorPoint           = Vector2.new(1, 0)
        f1hint.Position              = UDim2.new(1, -16, 0, 0)
        f1hint.BackgroundTransparency = 1
        f1hint.Text                  = "F1 / Backspace to stop"
        f1hint.TextColor3            = Color3.fromRGB(100, 100, 110)
        f1hint.Font                  = Enum.Font.Gotham
        f1hint.TextSize              = 12
        f1hint.TextXAlignment        = Enum.TextXAlignment.Right
        f1hint.Parent                = topRow

        local div = Instance.new("Frame")
        div.Size             = UDim2.new(1, -32, 0, 1)
        div.Position         = UDim2.new(0, 16, 0, 30)
        div.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        div.BorderSizePixel  = 0
        div.Parent           = bar

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Name                 = "StatusLabel"
        statusLabel.Size                 = UDim2.new(1, -32, 0, 24)
        statusLabel.Position             = UDim2.new(0, 16, 0, 32)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text                 = "Initializing..."
        statusLabel.TextColor3           = Color3.fromRGB(180, 180, 190)
        statusLabel.Font                 = Enum.Font.Gotham
        statusLabel.TextSize             = 12
        statusLabel.TextXAlignment       = Enum.TextXAlignment.Center
        statusLabel.Parent               = bar
    end

    local function SetHUDStatus(msg)
        local gui = CoreGui:FindFirstChild(HUD_NAME)
        if not gui then return end
        local bar   = gui:FindFirstChild("Bar")
        local label = bar and bar:FindFirstChild("StatusLabel")
        if label then label.Text = msg end
    end

    local function SetHUDFound(posStr, treeType)
        local gui = CoreGui:FindFirstChild(HUD_NAME)
        if not gui then return end
        local bar = gui:FindFirstChild("Bar")
        if not bar then return end
        TweenService:Create(bar, TweenInfo.new(0.4), {
            BackgroundColor3 = Color3.fromRGB(15, 55, 20)
        }):Play()
        local label = bar:FindFirstChild("StatusLabel")
        if label then
            label.Text       = treeType .. " found!  Position: " .. posStr .. "  |  F1 / Backspace to dismiss"
            label.TextColor3 = Color3.fromRGB(120, 230, 130)
        end
    end

    -- ================================================================
    -- BOOTSTRAP
    -- Paths inside the string use the Dynxe folder prefix.
    -- ================================================================
    local BOOTSTRAP_SRC = [=[
task.wait(2)
local ok, flag = pcall(readfile, "Dynxe/cc_active.txt")
if not ok or flag ~= "1" then return end
local ok2, src = pcall(readfile, "Dynxe/cc_hopper.lua")
if ok2 and src then loadstring(src)() end
]=]

    -- ================================================================
    -- STANDALONE HOPPER
    -- All file I/O under Dynxe/. ASCII only, no Library dependency.
    -- ================================================================
    local HOPPER_SRC = [=[
if getgenv()._ccRunning then return end
getgenv()._ccRunning = true
writefile("Dynxe/cc_active.txt", "1")

local QUEUE_LINE  = "pcall(function() loadstring(readfile('Dynxe/cc_bootstrap.lua'))() end)"
local LOAD_WAIT   = 6
local RETRY_WAIT  = 5
local HOP_TIMEOUT = 20
local HUD_NAME    = "TreeSearcherHUD"

local Players          = game:GetService("Players")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local player           = Players.LocalPlayer
local PLACE_ID         = game.PlaceId

local ok, treeClass = pcall(readfile, "Dynxe/cc_treetype.txt")
if not ok or not treeClass or treeClass == "" then treeClass = "CaveCrawler" end

local okS, sizeStr = pcall(readfile, "Dynxe/cc_size.txt")
local minVolume = (okS and tonumber(sizeStr)) or 0

local function DestroyHUD()
    local existing = CoreGui:FindFirstChild(HUD_NAME)
    if existing then existing:Destroy() end
end

local function CreateHUD(treeType)
    DestroyHUD()
    local gui = Instance.new("ScreenGui")
    gui.Name            = HUD_NAME
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder    = 998
    gui.ResetOnSpawn    = false
    gui.IgnoreGuiInset  = true
    gui.Parent          = CoreGui

    local bar = Instance.new("Frame")
    bar.Name                   = "Bar"
    bar.Size                   = UDim2.new(1, 0, 0, 58)
    bar.Position               = UDim2.new(0, 0, 0.9, -29)
    bar.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    bar.BackgroundTransparency = 0.45
    bar.BorderSizePixel        = 0
    bar.Parent                 = gui

    local topLine = Instance.new("Frame")
    topLine.Size             = UDim2.new(1, 0, 0, 1)
    topLine.BackgroundColor3 = Color3.fromRGB(74, 120, 255)
    topLine.BackgroundTransparency = 0.5
    topLine.BorderSizePixel  = 0
    topLine.Parent           = bar

    local botLine = Instance.new("Frame")
    botLine.Size             = UDim2.new(1, 0, 0, 1)
    botLine.Position         = UDim2.new(0, 0, 1, -1)
    botLine.BackgroundColor3 = Color3.fromRGB(74, 120, 255)
    botLine.BackgroundTransparency = 0.5
    botLine.BorderSizePixel  = 0
    botLine.Parent           = bar

    local topRow = Instance.new("Frame")
    topRow.Name                   = "TopRow"
    topRow.Size                   = UDim2.new(1, 0, 0, 28)
    topRow.Position               = UDim2.new(0, 0, 0, 2)
    topRow.BackgroundTransparency = 1
    topRow.Parent                 = bar

    local badge = Instance.new("TextLabel")
    badge.Size                   = UDim2.new(0, 160, 1, 0)
    badge.Position               = UDim2.new(0, 16, 0, 0)
    badge.BackgroundTransparency = 1
    badge.Text                   = "TREE SEARCHER"
    badge.TextColor3             = Color3.fromRGB(74, 120, 255)
    badge.Font                   = Enum.Font.GothamBold
    badge.TextSize               = 13
    badge.TextXAlignment         = Enum.TextXAlignment.Left
    badge.Parent                 = topRow

    local treeLabel = Instance.new("TextLabel")
    treeLabel.Size               = UDim2.new(1, -340, 1, 0)
    treeLabel.Position           = UDim2.new(0, 180, 0, 0)
    treeLabel.BackgroundTransparency = 1
    treeLabel.Text               = treeType or "Unknown"
    treeLabel.TextColor3         = Color3.fromRGB(220, 220, 220)
    treeLabel.Font               = Enum.Font.GothamMedium
    treeLabel.TextSize           = 13
    treeLabel.TextXAlignment     = Enum.TextXAlignment.Center
    treeLabel.Parent             = topRow

    local f1hint = Instance.new("TextLabel")
    f1hint.Size                  = UDim2.new(0, 140, 1, 0)
    f1hint.AnchorPoint           = Vector2.new(1, 0)
    f1hint.Position              = UDim2.new(1, -16, 0, 0)
    f1hint.BackgroundTransparency = 1
    f1hint.Text                  = "F1 / Backspace to stop"
    f1hint.TextColor3            = Color3.fromRGB(100, 100, 110)
    f1hint.Font                  = Enum.Font.Gotham
    f1hint.TextSize              = 12
    f1hint.TextXAlignment        = Enum.TextXAlignment.Right
    f1hint.Parent                = topRow

    local div = Instance.new("Frame")
    div.Size             = UDim2.new(1, -32, 0, 1)
    div.Position         = UDim2.new(0, 16, 0, 30)
    div.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    div.BorderSizePixel  = 0
    div.Parent           = bar

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name                 = "StatusLabel"
    statusLabel.Size                 = UDim2.new(1, -32, 0, 24)
    statusLabel.Position             = UDim2.new(0, 16, 0, 32)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text                 = "Scanning..."
    statusLabel.TextColor3           = Color3.fromRGB(180, 180, 190)
    statusLabel.Font                 = Enum.Font.Gotham
    statusLabel.TextSize             = 12
    statusLabel.TextXAlignment       = Enum.TextXAlignment.Center
    statusLabel.Parent               = bar
end

local function SetHUDStatus(msg)
    local gui = CoreGui:FindFirstChild(HUD_NAME)
    if not gui then return end
    local bar   = gui:FindFirstChild("Bar")
    local label = bar and bar:FindFirstChild("StatusLabel")
    if label then label.Text = msg end
end

local function SetHUDFound(posStr, treeType)
    local gui = CoreGui:FindFirstChild(HUD_NAME)
    if not gui then return end
    local bar = gui:FindFirstChild("Bar")
    if not bar then return end
    TweenService:Create(bar, TweenInfo.new(0.4), {
        BackgroundColor3 = Color3.fromRGB(15, 55, 20)
    }):Play()
    local label = bar:FindFirstChild("StatusLabel")
    if label then
        label.Text       = treeType .. " found!  Position: " .. posStr .. "  |  F1 / Backspace to dismiss"
        label.TextColor3 = Color3.fromRGB(120, 230, 130)
    end
end

local running = true

CreateHUD(treeClass)
SetHUDStatus("Waiting for world to load...")

local stopConn = UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and (input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.Backspace) then
        running = false
        getgenv()._ccRunning = nil
        pcall(writefile, "Dynxe/cc_active.txt", "0")
        DestroyHUD()
    end
end)

local function GetTreeVolume(model)
    local total = 0
    for _, part in ipairs(model:GetChildren()) do
        if part.Name == "WoodSection" and part:IsA("BasePart") then
            total += part.Size.X * part.Size.Y * part.Size.Z
        end
    end
    return total
end

local function FindTree(cls)
    for _, folder in ipairs(workspace:GetChildren()) do
        if folder.Name:lower():match("treeregion") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") then
                    local tc = model:FindFirstChild("TreeClass")
                    if tc and tc:IsA("StringValue") and tc.Value == cls then
                        if minVolume > 0 and GetTreeVolume(model) < minVolume then
                            continue
                        end
                        return true, model
                    end
                end
            end
        end
    end
    return false, nil
end

local function SafeHttpGet(url)
    local ok2, res = pcall(function() return game:HttpGet(url) end)
    if ok2 and res and res ~= "" then return res end
    if request then
        ok2, res = pcall(function() return request({Url=url, Method="GET"}).Body end)
        if ok2 and res and res ~= "" then return res end
    end
    return nil
end

local function FetchServers()
    local url  = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(PLACE_ID)
    local body = SafeHttpGet(url)
    if not body then return {} end
    local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, body)
    return (ok2 and type(decoded) == "table" and decoded.data) or {}
end

local function ArmAndHop()
    local servers    = FetchServers()
    local currentId  = game.JobId
    local candidates = {}
    for _, s in ipairs(servers) do
        if s.id ~= currentId
        and type(s.playing) == "number"
        and type(s.maxPlayers) == "number"
        and s.playing < s.maxPlayers then
            table.insert(candidates, s)
        end
    end
    if #candidates == 0 then return false end
    if not queue_on_teleport then return false end
    local target = candidates[math.random(1, #candidates)]
    queue_on_teleport(QUEUE_LINE)
    local ok2 = pcall(TeleportService.TeleportToPlaceInstance,
        TeleportService, PLACE_ID, target.id, player)
    if not ok2 then
        pcall(writefile, "Dynxe/cc_active.txt", "0")
        return false
    end
    return true
end

task.wait(LOAD_WAIT)

while running do
    local sizeTag = minVolume > 0 and (" (vol >= " .. tostring(minVolume) .. ")") or ""
    SetHUDStatus("Scanning for " .. treeClass .. sizeTag .. "...")
    local found, treeModel = FindTree(treeClass)
    if found then
        local pos    = treeModel and treeModel:GetPivot().Position or Vector3.zero
        local posStr = ("%.1f, %.1f, %.1f"):format(pos.X, pos.Y, pos.Z)
        SetHUDFound(posStr, treeClass)
        running = false
        getgenv()._ccRunning = nil
        pcall(writefile, "Dynxe/cc_active.txt", "0")
        break
    end
    if not running then break end
    SetHUDStatus("Not found. Hopping to next server...")
    local hopped = ArmAndHop()
    if hopped then
        local deadline = tick() + HOP_TIMEOUT
        while running and tick() < deadline do task.wait(1) end
    else
        SetHUDStatus("No servers available. Retrying...")
        task.wait(RETRY_WAIT)
    end
end
]=]

    -- ================================================================
    -- UI
    -- ================================================================
    Tab:CreateSection("Tree Server Search")

    local TREE_OPTIONS = { "CaveCrawler", "LoneCave", "BlueSpruce", "Spooky", "SpookyNeon" }
    local DISABLED     = { BlueSpruce = true, Spooky = true, SpookyNeon = true }

    local selectedTree = "CaveCrawler"
    local selectedSize = "Small"
    local searchActive = false
    local startBtn

    local treeDropdown = Tab:CreateDropdown("Target Tree", TREE_OPTIONS, "CaveCrawler", function(sel)
        if not DISABLED[sel] then
            selectedTree = sel
        end
    end)

    for name in pairs(DISABLED) do
        treeDropdown:SetOptionDisabled(name, true)
    end

    Tab:CreateDropdown("Size", { "Small", "Medium", "Large" }, "Small", function(sel)
        selectedSize = sel
    end)

    -- ================================================================
    -- HELPERS
    -- ================================================================
    local function GetTreeVolume(model)
        local total = 0
        for _, part in ipairs(model:GetChildren()) do
            if part.Name == "WoodSection" and part:IsA("BasePart") then
                total += part.Size.X * part.Size.Y * part.Size.Z
            end
        end
        return total
    end

    local function FindTree(cls)
        local treeThresholds = SIZE_THRESHOLDS[cls] or { Small = 0, Medium = 0, Large = 0 }
        local minVol = treeThresholds[selectedSize] or 0
        for _, folder in ipairs(workspace:GetChildren()) do
            if folder.Name:lower():match("treeregion") then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") then
                        local tc = model:FindFirstChild("TreeClass")
                        if tc and tc:IsA("StringValue") and tc.Value == cls then
                            if minVol > 0 and GetTreeVolume(model) < minVol then
                                continue
                            end
                            return true, model
                        end
                    end
                end
            end
        end
        return false, nil
    end

    local function SafeHttpGet(url)
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res and res ~= "" then return res end
        return nil
    end

    local function FetchServers()
        local url  = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
        local body = SafeHttpGet(url)
        if not body then return {} end
        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body)
        return (ok and type(decoded) == "table" and decoded.data) or {}
    end

    local function WriteFiles()
        if not isfolder(FOLDER) then makefolder(FOLDER) end
        local treeThresholds = SIZE_THRESHOLDS[selectedTree] or { Small = 0, Medium = 0, Large = 0 }
        local threshold = treeThresholds[selectedSize] or 0
        pcall(writefile, ACTIVE_FILE,    "1")
        pcall(writefile, TREETYPE_FILE,  selectedTree)
        pcall(writefile, SIZE_FILE,      tostring(threshold))
        pcall(writefile, BOOTSTRAP_FILE, BOOTSTRAP_SRC)
        pcall(writefile, HOPPER_FILE,    HOPPER_SRC)
    end

    -- ================================================================
    -- SEARCH LOGIC
    -- ================================================================
    local function StopSearch()
        if not searchActive then return end
        searchActive = false
        getgenv()._ccRunning = nil
        pcall(writefile, ACTIVE_FILE, "0")
        if startBtn then startBtn:SetText("Start") end
        treeDropdown:SetDisabled(false)
        DestroyHUD()
    end

    local function ArmNextHop()
        if not queue_on_teleport then
            SetHUDStatus("queue_on_teleport unavailable - search cannot persist across servers")
            return false
        end
        pcall(writefile, ACTIVE_FILE, "1")
        queue_on_teleport(QUEUE_LINE)
        return true
    end

    local function HopToServer()
        local servers    = FetchServers()
        local currentId  = game.JobId
        local candidates = {}
        for _, s in ipairs(servers) do
            if s.id ~= currentId
            and type(s.playing) == "number"
            and type(s.maxPlayers) == "number"
            and s.playing < s.maxPlayers then
                table.insert(candidates, s)
            end
        end
        if #candidates == 0 then
            SetHUDStatus("No available servers found. Retrying...")
            return false
        end
        SetHUDStatus("Hopping to next server...")
        if not ArmNextHop() then return false end
        local target = candidates[math.random(1, #candidates)]
        local ok = pcall(TeleportService.TeleportToPlaceInstance,
            TeleportService, game.PlaceId, target.id, player)
        if not ok then
            SetHUDStatus("Teleport failed. Retrying...")
            pcall(writefile, ACTIVE_FILE, "0")
            return false
        end
        return true
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F1 or input.KeyCode == Enum.KeyCode.Backspace then
            if searchActive then
                StopSearch()
            else
                DestroyHUD()
            end
        end
    end)

    local function OnStartStop()
        if searchActive then
            StopSearch()
            return
        end

        if getgenv()._ccRunning then
            SetHUDStatus("A search is already running.")
            return
        end

        searchActive = true
        if startBtn then startBtn:SetText("Stop") end
        treeDropdown:SetDisabled(true)

        WriteFiles()
        CreateHUD(selectedTree)

        local treeThresholds = SIZE_THRESHOLDS[selectedTree] or { Small = 0, Medium = 0, Large = 0 }
        local minVol  = treeThresholds[selectedSize] or 0
        local sizeTag = minVol > 0 and (" | " .. selectedSize .. " vol >= " .. minVol) or " | Any size"
        SetHUDStatus("Starting search for " .. selectedTree .. sizeTag .. "...")

        task.spawn(function()
            getgenv()._ccRunning = true

            SetHUDStatus("Waiting for world to finish loading...")
            task.wait(LOAD_WAIT)

            while searchActive and getgenv()._ccRunning do
                local treeT = SIZE_THRESHOLDS[selectedTree] or { Small = 0, Medium = 0, Large = 0 }
                local minV  = treeT[selectedSize] or 0
                local sTag  = minV > 0 and (" | min vol " .. minV) or ""
                SetHUDStatus("Scanning for " .. selectedTree .. sTag .. "...")

                local found, treeModel = FindTree(selectedTree)

                if found then
                    local pos    = treeModel and treeModel:GetPivot().Position or Vector3.zero
                    local posStr = ("%.1f, %.1f, %.1f"):format(pos.X, pos.Y, pos.Z)
                    SetHUDFound(posStr, selectedTree)
                    searchActive = false
                    getgenv()._ccRunning = nil
                    pcall(writefile, ACTIVE_FILE, "0")
                    if startBtn then startBtn:SetText("Start") end
                    treeDropdown:SetDisabled(false)
                    break
                end

                if not searchActive then break end

                SetHUDStatus(selectedTree .. " not found here. Hopping...")

                local hopped = HopToServer()
                if hopped then
                    local deadline = tick() + HOP_TIMEOUT
                    while searchActive and getgenv()._ccRunning and tick() < deadline do
                        task.wait(1)
                    end
                    if searchActive and getgenv()._ccRunning then
                        SetHUDStatus("Teleport timed out. Retrying hop...")
                    end
                else
                    task.wait(RETRY_WAIT)
                end
            end

            getgenv()._ccRunning = nil
        end)
    end

    startBtn = Tab:CreateAction("Search for Tree", "Start", OnStartStop)
end

return TreeSearcher
