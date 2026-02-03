-- AETHER HUB V11 - SAFE VERSION (NO AUTO RESPAWN)
-- Client-side safe

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Wait for character to load
repeat task.wait() until LocalPlayer.Character

-- Configurations
local ESPEnabled = false
local ESPShowDistance = false
local ESPShowNames = false
local WallhackEnabled = false
local SpeedEnabled = false
local StealBoostEnabled = false
local GrabAssistEnabled = false
local AntiKBEnabled = false
local AntiRagdollEnabled = false
local AutoGrabEnabled = false  
local WalkSpeedValue = 24
local StealSpeedValue = 27
local JumpPowerValue = 50
local AutoGrabRange = 20  -- Distance réduite pour pas lag
local ESPObjects = {}
local WallhackObjects = {}

-- Configurations Wallhack Optimisé
local WallhackMode = "Smart"
local WallhackTransparency = 0.85
local MinPartSize = 5
local WallhackUpdateRate = 2

-- Cache pour éviter de re-scanner constamment
local CachedParts = {}
local LastScan = 0
local SCAN_INTERVAL = 10

-- UI Colors
local MainColor = Color3.fromRGB(120,0,180)
local TabColor = Color3.fromRGB(90,0,130)
local TabHover = Color3.fromRGB(130,0,180)
local TextColor = Color3.fromRGB(255,200,255)

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AETHERHUB"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(500,400)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = MainColor
Main.BackgroundTransparency = 0.4
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,15)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "AETHER HUB V11 - SAFE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = TextColor
Title.BackgroundTransparency = 1

----------------------------------------------------------------
-- BARRE DE PROGRESSION AUTO GRAB 🧲
----------------------------------------------------------------
local GrabIndicator = Instance.new("Frame", ScreenGui)
GrabIndicator.Size = UDim2.fromOffset(300, 8)
GrabIndicator.Position = UDim2.new(0.5, -150, 0.85, 0)
GrabIndicator.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
GrabIndicator.BorderSizePixel = 0
GrabIndicator.Visible = false
GrabIndicator.ZIndex = 10
Instance.new("UICorner", GrabIndicator).CornerRadius = UDim.new(0, 4)

local GrabFill = Instance.new("Frame", GrabIndicator)
GrabFill.Size = UDim2.fromScale(0, 1)
GrabFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
GrabFill.BorderSizePixel = 0
GrabFill.ZIndex = 11
Instance.new("UICorner", GrabFill).CornerRadius = UDim.new(0, 4)

local GrabText = Instance.new("TextLabel", GrabIndicator)
GrabText.Size = UDim2.fromScale(1, 1)
GrabText.BackgroundTransparency = 1
GrabText.Text = "🧲 Grabbing..."
GrabText.Font = Enum.Font.GothamBold
GrabText.TextSize = 12
GrabText.TextColor3 = Color3.new(1, 1, 1)
GrabText.ZIndex = 12

-- Fonction pour afficher la barre de progression
local function showGrabProgress()
	GrabIndicator.Visible = true
	GrabFill.Size = UDim2.fromScale(0, 1)
	
	-- Animation de remplissage
	TweenService:Create(GrabFill, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
		Size = UDim2.fromScale(1, 1)
	}):Play()
	
	-- Cache après 1 seconde
	task.delay(1, function()
		GrabIndicator.Visible = false
	end)
end
----------------------------------------------------------------

-- Tabs
local Tabs = Instance.new("Frame", Main)
Tabs.Position = UDim2.fromOffset(10,50)
Tabs.Size = UDim2.fromOffset(150,340)
Tabs.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromOffset(170,50)
Content.Size = UDim2.fromOffset(320,340)
Content.BackgroundTransparency = 1

-- Helper functions
local function createTabButton(text,y)
	local b = Instance.new("TextButton", Tabs)
	b.Size = UDim2.fromOffset(150,40)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = TabColor
	Instance.new("UICorner",b)
	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=TabHover}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=TabColor}):Play()
	end)
	return b
end

local FeaturesTab = createTabButton("Features",0)
local VisualTab = createTabButton("Visual",50)

