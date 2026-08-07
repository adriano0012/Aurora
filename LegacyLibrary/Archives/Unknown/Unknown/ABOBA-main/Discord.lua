 
        local Library =
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Kurus Discord (abandoned)", "Synapse")

    -- MAIN
    local Main = Window:NewTab("Discord")
    local MainSection = Main:NewSection("Discord")

    MainSection:NewButton("Discord", "", function()
        local CoreGui = game:GetService("StarterGui") -- Variable of StarterGui
            CoreGui:SetCore("SendNotification", {
                -- Customizable
                Title = "Paste To Browser",
                Text = "Copied To Clipboard",
                Duration = 7, -- Set the duration to how much you want this to stay
                -- More code in part 2
            })
            setclipboard("https://discord.gg/C9aRngy5Ym")
            toclipboard("https://discord.gg/C9aRngy5Ym")
                    end)
                
