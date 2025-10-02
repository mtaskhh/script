--[[
	SimpleUI Pro Enhanced - Advanced UI Library for Roblox
	Version: 3.0.0
	Optimized for Injectors with Enhanced Features
]]

local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

-- Constants
local ANIMATION_SPEED = 0.3
local HOVER_SCALE = 1.05
local CLICK_SCALE = 0.95
local SHADOW_TRANSPARENCY = 0.85
local BLUR_SIZE = 24

-- Enhanced Utility Functions
local function GetScreenGui()
	local success, result = pcall(function()
		return CoreGui:FindFirstChild("SimpleUI_Pro_Enhanced")
	end)
	
	if success and result then
		return result
	end
	
	local player = Players.LocalPlayer
	if player then
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			return playerGui:FindFirstChild("SimpleUI_Pro_Enhanced")
		end
	end
end

local function CreateScreenGui(name, parent)
	local screen = Instance.new("ScreenGui")
	screen.Name = name or "SimpleUI_Pro_Enhanced"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.DisplayOrder = 999999
	screen.IgnoreGuiInset = true
	
	local success = pcall(function()
		screen.Parent = parent or CoreGui
	end)
	
	if not success then
		local player = Players.LocalPlayer
		if player then
			local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
			screen.Parent = playerGui
		end
	end
	
	return screen
end

-- Advanced Tween Helper
local function CreateTween(instance, properties, duration, style, direction, repeatCount, reverses)
	local tweenInfo = TweenInfo.new(
		duration or ANIMATION_SPEED,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out,
		repeatCount or 0,
		reverses or false
	)
	return TweenService:Create(instance, tweenInfo, properties)
end

-- Spring Animation
local function SpringAnimate(instance, properties, tension, friction)
	tension = tension or 180
	friction = friction or 12
	
	local connection
	local velocity = {}
	local current = {}
	
	for prop, target in pairs(properties) do
		velocity[prop] = 0
		current[prop] = instance[prop]
	end
	
	connection = RunService.Heartbeat:Connect(function(dt)
		local allComplete = true
		
		for prop, target in pairs(properties) do
			local springForce = -tension * (current[prop] - target)
			local dampingForce = -friction * velocity[prop]
			local acceleration = springForce + dampingForce
			
			velocity[prop] = velocity[prop] + acceleration * dt
			current[prop] = current[prop] + velocity[prop] * dt
			
			instance[prop] = current[prop]
			
			if math.abs(velocity[prop]) > 0.01 or math.abs(current[prop] - target) > 0.01 then
				allComplete = false
			end
		end
		
		if allComplete then
			connection:Disconnect()
			for prop, target in pairs(properties) do
				instance[prop] = target
			end
		end
	end)
	
	return connection
end

-- Constructor
function SimpleUI.new()
	local self = setmetatable({}, SimpleUI)
	
	-- Enhanced Theme System
	self.themes = {
		dark = {
			primary = Color3.fromRGB(88, 101, 242),
			secondary = Color3.fromRGB(32, 34, 37),
			background = Color3.fromRGB(24, 25, 28),
			surface = Color3.fromRGB(41, 43, 47),
			text = Color3.fromRGB(255, 255, 255),
			textSecondary = Color3.fromRGB(185, 187, 190),
			border = Color3.fromRGB(47, 49, 54),
			success = Color3.fromRGB(67, 181, 129),
			danger = Color3.fromRGB(240, 71, 71),
			warning = Color3.fromRGB(250, 166, 26),
			info = Color3.fromRGB(88, 101, 242),
			hover = Color3.fromRGB(114, 137, 218),
			accent = Color3.fromRGB(255, 255, 255),
			gradient1 = Color3.fromRGB(88, 101, 242),
			gradient2 = Color3.fromRGB(114, 137, 218)
		},
		light = {
			primary = Color3.fromRGB(88, 101, 242),
			secondary = Color3.fromRGB(246, 246, 247),
			background = Color3.fromRGB(255, 255, 255),
			surface = Color3.fromRGB(246, 246, 247),
			text = Color3.fromRGB(6, 6, 7),
			textSecondary = Color3.fromRGB(79, 84, 92),
			border = Color3.fromRGB(220, 221, 222),
			success = Color3.fromRGB(67, 181, 129),
			danger = Color3.fromRGB(240, 71, 71),
			warning = Color3.fromRGB(250, 166, 26),
			info = Color3.fromRGB(88, 101, 242),
			hover = Color3.fromRGB(114, 137, 218),
			accent = Color3.fromRGB(0, 0, 0),
			gradient1 = Color3.fromRGB(88, 101, 242),
			gradient2 = Color3.fromRGB(114, 137, 218)
		},
		neon = {
			primary = Color3.fromRGB(0, 255, 255),
			secondary = Color3.fromRGB(20, 20, 30),
			background = Color3.fromRGB(10, 10, 20),
			surface = Color3.fromRGB(25, 25, 40),
			text = Color3.fromRGB(255, 255, 255),
			textSecondary = Color3.fromRGB(150, 150, 200),
			border = Color3.fromRGB(0, 255, 255),
			success = Color3.fromRGB(0, 255, 128),
			danger = Color3.fromRGB(255, 0, 128),
			warning = Color3.fromRGB(255, 255, 0),
			info = Color3.fromRGB(0, 128, 255),
			hover = Color3.fromRGB(0, 200, 200),
			accent = Color3.fromRGB(255, 0, 255),
			gradient1 = Color3.fromRGB(0, 255, 255),
			gradient2 = Color3.fromRGB(255, 0, 255)
		}
	}
	
	self.theme = self.themes.dark
	self.windows = {}
	self.notifications = {}
	self.dragConnections = {}
	self.floatingButton = nil
	self.mainScreen = nil
	self.blurEffect = nil
	
	return self
end

-- Set Theme
function SimpleUI:SetTheme(themeName)
	if self.themes[themeName] then
		self.theme = self.themes[themeName]
		self:UpdateTheme()
	end
end

-- Update Theme for all elements
function SimpleUI:UpdateTheme()
	-- Update all existing elements with new theme
	for _, window in pairs(self.windows) do
		if window and window.Parent then
			-- Update window colors
			window.BackgroundColor3 = self.theme.background
			local titleBar = window:FindFirstChild("TitleBar")
			if titleBar then
				titleBar.BackgroundColor3 = self.theme.secondary
			end
		end
	end
end

-- Initialize with Floating Button
function SimpleUI:Init(config)
	config = config or {}
	
	-- Create main screen
	self.mainScreen = CreateScreenGui("SimpleUI_Enhanced")
	
	-- Create blur effect
	if config.blur ~= false then
		self.blurEffect = Instance.new("BlurEffect")
		self.blurEffect.Size = 0
		self.blurEffect.Parent = Lighting
	end
	
	-- Create floating button
	if config.floatingButton ~= false then
		self:CreateFloatingButton()
	end
	
	return self.mainScreen
end