-- Pages
local Pages = {}
local function createPage(name)
	local f = Instance.new("Frame", Content)
	f.Size = UDim2.fromScale(1,1)
	f.BackgroundTransparency = 0.6
	f.BackgroundColor3 = Color3.fromRGB(80,0,140)
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
	f.Visible = false
	Pages[name] = f
	return f
end

local FeaturesPage = createPage("Features")
local VisualPage = createPage("Visual")
FeaturesPage.Visible = true

local function switchPage(name)
	for _,v in pairs(Pages) do v.Visible = false end
	Pages[name].Visible = true
end

FeaturesTab.MouseButton1Click:Connect(function() switchPage("Features") end)
VisualTab.MouseButton1Click:Connect(function() switchPage("Visual") end)

-- Toggle helper
local function createToggle(parent,text,y,callback)
	local b = Instance.new("TextButton",parent)
	b.Size = UDim2.fromOffset(240,40)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(70,0,120)
	Instance.new("UICorner",b)
	local state=false
	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = text.." : "..(state and "ON" or "OFF")
		callback(state)
	end)
	return b
end

-- Features
createToggle(FeaturesPage,"Auto Grab 🧲",0,function(v) AutoGrabEnabled=v end)
createToggle(FeaturesPage,"Grab Assist",50,function(v) GrabAssistEnabled=v end)
createToggle(FeaturesPage,"Anti-Knockback",100,function(v) AntiKBEnabled=v end)
createToggle(FeaturesPage,"Anti-Ragdoll",150,function(v) AntiRagdollEnabled=v end)

-- Visual
createToggle(VisualPage,"ESP",0,function(v) ESPEnabled=v end)
createToggle(VisualPage,"ESP Distance",50,function(v) ESPShowDistance=v end)
createToggle(VisualPage,"ESP Names",100,function(v) ESPShowNames=v end)
createToggle(VisualPage,"Wallhack",150,function(v) WallhackEnabled=v end)

-- Aether Booster - Menu complet avec Speed et Steal Boost
local AetherBooster = Instance.new("Frame", ScreenGui)
AetherBooster.Size = UDim2.fromOffset(260,400)
AetherBooster.Position = UDim2.fromScale(0.7,0.5)
AetherBooster.AnchorPoint = Vector2.new(0.5,0.5)
AetherBooster.BackgroundColor3 = MainColor
AetherBooster.BackgroundTransparency = 0.4
AetherBooster.BorderSizePixel = 0
AetherBooster.Active = true
AetherBooster.Draggable = true
Instance.new("UICorner", AetherBooster)
AetherBooster.Visible = false

-- Titre Aether Booster
local BoosterTitle = Instance.new("TextLabel", AetherBooster)
BoosterTitle.Size = UDim2.new(1,0,0,35)
BoosterTitle.Text = "⚡ AETHER BOOSTER ⚡"
BoosterTitle.Font = Enum.Font.GothamBold
BoosterTitle.TextSize = 16
BoosterTitle.TextColor3 = TextColor
BoosterTitle.BackgroundTransparency = 1

-- Toggle Speed Boost
local SpeedBoostToggle = Instance.new("TextButton", AetherBooster)
SpeedBoostToggle.Size = UDim2.fromOffset(240,35)
SpeedBoostToggle.Position = UDim2.fromOffset(10,45)
SpeedBoostToggle.Text = "Speed Boost : OFF"
SpeedBoostToggle.Font = Enum.Font.Gotham
SpeedBoostToggle.TextSize = 14
SpeedBoostToggle.TextColor3 = Color3.new(1,1,1)
SpeedBoostToggle.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",SpeedBoostToggle)
SpeedBoostToggle.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	SpeedBoostToggle.Text = "Speed Boost : "..(SpeedEnabled and "ON" or "OFF")
end)

-- Speed controls
local SpeedLabel = Instance.new("TextLabel", AetherBooster)
SpeedLabel.Size = UDim2.fromOffset(240,25)
SpeedLabel.Position = UDim2.fromOffset(10,90)
SpeedLabel.Text = "Speed: 24"
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1

