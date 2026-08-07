local SettingsModule = {}
local CoreGui      = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
_G.NexusConnections = _G.NexusConnections or {}

function SettingsModule.Init(Tab, MainUI, RepoConfig, Config)
    local ScreenGui, MainFrame, SidebarFrame
    if typeof(MainUI) == "table" then
        ScreenGui    = MainUI.UI
        MainFrame    = MainUI.Frame
        SidebarFrame = MainUI.Sidebar
    elseif typeof(MainUI) == "Instance" then
        ScreenGui = MainUI
    end
    if not ScreenGui or not ScreenGui.Parent then
        ScreenGui = CoreGui:FindFirstChild("DynxeHub")
    end

    local W = Config and Config.Window

    -- ════════════════════════════════════════════════════════
    -- WINDOW SIZE
    -- ════════════════════════════════════════════════════════
    if Config and MainFrame then

        Tab:CreateSection("Customization")

        Tab:CreateSlider("Width", 400, 600, W.Width, function(val)
            W.Width = val
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, val, 0, W.Height),
            }):Play()
        end)

        Tab:CreateSlider("Height", 350, 600, W.Height, function(val)
            W.Height = val
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, W.Width, 0, val),
            }):Play()
        end)

        Tab:CreateSlider("Menu Opacity", 0, 100, 85, function(val)
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                BackgroundTransparency = 1 - (val / 100)
            }):Play()
        end)
    end

    -- ════════════════════════════════════════════════════════
    -- SYSTEM
    -- ════════════════════════════════════════════════════════
    Tab:CreateSection("System")

    _G.DynxeMenuClamped = true
    Tab:CreateToggle("Clamp Menu", true, function(state)
        _G.DynxeMenuClamped = state
    end)

    local AUTO_EXEC_PATH = "autoexec/Dynxe.lua"
    local autoLoadDefault = (isfile and isfile(AUTO_EXEC_PATH)) or false
    Tab:CreateToggle("Auto Load Script", autoLoadDefault, function(state)
        if state then
            pcall(function()
                if isfolder and not isfolder("autoexec") then
                    makefolder("autoexec")
                end
                if writefile then
                    writefile(
                        AUTO_EXEC_PATH,
                        string.format(
                            'loadstring(game:HttpGet("https://raw.githubusercontent.com/%s/%s/%s/main.lua"))();',
                            RepoConfig.User, RepoConfig.Repo, RepoConfig.Branch
                        )
                    )
                end
            end)
        else
            pcall(function()
                if isfile and isfile(AUTO_EXEC_PATH) then
                    delfile(AUTO_EXEC_PATH)
                end
            end)
        end
    end)

    Tab:CreateKeybind("Toggle Menu", Enum.KeyCode.LeftAlt, function()
        if ScreenGui then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local function Unload()
        _G.NexusActive = false
        for _, conn in pairs(_G.NexusConnections) do
            if typeof(conn) == "RBXScriptConnection" and conn.Connected then
                conn:Disconnect()
            end
        end
        _G.NexusConnections = {}
        pcall(function() game:GetService("Lighting").ClockTime = 12 end)
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
        if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    end

    local ReloadAction = Tab:CreateAction("Reload Script", "Reload", function()
        Unload()
        task.wait(0.1)
        local URL = string.format(
            "https://raw.githubusercontent.com/%s/%s/%s/main.lua?t=%s",
            RepoConfig.User, RepoConfig.Repo, RepoConfig.Branch, tick()
        )
        local ok, result = pcall(function() return game:HttpGet(URL) end)
        if ok and result and result ~= "" then
            local fn = loadstring(result)
            if fn then fn() else warn("[Settings] Reload: loadstring failed") end
        else
            warn("[Settings] Reload: HttpGet failed — " .. tostring(result))
        end
    end)
    ReloadAction:SetDisabled(true)

    local UnloadAction = Tab:CreateAction("Unload Script", "Unload", Unload)
    UnloadAction:SetDisabled(true)

    -- ════════════════════════════════════════════════════════
    -- DATA MANAGEMENT
    -- ════════════════════════════════════════════════════════
    Tab:CreateSection("Data Management")

    Tab:CreateAction("Open Folder", "Open", function()
        pcall(function()
            if isfolder and not isfolder("Dynxe") then
                makefolder("Dynxe")
            end
        end)
    
        local opened = false
    
        -- Synapse X
        if not opened and syn and syn.open_folder then
            pcall(function() syn.open_folder("Dynxe") end)
            opened = true
        end
    
        -- Fluxus / some others
        if not opened and explorerfolder then
            pcall(function() explorerfolder("Dynxe") end)
            opened = true
        end
    
        -- Krnl / Wave / some others
        if not opened and openfolder then
            pcall(function() openfolder("Dynxe") end)
            opened = true
        end
    
        -- openfile fallback
        if not opened and openfile then
            pcall(function() openfile("Dynxe") end)
            opened = true
        end
    
        if not opened then
            warn("[Settings] Executor: " .. tostring(identifyexecutor and identifyexecutor() or "unknown") .. " does not support opening folders.")
        end
    end)

    local FolderAction = Tab:CreateAction("Delete Folder", "Delete", function()
        pcall(function()
            if isfolder and isfolder("Dynxe") then
                delfolder("Dynxe")
            elseif isfile and isfile("Dynxe") then
                delfile("Dynxe")
            end
        end)

        task.wait(0.5)

        pcall(function()
            game:GetService("Players").LocalPlayer:Kick(
                "\n[Dynxe Hub]\nData reset initiated.\n\nThe 'Dynxe' folder has been removed.\nPlease rejoin to generate new configs."
            )
        end)
    end)
    FolderAction:AddTooltip("Deletes the storage folder for Dynxe. Also kicks you from the game to prevent any errors from occuring.")
end

return SettingsModule