-- Create Floating Button
function SimpleUI:CreateFloatingButton()
	local screen = self.mainScreen or CreateScreenGui("SimpleUI_FloatingButton")
	
	local floatingBtn = Instance.new("ImageButton")
	floatingBtn.Name = "FloatingButton"
	floatingBtn.Size = UDim2.new(0, 60, 0, 60)
	floatingBtn.Position = UDim2.new(0, 20, 0.5, -30)
	floatingBtn.BackgroundColor3 = self.theme.primary
	floatingBtn.BorderSizePixel = 0
	floatingBtn.Image = "rbxassetid://7734010488" -- Menu icon
	floatingBtn.ImageColor3 = self.theme.text
	floatingBtn.ScaleType = Enum.ScaleType.Fit
	floatingBtn.AutoButtonColor = false
	floatingBtn.Parent = screen
	
	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.5, 0)
	corner.Parent = floatingBtn
	
	-- Shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 20, 1, 20)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.ZIndex = floatingBtn.ZIndex - 1
	shadow.Parent = floatingBtn
	
	-- Glow effect
	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.Size = UDim2.new(1, 30, 1, 30)
	glow.Position = UDim2.new(0.5, 0, 0.5, 0)
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://5028857084"
	glow.ImageColor3 = self.theme.primary
	glow.ImageTransparency = 0.9
	glow.ZIndex = floatingBtn.ZIndex - 1
	glow.Parent = floatingBtn
	
	-- Pulse animation
	local pulseTween = CreateTween(glow, {
		Size = UDim2.new(1, 50, 1, 50),
		ImageTransparency = 1
	}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
	pulseTween:Play()
	
	-- Hover effects
	floatingBtn.MouseEnter:Connect(function()
		CreateTween(floatingBtn, {
			Size = UDim2.new(0, 65, 0, 65),
			BackgroundColor3 = self.theme.hover
		}, 0.2):Play()
		CreateTween(glow, {ImageTransparency = 0.7}, 0.2):Play()
	end)
	
	floatingBtn.MouseLeave:Connect(function()
		CreateTween(floatingBtn, {
			Size = UDim2.new(0, 60, 0, 60),
			BackgroundColor3 = self.theme.primary
		}, 0.2):Play()
		CreateTween(glow, {ImageTransparency = 0.9}, 0.2):Play()
	end)
	
	-- Click to toggle UI visibility
	local uiVisible = true
	floatingBtn.MouseButton1Click:Connect(function()
		uiVisible = not uiVisible
		
		-- Rotation animation
		CreateTween(floatingBtn, {Rotation = uiVisible and 0 or 180}, 0.3):Play()
		
		-- Toggle all windows
		for _, window in pairs(self.windows) do
			if window and window.Parent then
				if uiVisible then
					window.Visible = true
					CreateTween(window, {
						Size = window:GetAttribute("OriginalSize") or UDim2.new(0, 400, 0, 300),
						BackgroundTransparency = 0
					}, 0.3):Play()
				else
					window:SetAttribute("OriginalSize", window.Size)
					CreateTween(window, {
						Size = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1
					}, 0.3):Play()
					task.wait(0.3)
					window.Visible = false
				end
			end
		end
		
		-- Blur effect
		if self.blurEffect then
			CreateTween(self.blurEffect, {Size = uiVisible and 0 or BLUR_SIZE}, 0.3):Play()
		end
	end)
	
	-- Make floating button draggable
	self:MakeDraggable(floatingBtn)
	
	self.floatingButton = floatingBtn
	return floatingBtn
end

-- Enhanced Window with Glass Effect
function SimpleUI:CreateWindow(config)
	config = config or {}
	
	local screen = self.mainScreen or CreateScreenGui()
	
	local window = Instance.new("Frame")
	window.Name = config.Name or "Window"
	window.Size = config.Size or UDim2.new(0, 500, 0, 400)
	window.Position = config.Position or UDim2.new(0.5, -250, 0.5, -200)
	window.BackgroundColor3 = self.theme.background
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.AnchorPoint = config.Center and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
	
	-- Glass effect
	if config.Glass then
		window.BackgroundTransparency = 0.3
		
		local blur = Instance.new("Frame")
		blur.Size = UDim2.new(1, 0, 1, 0)
		blur.BackgroundColor3 = self.theme.background
		blur.BackgroundTransparency = 0.7
		blur.Parent = window
		
		local blurCorner = Instance.new("UICorner")
		blurCorner.CornerRadius = UDim.new(0, 12)
		blurCorner.Parent = blur
	end
	
	-- Rounded corners with border
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = window
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = self.theme.border
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = window
	
	-- Gradient background option
	if config.Gradient then
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, self.theme.gradient1),
			ColorSequenceKeypoint.new(1, self.theme.gradient2)
		})
		gradient.Rotation = config.GradientRotation or 45
		gradient.Parent = window
	end
	
	-- Enhanced Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = self.theme.secondary
	titleBar.BorderSizePixel = 0
	titleBar.Parent = window
	
	local titleBarCorner = Instance.new("UICorner")
	titleBarCorner.CornerRadius = UDim.new(0, 12)
	titleBarCorner.Parent = titleBar
	
	local titleBarFix = Instance.new("Frame")
	titleBarFix.Size = UDim2.new(1, 0, 0, 12)
	titleBarFix.Position = UDim2.new(0, 0, 1, -12)
	titleBarFix.BackgroundColor3 = self.theme.secondary
	titleBarFix.BorderSizePixel = 0
	titleBarFix.Parent = titleBar
	
	-- Title with icon
	local titleContainer = Instance.new("Frame")
	titleContainer.Size = UDim2.new(1, -100, 1, 0)
	titleContainer.BackgroundTransparency = 1
	titleContainer.Parent = titleBar
	
	local titleIcon = Instance.new("ImageLabel")
	titleIcon.Size = UDim2.new(0, 24, 0, 24)
	titleIcon.Position = UDim2.new(0, 12, 0.5, -12)
	titleIcon.BackgroundTransparency = 1
	titleIcon.Image = config.Icon or "rbxassetid://7734053495" -- Default icon
	titleIcon.ImageColor3 = self.theme.primary
	titleIcon.Parent = titleContainer
	
	local titleText = Instance.new("TextLabel")
	titleText.Size = UDim2.new(1, -50, 1, 0)
	titleText.Position = UDim2.new(0, 45, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = config.Title or "Window"
	titleText.TextColor3 = self.theme.text
	titleText.TextSize = 16
	titleText.Font = Enum.Font.GothamBold
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Parent = titleContainer
	
	-- Window Controls (Minimize, Maximize, Close)
	local controls = Instance.new("Frame")
	controls.Size = UDim2.new(0, 90, 0, 30)
	controls.Position = UDim2.new(1, -95, 0.5, -15)
	controls.BackgroundTransparency = 1
	controls.Parent = titleBar
	
	local controlLayout = Instance.new("UIListLayout")
	controlLayout.FillDirection = Enum.FillDirection.Horizontal
	controlLayout.Padding = UDim.new(0, 5)
	controlLayout.Parent = controls
	
	-- Minimize Button
	local minimizeBtn = self:CreateWindowButton(controls, "―", self.theme.warning, function()
		local isMinimized = window:GetAttribute("Minimized") or false
		window:SetAttribute("Minimized", not isMinimized)
		
		if not isMinimized then
			window:SetAttribute("OriginalSize", window.Size)
			CreateTween(window, {Size = UDim2.new(window.Size.X.Scale, window.Size.X.Offset, 0, 40)}, 0.3):Play()
		else
			local originalSize = window:GetAttribute("OriginalSize") or UDim2.new(0, 500, 0, 400)
			CreateTween(window, {Size = originalSize}, 0.3):Play()
		end
	end)
	
	-- Maximize Button
	local maximizeBtn = self:CreateWindowButton(controls, "□", self.theme.success, function()
		local isMaximized = window:GetAttribute("Maximized") or false
		window:SetAttribute("Maximized", not isMaximized)
		
		if not isMaximized then
			window:SetAttribute("OriginalSize", window.Size)
			window:SetAttribute("OriginalPosition", window.Position)
			CreateTween(window, {
				Size = UDim2.new(1, -40, 1, -40),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, 0.3):Play()
			window.AnchorPoint = Vector2.new(0.5, 0.5)
		else
			local originalSize = window:GetAttribute("OriginalSize") or UDim2.new(0, 500, 0, 400)
			local originalPos = window:GetAttribute("OriginalPosition") or UDim2.new(0.5, -250, 0.5, -200)
			CreateTween(window, {
				Size = originalSize,
				Position = originalPos
			}, 0.3):Play()
			window.AnchorPoint = Vector2.new(0, 0)
		end
	end)
	
	-- Close Button
	local closeBtn = self:CreateWindowButton(controls, "✕", self.theme.danger, function()
		-- Close animation
		CreateTween(window, {
			Size = UDim2.new(0, 0, 0, 0),
			Rotation = 360,
			BackgroundTransparency = 1
		}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
		
		task.wait(0.4)
		
		-- Remove from windows list
		local index = table.find(self.windows, window)
		if index then
			table.remove(self.windows, index)
		end
		
		window:Destroy()
	end)
	
	-- Content Container with padding
	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -55)
	content.Position = UDim2.new(0, 10, 0, 45)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 4
	content.ScrollBarImageColor3 = self.theme.primary
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.Parent = window
	
	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 5)
	contentPadding.PaddingBottom = UDim.new(0, 5)
	contentPadding.PaddingLeft = UDim.new(0, 5)
	contentPadding.PaddingRight = UDim.new(0, 5)
	contentPadding.Parent = content
	
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.Parent = content
	
	-- Make window draggable
	self:MakeDraggable(window, titleBar)
	
	-- Opening animation
	window.Size = UDim2.new(0, 0, 0, 0)
	window.Parent = screen
	CreateTween(window, {
		Size = config.Size or UDim2.new(0, 500, 0, 400)
	}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
	
	-- Add to windows list
	table.insert(self.windows, window)
	
	-- Return window object with methods
	local windowObj = {
		Window = window,
		Content = content,
		
		-- Methods
		AddLabel = function(_, text, config)
			return self:CreateLabel(content, text, config)
		end,
		
		AddButton = function(_, text, callback, config)
			return self:CreateButton(content, text, callback, config)
		end,
		
		AddToggle = function(_, text, default, callback, config)
			return self:CreateToggle(content, text, default, callback, config)
		end,
		
		AddSlider = function(_, text, min, max, default, callback, config)
			return self:CreateSlider(content, text, min, max, default, callback, config)
		end,
		
		AddTextBox = function(_, text, placeholder, callback, config)
			return self:CreateTextBox(content, text, placeholder, callback, config)
		end,
		
		AddDropdown = function(_, text, options, default, callback, config)
			return self:CreateDropdown(content, text, options, default, callback, config)
		end,
		
		AddColorPicker = function(_, text, default, callback, config)
			return self:CreateColorPicker(content, text, default, callback, config)
		end,
		
		AddKeybind = function(_, text, default, callback, config)
			return self:CreateKeybind(content, text, default, callback, config)
		end,
		
		AddSection = function(_, text, config)
			return self:CreateSection(content, text, config)
		end,
		
		AddSeparator = function(_)
			return self:CreateSeparator(content)
		end,
		
		AddParagraph = function(_, title, text, config)
			return self:CreateParagraph(content, title, text, config)
		end,
		
		AddImage = function(_, imageId, config)
			return self:CreateImage(content, imageId, config)
		end
	}
	
	return windowObj
end

-- Window Control Button Helper
function SimpleUI:CreateWindowButton(parent, text, color, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 26, 0, 26)
	button.BackgroundColor3 = color
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = self.theme.text
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button
	
	-- Hover effect
	button.MouseEnter:Connect(function()
		CreateTween(button, {
			BackgroundColor3 = self:LightenColor(color, 0.2),
			Size = UDim2.new(0, 28, 0, 28)
		}, 0.15):Play()
	end)
	
	button.MouseLeave:Connect(function()
		CreateTween(button, {
			BackgroundColor3 = color,
			Size = UDim2.new(0, 26, 0, 26)
		}, 0.15):Play()
	end)
	
	button.MouseButton1Click:Connect(callback)
	
	return button
end

-- Enhanced Label
function SimpleUI:CreateLabel(parent, text, config)
	config = config or {}
	
	local label = Instance.new("TextLabel")
	label.Size = config.Size or UDim2.new(1, 0, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = text or "Label"
	label.TextColor3 = config.Color or self.theme.text
	label.TextSize = config.TextSize or 14
	label.Font = config.Font or Enum.Font.Gotham
	label.TextXAlignment = config.Alignment or Enum.TextXAlignment.Left
	label.TextWrapped = config.Wrapped or false
	label.RichText = config.RichText or false
	label.Parent = parent
	
	if config.Icon then
		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, -25, 0.5, -10)
		icon.BackgroundTransparency = 1
		icon.Image = config.Icon
		icon.ImageColor3 = config.IconColor or self.theme.primary
		icon.Parent = label
	end
	
	return label
end

-- Ultra Enhanced Button with Ripple and Glow
function SimpleUI:CreateButton(parent, text, callback, config)
	config = config or {}
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundColor3 = config.Color or self.theme.primary
	button.BorderSizePixel = 0
	button.Text = text or "Button"
	button.TextColor3 = config.TextColor or self.theme.text
	button.TextSize = config.TextSize or 14
	button.Font = config.Font or Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	
	-- Gradient overlay
	if config.Gradient then
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, self.theme.gradient1),
			ColorSequenceKeypoint.new(1, self.theme.gradient2)
		})
		gradient.Rotation = 45
		gradient.Parent = button
	end
	
	-- Icon support
	if config.Icon then
		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 10, 0.5, -10)
		icon.BackgroundTransparency = 1
		icon.Image = config.Icon
		icon.ImageColor3 = config.IconColor or self.theme.text
		icon.Parent = button
		
		-- Adjust text position for icon
		button.TextXAlignment = Enum.TextXAlignment.Center
		button.TextSize = 14
	end
	
	-- Shadow effect
	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, 4, 1, 4)
	shadow.Position = UDim2.new(0, -2, 0, 2)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = SHADOW_TRANSPARENCY
	shadow.ZIndex = button.ZIndex - 1
	shadow.Parent = container
	
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 8)
	shadowCorner.Parent = shadow
	
	-- Ripple container
	local rippleContainer = Instance.new("Frame")
	rippleContainer.Name = "RippleContainer"
	rippleContainer.Size = UDim2.new(1, 0, 1, 0)
	rippleContainer.BackgroundTransparency = 1
	rippleContainer.ClipsDescendants = true
	rippleContainer.ZIndex = button.ZIndex + 1
	rippleContainer.Parent = button
	
	local rippleCorner = Instance.new("UICorner")
	rippleCorner.CornerRadius = UDim.new(0, 8)
	rippleCorner.Parent = rippleContainer
	
	-- States
	local isHovering = false
	local originalColor = config.Color or self.theme.primary
	
	-- Hover animation
	button.MouseEnter:Connect(function()
		isHovering = true
		CreateTween(button, {
			BackgroundColor3 = self:LightenColor(originalColor, 0.1)
		}, 0.2):Play()
		CreateTween(shadow, {
			Position = UDim2.new(0, -2, 0, 4),
			Size = UDim2.new(1, 6, 1, 6)
		}, 0.2):Play()
	end)
	
	button.MouseLeave:Connect(function()
		isHovering = false
		CreateTween(button, {
			BackgroundColor3 = originalColor
		}, 0.2):Play()
		CreateTween(shadow, {
			Position = UDim2.new(0, -2, 0, 2),
			Size = UDim2.new(1, 4, 1, 4)
		}, 0.2):Play()
	end)
	
	-- Click with advanced ripple
	button.MouseButton1Down:Connect(function()
		-- Get mouse position relative to button
		local mouse = UserInputService:GetMouseLocation()
		local buttonPos = button.AbsolutePosition
		local relativeX = (mouse.X - buttonPos.X) / button.AbsoluteSize.X
		local relativeY = (mouse.Y - buttonPos.Y) / button.AbsoluteSize.Y
		
		-- Create ripple
		local ripple = Instance.new("Frame")
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Position = UDim2.new(relativeX, 0, relativeY, 0)
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.BackgroundColor3 = Color3.new(1, 1, 1)
		ripple.BackgroundTransparency = 0.8
		ripple.Parent = rippleContainer
		
		local rippleRound = Instance.new("UICorner")
		rippleRound.CornerRadius = UDim.new(1, 0)
		rippleRound.Parent = ripple
		
		-- Animate ripple
		local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
		CreateTween(ripple, {
			Size = UDim2.new(0, maxSize, 0, maxSize),
			BackgroundTransparency = 1
		}, 0.6, Enum.EasingStyle.Quad):Play()
		
		-- Button press effect
		CreateTween(button, {
			BackgroundColor3 = self:DarkenColor(originalColor, 0.1)
		}, 0.1):Play()
		
		-- Clean up ripple
		Debris:AddItem(ripple, 0.6)
	end)
	
	button.MouseButton1Up:Connect(function()
		if isHovering then
			CreateTween(button, {
				BackgroundColor3 = self:LightenColor(originalColor, 0.1)
			}, 0.1):Play()
		else
			CreateTween(button, {
				BackgroundColor3 = originalColor
			}, 0.1):Play()
		end
	end)
	
	-- Callback
	if callback then
		button.MouseButton1Click:Connect(callback)
	end
	
	return container