local SpeedMinus = Instance.new("TextButton", AetherBooster)
SpeedMinus.Size = UDim2.fromOffset(70,30)
SpeedMinus.Position = UDim2.fromOffset(10,120)
SpeedMinus.Text = "- 1"
SpeedMinus.Font = Enum.Font.GothamBold
SpeedMinus.TextSize = 16
SpeedMinus.TextColor3 = Color3.new(1,1,1)
SpeedMinus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",SpeedMinus)
SpeedMinus.MouseButton1Click:Connect(function()
	WalkSpeedValue = math.max(24, WalkSpeedValue - 1)
	SpeedLabel.Text = "Speed: "..WalkSpeedValue
end)

local SpeedPlus = Instance.new("TextButton", AetherBooster)
SpeedPlus.Size = UDim2.fromOffset(70,30)
SpeedPlus.Position = UDim2.fromOffset(90,120)
SpeedPlus.Text = "+ 1"
SpeedPlus.Font = Enum.Font.GothamBold
SpeedPlus.TextSize = 16
SpeedPlus.TextColor3 = Color3.new(1,1,1)
SpeedPlus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",SpeedPlus)
SpeedPlus.MouseButton1Click:Connect(function()
	WalkSpeedValue = math.min(50, WalkSpeedValue + 1)
	SpeedLabel.Text = "Speed: "..WalkSpeedValue
end)

local SpeedPlus5 = Instance.new("TextButton", AetherBooster)
SpeedPlus5.Size = UDim2.fromOffset(70,30)
SpeedPlus5.Position = UDim2.fromOffset(170,120)
SpeedPlus5.Text = "+ 5"
SpeedPlus5.Font = Enum.Font.GothamBold
SpeedPlus5.TextSize = 16
SpeedPlus5.TextColor3 = Color3.new(1,1,1)
SpeedPlus5.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",SpeedPlus5)
SpeedPlus5.MouseButton1Click:Connect(function()
	WalkSpeedValue = math.min(50, WalkSpeedValue + 5)
	SpeedLabel.Text = "Speed: "..WalkSpeedValue
end)

-- Toggle Steal Boost
local StealBoostToggle = Instance.new("TextButton", AetherBooster)
StealBoostToggle.Size = UDim2.fromOffset(240,35)
StealBoostToggle.Position = UDim2.fromOffset(10,165)
StealBoostToggle.Text = "Steal Boost : OFF"
StealBoostToggle.Font = Enum.Font.Gotham
StealBoostToggle.TextSize = 14
StealBoostToggle.TextColor3 = Color3.new(1,1,1)
StealBoostToggle.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",StealBoostToggle)
StealBoostToggle.MouseButton1Click:Connect(function()
	StealBoostEnabled = not StealBoostEnabled
	StealBoostToggle.Text = "Steal Boost : "..(StealBoostEnabled and "ON" or "OFF")
end)

-- Steal Speed controls
local StealLabel = Instance.new("TextLabel", AetherBooster)
StealLabel.Size = UDim2.fromOffset(240,25)
StealLabel.Position = UDim2.fromOffset(10,210)
StealLabel.Text = "Steal Speed: 27"
StealLabel.Font = Enum.Font.GothamBold
StealLabel.TextSize = 14
StealLabel.TextColor3 = Color3.new(1,1,1)
StealLabel.BackgroundTransparency = 1

local StealMinus = Instance.new("TextButton", AetherBooster)
StealMinus.Size = UDim2.fromOffset(70,30)
StealMinus.Position = UDim2.fromOffset(10,240)
StealMinus.Text = "- 1"
StealMinus.Font = Enum.Font.GothamBold
StealMinus.TextSize = 16
StealMinus.TextColor3 = Color3.new(1,1,1)
StealMinus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",StealMinus)
StealMinus.MouseButton1Click:Connect(function()
	StealSpeedValue = math.max(24, StealSpeedValue - 1)
	StealLabel.Text = "Steal Speed: "..StealSpeedValue
end)

local StealPlus = Instance.new("TextButton", AetherBooster)
StealPlus.Size = UDim2.fromOffset(70,30)
StealPlus.Position = UDim2.fromOffset(90,240)
StealPlus.Text = "+ 1"
StealPlus.Font = Enum.Font.GothamBold
StealPlus.TextSize = 16
StealPlus.TextColor3 = Color3.new(1,1,1)
StealPlus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",StealPlus)
StealPlus.MouseButton1Click:Connect(function()
	StealSpeedValue = math.min(35, StealSpeedValue + 1)
	StealLabel.Text = "Steal Speed: "..StealSpeedValue
end)

