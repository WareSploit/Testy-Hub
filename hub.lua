local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local DISCORD_INVITE = "https://discord.gg/8vafV9Ap5"
local HUB_CATALOG = "https://raw.githubusercontent.com/WareSploit/Testy-Hub/main/catalog.json"

local function getGui()
	local ok, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok and cg then return cg end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local Colors = {
	BG = Color3.fromRGB(37, 37, 37),
	BAR = Color3.fromRGB(32, 32, 32),
	SURFACE = Color3.fromRGB(44, 44, 44),
	HOVER = Color3.fromRGB(53, 53, 53),
	LINE = Color3.fromRGB(57, 57, 57),
	BORDER = Color3.fromRGB(29, 29, 29),
	TEXT = Color3.fromRGB(255, 255, 255),
	DIM = Color3.fromRGB(172, 172, 172),
	ACCENT = Color3.fromRGB(102, 172, 255),
	RED = Color3.fromRGB(220, 60, 70),
	GREEN = Color3.fromRGB(80, 200, 120),
	YELLOW = Color3.fromRGB(240, 190, 80),
}

local FontRegular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FontBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local function create(class, props, parent)
	local i = Instance.new(class)
	for k, v in pairs(props or {}) do i[k] = v end
	if parent then i.Parent = parent end
	return i
end

local function corner(r, p)
	return create("UICorner", { CornerRadius = UDim.new(0, r) }, p)
end

local function stroke(color, thickness, p)
	return create("UIStroke", { Color = color, Thickness = thickness }, p)
end

local function tween(instance, t, props, style, dir)
	local info = TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local track = TweenService:Create(instance, info, props)
	track:Play()
	return track
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local function pointInGui(g, pos)
	local ap, as = g.AbsolutePosition, g.AbsoluteSize
	return pos.X >= ap.X and pos.X <= ap.X + as.X
		and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
end

if getgenv and getgenv().TestyHubGUI then
	pcall(function() getgenv().TestyHubGUI:Destroy() end)
end

local gui = create("ScreenGui", {
	Name = "TestyHubGui",
	IgnoreGuiInset = true,
	ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = getGui(),
})

if getgenv then
	getgenv().TestyHubGUI = gui
end

local main = create("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromOffset(334, 250),
	Position = UDim2.new(0.5, -167, 0.5, -125),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Active = true,
	Visible = false,
	Parent = gui,
})
corner(6, main)
stroke(Colors.BORDER, 2, main)

create("TextLabel", {
	Name = "UiTitle",
	Size = UDim2.new(1, 0, 0, 30),
	BackgroundTransparency = 1,
	Text = "Testy Hub",
	TextColor3 = Colors.TEXT,
	TextSize = 20,
	FontFace = FontBold,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 60,
	Parent = main,
})

create("ImageLabel", {
	Name = "SVG",
	Size = UDim2.fromOffset(20, 20),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundTransparency = 1,
	Image = "rbxassetid://1072321290",
	ImageColor3 = Colors.ACCENT,
	ZIndex = 61,
	Parent = main,
})

local closeBtn = create("TextButton", {
	Name = "Close",
	Size = UDim2.fromOffset(24, 24),
	Position = UDim2.new(1, -30, 0, 3),
	BackgroundColor3 = Colors.BAR,
	BackgroundTransparency = 0.3,
	Text = "X",
	TextColor3 = Colors.TEXT,
	TextSize = 16,
	FontFace = FontBold,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	ZIndex = 61,
	Parent = main,
})
corner(4, closeBtn)

local topbar = create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 29),
	Position = UDim2.new(0, 0, 0, 30),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 55,
	Parent = main,
})

create("Frame", {
	Name = "Line",
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = Colors.LINE,
	BorderSizePixel = 0,
	ZIndex = 56,
	Parent = topbar,
})

local function makeTab(internalName, text, xOff)
	return create("TextButton", {
		Name = "Tab_" .. internalName,
		Size = UDim2.fromOffset(111, 29),
		Position = UDim2.fromOffset(xOff, 0),
		BackgroundColor3 = Colors.BAR,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = Colors.TEXT,
		TextSize = 14,
		FontFace = FontRegular,
		AutoButtonColor = false,
		ZIndex = 57,
		Parent = topbar,
	})
end

makeTab("Main", "Scripts", 0)
makeTab("Player", "Featured", 111)
makeTab("Settings", "Socials", 222)

local content = create("Frame", {
	Name = "Content",
	Size = UDim2.new(1, 0, 1, -59),
	Position = UDim2.new(0, 0, 0, 59),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	ZIndex = 54,
	Parent = main,
})

local function makePage(name, visible)
	local p = create("ScrollingFrame", {
		Name = "Page_" .. name,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Colors.LINE,
		Visible = visible,
		ZIndex = 55,
		Parent = content,
	})
	create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, p)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 5),
	}, p)
	return p
end

local pageMain = makePage("Main", true)
local pagePlayer = makePage("Player", false)
local pageSettings = makePage("Settings", false)

