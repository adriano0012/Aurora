local User = "learnhtsd"
local Repo = "lt2"
local Branch = "main"
local Version = "v0.0.651"

task.spawn(function()
    local ICON_FOLDER  = "Dynxe"
    local VERSION_FILE = ICON_FOLDER .. "/_version"

    if not (isfolder and listfiles and isfile and delfile and writefile) then return end

    local storedOk, storedVersion = pcall(readfile, VERSION_FILE)
    local upToDate = storedOk and storedVersion == Version

    if not upToDate then
        if isfolder(ICON_FOLDER) then
            local ok, files = pcall(listfiles, ICON_FOLDER)
            if ok and type(files) == "table" then
                for _, path in ipairs(files) do
                    if path:match("%.png$") then
                        pcall(delfile, path)
                    end
                end
            end
        else
            makefolder(ICON_FOLDER)
        end
        pcall(writefile, VERSION_FILE, Version)
    end
end)

--loadstring(game:HttpGet("https://raw.githubusercontent.com/learnhtsd/lt2/refs/heads/main/main.lua"))()

-- ██████╗  ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██╔════╝ ██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║      ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║      ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╗ ╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝

local Config = {
    Window = {
        Width  = 400,
        Height = 550,
        SidebarWidth = 40,
    },
    Elements = {
        Scale = 0.80,
    },
    Theme = {
        Accent          = Color3.fromRGB(74,  120, 255),
        Background      = Color3.fromRGB(18,  18,  22),
        Surface         = Color3.fromRGB(24,  24,  29),
        SurfaceDeep     = Color3.fromRGB(35,  35,  42),
        Sidebar         = Color3.fromRGB(14,  14,  17),
        Stroke          = Color3.fromRGB(40,  40,  48),
        TextPrimary     = Color3.fromRGB(220, 220, 220),
        TextSecondary   = Color3.fromRGB(120, 120, 130),
        TextDark        = Color3.fromRGB(180, 180, 180),
        TextWhite       = Color3.fromRGB(255, 255, 255),
        Success         = Color3.fromRGB(45,  160, 75),
        Warning         = Color3.fromRGB(100, 155, 255),
        NotifBackground = Color3.fromRGB(24,  24,  29),
    },
}

local function ES(n) return math.round(n * Config.Elements.Scale) end
local function FS(n) return math.max(8, math.round(n * Config.Elements.Scale)) end
local T = Config.Theme
local W = Config.Window

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui               = game:GetService("CoreGui")
local UserInputService      = game:GetService("UserInputService")
local TweenService          = game:GetService("TweenService")
local ContextActionService  = game:GetService("ContextActionService")
local TextService           = game:GetService("TextService")
local GuiService            = game:GetService("GuiService")

-- ============================================================
-- CACHED TWEENINFOS  (avoids a new allocation on every interaction)
-- ============================================================
local TI_02    = TweenInfo.new(0.2)
local TI_03    = TweenInfo.new(0.3)
local TI_015   = TweenInfo.new(0.15)
local TI_025   = TweenInfo.new(0.25)
local TI_025Q  = TweenInfo.new(0.25, Enum.EasingStyle.Quart)
local TI_04Q_O = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TI_04Q_I = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

-- ============================================================
-- INSTANCE HELPERS
-- ============================================================
--- Adds a UICorner to `parent`. Defaults to the standard 6px radius.
local function Corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = radius or UDim.new(0, 6)
    return c
end

-- ============================================================
-- UI ENGINE
-- ============================================================
local Library = {}

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "DynxeHub" then v:Destroy() end
    if v.Name == "DynxeNotifications" then v:Destroy() end
end

-- ── Image helper ─────────────────────────────────────────────
local function FileExists(path)
    local ok, data = pcall(readfile, path)
    return ok and type(data) == "string" and #data > 0
end

getgenv().GetImage = function(folder, fileName)
    local base       = "Dynxe"
    local localPath  = (folder ~= "" and folder ~= nil)
                       and (base .. "/" .. folder .. "/" .. fileName)
                       or  (base .. "/" .. fileName)
    local folderPath = (folder ~= "" and folder ~= nil)
                       and (base .. "/" .. folder)
                       or  base
    local placeholderLocal = base .. "/Placeholder.png"
    local placeholderUrl   = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/Images/Placeholder.png",
        User, Repo, Branch
    )
    if isfolder and not isfolder(base)       then makefolder(base)       end
    if isfolder and not isfolder(folderPath) then makefolder(folderPath) end
    if not FileExists(placeholderLocal) then
        local pOk, pData = pcall(function() return game:HttpGet(placeholderUrl) end)
        if pOk and #pData > 100 then writefile(placeholderLocal, pData) end
    end
    if FileExists(localPath) then return getcustomasset(localPath) end
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/Images/%s/%s",
        User, Repo, Branch, folder, fileName
    )
    local ok, content = pcall(function() return game:HttpGet(url) end)
    if ok and content and not content:find("404: Not Found") and #content > 100 then
        writefile(localPath, content)
        return getcustomasset(localPath)
    else
        warn("Asset Missing: " .. fileName)
        return FileExists(placeholderLocal) and getcustomasset(placeholderLocal) or "rbxassetid://6023426923"
    end
end

-- ── Depth stroke helper (hoisted — shared across all tabs) ───
local function AddDepthStroke(frame)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent          = frame
    Stroke.Color           = T.Stroke
    Stroke.Thickness       = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

