-- Baggy MM2 | Версия UI как на Cxlt GUI -- Поддержка: Delta X, KRNL, Xeno -- Автор: @woin201 + ChatGPT

-- Библиотека для UI local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxScriptHub/UI-Libs/main/CxltHub.lua"))() local Window = Library:Window("Baggy MM2", Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightControl)

-- Флаги local ESP, KillAura, AutoFarm, Invis = false, false, false, false

-- ESP local function EnableESP() for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then local Billboard = Instance.new("BillboardGui", player.Character.Head) Billboard.Name = "BaggyESP" Billboard.Size = UDim2.new(0, 100, 0, 40) Billboard.AlwaysOnTop = true local Label = Instance.new("TextLabel", Billboard) Label.Size = UDim2.new(1, 0, 1, 0) Label.BackgroundTransparency = 1 Label.Text = player.Name Label.TextColor3 = Color3.new(1, 0, 0) Label.TextScaled = true end end end

-- KillAura local function StartKillAura() task.spawn(function() while KillAura and task.wait() do local char = game.Players.LocalPlayer.Character local knife = char and char:FindFirstChildOfClass("Tool") if knife then for _, plr in pairs(game.Players:GetPlayers()) do if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude if dist <= 15 then game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame) knife:Activate() end end end end end end) end

-- AutoFarm local function StartAutoFarm() task.spawn(function() while AutoFarm and task.wait(1) do for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("Part") and obj.Name == "Coin" then game.Players.LocalPlayer.Character:PivotTo(obj.CFrame) end end end end) end

-- Телепорт к роли local function TeleportToRole(role) for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer and player.Character then local hasRole = (role == "Murder" and player.Backpack:FindFirstChild("Knife")) or (role == "Sheriff" and player.Backpack:FindFirstChild("Gun")) if hasRole then game.Players.LocalPlayer.Character:PivotTo(player.Character:GetPivot() + Vector3.new(0, 5, 0)) end end end end

-- Невидимость local function SetInvisible() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, 9999, 9999) end

-- Сохраняем GUI настройки (если поддерживается) if writefile and readfile then local settings = {ESP = ESP, KillAura = KillAura, AutoFarm = AutoFarm, Invis = Invis} writefile("BaggyMM2_Settings.json", game:GetService("HttpService"):JSONEncode(settings)) end

-- Страницы и вкладки local MainTab = Window:Tab("Главное") MainTab:Toggle("ESP", false, function(state) ESP = state if state then EnableESP() end end)

MainTab:Toggle("KillAura", false, function(state) KillAura = state if state then StartKillAura() end end)

MainTab:Toggle("AutoFarm Coins", false, function(state) AutoFarm = state if state then StartAutoFarm() end end)

MainTab:Button("TP к Murder", function() TeleportToRole("Murder") end)

MainTab:Button("TP к Sheriff", function() TeleportToRole("Sheriff") end)

MainTab:Button("TP в Лобби", function() if workspace:FindFirstChild("Lobby") then game.Players.LocalPlayer.Character:PivotTo(workspace.Lobby.Spawn.CFrame) end end)

MainTab:Button("Невидимость", function() SetInvisible() end)

MainTab:Label("Telegram: @AKKAYNT_CKAMEPA")

-- Готово!

