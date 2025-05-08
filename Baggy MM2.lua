-- Baggy MM2 | Universal Edition
-- Поддержка: Delta X, Synapse X, KRNL, Fluxus
-- GitHub: https://github.com/woin201/BaggyMM2

--[[
  Улучшенная система проверки эксплойтов
  с поддержкой Delta X и других исполнителей
]]
local executor = {
    Name = "Unknown",
    Supported = false,
    DeltaMode = false
}

-- Определение эксплойта
if syn then
    executor.Name = "Synapse X"
    executor.Supported = true
elseif KRNL_LOADED then
    executor.Name = "KRNL"
    executor.Supported = true
elseif fluxus then
    executor.Name = "Fluxus"
    executor.Supported = true
elseif DELTA_LOADED or (identifyexecutor and identifyexecutor():lower():find("delta")) then
    executor.Name = "Delta X"
    executor.Supported = true
    executor.DeltaMode = true
elseif getexecutorname and getexecutorname():lower():find("delta") then
    executor.Name = "Delta X"
    executor.Supported = true
    executor.DeltaMode = true
end

if not executor.Supported then
    game:GetService("Players").LocalPlayer:Kick("Неподдерживаемый эксплойт\nТребуется: Synapse/KRNL/Fluxus/Delta X")
    return
end

-- Загрузка интерфейса с резервными источниками
local Rayfield
local uiLoadSuccess, uiError = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if not uiLoadSuccess then
    -- Попытка загрузить резервную версию
    uiLoadSuccess, uiError = pcall(function()
        Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/slrens/UI-Libraries/main/RayfieldBackup.lua"))()
    end)
    
    if not uiLoadSuccess then
        game:GetService("Players").LocalPlayer:Kick("Ошибка загрузки интерфейса: "..tostring(uiError))
        return
    end
end

-- Создание главного окна
local Window = Rayfield:CreateWindow({
    Name = "Baggy MM2 | "..executor.Name,
    LoadingTitle = "Инициализация...",
    LoadingSubtitle = "Версия 2.4 | Delta X Support",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BaggyMM2_Config",
        FileName = tostring(game.PlaceId).."_Settings.json"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink"
    },
    KeySystem = false
})

-- Уведомление о загрузке
Rayfield:Notify({
    Title = "Baggy MM2 Успешно Загружен",
    Content = "Используется: "..executor.Name,
    Duration = 4,
    Image = "rbxassetid://4483345998",
})

-- Основные настройки
local Settings = {
    ESP = {
        Enabled = false,
        Type = "Normal",
        Color = Color3.fromRGB(255, 50, 50),
        MaxDistance = 500
    },
    Combat = {
        KillAura = false,
        Reach = 25,
        Cooldown = 0.5
    },
    Movement = {
        Speed = 16,
        JumpPower = 50,
        Noclip = false
    },
    Farming = {
        Coins = false,
        Eggs = false,
        Delay = 1.0
    }
}

--[[ 
  Оптимизированная функция ESP 
  с поддержкой Delta X
]]
local ESP = {
    Objects = {},
    UpdateInterval = 1
}

function ESP:Add(player)
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "BaggyESP_"..player.Name
    highlight.FillColor = Settings.ESP.Color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    self.Objects[player] = highlight
end

function ESP:Remove(player)
    if self.Objects[player] then
        self.Objects[player]:Destroy()
        self.Objects[player] = nil
    end
end

function ESP:Update()
    for player, highlight in pairs(self.Objects) do
        if not player or not player.Character or not highlight then
            self:Remove(player)
        else
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - 
                            player.Character.HumanoidRootPart.Position).Magnitude
            highlight.Enabled = distance <= Settings.ESP.MaxDistance
        end
    end
end

-- Вкладка "Игрок"
local PlayerTab = Window:CreateTab("Игрок", "rbxassetid://3926305904")
local MovementSection = PlayerTab:CreateSection("Передвижение")

MovementSection:CreateSlider({
    Name = "Скорость",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = Settings.Movement.Speed,
    Callback = function(value)
        Settings.Movement.Speed = value
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

MovementSection:CreateSlider({
    Name = "Сила прыжка",
    Range = {50, 200},
    Increment = 5,
    Suffix = "power",
    CurrentValue = Settings.Movement.JumpPower,
    Callback = function(value)
        Settings.Movement.JumpPower = value
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

-- Вкладка "Визуал"
local VisualTab = Window:CreateTab("Визуал", "rbxassetid://3926307971")
local ESPSection = VisualTab:CreateSection("ESP")

ESPSection:CreateToggle({
    Name = "ESP игроков",
    CurrentValue = Settings.ESP.Enabled,
    Callback = function(state)
        Settings.ESP.Enabled = state
        if state then
            -- Включение ESP для всех игроков
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    ESP:Add(player)
                end
            end
            
            -- Обработка новых игроков
            game.Players.PlayerAdded:Connect(function(player)
                if Settings.ESP.Enabled then
                    player.CharacterAdded:Connect(function()
                        ESP:Add(player)
                    end)
                end
            end)
            
            -- Цикл обновления
            spawn(function()
                while Settings.ESP.Enabled do
                    ESP:Update()
                    task.wait(ESP.UpdateInterval)
                end
            end)
        else
            -- Отключение ESP
            for player in pairs(ESP.Objects) do
                ESP:Remove(player)
            end
        end
    end
})

-- Вкладка "Комбат"
local CombatTab = Window:CreateTab("Комбат", "rbxassetid://3926307971")
local KillAuraSection = CombatTab:CreateSection("Kill Aura")

KillAuraSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = Settings.Combat.KillAura,
    Callback = function(state)
        Settings.Combat.KillAura = state
        if state then
            spawn(function()
                while Settings.Combat.KillAura do
                    task.wait(Settings.Combat.Cooldown)
                    
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                        local knife = character:FindFirstChildOfClass("Tool") or character:FindFirstChild("Knife")
                        
                        if knife then
                            for _, player in ipairs(game.Players:GetPlayers()) do
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
            end)
        end
    end
})

-- Защита от ошибок
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if Settings.Movement.Speed then
        character:WaitForChild("Humanoid").WalkSpeed = Settings.Movement.Speed
    end
    if Settings.Movement.JumpPower then
        character:WaitForChild("Humanoid").JumpPower = Settings.Movement.JumpPower
    end
end)

-- Клавиша закрытия
local closeKey = executor.DeltaMode and Enum.KeyCode.F4 or Enum.KeyCode.RightShift
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == closeKey then
        Window:Destroy()
        Rayfield:Notify({
            Title = "Baggy MM2",
            Content = "Меню закрыто",
            Duration = 2,
        })
    end
end)

-- Авто-сохранение настроек
spawn(function()
    while task.wait(30) do
        pcall(function()
            if Window then
                Rayfield:SaveConfiguration()
            end
        end)
    end
end)