local function addLabel(parent, text)
	return create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = text or "",
		TextColor3 = Colors.DIM,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent,
	})
end

local function addButton(parent, text, cb)
	local b = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.SURFACE,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = Colors.TEXT,
		TextSize = 13,
		FontFace = FontRegular,
		AutoButtonColor = false,
		Parent = parent,
	})
	corner(4, b)
	b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundColor3 = Colors.HOVER }) end)
	b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundColor3 = Colors.SURFACE }) end)
	if cb then
		b.MouseButton1Click:Connect(function()
			local ok, err = pcall(cb)
			if not ok then warn("[TestyHub] " .. tostring(err)) end
		end)
	end
	return b
end

local opener = create("Frame", {
	Name = "TabOpener",
	Size = UDim2.fromOffset(205, 41),
	Position = UDim2.new(0.5, -102, 0, 16),
	BackgroundColor3 = Colors.BG,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Active = true,
	Parent = gui,
})
stroke(Colors.BORDER, 2, opener)

local openBtn = create("ImageButton", {
	Name = "OpenButton",
	Size = UDim2.fromOffset(41, 41),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://1424953189",
	ScaleType = Enum.ScaleType.Fit,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	ZIndex = 100,
	Parent = opener,
})

local versionLabel = create("TextLabel", {
	Name = "Version",
	Size = UDim2.fromOffset(160, 27),
	Position = UDim2.new(0, 46, 0, 7),
	BackgroundTransparency = 1,
	Text = "Testy Hub",
	TextColor3 = Colors.TEXT,
	TextSize = 18,
	FontFace = FontRegular,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = opener,
})

openBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.12, { BackgroundColor3 = Colors.RED, BackgroundTransparency = 0 })
end)
closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.12, { BackgroundColor3 = Colors.BAR, BackgroundTransparency = 0.3 })
end)
closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)

local dragging, dragStart, startPos
opener.InputBegan:Connect(function(input)
	if not isPress(input) then return end
	if pointInGui(openBtn, input.Position) then return end
	dragging = true
	dragStart = input.Position
	startPos = opener.Position
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and isMove(input) then
		local delta = input.Position - dragStart
		opener.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if isPress(input) then dragging = false end
end)

local tabs = {}
for _, child in ipairs(topbar:GetChildren()) do
	if child:IsA("TextButton") and child.Name:match("^Tab_") then
		tabs[#tabs + 1] = child
	end
end

local pages = {}
for _, child in ipairs(content:GetChildren()) do
	if child:IsA("ScrollingFrame") and child.Name:match("^Page_") then
		pages[child.Name:gsub("^Page_", "")] = child
	end
end

local activeTab = nil
local function switchTab(name)
	local btn
	for _, t in ipairs(tabs) do
		if t.Name == "Tab_" .. name then btn = t break end
	end
	local page = pages[name]
	if not btn or not page then return end

	if activeTab then tween(activeTab, 0.15, { BackgroundColor3 = Colors.BAR }) end
	for _, p in pairs(pages) do p.Visible = false end
	activeTab = btn
	tween(btn, 0.15, { BackgroundColor3 = Colors.HOVER })
	page.Visible = true
end

for _, tab in ipairs(tabs) do
	local name = tab.Name:gsub("^Tab_", "")
	tab.MouseEnter:Connect(function()
		if activeTab ~= tab then tween(tab, 0.12, { BackgroundColor3 = Colors.SURFACE }) end
	end)
	tab.MouseLeave:Connect(function()
		if activeTab ~= tab then tween(tab, 0.12, { BackgroundColor3 = Colors.BAR }) end
	end)
	tab.MouseButton1Click:Connect(function() switchTab(name) end)
end

if tabs[1] then switchTab(tabs[1].Name:gsub("^Tab_", "")) end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		opener.Visible = not opener.Visible
		if not opener.Visible then
			main.Visible = false
		end
	end
	if input.KeyCode == Enum.KeyCode.Escape then
		main.Visible = false
	end
end)

local NotifyHolder = create("Frame", {
	Name = "NotifyHolder",
	Size = UDim2.new(0, 280, 1, -20),
	Position = UDim2.new(1, -296, 0, 10),
	BackgroundTransparency = 1,
	Parent = gui,
})
create("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
}, NotifyHolder)

local function Notify(title, content, kind, duration)
	kind = kind or "info"
	duration = duration or 4
	local accent = Colors.ACCENT
	if kind == "success" then accent = Colors.GREEN end
	if kind == "warning" then accent = Colors.YELLOW end
	if kind == "error" then accent = Colors.RED end

	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = Colors.SURFACE,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = NotifyHolder,
	})
	corner(6, card)
	stroke(Colors.LINE, 1, card)

	create("Frame", {
		Size = UDim2.new(0, 3, 1, -12),
		Position = UDim2.new(0, 5, 0, 6),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Parent = card,
	})

	create("TextLabel", {
		Size = UDim2.new(1, -22, 0, 18),
		Position = UDim2.new(0, 14, 0, 6),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Colors.TEXT,
		TextSize = 13,
		FontFace = FontBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = card,
	})

	create("TextLabel", {
		Size = UDim2.new(1, -22, 0, 26),
		Position = UDim2.new(0, 14, 0, 26),
		BackgroundTransparency = 1,
		Text = content,
		TextColor3 = Colors.DIM,
		TextSize = 12,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = card,
	})

	card.Position = UDim2.new(0, 40, 0, 0)
	tween(card, 0.25, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) })

	task.delay(duration, function()
		if not card.Parent then return end
		tween(card, 0.25, { BackgroundTransparency = 1, Position = UDim2.new(0, 40, 0, 0) })
		task.wait(0.3)
		pcall(function() card:Destroy() end)
	end)
