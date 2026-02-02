--// AETHER HUB V9 PRO
--// UI violet, ESP + Wallhack séparé + pseudo + lignes + speed/jump boost + sliders transparence

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- States
local ESPEnabled = false
local WallhackEnabled = false
local SpeedEnabled = false
local JumpEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local WallhackTransparency = 0.5

-- Store ESP objects
local ESPObjects = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AETHERHUB"

-- Main frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(500,400)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(120,0,180) -- violet
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,15)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "AETHER HUB V9 PRO"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,200,255)
Title.BackgroundTransparency = 1

-- Tabs frame
local Tabs = Instance.new("Frame", Main)
Tabs.Position = UDim2.fromOffset(10,50)
Tabs.Size = UDim2.fromOffset(150,340)
Tabs.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromOffset(170,50)
Content.Size = UDim2.fromOffset(320,340)
Content.BackgroundTransparency = 1

-- Tab buttons creator
local function createTabButton(text,y)
	local b = Instance.new("TextButton", Tabs)
	b.Size = UDim2.fromOffset(150,40)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(90,0,130) -- violet foncé
	local uc = Instance.new("UICorner",b)
	uc.CornerRadius = UDim.new(0,8)

	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(130,0,180)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(90,0,130)}):Play()
	end)
	return b
end

local FeaturesTab = createTabButton("Features",0)
local MovementTab = createTabButton("Movement",50)
local AboutTab = createTabButton("About",100)

-- Pages
local Pages = {}
local function createPage(name)
	local f = Instance.new("Frame", Content)
	f.Size = UDim2.fromScale(1,1)
	f.BackgroundTransparency = 1
	f.Visible = false
	Pages[name] = f
	return f
end

local FeaturesPage = createPage("Features")
local MovementPage = createPage("Movement")
local AboutPage = createPage("About")
FeaturesPage.Visible = true

local function switchPage(name)
	for _,v in pairs(Pages) do v.Visible = false end
	Pages[name].Visible = true
end

FeaturesTab.MouseButton1Click:Connect(function() switchPage("Features") end)
MovementTab.MouseButton1Click:Connect(function() switchPage("Movement") end)
AboutTab.MouseButton1Click:Connect(function() switchPage("About") end)

-- Toggle helper
local function createToggle(parent,text,y,callback)
	local b = Instance.new("TextButton",parent)
	b.Size = UDim2.fromOffset(240,40)
	b.Position = UDim2.fromOffset(0,y)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(70,0,120) -- violet
	Instance.new("UICorner",b)
	local state=false

	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(120,0,180)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(70,0,120)}):Play()
	end)

	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = text.." : "..(state and "ON" or "OFF")
		callback(state)
	end)
end

