-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local ESP_ENABLED = false
local SPEED_ENABLED = false
local SPEED_VALUE = 24 -- vitesse par défaut (16 = normal)

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AetherHub"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 220)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "AETHER HUB V1"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

-- ESP BUTTON
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.fromOffset(200, 36)
espBtn.Position = UDim2.fromOffset(30, 50)
espBtn.Text = "ESP : OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14
espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Parent = main
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 8)

-- SPEED BUTTON
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.fromOffset(200, 36)
speedBtn.Position = UDim2.fromOffset(30, 95)
speedBtn.Text = "SPEED : OFF"
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 14
speedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)
speedBtn.Parent = main
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 8)

-- SPEED INPUT
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.fromOffset(200, 32)
speedBox.Position = UDim2.fromOffset(30, 140)
speedBox.PlaceholderText = "Vitesse (ex: 24)"
speedBox.Text = tostring(SPEED_VALUE)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.ClearTextOnFocus = false
speedBox.Parent = main
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

-- =========================
-- DRAG MENU
-- =========================
local dragging, dragStart, startPos = false

main.InputBegan:Connect(function(input)
 	if input.UserInputType == Enum.UserInputType.MouseButton1
 	or input.UserInputType == Enum.UserInputType.Touch then
 		dragging = true
 		dragStart = input.Position
 		startPos = main.Position
 	end
end)

main.InputEnded:Connect(function(input)
 	if input.UserInputType == Enum.UserInputType.MouseButton1
 	or input.UserInputType == Enum.UserInputType.Touch then
 		dragging = false
 	end
end)

UserInputService.InputChanged:Connect(function(input)
 	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
 	or input.UserInputType == Enum.UserInputType.Touch) then
 		local delta = input.Position - dragStart
 		main.Position = UDim2.new(
 			startPos.X.Scale, startPos.X.Offset + delta.X,
 			startPos.Y.Scale, startPos.Y.Offset + delta.Y
 		)
 	end
end)

-- =========================
-- ESP FUNCTIONS
-- =========================
local function addHighlight(player)
 	if player == LocalPlayer or not ESP_ENABLED then return end
 	if not player.Character or player.Character:FindFirstChild("PlayerHighlight") then return end

 	local h = Instance.new("Highlight")
 	h.Name = "PlayerHighlight"
 	h.Adornee = player.Character
 	h.FillColor = Color3.fromRGB(255, 0, 0)
 	h.OutlineColor = Color3.fromRGB(255, 255, 255)
 	h.FillTransparency = 0.5
 	h.Parent = player.Character
end

local function addLine(player)
 	if player == LocalPlayer or not ESP_ENABLED then return end
 	if not LocalPlayer.Character or not player.Character then return end

 	local hrp1 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
 	local hrp2 = player.Character:FindFirstChild("HumanoidRootPart")
 	if not hrp1 or not hrp2 then return end

 	local att1 = hrp1:FindFirstChild("Aether_Att1") or Instance.new("Attachment", hrp1)
 	att1.Name = "Aether_Att1"
 	local att2 = hrp2:FindFirstChild("Aether_Att2") or Instance.new("Attachment", hrp2)
 	att2.Name = "Aether_Att2"

 	if hrp1:FindFirstChild("AetherLine_" .. player.Name) then return end

 	local beam = Instance.new("Beam")
 	beam.Name = "AetherLine_" .. player.Name
 	beam.Attachment0 = att1
 	beam.Attachment1 = att2
 	beam.Width0, beam.Width1 = 0.35, 0.35
 	beam.Color = ColorSequence.new(Color3.fromRGB(0, 120, 255))
 	beam.LightEmission = 1
 	beam.FaceCamera = true
 	beam.Parent = hrp1
end

local function clearESP()
 	for _, p in pairs(Players:GetPlayers()) do
 		if p.Character then
 			local h = p.Character:FindFirstChild("PlayerHighlight")
 			if h then h:Destroy() end
 		end
 	end
 	if LocalPlayer.Character then
 		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
 			if v:IsA("Beam") and v.Name:find("AetherLine_") then
 				v:Destroy()
 			end
 		end
 	end
end

local function applyESP()
 	for _, p in pairs(Players:GetPlayers()) do
 		addHighlight(p)
 		addLine(p)
 	end
end

-- =========================
-- SPEED FUNCTIONS
-- =========================
local function applySpeed()
 	local char = LocalPlayer.Character
 	if not char then return end
 	local hum = char:FindFirstChildOfClass("Humanoid")
 	if not hum then return end
 	hum.WalkSpeed = SPEED_ENABLED and SPEED_VALUE or 16
end

speedBox.FocusLost:Connect(function()
 	local v = tonumber(speedBox.Text)
 	if v then
 		SPEED_VALUE = math.clamp(v, 16, 200)
 		if SPEED_ENABLED then applySpeed() end
 	end
end)

-- =========================
-- BUTTONS
-- =========================
espBtn.MouseButton1Click:Connect(function()
 	ESP_ENABLED = not ESP_ENABLED
 	if ESP_ENABLED then
 		espBtn.Text = "ESP : ON"
 		espBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
 		applyESP()
 	else
 		espBtn.Text = "ESP : OFF"
 		espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
 		clearESP()
 	end
end)

speedBtn.MouseButton1Click:Connect(function()
 	SPEED_ENABLED = not SPEED_ENABLED
 	if SPEED_ENABLED then
 		speedBtn.Text = "SPEED : ON"
 		speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
 	else
 		speedBtn.Text = "SPEED : OFF"
 		speedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
 	end
 	applySpeed()
end)

-- Respawn support
LocalPlayer.CharacterAdded:Connect(function()
 	task.wait(0.5)
 	applySpeed()
 	if ESP_ENABLED then applyESP() end
end)