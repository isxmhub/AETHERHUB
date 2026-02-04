-- AETHER HUB V11 - AETHER STYLE 💉
-- UI moderne + Auto Grab + Aether Speed + ESP Brainrot + FLY TO BASE intégré
-- By isxm and izxmi

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
local ESPBrainrotEnabled = false
local WallhackEnabled = false
local GrabAssistEnabled = false
local AntiKBEnabled = false
local AntiRagdollEnabled = false
local AutoGrabEnabled = false  
local AutoGrabRange = 35
local ESPObjects = {}
local ESPBrainrotObjects = {}
local WallhackObjects = {}

-- NOUVEAU: Fly to Base Config
local FlyToBaseEnabled = false
local flyConnection = nil
local basePosition = nil  -- Position de ta base (à définir)

-- Configurations Wallhack
local WallhackMode = "Smart"
local WallhackTransparency = 0.85
local MinPartSize = 5
local WallhackUpdateRate = 2

-- Cache
local CachedParts = {}
local LastScan = 0
local SCAN_INTERVAL = 10

-- Aether Speed Config
local velocityConnection = nil
local isSpeedEnabled = false
local speedValue = 25

-- ESP Brainrot Connections
local espBrainrotConnections = {}

----------------------------------------------------------------
-- 📋 LISTE COMPLÈTE DES BRAINROTS
----------------------------------------------------------------
local BRAINROT_NAMES = {
	-- Common
	"noobini pizzanini", "lirili larila", "tim cheese", "flurifura", 
	"talpa di fero", "svinia bombardino", "svinina bombardino",
	"pipi kiwi", "racooni jandelini", "pipi corni", "noobini santanini",
	
	-- Rare
	"trippi troppi", "gangster footera", "bandito bobritto", "boneca ambalabu",
	"cacto hipopotamo", "ta ta ta ta sahur", "tric trac baraboom", 
	"pipi avocado", "frogo elfo",
	
	-- Epic
	"cappuccino assassino", "brr brr patapin", "brr brr patapim",
	"trulimero trulicina", "bambini crostini", "bananita dolphinita",
	"perochello lemonchello", "brri brri bicus dicus bombicus",
	"avocadini guffo", "salamino penguino", "ti ti ti sahur",
	"penguin tree", "penguino cocosino",
	
	-- Legendary
	"burbalini loliloli", "burbaloni loliloli", "chimpanzini bananini", 
	"chimpazini bananini", "ballerina cappuccina", "chef crabracadabra",
	"lionel cactuseli", "glorbo fruttodrillo", "blueberrini octapusini",
	"blueberrini octopusini", "strawberelli flamingelli", 
	"pandaccini bananini", "cocosini mama", "sigma boy", "sigma girl",
	"pi pi watermelon", "chocco bunny", "sealo regalo",
	
	-- Mythic
	"frigo camelo", "orangutini ananasini", "orangutini ananassini",
	"rhino toasterino", "bombardiro crocodilo", "bombombini gusini",
	"cavallo virtuso", "gorillo watermelondrillo", "avocadorilla",
	"tob tobi tobi", "gangazelli trulala", "ganganzelli trulala",
	"cachorrito melonito", "elefanto frigo", "toiletto focaccino",
	"te te te sahur", "tracoducotulu delapeladustuz", "lerulerulerule",
	"jingle jingle sahur", "tree tree tree sahur", "carloo",
	"spioniro golubiro", "zibra zubra zibralini", "tigrilini watermelini",
	"carrotini brainini", "bananito bandito",
	
	-- Brainrot God
	"cocofanta elefanto", "coco elefanto", "girafa celestre",
	"gyattatino nyanino", "gattatino nyanino", "chihuanini taconini",
	"matteo", "tralalero tralala", "espresso signora",
	"odin din din dun", "statutino libertino", "trenostruzzo turbo 3000",
	"ballerino lololo", "los orcalitos", "dug dug dug",
	"tralalita tralala", "urubini flamenguini", "los bombinitos",
	"trigoligre frutonni", "orcalero orcala", "bulbito bandito traktorito",
	"los crocodilitos", "los crocodillitos", "piccione macchina",
	"trippi troppi troppa trippa", "los tungtuntuncitos", "los tungtungtungcitos",
	"tukanno bananno", "alessio", "tipi topi taco", "extinct ballerina",
	"capi taco", "gattito tacoto", "pakrahmatmamat", "tractoro dinosauro",
	"corn corn corn sahur", "squalanana", "los tipi tacos",
	"bombardini tortinii", "pop pop sahur", "ballerina peppermintina",
	"yeti claus", "ginger globo", "frio ninja", "ginger cisterna",
	"cacasito satalito", "aquanaut", "tartaruga cisterna",
	
	-- Secret
	"las sis", "la vacca saturno saturnita", "la vacca staturno saturnita",
	"chimpanzini spiderini", "chimpanzini_spiderini", "extinct tralalero",
	"extinct matteo", "los tralaleirtos", "los tralaleritos",
	"la karkerkar combinasion", "karker sahur", "las tralaleritas",
	"job job job sahur", "los spyderinis", "los spyderrinis",
	"perrito burrito", "graipuss medussi", "los jobcitos",
	"la grande combinasion", "tacorita bicicleta", "nuclearo dinossauro",
	"los 67", "money money puggy", "chillin chili", "la extinct grande",
	"los tacoritas", "los tortus", "tang tang keletang", "tang tang kelentang",
	"garama and madundung", "la secret combinasion", "tortuginni dragonfruitini",
	"torrtuginni dragonfruitini", "pot hotspot", "to to to sahur",
	"las vaquitas saturnitas", "chicleteira bicicleteira", "agarrini la palini",
	"mariachi corazoni", "dragon cannelloni", "los combinasionas",
	"la cucaracha", "karkerkar kurkur", "los hotspotsitos",
	"la sahur combinasion", "quesadilla crocodila", "esok sekolah",
	"lost matteos", "los matteos", "dul dul dul", "blackhole goat",
	"nooo my hotspot", "sammyini spyderini", "spaghetti tualetti",
	"67 brainrot", "67", "los noo my hotspotsitos", "celularcini viciosini",
	"tralaledon", "tictac sahur", "la supreme combinasion",
	"ketupat kepat", "ketchuru and musturu", "burguro and fryuro",
	"please my present", "la grande", "la vacca prese presente",
	"ho ho ho sahur", "chicleteira noelteira", "cooki and milki",
	"la jolly grande", "capitano moby", "cerberus",
	
	-- OG
	"skibidi toilet", "strawberry elephant", "meowl",
	
	-- Mots-clés génériques
	"brain", "rot", "brainrot"
}