local StealPlus5 = Instance.new("TextButton", AetherBooster)
StealPlus5.Size = UDim2.fromOffset(70,30)
StealPlus5.Position = UDim2.fromOffset(170,240)
StealPlus5.Text = "+ 5"
StealPlus5.Font = Enum.Font.GothamBold
StealPlus5.TextSize = 16
StealPlus5.TextColor3 = Color3.new(1,1,1)
StealPlus5.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",StealPlus5)
StealPlus5.MouseButton1Click:Connect(function()
	StealSpeedValue = math.min(35, StealSpeedValue + 5)
	StealLabel.Text = "Steal Speed: "..StealSpeedValue
end)

-- Jump controls
local JumpLabel = Instance.new("TextLabel", AetherBooster)
JumpLabel.Size = UDim2.fromOffset(240,25)
JumpLabel.Position = UDim2.fromOffset(10,285)
JumpLabel.Text = "Jump Power: 50"
JumpLabel.Font = Enum.Font.GothamBold
JumpLabel.TextSize = 14
JumpLabel.TextColor3 = Color3.new(1,1,1)
JumpLabel.BackgroundTransparency = 1

local JumpMinus = Instance.new("TextButton", AetherBooster)
JumpMinus.Size = UDim2.fromOffset(70,30)
JumpMinus.Position = UDim2.fromOffset(10,315)
JumpMinus.Text = "- 5"
JumpMinus.Font = Enum.Font.GothamBold
JumpMinus.TextSize = 16
JumpMinus.TextColor3 = Color3.new(1,1,1)
JumpMinus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",JumpMinus)
JumpMinus.MouseButton1Click:Connect(function()
	JumpPowerValue = math.max(50, JumpPowerValue - 5)
	JumpLabel.Text = "Jump Power: "..JumpPowerValue
end)

local JumpPlus = Instance.new("TextButton", AetherBooster)
JumpPlus.Size = UDim2.fromOffset(70,30)
JumpPlus.Position = UDim2.fromOffset(90,315)
JumpPlus.Text = "+ 5"
JumpPlus.Font = Enum.Font.GothamBold
JumpPlus.TextSize = 16
JumpPlus.TextColor3 = Color3.new(1,1,1)
JumpPlus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",JumpPlus)
JumpPlus.MouseButton1Click:Connect(function()
	JumpPowerValue = math.min(200, JumpPowerValue + 5)
	JumpLabel.Text = "Jump Power: "..JumpPowerValue
end)

local JumpPlus10 = Instance.new("TextButton", AetherBooster)
JumpPlus10.Size = UDim2.fromOffset(70,30)
JumpPlus10.Position = UDim2.fromOffset(170,315)
JumpPlus10.Text = "+ 10"
JumpPlus10.Font = Enum.Font.GothamBold
JumpPlus10.TextSize = 16
JumpPlus10.TextColor3 = Color3.new(1,1,1)
JumpPlus10.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner",JumpPlus10)
JumpPlus10.MouseButton1Click:Connect(function()
	JumpPowerValue = math.min(200, JumpPowerValue + 10)
	JumpLabel.Text = "Jump Power: "..JumpPowerValue
end)

-- Close button
local CloseBooster = Instance.new("TextButton", AetherBooster)
CloseBooster.Size = UDim2.fromOffset(240,30)
CloseBooster.Position = UDim2.fromOffset(10,360)
CloseBooster.Text = "Close"
CloseBooster.Font = Enum.Font.GothamBold
CloseBooster.TextSize = 14
CloseBooster.TextColor3 = Color3.new(1,1,1)
CloseBooster.BackgroundColor3 = Color3.fromRGB(150,0,200)
Instance.new("UICorner",CloseBooster)
CloseBooster.MouseButton1Click:Connect(function()
	AetherBooster.Visible = false
end)

createToggle(FeaturesPage,"Aether Booster",250,function(v)
	AetherBooster.Visible = v
end)

