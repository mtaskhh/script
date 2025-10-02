--[[
	SimpleUI - Lightweight UI Library for Roblox
	Version: 1.0.0
	
	Usage:
	local SimpleUI = require(path.to.SimpleUI)
	local ui = SimpleUI.new()
	
	-- Create a screen GUI
	local screen = ui:Screen("MyUI")
	
	-- Add elements
	local frame = ui:Frame(screen, {
		Size = UDim2.new(0, 300, 0, 200),
		Position = UDim2.new(0.5, -150, 0.5, -100),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	})
	
	local button = ui:Button(frame, "Click Me", {
		Size = UDim2.new(0, 200, 0, 50),
		Position = UDim2.new(0.5, -100, 0.5, -25)
	}, function()
		print("Button clicked!")
	end)
]]

local SimpleUI = {}
SimpleUI.__index = SimpleUI

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
		warning = Color3.fromRGB(255, 193, 7)
	}
	return self
end

-- Create ScreenGui
function SimpleUI:Screen(name, parent)
	local screen = Instance.new("ScreenGui")
	screen.Name = name or "SimpleUI"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	return screen
end

-- Create Frame
function SimpleUI:Frame(parent, props)
	props = props or {}
	
	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Frame"
	frame.Size = props.Size or UDim2.new(0, 200, 0, 200)
	frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = props.BackgroundColor3 or self.theme.background
	frame.BorderSizePixel = props.BorderSizePixel or 0
	frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	if props.Rounded ~= false then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, props.CornerRadius or 8)
		corner.Parent = frame
	end
	
	if props.Padding then
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, props.Padding)
		padding.PaddingBottom = UDim.new(0, props.Padding)
		padding.PaddingLeft = UDim.new(0, props.Padding)
		padding.PaddingRight = UDim.new(0, props.Padding)
		padding.Parent = frame
	end
	
	frame.Parent = parent
	return frame
end

-- Create Button
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
	
	-- Hover effect
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = self:LightenColor(button.BackgroundColor3, 0.2)
	end)
	
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = props.BackgroundColor3 or self.theme.primary
	end)
	
	-- Click effect
	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = self:DarkenColor(button.BackgroundColor3, 0.2)
	end)
	
	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = props.BackgroundColor3 or self.theme.primary
	end)
	
	if callback then
		button.MouseButton1Click:Connect(callback)
	end
	
	button.Parent = parent
	return button
end

-- Create Label
function SimpleUI:Label(parent, text, props)
	props = props or {}
	
	local label = Instance.new("TextLabel")
	label.Name = props.Name or "Label"
	label.Size = props.Size or UDim2.new(0, 200, 0, 30)
	label.Position = props.Position or UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = props.BackgroundTransparency or 1
	label.Text = text or "Label"
	label.TextColor3 = props.TextColor3 or self.theme.text
	label.TextSize = props.TextSize or 16
	label.Font = props.Font or Enum.Font.Gotham
	label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	label.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	label.Parent = parent
	return label
end

-- Create TextBox
function SimpleUI:TextBox(parent, placeholder, props, callback)
	props = props or {}
	
	local textbox = Instance.new("TextBox")
	textbox.Name = props.Name or "TextBox"
	textbox.Size = props.Size or UDim2.new(0, 200, 0, 40)
	textbox.Position = props.Position or UDim2.new(0, 0, 0, 0)
	textbox.BackgroundColor3 = props.BackgroundColor3 or self.theme.secondary
	textbox.BorderSizePixel = 0
	textbox.PlaceholderText = placeholder or "Enter text..."
	textbox.Text = props.Text or ""
	textbox.TextColor3 = props.TextColor3 or self.theme.text
	textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	textbox.TextSize = props.TextSize or 14
	textbox.Font = props.Font or Enum.Font.Gotham
	textbox.ClearTextOnFocus = props.ClearTextOnFocus or false
	textbox.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, props.CornerRadius or 6)
	corner.Parent = textbox
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = textbox
	
	if callback then
		textbox.FocusLost:Connect(function(enterPressed)
			callback(textbox.Text, enterPressed)
		end)
	end
	
	textbox.Parent = parent
	return textbox
end

-- Create ScrollingFrame
function SimpleUI:ScrollFrame(parent, props)
	props = props or {}
	
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = props.Name or "ScrollFrame"
	scroll.Size = props.Size or UDim2.new(0, 300, 0, 400)
	scroll.Position = props.Position or UDim2.new(0, 0, 0, 0)
	scroll.BackgroundColor3 = props.BackgroundColor3 or self.theme.background
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = props.ScrollBarThickness or 6
	scroll.CanvasSize = props.CanvasSize or UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = props.AutomaticCanvasSize or Enum.AutomaticSize.Y
	scroll.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, props.CornerRadius or 8)
	corner.Parent = scroll
	
	if props.Padding then
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, props.Padding)
		padding.PaddingBottom = UDim.new(0, props.Padding)
		padding.PaddingLeft = UDim.new(0, props.Padding)
		padding.PaddingRight = UDim.new(0, props.Padding)
		padding.Parent = scroll
	end
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, props.ItemPadding or 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scroll
	
	scroll.Parent = parent
	return scroll
