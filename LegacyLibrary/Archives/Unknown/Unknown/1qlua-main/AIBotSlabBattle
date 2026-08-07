
local scripts = {
    "https://raw.githubusercontent.com/1Qlua-RBXscript/1qlua/refs/heads/main/GUIAIBOT", -- Сам скрипт
    "https://obj.wearedevs.net/2/scripts/Focus%20Anti-AFK.lua", -- анти афк
    "https://raw.githubusercontent.com/1Qlua-RBXscript/1qlua/refs/heads/main/LIBRARY_1QLUA_NOPRINT" -- библеотека покачто не используеться
}

for i, url in ipairs(scripts) do
    coroutine.wrap(function()
        local success, err = pcall(function()
            local scriptContent = game:HttpGet(url)
            loadstring(scriptContent)()
        end)
        
        if not success then
            warn("Ошибка в скрипте "..i.." ("..url.."): "..err)
        else
            print("Скрипт "..i.." успешно запущен: "..url)
        end
    end)()
end
