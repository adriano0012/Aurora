local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Настройки по умолчанию
local BUILD_SETTINGS = {
    Spam = false,
    Retention = 0.1,
    Delay = 0.05,
    ReleaseDelay = 0.01,
    MaxDuration = 10
}

local activeProcesses = {}

-- Новая версия функции отправки ввода через VirtualInputManager
local function sendInput(keyCode, isPressed)
    if isPressed then
        VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    else
        VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
    end
end

-- Основная функция нажатия
local function pressKey(keyCode, settings)
    if activeProcesses[keyCode] then
        warn("⚠️ Процесс для клавиши "..tostring(keyCode).." уже запущен")
        return false
    end
    
    activeProcesses[keyCode] = true
    local startTime = os.clock()
    
    coroutine.wrap(function()
        if settings.Spam then
            -- Режим спама
            while activeProcesses[keyCode] and (os.clock() - startTime) < settings.MaxDuration do
                sendInput(keyCode, true)
                task.wait(settings.ReleaseDelay)
                sendInput(keyCode, false)
                task.wait(settings.Delay)
            end
        else
            -- Режим удержания
            sendInput(keyCode, true)
            
            if settings.Retention > 0 then
                local retentionEnd = os.clock() + settings.Retention
                while activeProcesses[keyCode] and os.clock() < retentionEnd do
                    task.wait()
                end
            end
            
            sendInput(keyCode, false)
        end
        
        activeProcesses[keyCode] = nil
    end)()
    
    return true
end

-- Функция настройки
getgenv().BUILD_SETTINGS = function(settings)
    if settings.Spam ~= nil then BUILD_SETTINGS.Spam = settings.Spam end
    if settings.Retention then BUILD_SETTINGS.Retention = settings.Retention end
    if settings.Delay then BUILD_SETTINGS.Delay = settings.Delay end
    if settings.ReleaseDelay then BUILD_SETTINGS.ReleaseDelay = settings.ReleaseDelay end
    if settings.MaxDuration then BUILD_SETTINGS.MaxDuration = settings.MaxDuration end
    
    print("✅ Настройки BUILD обновлены:")
    print("Spam:", BUILD_SETTINGS.Spam)
    print("Retention:", BUILD_SETTINGS.Retention, "сек")
    print("Delay:", BUILD_SETTINGS.Delay, "сек")
    print("ReleaseDelay:", BUILD_SETTINGS.ReleaseDelay, "сек")
    print("MaxDuration:", BUILD_SETTINGS.MaxDuration, "сек")
end

-- Основная функция
getgenv().BUILD = function(key, customSettings)
    local keyCode
    if type(key) == "string" then
        keyCode = Enum.KeyCode[key:upper()]
        if not keyCode then
            warn("❌ Неизвестная клавиша: "..key)
            return false
        end
    elseif typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        keyCode = key
    else
        warn("❌ Неверный формат клавиши")
        return false
    end
    
    local settings = table.clone(BUILD_SETTINGS)
    if type(customSettings) == "table" then
        for k,v in pairs(customSettings) do settings[k] = v end
    end
    
    local success, err = pcall(function()
        return pressKey(keyCode, settings)
    end)
    
    if not success then
        warn("❌ Ошибка при выполнении BUILD: "..tostring(err))
        return false
    end
    
    return true
end

-- Функция остановки
getgenv().UNBUILD = function(key)
    local keyCode
    if type(key) == "string" then
        keyCode = Enum.KeyCode[key:upper()]
    elseif typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        keyCode = key
    else
        warn("❌ Неверный формат клавиши")
        return false
    end
    
    if activeProcesses[keyCode] then
        activeProcesses[keyCode] = nil
        pcall(function()
            sendInput(keyCode, false)
        end)
        print("✅ Остановлено нажатие клавиши: "..tostring(keyCode))
        return true
    end
    
    warn("⚠️ Нет активного процесса для клавиши: "..tostring(keyCode))
    return false
end
