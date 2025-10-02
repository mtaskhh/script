--[[
	SimpleUI Pro - Enhanced UI Library for Roblox
	Version: 2.0.0
	Optimized for Injectors
]]

local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function GetScreenGui()
	local success, result = pcall(function()
		return CoreGui:FindFirstChild("SimpleUI_Pro")
	end)
	
	if success and result then
		return result
	end
	
	-- Fallback to PlayerGui if CoreGui is not accessible
	local player = Players.LocalPlayer
	if player then
		return player:WaitForChild("PlayerGui"):FindFirstChild("SimpleUI_Pro")
	end
end

local function CreateScreenGui(name, parent)
	local screen = Instance.new("ScreenGui")
	screen.Name = name or "SimpleUI_Pro"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.DisplayOrder = 999999
	
	-- Try to parent to CoreGui first (for injectors)
	local success = pcall(function()
		screen.Parent = parent or CoreGui
	end)
	
	if not success then
		-- Fallback to PlayerGui
		local player = Players.LocalPlayer
		if player then
			screen.Parent = player:WaitForChild("PlayerGui")
		end
	end
	
	return screen
end

-- Tween Helper
local function CreateTween(instance, properties, duration, style, direction)
	local tweenInfo = TweenInfo.new(
		duration or 0.3,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	)
	return TweenService:Create(instance, tweenInfo, properties)
end

-- Constructor
function SimpleUI.new()
	local self = setmetatable({}, SimpleUI)
	
	self.theme = {
		primary = Color3.fromRGB(66, 135, 245),
		secondary = Color3.fromRGB(45, 45, 45),
		background = Color3.fromRGB(30, 30, 30),
		text = Color3.fromRGB(255, 255, 255),
		border = Color3.fromRGB(60, 60, 60),
		success = Color3.fromRGB(40, 167, 69),
		danger = Color3.fromRGB(220, 53, 69),
		warning = Color3.fromRGB(255, 193, 7),
		hover = Color3.fromRGB(80, 150, 255)
	}
	
	self.windows = {}
	self.notifications = {}
	self.dragConnections = {}
	
	return self
end

-- Create Screen with protection
function SimpleUI:Screen(name, parent)
	return CreateScreenGui(name, parent)
end

-- Create Draggable Window
function SimpleUI:Window(parent, title, props)
	props = props or {}
	
	local window = Instance.new("Frame")
	window.Name = props.Name or "Window"
	window.Size = props.Size or UDim2.new(0, 400, 0, 300)
	window.Position = props.Position or UDim2.new(0.5, -200, 0.5, -150)
	window.BackgroundColor3 = props.BackgroundColor3 or self.theme.background
	window.BorderSizePixel = 0
	window.ClipsDescendants = true
	window.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = window
	
	-- Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = self.theme.secondary
	titleBar.BorderSizePixel = 0
	titleBar.Parent = window
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = titleBar
	
	-- Fix title bar corners
	local titleFix = Instance.new("Frame")
	titleFix.Size = UDim2.new(1, 0, 0, 10)
	titleFix.Position = UDim2.new(0, 0, 1, -10)
	titleFix.BackgroundColor3 = self.theme.secondary
	titleFix.BorderSizePixel = 0
	titleFix.Parent = titleBar
	
	-- Title Text
	local titleText = Instance.new("TextLabel")
	titleText.Size = UDim2.new(1, -70, 1, 0)
	titleText.Position = UDim2.new(0, 10, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = title or "Window"
	titleText.TextColor3 = self.theme.text
	titleText.TextSize = 16
	titleText.Font = Enum.Font.GothamBold
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Parent = titleBar
	
	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 25, 0, 25)
	closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
	closeBtn.BackgroundColor3 = self.theme.danger
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "×"
	closeBtn.TextColor3 = self.theme.text
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = titleBar
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 5)
	closeCorner.Parent = closeBtn
	
	-- Minimize Button
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
	minimizeBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
	minimizeBtn.BackgroundColor3 = self.theme.warning
	minimizeBtn.BorderSizePixel = 0
	minimizeBtn.Text = "_"
	minimizeBtn.TextColor3 = self.theme.text
	minimizeBtn.TextSize = 16
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.Parent = titleBar
	
	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(0, 5)
	minimizeCorner.Parent = minimizeBtn
	
	-- Content Frame
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -45)
	content.Position = UDim2.new(0, 10, 0, 40)
	content.BackgroundTransparency = 1
	content.Parent = window
	
	-- Make window draggable
	self:MakeDraggable(window, titleBar)
	
	-- Close functionality
	closeBtn.MouseButton1Click:Connect(function()
		local closeTween = CreateTween(window, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, 0.3)
		closeTween:Play()
		closeTween.Completed:Connect(function()
			window:Destroy()
		end)
	end)
	
	-- Minimize functionality
	local isMinimized = false
	local originalSize = window.Size
	
	minimizeBtn.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			CreateTween(window, {
				Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35)
			}, 0.3):Play()
		else
			CreateTween(window, {
				Size = originalSize
			}, 0.3):Play()
		end
	end)
	
	window.Parent = parent
	table.insert(self.windows, window)
	
	return window, content
