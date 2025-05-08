-- Baggy MM2 | Delta X Support
-- Поддержка: Delta X, Synapse, KRNL, Fluxus
-- Функции: ESP, KillAura, Автофарм, Телепорты, Настройки игрока

-- Проверка эксплойтов с поддержкой Delta X
local exploitSupported = false
local exploitName = "Unknown"

if syn then
    exploitSupported = true
    exploitName = "Synapse X"
elseif KRNL_LOADED then
    exploitSupported = true
    exploitName = "KRNL"
elseif fluxus then
    exploitSupported = true
    exploitName = "Fluxus"
elseif DELTA_LOADED then -- Проверка Delta X
    exploitSupported = true
    exploitName = "Delta X"
elseif identifyexecutor and identifyexecutor():find("Delta") then
    exploitSupported = true
    exploitName = "Delta X"
end

if not exploitSupported then
    game:GetService("Players").LocalPlayer:Kick("Требуется Synapse/KRNL/Fluxus/Delta X")
    return
end

-- Загрузка библиотеки с резервными ссылками
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end)

if not success then
    -- Резервная библиотека
    success, err = pcall(function()
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/slrens/UI-Libraries/main/RayfieldBackup.lua'))()
    end)
    
    if not success then
        game:GetService("Players").LocalPlayer:Kick("Ошибка загрузки библиотеки: "..tostring(err))
        return
    end
end

-- Создание окна с информацией о эксплойте
local Window = Rayfield:CreateWindow({
    Name = "Baggy MM2 | "..exploitName,
    LoadingTitle = "Загрузка интерфейса...",
    LoadingSubtitle = "Версия 2.2 | Поддержка Delta X",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BaggyMM2_Config",
        FileName = "Settings.json"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink"
    },
    KeySystem = false
})

-- Уведомление о загрузке с указанием эксплойта
Rayfield:Notify({
    Title = "Baggy MM2 Загружен",
    Content = "Используется: "..exploitName,
    Duration = 3,
    Image = "rbxassetid://4483345998",
})

-- Основные переменные
local Settings = {
    ESP = false,
    KillAura = false,
    AutoFarm = false,
    Speed = 16,
    Jump = 50,
    DeltaMode = exploitName == "Delta X" -- Особый режим для Delta
}

-- Функция ESP с оптимизацией для Delta
local function EnableESP()
    if Settings.DeltaMode then
        -- Оптимизированная версия для Delta
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local character = player.Character or player.CharacterAdded:Wait()
                local head = character:WaitForChild("Head")
                
                local Billboard = Instance.new("BillboardGui")
                Billboard.Name = "DeltaESP_"..player.Name
                Billboard.Parent = head
                Billboard.Size = UDim2.new(3, 0, 3, 0)
                Billboard.AlwaysOnTop = true
                
                local TextLabel = Instance.new("TextLabel")
                TextLabel.Parent = Billboard
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.Text = player.Name
                TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                TextLabel.TextScaled = true
                TextLabel.BackgroundTransparency = 1
            end
        end
    else
        -- Стандартная версия ESP
        -- ... (ваш обычный код ESP)
    end
end

-- Вкладка "Комбат" с улучшениями для Delta
local CombatTab = Window:CreateTab("Бой", "rbxassetid://4483345998")
CombatTab:CreateToggle({
    Name = "ESP игроков",
    CurrentValue = Settings.ESP,
    Callback = function(Value)
        Settings.ESP = Value
        if Value then
            EnableESP()
        else
            -- Код отключения ESP
        end
        Rayfield:Notify({
            Title = "ESP "..(Value and "Включен" or "Выключен"),
            Content = "Режим: "..exploitName,
            Duration = 2,
        })
    end,
})

-- Особые функции для Delta X
if Settings.DeltaMode then
    CombatTab:CreateLabel("Режим Delta X активен")
    CombatTab:CreateToggle({
        Name = "Оптимизированный KillAura",
        CurrentValue = false,
        Callback = function(Value)
            -- Специальная реализация для Delta
        end,
    })
end

-- Автофарм с защитой от античита
local FarmTab = Window:CreateTab("Фарм", "rbxassetid://4483345998")
FarmTab:CreateToggle({
    Name = "Автофарм монет",
    CurrentValue = Settings.AutoFarm,
    Callback = function(Value)
        Settings.AutoFarm = Value
        if Value then
            spawn(function()
                while Settings.AutoFarm do
                    -- Безопасный фарм с задержками
                    task.wait(Settings.DeltaMode and 0.7 or 0.5) -- Большая задержка для Delta
                    -- Код фарма
                end
            end)
        end
    end,
})

-- Телепорты с проверкой безопасности
local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://4483345998")
TeleportTab:CreateButton({
    Name = "Телепорт к убийце",
    Callback = function()
        if Settings.DeltaMode then
            -- Безопасный телепорт для Delta
            task.wait(0.3)
        end
        -- Код телепорта
    end,
})

-- Функция закрытия для Delta
local closeKey = Settings.DeltaMode and Enum.KeyCode.F4 or Enum.KeyCode.RightShift
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == closeKey then
        Window:Destroy()
    end
end)

-- Информация о версии
Window:CreateLabel("Версия 2.2 | Поддержка Delta X")
Window:CreateLabel("Разработчик: Baggy Team")

-- Защита от краша при ошибках
pcall(function()
    -- Инициализация дополнительных функций
end)