-- Slider helper
local function createSlider(parent,posY,label,initial,callback)
	local bg = Instance.new("Frame", parent)
	bg.Position = UDim2.fromOffset(0,posY)
	bg.Size = UDim2.fromOffset(240,10)
	bg.BackgroundColor3 = Color3.fromRGB(90,0,130)
	Instance.new("UICorner",bg)
	local fill = Instance.new("Frame",bg)
	fill.Size=UDim2.fromScale(initial,1)
	fill.BackgroundColor3=Color3.fromRGB(220,120,255)
	Instance.new("UICorner",fill)

	local dragging=false
	local valueLabel = Instance.new("TextLabel",parent)
	valueLabel.Size=UDim2.fromOffset(50,20)
	valueLabel.Position=UDim2.fromOffset(245,posY-5)
	valueLabel.TextColor3=Color3.new(1,1,1)
	valueLabel.BackgroundTransparency=1
	valueLabel.Font=Enum.Font.Gotham
	valueLabel.TextSize=14
	valueLabel.Text=math.floor(initial*100)

	bg.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
			local pos = math.clamp((input.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
			fill.Size=UDim2.fromScale(pos,1)
			valueLabel.Text=math.floor(pos*100)
			callback(pos)
		end
	end)
	return {bg=bg,fill=fill,valueLabel=valueLabel}
end

-- Features toggles
createToggle(FeaturesPage,"ESP",0,function(v)
	ESPEnabled=v
	if v then applyESP() else clearESP() end
end)

createToggle(FeaturesPage,"Wallhack",50,function(v)
	WallhackEnabled=v
	if v then applyESP() else clearESP() end
end)

-- Wallhack transparency slider
createSlider(FeaturesPage,100,"Wallhack Trans",WallhackTransparency,function(pos)
	WallhackTransparency = pos
	for player,obj in pairs(ESPObjects) do
		if obj.WallHighlight and WallhackEnabled then
			obj.WallHighlight.FillTransparency = WallhackTransparency
		end
	end
end)

-- Movement toggles
createToggle(MovementPage,"Speed Boost",0,function(v) SpeedEnabled=v end)
createToggle(MovementPage,"Jump Boost",60,function(v) JumpEnabled=v end)

-- Speed slider
createSlider(MovementPage,40,"Speed",WalkSpeedValue/76,function(pos)
	WalkSpeedValue=16+pos*60
end)

-- Jump slider
createSlider(MovementPage,140,"Jump",JumpPowerValue/100,function(pos)
	JumpPowerValue=50+pos*100
end)

-- About
local AboutText = Instance.new("TextLabel",AboutPage)
AboutText.Size=UDim2.fromScale(1,1)
AboutText.Text = "AETHER HUB V9 PRO\nESP + Wallhack + Speed + Jump + Pseudo + Lignes\nUI violet stylée et animée\nRejoins mon Discord : https://discord.gg/aSM5RqqgZg"
AboutText.TextColor3=Color3.new(1,1,1)
AboutText.BackgroundTransparency=1
AboutText.Font=Enum.Font.Gotham
AboutText.TextWrapped=true

-- ESP functions
function clearESP()
	for player,obj in pairs(ESPObjects) do
		if obj.Highlight then obj.Highlight:Destroy() end
		if obj.WallHighlight then obj.WallHighlight:Destroy() end
		if obj.Billboard then obj.Billboard:Destroy() end
		if obj.Beam then obj.Beam:Destroy() end
		if obj.Attachments then for _,a in pairs(obj.Attachments) do a:Destroy() end end
	end
	ESPObjects={}
end

function createESP(player)
	if player==LocalPlayer then return end
	local function apply(char)
		if not (ESPEnabled or WallhackEnabled) then return end

		-- Normal ESP
		if ESPEnabled then
			if not char:FindFirstChild("AetherESP") then
				local h = Instance.new("Highlight",char)
				h.Name="AetherESP"
				h.FillColor = Color3.new(1,0,0)
				h.FillTransparency = 0
				h.OutlineColor = Color3.new(1,1,1)
				h.OutlineTransparency = 0.3
			end
		end

		-- Wallhack ESP
		if WallhackEnabled then
			if not char:FindFirstChild("AetherWall") then
				local wh = Instance.new("Highlight",char)
				wh.Name="AetherWall"
				wh.FillColor = Color3.new(1,0,0)
				wh.FillTransparency = WallhackTransparency
				wh.OutlineColor = Color3.new(1,1,1)
				wh.OutlineTransparency = 0.3
			end
		end

		-- Pseudo
		if not char:FindFirstChild("AetherName") then
			local bill = Instance.new("BillboardGui",char)
			bill.Name="AetherName"
			bill.Adornee=char:WaitForChild("Head")
			bill.Size=UDim2.fromOffset(200,50)
			bill.StudsOffset=Vector3.new(0,2.5,0)
			bill.AlwaysOnTop=true
			local txt = Instance.new("TextLabel",bill)
			txt.Size=UDim2.fromScale(1,1)
			txt.BackgroundTransparency=1
			txt.Text=player.Name
			txt.TextColor3=Color3.new(1,0,0)
			txt.Font=Enum.Font.GothamBold
			txt.TextSize=14
		end

		-- Lignes bleues
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local hrp1=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local hrp2=char:FindFirstChild("HumanoidRootPart")
			if hrp1 and hrp2 and not ESPObjects[player] then
				local att1=Instance.new("Attachment",hrp1)
				att1.Name="Aether_Att1_"..player.Name
				local att2=Instance.new("Attachment",hrp2)
				att2.Name="Aether_Att2_"..player.Name
				local beam=Instance.new("Beam")
				beam.Name="AetherLine_"..player.Name
				beam.Attachment0=att1
				beam.Attachment1=att2
				beam.Width0,beam.Width1=0.4,0.4
				beam.Color=ColorSequence.new(Color3.fromRGB(0,120,255))
				beam.LightEmission=1
				beam.FaceCamera=true
				beam.Parent=hrp1
				ESPObjects[player]={Highlight=char:FindFirstChild("AetherESP"),WallHighlight=char:FindFirstChild("AetherWall"),Billboard=char:FindFirstChild("AetherName"),Beam=beam,Attachments={att1,att2}}
			end
		end
	end
	if player.Character then apply(player.Character) end
	player.CharacterAdded:Connect(apply)
end

function applyESP()
	for _,p in pairs(Players:GetPlayers()) do createESP(p) end
end

for _,p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- Speed & Jump apply
RunService.RenderStepped:Connect(function()
	local char=LocalPlayer.Character
	if char then
		local hum=char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = SpeedEnabled and WalkSpeedValue or 16
			hum.JumpPower = JumpEnabled and JumpPowerValue or 50
		end
	end
end)