end

-- Create ImageLabel
function SimpleUI:Image(parent, imageId, props)
	props = props or {}
	
	local image = Instance.new("ImageLabel")
	image.Name = props.Name or "Image"
	image.Size = props.Size or UDim2.new(0, 100, 0, 100)
	image.Position = props.Position or UDim2.new(0, 0, 0, 0)
	image.BackgroundTransparency = props.BackgroundTransparency or 1
	image.Image = imageId or ""
	image.ImageColor3 = props.ImageColor3 or Color3.fromRGB(255, 255, 255)
	image.ScaleType = props.ScaleType or Enum.ScaleType.Fit
	image.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	if props.Rounded ~= false then
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, props.CornerRadius or 8)
		corner.Parent = image
	end
	
	image.Parent = parent
	return image
end

-- Create Toggle
function SimpleUI:Toggle(parent, text, defaultValue, props, callback)
	props = props or {}
	local isOn = defaultValue or false
	
	local container = Instance.new("Frame")
	container.Name = props.Name or "Toggle"
	container.Size = props.Size or UDim2.new(0, 200, 0, 40)
	container.Position = props.Position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	
	local label = self:Label(container, text, {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	})
	
	local switch = Instance.new("TextButton")
	switch.Name = "Switch"
	switch.Size = UDim2.new(0, 50, 0, 28)
	switch.Position = UDim2.new(1, -50, 0.5, -14)
	switch.BackgroundColor3 = isOn and self.theme.success or self.theme.secondary
	switch.BorderSizePixel = 0
	switch.Text = ""
	switch.AutoButtonColor = false
	switch.Parent = container
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switch
	
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 22, 0, 22)
	knob.Position = isOn and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	switch.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		local tweenService = game:GetService("TweenService")
		local goal = {}
		goal.Position = isOn and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
		local tween = tweenService:Create(knob, TweenInfo.new(0.2), goal)
		tween:Play()
		
		local colorGoal = {}
		colorGoal.BackgroundColor3 = isOn and self.theme.success or self.theme.secondary
		local colorTween = tweenService:Create(switch, TweenInfo.new(0.2), colorGoal)
		colorTween:Play()
		
		if callback then
			callback(isOn)
		end
	end)
	
	container.Parent = parent
	return container, isOn
end

-- Create Notification
function SimpleUI:Notify(parent, message, type, duration)
	type = type or "info"
	duration = duration or 3
	
	local colors = {
		info = self.theme.primary,
		success = self.theme.success,
		warning = self.theme.warning,
		error = self.theme.danger
	}
	
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 300, 0, 0)
	notification.Position = UDim2.new(0.5, -150, 0, -80)
	notification.BackgroundColor3 = colors[type] or self.theme.primary
	notification.BorderSizePixel = 0
	notification.AnchorPoint = Vector2.new(0, 0)
	notification.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notification
	
	local label = self:Label(notification, message, {
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center
	})
	
	-- Animate in
	local tweenService = game:GetService("TweenService")
	local showTween = tweenService:Create(notification, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 300, 0, 60),
		Position = UDim2.new(0.5, -150, 0, 20)
	})
	showTween:Play()
	
	-- Auto hide
	task.wait(duration)
	local hideTween = tweenService:Create(notification, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -150, 0, -80)
	})
	hideTween:Play()
	hideTween.Completed:Connect(function()
		notification:Destroy()
	end)
	
	return notification
end

-- Utility: Lighten color
function SimpleUI:LightenColor(color, amount)
	return Color3.new(
		math.min(color.R + amount, 1),
		math.min(color.G + amount, 1),
		math.min(color.B + amount, 1)
	)
end

-- Utility: Darken color
function SimpleUI:DarkenColor(color, amount)
	return Color3.new(
		math.max(color.R - amount, 0),
		math.max(color.G - amount, 0),
		math.max(color.B - amount, 0)
	)
end

-- Utility: Center element
function SimpleUI:Center(element)
	element.Position = UDim2.new(0.5, -(element.Size.X.Offset / 2), 0.5, -(element.Size.Y.Offset / 2))
	element.AnchorPoint = Vector2.new(0.5, 0.5)
end

return SimpleUI