-- Baggy MM2 Script (UI + функции) -- Совместим с Delta X, KRNL, Xeno 2.0

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))() local Window = OrionLib:MakeWindow({Name = "BAGGY MM2", HidePremium = false, IntroText = "BAGGY MM2", SaveConfig = true, ConfigFolder = "BaggyMM2CFG"})

-- MAIN TAB local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddButton({ Name = "Blurt Murder", Callback = function() for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer and player:FindFirstChild("Backpack") then if player.Backpack:FindFirstChild("Knife") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame end end end end })

MainTab:AddButton({ Name = "Blurt Sheriff", Callback = function() for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer and player:FindFirstChild("Backpack") then if player.Backpack:FindFirstChild("Gun") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame end end end end })

MainTab:AddToggle({ Name = "Player's ESP", Default = false, Callback = function(state) if state then loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))() end end })

-- COMBAT TAB local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({ Name = "Kill Aura", Default = false, Callback = function(state) _G.KillAura = state while _G.KillAura do task.wait(0.2) for _, player in pairs(game.Players:GetPlayers()) do if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude if distance < 10 then game:GetService("ReplicatedStorage").Remotes.Throw:FireServer(player.Character.HumanoidRootPart.Position) end end end end end })

-- AUTOFARM TAB local AutoTab = Window:MakeTab({Name = "Autofarm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

AutoTab:AddToggle({ Name = "Autofarm Coins", Default = false, Callback = function(state) _G.Farm = state while _G.Farm do task.wait(1) for _, v in pairs(workspace:GetChildren()) do if v:IsA("Part") and v.Name == "Coin" then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame wait(0.3) end end end end })

-- TELEPORTS TAB local TP = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TP:AddButton({ Name = "Teleport to Map", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0) end })

TP:AddButton({ Name = "Teleport to Lobby", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(50, 100, 50) end })

TP:AddButton({ Name = "Teleport to Waiting Room", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 100, -100) end })

TP:AddButton({ Name = "Teleport to Secret Room", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999, 999, 999) end })

OrionLib:Init()