end

-- Make element draggable
function SimpleUI:MakeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	local function update(input)
		if dragging then
			local delta = input.Position - dragStart
			local newPosition = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			CreateTween(frame, {Position = newPosition}, 0.05):Play()
		end
	end
	
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
		   input.UserInputType == Enum.UserInputType.Touch then
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
	
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or 
		   input.UserInputType == Enum.UserInputType.Touch then
			update(input)
		end
	end)
end

-- Enhanced Frame
function SimpleUI:Frame(parent, props)
	props = props or {}
	
	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Frame"
	frame.Size = props.Size or UDim2.new(0, 200, 0, 200)
	frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = props.BackgroundColor3 or self.theme.background
	frame.BorderSizePixel = props.BorderSizePixel or 0
	frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	frame.BackgroundTransparency = props.BackgroundTransparency or 0
	
	if props.Rounded ~= false then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, props.CornerRadius or 8)
		corner.Parent = frame
	end
	
	if props.Gradient then
		local gradient = Instance.new("UIGradient")
		gradient.Color = props.Gradient
		gradient.Rotation = props.GradientRotation or 0
		gradient.Parent = frame
	end
	
	if props.Padding then
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, props.Padding)
		padding.PaddingBottom = UDim.new(0, props.Padding)
		padding.PaddingLeft = UDim.new(0, props.Padding)
		padding.PaddingRight = UDim.new(0, props.Padding)
		padding.Parent = frame
	end
	
	if props.Shadow then
		local shadow = Instance.new("ImageLabel")
		shadow.Name = "Shadow"
		shadow.Size = UDim2.new(1, 30, 1, 30)
		shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		shadow.AnchorPoint = Vector2.new(0.5, 0.5)
		shadow.BackgroundTransparency = 1
		shadow.Image = "rbxassetid://1316045217"
		shadow.ImageColor3 = Color3.new(0, 0, 0)
		shadow.ImageTransparency = 0.5
		shadow.ScaleType = Enum.ScaleType.Slice
		shadow.SliceCenter = Rect.new(10, 10, 118, 118)
		shadow.ZIndex = frame.ZIndex - 1
		shadow.Parent = frame
	end
	
	frame.Parent = parent
	return frame
end

