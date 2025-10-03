local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()

ESPLibrary.GlobalConfig.Rainbow = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RainbowESP"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(1, -330, 0, 20) -- 右上角
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

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Mtaskh透视"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- 折叠按钮
local FoldButton = Instance.new("TextButton")
FoldButton.Size = UDim2.new(0, 25, 0, 25)
FoldButton.Position = UDim2.new(1, -60, 0, 5)
FoldButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FoldButton.Text = "−"
FoldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FoldButton.TextSize = 18
FoldButton.Font = Enum.Font.GothamBold
FoldButton.Parent = TitleBar

local FoldCorner = Instance.new("UICorner")
FoldCorner.CornerRadius = UDim.new(0, 5)
FoldCorner.Parent = FoldButton

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

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- 输入框
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -20, 0, 35)
InputBox.Position = UDim2.new(0, 10, 0, 10)
InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderText = "输入多个名称，用逗号分隔"
InputBox.Text = ""
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.ClearTextOnFocus = false -- 不清除原有文字
InputBox.Parent = ContentContainer

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputBox

-- 状态显示
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 80)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "状态: 等待输入\n💡 用逗号分隔多个名称\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
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

-- 启用按钮
local EnableButton = Instance.new("TextButton")
EnableButton.Size = UDim2.new(0.48, 0, 1, 0)
EnableButton.Position = UDim2.new(0, 0, 0, 0)
EnableButton.BackgroundColor3 = Color3.fromRGB(0, 140, 80)
EnableButton.Text = "启用透视"
EnableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableButton.TextSize = 13
EnableButton.Font = Enum.Font.GothamBold
EnableButton.Parent = ButtonFrame

local EnableCorner = Instance.new("UICorner")
EnableCorner.CornerRadius = UDim.new(0, 6)
EnableCorner.Parent = EnableButton

-- 清除按钮
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, 0, 1, 0)
ClearButton.Position = UDim2.new(0.52, 0, 0, 0)
ClearButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ClearButton.Text = "清除所有"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 13
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Parent = ButtonFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

-- 折叠状态变量
local isFolded = false
local originalSize = MainFrame.Size
local foldedSize = UDim2.new(0, 120, 0, 35) -- 折叠后的小正方形尺寸

-- 折叠/展开函数
local function toggleFold()
    isFolded = not isFolded
    
    if isFolded then
        -- 折叠状态
        FoldButton.Text = "+"
        FoldButton.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
        ContentContainer.Visible = false
        MainFrame.Size = foldedSize
        TitleLabel.Text = "透视"
        
        -- 确保标题栏覆盖整个折叠后的框架
        TitleBar.Size = UDim2.new(1, 0, 1, 0)
    else
        -- 展开状态
        FoldButton.Text = "−"
        FoldButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        ContentContainer.Visible = true
        MainFrame.Size = originalSize
        TitleLabel.Text = "Mtaskh透视"
        
        -- 恢复标题栏原始大小
        TitleBar.Size = UDim2.new(1, 0, 0, 35)
    end
end

-- 折叠按钮点击事件
FoldButton.MouseButton1Click:Connect(toggleFold)

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
        
        -- 捕获输入以防止屏幕滑动
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
DragArea.Size = UDim2.new(1, -60, 1, 0) -- 留出按钮空间
DragArea.Position = UDim2.new(0, 0, 0, 0)
DragArea.BackgroundTransparency = 1
DragArea.Text = ""
DragArea.Parent = TitleBar

-- 为折叠状态也设置拖拽区域
local FoldedDragArea = Instance.new("TextLabel")
FoldedDragArea.Size = UDim2.new(1, -60, 1, 0) -- 留出按钮空间
FoldedDragArea.Position = UDim2.new(0, 0, 0, 0)
FoldedDragArea.BackgroundTransparency = 1
FoldedDragArea.Text = ""
FoldedDragArea.Visible = false
FoldedDragArea.Parent = MainFrame