end

-- Modern Toggle Switch
function SimpleUI:CreateToggle(parent, text, default, callback, config)
	config = config or {}
	local enabled = default or false
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Interactive button
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = container
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text or "Toggle"
	label.TextColor3 = self.theme.text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	-- Modern switch
	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 55, 0, 28)
	switch.Position = UDim2.new(1, -60, 0.5, -14)
	switch.BackgroundColor3 = enabled and self.theme.success or Color3.fromRGB(120, 120, 120)
	switch.BorderSizePixel = 0
	switch.Parent = container
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch
	
	-- Inner glow
	local innerGlow = Instance.new("Frame")
	innerGlow.Size = UDim2.new(1, -4, 1, -4)
	innerGlow.Position = UDim2.new(0, 2, 0, 2)
	innerGlow.BackgroundColor3 = enabled and self:LightenColor(self.theme.success, 0.3) or Color3.fromRGB(100, 100, 100)
	innerGlow.BackgroundTransparency = 0.5
	innerGlow.BorderSizePixel = 0
	innerGlow.Parent = switch
	
	local innerGlowCorner = Instance.new("UICorner")
	innerGlowCorner.CornerRadius = UDim.new(1, 0)
	innerGlowCorner.Parent = innerGlow
	
	-- Knob
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 24, 0, 24)
	knob.Position = enabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	-- Knob shadow
	local knobShadow = Instance.new("Frame")
	knobShadow.Size = UDim2.new(1, 6, 1, 6)
	knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
	knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	knobShadow.BackgroundColor3 = Color3.new(0, 0, 0)
	knobShadow.BackgroundTransparency = 0.8
	knobShadow.ZIndex = knob.ZIndex - 1
	knobShadow.Parent = knob
	
	local knobShadowCorner = Instance.new("UICorner")
	knobShadowCorner.CornerRadius = UDim.new(1, 0)
	knobShadowCorner.Parent = knobShadow
	
	-- Status indicator
	local statusDot = Instance.new("Frame")
	statusDot.Size = UDim2.new(0, 8, 0, 8)
	statusDot.Position = UDim2.new(0.5, -4, 0.5, -4)
	statusDot.BackgroundColor3 = enabled and self.theme.success or Color3.fromRGB(150, 150, 150)
	statusDot.BorderSizePixel = 0
	statusDot.Parent = knob
	
	local statusDotCorner = Instance.new("UICorner")
	statusDotCorner.CornerRadius = UDim.new(1, 0)
	statusDotCorner.Parent = statusDot
	
	-- Toggle function
	local function toggle()
		enabled = not enabled
		
		-- Animate switch
		CreateTween(switch, {
			BackgroundColor3 = enabled and self.theme.success or Color3.fromRGB(120, 120, 120)
		}, 0.3):Play()
		
		CreateTween(innerGlow, {
			BackgroundColor3 = enabled and self:LightenColor(self.theme.success, 0.3) or Color3.fromRGB(100, 100, 100)
		}, 0.3):Play()
		
		-- Animate knob with spring
		SpringAnimate(knob, {
			Position = enabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
		})
		
		-- Animate status dot
		CreateTween(statusDot, {
			BackgroundColor3 = enabled and self.theme.success or Color3.fromRGB(150, 150, 150),
			Size = UDim2.new(0, enabled and 10 or 8, 0, enabled and 10 or 8),
			Position = UDim2.new(0.5, enabled and -5 or -4, 0.5, enabled and -5 or -4)
		}, 0.2):Play()
		
		-- Pulse effect when enabled
		if enabled then
			local pulse = Instance.new("Frame")
			pulse.Size = UDim2.new(0, 30, 0, 30)
			pulse.Position = UDim2.new(0.5, -15, 0.5, -15)
			pulse.BackgroundColor3 = self.theme.success
			pulse.BackgroundTransparency = 0.7
			pulse.BorderSizePixel = 0
			pulse.Parent = knob
			
			local pulseCorner = Instance.new("UICorner")
			pulseCorner.CornerRadius = UDim.new(1, 0)
			pulseCorner.Parent = pulse
			
			CreateTween(pulse, {
				Size = UDim2.new(0, 40, 0, 40),
				Position = UDim2.new(0.5, -20, 0.5, -20),
				BackgroundTransparency = 1
			}, 0.4):Play()
			
			Debris:AddItem(pulse, 0.4)
		end
		
		if callback then
			callback(enabled)
		end
	end
	
	button.MouseButton1Click:Connect(toggle)
	
	-- Hover effect
	container.MouseEnter:Connect(function()
		CreateTween(container, {
			BackgroundColor3 = self:LightenColor(config.BackgroundColor or self.theme.surface, 0.05)
		}, 0.2):Play()
	end)
	
	container.MouseLeave:Connect(function()
		CreateTween(container, {
			BackgroundColor3 = config.BackgroundColor or self.theme.surface
		}, 0.2):Play()
	end)
	
	return container, function() return enabled end
