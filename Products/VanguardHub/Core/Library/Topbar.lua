local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Topbar = {}

local function makeButton(context, parent, text, x, width)
    local library = context.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = parent,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, 26),
        Size = UDim2.fromOffset(width, 40),
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextColor3 = library.Theme.Text,
        TextSize = 14
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 10)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = button,
        Color = library.Theme.CardBorder,
        Transparency = 0.2
    })
    library:BindTheme(button, "TextColor3", "Text")
    library:BindTheme(stroke, "Color", "CardBorder")
    return button, stroke
end

function Topbar.Build(context)
    local library = context.Library
    local main = context.Main

    local root = Utils.CreateInstance("Frame", {
        Name = "Topbar",
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(22, 22),
        Size = UDim2.new(1, -44, 0, 80)
    })
    library:TrackInstance(root)

    local title = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(10, 6),
        Size = UDim2.fromOffset(240, 32),
        RichText = true,
        Text = '<b>Vanguard</b><font color="#805EF5"><b>Hub</b></font>',
        TextColor3 = library.Theme.Text,
        TextSize = 28,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(title, "TextColor3", "Text")

    local subtitle = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(12, 42),
        Size = UDim2.fromOffset(320, 22),
        Text = library.Options.Subtitle or "Universal",
        TextColor3 = library.Theme.TextDim,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(subtitle, "TextColor3", "TextDim")
    library.SubtitleLabel = subtitle

    local mainButton, mainStroke = makeButton(context, root, "Main", 360, 100)
    local settingsButton, settingsStroke = makeButton(context, root, "Settings", 470, 120)
    local themeButton, themeStroke = makeButton(context, root, "Theme", 600, 100)
    local minimizeButton = makeButton(context, root, "_", 860, 40)
    local closeButton = makeButton(context, root, "X", 910, 40)

    context.Topbar = {
        Root = root,
        Buttons = {
            Main = {Button = mainButton, Stroke = mainStroke},
            Settings = {Button = settingsButton, Stroke = settingsStroke},
            Theme = {Button = themeButton, Stroke = themeStroke}
        }
    }

    local profile = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.new(1, -260, 0, 16),
        Size = UDim2.fromOffset(160, 22),
        Text = (game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.DisplayName) or "Vanguard",
        TextColor3 = library.Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    library:BindTheme(profile, "TextColor3", "Text")

    local themePanel = Utils.CreateInstance("Frame", {
        Parent = root,
        BackgroundColor3 = library.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(600, 72),
        Size = UDim2.fromOffset(230, 56),
        Visible = false
    })
    Utils.CreateInstance("UICorner", {Parent = themePanel, CornerRadius = UDim.new(0, 10)})
    local panelLayout = Utils.CreateInstance("UIListLayout", {
        Parent = themePanel,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8)
    })
    Utils.CreateInstance("UIPadding", {
        Parent = themePanel,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    library:TrackInstance(themePanel)
    context.ThemePanel = themePanel

    for _, themeName in ipairs({"Dark", "Purple", "Blue", "Green", "Gold", "Light"}) do
        local choice = (library.ThemeCatalog or {})[themeName]
        if choice then
            local swatch = Utils.CreateInstance("TextButton", {
                Parent = themePanel,
                AutoButtonColor = false,
                BackgroundColor3 = choice.Accent,
                BorderSizePixel = 0,
                Size = UDim2.fromOffset(24, 24),
                Text = ""
            })
            Utils.CreateInstance("UICorner", {Parent = swatch, CornerRadius = UDim.new(1, 0)})
            library:AddConnection(swatch, "MouseButton1Click", function()
                if context.UI and type(context.UI.SetTheme) == "function" then
                    context.UI:SetTheme(themeName)
                end
                themePanel.Visible = false
            end)
        end
    end

    library:AddConnection(mainButton, "MouseButton1Click", function()
        if context.SelectPreferredMainTab then
            context.SelectPreferredMainTab()
        end
    end)
    library:AddConnection(settingsButton, "MouseButton1Click", function()
        if context.SelectSettingsTab then
            context.SelectSettingsTab()
        end
    end)
    library:AddConnection(themeButton, "MouseButton1Click", function()
        themePanel.Visible = not themePanel.Visible
        Topbar.SetSelected(context, themePanel.Visible and "Theme" or context.ActiveTopButton or "Main")
    end)
    library:AddConnection(minimizeButton, "MouseButton1Click", function()
        if context.ToggleMinimize then
            context.ToggleMinimize()
        end
    end)
    library:AddConnection(closeButton, "MouseButton1Click", function()
        if context.UI and context.UI.Destroy then
            context.UI:Destroy()
        end
    end)
end

function Topbar.SetSelected(context, key)
    local library = context.Library
    context.ActiveTopButton = key
    for name, record in pairs(context.Topbar.Buttons) do
        local active = name == key
        Tween.Play(library, record.Button, {
            BackgroundColor3 = active and library.Theme.Selected or library.Theme.Glass
        }, 0.15)
        Tween.Play(library, record.Stroke, {
            Color = active and library.Theme.Accent or library.Theme.CardBorder
        }, 0.15)
        Tween.Play(library, record.Button, {
            TextColor3 = active and library.Theme.Accent or library.Theme.Text
        }, 0.15)
    end
end

return Topbar