-- Enhanced Button with animations
function SimpleUI:Button(parent, text, props, callback)
	props = props or {}
	
	local button = Instance.new("TextButton")
	button.Name = props.Name or "Button"
	button.Size = props.Size or UDim2.new(0, 150, 0, 40)
	button.Position = props.Position or UDim2.new(0, 0, 0, 0)
	button.BackgroundColor3 = props.BackgroundColor3 or self.theme.primary
	button.BorderSizePixel = 0
	button.Text = text or "Button"
	button.TextColor3 = props.TextColor3 or self.theme.text
	button.TextSize = props.TextSize or 16
	button.Font = props.Font or Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, props.CornerRadius or 6)
	corner.Parent = button
	
	-- Add stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = props.StrokeColor or self.theme.border
	stroke.Thickness = props.StrokeThickness or 0
	stroke.Transparency = props.StrokeTransparency or 0.5
	stroke.Parent = button
	
	-- Ripple effect container
	local rippleContainer = Instance.new("Frame")
	rippleContainer.Name = "RippleContainer"
	rippleContainer.Size = UDim2.new(1, 0, 1, 0)
	rippleContainer.BackgroundTransparency = 1
	rippleContainer.ClipsDescendants = true
	rippleContainer.Parent = button
	
	local rippleCorner = Instance.new("UICorner")
	rippleCorner.CornerRadius = corner.CornerRadius
	rippleCorner.Parent = rippleContainer
	
	-- Button states
	local originalColor = props.BackgroundColor3 or self.theme.primary
	local hoverColor = self:LightenColor(originalColor, 0.1)
	local pressColor = self:DarkenColor(originalColor, 0.1)
	
	-- Hover animations
	button.MouseEnter:Connect(function()
		CreateTween(button, {BackgroundColor3 = hoverColor}, 0.2):Play()
		CreateTween(button, {Size = UDim2.new(
			button.Size.X.Scale, 
			button.Size.X.Offset + 2,
			button.Size.Y.Scale,
			button.Size.Y.Offset + 2
		)}, 0.2):Play()
	end)
	
	button.MouseLeave:Connect(function()
		CreateTween(button, {BackgroundColor3 = originalColor}, 0.2):Play()
		CreateTween(button, {Size = props.Size or UDim2.new(0, 150, 0, 40)}, 0.2):Play()
	end)
	
	-- Click with ripple effect
	button.MouseButton1Down:Connect(function()
		CreateTween(button, {BackgroundColor3 = pressColor}, 0.1):Play()
		
		-- Create ripple
		local ripple = Instance.new("Frame")
		ripple.Name = "Ripple"
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.BackgroundColor3 = Color3.new(1, 1, 1)
		ripple.BackgroundTransparency = 0.7
		ripple.Parent = rippleContainer
		
		local rippleCorner = Instance.new("UICorner")
		rippleCorner.CornerRadius = UDim.new(1, 0)
		rippleCorner.Parent = ripple
		
		local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
		
		CreateTween(ripple, {
			Size = UDim2.new(0, maxSize, 0, maxSize),
			BackgroundTransparency = 1
		}, 0.5):Play()
		
		task.wait(0.5)
		ripple:Destroy()
	end)
	
	button.MouseButton1Up:Connect(function()
		CreateTween(button, {BackgroundColor3 = hoverColor}, 0.1):Play()
	end)
	
	if callback then
		button.MouseButton1Click:Connect(callback)
	end
	
	button.Parent = parent
	return button
end

-- Enhanced Toggle with smooth animations
function SimpleUI:Toggle(parent, text, defaultValue, props, callback)
	props = props or {}
	local isOn = defaultValue or false
	
	local container = Instance.new("Frame")
	container.Name = props.Name or "Toggle"
	container.Size = props.Size or UDim2.new(0, 200, 0, 40)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	-- Interactive area
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text or "Toggle"
	label.TextColor3 = props.TextColor3 or self.theme.text
	label.TextSize = props.TextSize or 16
	label.Font = props.Font or Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = container
	
	local switch = Instance.new("Frame")
	switch.Name = "Switch"
	switch.Size = UDim2.new(0, 50, 0, 26)
	switch.Position = UDim2.new(1, -50, 0.5, -13)
	switch.BackgroundColor3 = isOn and self.theme.success or Color3.fromRGB(100, 100, 100)
	switch.BorderSizePixel = 0
	switch.Parent = container
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch
	
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = isOn and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	-- Add shadow to knob
	local knobShadow = Instance.new("Frame")
	knobShadow.Name = "Shadow"
	knobShadow.Size = UDim2.new(1, 4, 1, 4)
	knobShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
	knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	knobShadow.BackgroundColor3 = Color3.new(0, 0, 0)
	knobShadow.BackgroundTransparency = 0.7
	knobShadow.ZIndex = knob.ZIndex - 1
	knobShadow.Parent = knob
	
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(1, 0)
	shadowCorner.Parent = knobShadow
	
	-- Toggle function
	local function toggle()
		isOn = not isOn
		
		-- Animate knob
		CreateTween(knob, {
			Position = isOn and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
		}, 0.25, Enum.EasingStyle.Back):Play()
		
		-- Animate color
		CreateTween(switch, {
			BackgroundColor3 = isOn and self.theme.success or Color3.fromRGB(100, 100, 100)
		}, 0.25):Play()
		
		-- Scale animation
		CreateTween(knob, {Size = UDim2.new(0, 22, 0, 22)}, 0.1):Play()
		task.wait(0.1)
		CreateTween(knob, {Size = UDim2.new(0, 20, 0, 20)}, 0.1):Play()
		
		if callback then
			callback(isOn)
		end
	end
	
	button.MouseButton1Click:Connect(toggle)
	
	-- Hover effects
	button.MouseEnter:Connect(function()
		CreateTween(switch, {
			BackgroundColor3 = isOn and self:LightenColor(self.theme.success, 0.1) or Color3.fromRGB(120, 120, 120)
		}, 0.2):Play()
	end)
	
	button.MouseLeave:Connect(function()
		CreateTween(switch, {
			BackgroundColor3 = isOn and self.theme.success or Color3.fromRGB(100, 100, 100)
		}, 0.2):Play()
	end)
	
	container.Parent = parent
	return container, function() return isOn end