end

-- Modern Slider
function SimpleUI:CreateSlider(parent, text, min, max, default, callback, config)
	config = config or {}
	local value = default or min
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 60)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Title and value display
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 25)
	header.BackgroundTransparency = 1
	header.Parent = container
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.7, 0, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = text or "Slider"
	title.TextColor3 = self.theme.text
	title.TextSize = 14
	title.Font = Enum.Font.Gotham
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header
	
	local valueDisplay = Instance.new("TextBox")
	valueDisplay.Size = UDim2.new(0, 50, 0, 22)
	valueDisplay.Position = UDim2.new(1, -60, 0.5, -11)
	valueDisplay.BackgroundColor3 = self.theme.secondary
	valueDisplay.BorderSizePixel = 0
	valueDisplay.Text = tostring(value)
	valueDisplay.TextColor3 = self.theme.text
	valueDisplay.TextSize = 12
	valueDisplay.Font = Enum.Font.GothamBold
	valueDisplay.Parent = header
	
	local valueCorner = Instance.new("UICorner")
	valueCorner.CornerRadius = UDim.new(0, 4)
	valueCorner.Parent = valueDisplay
	
	-- Slider track
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -20, 0, 8)
	track.Position = UDim2.new(0, 10, 0, 35)
	track.BackgroundColor3 = self.theme.secondary
	track.BorderSizePixel = 0
	track.Parent = container
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track
	
	-- Progress fill
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = self.theme.primary
	fill.BorderSizePixel = 0
	fill.Parent = track
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill
	
	-- Animated gradient on fill
	local fillGradient = Instance.new("UIGradient")
	fillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, self.theme.primary),
		ColorSequenceKeypoint.new(1, self:LightenColor(self.theme.primary, 0.2))
	})
	fillGradient.Parent = fill
	
	-- Slider handle
	local handle = Instance.new("TextButton")
	handle.Size = UDim2.new(0, 20, 0, 20)
	handle.Position = UDim2.new((value - min) / (max - min), -10, 0.5, -10)
	handle.BackgroundColor3 = self.theme.text
	handle.BorderSizePixel = 0
	handle.Text = ""
	handle.AutoButtonColor = false
	handle.ZIndex = 5
	handle.Parent = track
	
	local handleCorner = Instance.new("UICorner")
	handleCorner.CornerRadius = UDim.new(1, 0)
	handleCorner.Parent = handle
	
	-- Handle shadow
	local handleShadow = Instance.new("Frame")
	handleShadow.Size = UDim2.new(1, 8, 1, 8)
	handleShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
	handleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	handleShadow.BackgroundColor3 = Color3.new(0, 0, 0)
	handleShadow.BackgroundTransparency = 0.7
	handleShadow.ZIndex = handle.ZIndex - 1
	handleShadow.Parent = handle
	
	local handleShadowCorner = Instance.new("UICorner")
	handleShadowCorner.CornerRadius = UDim.new(1, 0)
	handleShadowCorner.Parent = handleShadow
	
	-- Dragging
	local dragging = false
	
	local function updateValue(input)
		local relativeX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * relativeX + 0.5)
		
		CreateTween(handle, {Position = UDim2.new(relativeX, -10, 0.5, -10)}, 0.05):Play()
		CreateTween(fill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.05):Play()
		
		valueDisplay.Text = tostring(value)
		
		if callback then
			callback(value)
		end
	end
	
	handle.MouseButton1Down:Connect(function()
		dragging = true
		CreateTween(handle, {
			Size = UDim2.new(0, 24, 0, 24),
			BackgroundColor3 = self.theme.primary
		}, 0.1):Play()
	end)
	
	-- Direct track clicking
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateValue(input)
		end
	end)
	
	-- Value input
	valueDisplay.FocusLost:Connect(function()
		local newValue = tonumber(valueDisplay.Text)
		if newValue then
			value = math.clamp(newValue, min, max)
			local relativeX = (value - min) / (max - min)
			
			CreateTween(handle, {Position = UDim2.new(relativeX, -10, 0.5, -10)}, 0.2):Play()
			CreateTween(fill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.2):Play()
			
			valueDisplay.Text = tostring(value)
			
			if callback then
				callback(value)
			end
		else
			valueDisplay.Text = tostring(value)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateValue(input)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			CreateTween(handle, {
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundColor3 = self.theme.text
			}, 0.1):Play()
		end
	end)
	
	return container, function() return value end
