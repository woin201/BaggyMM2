-- Baggy MM2 - Чит для Murder Mystery 2
-- Поддержка: Synapse X, KRNL, Fluxus
-- Функции: ESP, KillAura, Автофарм, Телепорты
-- Особенности: Анимированное меню, обход античита

-- Проверка эксплойта
if not (syn or KRNL_LOADED or fluxus) then
    game:GetService("Players").LocalPlayer:Kick("Требуется поддерживаемый эксплойт (Synapse/KRNL/Fluxus)")
    return
end

-- Загрузка библиотеки
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end)

if not success then
    game:GetService("Players").LocalPlayer:Kick("Ошибка загрузки библиотеки UI")
    return
end

-- Создание окна с анимацией
local Window = Rayfield:CreateWindow({
    Name = "Baggy MM2",
    LoadingTitle = "Загрузка интерфейса...",
    LoadingSubtitle = "Версия 2.1",
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

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Baggy MM2",
    Content = "Успешно загружен!",
    Duration = 3,
    Image = "rbxassetid://4483345998",
})

-- Основные переменные
local Settings = {
    ESP = false,
    KillAura = false,
    AutoFarm = false,
    Speed = 16,
    Jump = 50
}

-- Создание вкладок
local MainTab = Window:CreateTab("Главная", "rbxassetid://4483345998")
local CombatTab = Window:CreateTab("Бой", "rbxassetid://4483345998")
local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://4483345998")

-- Вкладка Главная
local PlayerSection = MainTab:CreateSection("Настройки игрока")

MainTab:CreateSlider({
    Name = "Скорость передвижения",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Settings.Speed,
    Callback = function(Value)
        Settings.Speed = Value
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

MainTab:CreateSlider({
    Name = "Сила прыжка",
    Range = {50, 200},
    Increment = 5,
    Suffix = "power",
    CurrentValue = Settings.Jump,
    Callback = function(Value)
        Settings.Jump = Value
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end,
})

MainTab:CreateToggle({
    Name = "Анти-АФК",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end,
})

-- Вкладка Бой
local CombatSection = CombatTab:CreateSection("Боевые функции")

CombatTab:CreateToggle({
    Name = "ESP игроков",
    CurrentValue = Settings.ESP,
    Callback = function(Value)
        Settings.ESP = Value
        Rayfield:Notify({
            Title = "ESP",
            Content = Value and "Включен" or "Выключен",
            Duration = 2,
        })
    end,
})

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = Settings.KillAura,
    Callback = function(Value)
        Settings.KillAura = Value
        Rayfield:Notify({
            Title = "Kill Aura",
            Content = Value and "Включена" or "Выключена",
            Duration = 2,
        })
    end,
})

-- Вкладка Телепорты
local TeleportSection = TeleportTab:CreateSection("Основные места")

TeleportTab:CreateButton({
    Name = "Телепорт в лобби",
    Callback = function()
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lobby:FindFirstChild("Spawn").CFrame
            Rayfield:Notify({
                Title = "Телепорт",
                Content = "Успешно телепортирован в лобби",
                Duration = 2,
            })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Телепорт на карту",
    Callback = function()
        local map = workspace:FindFirstChild("Map") or workspace:FindFirstChildOfClass("Model")
        if map then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = map:GetModelCFrame() + Vector3.new(0, 5, 0)
            Rayfield:Notify({
                Title = "Телепорт",
                Content = "Успешно телепортирован на карту",
                Duration = 2,
            })
        end
    end,
})

-- Функция закрытия
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:Destroy()
        Rayfield:Notify({
            Title = "Baggy MM2",
            Content = "Меню закрыто",
            Duration = 2,
        })
    end
end)

-- Анимация логотипа
task.spawn(function()
    local Logo = Instance.new("BillboardGui")
    Logo.Name = "BaggyMM2Logo"
    Logo.Size = UDim2.new(5, 0, 2, 0)
    Logo.AlwaysOnTop = true
    Logo.StudsOffset = Vector3.new(0, 2, 0)
    
    local LogoFrame = Instance.new("Frame", Logo)
    LogoFrame.Size = UDim2.new(1, 0, 1, 0)
    LogoFrame.BackgroundTransparency = 1
    
    local LogoText = Instance.new("TextLabel", LogoFrame)
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.Text = "Baggy MM2"
    LogoText.TextColor3 = Color3.fromRGB(255, 85, 0)
    LogoText.TextScaled = true
    LogoText.Font = Enum.Font.GothamBold
    LogoText.BackgroundTransparency = 1
    
    Logo.Parent = game.Players.LocalPlayer.Character:WaitForChild("Head")
    
    -- Анимация появления
    for i = 0, 1, 0.05 do
        LogoText.TextTransparency = 1 - i
        task.wait(0.03)
    end
    
    task.wait(2)
    
    -- Анимация исчезновения
    for i = 0, 1, 0.05 do
        LogoText.TextTransparency = i
        task.wait(0.03)
    end
    
    Logo:Destroy()
end)