-- 设置拖拽事件
local function setupDragEvents(dragArea)
    -- 鼠标和触摸开始事件
    dragArea.InputBegan:Connect(startDrag)
    
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
        touchHint.Parent = dragArea
        
        -- 显示/隐藏提示
        dragArea.MouseEnter:Connect(function()
            touchHint.Visible = true
        end)
        dragArea.MouseLeave:Connect(function()
            touchHint.Visible = false
        end)
    end
end

-- 设置拖拽区域事件
setupDragEvents(DragArea)
setupDragEvents(FoldedDragArea)

-- 拖拽过程事件
UserInputService.InputChanged:Connect(updateDrag)

-- 更新折叠状态时的拖拽区域
local function updateFoldedDragArea()
    if isFolded then
        FoldedDragArea.Visible = true
        DragArea.Visible = false
    else
        FoldedDragArea.Visible = false
        DragArea.Visible = true
    end
end

-- 初始更新拖拽区域
updateFoldedDragArea()

-- 折叠时更新拖拽区域
local originalToggleFold = toggleFold
toggleFold = function()
    originalToggleFold()
    updateFoldedDragArea()
end

-- ESP 功能变量
local espEnabled = false
local currentSearchItems = {}
local trackedObjects = {}

-- 清除所有ESP
local function clearAllESP()
    ESPLibrary:Clear()
    trackedObjects = {}
    StatusLabel.Text = "状态: 已清除所有ESP\n💡 输入新内容开始透视\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
end

-- 分割字符串为多个搜索项
local function splitSearchItems(inputText)
    local items = {}
    for item in string.gmatch(inputText, "([^,]+)") do
        item = string.gsub(item, "^%s*(.-)%s*$", "%1") -- 去除前后空格
        if item ~= "" then
            table.insert(items, item)
        end
    end
    return items
end

-- 检查是否为玩家名称
local function isPlayerName(name)
    for _, player in pairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(name) then
            return player
        end
    end
    return nil
end

-- 为玩家添加ESP
local function addPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(character)
        if not character:FindFirstChild("HumanoidRootPart") then
            character:WaitForChild("HumanoidRootPart")
        end
        
        local espElement = ESPLibrary:Add({
            Name = player.Name,
            Model = character,
            Color = Color3.new(1, 1, 1), -- 彩虹效果会覆盖这个颜色
            MaxDistance = math.huge, -- 设置为最大距离
            TextSize = 16,
            ESPType = "Highlight",
            FillTransparency = 0.5,
            OutlineTransparency = 0,
            Tracer = {
                Enabled = true,
                From = "Bottom"
            },
            Arrow = {
                Enabled = true
            }
        })
        
        table.insert(trackedObjects, {
            Object = character,
            ESPElement = espElement,
            Type = "Player",
            SearchTerm = player.Name
        })
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- 为零件添加ESP
local function addPartESP(part, searchTerm)
    local espElement = ESPLibrary:Add({
        Name = part.Name,
        Model = part,
        Color = Color3.new(1, 1, 1), -- 彩虹效果会覆盖这个颜色
        MaxDistance = math.huge, -- 设置为最大距离
        TextSize = 14,
        ESPType = "Highlight",
        FillTransparency = 0.4,
        OutlineTransparency = 0,
        Tracer = {
            Enabled = true,
            From = "Bottom"
        }
    })
    
    table.insert(trackedObjects, {
        Object = part,
        ESPElement = espElement,
        Type = "Part",
        SearchTerm = searchTerm
    })
end

-- 搜索并标记对象
local function searchAndMarkObjects()
    clearAllESP()
    
    if not espEnabled or #currentSearchItems == 0 then
        StatusLabel.Text = "状态: ESP已关闭\n💡 输入新内容开始透视\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
        return
    end
    
    local foundCount = 0
    local playerCount = 0
    local partCount = 0
    
    -- 处理每个搜索项
    for _, searchTerm in pairs(currentSearchItems) do
        local searchText = string.lower(searchTerm)
        
        -- 先检查是否是玩家名称
        local targetPlayer = isPlayerName(searchTerm)
        if targetPlayer then
            addPlayerESP(targetPlayer)
            foundCount = foundCount + 1
            playerCount = playerCount + 1
        else
            -- 搜索 workspace 中的所有零件
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and string.find(string.lower(obj.Name), searchText) then
                    pcall(function()
                        addPartESP(obj, searchTerm)
                        foundCount = foundCount + 1
                        partCount = partCount + 1
                    end)
                end
            end
        end
    end
    
    -- 更新状态显示
    local statusText = string.format("状态: 找到 %d 个对象\n", foundCount)
    if playerCount > 0 then
        statusText = statusText .. string.format("玩家: %d 个\n", playerCount)
    end
    if partCount > 0 then
        statusText = statusText .. string.format("零件: %d 个\n", partCount)
    end
    statusText = statusText .. "🌈 彩虹效果已启用\n📏 最大距离: 无限"
    
    StatusLabel.Text = statusText