----------------------------------------------------------------
-- FAKE BYPASS ANTI-CHEAT 😈 (STYLE UNIQUEMENT)
----------------------------------------------------------------
local FakeBypassBtn = Instance.new("TextButton", FeaturesPage)
FakeBypassBtn.Size = UDim2.fromOffset(240,40)
FakeBypassBtn.Position = UDim2.fromOffset(0,300)
FakeBypassBtn.Text = "Bypass Anti-Cheat 😈"
FakeBypassBtn.Font = Enum.Font.GothamBold
FakeBypassBtn.TextSize = 14
FakeBypassBtn.TextColor3 = Color3.new(1,1,1)
FakeBypassBtn.BackgroundColor3 = Color3.fromRGB(150,0,200)
Instance.new("UICorner", FakeBypassBtn)

local Overlay = Instance.new("Frame", ScreenGui)
Overlay.Size = UDim2.fromScale(1,1)
Overlay.BackgroundColor3 = Color3.new(0,0,0)
Overlay.BackgroundTransparency = 1
Overlay.Visible = false
Overlay.ZIndex = 100

local OverlayText = Instance.new("TextLabel", Overlay)
OverlayText.Size = UDim2.fromScale(1,1)
OverlayText.BackgroundTransparency = 1
OverlayText.TextWrapped = true
OverlayText.TextYAlignment = Enum.TextYAlignment.Center
OverlayText.TextXAlignment = Enum.TextXAlignment.Center
OverlayText.Font = Enum.Font.GothamBold
OverlayText.TextSize = 36
OverlayText.TextColor3 = Color3.new(1,1,1)
OverlayText.ZIndex = 101
OverlayText.Text =
	"injecting 💉...\n\n" ..
	"https://discord.gg/aSM5RqqgZg\n" ..
	"By isxm and izxmi 😈"

local LoadBG = Instance.new("Frame", Overlay)
LoadBG.Size = UDim2.fromScale(0.5,0.025)
LoadBG.Position = UDim2.fromScale(0.25,0.1)
LoadBG.BackgroundColor3 = Color3.fromRGB(60,0,90)
LoadBG.BorderSizePixel = 0
LoadBG.ZIndex = 101
Instance.new("UICorner", LoadBG)

local LoadFill = Instance.new("Frame", LoadBG)
LoadFill.Size = UDim2.fromScale(0,1)
LoadFill.BackgroundColor3 = Color3.fromRGB(200,100,255)
LoadFill.BorderSizePixel = 0
LoadFill.ZIndex = 102
Instance.new("UICorner", LoadFill)

FakeBypassBtn.MouseButton1Click:Connect(function()
	Overlay.Visible = true
	LoadFill.Size = UDim2.fromScale(0,1)

	TweenService:Create(Overlay,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()

	for i=1,100 do
		LoadFill.Size = UDim2.fromScale(i/100,1)
		task.wait(0.03)
	end

	task.wait(0.4)

	TweenService:Create(Overlay,TweenInfo.new(0.6),{BackgroundTransparency=1}):Play()
	task.wait(0.6)
	Overlay.Visible = false
end)

----------------------------------------------------------------
-- AUTO GRAB SYSTEM OPTIMISÉ 🧲 (SANS TÉLÉPORTATION)
----------------------------------------------------------------
local lastGrabTime = 0
local grabCooldown = 1  -- Cooldown de 1 seconde entre chaque grab

task.spawn(function()
	while task.wait(0.5) do  -- Check toutes les 0.5 secondes (réduit le lag)
		pcall(function()
			if AutoGrabEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = LocalPlayer.Character.HumanoidRootPart
				local char = LocalPlayer.Character
				local currentTime = tick()
				
				-- Vérifie le cooldown
				if currentTime - lastGrabTime < grabCooldown then
					return
				end
				
				-- Vérifie qu'on n'a pas déjà un brainrot
				local hasBrainrot = false
				local equippedTool = char:FindFirstChildOfClass("Tool")
				if equippedTool then
					local toolName = equippedTool.Name:lower()
					if toolName:find("brain") then
						hasBrainrot = true
					end
				end
				
				if hasBrainrot then
					return  -- On a déjà un brainrot, on skip
				end
				
				-- Cherche le brainrot le plus proche
				local closestBrainrot = nil
				local closestDistance = AutoGrabRange
				
				for _, obj in pairs(workspace:GetChildren()) do
					if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChildOfClass("Tool")) then
						local tool = obj:IsA("Tool") and obj or obj:FindFirstChildOfClass("Tool")
						
						if tool then
							local toolName = tool.Name:lower()
							if toolName:find("brain") then
								local handle = tool:FindFirstChild("Handle")
								if handle then
									local distance = (hrp.Position - handle.Position).Magnitude
									if distance < closestDistance then
										closestDistance = distance
										closestBrainrot = tool
									end
								end
							end
						end
					end
				end
				
				-- Si on a trouvé un brainrot proche, on le prend
				if closestBrainrot then
					-- Méthode 1: Essayer de déclencher ProximityPrompt
					local prompt = closestBrainrot:FindFirstChildOfClass("ProximityPrompt", true)
					if prompt then
						fireproximityprompt(prompt)
						showGrabProgress()
						lastGrabTime = currentTime
						return
					end
					
					-- Méthode 2: Changer le parent directement
					if closestBrainrot.Parent == workspace or closestBrainrot.Parent:IsA("Model") then
						closestBrainrot.Parent = char
						task.wait(0.1)
						
						-- Essaie de l'équiper
						if char.Humanoid then
							char.Humanoid:EquipTool(closestBrainrot)
						end
						
						showGrabProgress()
						lastGrabTime = currentTime
					end
				end
			end
		end)
	end
end)
----------------------------------------------------------------
-- END AUTO GRAB
----------------------------------------------------------------