-- Fonction pour vérifier si c'est un brainrot
local function isBrainrot(name)
	local nameLower = name:lower()
	for _, brainrotName in pairs(BRAINROT_NAMES) do
		if nameLower:find(brainrotName) or brainrotName:find(nameLower) then
			return true
		end
	end
	return false
end

----------------------------------------------------------------
-- UI PRINCIPALE - AETHER STYLE 💉
----------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AETHERHUB"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.fromOffset(500, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Transparency = 0.3

-- Titre principal
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, -80, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "aether hub v11 💉"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

----------------------------------------------------------------
-- BOUTON MINIMIZE EN HAUT À DROITE
----------------------------------------------------------------
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.fromOffset(40, 40)
MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.fromRGB(200, 150, 255)
MinimizeButton.TextSize = 24
MinimizeButton.AutoButtonColor = false

local MinimizeCorner = Instance.new("UICorner", MinimizeButton)
MinimizeCorner.CornerRadius = UDim.new(0, 8)

local MinimizeStroke = Instance.new("UIStroke", MinimizeButton)
MinimizeStroke.Thickness = 2
MinimizeStroke.Color = Color3.fromRGB(138, 43, 226)

-- Mini Frame (version réduite)
local MiniFrame = Instance.new("TextButton", ScreenGui)
MiniFrame.Size = UDim2.fromOffset(60, 60)
MiniFrame.Position = UDim2.new(0.5, -30, 0.5, -30)
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MiniFrame.Text = "AH"
MiniFrame.Font = Enum.Font.GothamBold
MiniFrame.TextColor3 = Color3.fromRGB(200, 150, 255)
MiniFrame.TextSize = 20
MiniFrame.AutoButtonColor = false
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true

local MiniCorner = Instance.new("UICorner", MiniFrame)
MiniCorner.CornerRadius = UDim.new(0, 12)

local MiniStroke = Instance.new("UIStroke", MiniFrame)
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.fromRGB(138, 43, 226)

-- Hover effect minimize button
MinimizeButton.MouseEnter:Connect(function()
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end)

MinimizeButton.MouseLeave:Connect(function()
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

-- Toggle minimize
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = true
	TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
	
	task.wait(0.3)
	MainFrame.Visible = false
	MiniFrame.Visible = true
	
	TweenService:Create(MiniFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
		Size = UDim2.fromOffset(60, 60)
	}):Play()
end)

-- Restore from mini
MiniFrame.MouseButton1Click:Connect(function()
	TweenService:Create(MiniFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.fromOffset(0, 0)
	}):Play()
	
	task.wait(0.3)
	MiniFrame.Visible = false
	MainFrame.Visible = true
	MainFrame.Size = UDim2.fromOffset(0, 0)
	MainFrame.BackgroundTransparency = 1
	MainStroke.Transparency = 1
	
	TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
		Size = UDim2.fromOffset(500, 400),
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
	isMinimized = false
end)

-- Hover effect mini frame
MiniFrame.MouseEnter:Connect(function()
	TweenService:Create(MiniFrame, TweenInfo.new(0.2), {
		Size = UDim2.fromOffset(70, 70),
		BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	}):Play()
end)

MiniFrame.MouseLeave:Connect(function()
	TweenService:Create(MiniFrame, TweenInfo.new(0.2), {
		Size = UDim2.fromOffset(60, 60),
		BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	}):Play()
end)

----------------------------------------------------------------
-- TABS SYSTEM
----------------------------------------------------------------
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.fromOffset(150, 340)
TabsFrame.Position = UDim2.fromOffset(10, 50)
TabsFrame.BackgroundTransparency = 1

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.fromOffset(320, 340)
ContentFrame.Position = UDim2.fromOffset(170, 50)
ContentFrame.BackgroundTransparency = 1

-- Couleurs tabs
local TabColor = Color3.fromRGB(30, 30, 35)
local TabHover = Color3.fromRGB(50, 50, 55)
local TabActive = Color3.fromRGB(138, 43, 226)

local function createTab(text, yPos)
	local tab = Instance.new("TextButton", TabsFrame)
	tab.Size = UDim2.fromOffset(150, 40)
	tab.Position = UDim2.fromOffset(0, yPos)
	tab.BackgroundColor3 = TabColor
	tab.Text = text
	tab.Font = Enum.Font.GothamBold
	tab.TextColor3 = Color3.fromRGB(200, 150, 255)
	tab.TextSize = 14
	tab.AutoButtonColor = false
	
	local tabCorner = Instance.new("UICorner", tab)
	tabCorner.CornerRadius = UDim.new(0, 8)
	
	local tabStroke = Instance.new("UIStroke", tab)
	tabStroke.Thickness = 2
	tabStroke.Color = Color3.fromRGB(80, 80, 90)
	
	tab.MouseEnter:Connect(function()
		if tab.BackgroundColor3 ~= TabActive then
			TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = TabHover}):Play()
		end
	end)
	
	tab.MouseLeave:Connect(function()
		if tab.BackgroundColor3 ~= TabActive then
			TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = TabColor}):Play()
		end
	end)
	
	return tab
end

local FeaturesTab = createTab("Features", 0)
local VisualTab = createTab("Visual", 50)
local TeleportTab = createTab("Teleport ✈️", 100)  -- NOUVEAU TAB

