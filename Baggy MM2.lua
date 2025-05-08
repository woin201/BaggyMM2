-- Baggy MM2 Ultimate | Delta X Support + Error Fix
-- Полная сборка всех функций с исправлением ошибок
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

-- ========================
-- 3. СОЗДАНИЕ ИНТЕРФЕЙСА
-- ========================
if UILoadSuccess and Rayfield then
    -- Основной интерфейс Rayfield
    local Window = Rayfield:CreateWindow({
        Name = "Baggy MM2 | " .. executor.Name,
        LoadingTitle = "Инициализация системы...",
        LoadingSubtitle = "Версия 2.6 | Полная сборка",
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
            UpdateDelay = 1,
            Color = Color3.fromRGB(255, 50, 50)
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
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not Settings.ESP.Players[player] then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESP_"..player.Name
                            highlight.FillColor = Settings.ESP.Color
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = player.Character
                            Settings.ESP.Players[player] = highlight
                        end
                    elseif Settings.ESP.Players[player] then
                        Settings.ESP.Players[player]:Destroy()
                        Settings.ESP.Players[player] = nil
                    end
                end
            end
        end
    end

    -- Функция Kill Aura
    local function RunKillAura()
        while Settings.Combat.KillAura do
            task.wait(Settings.Combat.Cooldown)
            
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local knife = character:FindFirstChildOfClass("Tool") or character:FindFirstChild("Knife")
                
                if knife then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            local targetChar = player.Character
                            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                                local distance = (character.HumanoidRootPart.Position - 
                                               targetChar.HumanoidRootPart.Position).Magnitude
                                
                                if distance <= Settings.Combat.Reach then
                                    knife:Activate()
                                    task.wait(0.1)
                                    knife:Deactivate()
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- ========================
    -- 5. СОЗДАНИЕ ВКЛАДОК
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

    PlayerSection:CreateSlider({
        Name = "Сила прыжка",
        Range = {50, 200},
        Increment = 5,
        CurrentValue = Settings.Movement.JumpPower,
        Callback = function(value)
            Settings.Movement.JumpPower = value
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end)
        end
    })

    -- Вкладка Визуал
    local VisualTab = Window:CreateTab("Визуал", "rbxassetid://3926307971")
    local ESPSection = VisualTab:CreateSection("ESP")

    ESPSection:CreateToggle({
        Name = "ESP игроков",
        CurrentValue = Settings.ESP.Enabled,
        Callback = function(state)
            Settings.ESP.Enabled = state
            if state then
                spawn(UpdateESP)
            else
                for player, highlight in pairs(Settings.ESP.Players) do
                    highlight:Destroy()
                end
                Settings.ESP.Players = {}
            end
        end
    })

    -- Вкладка Комбат
    local CombatTab = Window:CreateTab("Комбат", "rbxassetid://3926307971")
    local KillAuraSection = CombatTab:CreateSection("Kill Aura")

    KillAuraSection:CreateToggle({
        Name = "Kill Aura",
        CurrentValue = Settings.Combat.KillAura,
        Callback = function(state)
            Settings.Combat.KillAura = state
            if state then
                spawn(RunKillAura)
            end
        end
    })

    -- Уведомление о загрузке
    Rayfield:Notify({
        Title = "Baggy MM2 Успешно Загружен",
        Content = string.format("Эксплойт: %s\nБезопасность: %d/3", executor.Name, executor.SecurityLevel),
        Duration = 5,
        Image = "rbxassetid://4483345998",
    })

else
    -- ========================
    -- АВАРИЙНЫЙ ИНТЕРФЕЙС
    -- ========================
    local function CreateSimpleUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BaggyMM2_SimpleUI"
        if executor.Name == "Synapse X" then
            syn.protect_gui(ScreenGui)
        end
        ScreenGui.Parent = game:GetService("CoreGui")
        
        -- Основной фрейм
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        MainFrame.Parent = ScreenGui
        
        -- Заголовок
        local Title = Instance.new("TextLabel")
        Title.Text = "Baggy MM2 (Simple Mode)"
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        Title.Parent = MainFrame
        
        -- Кнопка ESP
        local ESPButton = Instance.new("TextButton")
        ESPButton.Text = "Toggle ESP"
        ESPButton.Size = UDim2.new(0.9, 0, 0, 40)
        ESPButton.Position = UDim2.new(0.05, 0, 0.15, 0)
        ESPButton.Parent = MainFrame
        
        -- Кнопка Speed
        local SpeedButton = Instance.new("TextButton")
        SpeedButton.Text = "Speed Hack"
        SpeedButton.Size = UDim2.new(0.9, 0, 0, 40)
        SpeedButton.Position = UDim2.new(0.05, 0, 0.30, 0)
        SpeedButton.Parent = MainFrame
        
        -- Функционал кнопок
        local espEnabled = false
        local highlights = {}
        
        ESPButton.MouseButton1Click:Connect(function()
            espEnabled = not espEnabled
            if espEnabled then
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(255, 50, 50)
                        highlight.Parent = player.Character
                        highlights[player] = highlight
                    end
                end
            else
                for player, highlight in pairs(highlights) do
                    highlight:Destroy()
                end
                highlights = {}
            end
        end)
        
        SpeedButton.MouseButton1Click:Connect(function()
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if humanoid.WalkSpeed == 16 then
                    humanoid.WalkSpeed = 50
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end)
        
        -- Уведомление
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Baggy MM2",
            Text = "Используется простой интерфейс",
            Duration = 5
        })
    end

    CreateSimpleUI()
end

-- Защита от ошибок
game:GetService("ScriptContext").Error:Connect(function(message, trace, script)
    warn("Baggy MM2 Error:", message)
end)