-- MOVEMENT SYSTEM - DÉSACTIVÉ (cause respawn sur ce jeu)
--[[
task.spawn(function()
	while task.wait() do
		pcall(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				local humanoid = char.Humanoid
				
				if humanoid.Health > 0 then
					local hasBrainrot = false
					local tool = char:FindFirstChildOfClass("Tool")
					
					if tool then
						local toolName = tool.Name:lower()
						if toolName:find("brain") then
							hasBrainrot = true
						end
					end
					
					local targetSpeed = nil
					
					if hasBrainrot and StealBoostEnabled then
						targetSpeed = StealSpeedValue
					elseif not hasBrainrot and SpeedEnabled then
						targetSpeed = WalkSpeedValue
					end
					
					if targetSpeed and humanoid.WalkSpeed < targetSpeed then
						humanoid.WalkSpeed = targetSpeed
					end
					
					if (SpeedEnabled or StealBoostEnabled) and humanoid.JumpPower < JumpPowerValue then
						humanoid.JumpPower = JumpPowerValue
					end
				end
			end
		end)
	end
end)
--]]

-- ANTI-RAGDOLL
task.spawn(function()
	while task.wait() do
		pcall(function()
			if AntiRagdollEnabled then
				local char = LocalPlayer.Character
				if char and char:FindFirstChild("Humanoid") then
					local humanoid = char.Humanoid
					if humanoid.Health > 0 then
						humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
						humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					end
				end
			end
		end)
	end
end)

-- ANTI-KB
task.spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if AntiKBEnabled then
				local char = LocalPlayer.Character
				if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
					local hrp = char.HumanoidRootPart
					local humanoid = char.Humanoid
					if humanoid.Health > 0 then
						local vel = hrp.AssemblyLinearVelocity
						if math.abs(vel.X) > 40 or math.abs(vel.Z) > 40 then
							hrp.AssemblyLinearVelocity = Vector3.new(
								math.clamp(vel.X, -40, 40),
								vel.Y,
								math.clamp(vel.Z, -40, 40)
							)
						end
					end
				end
			end
		end)
	end
end)

-- GRAB ASSIST
task.spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if GrabAssistEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				for _,p in pairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
						if dist < 10 then
							-- Code pour grab assist ici
						end
					end
				end
			end
		end)
	end
end)