-- Pages
local Pages = {}
local function createPage(name)
	local page = Instance.new("ScrollingFrame", ContentFrame)
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	page.BackgroundTransparency = 0.3
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 6
	page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
	page.CanvasSize = UDim2.fromOffset(0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	
	local pageCorner = Instance.new("UICorner", page)
	pageCorner.CornerRadius = UDim.new(0, 10)
	
	local pageLayout = Instance.new("UIListLayout", page)
	pageLayout.Padding = UDim.new(0, 10)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local pagePadding = Instance.new("UIPadding", page)
	pagePadding.PaddingTop = UDim.new(0, 10)
	pagePadding.PaddingLeft = UDim.new(0, 10)
	pagePadding.PaddingRight = UDim.new(0, 10)
	pagePadding.PaddingBottom = UDim.new(0, 10)
	
	Pages[name] = page
	return page
end

local FeaturesPage = createPage("Features")
local VisualPage = createPage("Visual")
local TeleportPage = createPage("Teleport")  -- NOUVELLE PAGE
FeaturesPage.Visible = true
FeaturesTab.BackgroundColor3 = TabActive

local currentTab = FeaturesTab

local function switchPage(name, tab)
	for _, page in pairs(Pages) do
		page.Visible = false
	end
	Pages[name].Visible = true
	
	if currentTab then
		currentTab.BackgroundColor3 = TabColor
	end
	tab.BackgroundColor3 = TabActive
	currentTab = tab
end

FeaturesTab.MouseButton1Click:Connect(function()
	switchPage("Features", FeaturesTab)
end)

VisualTab.MouseButton1Click:Connect(function()
	switchPage("Visual", VisualTab)
end)

TeleportTab.MouseButton1Click:Connect(function()
	switchPage("Teleport", TeleportTab)
end)

----------------------------------------------------------------
-- FONCTION POUR CRÉER DES TOGGLES STYLE AETHER
----------------------------------------------------------------
local function createAetherToggle(parent, text, callback)
	local toggleFrame = Instance.new("Frame", parent)
	toggleFrame.Size = UDim2.fromOffset(300, 45)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	toggleFrame.BorderSizePixel = 0
	
	local toggleCorner = Instance.new("UICorner", toggleFrame)
	toggleCorner.CornerRadius = UDim.new(0, 8)
	
	local toggleStroke = Instance.new("UIStroke", toggleFrame)
	toggleStroke.Thickness = 2
	toggleStroke.Color = Color3.fromRGB(80, 80, 90)
	
	local toggleButton = Instance.new("TextButton", toggleFrame)
	toggleButton.Size = UDim2.fromOffset(90, 35)
	toggleButton.Position = UDim2.fromOffset(200, 5)
	toggleButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	toggleButton.Text = "ENABLE"
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.TextSize = 12
	toggleButton.AutoButtonColor = false
	
	local btnCorner = Instance.new("UICorner", toggleButton)
	btnCorner.CornerRadius = UDim.new(0, 6)
	
	local btnStroke = Instance.new("UIStroke", toggleButton)
	btnStroke.Thickness = 2
	btnStroke.Color = Color3.fromRGB(180, 100, 255)
	
	local labelText = Instance.new("TextLabel", toggleFrame)
	labelText.Size = UDim2.fromOffset(185, 35)
	labelText.Position = UDim2.fromOffset(10, 5)
	labelText.BackgroundTransparency = 1
	labelText.Text = text
	labelText.Font = Enum.Font.GothamBold
	labelText.TextColor3 = Color3.fromRGB(200, 150, 255)
	labelText.TextSize = 14
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	
	local isEnabled = false
	
	toggleButton.MouseEnter:Connect(function()
		toggleButton.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
	end)
	
	toggleButton.MouseLeave:Connect(function()
		if isEnabled then
			toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
		else
			toggleButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		end
	end)
	
	toggleButton.MouseButton1Click:Connect(function()
		isEnabled = not isEnabled
		
		if isEnabled then
			toggleButton.Text = "DISABLE"
			toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
			btnStroke.Color = Color3.fromRGB(255, 100, 120)
			toggleStroke.Color = Color3.fromRGB(255, 60, 100)
		else
			toggleButton.Text = "ENABLE"
			toggleButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			btnStroke.Color = Color3.fromRGB(180, 100, 255)
			toggleStroke.Color = Color3.fromRGB(80, 80, 90)
		end
		
		callback(isEnabled)
	end)
	
	return toggleFrame
end

----------------------------------------------------------------
-- TOGGLES FEATURES
----------------------------------------------------------------
createAetherToggle(FeaturesPage, "auto grab 🧲", function(v) AutoGrabEnabled = v end)
createAetherToggle(FeaturesPage, "grab assist", function(v) GrabAssistEnabled = v end)
createAetherToggle(FeaturesPage, "anti knockback", function(v) AntiKBEnabled = v end)
createAetherToggle(FeaturesPage, "anti ragdoll", function(v) AntiRagdollEnabled = v end)

-- Allow/Disallow Friends Toggle
local AllowFriendsFrame = Instance.new("Frame", FeaturesPage)
AllowFriendsFrame.Size = UDim2.fromOffset(300, 45)
AllowFriendsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AllowFriendsFrame.BorderSizePixel = 0

local AllowFriendsCorner = Instance.new("UICorner", AllowFriendsFrame)
AllowFriendsCorner.CornerRadius = UDim.new(0, 8)

local AllowFriendsStroke = Instance.new("UIStroke", AllowFriendsFrame)
AllowFriendsStroke.Thickness = 2
AllowFriendsStroke.Color = Color3.fromRGB(80, 80, 90)

local AllowFriendsButton = Instance.new("TextButton", AllowFriendsFrame)
AllowFriendsButton.Size = UDim2.fromOffset(90, 35)
AllowFriendsButton.Position = UDim2.fromOffset(200, 5)
AllowFriendsButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
AllowFriendsButton.Text = "TOGGLE"
AllowFriendsButton.Font = Enum.Font.GothamBold
AllowFriendsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AllowFriendsButton.TextSize = 12
AllowFriendsButton.AutoButtonColor = false

local AllowFriendsBtnCorner = Instance.new("UICorner", AllowFriendsButton)
AllowFriendsBtnCorner.CornerRadius = UDim.new(0, 6)

local AllowFriendsBtnStroke = Instance.new("UIStroke", AllowFriendsButton)
AllowFriendsBtnStroke.Thickness = 2
AllowFriendsBtnStroke.Color = Color3.fromRGB(180, 100, 255)

local AllowFriendsLabel = Instance.new("TextLabel", AllowFriendsFrame)
AllowFriendsLabel.Size = UDim2.fromOffset(185, 35)
AllowFriendsLabel.Position = UDim2.fromOffset(10, 5)
AllowFriendsLabel.BackgroundTransparency = 1
AllowFriendsLabel.Text = "allow/disallow friends"
AllowFriendsLabel.Font = Enum.Font.GothamBold
AllowFriendsLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
AllowFriendsLabel.TextSize = 14
AllowFriendsLabel.TextXAlignment = Enum.TextXAlignment.Left

AllowFriendsButton.MouseEnter:Connect(function()
	AllowFriendsButton.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
end)

AllowFriendsButton.MouseLeave:Connect(function()
	AllowFriendsButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
end)

AllowFriendsButton.MouseButton1Click:Connect(function()
	pcall(function()
		game:GetService('ReplicatedStorage'):WaitForChild('Packages'):WaitForChild('Net'):WaitForChild('RE/PlotService/ToggleFriends'):FireServer()
		
		-- Animation du bouton
		TweenService:Create(AllowFriendsButton, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		}):Play()
		
		task.wait(0.2)
		
		TweenService:Create(AllowFriendsButton, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		}):Play()
	end)
end)

-- Fake Bypass Button
local BypassFrame = Instance.new("Frame", FeaturesPage)
BypassFrame.Size = UDim2.fromOffset(300, 45)
BypassFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
BypassFrame.BorderSizePixel = 0

local BypassCorner = Instance.new("UICorner", BypassFrame)
BypassCorner.CornerRadius = UDim.new(0, 8)

local BypassStroke = Instance.new("UIStroke", BypassFrame)
BypassStroke.Thickness = 2
BypassStroke.Color = Color3.fromRGB(150, 0, 200)