end

-- 输入框内容改变事件 - 只更新搜索项，不触发透视
InputBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentSearchItems = splitSearchItems(InputBox.Text)
    
    -- 更新状态显示，但不触发透视
    if #currentSearchItems > 0 then
        StatusLabel.Text = string.format("状态: 已输入 %d 个搜索项\n💡 点击'启用透视'开始\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限", #currentSearchItems)
    else
        StatusLabel.Text = "状态: 等待输入\n💡 用逗号分隔多个名称\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
    end
end)

-- 启用按钮点击事件
EnableButton.MouseButton1Click:Connect(function()
    if #currentSearchItems == 0 then
        StatusLabel.Text = "状态: 请输入内容\n💡 用逗号分隔多个名称\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
        return
    end
    
    espEnabled = true
    EnableButton.Text = "透视中..."
    EnableButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    
    -- 显示开始搜索的状态
    StatusLabel.Text = string.format("状态: 正在搜索 %d 个项目...\n🌈 请稍候...", #currentSearchItems)
    
    -- 延迟一下让状态显示出来
    wait(0.1)
    
    searchAndMarkObjects()
    
    wait(1)
    EnableButton.Text = "重新透视"
    EnableButton.BackgroundColor3 = Color3.fromRGB(0, 140, 80)
end)

ClearButton.MouseButton1Click:Connect(function()
    espEnabled = false
    clearAllESP()
    EnableButton.Text = "启用透视"
    EnableButton.BackgroundColor3 = Color3.fromRGB(0, 140, 80)
    StatusLabel.Text = "状态: 已清除所有ESP\n💡 输入新内容开始透视\n🌈 所有ESP都有彩虹效果\n📏 最大距离: 无限"
end)

CloseButton.MouseButton1Click:Connect(function()
    clearAllESP()
    ScreenGui:Destroy()
end)

RunService.Heartbeat:Connect(function()
    if espEnabled and #currentSearchItems > 0 then
     
        if tick() % 3 < 0.1 then
            for _, searchTerm in pairs(currentSearchItems) do
                local targetPlayer = isPlayerName(searchTerm)
                if not targetPlayer then
                   
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and 
                           string.find(string.lower(obj.Name), string.lower(searchTerm)) then
                            local alreadyTracked = false
                            for _, tracked in pairs(trackedObjects) do
                                if tracked.Object == obj and tracked.SearchTerm == searchTerm then
                                    alreadyTracked = true
                                    break
                                end
                            end
                            if not alreadyTracked then
                                pcall(function()
                                    addPartESP(obj, searchTerm)
                            
                                    local currentText = StatusLabel.Text
                                    local lines = {}
                                    for line in currentText:gmatch("[^\n]+") do
                                        table.insert(lines, line)
                                    end
                                    if #lines > 0 then
                                        lines[1] = lines[1] .. " (+1)"
                                        StatusLabel.Text = table.concat(lines, "\n")
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

warn("ESP透视器已加载!")
warn("使用方法:")
warn("1. 输入多个零件名或玩家名，用逗号分隔")
warn("2. 例如: Mouse,Part,Handle,Player1")
warn("3. 点击'启用透视'按钮开始透视")
warn("4. 所有ESP都有彩虹效果")
warn("5. 最大透视距离: 无限")
warn("6. 输入框会保留原有文字")
warn("7. 点击标题栏的'-'按钮可以折叠UI")
warn("8. " .. (isMobile and "长按标题栏左侧区域可以移动UI位置" or "拖动标题栏左侧区域可以移动UI位置"))