-- ESP
task.spawn(function()
	while task.wait() do
		pcall(function()
			if ESPEnabled then
				for _,player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local root = player.Character.HumanoidRootPart
						local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
						
						if not ESPObjects[player] then
							local box = Drawing.new("Square")
							box.Color = Color3.fromRGB(255,0,0)
							box.Thickness = 2
							box.Filled = false

							local line = Drawing.new("Line")
							line.Color = Color3.fromRGB(128,0,128)
							line.Thickness = 4

							local nameText = Drawing.new("Text")
							nameText.Color = Color3.fromRGB(255,255,255)
							nameText.Size = 16
							nameText.Center = true
							nameText.Outline = true
							nameText.Font = 2

							local distText = Drawing.new("Text")
							distText.Color = Color3.fromRGB(255,255,0)
							distText.Size = 14
							distText.Center = true
							distText.Outline = true
							distText.Font = 2

							ESPObjects[player] = {box=box, line=line, nameText=nameText, distText=distText}
						end

						local box = ESPObjects[player].box
						local line = ESPObjects[player].line
						local nameText = ESPObjects[player].nameText
						local distText = ESPObjects[player].distText

						if onScreen then
							box.Position = Vector2.new(screenPos.X-20,screenPos.Y-40)
							box.Size = Vector2.new(40,60)
							box.Visible = true

							line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
							line.To = Vector2.new(screenPos.X, screenPos.Y)
							line.Visible = true

							if ESPShowNames then
								nameText.Text = player.Name
								nameText.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
								nameText.Visible = true
							else
								nameText.Visible = false
							end

							if ESPShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
								local distance = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
								distText.Text = math.floor(distance).."m"
								distText.Position = Vector2.new(screenPos.X, screenPos.Y + 15)
								distText.Visible = true
							else
								distText.Visible = false
							end
						else
							box.Visible = false
							line.Visible = false
							nameText.Visible = false
							distText.Visible = false
						end
					else
						if ESPObjects[player] then
							ESPObjects[player].box:Remove()
							ESPObjects[player].line:Remove()
							ESPObjects[player].nameText:Remove()
							ESPObjects[player].distText:Remove()
							ESPObjects[player] = nil
						end
					end
				end
			else
				for player, objects in pairs(ESPObjects) do
					if objects.box then objects.box:Remove() end
					if objects.line then objects.line:Remove() end
					if objects.nameText then objects.nameText:Remove() end
					if objects.distText then objects.distText:Remove() end
				end
				ESPObjects = {}
			end
		end)
	end
end)

----------------------------------------------------------------
-- WALLHACK OPTIMISÉ
----------------------------------------------------------------

local function isWallOrObstacle(part)
	local size = part.Size
	if size.Magnitude < MinPartSize then
		return false
	end
	if size.X < 1 and size.Z < 1 then
		return false
	end
	return true
end

local function isPlayerPart(obj)
	local parent = obj.Parent
	local depth = 0
	
	while parent and depth < 5 do
		if parent:IsA("Model") then
			if Players:GetPlayerFromCharacter(parent) then
				return true
			end
			if parent.Name == "Character" or parent:FindFirstChild("Humanoid") then
				return true
			end
		end
		parent = parent.Parent
		depth = depth + 1
	end
	
	return false
end

task.spawn(function()
	while task.wait(WallhackUpdateRate) do
		pcall(function()
			if WallhackEnabled then
				local currentTime = tick()
				
				if currentTime - LastScan > SCAN_INTERVAL or next(CachedParts) == nil then
					LastScan = currentTime
					
					for obj, data in pairs(CachedParts) do
						if obj and obj.Parent then
							obj.Transparency = data.OriginalTransparency
						end
					end
					CachedParts = {}
					
					local partsToProcess = {}
					
					if WallhackMode == "WallsOnly" then
						local folders = {"Map", "Walls", "Buildings", "Structure", "World"}
						for _, folderName in pairs(folders) do
							local folder = workspace:FindFirstChild(folderName)
							if folder then
								for _, obj in pairs(folder:GetDescendants()) do
									if obj:IsA("BasePart") then
										table.insert(partsToProcess, obj)
									end
								end
							end
						end
					elseif WallhackMode == "Smart" then
						for _, obj in pairs(workspace:GetDescendants()) do
							if obj:IsA("BasePart") and obj.Size.Magnitude >= MinPartSize then
								table.insert(partsToProcess, obj)
							end
						end
					else
						for _, obj in pairs(workspace:GetDescendants()) do
							if obj:IsA("BasePart") then
								table.insert(partsToProcess, obj)
							end
						end
					end
					
					for _, obj in pairs(partsToProcess) do
						if obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Head" and obj.Name ~= "Baseplate" then
							if not isPlayerPart(obj) then
								if WallhackMode == "WallsOnly" or isWallOrObstacle(obj) or WallhackMode == "Full" then
									CachedParts[obj] = {
										OriginalTransparency = obj.Transparency,
										OriginalCanCollide = obj.CanCollide
									}
									obj.Transparency = math.max(obj.Transparency, WallhackTransparency)
								end
							end
						end
					end
				else
					for obj, data in pairs(CachedParts) do
						if not obj or not obj.Parent then
							CachedParts[obj] = nil
						else
							if obj.Transparency < WallhackTransparency then
								obj.Transparency = WallhackTransparency
							end
						end
					end
				end
			else
				for obj, data in pairs(CachedParts) do
					if obj and obj.Parent then
						obj.Transparency = data.OriginalTransparency
					end
				end
				CachedParts = {}
				LastScan = 0
			end
		end)
	end
end)