local BypassButton = Instance.new("TextButton", BypassFrame)
BypassButton.Size = UDim2.new(1, -10, 1, -10)
BypassButton.Position = UDim2.fromOffset(5, 5)
BypassButton.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
BypassButton.Text = "bypass anti-cheat 😈"
BypassButton.Font = Enum.Font.GothamBold
BypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BypassButton.TextSize = 14
BypassButton.AutoButtonColor = false

local BypassBtnCorner = Instance.new("UICorner", BypassButton)
BypassBtnCorner.CornerRadius = UDim.new(0, 6)

-- Overlay bypass
local Overlay = Instance.new("Frame", ScreenGui)
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.Visible = false
Overlay.ZIndex = 100

local OverlayText = Instance.new("TextLabel", Overlay)
OverlayText.Size = UDim2.fromScale(1, 1)
OverlayText.BackgroundTransparency = 1
OverlayText.TextWrapped = true
OverlayText.TextYAlignment = Enum.TextYAlignment.Center
OverlayText.Font = Enum.Font.GothamBold
OverlayText.TextSize = 36
OverlayText.TextColor3 = Color3.new(1, 1, 1)
OverlayText.ZIndex = 101
OverlayText.Text = "injecting 💉...\n\nhttps://discord.gg/aSM5RqqgZg\nBy isxm and izxmi 😈"

local LoadBG = Instance.new("Frame", Overlay)
LoadBG.Size = UDim2.fromScale(0.5, 0.025)
LoadBG.Position = UDim2.fromScale(0.25, 0.1)
LoadBG.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
LoadBG.BorderSizePixel = 0
LoadBG.ZIndex = 101
Instance.new("UICorner", LoadBG)

local LoadFill = Instance.new("Frame", LoadBG)
LoadFill.Size = UDim2.fromScale(0, 1)
LoadFill.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
LoadFill.BorderSizePixel = 0
LoadFill.ZIndex = 102
Instance.new("UICorner", LoadFill)

BypassButton.MouseEnter:Connect(function()
	BypassButton.BackgroundColor3 = Color3.fromRGB(170, 20, 220)
end)

BypassButton.MouseLeave:Connect(function()
	BypassButton.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
end)

BypassButton.MouseButton1Click:Connect(function()
	Overlay.Visible = true
	LoadFill.Size = UDim2.fromScale(0, 1)
	TweenService:Create(Overlay, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
	
	for i = 1, 100 do
		LoadFill.Size = UDim2.fromScale(i/100, 1)
		task.wait(0.03)
	end
	
	task.wait(0.4)
	TweenService:Create(Overlay, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
	task.wait(0.6)
	Overlay.Visible = false
end)

----------------------------------------------------------------
-- TOGGLES VISUAL
----------------------------------------------------------------
createAetherToggle(VisualPage, "esp players", function(v) ESPEnabled = v end)
createAetherToggle(VisualPage, "esp distance", function(v) ESPShowDistance = v end)
createAetherToggle(VisualPage, "esp names", function(v) ESPShowNames = v end)
createAetherToggle(VisualPage, "esp brainrot 🧠", function(v) ESPBrainrotEnabled = v end)
createAetherToggle(VisualPage, "wallhack", function(v) WallhackEnabled = v end)

-- Wallhack Mode Button
local WallhackModeFrame = Instance.new("Frame", VisualPage)
WallhackModeFrame.Size = UDim2.fromOffset(300, 45)
WallhackModeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
WallhackModeFrame.BorderSizePixel = 0

local WallhackModeCorner = Instance.new("UICorner", WallhackModeFrame)
WallhackModeCorner.CornerRadius = UDim.new(0, 8)

local WallhackModeStroke = Instance.new("UIStroke", WallhackModeFrame)
WallhackModeStroke.Thickness = 2
WallhackModeStroke.Color = Color3.fromRGB(80, 80, 90)

local WallhackModeButton = Instance.new("TextButton", WallhackModeFrame)
WallhackModeButton.Size = UDim2.fromOffset(120, 35)
WallhackModeButton.Position = UDim2.fromOffset(170, 5)
WallhackModeButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
WallhackModeButton.Text = "Smart"
WallhackModeButton.Font = Enum.Font.GothamBold
WallhackModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WallhackModeButton.TextSize = 12
WallhackModeButton.AutoButtonColor = false

local WallhackModeBtnCorner = Instance.new("UICorner", WallhackModeButton)
WallhackModeBtnCorner.CornerRadius = UDim.new(0, 6)

local WallhackModeLabel = Instance.new("TextLabel", WallhackModeFrame)
WallhackModeLabel.Size = UDim2.fromOffset(155, 35)
WallhackModeLabel.Position = UDim2.fromOffset(10, 5)
WallhackModeLabel.BackgroundTransparency = 1
WallhackModeLabel.Text = "wallhack mode"
WallhackModeLabel.Font = Enum.Font.GothamBold
WallhackModeLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
WallhackModeLabel.TextSize = 14
WallhackModeLabel.TextXAlignment = Enum.TextXAlignment.Left

WallhackModeButton.MouseButton1Click:Connect(function()
	if WallhackMode == "Smart" then
		WallhackMode = "WallsOnly"
		WallhackModeButton.Text = "WallsOnly"
	elseif WallhackMode == "WallsOnly" then
		WallhackMode = "Full"
		WallhackModeButton.Text = "Full"
	else
		WallhackMode = "Smart"
		WallhackModeButton.Text = "Smart"
	end
	LastScan = 0
end)

----------------------------------------------------------------
-- 🚀 TELEPORT PAGE - FLY TO BASE (NOUVEAU)
----------------------------------------------------------------

-- Instructions
local InstructionsLabel = Instance.new("TextLabel", TeleportPage)
InstructionsLabel.Size = UDim2.fromOffset(300, 60)
InstructionsLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InstructionsLabel.BorderSizePixel = 0
InstructionsLabel.Text = "1. Stand at your base\n2. Click 'Set Base Position'\n3. Use 'Fly to Base' anytime!"
InstructionsLabel.Font = Enum.Font.Gotham
InstructionsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InstructionsLabel.TextSize = 12
InstructionsLabel.TextWrapped = true
InstructionsLabel.TextYAlignment = Enum.TextYAlignment.Top

local InstructionsCorner = Instance.new("UICorner", InstructionsLabel)
InstructionsCorner.CornerRadius = UDim.new(0, 8)

-- Set Base Position Button
local SetBaseFrame = Instance.new("Frame", TeleportPage)
SetBaseFrame.Size = UDim2.fromOffset(300, 45)
SetBaseFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SetBaseFrame.BorderSizePixel = 0

local SetBaseCorner = Instance.new("UICorner", SetBaseFrame)
SetBaseCorner.CornerRadius = UDim.new(0, 8)

local SetBaseStroke = Instance.new("UIStroke", SetBaseFrame)
SetBaseStroke.Thickness = 2
SetBaseStroke.Color = Color3.fromRGB(80, 80, 90)

local SetBaseButton = Instance.new("TextButton", SetBaseFrame)
SetBaseButton.Size = UDim2.fromOffset(120, 35)
SetBaseButton.Position = UDim2.fromOffset(170, 5)
SetBaseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SetBaseButton.Text = "SET BASE"
SetBaseButton.Font = Enum.Font.GothamBold
SetBaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SetBaseButton.TextSize = 12
SetBaseButton.AutoButtonColor = false

local SetBaseBtnCorner = Instance.new("UICorner", SetBaseButton)
SetBaseBtnCorner.CornerRadius = UDim.new(0, 6)

local SetBaseBtnStroke = Instance.new("UIStroke", SetBaseButton)
SetBaseBtnStroke.Thickness = 2
SetBaseBtnStroke.Color = Color3.fromRGB(100, 180, 255)

local SetBaseLabel = Instance.new("TextLabel", SetBaseFrame)
SetBaseLabel.Size = UDim2.fromOffset(155, 35)
SetBaseLabel.Position = UDim2.fromOffset(10, 5)
SetBaseLabel.BackgroundTransparency = 1
SetBaseLabel.Text = "set base position 📍"
SetBaseLabel.Font = Enum.Font.GothamBold
SetBaseLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
SetBaseLabel.TextSize = 14
SetBaseLabel.TextXAlignment = Enum.TextXAlignment.Left

SetBaseButton.MouseEnter:Connect(function()
	SetBaseButton.BackgroundColor3 = Color3.fromRGB(20, 170, 255)
end)

SetBaseButton.MouseLeave:Connect(function()
	SetBaseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

SetBaseButton.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		basePosition = char.HumanoidRootPart.Position
		
		-- Animation feedback
		TweenService:Create(SetBaseButton, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		}):Play()
		SetBaseButton.Text = "✅ SAVED"
		
		task.wait(1)
		
		TweenService:Create(SetBaseButton, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		}):Play()
		SetBaseButton.Text = "SET BASE"
	end
end)

