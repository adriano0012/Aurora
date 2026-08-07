 
        local Library =
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Kurus Discord (abandoned)", "Serpent")

    -- MAIN
    local Main = Window:NewTab("Discord")
    local MainSection = Main:NewSection("Discord Russian")

    MainSection:NewButton("Discord", "<< RU", function()
        local CoreGui = game:GetService("StarterGui") -- Variable of StarterGui
            CoreGui:SetCore("SendNotification", {
                -- Customizable
                Title = "Paste To Browser",
                Text = "Copied To Clipboard",
                Duration = 7, -- Set the duration to how much you want this to stay
                -- More code in part 2
            })
            setclipboard("https://discord.gg/yPjnhFwkxm")
            toclipboard("https://discord.gg/yPjnhFwkxm")
                    end)
                