end

-- Enhanced TextBox
function SimpleUI:TextBox(parent, placeholder, props, callback)
	props = props or {}
	
	local container = Instance.new("Frame")
	container.Name = "TextBoxContainer"
	container.Size = props.Size or UDim2.new(0, 200, 0, 40)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundColor3 = props.BackgroundColor3 or self.theme.secondary
	container.BorderSizePixel = 0
	container.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, props.CornerRadius or 6)
	corner.Parent = container
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = self.theme.border
	stroke.Thickness = 1
	stroke.Transparency = 1
	stroke.Parent = container
	
	local textbox = Instance.new("TextBox")
	textbox.Name = props.Name or "TextBox"
	textbox.Size = UDim2.new(1, -20, 1, 0)
	textbox.Position = UDim2.new(0, 10, 0, 0)
	textbox.BackgroundTransparency = 1
	textbox.PlaceholderText = placeholder or "Enter text..."
	textbox.Text = props.Text or ""
	textbox.TextColor3 = props.TextColor3 or self.theme.text
	textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	textbox.TextSize = props.TextSize or 14
	textbox.Font = props.Font or Enum.Font.Gotham
	textbox.ClearTextOnFocus = props.ClearTextOnFocus or false
	textbox.TextXAlignment = Enum.TextXAlignment.Left
	textbox.Parent = container
	
	-- Focus animations
	textbox.Focused:Connect(function()
		CreateTween(stroke, {Transparency = 0}, 0.2):Play()
		CreateTween(stroke, {Color = self.theme.primary}, 0.2):Play()
	end)
	
	textbox.FocusLost:Connect(function(enterPressed)
		CreateTween(stroke, {Transparency = 1}, 0.2):Play()
		CreateTween(stroke, {Color = self.theme.border}, 0.2):Play()
		
		if callback then
			callback(textbox.Text, enterPressed)
		end
	end)
	
	container.Parent = parent
	return container, textbox
end