-- Fly to Base Toggle
local FlyToBaseFrame = Instance.new("Frame", TeleportPage)
FlyToBaseFrame.Size = UDim2.fromOffset(300, 45)
FlyToBaseFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FlyToBaseFrame.BorderSizePixel = 0

local FlyToBaseCorner = Instance.new("UICorner", FlyToBaseFrame)
FlyToBaseCorner.CornerRadius = UDim.new(0, 8)

local FlyToBaseStroke = Instance.new("UIStroke", FlyToBaseFrame)
FlyToBaseStroke.Thickness = 2
FlyToBaseStroke.Color = Color3.fromRGB(80, 80, 90)

local FlyToBaseButton = Instance.new("TextButton", FlyToBaseFrame)
FlyToBaseButton.Size = UDim2.fromOffset(120, 35)
FlyToBaseButton.Position = UDim2.fromOffset(170, 5)
FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
FlyToBaseButton.Text = "FLY"
FlyToBaseButton.Font = Enum.Font.GothamBold
FlyToBaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToBaseButton.TextSize = 12
FlyToBaseButton.AutoButtonColor = false

local FlyToBaseBtnCorner = Instance.new("UICorner", FlyToBaseButton)
FlyToBaseBtnCorner.CornerRadius = UDim.new(0, 6)

local FlyToBaseBtnStroke = Instance.new("UIStroke", FlyToBaseButton)
FlyToBaseBtnStroke.Thickness = 2
FlyToBaseBtnStroke.Color = Color3.fromRGB(180, 100, 255)

local FlyToBaseLabel = Instance.new("TextLabel", FlyToBaseFrame)
FlyToBaseLabel.Size = UDim2.fromOffset(155, 35)
FlyToBaseLabel.Position = UDim2.fromOffset(10, 5)
FlyToBaseLabel.BackgroundTransparency = 1
FlyToBaseLabel.Text = "fly to base ✈️"
FlyToBaseLabel.Font = Enum.Font.GothamBold
FlyToBaseLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
FlyToBaseLabel.TextSize = 14
FlyToBaseLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Status Label
local FlyStatusLabel = Instance.new("TextLabel", TeleportPage)
FlyStatusLabel.Size = UDim2.fromOffset(300, 30)
FlyStatusLabel.BackgroundTransparency = 1
FlyStatusLabel.Text = "Status: Waiting..."
FlyStatusLabel.Font = Enum.Font.GothamBold
FlyStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
FlyStatusLabel.TextSize = 12
FlyStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

FlyToBaseButton.MouseEnter:Connect(function()
	FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
end)

FlyToBaseButton.MouseLeave:Connect(function()
	if FlyToBaseEnabled then
		FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
	else
		FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end
end)

FlyToBaseButton.MouseButton1Click:Connect(function()
	if not basePosition then
		FlyStatusLabel.Text = "❌ Set base position first!"
		FlyStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	FlyToBaseEnabled = not FlyToBaseEnabled
	
	if FlyToBaseEnabled then
		FlyToBaseButton.Text = "STOP"
		FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
		FlyToBaseBtnStroke.Color = Color3.fromRGB(255, 100, 120)
		FlyToBaseStroke.Color = Color3.fromRGB(255, 60, 100)
		FlyStatusLabel.Text = "Status: Flying to base..."
		FlyStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		
		local char = LocalPlayer.Character
		if not char then return end
		
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")
		
		if not hrp or not hum then return end
		
		-- Change state to flying
		hum:ChangeState(Enum.HumanoidStateType.Physics)
		
		flyConnection = RunService.Heartbeat:Connect(function()
			if not FlyToBaseEnabled then return end
			
			local char = LocalPlayer.Character
			if not char then return end
			
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			
			-- Calculate direction and distance
			local direction = (basePosition - hrp.Position).Unit
			local distance = (basePosition - hrp.Position).Magnitude
			
			-- Check if arrived
			if distance < 5 then
				-- Stop flying
				FlyToBaseEnabled = false
				hrp.Velocity = Vector3.new(0, 0, 0)
				
				local hum = char:FindFirstChild("Humanoid")
				if hum then
					hum:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
				
				if flyConnection then
					flyConnection:Disconnect()
					flyConnection = nil
				end
				
				FlyToBaseButton.Text = "FLY"
				FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
				FlyToBaseBtnStroke.Color = Color3.fromRGB(180, 100, 255)
				FlyToBaseStroke.Color = Color3.fromRGB(80, 80, 90)
				FlyStatusLabel.Text = "Status: ✅ Arrived!"
				FlyStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
				
				task.delay(2, function()
					FlyStatusLabel.Text = "Status: Waiting..."
					FlyStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
				end)
			else
				-- Continue flying with smooth velocity
				local flySpeed = 50
				hrp.Velocity = direction * flySpeed + Vector3.new(0, 5, 0)  -- Add slight upward force
			end
		end)
	else
		FlyToBaseButton.Text = "FLY"
		FlyToBaseButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		FlyToBaseBtnStroke.Color = Color3.fromRGB(180, 100, 255)
		FlyToBaseStroke.Color = Color3.fromRGB(80, 80, 90)
		FlyStatusLabel.Text = "Status: Stopped"
		FlyStatusLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
		
		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		
		local char = LocalPlayer.Character
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChild("Humanoid")
			
			if hrp then
				hrp.Velocity = Vector3.new(0, 0, 0)
			end
			
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
		
		task.delay(2, function()
			FlyStatusLabel.Text = "Status: Waiting..."
			FlyStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		end)
	end
end)