end

-- Modern TextBox
function SimpleUI:CreateTextBox(parent, text, placeholder, callback, config)
	config = config or {}
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Label
	if text and text ~= "" then
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.4, -10, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = self.theme.text
		label.TextSize = 14
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container
	end
	
	-- TextBox container
	local textBoxContainer = Instance.new("Frame")
	textBoxContainer.Size = text and UDim2.new(0.6, -10, 1, -8) or UDim2.new(1, -20, 1, -8)
	textBoxContainer.Position = text and UDim2.new(0.4, 0, 0, 4) or UDim2.new(0, 10, 0, 4)
	textBoxContainer.BackgroundColor3 = self.theme.secondary
	textBoxContainer.BorderSizePixel = 0
	textBoxContainer.Parent = container
	
	local textBoxCorner = Instance.new("UICorner")
	textBoxCorner.CornerRadius = UDim.new(0, 6)
	textBoxCorner.Parent = textBoxContainer
	
	local textBoxStroke = Instance.new("UIStroke")
	textBoxStroke.Color = self.theme.border
	textBoxStroke.Thickness = 1
	textBoxStroke.Transparency = 1
	textBoxStroke.Parent = textBoxContainer
	
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -10, 1, 0)
	textBox.Position = UDim2.new(0, 5, 0, 0)
	textBox.BackgroundTransparency = 1
	textBox.PlaceholderText = placeholder or "Enter text..."
	textBox.PlaceholderColor3 = self.theme.textSecondary
	textBox.Text = config.Default or ""
	textBox.TextColor3 = self.theme.text
	textBox.TextSize = 13
	textBox.Font = Enum.Font.Gotham
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.ClearTextOnFocus = config.ClearOnFocus or false
	textBox.Parent = textBoxContainer
	
	-- Focus animations
	textBox.Focused:Connect(function()
		CreateTween(textBoxStroke, {
			Transparency = 0,
			Color = self.theme.primary
		}, 0.2):Play()
		CreateTween(textBoxContainer, {
			BackgroundColor3 = self:LightenColor(self.theme.secondary, 0.05)
		}, 0.2):Play()
	end)
	
	textBox.FocusLost:Connect(function(enterPressed)
		CreateTween(textBoxStroke, {
			Transparency = 1,
			Color = self.theme.border
		}, 0.2):Play()
		CreateTween(textBoxContainer, {
			BackgroundColor3 = self.theme.secondary
		}, 0.2):Play()
		
		if callback then
			callback(textBox.Text, enterPressed)
		end
	end)
	
	return container, textBox
end

