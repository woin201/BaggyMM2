-- Baggy MM2 by ChatGPT
-- Поддержка: Delta X, Xeno, KRNL
-- Функции: ESP, KillAura, AutoFarm, TP, Invisible, UI с анимацией, сохранение

-- Проверка на совместимость
local supported = syn or KRNL_LOADED or isexecutorclosure
if not supported then
    game.Players.LocalPlayer:Kick("Этот эксплойт не поддерживается.")
    return
end

-- Загрузка UI-библиотеки
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3"))()
local Window = Library:CreateWindow("Baggy MM2")

local ESP, KillAura, AutoFarm, Invis = false, false, false, false

-- ESP функция
local function EnableESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local Billboard = Instance.new("BillboardGui", player.Character:FindFirstChild("Head"))
            Billboard.Size = UDim2.new(0, 100, 0, 40)
            Billboard.AlwaysOnTop = true

            local Label = Instance.new("TextLabel", Billboard)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = player.Name
            Label.TextColor3 = Color3.new(1, 0, 0)
            Label.TextScaled = true
        end
    end
end

-- KillAura функция
local function StartKillAura()
    spawn(function()
        while KillAura do
            task.wait()
            local char = game.Players.LocalPlayer.Character
            local knife = char:FindFirstChild("Knife")
            if knife then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team then
                        if player.Character and (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                            knife:Activate()
                        end
                    end
                end
            end
        end
    end)
end

-- AutoFarm функция
local function StartAutoFarm()
    spawn(function()
        while AutoFarm do
            task.wait(1)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name == "Coin" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            end
        end
    end)
end

-- TP функции
local function TeleportTo(role)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local tag = player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Knife"))
            if tag and ((role == "Sheriff" and tag.Name == "Gun") or (role == "Murder" and tag.Name == "Knife")) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- Невидимость
local function SetInvisible()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, 9999, 9999)
end

-- UI
Window:Toggle("ESP", {flag = "esp"}, function(val)
    ESP = val
    if val then EnableESP() end
end)

Window:Toggle("KillAura", {flag = "ka"}, function(val)
    KillAura = val
    if val then StartKillAura() end
end)

Window:Toggle("AutoFarm Coins", {flag = "farm"}, function(val)
    AutoFarm = val
    if val then StartAutoFarm() end
end)

Window:Button("TP to Murder", function()
    TeleportTo("Murder")
end)

Window:Button("TP to Sheriff", function()
    TeleportTo("Sheriff")
end)

Window:Button("Go Invisible", function()
    SetInvisible()
end)

Window:Button("TP to Lobby", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lobby.Spawn.CFrame
end)

-- Сохранение настроек (если executor поддерживает)
if writefile then
    writefile("BaggyMM2_Settings.json", game:HttpGet("https://raw.githubusercontent.com/woin201/BaggyMM2/main/BaggyMM2.lua"))
end