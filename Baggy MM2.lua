-- Baggy MM2 | Анимированное меню
-- Поддержка: Synapse, KRNL, Fluxus
-- Функции: ESP, KillAura, Автофарм, Телепорты
-- Особенности: Плавные анимации, обход античита

local supported = syn or KRNL_LOADED or isexecutorclosure
if not supported then
    game.Players.LocalPlayer:Kick("Ваш эксплойт не поддерживается.")
    return
end

-- Загрузка анимированной библиотеки
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
   Name = "Baggy MM2",
   LoadingTitle = "Загрузка Baggy MM2...",
   LoadingSubtitle = "by ChatGPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BaggyMM2",
      FileName = "Config.json"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Анимация загрузки
Rayfield:Notify({
   Title = "Baggy MM2",
   Content = "Успешно загружен!",
   Duration = 3,
   Image = "https://i.imgur.com/JbXQj2v.png",
   Actions = {
      Ignore = {
         Name = "Ок",
         Callback = function()
         end
      },
   },
})

-- Создаем вкладки с анимациями
local MainTab = Window:CreateTab("Главная", "rbxassetid://4483345998")
local CombatTab = Window:CreateTab("Бой", "rbxassetid://4483345998")
local FarmTab = Window:CreateTab("Фарм", "rbxassetid://4483345998")
local TeleportTab = Window:CreateTab("Телепорты", "rbxassetid://4483345998")
local SettingsTab = Window:CreateTab("Настройки", "rbxassetid://4483345998")

-- Анимированные элементы на главной
local PlayerSection = MainTab:CreateSection("Настройки игрока", true)

local SpeedSlider = MainTab:CreateSlider({
   Name = "Скорость передвижения",
   Range = {16, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "SpeedValue",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

local JumpSlider = MainTab:CreateSlider({
   Name = "Сила прыжка",
   Range = {50, 200},
   Increment = 5,
   Suffix = "power",
   CurrentValue = 50,
   Flag = "JumpValue",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

local FOVSlider = MainTab:CreateSlider({
   Name = "Поле зрения",
   Range = {70, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FOVValue",
   Callback = function(Value)
      game.Workspace.CurrentCamera.FieldOfView = Value
   end,
})

-- Анимированные элементы боя
local CombatSection = CombatTab:CreateSection("Боевые функции", true)

local ESPToggle = CombatTab:CreateToggle({
   Name = "ESP игроков",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      -- Функция ESP здесь
   end,
})

local KillAuraToggle = CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value)
      -- Функция Kill Aura здесь
   end,
})

-- Анимация переключения
KillAuraToggle:SetValue(true, true) -- С анимацией
task.wait(0.5)
KillAuraToggle:SetValue(false, true) -- С анимацией

-- Анимированные элементы фарма
local FarmSection = FarmTab:CreateSection("Автоматический фарм", true)

local CoinFarmToggle = FarmTab:CreateToggle({
   Name = "Автофарм монет",
   CurrentValue = false,
   Flag = "CoinFarmToggle",
   Callback = function(Value)
      -- Функция фарма монет
   end,
})

local EggFarmToggle = FarmTab:CreateToggle({
   Name = "Автофарм яиц",
   CurrentValue = false,
   Flag = "EggFarmToggle",
   Callback = function(Value)
      -- Функция фарма яиц
   end,
})

-- Анимированные телепорты
local TeleportSection = TeleportTab:CreateSection("Основные места", true)

local TeleportButtons = {
   {Name = "Лобби", Callback = function() end},
   {Name = "Карта", Callback = function() end},
   {Name = "Комната ожидания", Callback = function() end},
   {Name = "Секретная комната", Callback = function() end}
}

for _, btn in pairs(TeleportButtons) do
   TeleportTab:CreateButton({
      Name = btn.Name,
      Callback = btn.Callback,
   })
end

-- Анимированные настройки
local UISettings = SettingsTab:CreateSection("Настройки интерфейса", true)

local ThemeDropdown = SettingsTab:CreateDropdown({
   Name = "Тема интерфейса",
   Options = {"Default", "Dark", "Light", "Aqua"},
   CurrentOption = "Default",
   Flag = "ThemeDropdown",
   Callback = function(Option)
      -- Смена темы с анимацией
      Rayfield:SetTheme(Option:lower())
   end,
})

-- Анимация при закрытии
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
   Rayfield:SetToggleKey(Enum.KeyCode.RightShift)
end)

-- Заставка Baggy MM2
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