-- Enhanced Dropdown
function SimpleUI:CreateDropdown(parent, text, options, default, callback, config)
	config = config or {}
	local selected = default or options[1] or "Select"
	local isOpen = false
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.ClipsDescendants = false
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Main button
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = container
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, -10, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text or "Dropdown"
	label.TextColor3 = self.theme.text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	-- Selected value display
	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.Size = UDim2.new(0.5, -35, 1, 0)
	selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.Text = selected
	selectedLabel.TextColor3 = self.theme.textSecondary
	selectedLabel.TextSize = 14
	selectedLabel.Font = Enum.Font.Gotham
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	selectedLabel.Parent = container
	
	-- Arrow icon
	local arrow = Instance.new("ImageLabel")
	arrow.Size = UDim2.new(0, 20, 0, 20)
	arrow.Position = UDim2.new(1, -25, 0.5, -10)
	arrow.BackgroundTransparency = 1
	arrow.Image = "rbxassetid://7734053426" -- Chevron down
	arrow.ImageColor3 = self.theme.text
	arrow.Rotation = 0
	arrow.Parent = container
	
	-- Dropdown list
	local dropdownList = Instance.new("Frame")
	dropdownList.Size = UDim2.new(1, 0, 0, math.min(#options * 32, 150))
	dropdownList.Position = UDim2.new(0, 0, 1, 5)
	dropdownList.BackgroundColor3 = self.theme.secondary
	dropdownList.BorderSizePixel = 0
	dropdownList.Visible = false
	dropdownList.ZIndex = 10
	dropdownList.Parent = container
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 8)
	listCorner.Parent = dropdownList
	
	local listStroke = Instance.new("UIStroke")
	listStroke.Color = self.theme.border
	listStroke.Thickness = 1
	listStroke.Transparency = 0.5
	listStroke.Parent = dropdownList
	
	-- Scrolling frame for options
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -4, 1, -4)
	scrollFrame.Position = UDim2.new(0, 2, 0, 2)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 3
	scrollFrame.ScrollBarImageColor3 = self.theme.primary
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
	scrollFrame.Parent = dropdownList
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = scrollFrame
	
	-- Create options
	for i, option in ipairs(options) do
		local optionButton = Instance.new("TextButton")
		optionButton.Size = UDim2.new(1, 0, 0, 30)
		optionButton.BackgroundColor3 = self.theme.secondary
		optionButton.BorderSizePixel = 0
		optionButton.Text = option
		optionButton.TextColor3 = option == selected and self.theme.primary or self.theme.text
		optionButton.TextSize = 13
		optionButton.Font = Enum.Font.Gotham
		optionButton.AutoButtonColor = false
		optionButton.Parent = scrollFrame
		
		local optionCorner = Instance.new("UICorner")
		optionCorner.CornerRadius = UDim.new(0, 6)
		optionCorner.Parent = optionButton
		
		-- Hover effect
		optionButton.MouseEnter:Connect(function()
			CreateTween(optionButton, {
				BackgroundColor3 = self.theme.primary,
				BackgroundTransparency = 0.8
			}, 0.15):Play()
		end)
		
		optionButton.MouseLeave:Connect(function()
			CreateTween(optionButton, {
				BackgroundColor3 = self.theme.secondary,
				BackgroundTransparency = 0
			}, 0.15):Play()
		end)
		
		optionButton.MouseButton1Click:Connect(function()
			selected = option
			selectedLabel.Text = selected
			
			-- Update colors
			for _, child in ipairs(scrollFrame:GetChildren()) do
				if child:IsA("TextButton") then
					child.TextColor3 = child.Text == selected and self.theme.primary or self.theme.text
				end
			end
			
			-- Close dropdown
			isOpen = false
			dropdownList.Visible = false
			CreateTween(arrow, {Rotation = 0}, 0.2):Play()
			
			if callback then
				callback(selected)
			end
		end)
	end
	
	-- Toggle dropdown
	button.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		dropdownList.Visible = isOpen
		CreateTween(arrow, {Rotation = isOpen and 180 or 0}, 0.2):Play()
		
		if isOpen then
			-- Animate dropdown opening
			dropdownList.Size = UDim2.new(1, 0, 0, 0)
			CreateTween(dropdownList, {
				Size = UDim2.new(1, 0, 0, math.min(#options * 32, 150))
			}, 0.2):Play()
		end
	end)
	
	return container, function() return selected end
end

-- Color Picker
function SimpleUI:CreateColorPicker(parent, text, default, callback, config)
	config = config or {}
	local currentColor = default or Color3.fromRGB(255, 255, 255)
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text or "Color"
	label.TextColor3 = self.theme.text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	-- Color display
	local colorDisplay = Instance.new("Frame")
	colorDisplay.Size = UDim2.new(0, 30, 0, 30)
	colorDisplay.Position = UDim2.new(1, -35, 0.5, -15)
	colorDisplay.BackgroundColor3 = currentColor
	colorDisplay.BorderSizePixel = 0
	colorDisplay.Parent = container
	
	local colorCorner = Instance.new("UICorner")
	colorCorner.CornerRadius = UDim.new(0, 6)
	colorCorner.Parent = colorDisplay
	
	local colorStroke = Instance.new("UIStroke")
	colorStroke.Color = self.theme.border
	colorStroke.Thickness = 2
	colorStroke.Parent = colorDisplay
	
	-- Color picker popup
	local pickerOpen = false
	local pickerFrame = Instance.new("Frame")
	pickerFrame.Size = UDim2.new(0, 200, 0, 240)
	pickerFrame.Position = UDim2.new(0, 0, 1, 5)
	pickerFrame.BackgroundColor3 = self.theme.secondary
	pickerFrame.BorderSizePixel = 0
	pickerFrame.Visible = false
	pickerFrame.ZIndex = 20
	pickerFrame.Parent = container
	
	local pickerCorner = Instance.new("UICorner")
	pickerCorner.CornerRadius = UDim.new(0, 8)
	pickerCorner.Parent = pickerFrame
	
	-- HSV picker implementation would go here
	-- For brevity, showing RGB sliders instead
	
	local function createColorSlider(name, position, getValue, setValue)
		local sliderContainer = Instance.new("Frame")
		sliderContainer.Size = UDim2.new(1, -20, 0, 30)
		sliderContainer.Position = position
		sliderContainer.BackgroundTransparency = 1
		sliderContainer.Parent = pickerFrame
		
		local sliderLabel = Instance.new("TextLabel")
		sliderLabel.Size = UDim2.new(0, 20, 1, 0)
		sliderLabel.BackgroundTransparency = 1
		sliderLabel.Text = name
		sliderLabel.TextColor3 = self.theme.text
		sliderLabel.TextSize = 12
		sliderLabel.Font = Enum.Font.Gotham
		sliderLabel.Parent = sliderContainer
		
		local sliderTrack = Instance.new("Frame")
		sliderTrack.Size = UDim2.new(1, -70, 0, 6)
		sliderTrack.Position = UDim2.new(0, 25, 0.5, -3)
		sliderTrack.BackgroundColor3 = self.theme.background
		sliderTrack.BorderSizePixel = 0
		sliderTrack.Parent = sliderContainer
		
		local trackCorner = Instance.new("UICorner")
		trackCorner.CornerRadius = UDim.new(1, 0)
		trackCorner.Parent = sliderTrack
		
		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(getValue() / 255, 0, 1, 0)
		sliderFill.BackgroundColor3 = name == "R" and Color3.new(1, 0, 0) or name == "G" and Color3.new(0, 1, 0) or Color3.new(0, 0, 1)
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderTrack
		
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(1, 0)
		fillCorner.Parent = sliderFill
		
		local sliderHandle = Instance.new("TextButton")
		sliderHandle.Size = UDim2.new(0, 12, 0, 12)
		sliderHandle.Position = UDim2.new(getValue() / 255, -6, 0.5, -6)
		sliderHandle.BackgroundColor3 = self.theme.text
		sliderHandle.BorderSizePixel = 0
		sliderHandle.Text = ""
		sliderHandle.AutoButtonColor = false
		sliderHandle.Parent = sliderTrack
		
		local handleCorner = Instance.new("UICorner")
		handleCorner.CornerRadius = UDim.new(1, 0)
		handleCorner.Parent = sliderHandle
		
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0, 40, 1, 0)
		valueLabel.Position = UDim2.new(1, -40, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = tostring(math.floor(getValue()))
		valueLabel.TextColor3 = self.theme.textSecondary
		valueLabel.TextSize = 12
		valueLabel.Font = Enum.Font.Gotham
		valueLabel.Parent = sliderContainer
		
		-- Dragging
		local dragging = false
		
		sliderHandle.MouseButton1Down:Connect(function()
			dragging = true
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
				local value = math.floor(relativeX * 255)
				
				setValue(value)
				sliderHandle.Position = UDim2.new(relativeX, -6, 0.5, -6)
				sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
				valueLabel.Text = tostring(value)
				
				colorDisplay.BackgroundColor3 = currentColor
				if callback then
					callback(currentColor)
				end
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end
	
	-- Create RGB sliders
	createColorSlider("R", UDim2.new(0, 10, 0, 10), 
		function() return currentColor.R * 255 end,
		function(value) 
			currentColor = Color3.fromRGB(value, currentColor.G * 255, currentColor.B * 255) 
		end
	)
	
	createColorSlider("G", UDim2.new(0, 10, 0, 50),
		function() return currentColor.G * 255 end,
		function(value)
			currentColor = Color3.fromRGB(currentColor.R * 255, value, currentColor.B * 255)
		end
	)
	
	createColorSlider("B", UDim2.new(0, 10, 0, 90),
		function() return currentColor.B * 255 end,
		function(value)
			currentColor = Color3.fromRGB(currentColor.R * 255, currentColor.G * 255, value)
		end
	)
	
	-- Hex input
	local hexContainer = Instance.new("Frame")
	hexContainer.Size = UDim2.new(1, -20, 0, 30)
	hexContainer.Position = UDim2.new(0, 10, 0, 140)
	hexContainer.BackgroundColor3 = self.theme.background
	hexContainer.BorderSizePixel = 0
	hexContainer.Parent = pickerFrame
	
	local hexCorner = Instance.new("UICorner")
	hexCorner.CornerRadius = UDim.new(0, 6)
	hexCorner.Parent = hexContainer
	
	local hexInput = Instance.new("TextBox")
	hexInput.Size = UDim2.new(1, -10, 1, 0)
	hexInput.Position = UDim2.new(0, 5, 0, 0)
	hexInput.BackgroundTransparency = 1
	hexInput.Text = string.format("#%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
	hexInput.TextColor3 = self.theme.text
	hexInput.TextSize = 12
	hexInput.Font = Enum.Font.GothamBold
	hexInput.PlaceholderText = "#FFFFFF"
	hexInput.Parent = hexContainer
	
	-- Preset colors
	local presetContainer = Instance.new("Frame")
	presetContainer.Size = UDim2.new(1, -20, 0, 40)
	presetContainer.Position = UDim2.new(0, 10, 0, 180)
	presetContainer.BackgroundTransparency = 1
	presetContainer.Parent = pickerFrame
	
	local presetLayout = Instance.new("UIGridLayout")
	presetLayout.CellSize = UDim2.new(0, 22, 0, 22)
	presetLayout.CellPadding = UDim2.new(0, 4, 0, 4)
	presetLayout.Parent = presetContainer
	
	local presetColors = {
		Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(255, 128, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(128, 0, 255),
		Color3.fromRGB(255, 0, 255)
	}
	
	for _, presetColor in ipairs(presetColors) do
		local presetButton = Instance.new("TextButton")
		presetButton.Size = UDim2.new(0, 22, 0, 22)
		presetButton.BackgroundColor3 = presetColor
		presetButton.BorderSizePixel = 0
		presetButton.Text = ""
		presetButton.Parent = presetContainer
		
		local presetCorner = Instance.new("UICorner")
		presetCorner.CornerRadius = UDim.new(0, 4)
		presetCorner.Parent = presetButton
		
		presetButton.MouseButton1Click:Connect(function()
			currentColor = presetColor
			colorDisplay.BackgroundColor3 = currentColor
			hexInput.Text = string.format("#%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
			if callback then
				callback(currentColor)
			end
		end)
	end
	
	-- Toggle picker
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = container
	
	button.MouseButton1Click:Connect(function()
		pickerOpen = not pickerOpen
		pickerFrame.Visible = pickerOpen
		
		if pickerOpen then
			pickerFrame.Size = UDim2.new(0, 200, 0, 0)
			CreateTween(pickerFrame, {Size = UDim2.new(0, 200, 0, 240)}, 0.2):Play()
		end
	end)
	
	return container, function() return currentColor end
end

-- Keybind
function SimpleUI:CreateKeybind(parent, text, default, callback, config)
	config = config or {}
	local currentKey = default or Enum.KeyCode.Unknown
	local binding = false
	
	local container = Instance.new("Frame")
	container.Size = config.Size or UDim2.new(1, 0, 0, 38)
	container.BackgroundColor3 = config.BackgroundColor or self.theme.surface
	container.BorderSizePixel = 0
	container.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container
	
	-- Label
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -90, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text or "Keybind"
	label.TextColor3 = self.theme.text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container
	
	-- Key display
	local keyButton = Instance.new("TextButton")
	keyButton.Size = UDim2.new(0, 70, 0, 26)
	keyButton.Position = UDim2.new(1, -75, 0.5, -13)
	keyButton.BackgroundColor3 = self.theme.secondary
	keyButton.BorderSizePixel = 0
	keyButton.Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name
	keyButton.TextColor3 = self.theme.text
	keyButton.TextSize = 12
	keyButton.Font = Enum.Font.GothamBold
	keyButton.AutoButtonColor = false
	keyButton.Parent = container
	
	local keyCorner = Instance.new("UICorner")
	keyCorner.CornerRadius = UDim.new(0, 6)
	keyCorner.Parent = keyButton
	
	local keyStroke = Instance.new("UIStroke")
	keyStroke.Color = self.theme.border
	keyStroke.Thickness = 1
	keyStroke.Transparency = 0.5
	keyStroke.Parent = keyButton
	
	-- Binding
	keyButton.MouseButton1Click:Connect(function()
		if not binding then
			binding = true
			keyButton.Text = "..."
			keyButton.TextColor3 = self.theme.primary
			CreateTween(keyStroke, {Color = self.theme.primary, Transparency = 0}, 0.2):Play()
			
			local connection
			connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
					currentKey = input.KeyCode
					keyButton.Text = currentKey.Name
					keyButton.TextColor3 = self.theme.text
					CreateTween(keyStroke, {Color = self.theme.border, Transparency = 0.5}, 0.2):Play()
					binding = false
					connection:Disconnect()
					
					if callback then
						callback(currentKey)
					end
				end
			end)
		end
	end)
	
	-- Listen for key press
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
			-- Visual feedback
			CreateTween(keyButton, {BackgroundColor3 = self.theme.primary}, 0.1):Play()
			task.wait(0.1)
			CreateTween(keyButton, {BackgroundColor3 = self.theme.secondary}, 0.1):Play()
			
			if callback then
				callback(currentKey, true)
			end
		end
	end)
	
	return container, function() return currentKey end
end

-- 继续完成被截断的代码并优化整个UI库

-- Section Divider (继续)
function SimpleUI:CreateSection(parent, text, config)
    config = config or {}
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local line1 = Instance.new("Frame")
    line1.Size = UDim2.new(0.5, -40, 0, 1)
    line1.Position = UDim2.new(0, 0, 0.5, 0)
    line1.BackgroundColor3 = self.theme.border
    line1.BorderSizePixel = 0
    line1.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 70, 1, 0)
    label.Position = UDim2.new(0.5, -35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Section"
    label.TextColor3 = self.theme.textSecondary
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = section
    
    local line2 = Instance.new("Frame")
    line2.Size = UDim2.new(0.5, -40, 0, 1)
    line2.Position = UDim2.new(0.5, 40, 0.5, 0)
    line2.BackgroundColor3 = self.theme.border
    line2.BorderSizePixel = 0
    line2.Parent = section
    
    return section
end

-- Separator
function SimpleUI:CreateSeparator(parent, config)
    config = config or {}
    
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = self.theme.border
    separator.BackgroundTransparency = 0.5
    separator.BorderSizePixel = 0
    separator.Parent = parent
    
    return separator
end

-- Paragraph
function SimpleUI:CreateParagraph(parent, title, text, config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Size = config.Size or UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Title"
    titleLabel.TextColor3 = self.theme.text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, -25)
    textLabel.Position = UDim2.new(0, 0, 0, 25)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "Content"
    textLabel.TextColor3 = self.theme.textSecondary
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Parent = container
    
    return container
end

-- Image
function SimpleUI:CreateImage(parent, imageId, config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Size = config.Size or UDim2.new(1, 0, 0, 150)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundColor3 = self.theme.secondary
    image.BorderSizePixel = 0
    image.Image = imageId or ""
    image.ScaleType = Enum.ScaleType.Crop
    image.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = image
    
    return container
end

-- Enhanced Notification System
function SimpleUI:Notify(config)
    config = config or {}
    local text = config.Text or config.text or "Notification"
    local duration = config.Duration or config.duration or 3
    local type = config.Type or config.type or "info"
    
    local colors = {
        info = self.theme.info,
        success = self.theme.success,
        warning = self.theme.warning,
        error = self.theme.danger,
        danger = self.theme.danger
    }
    
    local screen = self.mainScreen or CreateScreenGui()
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 0)
    notif.Position = UDim2.new(1, -320, 0, 20 + (#self.notifications * 70))
    notif.BackgroundColor3 = self.theme.surface
    notif.BorderSizePixel = 0
    notif.Parent = screen
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = colors[type] or self.theme.primary
    stroke.Thickness = 2
    stroke.Parent = notif
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = colors[type] or self.theme.primary
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notif
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 10)
    accentCorner.Parent = accentBar
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.theme.text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = notif
    
    table.insert(self.notifications, notif)
    
    CreateTween(notif, {Size = UDim2.new(0, 300, 0, 60)}, 0.3, Enum.EasingStyle.Back):Play()
    
    task.delay(duration, function()
        CreateTween(notif, {
            Position = UDim2.new(1, 0, notif.Position.Y.Scale, notif.Position.Y.Offset),
            BackgroundTransparency = 1
        }, 0.3):Play()
        task.wait(0.3)
        
        local index = table.find(self.notifications, notif)
        if index then
            table.remove(self.notifications, index)
        end
        
        notif:Destroy()
        
        for i, n in ipairs(self.notifications) do
            CreateTween(n, {Position = UDim2.new(1, -320, 0, 20 + ((i-1) * 70))}, 0.2):Play()
        end
    end)
    
    return notif
end

-- Color Helper Functions
function SimpleUI:LightenColor(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

function SimpleUI:DarkenColor(color, amount)
    return Color3.new(
        math.clamp(color.R - amount, 0, 1),
        math.clamp(color.G - amount, 0, 1),
        math.clamp(color.B - amount, 0, 1)
    )
end

-- Make Draggable
function SimpleUI:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        CreateTween(frame, {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }, 0.1):Play()
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Toggle UI Visibility
function SimpleUI:ToggleUI()
    if not self.uiVisible then
        self:Show()
    else
        self:Hide()
    end
end

-- Show UI
function SimpleUI:Show()
    self.uiVisible = true
    
    if self.floatingButton then
        CreateTween(self.floatingButton, {Rotation = 0}, 0.3):Play()
    end
    
    for _, window in pairs(self.windows) do
        if window and window.Parent then
            window.Visible = true
            CreateTween(window, {
                Size = window:GetAttribute("OriginalSize") or UDim2.new(0, 400, 0, 300),
                BackgroundTransparency = 0
            }, 0.3, Enum.EasingStyle.Back):Play()
        end
    end
    
    if self.blurEffect then
        CreateTween(self.blurEffect, {Size = 0}, 0.3):Play()
    end
end

-- Hide UI
function SimpleUI:Hide()
    self.uiVisible = false
    
    if self.floatingButton then
        CreateTween(self.floatingButton, {Rotation = 180}, 0.3):Play()
    end
    
    for _, window in pairs(self.windows) do
        if window and window.Parent then
            window:SetAttribute("OriginalSize", window.Size)
            CreateTween(window, {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }, 0.3):Play()
            task.wait(0.3)
            window.Visible = false
        end
    end
    
    if self.blurEffect then
        CreateTween(self.blurEffect, {Size = BLUR_SIZE}, 0.3):Play()
    end
end

-- Tab System
function SimpleUI:CreateTabContainer(parent, config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Size = config.Size or UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.BackgroundColor3 = self.theme.secondary
    tabBar.BorderSizePixel = 0
    tabBar.Parent = container
    
    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 8)
    tabBarCorner.Parent = tabBar
    
    local tabBarLayout = Instance.new("UIListLayout")
    tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    tabBarLayout.Padding = UDim.new(0, 5)
    tabBarLayout.Parent = tabBar
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = container
    
    local tabs = {}
    local currentTab = nil
    
    local tabContainer = {
        Container = container,
        AddTab = function(self, name, icon)
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(0, 100, 1, 0)
            tabButton.BackgroundColor3 = self.theme.secondary
            tabButton.BorderSizePixel = 0
            tabButton.Text = name
            tabButton.TextColor3 = self.theme.text
            tabButton.TextSize = 14
            tabButton.Font = Enum.Font.Gotham
            tabButton.AutoButtonColor = false
            tabButton.Parent = tabBar
            
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 6)
            tabCorner.Parent = tabButton
            
            if icon then
                local iconLabel = Instance.new("ImageLabel")
                iconLabel.Size = UDim2.new(0, 16, 0, 16)
                iconLabel.Position = UDim2.new(0, 8, 0.5, -8)
                iconLabel.BackgroundTransparency = 1
                iconLabel.Image = icon
                iconLabel.ImageColor3 = self.theme.text
                iconLabel.Parent = tabButton
                
                tabButton.TextXAlignment = Enum.TextXAlignment.Left
                tabButton.PaddingLeft = UDim.new(0, 30)
            end
            
            local tabContent = Instance.new("ScrollingFrame")
            tabContent.Size = UDim2.new(1, 0, 1, 0)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollBarImageColor3 = self.theme.primary
            tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            tabContent.Visible = false
            tabContent.Parent = contentFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 8)
            contentLayout.Parent = tabContent
            
            tabs[name] = {
                Button = tabButton,
                Content = tabContent
            }
            
            tabButton.MouseButton1Click:Connect(function()
                if currentTab then
                    tabs[currentTab].Content.Visible = false
                    CreateTween(tabs[currentTab].Button, {
                        BackgroundColor3 = self.theme.secondary,
                        TextColor3 = self.theme.text
                    }, 0.2):Play()
                end
                
                currentTab = name
                tabContent.Visible = true
                CreateTween(tabButton, {
                    BackgroundColor3 = self.theme.primary,
                    TextColor3 = self.theme.text
                }, 0.2):Play()
            end)
            
            -- Select first tab by default
            if not currentTab then
                tabButton.MouseButton1Click:Fire()
            end
            
            return tabContent
        end,
        
        SelectTab = function(self, name)
            if tabs[name] then
                tabs[name].Button.MouseButton1Click:Fire()
            end
        end
    }
    
    return tabContainer
end

-- Progress Bar
function SimpleUI:CreateProgressBar(parent, text, value, config)
    config = config or {}
    local currentValue = math.clamp(value or 0, 0, 100)
    
    local container = Instance.new("Frame")
    container.Size = config.Size or UDim2.new(1, 0, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 20)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = text or "Progress"
    title.TextColor3 = self.theme.text
    title.TextSize = 14
    title.Font = Enum.Font.Gotham
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local percentage = Instance.new("TextLabel")
    percentage.Size = UDim2.new(0.3, 0, 1, 0)
    percentage.Position = UDim2.new(0.7, 0, 0, 0)
    percentage.BackgroundTransparency = 1
    percentage.Text = string.format("%d%%", currentValue)
    percentage.TextColor3 = self.theme.textSecondary
    percentage.TextSize = 14
    percentage.Font = Enum.Font.GothamBold
    percentage.TextXAlignment = Enum.TextXAlignment.Right
    percentage.Parent = header
    
    -- Progress track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 12)
    track.Position = UDim2.new(0, 0, 0, 25)
    track.BackgroundColor3 = self.theme.secondary
    track.BorderSizePixel = 0
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Progress fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(currentValue / 100, 0, 1, 0)
    fill.BackgroundColor3 = self.theme.primary
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Animated gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.theme.primary),
        ColorSequenceKeypoint.new(1, self:LightenColor(self.theme.primary, 0.3))
    })
    gradient.Rotation = 45
    gradient.Parent = fill
    
    -- Progress methods
    local progressBar = {
        Container = container,
        SetValue = function(_, newValue)
            currentValue = math.clamp(newValue, 0, 100)
            percentage.Text = string.format("%d%%", currentValue)
            CreateTween(fill, {Size = UDim2.new(currentValue / 100, 0, 1, 0)}, 0.3):Play()
        end,
        
        GetValue = function(_)
            return currentValue
        end,
        
        SetColor = function(_, color)
            fill.BackgroundColor3 = color
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color),
                ColorSequenceKeypoint.new(1, self:LightenColor(color, 0.3))
            })
        end
    }
    
    return progressBar
