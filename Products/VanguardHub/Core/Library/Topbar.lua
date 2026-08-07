local Registry = rawget(_G, "__VanguardModuleRegistry") or {}
local Utils = Registry["Core/Library/Utils"]
local Tween = Registry["Core/Library/Tween"]

local Players = game:GetService("Players")

local Topbar = {}

local function tween(library, instance, properties, duration)
    if Tween then
        Tween.Play(library, instance, properties, duration or 0.16)
        return
    end
    for property, value in pairs(properties) do
        instance[property] = value
    end
end

local function makeTopButton(context, parent, text, icon, x, width)
    local library = context.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = parent,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(x, 35),
        Size = UDim2.fromOffset(width, 51),
        Text = ""
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = button,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.26
    })
    local iconLabel = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.fromOffset(34, 51),
        Text = icon,
        TextColor3 = library.Theme.Text,
        TextSize = 23
    })
    local textLabel = Utils.CreateInstance("TextLabel", {
        Parent = button,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(44, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    library:AddConnection(button, "MouseEnter", function()
        tween(library, button, {BackgroundColor3 = library.Theme.Hover}, 0.16)
    end)
    library:AddConnection(button, "MouseLeave", function()
        local record = context.Topbar and context.Topbar.Lookup and context.Topbar.Lookup[button]
        if not (record and record.Selected) then
            tween(library, button, {BackgroundColor3 = library.Theme.Glass}, 0.16)
        end
    end)

    return {
        Button = button,
        Stroke = stroke,
        Icon = iconLabel,
        Label = textLabel,
        Selected = false
    }
end

local function makeWindowButton(context, parent, text, x)
    local library = context.Library
    local button = Utils.CreateInstance("TextButton", {
        Parent = parent,
        AutoButtonColor = false,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(x, 13),
        Size = UDim2.fromOffset(48, 50),
        Text = text,
        TextColor3 = library.Theme.Text,
        TextSize = 28
    })
    Utils.CreateInstance("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})
    local stroke = Utils.CreateInstance("UIStroke", {
        Parent = button,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.32
    })
    library:AddConnection(button, "MouseEnter", function()
        tween(library, button, {BackgroundColor3 = library.Theme.Hover}, 0.15)
    end)
    library:AddConnection(button, "MouseLeave", function()
        tween(library, button, {BackgroundColor3 = library.Theme.Glass}, 0.15)
    end)
    return button, stroke
end

function Topbar.Build(context)
    local library = context.Library
    local main = context.Main
    local localPlayer = Players.LocalPlayer

    local root = Utils.CreateInstance("Frame", {
        Name = "Top",
        Parent = main,
        Active = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 104)
    })
    library:TrackInstance(root)
    context.DragHandle = root

    local logoShield = Utils.CreateInstance("Frame", {
        Parent = root,
        BackgroundColor3 = Color3.fromRGB(4, 9, 11),
        BackgroundTransparency = 0.25,
        Position = UDim2.fromOffset(24, 22),
        Size = UDim2.fromOffset(62, 66)
    })
    Utils.CreateInstance("UICorner", {Parent = logoShield, CornerRadius = UDim.new(0, 15)})
    Utils.CreateInstance("UIStroke", {
        Parent = logoShield,
        Color = Color3.fromRGB(219, 221, 223),
        Thickness = 3,
        Transparency = 0.08
    })
    Utils.CreateInstance("TextLabel", {
        Parent = logoShield,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(0, -1),
        Size = UDim2.fromScale(1, 1),
        Text = "V",
        TextColor3 = library.Theme.Text,
        TextSize = 41
    })

    local title = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(101, 24),
        RichText = true,
        Size = UDim2.fromOffset(255, 42),
        Text = '<b>Vanguard</b><font color="#805EF5"><b>Hub</b></font>',
        TextColor3 = library.Theme.Text,
        TextSize = 32,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local subtitle = Utils.CreateInstance("TextLabel", {
        Parent = root,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(102, 66),
        Size = UDim2.fromOffset(260, 24),
        Text = library.Options.Subtitle or "Universal",
        TextColor3 = library.Theme.TextDim,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library.SubtitleLabel = subtitle

    local mainButton = makeTopButton(context, root, "Main", "M", 394, 113)
    local settingsButton = makeTopButton(context, root, "Settings", "S", 526, 135)
    local themeButton = makeTopButton(context, root, "Theme", "T", 681, 128)

    local profile = Utils.CreateInstance("Frame", {
        Parent = root,
        BackgroundColor3 = library.Theme.Glass,
        BackgroundTransparency = 0.05,
        Position = UDim2.fromOffset(1240, 21),
        Size = UDim2.fromOffset(359, 79)
    })
    Utils.CreateInstance("UICorner", {Parent = profile, CornerRadius = UDim.new(0, 10)})
    Utils.CreateInstance("UIStroke", {
        Parent = profile,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.2
    })

    local avatar = Utils.CreateInstance("ImageLabel", {
        Parent = profile,
        BackgroundColor3 = library.Theme.Selected,
        Image = localPlayer and ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(localPlayer.UserId) .. "&w=150&h=150") or "",
        Position = UDim2.fromOffset(8, 6),
        ScaleType = Enum.ScaleType.Crop,
        Size = UDim2.fromOffset(66, 66)
    })
    Utils.CreateInstance("UICorner", {Parent = avatar, CornerRadius = UDim.new(1, 0)})
    local avatarStroke = Utils.CreateInstance("UIStroke", {
        Parent = avatar,
        Color = library.Theme.Accent,
        Thickness = 2,
        Transparency = 0.08
    })
    library:BindTheme(avatarStroke, "Color", "Accent")

    Utils.CreateInstance("TextLabel", {
        Parent = profile,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(87, 10),
        Size = UDim2.fromOffset(145, 28),
        Text = localPlayer and localPlayer.DisplayName or "VanguardHub",
        TextColor3 = library.Theme.Text,
        TextSize = 17,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local premiumLabel = Utils.CreateInstance("TextLabel", {
        Parent = profile,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(87, 39),
        Size = UDim2.fromOffset(145, 25),
        Text = "Premium",
        TextColor3 = library.Theme.Accent,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    library:BindTheme(premiumLabel, "TextColor3", "Accent")

    local minimizeButton = makeWindowButton(context, profile, "-", 244)
    local closeButton = makeWindowButton(context, profile, "x", 302)

    local themePanel = Utils.CreateInstance("Frame", {
        Parent = main,
        BackgroundColor3 = library.Theme.Secondary,
        BackgroundTransparency = 0.02,
        Position = UDim2.fromOffset(681, 94),
        Size = UDim2.fromOffset(270, 84),
        Visible = false
    })
    Utils.CreateInstance("UICorner", {Parent = themePanel, CornerRadius = UDim.new(0, 9)})
    Utils.CreateInstance("UIStroke", {
        Parent = themePanel,
        Color = library.Theme.CardBorder,
        Thickness = 1,
        Transparency = 0.05
    })
    Utils.CreateInstance("TextLabel", {
        Parent = themePanel,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Position = UDim2.fromOffset(12, 7),
        Size = UDim2.fromOffset(246, 22),
        Text = "ACCENT COLOR",
        TextColor3 = library.Theme.TextDim,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    context.ThemePanel = themePanel
    context.Topbar = {
        Root = root,
        Buttons = {
            Main = mainButton,
            Settings = settingsButton,
            Theme = themeButton
        },
        Lookup = {
            [mainButton.Button] = mainButton,
            [settingsButton.Button] = settingsButton,
            [themeButton.Button] = themeButton
        },
        MinimizeButton = minimizeButton
    }

    for index, themeName in ipairs({"Purple", "Blue", "Dark", "Green", "Gold"}) do
        local choice = library.ThemeCatalog[themeName]
        if choice then
            local swatch = Utils.CreateInstance("TextButton", {
                Parent = themePanel,
                AutoButtonColor = false,
                BackgroundColor3 = choice.Accent,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(14 + ((index - 1) * 50), 38),
                Size = UDim2.fromOffset(36, 36),
                Text = ""
            })
            Utils.CreateInstance("UICorner", {Parent = swatch, CornerRadius = UDim.new(1, 0)})
            Utils.CreateInstance("UIStroke", {
                Parent = swatch,
                Color = Color3.fromRGB(235, 235, 235),
                Thickness = 1,
                Transparency = 0.42
            })
            library:AddConnection(swatch, "MouseButton1Click", function()
                if context.UI and type(context.UI.SetTheme) == "function" then
                    context.UI:SetTheme(themeName)
                end
                themePanel.Visible = false
                Topbar.SetSelected(context, context.CurrentTab and context.CurrentTab.Id == "settings" and "Settings" or "Main")
            end)
        end
    end

    library:AddConnection(mainButton.Button, "MouseButton1Click", function()
        if context.SelectPreferredMainTab then
            context.SelectPreferredMainTab()
        end
    end)
    library:AddConnection(settingsButton.Button, "MouseButton1Click", function()
        if context.SelectSettingsTab then
            context.SelectSettingsTab()
        end
    end)
    library:AddConnection(themeButton.Button, "MouseButton1Click", function()
        themePanel.Visible = not themePanel.Visible
        Topbar.SetSelected(context, themePanel.Visible and "Theme" or (context.CurrentTab and context.CurrentTab.Id == "settings" and "Settings" or "Main"))
    end)
    library:AddConnection(minimizeButton, "MouseButton1Click", function()
        local minimized = context.ToggleMinimize and context.ToggleMinimize()
        minimizeButton.Text = minimized and "+" or "-"
    end)
    library:AddConnection(closeButton, "MouseButton1Click", function()
        if context.UI and type(context.UI.Destroy) == "function" then
            context.UI:Destroy()
        end
    end)
end

function Topbar.SetSelected(context, key)
    if not context.Topbar then
        return
    end

    local library = context.Library
    context.ActiveTopButton = key

    for name, record in pairs(context.Topbar.Buttons) do
        local active = name == key
        record.Selected = active
        tween(library, record.Button, {
            BackgroundColor3 = active and library.Theme.Selected or library.Theme.Glass
        }, 0.16)
        tween(library, record.Stroke, {
            Color = active and library.Theme.Accent or library.Theme.CardBorder,
            Transparency = active and 0.08 or 0.26
        }, 0.16)
        tween(library, record.Icon, {
            TextColor3 = active and library.Theme.Accent or library.Theme.Text
        }, 0.16)
        tween(library, record.Label, {
            TextColor3 = active and library.Theme.Accent or library.Theme.Text
        }, 0.16)
    end
end

return Topbar