end

local catalog
do
	local ok, raw = pcall(function() return game:HttpGet(HUB_CATALOG) end)
	if not ok or not raw or raw == "" then
		Notify("Hub", "Failed to fetch catalog", "error", 5)
		return
	end
	local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok2 or not decoded then
		Notify("Hub", "Bad catalog JSON", "error", 5)
		return
	end
	catalog = decoded
end

versionLabel.Text = "Testy Hub v" .. tostring(catalog.version or "1.0.0")

addLabel(pageMain, "── Testy Hub v" .. tostring(catalog.version or "1.0.0") .. " ──")
addLabel(pageMain, "Search")

local searchBox = create("TextBox", {
	Name = "SearchBox",
	Size = UDim2.new(1, 0, 0, 34),
	BackgroundColor3 = Colors.SURFACE,
	BorderSizePixel = 0,
	Text = "",
	PlaceholderText = "type script name...",
	PlaceholderColor3 = Colors.DIM,
	TextColor3 = Colors.TEXT,
	TextSize = 13,
	FontFace = FontRegular,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	Parent = pageMain,
})
corner(4, searchBox)
create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, searchBox)

addLabel(pageMain, "── Available Scripts ──")

local currentPlace = game.PlaceId
local scriptButtons = {}

local function loadScript(entry)
	Notify("Loading", entry.name, "info", 2)
	task.spawn(function()
		local url = entry.url
		if not url:match("^https?://") then
			url = "https://raw.githubusercontent.com/WareSploit/Testy-Hub/main/" .. url
		end
		local ok, code = pcall(function() return game:HttpGet(url) end)
		if not ok or not code or code == "" then
			Notify("Error", "Download failed: " .. entry.name, "error", 4)
			return
		end
		local okRun, err = pcall(function()
			local fn = loadstring(code)
			if fn then fn() end
		end)
		if okRun then
			Notify("Loaded", entry.name, "success", 3)
		else
			Notify("Error", tostring(err), "error", 5)
		end
	end)
end

for _, gameEntry in ipairs(catalog.games or {}) do
	local matches = (gameEntry.placeId == 0) or (gameEntry.placeId == currentPlace)
	if matches then
		local header = addLabel(pageMain, "▸ " .. gameEntry.name)
		header.TextColor3 = Colors.ACCENT

		for _, scriptEntry in ipairs(gameEntry.scripts or {}) do
			local btn = addButton(pageMain, scriptEntry.name, function()
				loadScript(scriptEntry)
			end)
			table.insert(scriptButtons, { btn = btn, entry = scriptEntry, game = gameEntry.name })
		end
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local query = string.lower(searchBox.Text)
	for _, item in ipairs(scriptButtons) do
		if query == "" then
			item.btn.Visible = true
		else
			local match = string.find(string.lower(item.entry.name), query, 1, true)
				or string.find(string.lower(item.game), query, 1, true)
			item.btn.Visible = match ~= nil
		end
	end
end)

addLabel(pagePlayer, "── Featured ──")
addLabel(pagePlayer, "Hand-picked by WareSploit")

for _, gameEntry in ipairs(catalog.games or {}) do
	for _, scriptEntry in ipairs(gameEntry.scripts or {}) do
		if scriptEntry.featured then
			addButton(pagePlayer, "★ " .. scriptEntry.name, function()
				loadScript(scriptEntry)
			end)
		end
	end
end

addLabel(pageSettings, "── Socials ──")

addButton(pageSettings, "Join Discord", function()
	if setclipboard then
		setclipboard(DISCORD_INVITE)
		Notify("Discord", "Invite copied to clipboard", "success", 3)
	end
	if request then
		pcall(function()
			request({ Url = DISCORD_INVITE, Method = "GET" })
		end)
	end
end)

addLabel(pageSettings, "── Info ──")
addLabel(pageSettings, "Version: " .. tostring(catalog.version or "1.0.0"))
addLabel(pageSettings, "PlaceId: " .. tostring(currentPlace))
addLabel(pageSettings, "Scripts loaded: " .. tostring(#scriptButtons))
addLabel(pageSettings, "Discord: 8vafV9Ap5")

Notify("Testy Hub", "v" .. tostring(catalog.version or "1.0.0") .. " | " .. tostring(#scriptButtons) .. " scripts", "success", 4)
