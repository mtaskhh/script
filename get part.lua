-- 路径复制工具 - 与透视工具搭配使用
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- 创建主界面（与透视工具相同的ScreenGui）
local ScreenGui = game:GetService("CoreGui"):FindFirstChild("RainbowESP") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RainbowESP")
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RainbowESP"
    ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end

-- 主悬浮窗（放在透视工具下方）
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(1, -330, 0, 270) -- 在透视工具下方
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 圆角
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- 标题栏圆角（只圆角顶部）
local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "路径复制工具"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- 内容容器
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- 路径输入框
local PathInputBox = Instance.new("TextBox")
PathInputBox.Size = UDim2.new(1, -20, 0, 35)
PathInputBox.Position = UDim2.new(0, 10, 0, 10)
PathInputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PathInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PathInputBox.PlaceholderText = "输入Dex路径 (如: workspace.Model)"
PathInputBox.Text = ""
PathInputBox.TextSize = 14
PathInputBox.Font = Enum.Font.Gotham
PathInputBox.ClearTextOnFocus = false
PathInputBox.Parent = ContentContainer

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = PathInputBox

-- 状态显示
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 60)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "状态: 等待输入路径\n💡 输入Dex中的路径\n📋 复制所有零件名称"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = ContentContainer

-- 控制按钮框架
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 0, 35)
ButtonFrame.Position = UDim2.new(0, 10, 1, -45)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = ContentContainer

-- 复制按钮
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, 0, 1, 0)
CopyButton.Position = UDim2.new(0, 0, 0, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
CopyButton.Text = "复制路径下所有零件"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 13
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = ButtonFrame

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 6)
CopyCorner.Parent = CopyButton

-- 手机拖拽功能
local dragging = false
local dragStart, startPos

-- 检测是否为移动设备
local isMobile = UserInputService.TouchEnabled

-- 通用的拖拽开始函数
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

-- 通用的拖拽更新函数
local function updateDrag(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                    input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        
        -- 限制在屏幕范围内
        local screenSize = ScreenGui.AbsoluteSize
        local frameSize = MainFrame.AbsoluteSize
        newX = math.max(0, math.min(newX, screenSize.X - frameSize.X))
        newY = math.max(0, math.min(newY, screenSize.Y - frameSize.Y))
        
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end

-- 创建拖拽区域（覆盖整个标题栏但排除按钮）
local DragArea = Instance.new("TextLabel")
DragArea.Size = UDim2.new(1, -40, 1, 0) -- 留出按钮空间
DragArea.Position = UDim2.new(0, 0, 0, 0)
DragArea.BackgroundTransparency = 1
DragArea.Text = ""
DragArea.Parent = TitleBar

-- 设置拖拽事件
DragArea.InputBegan:Connect(startDrag)
UserInputService.InputChanged:Connect(updateDrag)

-- 为移动设备添加长按提示
if isMobile then
    local touchHint = Instance.new("TextLabel")
    touchHint.Size = UDim2.new(1, 0, 1, 0)
    touchHint.Position = UDim2.new(0, 0, 0, 0)
    touchHint.BackgroundTransparency = 1
    touchHint.Text = "长按拖动"
    touchHint.TextColor3 = Color3.fromRGB(200, 200, 200)
    touchHint.TextSize = 10
    touchHint.Font = Enum.Font.Gotham
    touchHint.Visible = false
    touchHint.Parent = DragArea
    
    DragArea.MouseEnter:Connect(function()
        touchHint.Visible = true
    end)
    DragArea.MouseLeave:Connect(function()
        touchHint.Visible = false
    end)
end

-- 获取路径下所有零件名称
local function getPartsFromPath(path)
    local parts = {}
    local uniqueNames = {}
    
    -- 尝试解析路径
    local success, target = pcall(function()
        return loadstring("return " .. path)()
    end)
    
    if not success or not target then
        return nil, "路径无效或不存在: " .. path
    end
    
    -- 递归收集所有零件
    local function collectParts(object)
        if object:IsA("BasePart") or object:IsA("MeshPart") then
            local partName = object.Name
            -- 去重并只添加零件
            if not uniqueNames[partName] then
                table.insert(parts, partName)
                uniqueNames[partName] = true
            end
        end
        
        -- 递归子对象
        for _, child in pairs(object:GetChildren()) do
            collectParts(child)
        end
    end
    
    collectParts(target)
    
    if #parts == 0 then
        return nil, "该路径下没有找到零件"
    end
    
    return parts, #parts
end

-- 复制零件名称
local function copyPartNames()
    local path = PathInputBox.Text
    if path == "" then
        StatusLabel.Text = "状态: 请输入路径\n❌ 路径不能为空"
        return
    end
    
    CopyButton.Text = "处理中..."
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    
    local parts, count = getPartsFromPath(path)
    
    if not parts then
        StatusLabel.Text = "状态: " .. count -- 这里count是错误信息
        CopyButton.Text = "复制路径下所有零件"
        CopyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        return
    end
    
    -- 格式化为透视工具兼容的格式（逗号分隔）
    local partNamesString = table.concat(parts, ",")
    
    -- 复制到剪贴板
    pcall(function()
        setclipboard(partNamesString)
    end)
    
    -- 更新状态
    StatusLabel.Text = string.format("状态: 已复制 %d 个零件\n📋 格式已适配透视工具\n💡 可粘贴到透视工具输入框", count)
    
    -- 按钮反馈
    CopyButton.Text = "已复制!"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    
    wait(2)
    
    CopyButton.Text = "复制路径下所有零件"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end

-- 复制按钮点击事件
CopyButton.MouseButton1Click:Connect(copyPartNames)

-- 输入框回车事件
PathInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        copyPartNames()
    end
end)

-- 关闭按钮事件
CloseButton.MouseButton1Click:Connect(function()
    MainFrame:Destroy()
end)

warn("路径复制工具已加载!")
warn("使用方法:")
warn("1. 输入从Dex获取的路径 (如: workspace.Model)")
warn("2. 点击按钮复制该路径下所有零件名称")
warn("3. 复制的格式已适配透视工具")
warn("4. 可将复制的内容直接粘贴到透视工具输入框")
warn("5. " .. (isMobile and "长按标题栏拖动" or "拖动标题栏移动"))