-- Enhanced Notification System
function SimpleUI:Notify(parent, message, type, duration)
	type = type or "info"
	duration = duration or 3
	
	local colors = {
		info = self.theme.primary,
		success = self.theme.success,
		warning = self.theme.warning,
		error = self.theme.danger
	}
	
	local icons = {
		info = "ℹ",
		success = "✓",
		warning = "⚠",
		error = "✕"
	}
	
	-- Notification container
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 350, 0, 70)
	notification.Position = UDim2.new(1, 400, 1, -80 - (#self.notifications * 80))
	notification.BackgroundColor3 = self.theme.background
	notification.BorderSizePixel = 0
	notification.Parent = parent
	
	table.insert(self.notifications, notification)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = notification
	
	-- Side accent
	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 4, 1, 0)
	accent.Position = UDim2.new(0, 0, 0, 0)
	accent.BackgroundColor3 = colors[type] or self.theme.primary
	accent.BorderSizePixel = 0
	accent.Parent = notification
	
	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(0, 10)
	accentCorner.Parent = accent
	
	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0, 15, 0.5, -20)
	icon.BackgroundColor3 = colors[type] or self.theme.primary
	icon.BorderSizePixel = 0
	icon.Text = icons[type] or "ℹ"
	icon.TextColor3 = self.theme.text
	icon.TextSize = 20
	icon.Font = Enum.Font.GothamBold
	icon.Parent = notification
	
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = icon
	
	-- Message
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, -20)
	label.Position = UDim2.new(0, 65, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = message
	label.TextColor3 = self.theme.text
	label.TextSize = 14
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = notification
	
	-- Animate in
	CreateTween(notification, {
		Position = UDim2.new(1, -360, 1, -80 - ((#self.notifications - 1) * 80))
	}, 0.5, Enum.EasingStyle.Back):Play()
	
	-- Auto hide
	task.wait(duration)
	
	CreateTween(notification, {
		Position = UDim2.new(1, 400, 1, -80 - ((#self.notifications - 1) * 80))
	}, 0.3):Play()
	
	task.wait(0.3)
	
	local index = table.find(self.notifications, notification)
	if index then
		table.remove(self.notifications, index)
	end
	
	notification:Destroy()
	
	-- Update positions of remaining notifications
	for i, notif in ipairs(self.notifications) do
		CreateTween(notif, {
			Position = UDim2.new(1, -360, 1, -80 - ((i - 1) * 80))
		}, 0.2):Play()
	end
	
	return notification
end

-- Slider Component
function SimpleUI:Slider(parent, min, max, default, props, callback)
	props = props or {}
	local value = default or min
	
	local container = Instance.new("Frame")
	container.Name = props.Name or "Slider"
	container.Size = props.Size or UDim2.new(0, 200, 0, 50)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	-- Value label
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(1, 0, 0, 20)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = props.Title or "Value: " .. tostring(value)
	valueLabel.TextColor3 = self.theme.text
	valueLabel.TextSize = 14
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.Parent = container
	
	-- Slider track
	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 30)
	track.BackgroundColor3 = self.theme.secondary
	track.BorderSizePixel = 0
	track.Parent = container
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track
	
	-- Slider fill
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = self.theme.primary
	fill.BorderSizePixel = 0
	fill.Parent = track
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill
	
	-- Slider knob
	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new((value - min) / (max - min), -10, 0.5, -10)
	knob.BackgroundColor3 = self.theme.text
	knob.BorderSizePixel = 0
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.Parent = track
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	-- Dragging
	local dragging = false
	
	knob.MouseButton1Down:Connect(function()
		dragging = true
		CreateTween(knob, {Size = UDim2.new(0, 24, 0, 24)}, 0.1):Play()
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			CreateTween(knob, {Size = UDim2.new(0, 20, 0, 20)}, 0.1):Play()
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouse = UserInputService:GetMouseLocation()
			local relativeX = math.clamp((mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			
			value = math.floor(min + (max - min) * relativeX)
			
			CreateTween(knob, {Position = UDim2.new(relativeX, -10, 0.5, -10)}, 0.05):Play()
			CreateTween(fill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.05):Play()
			
			valueLabel.Text = props.Title or "Value: " .. tostring(value)
			
			if callback then
				callback(value)
			end
		end
	end)
	
	container.Parent = parent
	return container, function() return value end
end

-- Dropdown Component
function SimpleUI:Dropdown(parent, options, default, props, callback)
	props = props or {}
	local selected = default or options[1] or "Select"
	local isOpen = false
	
	local container = Instance.new("Frame")
	container.Name = props.Name or "Dropdown"
	container.Size = props.Size or UDim2.new(0, 200, 0, 40)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundColor3 = props.BackgroundColor3 or self.theme.secondary
	container.BorderSizePixel = 0
	container.ClipsDescendants = false
	container.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = container
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = selected
	button.TextColor3 = self.theme.text
	button.TextSize = 14
	button.Font = Enum.Font.Gotham
	button.Parent = container
	
	-- Arrow icon
	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 20, 0, 20)
	arrow.Position = UDim2.new(1, -25, 0.5, -10)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = self.theme.text
	arrow.TextSize = 12
	arrow.Font = Enum.Font.Gotham
	arrow.Parent = container
	
	-- Options container
	local optionsFrame = Instance.new("Frame")
	optionsFrame.Size = UDim2.new(1, 0, 0, #options * 35)
	optionsFrame.Position = UDim2.new(0, 0, 1, 5)
	optionsFrame.BackgroundColor3 = self.theme.secondary
	optionsFrame.BorderSizePixel = 0
	optionsFrame.Visible = false
	optionsFrame.ZIndex = 999
	optionsFrame.Parent = container
	
	local optionsCorner = Instance.new("UICorner")
	optionsCorner.CornerRadius = UDim.new(0, 6)
	optionsCorner.Parent = optionsFrame
	
	local optionsLayout = Instance.new("UIListLayout")
	optionsLayout.Padding = UDim.new(0, 0)
	optionsLayout.Parent = optionsFrame
	
	-- Create option buttons
	for _, option in ipairs(options) do
		local optionBtn = Instance.new("TextButton")
		optionBtn.Size = UDim2.new(1, 0, 0, 35)
		optionBtn.BackgroundColor3 = self.theme.secondary
		optionBtn.BorderSizePixel = 0
		optionBtn.Text = option
		optionBtn.TextColor3 = self.theme.text
		optionBtn.TextSize = 14
		optionBtn.Font = Enum.Font.Gotham
		optionBtn.Parent = optionsFrame
		
		optionBtn.MouseEnter:Connect(function()
			CreateTween(optionBtn, {BackgroundColor3 = self.theme.primary}, 0.2):Play()
		end)
		
		optionBtn.MouseLeave:Connect(function()
			CreateTween(optionBtn, {BackgroundColor3 = self.theme.secondary}, 0.2):Play()
		end)
		
		optionBtn.MouseButton1Click:Connect(function()
			selected = option
			button.Text = selected
			isOpen = false
			optionsFrame.Visible = false
			CreateTween(arrow, {Rotation = 0}, 0.2):Play()
			
			if callback then
				callback(selected)
			end
		end)
	end
	
	button.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		optionsFrame.Visible = isOpen
		CreateTween(arrow, {Rotation = isOpen and 180 or 0}, 0.2):Play()
	end)
	
	container.Parent = parent
	return container, function() return selected end
end

-- Utility Functions
function SimpleUI:LightenColor(color, amount)
	local h, s, v = Color3.toHSV(color)
	return Color3.fromHSV(h, s * (1 - amount), math.min(v + amount, 1))
end

function SimpleUI:DarkenColor(color, amount)
	local h, s, v = Color3.toHSV(color)
	return Color3.fromHSV(h, s, math.max(v - amount, 0))
end

function SimpleUI:Center(element)
	element.AnchorPoint = Vector2.new(0.5, 0.5)
	element.Position = UDim2.new(0.5, 0, 0.5, 0)
end

-- Tab System
function SimpleUI:TabContainer(parent, props)
	props = props or {}
	
	local container = Instance.new("Frame")
	container.Name = "TabContainer"
	container.Size = props.Size or UDim2.new(1, 0, 1, 0)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(1, 0, 0, 35)
	tabBar.BackgroundColor3 = self.theme.secondary
	tabBar.BorderSizePixel = 0
	tabBar.Parent = container
	
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
	
	return {
		Container = container,
		AddTab = function(_, name)
			local tabButton = Instance.new("TextButton")
			tabButton.Size = UDim2.new(0, 100, 1, 0)
			tabButton.BackgroundColor3 = self.theme.secondary
			tabButton.BorderSizePixel = 0
			tabButton.Text = name
			tabButton.TextColor3 = self.theme.text
			tabButton.TextSize = 14
			tabButton.Font = Enum.Font.Gotham
			tabButton.Parent = tabBar
			
			local tabContent = Instance.new("ScrollingFrame")
			tabContent.Size = UDim2.new(1, 0, 1, 0)
			tabContent.BackgroundTransparency = 1
			tabContent.BorderSizePixel = 0
			tabContent.ScrollBarThickness = 4
			tabContent.Visible = false
			tabContent.Parent = contentFrame
			
			local contentLayout = Instance.new("UIListLayout")
			contentLayout.Padding = UDim.new(0, 5)
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
		end
	}
end

return SimpleUI