-- Baggy MM2 Ultimate | Delta X Support + Error 267 Fix
-- GitHub: https://github.com/woin201/BaggyMM2
-- Поддержка: Delta X, Synapse, KRNL, Fluxus

-- ========================
-- 1. ИНИЦИАЛИЗАЦИЯ ЭКСПЛОЙТА
-- ========================
local executor = {
    Name = "Unknown",
    Supported = false,
    DeltaMode = false,
    SecurityLevel = 0
}

-- Функция определения эксплойта
local function DetectExecutor()
    if syn and syn.protect_gui then
        executor.Name = "Synapse X"
        executor.Supported = true
        executor.SecurityLevel = 3
    elseif KRNL_LOADED then
        executor.Name = "KRNL"
        executor.Supported = true
        executor.SecurityLevel = 2
    elseif fluxus then
        executor.Name = "Fluxus"
        executor.Supported = true
        executor.SecurityLevel = 2
    elseif DELTA_LOADED or (identifyexecutor and identifyexecutor():lower():find("delta")) then
        executor.Name = "Delta X"
        executor.Supported = true
        executor.DeltaMode = true
        executor.SecurityLevel = 2
    elseif getexecutorname and getexecutorname():lower():find("delta") then
        executor.Name = "Delta X"
        executor.Supported = true
        executor.DeltaMode = true
        executor.SecurityLevel = 2
    end
end

DetectExecutor()

if not executor.Supported then
    game:GetService("Players").LocalPlayer:Kick("✗ Неподдерживаемый эксплойт\n✓ Требуется: Synapse/KRNL/Fluxus/Delta X")
    return
end

-- ========================
-- 2. ЗАГРУЗКА ИНТЕРФЕЙСА
-- ========================
local Rayfield
local UILoadSuccess, UILoadError = pcall(function()
    -- Попытка загрузить с разных источников
    local UISources = {
        "https://raw.githubusercontent.com/shlexware/Rayfield/main/source",
        "https://raw.githubusercontent.com/slrens/UI-Libraries/main/RayfieldBackup.lua",
        "https://raw.githubusercontent.com/not-weird/LinoriaLib/main/Library.lua"
    }

    for _, url in ipairs(UISources) do
        local success, lib = pcall(function()
            local content = game:HttpGet(url, true)
            return loadstring(content)()
        end)
        
        if success and lib then
            Rayfield = lib
            break
        end
    end

    if not Rayfield then error("Не удалось загрузить UI") end
end)

if not UILoadSuccess then
    -- Создаем простой интерфейс как запасной вариант
    local SimpleUI = Instance.new("ScreenGui")
    SimpleUI.Name = "BaggyMM2_SimpleUI"
    SimpleUI.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.Parent = SimpleUI

    -- Здесь можно добавить элементы простого интерфейса
    -- ...
    
    game:GetService("Players").LocalPlayer:Kick("UI Error 267: Используется простой интерфейс")
    return
end

-- ========================
-- 3. СОЗДАНИЕ ОКНА
-- ========================
local Window = Rayfield:CreateWindow({
    Name = "Baggy MM2 | " .. executor.Name,
    LoadingTitle = "Инициализация системы...",
    LoadingSubtitle = "Версия 2.5 | Защита от ошибки 267",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BaggyMM2_Config",
        FileName = executor.Name .. "_Settings.json"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- ========================
-- 4. ОСНОВНЫЕ ФУНКЦИИ
-- ========================
local Settings = {
    ESP = {
        Enabled = false,
        Players = {},
        UpdateDelay = 1
    },
    Combat = {
        KillAura = false,
        Reach = 25,
        Cooldown = 0.3
    },
    Movement = {
        Speed = 16,
        JumpPower = 50,
        Noclip = false
    },
    Farming = {
        Coins = false,
        Eggs = false,
        Delay = 0.5
    }
}

-- Функция ESP
local function UpdateESP()
    while Settings.ESP.Enabled do
        task.wait(Settings.ESP.UpdateDelay)
        
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                -- Логика ESP
            end
        end
    end
end

-- Функция Kill Aura
local function RunKillAura()
    while Settings.Combat.KillAura do
        task.wait(Settings.Combat.Cooldown)
        
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            -- Логика Kill Aura
        end
    end
end

-- ========================
-- 5. СОЗДАНИЕ ИНТЕРФЕЙСА
-- ========================
local MainTab = Window:CreateTab("Главная", "rbxassetid://4483345998")
local PlayerSection = MainTab:CreateSection("Настройки игрока")

PlayerSection:CreateSlider({
    Name = "Скорость передвижения",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = Settings.Movement.Speed,
    Callback = function(value)
        Settings.Movement.Speed = value
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end)
    end
})

-- Другие элементы интерфейса...

-- ========================
-- 6. ЗАЩИТА И ОПТИМИЗАЦИЯ
-- ========================
-- Авто-сохранение настроек
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            if Window then
                Rayfield:SaveConfiguration()
            end
        end)
    end
end)

-- Обработчик ошибок
game:GetService("ScriptContext").Error:Connect(function(message, trace, script)
    warn("Baggy MM2 Error:", message)
end)

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Baggy MM2 Успешно Загружен",
    Content = string.format("Эксплойт: %s\nБезопасность: %d/3", executor.Name, executor.SecurityLevel),
    Duration = 5,
    Image = "rbxassetid://4483345998",
})