-- ── Window ───────────────────────────────────────────────────
function Library:CreateWindow()
    local Window     = {}
    local CurrentTab = nil

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = "DynxeHub"
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset  = true
    ScreenGui.Parent          = CoreGui

    -- TOOLTIP
    local TooltipGui = Instance.new("TextLabel")
    TooltipGui.Size                = UDim2.new(0, 0, 0, 0)
    TooltipGui.AutomaticSize       = Enum.AutomaticSize.XY
    TooltipGui.BackgroundColor3    = Color3.fromRGB(15, 15, 25)
    TooltipGui.TextColor3          = T.TextDark
    TooltipGui.Font                = Enum.Font.GothamMedium
    TooltipGui.TextSize            = FS(12)
    TooltipGui.RichText            = true
    TooltipGui.Visible             = false
    TooltipGui.ZIndex              = 100
    TooltipGui.Parent              = ScreenGui
    local TTPad = Instance.new("UIPadding", TooltipGui)
    TTPad.PaddingTop    = UDim.new(0, ES(6))
    TTPad.PaddingBottom = UDim.new(0, ES(6))
    TTPad.PaddingLeft   = UDim.new(0, ES(8))
    TTPad.PaddingRight  = UDim.new(0, ES(8))
    Corner(TooltipGui, UDim.new(0, 4))

    function Library.ShowTooltip(text)
        TooltipGui.Text    = text
        TooltipGui.Visible = true
    end
    function Library.HideTooltip()
        TooltipGui.Visible = false
    end
    local _inset = GuiService:GetGuiInset()
    UserInputService.InputChanged:Connect(function(input)
        if TooltipGui.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
            TooltipGui.Position = UDim2.new(
                0, math.round(input.Position.X + 12),
                0, math.round(input.Position.Y + _inset.Y + 12)
            )
        end
    end)

    -- TOOLTIP ATTACHMENT HELPER
    local function AttachTooltip(TitleLabel, ElementTable)
        function ElementTable:AddTooltip(text)
            local InfoIcon = Instance.new("TextLabel")
            InfoIcon.Size               = UDim2.new(0, ES(16), 0, ES(16))
            InfoIcon.AnchorPoint        = Vector2.new(0, 0.5)
            InfoIcon.BackgroundTransparency = 1
            InfoIcon.Text               = "(?)"
            InfoIcon.TextColor3         = T.TextSecondary
            InfoIcon.Font               = Enum.Font.Gotham
            InfoIcon.TextSize           = FS(12)
            InfoIcon.Parent             = TitleLabel
            local function updatePos()
                InfoIcon.Position = UDim2.new(0, TitleLabel.TextBounds.X + 6, 0.5, 0)
            end
            TitleLabel:GetPropertyChangedSignal("TextBounds"):Connect(updatePos)
            updatePos()
            InfoIcon.MouseEnter:Connect(function()
                InfoIcon.TextColor3 = T.Accent
                Library.ShowTooltip(text)
            end)
            InfoIcon.MouseLeave:Connect(function()
                InfoIcon.TextColor3 = T.TextSecondary
                Library.HideTooltip()
            end)
            return ElementTable
        end
        return ElementTable
    end

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Size                 = UDim2.new(0, W.Width, 0, W.Height)
    MainFrame.Position             = UDim2.new(0, 0, 1, -(W.Height + 120))
    MainFrame.BackgroundColor3     = T.Background
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel      = 0
    MainFrame.ZIndex               = 2
    MainFrame.Parent               = ScreenGui
    Corner(MainFrame)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Size             = UDim2.new(0, W.SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = T.Sidebar
    Sidebar.BorderSizePixel  = 0
    Sidebar.Parent           = MainFrame
    Corner(Sidebar)

    local SideBlock = Instance.new("Frame")
    SideBlock.Size             = UDim2.new(0, 10, 1, 0)
    SideBlock.Position         = UDim2.new(1, -10, 0, 0)
    SideBlock.BackgroundColor3 = T.Sidebar
    SideBlock.BorderSizePixel  = 0
    SideBlock.Parent           = Sidebar

    -- HEADER
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size               = UDim2.new(1, -(W.SidebarWidth + 25), 0, 30)
    HeaderTitle.Position = UDim2.new(0, W.SidebarWidth + 7, 0, 10)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text               = "<b>Dynxe</b> <font color=\"#4a78ff\">LT2</font> <font color=\"#555555\" size=\"" .. FS(12) .. "\">" .. Version .. "</font>"
    HeaderTitle.RichText           = true
    HeaderTitle.TextColor3         = T.TextWhite
    HeaderTitle.Font               = Enum.Font.GothamMedium
    HeaderTitle.TextSize           = FS(16)
    HeaderTitle.TextXAlignment     = Enum.TextXAlignment.Left
    HeaderTitle.Parent             = MainFrame

    local ActiveTabLabel = Instance.new("TextLabel")
    ActiveTabLabel.Size            = UDim2.new(0, 150, 0, 30)
    ActiveTabLabel.Position        = UDim2.new(1, -165, 0, 10)
    ActiveTabLabel.BackgroundTransparency = 1
    ActiveTabLabel.Text            = ""
    ActiveTabLabel.TextColor3      = T.Accent
    ActiveTabLabel.Font            = Enum.Font.GothamMedium
    ActiveTabLabel.TextSize        = FS(12)
    ActiveTabLabel.TextXAlignment  = Enum.TextXAlignment.Right
    ActiveTabLabel.Parent          = MainFrame
    
    -- Add this block after ActiveTabLabel is set up (around line where ActiveTabLabel.Parent = MainFrame)
    
    local FerryLabel = Instance.new("TextLabel")
    FerryLabel.Size            = UDim2.new(1, -(W.SidebarWidth + 25), 0, 14)
    FerryLabel.Position        = UDim2.new(0, W.SidebarWidth + 7, 0, 32)
    FerryLabel.BackgroundTransparency = 1
    FerryLabel.Text            = "Ferry: --"
    FerryLabel.TextColor3      = T.TextSecondary
    FerryLabel.Font            = Enum.Font.Gotham
    FerryLabel.TextSize        = FS(11)
    FerryLabel.TextXAlignment  = Enum.TextXAlignment.Left
    FerryLabel.Parent          = MainFrame
    
    -- Ferry timer listener
    task.spawn(function()
        local Ferry = game.Workspace:WaitForChild("Ferry", 10)
        if not Ferry then return end
        local TimeToDeparture = Ferry:WaitForChild("TimeToDeparture", 10)
        if not TimeToDeparture then return end
    
        local function UpdateFerry()
            local val = TimeToDeparture.Value
            if val <= 0 then
                FerryLabel.Text      = "Ferry has Departed"
                FerryLabel.TextColor3 = T.TextSecondary
            elseif val <= 10 then
                FerryLabel.Text      = "Ferry Departs: " .. val .. "s"
                FerryLabel.TextColor3 = T.Warning  -- blue-ish highlight when close
            else
                FerryLabel.Text      = "Ferry Departs: " .. val .. "s"
                FerryLabel.TextColor3 = T.TextSecondary
            end
        end
    
        UpdateFerry()
        TimeToDeparture.Changed:Connect(UpdateFerry)
    end)
    
    -- TAB CONTAINER (inside sidebar)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name              = "TabContainer"
    TabContainer.Size              = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.BorderSizePixel   = 0
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.Parent            = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent             = TabContainer
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.VerticalAlignment  = Enum.VerticalAlignment.Top
    SidebarList.SortOrder          = Enum.SortOrder.LayoutOrder
    SidebarList.Padding            = UDim.new(0, ES(15))

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent     = TabContainer
    SidebarPadding.PaddingTop = UDim.new(0, ES(20))

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 30)
    end)

    -- CONTENT AREA
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size     = UDim2.new(1, -(W.SidebarWidth + 14), 1, -60)
    ContentContainer.Position = UDim2.new(0, W.SidebarWidth + 7, 0, 52)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants  = true
    ContentContainer.Parent            = MainFrame

    -- NOTIFICATIONS
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name            = "DynxeNotifications"
    NotifGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    NotifGui.DisplayOrder    = 999
    NotifGui.ResetOnSpawn    = false
    NotifGui.Parent          = CoreGui

    -- AnchorPoint(1,0) + Position(1,0,...) pins the right edge flush to the screen.
    local NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name        = "NotificationContainer"
    NotificationContainer.Size        = UDim2.new(0, 270, 1, -20)
    NotificationContainer.AnchorPoint = Vector2.new(1, 0)
    NotificationContainer.Position    = UDim2.new(1, 0, 0, 10)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.Parent      = NotifGui

    local NotifList = Instance.new("UIListLayout")
    NotifList.Parent            = NotificationContainer
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.SortOrder         = Enum.SortOrder.LayoutOrder
    NotifList.Padding           = UDim.new(0, 6)

    function Library:Notify(Title, Text, Duration)
        Duration = Duration or 2

        local CR     = 4   -- reduced roundness
        local OPEN_H = ES(72)

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size                   = UDim2.new(1, CR, 0, 0)
        NotifFrame.BackgroundColor3       = T.NotifBackground
        NotifFrame.BackgroundTransparency = 0.08
        NotifFrame.BorderSizePixel        = 0
        NotifFrame.Parent                 = NotificationContainer
        Corner(NotifFrame, UDim.new(0, CR))

        local AccentBar = Instance.new("Frame")
        AccentBar.Size             = UDim2.new(0, 2, 1, 0)
        AccentBar.AnchorPoint      = Vector2.new(1, 0)
        AccentBar.Position         = UDim2.new(1, -CR, 0, 0)
        AccentBar.BackgroundColor3 = T.Accent
        AccentBar.BorderSizePixel  = 0
        AccentBar.Parent           = NotifFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size               = UDim2.new(1, -(CR + ES(20)), 0, ES(20))
        TitleLabel.Position           = UDim2.new(0, ES(10), 0, ES(8))
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text               = Title:upper()
        TitleLabel.TextColor3         = T.Accent
        TitleLabel.Font               = Enum.Font.GothamBold
        TitleLabel.TextSize           = FS(14)   -- increased
        TitleLabel.TextXAlignment     = Enum.TextXAlignment.Right
        TitleLabel.TextTruncate       = Enum.TextTruncate.AtEnd
        TitleLabel.Parent             = NotifFrame

        local DividerTrack = Instance.new("Frame")
        DividerTrack.Size                   = UDim2.new(1, -(CR + ES(12)), 0, ES(2))
        DividerTrack.Position               = UDim2.new(0, ES(6), 0, ES(31))
        DividerTrack.BackgroundColor3       = T.Stroke
        DividerTrack.BackgroundTransparency = 0.3
        DividerTrack.BorderSizePixel        = 0
        DividerTrack.ClipsDescendants       = true
        DividerTrack.Parent                 = NotifFrame
        Corner(DividerTrack, UDim.new(1, 0))

        -- AnchorPoint(1,0) pins the RIGHT edge so as width shrinks the
        -- LEFT edge moves rightward — draining left to right.
        local DividerFill = Instance.new("Frame")
        DividerFill.AnchorPoint      = Vector2.new(1, 0)
        DividerFill.Position         = UDim2.new(1, 0, 0, 0)
        DividerFill.Size             = UDim2.new(1, 0, 1, 0)
        DividerFill.BackgroundColor3 = T.Accent
        DividerFill.BackgroundTransparency = 0.35
        DividerFill.BorderSizePixel  = 0
        DividerFill.Parent           = DividerTrack

        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Size             = UDim2.new(1, -(CR + ES(16)), 0, ES(30))
        ContentLabel.Position         = UDim2.new(0, ES(10), 0, ES(36))
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Text             = Text
        ContentLabel.TextColor3       = T.TextDark
        ContentLabel.Font             = Enum.Font.Gotham
        ContentLabel.TextSize         = FS(13)   -- increased
        ContentLabel.TextWrapped      = true
        ContentLabel.TextXAlignment   = Enum.TextXAlignment.Right
        ContentLabel.Parent           = NotifFrame

        local openTween = TweenService:Create(NotifFrame, TI_04Q_O, {
            Size = UDim2.new(1, CR, 0, OPEN_H)
        })
        openTween:Play()
        openTween.Completed:Connect(function()
            TweenService:Create(DividerFill,
                TweenInfo.new(Duration, Enum.EasingStyle.Linear),
                { Size = UDim2.new(0, 0, 1, 0) }
            ):Play()
        end)

        task.delay(Duration, function()
            local Tween = TweenService:Create(NotifFrame, TI_04Q_I, {
                Size                   = UDim2.new(1, CR, 0, 0),
                BackgroundTransparency = 1,
            })
            Tween:Play()
            Tween.Completed:Connect(function() NotifFrame:Destroy() end)
        end)
    end

    -- DRAG
    local dragging, dragStart, startPos = false, nil, nil
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and not _G.DynxeMenuClamped then
            local d = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- ── CREATE TAB ───────────────────────────────────────────
    function Window:CreateTab(TabName)
        local Tab = {}

        local TabBtn = Instance.new("ImageButton")
        TabBtn.Name              = TabName
        TabBtn.Size              = UDim2.new(0, ES(32), 0, ES(32))
        TabBtn.Parent            = TabContainer
        TabBtn.BackgroundColor3  = T.Accent
        TabBtn.BackgroundTransparency = 1
        Corner(TabBtn, UDim.new(0, 8))

        local FallbackText = Instance.new("TextLabel", TabBtn)
        FallbackText.Size              = UDim2.new(1, 0, 1, 0)
        FallbackText.BackgroundTransparency = 1
        FallbackText.Text              = string.sub(TabName, 1, 1):upper()
        FallbackText.TextColor3        = T.TextSecondary
        FallbackText.Font              = Enum.Font.GothamBold
        FallbackText.TextSize          = FS(14)
        FallbackText.Name              = "TabIconText"

        local folderName  = "Dynxe"
        local fileName    = TabName .. ".png"
        local filePath    = folderName .. "/" .. fileName
        local finalAssetUrl = ""
        if isfolder and makefolder and writefile and isfile and getcustomasset then
            if not isfolder(folderName) then makefolder(folderName) end
            if not FileExists(filePath) then
                local iconUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/Icons/%s.png?t=%s", User, Repo, Branch, TabName, tick())
                local ok, imgData = pcall(function() return game:HttpGet(iconUrl) end)
                if ok and imgData and not imgData:match("404: Not Found") then writefile(filePath, imgData) end
            end
            if FileExists(filePath) then finalAssetUrl = getcustomasset(filePath) end
        end

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size               = UDim2.new(0, ES(20), 0, ES(20))
        TabIcon.Position           = UDim2.new(0.5, -ES(10), 0.5, -ES(10))
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image              = finalAssetUrl
        TabIcon.ImageColor3        = T.TextWhite
        TabIcon.ScaleType          = Enum.ScaleType.Fit
        TabIcon.Name               = "TabIcon"
        TabIcon.Parent             = TabBtn
        if finalAssetUrl ~= "" then FallbackText.Visible = false end

        local TweenIn  = TweenService:Create(TabBtn, TI_03, {BackgroundTransparency = 0.85})
        local TweenOut = TweenService:Create(TabBtn, TI_03, {BackgroundTransparency = 1})

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size               = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 0
        TabPage.BorderSizePixel    = 0
        TabPage.Visible            = false
        TabPage.ClipsDescendants   = true
        TabPage.Parent             = ContentContainer
        Tab.Container              = TabPage

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent   = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding  = UDim.new(0, ES(6))

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent        = TabPage
        PagePadding.PaddingLeft   = UDim.new(0, 2)
        PagePadding.PaddingRight  = UDim.new(0, 4)
        PagePadding.PaddingTop    = UDim.new(0, 2)
        PagePadding.PaddingBottom = UDim.new(0, ES(20))

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 25)
        end)

        local function ActivateTab()
            if CurrentTab then
                CurrentTab.TweenOut:Play()
                CurrentTab.Btn.TabIconText.TextColor3 = T.TextSecondary
                local prev = CurrentTab.Btn:FindFirstChild("TabIcon")
                if prev then
                    TweenService:Create(prev, TI_03, {ImageColor3 = T.TextSecondary}):Play()
                end
                CurrentTab.Page.Visible = false
            end
            TweenIn:Play()
            FallbackText.TextColor3 = T.Accent
            TweenService:Create(TabIcon, TI_03, {ImageColor3 = T.Accent}):Play()
            TabPage.Visible         = true
            ActiveTabLabel.Text     = TabName:upper()
            CurrentTab = {Btn = TabBtn, TweenOut = TweenOut, Page = TabPage}
        end

        TabBtn.MouseButton1Click:Connect(ActivateTab)
        if not CurrentTab then ActivateTab() end

        -- ── ROW ───────────────────────────────────────────────
        function Tab:CreateRow()
            local Row = setmetatable({}, {__index = self})
            local RowFrame = Instance.new("Frame")
            RowFrame.Size              = UDim2.new(1, 0, 0, ES(28))
            RowFrame.BackgroundTransparency = 1
            RowFrame.Parent            = self.Container
            local RowLayout = Instance.new("UIListLayout")
            RowLayout.Parent          = RowFrame
            RowLayout.FillDirection   = Enum.FillDirection.Horizontal
            RowLayout.SortOrder       = Enum.SortOrder.LayoutOrder
            RowLayout.Padding         = UDim.new(0, ES(6))
            RowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                RowFrame.Size = UDim2.new(1, 0, 0, RowLayout.AbsoluteContentSize.Y)
            end)
            RowFrame.ChildAdded:Connect(function()
                task.defer(function()
                    local elements = {}
                    for _, v in pairs(RowFrame:GetChildren()) do
                        if v:IsA("GuiObject") and not v:IsA("UIListLayout") then
                            table.insert(elements, v)
                        end
                    end
                    local count = #elements
                    if count > 0 then
                        local totalPadding = (count - 1) * ES(6)
                        for _, v in pairs(elements) do
                            v.Size = UDim2.new(1/count, -totalPadding/count, 0, v.Size.Y.Offset)
                        end
                    end
                end)
            end)
            Row.Container = RowFrame
            return Row
        end
        
        -- ── SECTION ───────────────────────────────────────────
        function Tab:CreateSection(Name)
            local Holder = Instance.new("Frame")
            Holder.Size                   = UDim2.new(1, 0, 0, ES(20))
            Holder.BackgroundTransparency = 1
            Holder.Parent                 = self.Container
        
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.AutomaticSize        = Enum.AutomaticSize.X
            SectionLabel.Size                 = UDim2.new(0, 0, 1, 0)
            SectionLabel.Position             = UDim2.new(0, 0, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text                 = Name:upper()
            SectionLabel.TextColor3           = T.Accent
            SectionLabel.Font                 = Enum.Font.GothamBold
            SectionLabel.TextSize             = FS(11)
            SectionLabel.TextXAlignment       = Enum.TextXAlignment.Left
            SectionLabel.Parent               = Holder
        
            local Gap = ES(6)
        
            local Line = Instance.new("Frame")
            Line.AnchorPoint            = Vector2.new(1, 0.5)
            Line.Position               = UDim2.new(1, 0, 0.5, 0)
            Line.BackgroundColor3       = T.Accent
            Line.BackgroundTransparency = 0.6
            Line.BorderSizePixel        = 0
            Line.Parent                 = Holder
        
            local function UpdateLine()
                local textWidth   = SectionLabel.AbsoluteSize.X
                local holderWidth = Holder.AbsoluteSize.X
                if holderWidth > 0 and textWidth > 0 then
                    Line.Size = UDim2.new(0, holderWidth - textWidth - Gap, 0, ES(1))
                end
            end
        
            -- Initial calculation once layout resolves
            task.defer(UpdateLine)
        
            -- Recalculate whenever the container or label resizes (UI scale changes etc.)
            Holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLine)
            SectionLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLine)
        end

        -- ── ACTION ────────────────────────────────────────────
        function Tab:CreateAction(Title, ButtonText, Callback, Secure)
            local Element     = {}
            Element.Disabled  = false

            local RowHeight   = ES(28)
            local BtnHeight   = ES(20)
            local BtnWidth    = ES(70)

            local ActionFrame = Instance.new("Frame")
            ActionFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            ActionFrame.BackgroundColor3 = T.Surface
            ActionFrame.Parent           = self.Container
            Corner(ActionFrame)
            AddDepthStroke(ActionFrame)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size            = UDim2.new(0.65, 0, 1, 0)
            TitleLabel.Position        = UDim2.new(0, ES(10), 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text            = Title
            TitleLabel.TextColor3      = T.TextPrimary
            TitleLabel.Font            = Enum.Font.GothamMedium
            TitleLabel.TextSize        = FS(12)
            TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
            TitleLabel.Parent          = ActionFrame

            if Secure then
                local LockBadge = Instance.new("TextLabel")
                LockBadge.Size             = UDim2.new(0, ES(22), 0, ES(14))
                LockBadge.AnchorPoint      = Vector2.new(0, 0.5)
                LockBadge.BackgroundColor3 = Color3.fromRGB(180, 120, 20)
                LockBadge.BackgroundTransparency = 0.3
                LockBadge.Text             = "🔒"
                LockBadge.TextSize         = FS(9)
                LockBadge.Font             = Enum.Font.Gotham
                LockBadge.TextColor3       = Color3.fromRGB(255, 220, 100)
                LockBadge.Parent           = TitleLabel
                Corner(LockBadge, UDim.new(0, 3))
                local function updateBadgePos()
                    LockBadge.Position = UDim2.new(0, TitleLabel.TextBounds.X + 8, 0.5, 0)
                end
                TitleLabel:GetPropertyChangedSignal("TextBounds"):Connect(updateBadgePos)
                updateBadgePos()
            end

            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Size             = UDim2.new(0, BtnWidth, 0, BtnHeight)
            ActionBtn.AnchorPoint      = Vector2.new(1, 0.5)
            ActionBtn.Position         = UDim2.new(1, -ES(8), 0.5, 0)
            ActionBtn.BackgroundColor3 = T.SurfaceDeep
            ActionBtn.Text             = ButtonText
            ActionBtn.TextColor3       = T.TextWhite
            ActionBtn.Font             = Enum.Font.GothamBold
            ActionBtn.TextSize         = FS(11)
            ActionBtn.Parent           = ActionFrame
            Corner(ActionBtn, UDim.new(0, 4))
            AddDepthStroke(ActionBtn)

            local awaitingConfirm = false
            local resetThread     = nil

            local function resetBtn()
                awaitingConfirm = false
                TweenService:Create(ActionBtn, TI_025, {
                    BackgroundColor3 = Element.Disabled and T.Surface or T.SurfaceDeep,
                    TextTransparency = Element.Disabled and 0.5 or 0
                }):Play()
                ActionBtn.Text      = ButtonText
                ActionBtn.TextColor3 = T.TextWhite
            end

            function Element:SetText(NewText)
                ButtonText = NewText
                if not awaitingConfirm then
                    ActionBtn.Text = NewText
                end
            end

            function Element:SetDisabled(State)
                Element.Disabled = State
                ActionBtn.Active = not State
                TweenService:Create(ActionBtn, TI_02, {
                    BackgroundTransparency = State and 0.5 or 0,
                    TextTransparency = State and 0.5 or 0,
                    BackgroundColor3 = State and T.Surface or T.SurfaceDeep
                }):Play()
                if State and awaitingConfirm then
                    if resetThread then task.cancel(resetThread) end
                    resetBtn()
                end
            end

            ActionBtn.MouseButton1Click:Connect(function()
                if Element.Disabled then return end
                if Secure then
                    if not awaitingConfirm then
                        awaitingConfirm = true
                        TweenService:Create(ActionBtn, TI_02, {BackgroundColor3 = T.Warning}):Play()
                        ActionBtn.Text      = "Confirm?"
                        ActionBtn.TextColor3 = Color3.fromRGB(255, 240, 180)
                        if resetThread then task.cancel(resetThread) end
                        resetThread = task.delay(3, resetBtn)
                    else
                        if resetThread then task.cancel(resetThread) end
                        awaitingConfirm = false
                        TweenService:Create(ActionBtn, TI_015, {BackgroundColor3 = T.Success}):Play()
                        ActionBtn.Text      = "✓ Done"
                        ActionBtn.TextColor3 = Color3.fromRGB(200, 255, 210)
                        Callback()
                        task.delay(1.2, resetBtn)
                    end
                else
                    Callback()
                end
            end)

            return AttachTooltip(TitleLabel, Element)
        end

        -- ── TOGGLE ────────────────────────────────────────────────────────────
        function Tab:CreateToggle(Title, Default, Callback)
            local Element        = {}
            local Toggled        = Default
            local toggleDisabled = false
            local RowHeight      = ES(28)

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            ToggleFrame.BackgroundColor3 = T.Surface
            ToggleFrame.Parent           = self.Container
            Corner(ToggleFrame)
            AddDepthStroke(ToggleFrame)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size            = UDim2.new(0.65, 0, 1, 0)
            TitleLabel.Position        = UDim2.new(0, ES(10), 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text            = Title
            TitleLabel.TextColor3      = T.TextPrimary
            TitleLabel.Font            = Enum.Font.GothamMedium
            TitleLabel.TextSize        = FS(12)
            TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
            TitleLabel.Parent          = ToggleFrame

            local ToggleBG = Instance.new("TextButton")
            ToggleBG.Size             = UDim2.new(0, ES(34), 0, ES(18))
            ToggleBG.AnchorPoint      = Vector2.new(1, 0.5)
            ToggleBG.Position         = UDim2.new(1, -ES(8), 0.5, 0)
            ToggleBG.BackgroundColor3 = Toggled and T.Accent or T.SurfaceDeep
            ToggleBG.Text             = ""
            ToggleBG.Parent           = ToggleFrame
            Corner(ToggleBG, UDim.new(1, 0))
            AddDepthStroke(ToggleBG)

            local dotOff = ES(3)
            local dotOn  = ES(34) - ES(15)
            local dotSz  = ES(12)
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Size             = UDim2.new(0, dotSz, 0, dotSz)
            ToggleDot.Position         = Toggled and UDim2.new(0, dotOn, 0.5, -dotSz/2) or UDim2.new(0, dotOff, 0.5, -dotSz/2)
            ToggleDot.BackgroundColor3 = T.TextWhite
            ToggleDot.Parent           = ToggleBG
            Corner(ToggleDot, UDim.new(1, 0))

            local function ApplyVisual(state)
                local targetPos = state and UDim2.new(0, dotOn, 0.5, -dotSz/2) or UDim2.new(0, dotOff, 0.5, -dotSz/2)
                local targetCol = state and T.Accent or T.SurfaceDeep
                TweenService:Create(ToggleDot, TI_02, {Position = targetPos}):Play()
                TweenService:Create(ToggleBG,  TI_02, {BackgroundColor3 = targetCol}):Play()
            end

            ToggleBG.MouseButton1Click:Connect(function()
                if toggleDisabled then return end
                Toggled = not Toggled
                ApplyVisual(Toggled)
                Callback(Toggled)
            end)

            function Element:SetState(state)
                if state == Toggled then return end
                Toggled = state
                ApplyVisual(Toggled)
            end

            function Element:SetDisabled(state)
                toggleDisabled = state
                ToggleBG.Active = not state
                TweenService:Create(ToggleBG, TI_02, {
                    BackgroundTransparency = state and 0.5 or 0,
                    BackgroundColor3       = state and T.Surface or (Toggled and T.Accent or T.SurfaceDeep),
                }):Play()
                TweenService:Create(ToggleDot, TI_02, {
                    BackgroundTransparency = state and 0.5 or 0,
                }):Play()
                TitleLabel.TextColor3 = state and T.TextSecondary or T.TextPrimary
            end

            return AttachTooltip(TitleLabel, Element)
        end

        -- ── IMAGE ─────────────────────────────────────────────────────────
        function Tab:CreateImage(FileName, Height)
            local Element = {}
            local CardH   = ES(Height or 80)

            local ImageFrame = Instance.new("ImageLabel")
            ImageFrame.Size             = UDim2.new(1, 0, 0, CardH)
            ImageFrame.BackgroundColor3 = T.Surface
            ImageFrame.Image            = ""
            ImageFrame.ScaleType        = Enum.ScaleType.Stretch
            ImageFrame.ImageColor3      = Color3.new(1, 1, 1)
            ImageFrame.Parent           = self.Container
            Corner(ImageFrame)

            local StrokeFrame = Instance.new("Frame")
            StrokeFrame.Size                   = UDim2.new(1, 0, 1, 0)
            StrokeFrame.BackgroundTransparency = 1
            StrokeFrame.ZIndex                 = 10
            StrokeFrame.Parent                 = ImageFrame
            Corner(StrokeFrame)
            local Stroke = Instance.new("UIStroke", StrokeFrame)
            Stroke.Color           = T.Stroke
            Stroke.Thickness       = 1
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local function LoadImage(fileName)
                if not fileName or fileName == "" then return end
                task.spawn(function()
                    local localPath = "Dynxe/Images/" .. fileName
                    local asset

                    if isfile and getcustomasset and isfile(localPath) then
                        asset = getcustomasset(localPath)
                    else
                        local url = string.format(
                            "https://raw.githubusercontent.com/%s/%s/%s/Images/%s",
                            User, Repo, Branch, fileName
                        )
                        local ok, content = pcall(function() return game:HttpGet(url) end)
                        if ok and content
                        and not content:find("404: Not Found")
                        and #content > 100 then
                            if isfolder and makefolder and writefile and getcustomasset then
                                if not isfolder("Dynxe")        then makefolder("Dynxe")        end
                                if not isfolder("Dynxe/Images") then makefolder("Dynxe/Images") end
                                writefile(localPath, content)
                                asset = getcustomasset(localPath)
                            end
                        else
                            warn("[CreateImage] Asset missing: " .. fileName)
                        end
                    end

                    if asset then ImageFrame.Image = asset end
                end)
            end

            LoadImage(FileName)

            function Element:SetImage(fileName)   LoadImage(fileName)                                    end
            function Element:SetHeight(pts)       ImageFrame.Size = UDim2.new(1, 0, 0, ES(pts))         end
            function Element:SetImageColor(color) ImageFrame.ImageColor3 = color                        end
            function Element:SetTransparency(v)   ImageFrame.ImageTransparency = math.clamp(v, 0, 1)   end
            function Element:SetVisible(state)    ImageFrame.Visible = state                            end

            return Element
        end
        
    -- ── INPUT ─────────────────────────────────────────────
    function Tab:CreateInput(Title, Placeholder, Callback)
        local Element   = {}
        local RowHeight = ES(28)
        local BoxWidth  = ES(70)
        local BoxHeight = ES(20)
    
        local InputFrame = Instance.new("Frame")
        InputFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
        InputFrame.BackgroundColor3 = T.Surface
        InputFrame.Parent           = self.Container
        Corner(InputFrame)
        AddDepthStroke(InputFrame)
    
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size            = UDim2.new(0.6, 0, 1, 0)
        TitleLabel.Position        = UDim2.new(0, ES(10), 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text            = Title
        TitleLabel.TextColor3      = T.TextPrimary
        TitleLabel.Font            = Enum.Font.GothamMedium
        TitleLabel.TextSize        = FS(12)
        TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
        TitleLabel.Parent          = InputFrame
    
        local InputBox = Instance.new("TextBox")
        InputBox.Name              = "InputBox"
        InputBox.Size              = UDim2.new(0, BoxWidth, 0, BoxHeight)
        InputBox.AnchorPoint       = Vector2.new(1, 0.5)
        InputBox.Position          = UDim2.new(1, -ES(8), 0.5, 0)
        InputBox.BackgroundTransparency = 1
        InputBox.BorderSizePixel   = 0
        InputBox.Text              = ""
        InputBox.PlaceholderText   = Placeholder
        InputBox.PlaceholderColor3 = T.TextSecondary
        InputBox.TextColor3        = T.TextWhite
        InputBox.Font              = Enum.Font.GothamMedium
        InputBox.TextSize          = FS(11)
        InputBox.TextXAlignment    = Enum.TextXAlignment.Right
        InputBox.ClipsDescendants  = true
        InputBox.ClearTextOnFocus  = false
        InputBox.Parent            = InputFrame
    
        local UnderTrack = Instance.new("Frame")
        UnderTrack.Size             = UDim2.new(0, BoxWidth, 0, 1)
        UnderTrack.AnchorPoint      = Vector2.new(1, 0)
        UnderTrack.Position         = UDim2.new(1, -ES(8), 0.5, ES(11))
        UnderTrack.BackgroundColor3 = T.Stroke
        UnderTrack.BorderSizePixel  = 0
        UnderTrack.Parent           = InputFrame
    
        local UnderFill = Instance.new("Frame")
        UnderFill.Size             = UDim2.new(0, 0, 1, 0)
        UnderFill.AnchorPoint      = Vector2.new(0.5, 0)
        UnderFill.Position         = UDim2.new(0.5, 0, 0, 0)
        UnderFill.BackgroundColor3 = T.Accent
        UnderFill.BorderSizePixel  = 0
        UnderFill.Parent           = UnderTrack
    
        InputBox.Focused:Connect(function()
            TweenService:Create(UnderFill, TI_025Q, { Size = UDim2.new(1, 0, 1, 0) }):Play()
        end)
    
        InputBox.FocusLost:Connect(function()
            Callback(InputBox.Text)
            TweenService:Create(UnderFill, TI_025Q, { Size = UDim2.new(0, 0, 1, 0) }):Play()
        end)
    
        function Element:SetText(val)
            InputBox.Text = tostring(val)
        end
    
        function Element:GetText()
            return InputBox.Text
        end
    
        return AttachTooltip(TitleLabel, Element)
    end
            
        -- ── SLIDER ────────────────────────────────────────────────────
        function Tab:CreateSlider(Title, Min, Max, Default, Callback, Decimals)
            Decimals = Decimals or 0

            local Element        = {}
            local sliderDisabled = false
            local RowHeight      = ES(38)

            local function RoundValue(v)
                if Decimals == 0 then
                    return math.floor(v)
                end
                local factor = 10 ^ Decimals
                return math.floor(v * factor + 0.5) / factor
            end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            SliderFrame.BackgroundColor3 = T.Surface
            SliderFrame.Parent           = self.Container
            Corner(SliderFrame)
            AddDepthStroke(SliderFrame)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size            = UDim2.new(1, -ES(70), 0, ES(20))
            TitleLabel.Position        = UDim2.new(0, ES(10), 0, ES(4))
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text            = Title
            TitleLabel.TextColor3      = T.TextPrimary
            TitleLabel.Font            = Enum.Font.GothamMedium
            TitleLabel.TextSize        = FS(12)
            TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
            TitleLabel.Parent          = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size            = UDim2.new(0, ES(55), 0, ES(20))
            ValueLabel.AnchorPoint     = Vector2.new(1, 0)
            ValueLabel.Position        = UDim2.new(1, -ES(8), 0, ES(4))
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text            = tostring(RoundValue(Default))
            ValueLabel.TextColor3      = T.Accent
            ValueLabel.Font            = Enum.Font.GothamBold
            ValueLabel.TextSize        = FS(12)
            ValueLabel.TextXAlignment  = Enum.TextXAlignment.Right
            ValueLabel.Parent          = SliderFrame

            local trackY = ES(28)
            local SliderBG = Instance.new("Frame")
            SliderBG.Size             = UDim2.new(1, -ES(20), 0, ES(4))
            SliderBG.Position         = UDim2.new(0, ES(10), 0, trackY)
            SliderBG.BackgroundColor3 = T.SurfaceDeep
            SliderBG.Parent           = SliderFrame
            Corner(SliderBG)

            local SliderFill = Instance.new("Frame")
            SliderFill.Size             = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = T.Accent
            SliderFill.BorderSizePixel  = 0
            SliderFill.Parent           = SliderBG
            Corner(SliderFill)

            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Size               = UDim2.new(1, 0, 1, 0)
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Text               = ""
            SliderBtn.ZIndex             = SliderFrame.ZIndex + 5
            SliderBtn.Parent             = SliderFrame

            local function UpdateSlider()
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos   = SliderBG.AbsolutePosition.X
                local barWidth = SliderBG.AbsoluteSize.X
                local pct      = math.clamp((mousePos - barPos) / barWidth, 0, 1)
                local value    = RoundValue(Min + (Max - Min) * pct)
                SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                Callback(value)
            end

            function Element:SetValue(value)
                value = math.clamp(RoundValue(value), Min, Max)
                local pct = (value - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                ValueLabel.Text = tostring(value)
            end

            function Element:SetDisabled(state)
                sliderDisabled = state
                TweenService:Create(SliderFill, TI_02, {
                    BackgroundColor3 = state and T.TextSecondary or T.Accent
                }):Play()
                TweenService:Create(SliderBG, TI_02, {
                    BackgroundTransparency = state and 0.5 or 0
                }):Play()
                ValueLabel.TextColor3 = state and T.TextSecondary or T.Accent
                TitleLabel.TextColor3 = state and T.TextSecondary or T.TextPrimary
                SliderBtn.Active      = not state
            end

            local sliding = false
            SliderBtn.InputBegan:Connect(function(input)
                if sliderDisabled then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    UpdateSlider()
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and not sliderDisabled and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider()
                end
            end)

            return AttachTooltip(TitleLabel, Element)
        end

    -- ── RANGE SLIDER ──────────────────────────────────────────────
        -- Like CreateSlider but with two draggable handles so the player
        -- can set both a minimum and maximum value.
        --
        -- Callback signature: Callback(low, high)
        -- Element methods:    Element:SetValue(low, high)
        --                     Element:SetDisabled(bool)
        function Tab:CreateRangeSlider(Title, Min, Max, DefaultLow, DefaultHigh, Callback, Decimals)
            Decimals = Decimals or 0

            local Element        = {}
            local sliderDisabled = false
            local RowHeight      = ES(38)

            -- Clamp and order the defaults so low <= high always
            local currentLow  = math.clamp(DefaultLow,  Min, Max)
            local currentHigh = math.clamp(DefaultHigh, Min, Max)
            if currentLow > currentHigh then
                currentLow, currentHigh = currentHigh, currentLow
            end

            local function RoundValue(v)
                if Decimals == 0 then
                    return math.floor(v)
                end
                local factor = 10 ^ Decimals
                return math.floor(v * factor + 0.5) / factor
            end

            -- ── outer frame ───────────────────────────────────────────
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            SliderFrame.BackgroundColor3 = T.Surface
            SliderFrame.Parent           = self.Container
            Corner(SliderFrame)
            AddDepthStroke(SliderFrame)

            -- ── title ─────────────────────────────────────────────────
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size                   = UDim2.new(1, -ES(110), 0, ES(20))
            TitleLabel.Position               = UDim2.new(0, ES(10), 0, ES(4))
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text                   = Title
            TitleLabel.TextColor3             = T.TextPrimary
            TitleLabel.Font                   = Enum.Font.GothamMedium
            TitleLabel.TextSize               = FS(12)
            TitleLabel.TextXAlignment         = Enum.TextXAlignment.Left
            TitleLabel.Parent                 = SliderFrame

            -- ── value label: shows "low — high" ───────────────────────
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size                   = UDim2.new(0, ES(100), 0, ES(20))
            ValueLabel.AnchorPoint            = Vector2.new(1, 0)
            ValueLabel.Position               = UDim2.new(1, -ES(8), 0, ES(4))
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3             = T.Accent
            ValueLabel.Font                   = Enum.Font.GothamBold
            ValueLabel.TextSize               = FS(12)
            ValueLabel.TextXAlignment         = Enum.TextXAlignment.Right
            ValueLabel.Parent                 = SliderFrame

            -- ── track background ──────────────────────────────────────
            local trackY  = ES(28)
            local SliderBG = Instance.new("Frame")
            SliderBG.Size             = UDim2.new(1, -ES(20), 0, ES(4))
            SliderBG.Position         = UDim2.new(0, ES(10), 0, trackY)
            SliderBG.BackgroundColor3 = T.SurfaceDeep
            SliderBG.ClipsDescendants = false   -- let handles poke out above/below
            SliderBG.Parent           = SliderFrame
            Corner(SliderBG)

            -- ── range fill (sits between the two handles) ─────────────
            local SliderFill = Instance.new("Frame")
            SliderFill.BackgroundColor3 = T.Accent
            SliderFill.BorderSizePixel  = 0
            SliderFill.ZIndex           = SliderBG.ZIndex + 1
            SliderFill.Parent           = SliderBG
            Corner(SliderFill)

            -- ── handle knobs ──────────────────────────────────────────
            -- Small circles centred vertically on the track so it is
            -- visually obvious that both ends are independently draggable.
            local KNOB_SIZE = ES(8)

            local function MakeKnob(zIndex)
                local k = Instance.new("Frame")
                k.Size             = UDim2.new(0, KNOB_SIZE, 0, KNOB_SIZE)
                k.AnchorPoint      = Vector2.new(0.5, 0.5)
                k.Position         = UDim2.new(0, 0, 0.5, 0)
                k.BackgroundColor3 = T.Accent
                k.BorderSizePixel  = 0
                k.ZIndex           = zIndex
                k.Parent           = SliderBG
                Corner(k)   -- makes it a circle when width == height
                return k
            end

            local KnobLow  = MakeKnob(SliderBG.ZIndex + 3)
            local KnobHigh = MakeKnob(SliderBG.ZIndex + 3)

            -- ── invisible full-frame capture button ───────────────────
            -- Spans the whole SliderFrame (not just the track) so the
            -- click target is generous and easier to hit.
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Size               = UDim2.new(1, 0, 1, 0)
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Text               = ""
            SliderBtn.ZIndex             = SliderFrame.ZIndex + 5
            SliderBtn.Parent             = SliderFrame

            -- ── layout helper ─────────────────────────────────────────
            local function UpdateVisuals()
                local lowPct  = (currentLow  - Min) / (Max - Min)
                local highPct = (currentHigh - Min) / (Max - Min)

                -- Fill between the two handles
                SliderFill.Position = UDim2.new(lowPct,  0, 0, 0)
                SliderFill.Size     = UDim2.new(highPct - lowPct, 0, 1, 0)

                -- Knobs sit at the ends of the fill
                KnobLow.Position  = UDim2.new(lowPct,  0, 0.5, 0)
                KnobHigh.Position = UDim2.new(highPct, 0, 0.5, 0)

                -- Value readout
                ValueLabel.Text = tostring(RoundValue(currentLow))
                    .. " — "
                    .. tostring(RoundValue(currentHigh))
            end

            UpdateVisuals()

            -- ── drag logic ────────────────────────────────────────────
            -- `dragging` tracks which handle the mouse grabbed:
            --   nil = not dragging, "low" = left handle, "high" = right handle
            local dragging = nil

            local function PctFromMouse()
                local mx       = UserInputService:GetMouseLocation().X
                local barLeft  = SliderBG.AbsolutePosition.X
                local barWidth = SliderBG.AbsoluteSize.X
                return math.clamp((mx - barLeft) / barWidth, 0, 1)
            end

            SliderBtn.InputBegan:Connect(function(input)
                if sliderDisabled then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                local pct     = PctFromMouse()
                local lowPct  = (currentLow  - Min) / (Max - Min)
                local highPct = (currentHigh - Min) / (Max - Min)

                -- Grab whichever handle is closer to the click
                if math.abs(pct - lowPct) <= math.abs(pct - highPct) then
                    dragging = "low"
                else
                    dragging = "high"
                end

                -- Apply immediately so a click without drag still works
                local value = RoundValue(Min + (Max - Min) * pct)
                if dragging == "low" then
                    currentLow = math.min(value, currentHigh)
                else
                    currentHigh = math.max(value, currentLow)
                end
                UpdateVisuals()
                Callback(currentLow, currentHigh)
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = nil
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not dragging or sliderDisabled then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

                local value = RoundValue(Min + (Max - Min) * PctFromMouse())

                if dragging == "low" then
                    -- Low handle cannot cross above the high handle
                    currentLow = math.clamp(value, Min, currentHigh)
                else
                    -- High handle cannot cross below the low handle
                    currentHigh = math.clamp(value, currentLow, Max)
                end
                UpdateVisuals()
                Callback(currentLow, currentHigh)
            end)

            -- ── public API ────────────────────────────────────────────
            function Element:SetValue(low, high)
                currentLow  = math.clamp(RoundValue(low),  Min, Max)
                currentHigh = math.clamp(RoundValue(high), Min, Max)
                if currentLow > currentHigh then
                    currentLow, currentHigh = currentHigh, currentLow
                end
                UpdateVisuals()
            end

            function Element:SetDisabled(state)
                sliderDisabled = state

                local fillColor = state and T.TextSecondary or T.Accent
                TweenService:Create(SliderFill, TI_02, { BackgroundColor3 = fillColor }):Play()
                TweenService:Create(KnobLow,   TI_02, { BackgroundColor3 = fillColor }):Play()
                TweenService:Create(KnobHigh,  TI_02, { BackgroundColor3 = fillColor }):Play()
                TweenService:Create(SliderBG,  TI_02, {
                    BackgroundTransparency = state and 0.5 or 0
                }):Play()

                ValueLabel.TextColor3 = state and T.TextSecondary or T.Accent
                TitleLabel.TextColor3 = state and T.TextSecondary or T.TextPrimary
                SliderBtn.Active      = not state
            end

            return AttachTooltip(TitleLabel, Element)
        end
        
        -- ── KEYBIND ───────────────────────────────────────────
        function Tab:CreateKeybind(Title, Default, Callback)
            local Element   = {}
            local KeyName   = (typeof(Default) == "EnumItem") and Default.Name or Default.UserInputType.Name
            local RowHeight = ES(28)

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            KeybindFrame.BackgroundColor3 = T.Surface
            KeybindFrame.Parent           = self.Container
            Corner(KeybindFrame)
            AddDepthStroke(KeybindFrame)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size            = UDim2.new(0.65, 0, 1, 0)
            TitleLabel.Position        = UDim2.new(0, ES(10), 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text            = Title
            TitleLabel.TextColor3      = T.TextPrimary
            TitleLabel.Font            = Enum.Font.GothamMedium
            TitleLabel.TextSize        = FS(12)
            TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
            TitleLabel.Parent          = KeybindFrame

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size             = UDim2.new(0, ES(70), 0, ES(20))
            BindBtn.AnchorPoint      = Vector2.new(1, 0.5)
            BindBtn.Position         = UDim2.new(1, -ES(8), 0.5, 0)
            BindBtn.BackgroundColor3 = T.SurfaceDeep
            BindBtn.Text             = KeyName
            BindBtn.TextColor3       = T.TextWhite
            BindBtn.Font             = Enum.Font.GothamBold
            BindBtn.TextSize         = FS(11)
            BindBtn.Parent           = KeybindFrame
            Corner(BindBtn, UDim.new(0, 4))
            AddDepthStroke(BindBtn)

            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        KeyName = input.KeyCode.Name; BindBtn.Text = KeyName; conn:Disconnect()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                        KeyName = input.UserInputType.Name; BindBtn.Text = KeyName; conn:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(input, processed)
                if not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == KeyName then
                        Callback()
                    elseif input.UserInputType.Name == KeyName then
                        Callback()
                    end
                end
            end)

            return AttachTooltip(TitleLabel, Element)
        end

        -- ── INFO BOX (v2) ─────────────────────────────────────────────
        function Tab:CreateInfoBox()
            local InfoBox    = {}
            local layoutOrder = 0

            local Card = Instance.new("Frame")
            Card.Name             = "InfoBox"
            Card.Size             = UDim2.new(1, 0, 0, 0)
            Card.AutomaticSize    = Enum.AutomaticSize.Y
            Card.BackgroundColor3 = T.Surface
            Card.BorderSizePixel  = 0
            Card.ClipsDescendants = false
            Card.Parent           = self.Container
            Corner(Card)
            AddDepthStroke(Card)

            local Inner = Instance.new("Frame")
            Inner.Name                = "Inner"
            Inner.Size                = UDim2.new(1, 0, 0, 0)
            Inner.AutomaticSize       = Enum.AutomaticSize.Y
            Inner.BackgroundTransparency = 1
            Inner.Parent              = Card

            local InnerPad = Instance.new("UIPadding", Inner)
            InnerPad.PaddingLeft   = UDim.new(0, ES(10))
            InnerPad.PaddingRight  = UDim.new(0, ES(10))
            InnerPad.PaddingTop    = UDim.new(0, ES(6))
            InnerPad.PaddingBottom = UDim.new(0, ES(6))

            local InnerLayout = Instance.new("UIListLayout", Inner)
            InnerLayout.SortOrder     = Enum.SortOrder.LayoutOrder
            InnerLayout.FillDirection = Enum.FillDirection.Vertical
            InnerLayout.Padding       = UDim.new(0, ES(3))

            function InfoBox:AddText(content, opts)
                opts = opts or {}
                layoutOrder = layoutOrder + 1

                local resolvedFont = opts.Font or Enum.Font.Gotham
                if opts.Bold then resolvedFont = Enum.Font.GothamBold end

                local resolvedContent = tostring(content or "")
                local useRichText     = opts.RichText or false
                if opts.Italic then
                    resolvedContent = "<i>" .. resolvedContent .. "</i>"
                    useRichText     = true
                end

                local useTruncate = opts.Truncate or Enum.TextTruncate.None
                local useWrap     = (opts.Wrap ~= false)
                if useTruncate ~= Enum.TextTruncate.None then
                    useWrap = false
                end

                local Label = Instance.new("TextLabel")
                Label.Name                = "InfoText_" .. layoutOrder
                Label.LayoutOrder         = layoutOrder
                Label.Size                = UDim2.new(1, 0, 0, 0)
                Label.AutomaticSize       = Enum.AutomaticSize.Y
                Label.BackgroundTransparency = 1
                Label.Text                = resolvedContent
                Label.Font                = resolvedFont
                Label.TextSize            = FS(opts.Size or 12)
                Label.TextColor3          = opts.Color or T.TextPrimary
                Label.TextXAlignment      = opts.XAlignment or Enum.TextXAlignment.Left
                Label.TextYAlignment      = opts.YAlignment or Enum.TextYAlignment.Center
                Label.TextWrapped         = useWrap
                Label.TextTruncate        = useTruncate
                Label.RichText            = useRichText
                Label.Rotation            = opts.Rotation or 0
                Label.TextTransparency    = opts.Opacity ~= nil and (1 - opts.Opacity) or 0
                Label.Parent              = Inner

                if opts.PaddingTop or opts.PaddingBottom or opts.PaddingLeft or opts.PaddingRight then
                    local Pad = Instance.new("UIPadding", Label)
                    Pad.PaddingTop    = UDim.new(0, ES(opts.PaddingTop    or 0))
                    Pad.PaddingBottom = UDim.new(0, ES(opts.PaddingBottom or 0))
                    Pad.PaddingLeft   = UDim.new(0, ES(opts.PaddingLeft   or 0))
                    Pad.PaddingRight  = UDim.new(0, ES(opts.PaddingRight  or 0))
                end

                local Handle = {}

                function Handle:Set(text)
                    local str = tostring(text)
                    if opts.Italic then str = "<i>" .. str .. "</i>" end
                    Label.Text = str
                end

                function Handle:SetColor(color)    Label.TextColor3     = color                            end
                function Handle:SetSize(pts)        Label.TextSize       = FS(pts)                         end
                function Handle:SetFont(font)       Label.Font           = font                            end
                function Handle:SetRotation(deg)    Label.Rotation       = deg                             end
                function Handle:SetOpacity(value)   Label.TextTransparency = 1 - math.clamp(value, 0, 1)  end
                function Handle:SetXAlignment(a)    Label.TextXAlignment = a                               end
                function Handle:SetYAlignment(a)    Label.TextYAlignment = a                               end
                function Handle:SetWrap(state)      Label.TextWrapped    = state                           end
                function Handle:SetRichText(state)  Label.RichText       = state                           end
                function Handle:SetVisible(state)   Label.Visible        = state                           end
                function Handle:Destroy()           Label:Destroy()                                        end

                function Handle:SetTruncate(mode)
                    Label.TextTruncate = mode
                    if mode ~= Enum.TextTruncate.None then
                        Label.TextWrapped = false
                    end
                end

                function Handle:SetPadding(top, bottom, left, right)
                    local pad = Label:FindFirstChildOfClass("UIPadding")
                    if not pad then pad = Instance.new("UIPadding", Label) end
                    pad.PaddingTop    = UDim.new(0, ES(top    or 0))
                    pad.PaddingBottom = UDim.new(0, ES(bottom or 0))
                    pad.PaddingLeft   = UDim.new(0, ES(left   or 0))
                    pad.PaddingRight  = UDim.new(0, ES(right  or 0))
                end

                function Handle:Tween(props, duration, style, direction)
                    TweenService:Create(
                        Label,
                        TweenInfo.new(
                            duration  or 0.25,
                            style     or Enum.EasingStyle.Quad,
                            direction or Enum.EasingDirection.Out
                        ),
                        props
                    ):Play()
                end

                return Handle
            end

            function InfoBox:AddDivider(color, thickness)
                layoutOrder = layoutOrder + 1
                local Line = Instance.new("Frame")
                Line.LayoutOrder        = layoutOrder
                Line.Size               = UDim2.new(1, 0, 0, math.max(1, thickness or 1))
                Line.BackgroundColor3   = color or T.Stroke
                Line.BorderSizePixel    = 0
                Line.Parent             = Inner
            end

            function InfoBox:AddSpacer(height)
                layoutOrder = layoutOrder + 1
                local Gap = Instance.new("Frame")
                Gap.LayoutOrder            = layoutOrder
                Gap.Size                   = UDim2.new(1, 0, 0, ES(height or 4))
                Gap.BackgroundTransparency = 1
                Gap.Parent                 = Inner
            end

            function InfoBox:SetPadding(top, bottom, left, right)
                InnerPad.PaddingTop    = UDim.new(0, ES(top    or 6))
                InnerPad.PaddingBottom = UDim.new(0, ES(bottom or 6))
                InnerPad.PaddingLeft   = UDim.new(0, ES(left   or 10))
                InnerPad.PaddingRight  = UDim.new(0, ES(right  or 10))
            end

            function InfoBox:SetSpacing(pts)
                InnerLayout.Padding = UDim.new(0, ES(pts))
            end

            function InfoBox:SetBackground(color)
                Card.BackgroundColor3 = color
            end

            function InfoBox:SetStroke(color, thickness)
                local stroke = Card:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color     = color     or T.Stroke
                    stroke.Thickness = thickness or 1
                end
            end

            return InfoBox
        end

        -- ── IMAGE SELECTOR ────────────────────────────────────
        function Tab:CreateImageSelector(Title, Config2, Callback)
            local Element = {Selected = {}}
            Config2 = Config2 or {}
            local Multi       = Config2.MultiSelect or false
            local SlotSize    = Config2.SlotSize or UDim2.new(0, ES(70), 0, ES(70))
            local VisibleRows = Config2.VisibleRows or 2

            local SCROLLBAR_W   = 4
            local FADE_H        = ES(16)
            local TopPadding    = ES(35)
            local BottomPadding = ES(10)
            local CellPaddingX  = ES(8)
            local CellPaddingY  = ES(8)
            local ScrollHeight  = (SlotSize.Y.Offset * VisibleRows)
                                + (CellPaddingY * (VisibleRows - 1))
                                + 6
            local TotalHeight   = TopPadding + ScrollHeight + BottomPadding

            local CLIP_WIDTH = SlotSize.X.Offset - ES(6)

            local SlotRegistry = {}

            local SelectorFrame = Instance.new("Frame")
            SelectorFrame.Name             = Title .. "_ImageSelector"
            SelectorFrame.Size             = UDim2.new(1, 0, 0, TotalHeight)
            SelectorFrame.BackgroundColor3 = T.Surface
            SelectorFrame.Parent           = self.Container
            Corner(SelectorFrame)

            local FrameStroke = Instance.new("UIStroke", SelectorFrame)
            FrameStroke.Color     = T.Stroke
            FrameStroke.Thickness = 1

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size                   = UDim2.new(0.5, 0, 0, ES(20))
            TitleLabel.Position               = UDim2.new(0, ES(10), 0, ES(8))
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text                   = Title
            TitleLabel.TextColor3             = T.TextPrimary
            TitleLabel.Font                   = Enum.Font.GothamMedium
            TitleLabel.TextSize               = FS(13)
            TitleLabel.TextXAlignment         = Enum.TextXAlignment.Left
            TitleLabel.Parent                 = SelectorFrame
    
            local SearchBox = Instance.new("TextBox")
            SearchBox.Name              = "SearchBox"
            SearchBox.Size              = UDim2.new(0, ES(150), 0, ES(20))
            SearchBox.AnchorPoint       = Vector2.new(1, 0)
            SearchBox.Position          = UDim2.new(1, -ES(10), 0, ES(8))
            SearchBox.BackgroundTransparency = 1
            SearchBox.BorderSizePixel   = 0
            SearchBox.PlaceholderText   = "Search…"
            SearchBox.PlaceholderColor3 = T.TextSecondary
            SearchBox.Text              = ""
            SearchBox.TextColor3        = T.TextWhite
            SearchBox.TextXAlignment    = Enum.TextXAlignment.Right
            SearchBox.Font              = Enum.Font.Gotham
            SearchBox.TextSize          = FS(11)
            SearchBox.ClearTextOnFocus  = false
            SearchBox.ClipsDescendants  = true
            SearchBox.Parent            = SelectorFrame
            
            local SearchPad = Instance.new("UIPadding", SearchBox)
            SearchPad.PaddingLeft  = UDim.new(0, ES(6))
            SearchPad.PaddingRight = UDim.new(0, ES(6))
            
            local SearchUnderTrack = Instance.new("Frame")
            SearchUnderTrack.Size             = UDim2.new(0, ES(150), 0, 1)
            SearchUnderTrack.AnchorPoint      = Vector2.new(1, 0)
            SearchUnderTrack.Position         = UDim2.new(1, -ES(10), 0, ES(28))
            SearchUnderTrack.BackgroundColor3 = T.Stroke
            SearchUnderTrack.BorderSizePixel  = 0
            SearchUnderTrack.Parent           = SelectorFrame
            
            local SearchUnderFill = Instance.new("Frame")
            SearchUnderFill.Size             = UDim2.new(0, 0, 1, 0)
            SearchUnderFill.AnchorPoint      = Vector2.new(0.5, 0)
            SearchUnderFill.Position         = UDim2.new(0.5, 0, 0, 0)
            SearchUnderFill.BackgroundColor3 = T.Accent
            SearchUnderFill.BorderSizePixel  = 0
            SearchUnderFill.Parent           = SearchUnderTrack
            
            SearchBox.Focused:Connect(function()
                TweenService:Create(SearchUnderFill, TI_025Q, { Size = UDim2.new(1, 0, 1, 0) }):Play()
            end)
            SearchBox.FocusLost:Connect(function()
                TweenService:Create(SearchUnderFill, TI_025Q, { Size = UDim2.new(0, 0, 1, 0) }):Play()
            end)

            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size                       = UDim2.new(1, -ES(20), 0, ScrollHeight)
            Scroll.Position                   = UDim2.new(0, ES(10), 0, TopPadding)
            Scroll.BackgroundTransparency     = 1
            Scroll.BorderSizePixel            = 0
            Scroll.CanvasSize                 = UDim2.new(0, 0, 0, 0)
            Scroll.ScrollBarThickness         = SCROLLBAR_W
            Scroll.ScrollBarImageColor3       = T.Accent
            Scroll.ScrollBarImageTransparency = 0
            Scroll.ScrollingDirection         = Enum.ScrollingDirection.Y
            Scroll.ClipsDescendants           = true
            Scroll.Parent                     = SelectorFrame

            local Layout = Instance.new("UIGridLayout", Scroll)
            Layout.CellSize            = SlotSize
            Layout.CellPadding         = UDim2.new(0, CellPaddingX, 0, CellPaddingY)
            Layout.SortOrder           = Enum.SortOrder.LayoutOrder
            Layout.FillDirection       = Enum.FillDirection.Horizontal
            Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            Layout.VerticalAlignment   = Enum.VerticalAlignment.Top

            local Padding = Instance.new("UIPadding", Scroll)
            Padding.PaddingLeft   = UDim.new(0, 2)
            Padding.PaddingTop    = UDim.new(0, ES(3))
            Padding.PaddingBottom = UDim.new(0, ES(3))
            Padding.PaddingRight  = UDim.new(0, SCROLLBAR_W + 2)

            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + ES(6))
            end)

            local FADE_W_OFFSET = -ES(20) - SCROLLBAR_W - 2
            
            local ScrollbarTrack = Instance.new("Frame")
            ScrollbarTrack.Size             = UDim2.new(0, 1, 0, ScrollHeight - ES(6))
            ScrollbarTrack.AnchorPoint      = Vector2.new(0.5, 0)
            ScrollbarTrack.Position         = UDim2.new(1, -ES(12), 0, TopPadding + ES(3))
            ScrollbarTrack.BackgroundColor3 = T.Stroke
            ScrollbarTrack.BorderSizePixel  = 0
            ScrollbarTrack.Parent           = SelectorFrame
            
            local function MakeVerticalFade(isBottom)
                local Fade = Instance.new("Frame")
                Fade.Size                   = UDim2.new(1, FADE_W_OFFSET, 0, FADE_H)
                Fade.AnchorPoint            = Vector2.new(0, isBottom and 1 or 0)
                Fade.Position               = UDim2.new(0, ES(10), 0,
                    isBottom and (TopPadding + ScrollHeight) or TopPadding)
                Fade.BackgroundColor3       = T.Surface
                Fade.BackgroundTransparency = 0
                Fade.BorderSizePixel        = 0
                Fade.ZIndex                 = 5
                Fade.Parent                 = SelectorFrame
                local Grad = Instance.new("UIGradient", Fade)
                Grad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
                Grad.Rotation = isBottom and 270 or 90
            end

            MakeVerticalFade(false)
            MakeVerticalFade(true)

            local function ApplySearch(query)
                query = query:lower():gsub("^%s+", ""):gsub("%s+$", "")
                for _, entry in ipairs(SlotRegistry) do
                    entry.slot.Visible = query == ""
                        or entry.title:lower():find(query, 1, true) ~= nil
                end
                task.defer(function()
                    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + ES(6))
                end)
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                ApplySearch(SearchBox.Text)
            end)

            function Element:AddSlot(ID, SlotTitle, SlotSubText)
                local SlotObj = { _enabled = true }

                local Slot = Instance.new("TextButton")
                Slot.BackgroundColor3 = T.SurfaceDeep
                Slot.Text             = ""
                Slot.ZIndex           = 2
                Slot.Parent           = Scroll
                Corner(Slot)

                local Stroke = Instance.new("UIStroke", Slot)
                Stroke.Color           = T.Stroke
                Stroke.Thickness       = 1.2
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                local DisabledOverlay = Instance.new("Frame")
                DisabledOverlay.Name                  = "DisabledOverlay"
                DisabledOverlay.Size                  = UDim2.new(1, 0, 1, 0)
                DisabledOverlay.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
                DisabledOverlay.BackgroundTransparency = 0.6
                DisabledOverlay.BorderSizePixel        = 0
                DisabledOverlay.ZIndex                 = 10
                DisabledOverlay.Visible                = false
                DisabledOverlay.Parent                 = Slot
                Corner(DisabledOverlay)

                local Image = Instance.new("ImageLabel")
                Image.Size                   = UDim2.new(0.75, 0, 0.75, 0)
                Image.Position               = UDim2.new(0.5, 0, 0.5, 0)
                Image.AnchorPoint            = Vector2.new(0.5, 0.5)
                Image.BackgroundTransparency = 1
                Image.Image                  = ID
                Image.ZIndex                 = 2
                Image.Parent                 = Slot

                if SlotTitle or SlotSubText then
                    Image.Position = UDim2.new(0.5, 0, 0.35, 0)
                    Image.Size     = UDim2.new(0.55, 0, 0.55, 0)
                end

                local TitleFades = {}

                if SlotTitle then
                    local TitleClip = Instance.new("Frame")
                    TitleClip.Size                   = UDim2.new(1, -ES(6), 0, FS(13))
                    TitleClip.Position               = UDim2.new(0, ES(3), 0.65, 0)
                    TitleClip.BackgroundTransparency = 1
                    TitleClip.ClipsDescendants       = true
                    TitleClip.ZIndex                 = 2
                    TitleClip.Parent                 = Slot

                    local textW = TextService:GetTextSize(
                        SlotTitle,
                        FS(10),
                        Enum.Font.GothamMedium,
                        Vector2.new(math.huge, math.huge)
                    ).X

                    if textW <= CLIP_WIDTH then
                        local Txt = Instance.new("TextLabel")
                        Txt.Size                   = UDim2.new(1, 0, 1, 0)
                        Txt.BackgroundTransparency = 1
                        Txt.Text                   = SlotTitle
                        Txt.TextColor3             = T.TextPrimary
                        Txt.Font                   = Enum.Font.GothamMedium
                        Txt.TextSize               = FS(10)
                        Txt.ZIndex                 = 2
                        Txt.Parent                 = TitleClip
                    else
                        local GAP    = ES(18)
                        local totalW = textW + GAP

                        local Scroller = Instance.new("Frame")
                        Scroller.Size                   = UDim2.new(0, totalW * 2, 1, 0)
                        Scroller.Position               = UDim2.new(0, 0, 0, 0)
                        Scroller.BackgroundTransparency = 1
                        Scroller.ZIndex                 = 2
                        Scroller.Parent                 = TitleClip

                        for i = 0, 1 do
                            local Lbl = Instance.new("TextLabel")
                            Lbl.Size                   = UDim2.new(0, textW, 1, 0)
                            Lbl.Position               = UDim2.new(0, i * totalW, 0, 0)
                            Lbl.BackgroundTransparency = 1
                            Lbl.Text                   = SlotTitle
                            Lbl.TextColor3             = T.TextPrimary
                            Lbl.Font                   = Enum.Font.GothamMedium
                            Lbl.TextSize               = FS(10)
                            Lbl.TextXAlignment         = Enum.TextXAlignment.Left
                            Lbl.ZIndex                 = 2
                            Lbl.Parent                 = Scroller
                        end

                        local TITLE_FADE_W = ES(10)
                        local function MakeTitleFade(anchorX, posX, rotated)
                            local F = Instance.new("Frame")
                            F.Size             = UDim2.new(0, TITLE_FADE_W, 1, 0)
                            F.AnchorPoint      = Vector2.new(anchorX, 0)
                            F.Position         = UDim2.new(posX, 0, 0, 0)
                            F.BackgroundColor3 = T.SurfaceDeep
                            F.BorderSizePixel  = 0
                            F.ZIndex           = 4
                            F.Parent           = TitleClip
                            local G = Instance.new("UIGradient", F)
                            G.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(1, 1),
                            })
                            if rotated then G.Rotation = 180 end
                            table.insert(TitleFades, F)
                        end
                        MakeTitleFade(0, 0, false)
                        MakeTitleFade(1, 1, true)

                        local scrollDuration = totalW / 28
                        task.spawn(function()
                            task.wait(1.2)
                            while Slot.Parent do
                                local tween = TweenService:Create(
                                    Scroller,
                                    TweenInfo.new(scrollDuration, Enum.EasingStyle.Linear),
                                    { Position = UDim2.new(0, -totalW, 0, 0) }
                                )
                                tween:Play()
                                tween.Completed:Wait()
                                if not Slot.Parent then break end
                                Scroller.Position = UDim2.new(0, 0, 0, 0)
                            end
                        end)
                    end
                end

                if SlotSubText then
                    local SubTxt = Instance.new("TextLabel")
                    SubTxt.Size                   = UDim2.new(1, 0, 0, FS(12))
                    SubTxt.Position               = UDim2.new(0, 0, 0.82, 0)
                    SubTxt.BackgroundTransparency = 1
                    SubTxt.Text                   = SlotSubText
                    SubTxt.TextColor3             = T.Success
                    SubTxt.Font                   = Enum.Font.GothamBold
                    SubTxt.TextSize               = FS(9)
                    SubTxt.ZIndex                 = 2
                    SubTxt.Parent                 = Slot
                end

                local registryEntry = {
                    slot       = Slot,
                    title      = SlotTitle or "",
                    titleFades = TitleFades,
                }
                table.insert(SlotRegistry, registryEntry)

                Slot.MouseButton1Click:Connect(function()
                    if not SlotObj._enabled then return end

                    local isSelected = (Slot.BackgroundColor3 == T.Accent)

                    if not Multi then
                        for _, entry in ipairs(SlotRegistry) do
                            if entry.slot ~= Slot then
                                TweenService:Create(entry.slot, TI_02, {BackgroundColor3 = T.SurfaceDeep}):Play()
                                local s = entry.slot:FindFirstChildOfClass("UIStroke")
                                if s then s.Color = T.Stroke end
                                for _, fade in ipairs(entry.titleFades) do
                                    TweenService:Create(fade, TI_02, {BackgroundColor3 = T.SurfaceDeep}):Play()
                                end
                            end
                        end
                        Element.Selected = {SlotTitle or ID}
                    else
                        if isSelected then
                            for i, v in ipairs(Element.Selected) do
                                if v == (SlotTitle or ID) then
                                    table.remove(Element.Selected, i)
                                    break
                                end
                            end
                        else
                            table.insert(Element.Selected, SlotTitle or ID)
                        end
                    end

                    local targetColor = isSelected and T.SurfaceDeep or T.Accent
                    local strokeColor = isSelected and T.Stroke      or T.TextWhite

                    TweenService:Create(Slot, TI_02, {BackgroundColor3 = targetColor}):Play()
                    Stroke.Color = strokeColor

                    for _, fade in ipairs(TitleFades) do
                        TweenService:Create(fade, TI_02, {BackgroundColor3 = targetColor}):Play()
                    end

                    Callback(Multi and Element.Selected or Element.Selected[1])
                end)

                function SlotObj:SetEnabled(enabled)
                    self._enabled = enabled
                    DisabledOverlay.Visible = not enabled
                    if not enabled and Slot.BackgroundColor3 == T.Accent then
                        TweenService:Create(Slot, TI_02, {BackgroundColor3 = T.SurfaceDeep}):Play()
                        Stroke.Color = T.Stroke
                        for _, fade in ipairs(TitleFades) do
                            TweenService:Create(fade, TI_02, {BackgroundColor3 = T.SurfaceDeep}):Play()
                        end
                        for i, v in ipairs(Element.Selected) do
                            if v == (SlotTitle or ID) then
                                table.remove(Element.Selected, i)
                                break
                            end
                        end
                        Callback(Multi and Element.Selected or Element.Selected[1])
                    end
                end

                ApplySearch(SearchBox.Text)

                return SlotObj
            end

            return Element
        end

        -- ── DROPDOWN ──────────────────────────────────────────────────────
        function Tab:CreateDropdown(Title, Options, Default, Callback)
            local Element      = {}
            local dropDisabled    = false
            local disabledOptions = {}   -- [optName] = true when that option is grayed out
            local optionOverlays  = {}   -- [optName] = overlay Frame, rebuilt on each Refresh
            local RowHeight    = ES(28)
            local OptHeight    = ES(22)

            local function IsColorMode(opts)
                if not opts or #opts == 0 then return false end
                local first = opts[1]
                return typeof(first) == "Color3"
                    or (type(first) == "table" and typeof(first.Color) == "Color3")
            end

            local colorMode = IsColorMode(Options)

            local function Normalise(opt)
                if not colorMode then return opt end
                if typeof(opt) == "Color3" then return { Name = "", Color = opt } end
                return opt
            end

            local Selected = Default and Normalise(Default) or (Options[1] and Normalise(Options[1]))

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size             = UDim2.new(1, 0, 0, RowHeight)
            DropdownFrame.BackgroundColor3 = T.Surface
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent           = self.Container
            Corner(DropdownFrame)
            AddDepthStroke(DropdownFrame)

            local Header = Instance.new("TextButton")
            Header.Size                   = UDim2.new(1, 0, 0, RowHeight)
            Header.BackgroundTransparency = 1
            Header.Text                   = ""
            Header.Parent                 = DropdownFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size            = UDim2.new(0.6, 0, 1, 0)
            TitleLabel.Position        = UDim2.new(0, ES(10), 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text            = Title
            TitleLabel.TextColor3      = T.TextPrimary
            TitleLabel.Font            = Enum.Font.GothamMedium
            TitleLabel.TextSize        = FS(12)
            TitleLabel.TextXAlignment  = Enum.TextXAlignment.Left
            TitleLabel.Parent          = Header

            local SelectedLabel  = nil
            local SelectedSwatch = nil
            local SelectedName   = nil

            if colorMode then
                SelectedSwatch = Instance.new("Frame")
                SelectedSwatch.Size             = UDim2.new(0, ES(14), 0, ES(14))
                SelectedSwatch.AnchorPoint      = Vector2.new(1, 0.5)
                SelectedSwatch.Position         = UDim2.new(1, -ES(10), 0.5, 0)
                SelectedSwatch.BorderSizePixel  = 0
                SelectedSwatch.BackgroundColor3 = (Selected and Selected.Color) or Color3.new(1,1,1)
                SelectedSwatch.Parent           = Header
                Corner(SelectedSwatch, UDim.new(0, 3))
                local SwStroke = Instance.new("UIStroke", SelectedSwatch)
                SwStroke.Color = T.Stroke; SwStroke.Thickness = 1

                SelectedName = Instance.new("TextLabel")
                SelectedName.Size            = UDim2.new(0.35, 0, 1, 0)
                SelectedName.AnchorPoint     = Vector2.new(1, 0)
                SelectedName.Position        = UDim2.new(1, -ES(30), 0, 0)
                SelectedName.BackgroundTransparency = 1
                SelectedName.Text            = (Selected and Selected.Name) or ""
                SelectedName.TextColor3      = T.Accent
                SelectedName.Font            = Enum.Font.GothamBold
                SelectedName.TextSize        = FS(11)
                SelectedName.TextXAlignment  = Enum.TextXAlignment.Right
                SelectedName.TextTruncate    = Enum.TextTruncate.AtEnd
                SelectedName.Parent          = Header
            else
                SelectedLabel = Instance.new("TextLabel")
                SelectedLabel.Size            = UDim2.new(0.4, -25, 1, 0)
                SelectedLabel.Position        = UDim2.new(1, -10, 0, 0)
                SelectedLabel.AnchorPoint     = Vector2.new(1, 0)
                SelectedLabel.BackgroundTransparency = 1
                SelectedLabel.Text            = (type(Selected) == "string" and Selected) or "Select..."
                SelectedLabel.TextColor3      = T.Accent
                SelectedLabel.Font            = Enum.Font.GothamBold
                SelectedLabel.TextSize        = FS(11)
                SelectedLabel.TextXAlignment  = Enum.TextXAlignment.Right
                SelectedLabel.Parent          = Header
            end

            local OptionHolder = Instance.new("Frame")
            OptionHolder.Size             = UDim2.new(1, -ES(10), 0, 0)
            OptionHolder.Position         = UDim2.new(0, ES(5), 0, RowHeight + ES(4))
            OptionHolder.BackgroundTransparency = 1
            OptionHolder.Parent           = DropdownFrame

            local Layout = Instance.new("UIListLayout", OptionHolder)
            Layout.Padding   = UDim.new(0, ES(3))
            Layout.SortOrder = Enum.SortOrder.LayoutOrder

            local Dropdown = { Open = false }

            local function UpdateHeader(sel)
                Selected = sel
                if colorMode then
                    if SelectedSwatch then SelectedSwatch.BackgroundColor3 = sel and sel.Color or Color3.new(1,1,1) end
                    if SelectedName   then SelectedName.Text = (sel and sel.Name) or "" end
                else
                    if SelectedLabel  then SelectedLabel.Text = (type(sel) == "string" and sel) or "Select..." end
                end
            end

            local function GetOpenHeight()
                return RowHeight + ES(4) + Layout.AbsoluteContentSize.Y + ES(6)
            end

            local function Refresh()
                optionOverlays = {}
                for _, child in pairs(OptionHolder:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
                end
                colorMode = IsColorMode(Options)

                for i, rawOpt in ipairs(Options) do
                    local opt = Normalise(rawOpt)

                    if colorMode then
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.LayoutOrder      = i
                        OptBtn.Size             = UDim2.new(1, 0, 0, OptHeight)
                        OptBtn.BackgroundColor3 = opt.Color
                        OptBtn.Text             = ""
                        OptBtn.BorderSizePixel  = 0
                        OptBtn.Parent           = OptionHolder
                        Corner(OptBtn, UDim.new(0, 4))

                        local RowStroke = Instance.new("UIStroke", OptBtn)
                        RowStroke.Thickness = 1.5
                        local isSel = Selected and typeof(Selected) == "table" and Selected.Color == opt.Color
                        RowStroke.Color        = isSel and T.TextWhite or Color3.fromRGB(0,0,0)
                        RowStroke.Transparency = isSel and 0 or 0.85

                        if opt.Name and opt.Name ~= "" then
                            local NameLbl = Instance.new("TextLabel")
                            NameLbl.Size                  = UDim2.new(1, -ES(10), 1, 0)
                            NameLbl.Position              = UDim2.new(0, ES(8), 0, 0)
                            NameLbl.BackgroundTransparency = 1
                            NameLbl.Text                  = opt.Name
                            NameLbl.Font                  = Enum.Font.GothamBold
                            NameLbl.TextSize              = FS(11)
                            NameLbl.TextColor3            = Color3.new(1, 1, 1)
                            NameLbl.TextTransparency      = 0.2
                            NameLbl.TextXAlignment        = Enum.TextXAlignment.Left
                            NameLbl.TextStrokeColor3      = Color3.new(0, 0, 0)
                            NameLbl.TextStrokeTransparency = 0.5
                            NameLbl.Parent                = OptBtn
                        end

                        local colorKey = (opt.Name ~= "" and opt.Name) or tostring(opt.Color)
                        local DisabledOverlay = Instance.new("Frame")
                        DisabledOverlay.Name                   = "DisabledOverlay"
                        DisabledOverlay.Size                   = UDim2.new(1, 0, 1, 0)
                        DisabledOverlay.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
                        DisabledOverlay.BackgroundTransparency = 0.6
                        DisabledOverlay.BorderSizePixel        = 0
                        DisabledOverlay.ZIndex                 = 10
                        DisabledOverlay.Visible                = disabledOptions[colorKey] == true
                        DisabledOverlay.Parent                 = OptBtn
                        Corner(DisabledOverlay, UDim.new(0, 4))
                        optionOverlays[colorKey] = DisabledOverlay

                        OptBtn.MouseButton1Click:Connect(function()
                            if dropDisabled or disabledOptions[colorKey] then return end
                            for _, child in pairs(OptionHolder:GetChildren()) do
                                local s = child:FindFirstChildOfClass("UIStroke")
                                if s then s.Color = Color3.fromRGB(0,0,0); s.Transparency = 0.85 end
                            end
                            RowStroke.Color        = T.TextWhite
                            RowStroke.Transparency = 0
                            UpdateHeader(opt)
                            Dropdown.Open = false
                            TweenService:Create(DropdownFrame, TI_02, {Size = UDim2.new(1, 0, 0, RowHeight)}):Play()
                            Callback(opt.Color, opt.Name)
                        end)

                    else
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.LayoutOrder      = i
                        OptBtn.Size             = UDim2.new(1, 0, 0, OptHeight)
                        OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                        OptBtn.Text             = opt
                        OptBtn.TextColor3       = T.TextDark
                        OptBtn.Font             = Enum.Font.Gotham
                        OptBtn.TextSize         = FS(11)
                        OptBtn.Parent           = OptionHolder
                        Corner(OptBtn, UDim.new(0, 4))

                        local DisabledOverlay = Instance.new("Frame")
                        DisabledOverlay.Name                   = "DisabledOverlay"
                        DisabledOverlay.Size                   = UDim2.new(1, 0, 1, 0)
                        DisabledOverlay.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
                        DisabledOverlay.BackgroundTransparency = 0.6
                        DisabledOverlay.BorderSizePixel        = 0
                        DisabledOverlay.ZIndex                 = 10
                        DisabledOverlay.Visible                = disabledOptions[opt] == true
                        DisabledOverlay.Parent                 = OptBtn
                        Corner(DisabledOverlay, UDim.new(0, 4))
                        optionOverlays[opt] = DisabledOverlay

                        OptBtn.MouseButton1Click:Connect(function()
                            if dropDisabled or disabledOptions[opt] then return end
                            UpdateHeader(opt)
                            Dropdown.Open = false
                            TweenService:Create(DropdownFrame, TI_02, {Size = UDim2.new(1, 0, 0, RowHeight)}):Play()
                            Callback(opt)
                        end)
                    end
                end
            end

            Header.MouseButton1Click:Connect(function()
                if dropDisabled then return end
                Dropdown.Open = not Dropdown.Open
                local targetH = Dropdown.Open and GetOpenHeight() or RowHeight
                TweenService:Create(DropdownFrame, TI_025Q, {Size = UDim2.new(1, 0, 0, targetH)}):Play()
            end)

            function Element:SetDisabled(state)
                dropDisabled  = state
                Header.Active = not state
                TweenService:Create(TitleLabel, TI_02, {TextColor3 = state and T.TextSecondary or T.TextPrimary}):Play()
                if SelectedLabel  then TweenService:Create(SelectedLabel,  TI_02, {TextTransparency       = state and 0.5 or 0}):Play() end
                if SelectedSwatch then TweenService:Create(SelectedSwatch, TI_02, {BackgroundTransparency = state and 0.5 or 0}):Play() end
                if SelectedName   then TweenService:Create(SelectedName,   TI_02, {TextTransparency       = state and 0.5 or 0}):Play() end
                if state and Dropdown.Open then
                    Dropdown.Open = false
                    TweenService:Create(DropdownFrame, TI_02, {Size = UDim2.new(1, 0, 0, RowHeight)}):Play()
                end
            end

            function Element:SetOptions(newOptions)
                Options  = newOptions
                Selected = newOptions[1] and Normalise(newOptions[1])
                UpdateHeader(Selected)
                Dropdown.Open = false
                TweenService:Create(DropdownFrame, TI_02, {Size = UDim2.new(1, 0, 0, RowHeight)}):Play()
                Refresh()
            end

            function Element:SetSelected(val)
                UpdateHeader(Normalise(val))
            end

            -- name: option string (non-color) or opt.Name (color mode)
            -- state: true = grayed out and unclickable, false = normal
            function Element:SetOptionDisabled(name, state)
                disabledOptions[name] = state == true
                local overlay = optionOverlays[name]
                if overlay then overlay.Visible = state == true end
            end

            Refresh()
            return AttachTooltip(TitleLabel, Element)
        end

        return Tab
    end

    Window.Frame   = MainFrame
    Window.Sidebar = Sidebar
    return Window
end

-- ============================================================
-- WINDOW & TAB CREATION
-- ============================================================
local HubWindow = Library:CreateWindow()

local HomeTab        = HubWindow:CreateTab("Home")
local PlayerTab      = HubWindow:CreateTab("Player")
local WorldTab       = HubWindow:CreateTab("World")
local TeleportTab    = HubWindow:CreateTab("Teleport")
local PlotTab        = HubWindow:CreateTab("Plot")
local WoodTab        = HubWindow:CreateTab("Wood")
local ShopTab        = HubWindow:CreateTab("Shop")
local ToolTab        = HubWindow:CreateTab("Tool")
local BuildTab       = HubWindow:CreateTab("Build")
local WireArtTab     = HubWindow:CreateTab("Wiring")
local DuplicationTab = HubWindow:CreateTab("Duplicate")
local VehicleTab     = HubWindow:CreateTab("Vehicle")
local SearchTab      = HubWindow:CreateTab("Search")
local ProtectionTab  = HubWindow:CreateTab("Protection")
--local HelpTab        = HubWindow:CreateTab("Help")
local SettingsTab    = HubWindow:CreateTab("Settings")
--local TestingTab        = HubWindow:CreateTab("Testing")

-- ============================================================
-- LOAD SCREEN
-- ============================================================
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name           = "DynxeLoadScreen"
LoadGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadGui.DisplayOrder   = 9999
LoadGui.ResetOnSpawn   = false
LoadGui.IgnoreGuiInset = true
LoadGui.Parent         = CoreGui

local Overlay = Instance.new("Frame")
Overlay.Size                 = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3     = Color3.fromRGB(8, 10, 22)
Overlay.BackgroundTransparency = 0.12
Overlay.BorderSizePixel      = 0
Overlay.Active               = true
Overlay.Parent               = LoadGui

ContextActionService:BindAction(
    "DynxeLoadingFreeze",
    function() return Enum.ContextActionResult.Sink end,
    false,
    unpack(Enum.PlayerActions:GetEnumItems())
)

local Vignette = Instance.new("UIGradient", Overlay)
Vignette.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(10, 20, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8,  10, 22)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 20, 60)),
})
Vignette.Rotation = 45