end

-- Loading Spinner
function SimpleUI:CreateLoadingSpinner(parent, config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Size = config.Size or UDim2.new(0, 40, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(1, 0, 1, 0)
    spinner.BackgroundTransparency = 1
    spinner.Parent = container
    
    local circle1 = Instance.new("Frame")
    circle1.Size = UDim2.new(0, 8, 0, 8)
    circle1.Position = UDim2.new(0.5, -4, 0, 0)
    circle1.BackgroundColor3 = self.theme.primary
    circle1.BorderSizePixel = 0
    circle1.Parent = spinner
    
    local circle1Corner = Instance.new("UICorner")
    circle1Corner.CornerRadius = UDim.new(1, 0)
    circle1Corner.Parent = circle1
    
    local circle2 = Instance.new("Frame")
    circle2.Size = UDim2.new(0, 6, 0, 6)
    circle2.Position = UDim2.new(0.5, -3, 0, 0)
    circle2.BackgroundColor3 = self.theme.success
    circle2.BorderSizePixel = 0
    circle2.Parent = spinner
    
    local circle2Corner = Instance.new("UICorner")
    circle2Corner.CornerRadius = UDim.new(1, 0)
    circle2Corner.Parent = circle2
    
    -- Rotation animation
    local rotation = 0
    local connection = RunService.Heartbeat:Connect(function(dt)
        rotation = (rotation + dt * 360) % 360
        spinner.Rotation = rotation
    end)
    
    -- Cleanup
    container.Destroying:Connect(function()
        connection:Disconnect()
    end)
    
    return container
end

-- Tooltip System
function SimpleUI:CreateTooltip(parent, text, config)
    config = config or {}
    
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 150, 0, 0)
    tooltip.BackgroundColor3 = self.theme.surface
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 100
    tooltip.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tooltip
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.theme.border
    stroke.Thickness = 1
    stroke.Parent = tooltip
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, -10)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.theme.text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = tooltip
    
    local function showTooltip()
        tooltip.Visible = true
        CreateTween(tooltip, {Size = UDim2.new(0, 150, 0, 40)}, 0.2):Play()
    end
    
    local function hideTooltip()
        CreateTween(tooltip, {Size = UDim2.new(0, 150, 0, 0)}, 0.2):Play()
        task.wait(0.2)
        tooltip.Visible = false
    end
    
    return {
        Tooltip = tooltip,
        Show = showTooltip,
        Hide = hideTooltip,
        SetText = function(_, newText)
            label.Text = newText
        end
    }