-- UI WALLHACK
local WallhackModeBtn = Instance.new("TextButton", VisualPage)
WallhackModeBtn.Size = UDim2.fromOffset(240,40)
WallhackModeBtn.Position = UDim2.fromOffset(0,200)
WallhackModeBtn.Text = "Mode: Smart"
WallhackModeBtn.Font = Enum.Font.Gotham
WallhackModeBtn.TextSize = 14
WallhackModeBtn.TextColor3 = Color3.new(1,1,1)
WallhackModeBtn.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner", WallhackModeBtn)

WallhackModeBtn.MouseButton1Click:Connect(function()
	if WallhackMode == "Smart" then
		WallhackMode = "WallsOnly"
	elseif WallhackMode == "WallsOnly" then
		WallhackMode = "Full"
	else
		WallhackMode = "Smart"
	end
	WallhackModeBtn.Text = "Mode: "..WallhackMode
	LastScan = 0
end)

local TranspLabel = Instance.new("TextLabel", VisualPage)
TranspLabel.Size = UDim2.fromOffset(240,25)
TranspLabel.Position = UDim2.fromOffset(0,250)
TranspLabel.Text = "Transparency: 85%"
TranspLabel.Font = Enum.Font.Gotham
TranspLabel.TextSize = 14
TranspLabel.TextColor3 = Color3.new(1,1,1)
TranspLabel.BackgroundTransparency = 1

local TranspMinus = Instance.new("TextButton", VisualPage)
TranspMinus.Size = UDim2.fromOffset(70,30)
TranspMinus.Position = UDim2.fromOffset(0,280)
TranspMinus.Text = "- 5%"
TranspMinus.Font = Enum.Font.Gotham
TranspMinus.TextSize = 14
TranspMinus.TextColor3 = Color3.new(1,1,1)
TranspMinus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner", TranspMinus)

TranspMinus.MouseButton1Click:Connect(function()
	WallhackTransparency = math.max(0.5, WallhackTransparency - 0.05)
	TranspLabel.Text = "Transparency: "..math.floor(WallhackTransparency*100).."%"
	LastScan = 0
end)

local TranspPlus = Instance.new("TextButton", VisualPage)
TranspPlus.Size = UDim2.fromOffset(70,30)
TranspPlus.Position = UDim2.fromOffset(85,280)
TranspPlus.Text = "+ 5%"
TranspPlus.Font = Enum.Font.Gotham
TranspPlus.TextSize = 14
TranspPlus.TextColor3 = Color3.new(1,1,1)
TranspPlus.BackgroundColor3 = Color3.fromRGB(70,0,120)
Instance.new("UICorner", TranspPlus)

TranspPlus.MouseButton1Click:Connect(function()
	WallhackTransparency = math.min(0.95, WallhackTransparency + 0.05)
	TranspLabel.Text = "Transparency: "..math.floor(WallhackTransparency*100).."%"
	LastScan = 0
end)

print("✅ AETHER HUB V11 SAFE - Loaded!")
print("🎯 Wallhack optimisé - Smart mode")
print("🧲 Auto Grab - Sans téléportation + Barre violette")
print("💜 By isxm and izxmi")