local Center = Instance.new("Frame")
Center.Size                   = UDim2.new(0, 320, 0, 140)
Center.AnchorPoint            = Vector2.new(0.5, 0.5)
Center.Position               = UDim2.new(0.5, 0, 0.5, 0)
Center.BackgroundTransparency = 1
Center.Parent                 = Overlay

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size               = UDim2.new(1, 0, 0, 20)
LoadingLabel.Position           = UDim2.new(0, 0, 0, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text               = "Initializing..."
LoadingLabel.TextColor3         = Color3.fromRGB(100, 140, 255)
LoadingLabel.Font               = Enum.Font.Gotham
LoadingLabel.TextSize           = 16
LoadingLabel.TextXAlignment     = Enum.TextXAlignment.Center
LoadingLabel.Parent             = Center

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size               = UDim2.new(1, 0, 0, 36)
TitleLabel.Position           = UDim2.new(0, 0, 0, 24)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text               = "<b>Dynxe</b> <font color=\"#4a78ff\">LT2</font> <font color=\"#444466\">" .. Version .. "</font>"
TitleLabel.RichText           = true
TitleLabel.TextColor3         = Color3.fromRGB(220, 220, 230)
TitleLabel.Font               = Enum.Font.GothamMedium
TitleLabel.TextSize           = 28
TitleLabel.TextXAlignment     = Enum.TextXAlignment.Center
TitleLabel.Parent             = Center

local BarTrack = Instance.new("Frame")
BarTrack.Size             = UDim2.new(1, 0, 0, 4)
BarTrack.Position         = UDim2.new(0, 0, 0, 82)
BarTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
BarTrack.BorderSizePixel  = 0
BarTrack.Parent           = Center
Corner(BarTrack, UDim.new(1, 0))

local BarFill = Instance.new("Frame")
BarFill.Size             = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(74, 120, 255)
BarFill.BorderSizePixel  = 0
BarFill.Parent           = BarTrack
Corner(BarFill, UDim.new(1, 0))

local PctLabel = Instance.new("TextLabel")
PctLabel.Size                = UDim2.new(1, 0, 0, 16)
PctLabel.Position            = UDim2.new(0, 0, 0, 90)
PctLabel.BackgroundTransparency = 1
PctLabel.Text                = "0%"
PctLabel.TextColor3          = Color3.fromRGB(70, 90, 140)
PctLabel.Font                = Enum.Font.Gotham
PctLabel.TextSize            = 11
PctLabel.TextXAlignment      = Enum.TextXAlignment.Center
PctLabel.Parent              = Center

local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size                = UDim2.new(1, 0, 0, 16)
WarningLabel.Position            = UDim2.new(0, 0, 0, 110)
WarningLabel.BackgroundTransparency = 1
WarningLabel.Text                = "MODULE STILL LOADING | DO NOT LEAVE"
WarningLabel.TextColor3          = Color3.fromRGB(255, 100, 80)
WarningLabel.Font                = Enum.Font.GothamBold
WarningLabel.TextSize            = 12
WarningLabel.Visible             = false
WarningLabel.TextXAlignment      = Enum.TextXAlignment.Center
WarningLabel.Parent              = Center

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size               = UDim2.new(1, 0, 0, 30)
FooterLabel.Position           = UDim2.new(0, 0, 1, -40)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text               = "Specific modules may take longer due to heavier functionality. Please be patient as we work foward to perfect this menu!"
FooterLabel.TextColor3         = Color3.fromRGB(255, 255, 255)
FooterLabel.Font               = Enum.Font.Gotham
FooterLabel.TextSize           = 12
FooterLabel.TextXAlignment     = Enum.TextXAlignment.Center
FooterLabel.Parent             = Overlay

local SkipButton = Instance.new("TextButton")
SkipButton.Size                = UDim2.new(1, 0, 0, 20)
SkipButton.Position            = UDim2.new(0, 0, 0, 130)
SkipButton.BackgroundTransparency = 1
SkipButton.Text                = "<u>Click to Skip Module (may cause issues)</u>"
SkipButton.TextColor3          = Color3.fromRGB(150, 150, 170)
SkipButton.Font                = Enum.Font.Gotham
SkipButton.TextSize            = 12
SkipButton.RichText            = true
SkipButton.Visible             = false
SkipButton.Parent              = Center

local function SetProgress(current, total, moduleName)
    local pct = current / total
    TweenService:Create(BarFill, TI_025Q, {
        Size = UDim2.new(pct, 0, 1, 0)
    }):Play()
    PctLabel.Text     = math.floor(pct * 100) .. "%"
    LoadingLabel.Text = moduleName and ("Loading " .. moduleName) or "Done"
    WarningLabel.Visible = false
    SkipButton.Visible   = false
end

local function DismissLoadScreen()
    ContextActionService:UnbindAction("DynxeLoadingFreeze")
    TweenService:Create(Overlay,       TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(TitleLabel,    TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(LoadingLabel,  TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(PctLabel,      TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(WarningLabel,  TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(FooterLabel,   TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(BarFill,       TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarTrack,      TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.delay(0.7, function() LoadGui:Destroy() end)
end

-- ============================================================
-- MODULE LOADING
-- ============================================================
local function LoadModule(ModuleName)
    local URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/Modules/%s.lua?t=%s",
        User, Repo, Branch, ModuleName, tick())
    local success, code = pcall(function() return game:HttpGet(URL) end)
    if success and code then
        local func = loadstring(code)
        if func then return func() end
    end
    return nil
end

local LooseObjectTeleportModule = nil
local Modules = {
    { name = "LT2Axes", run = function(m) _G.LT2Axes = m end },
    { name = "Logo",                run = function(m) if m and m.Init then m.Init(Version, Vector3.new(43.5, 18, 55.3), Vector3.new(0, -105, 0), 60, 20) end end },
    { name = "Home",                run = function(m) if m and m.Init then m.Init(HomeTab, Library) end end },
    { name = "Player",      run = function(m) if m and m.Init then m.Init(PlayerTab) end end },
    { name = "Teleport",            run = function(m) if m and m.Init then m.Init(TeleportTab) end end },
    { name = "World",               run = function(m) if m and m.Init then m.Init(WorldTab, Library) end end },
    { name = "Settings",            run = function(m) if m and m.Init then m.Init(SettingsTab, HubWindow, {User = User, Repo = Repo, Branch = Branch}, Config) end end },
    --{ name = "HardDragger",        run = function(m) if m and m.Init then m.Init(PlayerTab) end end },
    --{ name = "AntiFling",          run = function(m) if m and m.Init then m.Init(ProtectionTab) end end },
    --{ name = "AntiVoid",           run = function(m) if m and m.Init then m.Init(ProtectionTab) end end },
    { name = "AntiRagdoll",         run = function(m) if m and m.Init then m.Init(ProtectionTab) end end },
    { name = "AntiAFK",             run = function(m) if m and m.Init then m.Init(ProtectionTab) end end },
    { name = "AxeRecovery",         run = function(m) if m and m.Init then m.Init(ProtectionTab) end end },
    { name = "LooseObjectTeleport", run = function(m)
        LooseObjectTeleportModule = m
        if m and m.Init then m.Init(ToolTab, Library) end
    end },
    --{ name = "TreeCam",             run = function(m) if m and m.Init then m.Init(WoodTab) end end },
    { name = "Vehicle",             run = function(m) if m and m.Init then m.Init(VehicleTab) end end },
    { name = "Plot",                run = function(m) if m and m.Init then m.Init(PlotTab, Library) end end },
    { name = "Tree",                run = function(m) if m and m.Init then m.Init(WoodTab, LooseObjectTeleportModule) end end },
    --{ name = "Help",                run = function(m) if m and m.Init then m.Init(HelpTab) end end },
    { name = "AxeDupe",         run = function(m) if m and m.Init then m.Init(DuplicationTab) end end },
    { name = "Duplication",         run = function(m) if m and m.Init then m.Init(DuplicationTab) end end },
    { name = "Build",               run = function(m) if m and m.Init then m.Init(BuildTab, LooseObjectTeleportModule) end end },
    { name = "Shop",                run = function(m) if m and m.Init then m.Init(ShopTab, LooseObjectTeleportModule) end end },
    { name = "ModTree", run = function(m) if m and m.Init then m.Init(WoodTab, LooseObjectTeleportModule, Library) end end },
    { name = "1x1Cutter",            run = function(m) if m and m.Init then m.Init(WoodTab) end end },
    { name = "TreeSearcher", run = function(m) if m and m.Init then m.Init(SearchTab, Library) end end },
    { name = "HoverValue", run = function(m) if m and m.Init then m.Init(WoodTab, Library) end end },
    { name = "WireArt", run = function(m) if m and m.Init then m.Init(WireArtTab, Library) end end },
}

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/learnhtsd/lt2/refs/heads/main/Theme.lua"))()

local total = #Modules
for i, entry in ipairs(Modules) do
    SetProgress(i - 1, total, entry.name)

    local moduleFinished = false
    local skipRequested  = false

    local skipConn
    skipConn = SkipButton.MouseButton1Click:Connect(function()
        skipRequested = true
        warn("[Loader] Skipping " .. entry.name)
    end)

    task.delay(5, function()
        if not moduleFinished then
            WarningLabel.Visible = true
            SkipButton.Visible   = true
        end
    end)

    task.spawn(function()
        local ok, err = pcall(function()
            local m = LoadModule(entry.name)
            entry.run(m)
        end)
        moduleFinished = true
        if not ok then warn("[Loader] " .. entry.name .. " failed: " .. tostring(err)) end
    end)

    repeat task.wait() until moduleFinished or skipRequested

    if skipConn then skipConn:Disconnect() end
    WarningLabel.Visible = false
    SkipButton.Visible   = false
    task.wait(0.05)
end

SetProgress(total, total, nil)
task.wait(0.4)
DismissLoadScreen()
Library:Notify("Dynxe LT2", "All modules loaded!", 5)