end

-- Utility Methods
function SimpleUI:Center(element)
    element.AnchorPoint = Vector2.new(0.5, 0.5)
    element.Position = UDim2.new(0.5, 0, 0.5, 0)
end

function SimpleUI:Destroy()
    if self.mainScreen then
        self.mainScreen:Destroy()
    end
    
    if self.blurEffect then
        self.blurEffect:Destroy()
    end
    
    -- Clean up all windows
    for _, window in pairs(self.windows) do
        if window and window.Parent then
            window:Destroy()
        end
    end
    
    self.windows = {}
    self.notifications = {}
end

-- Enhanced Method Aliases (兼容性)
SimpleUI.NewWindow = SimpleUI.CreateWindow
SimpleUI.NewButton = SimpleUI.CreateButton
SimpleUI.NewLabel = SimpleUI.CreateLabel
SimpleUI.NewToggle = SimpleUI.CreateToggle
SimpleUI.NewSlider = SimpleUI.CreateSlider
SimpleUI.NewTextBox = SimpleUI.CreateTextBox
SimpleUI.NewDropdown = SimpleUI.CreateDropdown
SimpleUI.NewColorPicker = SimpleUI.CreateColorPicker
SimpleUI.NewKeybind = SimpleUI.CreateKeybind
SimpleUI.NewSection = SimpleUI.CreateSection

-- 返回完整的UI库
return SimpleUI