-- Instant TP Button
local InstantTPFrame = Instance.new("Frame", TeleportPage)
InstantTPFrame.Size = UDim2.fromOffset(300, 45)
InstantTPFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InstantTPFrame.BorderSizePixel = 0

local InstantTPCorner = Instance.new("UICorner", InstantTPFrame)
InstantTPCorner.CornerRadius = UDim.new(0, 8)

local InstantTPStroke = Instance.new("UIStroke", InstantTPFrame)
InstantTPStroke.Thickness = 2
InstantTPStroke.Color = Color3.fromRGB(255, 150, 0)

local InstantTPButton = Instance.new("TextButton", InstantTPFrame)
InstantTPButton.Size = UDim2.new(1, -10, 1, -10)
InstantTPButton.Position = UDim2.fromOffset(5, 5)
InstantTPButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
InstantTPButton.Text = "⚡ INSTANT TP TO BASE ⚡"
InstantTPButton.Font = Enum.Font.GothamBold
InstantTPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantTPButton.TextSize = 14
InstantTPButton.AutoButtonColor = false

local InstantTPBtnCorner = Instance.new("UICorner", InstantTPButton)
InstantTPBtnCorner.CornerRadius = UDim.new(0, 6)

InstantTPButton.MouseEnter:Connect(function()
	InstantTPButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
end)

InstantTPButton.MouseLeave:Connect(function()
	InstantTPButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
end)

InstantTPButton.MouseButton1Click:Connect(function()
	if not basePosition then
		FlyStatusLabel.Text = "❌ Set base position first!"
		FlyStatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		return
	end
	
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(basePosition)
		
		-- Animation feedback
		TweenService:Create(InstantTPButton, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		}):Play()
		
		FlyStatusLabel.Text = "Status: ⚡ Teleported!"
		FlyStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
		
		task.wait(0.3)
		
		TweenService:Create(InstantTPButton, TweenInfo.new(0.3), {
			BackgroundColor3 = Color3.fromRGB(255, 150, 0)
		}):Play()
		
		task.delay(1.5, function()
			FlyStatusLabel.Text = "Status: Waiting..."
			FlyStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		end)
	end
end)

----------------------------------------------------------------
-- AETHER SPEED UI 💉
----------------------------------------------------------------
local SpeedFrame = Instance.new("Frame", ScreenGui)
SpeedFrame.Size = UDim2.fromOffset(280, 100)
SpeedFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Active = true
SpeedFrame.Draggable = true

local SpeedCorner = Instance.new("UICorner", SpeedFrame)
SpeedCorner.CornerRadius = UDim.new(0, 12)

local SpeedStroke = Instance.new("UIStroke", SpeedFrame)
SpeedStroke.Thickness = 2
SpeedStroke.Color = Color3.fromRGB(138, 43, 226)
SpeedStroke.Transparency = 0.3

local SpeedTitle = Instance.new("TextLabel", SpeedFrame)
SpeedTitle.Size = UDim2.new(1, -20, 0, 25)
SpeedTitle.Position = UDim2.new(0, 10, 0, 5)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "aether speed 💉"
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
SpeedTitle.TextSize = 16
SpeedTitle.TextXAlignment = Enum.TextXAlignment.Left

local SpeedContainer = Instance.new("Frame", SpeedFrame)
SpeedContainer.Size = UDim2.fromOffset(260, 50)
SpeedContainer.Position = UDim2.fromOffset(10, 35)
SpeedContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SpeedContainer.BorderSizePixel = 0

local ContainerCorner = Instance.new("UICorner", SpeedContainer)
ContainerCorner.CornerRadius = UDim.new(0, 8)

local ContainerStroke = Instance.new("UIStroke", SpeedContainer)
ContainerStroke.Thickness = 2
ContainerStroke.Color = Color3.fromRGB(80, 80, 90)

local SpeedToggle = Instance.new("TextButton", SpeedContainer)
SpeedToggle.Size = UDim2.fromOffset(165, 40)
SpeedToggle.Position = UDim2.fromOffset(5, 5)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SpeedToggle.Text = "ENABLE"
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextSize = 14
SpeedToggle.AutoButtonColor = false

local SpeedToggleCorner = Instance.new("UICorner", SpeedToggle)
SpeedToggleCorner.CornerRadius = UDim.new(0, 6)

local SpeedToggleStroke = Instance.new("UIStroke", SpeedToggle)
SpeedToggleStroke.Thickness = 2
SpeedToggleStroke.Color = Color3.fromRGB(180, 100, 255)

local SpeedInput = Instance.new("TextBox", SpeedContainer)
SpeedInput.Size = UDim2.fromOffset(80, 40)
SpeedInput.Position = UDim2.fromOffset(175, 5)
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.PlaceholderText = "25"
SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedInput.Text = "25"
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 18
SpeedInput.ClearTextOnFocus = false

local InputCorner = Instance.new("UICorner", SpeedInput)
InputCorner.CornerRadius = UDim.new(0, 6)

local InputStroke = Instance.new("UIStroke", SpeedInput)
InputStroke.Thickness = 2
InputStroke.Color = Color3.fromRGB(80, 80, 90)

SpeedToggle.MouseEnter:Connect(function()
	SpeedToggle.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
end)

SpeedToggle.MouseLeave:Connect(function()
	if isSpeedEnabled then
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
	else
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	end
end)

