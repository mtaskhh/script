local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CoordinateDisplay"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(1, -190, 0, 120) 
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.8 
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

local CoordLabel = Instance.new("TextLabel")
CoordLabel.Size = UDim2.new(1, -20, 1, -30) -- 调整大小给关闭按钮留空间
CoordLabel.Position = UDim2.new(0, 10, 0, 25) -- 调整位置
CoordLabel.BackgroundTransparency = 1
CoordLabel.Text = "x: 0.00\ny: 0.00\nz: 0.00"
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.TextSize = 14
CoordLabel.Font = Enum.Font.Code
CoordLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordLabel.TextYAlignment = Enum.TextYAlignment.Top
CoordLabel.Parent = MainFrame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 60, 0, 20)
CopyButton.Position = UDim2.new(1, -70, 1, -25)
CopyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyButton.BackgroundTransparency = 0.2
CopyButton.Text = "✝️复制✝️"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 12
CopyButton.Font = Enum.Font.Code
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = CopyButton

local dragging = true
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function updateCoordinates()
    if not LocalPlayer.Character then return end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local position = rootPart.Position
    local x, y, z = position.X, position.Y, position.Z
   
    CoordLabel.Text = string.format("x: %.2f\ny: %.2f\nz: %.2f", x, y, z)
end

local function copyCoordinates()
    if not LocalPlayer.Character then return end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local position = rootPart.Position
    local x, y, z = position.X, position.Y, position.Z
    
    local coordString = string.format("%.2f,%.2f,%.2f", x, y, z)
    
    pcall(function()
        setclipboard(coordString)
    end)
    
    local originalText = CopyButton.Text
    CopyButton.Text = "已复制😘"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    
    wait(1.5)
    
    CopyButton.Text = originalText
    CopyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end

-- 关闭窗口函数
local function closeWindow()
    ScreenGui:Destroy()
end

CopyButton.MouseButton1Click:Connect(copyCoordinates)

CoordLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        copyCoordinates()
    end
end)

-- 关闭按钮点击事件
CloseButton.MouseButton1Click:Connect(closeWindow)

RunService.Heartbeat:Connect(updateCoordinates)

updateCoordinates()

warn("mtaskh坐标仪已加载!")
warn("位置: 右上角")
warn("格式: x,y,z (高精度)")
warn("透明度: 80%")
warn("点击坐标或复制按钮即可复制")
warn("点击×按钮关闭窗口")