SpeedToggle.MouseButton1Click:Connect(function()
	isSpeedEnabled = not isSpeedEnabled
	
	if isSpeedEnabled then
		SpeedToggle.Text = "DISABLE"
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
		SpeedToggleStroke.Color = Color3.fromRGB(255, 100, 120)
		SpeedStroke.Color = Color3.fromRGB(255, 60, 100)
		SpeedTitle.TextColor3 = Color3.fromRGB(255, 150, 180)
		ContainerStroke.Color = Color3.fromRGB(255, 60, 100)
		
		speedValue = tonumber(SpeedInput.Text) or 25
		
		velocityConnection = RunService.Heartbeat:Connect(function()
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			
			if hrp and hum then
				local moveDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z) * speedValue
				hrp.Velocity = hrp.Velocity:Lerp(Vector3.new(moveDir.X, hrp.Velocity.Y, moveDir.Z), 0.45)
			end
		end)
	else
		SpeedToggle.Text = "ENABLE"
		SpeedToggle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
		SpeedToggleStroke.Color = Color3.fromRGB(180, 100, 255)
		SpeedStroke.Color = Color3.fromRGB(138, 43, 226)
		SpeedTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
		ContainerStroke.Color = Color3.fromRGB(80, 80, 90)
		
		if velocityConnection then
			velocityConnection:Disconnect()
			velocityConnection = nil
		end
	end
end)

SpeedInput.FocusLost:Connect(function()
	local value = tonumber(SpeedInput.Text)
	if not value then
		SpeedInput.Text = "25"
	else
		SpeedInput.Text = tostring(math.clamp(value, 1, 200))
	end
end)

----------------------------------------------------------------
-- TOKINU HUB MINI UI 💜
----------------------------------------------------------------
local TokinuFrame = Instance.new("Frame", ScreenGui)
TokinuFrame.Size = UDim2.fromOffset(180, 120)
TokinuFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
TokinuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TokinuFrame.BorderSizePixel = 0
TokinuFrame.Active = true
TokinuFrame.Draggable = true

local TokinuCorner = Instance.new("UICorner", TokinuFrame)
TokinuCorner.CornerRadius = UDim.new(0, 12)

local TokinuStroke = Instance.new("UIStroke", TokinuFrame)
TokinuStroke.Thickness = 2
TokinuStroke.Color = Color3.fromRGB(138, 43, 226)
TokinuStroke.Transparency = 0.3

local TokinuTitle = Instance.new("TextLabel", TokinuFrame)
TokinuTitle.Size = UDim2.new(1, -20, 0, 24)
TokinuTitle.Position = UDim2.new(0, 10, 0, 6)
TokinuTitle.BackgroundTransparency = 1
TokinuTitle.Text = "aether allow/disallow 💜"
TokinuTitle.Font = Enum.Font.GothamBold
TokinuTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
TokinuTitle.TextSize = 14
TokinuTitle.TextXAlignment = Enum.TextXAlignment.Center

local TokinuAllowButton = Instance.new("TextButton", TokinuFrame)
TokinuAllowButton.Size = UDim2.new(1, -30, 0, 70)
TokinuAllowButton.Position = UDim2.new(0, 15, 0, 40)
TokinuAllowButton.Text = "Allow Friends"
TokinuAllowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TokinuAllowButton.Font = Enum.Font.GothamBold
TokinuAllowButton.TextSize = 16
TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
TokinuAllowButton.BorderSizePixel = 0
TokinuAllowButton.AutoButtonColor = false

local TokinuButtonCorner = Instance.new("UICorner", TokinuAllowButton)
TokinuButtonCorner.CornerRadius = UDim.new(0, 10)

local TokinuButtonStroke = Instance.new("UIStroke", TokinuAllowButton)
TokinuButtonStroke.Thickness = 2
TokinuButtonStroke.Color = Color3.fromRGB(180, 100, 255)

local isFriendsAllowed = true

TokinuAllowButton.MouseEnter:Connect(function()
	TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(158, 63, 246)
end)

TokinuAllowButton.MouseLeave:Connect(function()
	if isFriendsAllowed then
		TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
	else
		TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
	end
end)

TokinuAllowButton.MouseButton1Click:Connect(function()
	pcall(function()
		isFriendsAllowed = not isFriendsAllowed
		
		if isFriendsAllowed then
			TokinuAllowButton.Text = "Allow Friends"
			TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
			TokinuButtonStroke.Color = Color3.fromRGB(180, 100, 255)
			TokinuStroke.Color = Color3.fromRGB(138, 43, 226)
		else
			TokinuAllowButton.Text = "Disallow"
			TokinuAllowButton.BackgroundColor3 = Color3.fromRGB(255, 60, 100)
			TokinuButtonStroke.Color = Color3.fromRGB(255, 100, 120)
			TokinuStroke.Color = Color3.fromRGB(255, 60, 100)
		end
		
		game:GetService('ReplicatedStorage'):WaitForChild('Packages'):WaitForChild('Net'):WaitForChild('RE/PlotService/ToggleFriends'):FireServer()
	end)
end)

----------------------------------------------------------------
-- BARRE DE PROGRESSION AUTO GRAB 🧲
----------------------------------------------------------------
local GrabIndicator = Instance.new("Frame", ScreenGui)
GrabIndicator.Size = UDim2.fromOffset(400, 18)
GrabIndicator.Position = UDim2.new(0.5, -200, 0.02, 0)
GrabIndicator.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
GrabIndicator.BorderSizePixel = 0
GrabIndicator.Visible = false
GrabIndicator.ZIndex = 100

local GrabCorner = Instance.new("UICorner", GrabIndicator)
GrabCorner.CornerRadius = UDim.new(0, 9)

local GrabGlow = Instance.new("UIStroke", GrabIndicator)
GrabGlow.Color = Color3.fromRGB(200, 0, 255)
GrabGlow.Thickness = 3
GrabGlow.Transparency = 0.3

local GrabFill = Instance.new("Frame", GrabIndicator)
GrabFill.Size = UDim2.fromScale(0, 1)
GrabFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
GrabFill.BorderSizePixel = 0
GrabFill.ZIndex = 101

local GrabFillCorner = Instance.new("UICorner", GrabFill)
GrabFillCorner.CornerRadius = UDim.new(0, 9)

local GrabGradient = Instance.new("UIGradient", GrabFill)
GrabGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
}

local GrabText = Instance.new("TextLabel", GrabIndicator)
GrabText.Size = UDim2.fromScale(1, 1)
GrabText.BackgroundTransparency = 1
GrabText.Text = "🧲 Grabbing..."
GrabText.Font = Enum.Font.GothamBold
GrabText.TextSize = 14
GrabText.TextColor3 = Color3.new(1, 1, 1)
GrabText.ZIndex = 102

local GrabTextStroke = Instance.new("UIStroke", GrabText)
GrabTextStroke.Thickness = 2

local function showGrabProgress(brainrotName)
	GrabIndicator.Visible = true
	GrabText.Text = "🧲 GRABBED: " .. (brainrotName or "Brainrot") .. " ✅"
	GrabFill.Size = UDim2.fromScale(0, 1)
	
	TweenService:Create(GrabFill, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromScale(1, 1)
	}):Play()
	
	task.delay(1.8, function()
		TweenService:Create(GrabIndicator, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		TweenService:Create(GrabFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		TweenService:Create(GrabText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		TweenService:Create(GrabGlow, TweenInfo.new(0.4), {Transparency = 1}):Play()
		
		task.wait(0.4)
		GrabIndicator.Visible = false
		GrabIndicator.BackgroundTransparency = 0
		GrabFill.BackgroundTransparency = 0
		GrabText.TextTransparency = 0
		GrabGlow.Transparency = 0.3
	end)
end

----------------------------------------------------------------
-- 🧠 ESP BRAINROT SYSTEM
----------------------------------------------------------------
local function createESPBrainrot(brainrot)
	if not brainrot:IsA("Tool") then return end
	if ESPBrainrotObjects[brainrot] then return end
	if not isBrainrot(brainrot.Name) then return end
	
	local handle = brainrot:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end
	
	-- Hitbox violette
	local hitbox = Instance.new("BoxHandleAdornment")
	hitbox.Name = "follow me @rznnq"
	hitbox.Adornee = handle
	hitbox.Size = handle.Size + Vector3.new(1, 1, 1)
	hitbox.Color3 = Color3.fromRGB(128, 0, 128)
	hitbox.Transparency = 0.6
	hitbox.ZIndex = 10
	hitbox.AlwaysOnTop = true
	hitbox.Parent = handle
	
	-- Billboard avec nom
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "cpsito riko"
	billboard.Adornee = handle
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = handle
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = brainrot.Name
	label.TextColor3 = Color3.fromRGB(255, 0, 255)
	label.Font = Enum.Font.Arcade
	label.TextScaled = true
	label.TextStrokeTransparency = 0.7
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.Parent = billboard
	
	ESPBrainrotObjects[brainrot] = {hitbox = hitbox, billboard = billboard}
end

local function removeESPBrainrot(brainrot)
	if not ESPBrainrotObjects[brainrot] then return end
	
	local data = ESPBrainrotObjects[brainrot]
	if data.hitbox then data.hitbox:Destroy() end
	if data.billboard then data.billboard:Destroy() end
	
	ESPBrainrotObjects[brainrot] = nil
end

local function enableESPBrainrot()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Tool") and isBrainrot(obj.Name) then
			createESPBrainrot(obj)
		end
	end
	
	local descConn = workspace.DescendantAdded:Connect(function(obj)
		if ESPBrainrotEnabled and obj:IsA("Tool") and isBrainrot(obj.Name) then
			task.wait(0.1)
			createESPBrainrot(obj)
		end
	end)
	table.insert(espBrainrotConnections, descConn)
	
	local descRemovedConn = workspace.DescendantRemoving:Connect(function(obj)
		if obj:IsA("Tool") then
			removeESPBrainrot(obj)
		end
	end)
	table.insert(espBrainrotConnections, descRemovedConn)
end

local function disableESPBrainrot()
	for brainrot, _ in pairs(ESPBrainrotObjects) do
		removeESPBrainrot(brainrot)
	end
	
	for _, conn in ipairs(espBrainrotConnections) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	espBrainrotConnections = {}
end

task.spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if ESPBrainrotEnabled then
				if #espBrainrotConnections == 0 then
					enableESPBrainrot()
				end
			else
				if #espBrainrotConnections > 0 then
					disableESPBrainrot()
				end
			end
		end)
	end
end)

----------------------------------------------------------------
-- AUTO GRAB SYSTEM 🧲
----------------------------------------------------------------
local lastGrabTime = 0
local grabCooldown = 0.7

local function hasBrainrotEquipped()
	local char = LocalPlayer.Character
	if not char then return false end
	
	for _, child in pairs(char:GetChildren()) do
		if child:IsA("Tool") and isBrainrot(child.Name) then
			return true
		end
	end
	
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if backpack then
		for _, tool in pairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and isBrainrot(tool.Name) then
				return true
			end
		end
	end
	
	return false
end

local function findClosestBrainrot()
	local char = LocalPlayer.Character
	if not char then return nil end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	
	local closest = nil
	local closestDist = AutoGrabRange
	
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Tool") and isBrainrot(obj.Name) then
			local handle = obj:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				local dist = (hrp.Position - handle.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closest = obj
				end
			end
		end
	end
	
	return closest
end

local function grabBrainrot(brainrot)
	local char = LocalPlayer.Character
	if not char then return false end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	
	local prompt = brainrot:FindFirstChildOfClass("ProximityPrompt", true)
	if prompt then
		pcall(function()
			fireproximityprompt(prompt)
		end)
		return true
	end
	
	local clickDetector = brainrot:FindFirstChildOfClass("ClickDetector", true)
	if clickDetector then
		pcall(function()
			fireclickdetector(clickDetector)
		end)
		return true
	end
	
	pcall(function()
		local handle = brainrot:FindFirstChild("Handle")
		if handle then
			handle.CFrame = hrp.CFrame
			task.wait(0.05)
		end
		
		brainrot.Parent = char
		task.wait(0.1)
		
		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:EquipTool(brainrot)
		end
	end)
	
	return true
end

task.spawn(function()
	while task.wait(0.4) do
		pcall(function()
			if not AutoGrabEnabled then return end
			
			local char = LocalPlayer.Character
			if not char then return end
			
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			
			local currentTime = tick()
			
			if currentTime - lastGrabTime < grabCooldown then
				return
			end
			
			if hasBrainrotEquipped() then
				return
			end
			
			local brainrot = findClosestBrainrot()
			if not brainrot then return end
			
			local success = grabBrainrot(brainrot)
			if success then
				lastGrabTime = currentTime
				showGrabProgress(brainrot.Name)
			end
		end)
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	lastGrabTime = 0
end)

----------------------------------------------------------------
-- ANTI-RAGDOLL
----------------------------------------------------------------
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

----------------------------------------------------------------
-- ANTI-KB
----------------------------------------------------------------
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

----------------------------------------------------------------
-- GRAB ASSIST
----------------------------------------------------------------
task.spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if GrabAssistEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				for _,p in pairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
						if dist < 10 then
							-- Grab assist logic
						end
					end
				end
			end
		end)
	end
end)

----------------------------------------------------------------
-- ESP PLAYERS
----------------------------------------------------------------
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
-- WALLHACK
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

print("✅ AETHER HUB V11 - AETHER STYLE 💉")
print("💉 Aether Speed intégré")
print("💜 By isxm and izxmi - discord.gg/aSM5RqqgZg")
