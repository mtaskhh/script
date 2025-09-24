-- 故障艺术风格公告系统
-- 作者: mtaskh
-- 版本: v2.4 - MT字母增强版

local config = {
    title = "mtaskh v1.2",
    content = "mshax公告\n\n感谢使用mtaskh汉化脚本！\n更新日志：-美化了公告\n-增加一大堆功能",
    explanation = "by--mtaskh",
    groupNumber = "698664023",
    animationDuration = 0.8,
    redFilterFadeDuration = 3.0,
    glitchIntensity = 25, -- 故障效果强度
    glitchFrequency = 0.1, -- 故障效果频率(秒)
    redFilterIntensity = 0.9, -- 红色滤镜强度参数
    rightBoxText = "LOADING…\nMTASKH\nv1.2" -- 右侧方框文本
}

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local setclipboard = setclipboard or (syn and syn.setclipboard) or function(text) 
    warn("[UI] 复制失败: 注入器不支持 setclipboard")
    return false
end

local sg = Instance.new("ScreenGui")
sg.Name = "GlitchAnnouncementUI"
sg.Parent = CoreGui
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建模糊效果
local blur = Instance.new("BlurEffect")
blur.Name = "AnnouncementBlur"
blur.Size = 45
blur.Parent = Lighting

-- 创建红色滤镜效果
local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Saturation = config.redFilterIntensity
colorCorrection.TintColor = Color3.fromRGB(255, 100, 100)
colorCorrection.Brightness = -0.1
colorCorrection.Contrast = 0.2
colorCorrection.Parent = Lighting

-- 创建更深的红色背景覆盖
local redOverlay = Instance.new("Frame")
redOverlay.Size = UDim2.new(1, 0, 1, 0)
redOverlay.Position = UDim2.new(0, 0, 0, 0)
redOverlay.BackgroundColor3 = Color3.fromRGB(40, 0, 0) -- 更深的红色
redOverlay.BackgroundTransparency = 0.85
redOverlay.ZIndex = 0
redOverlay.Parent = sg

-- 故障效果层
local glitchOverlay = Instance.new("Frame")
glitchOverlay.Size = UDim2.new(1, 0, 1, 0)
glitchOverlay.Position = UDim2.new(0, 0, 0, 0)
glitchOverlay.BackgroundTransparency = 1
glitchOverlay.ZIndex = 5
glitchOverlay.Parent = sg

-- 确保ScreenGui设置正确
sg.DisplayOrder = 10
sg.IgnoreGuiInset = true

-- 屏幕尺寸自适应
local function updateSize()
    local screenSize = workspace.CurrentCamera.ViewportSize
    redOverlay.Size = UDim2.new(0, screenSize.X, 0, screenSize.Y)
    glitchOverlay.Size = UDim2.new(0, screenSize.X, 0, screenSize.Y)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
updateSize()

-- 创建主容器 - 调整尺寸为更长且稍微变小
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 580, 0, 450) -- 宽度变小，高度增加
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -225) -- 调整位置
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0) -- 更深的背景
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = sg
mainFrame.ZIndex = 10

-- 添加圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 25) -- 稍微调整圆角
corner.Parent = mainFrame

-- 添加外发光效果
local shadow = Instance.new("UIStroke")
shadow.Thickness = 3
shadow.Color = Color3.fromRGB(255, 50, 50) -- 更深的红色发光
shadow.Transparency = 0.3
shadow.Parent = mainFrame

-- 添加内发光效果
local innerGlow = Instance.new("UIStroke")
innerGlow.Thickness = 1
innerGlow.Color = Color3.fromRGB(255, 100, 100) -- 更深的红色发光
innerGlow.Transparency = 0.5
innerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
innerGlow.Parent = mainFrame

-- 创建顶部方框容器
local topContainer = Instance.new("Frame")
topContainer.Size = UDim2.new(1, -20, 0, 100)
topContainer.Position = UDim2.new(0, 10, 0, 10)
topContainer.BackgroundTransparency = 1
topContainer.Parent = mainFrame

-- 左侧小方框（MT字母框）
local leftBox = Instance.new("Frame")
leftBox.Size = UDim2.new(0, 80, 1, 0)
leftBox.Position = UDim2.new(0, 0, 0, 0)
leftBox.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
leftBox.BackgroundTransparency = 0.2
leftBox.BorderSizePixel = 0
leftBox.Parent = topContainer

-- 左侧方框圆角
local leftBoxCorner = Instance.new("UICorner")
leftBoxCorner.CornerRadius = UDim.new(0, 15)
leftBoxCorner.Parent = leftBox

-- 左侧方框发光效果
local leftBoxGlow = Instance.new("UIStroke")
leftBoxGlow.Thickness = 2
leftBoxGlow.Color = Color3.fromRGB(255, 50, 50)
leftBoxGlow.Transparency = 0.4
leftBoxGlow.Parent = leftBox

-- MT字母文本
local mtLabel = Instance.new("TextLabel")
mtLabel.Size = UDim2.new(1, -10, 1, -10)
mtLabel.Position = UDim2.new(0, 5, 0, 5)
mtLabel.BackgroundTransparency = 1
mtLabel.Text = "MT"
mtLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
mtLabel.TextSize = 32
mtLabel.Font = Enum.Font.GothamBlack
mtLabel.TextScaled = true
mtLabel.Parent = leftBox

-- MT字母发光效果
local mtGlow = Instance.new("UIStroke")
mtGlow.Thickness = 3
mtGlow.Color = Color3.fromRGB(255, 50, 50)
mtGlow.Transparency = 0.3
mtGlow.Parent = mtLabel

-- 右侧大方框（高级动画和文本）
local rightBox = Instance.new("Frame")
rightBox.Size = UDim2.new(1, -90, 1, 0)
rightBox.Position = UDim2.new(0, 90, 0, 0)
rightBox.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
rightBox.BackgroundTransparency = 0.1
rightBox.BorderSizePixel = 0
rightBox.Parent = topContainer

-- 右侧方框圆角
local rightBoxCorner = Instance.new("UICorner")
rightBoxCorner.CornerRadius = UDim.new(0, 15)
rightBoxCorner.Parent = rightBox

-- 右侧方框发光效果
local rightBoxGlow = Instance.new("UIStroke")
rightBoxGlow.Thickness = 2
rightBoxGlow.Color = Color3.fromRGB(255, 50, 50)
rightBoxGlow.Transparency = 0.4
rightBoxGlow.Parent = rightBox

-- 右侧方框文本
local rightBoxTextLabel = Instance.new("TextLabel")
rightBoxTextLabel.Size = UDim2.new(1, -10, 1, -10)
rightBoxTextLabel.Position = UDim2.new(0, 5, 0, 5)
rightBoxTextLabel.BackgroundTransparency = 1
rightBoxTextLabel.Text = config.rightBoxText
rightBoxTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rightBoxTextLabel.TextSize = 14
rightBoxTextLabel.Font = Enum.Font.GothamBold
rightBoxTextLabel.TextXAlignment = Enum.TextXAlignment.Center
rightBoxTextLabel.TextYAlignment = Enum.TextYAlignment.Center
rightBoxTextLabel.TextWrapped = true
rightBoxTextLabel.Parent = rightBox

-- 右侧方框文本发光
local rightBoxTextGlow = Instance.new("UIStroke")
rightBoxTextGlow.Thickness = 1
rightBoxTextGlow.Color = Color3.fromRGB(255, 100, 100)
rightBoxTextGlow.Transparency = 0.6
rightBoxTextGlow.Parent = rightBoxTextLabel

-- 创建标题（位置下移）
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 45)
titleLabel.Position = UDim2.new(0, 10, 0, 120) -- 位置下移
titleLabel.BackgroundTransparency = 1
titleLabel.Text = config.title
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 28 -- 稍微减小字体
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextWrapped = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

-- 标题描边效果
local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 2
titleStroke.Color = Color3.fromRGB(255, 150, 150)
titleStroke.Transparency = 0.6
titleStroke.Parent = titleLabel

-- 创建内容文本（位置下移，高度增加）
local contentLabel = Instance.new("TextLabel")
contentLabel.Size = UDim2.new(1, -40, 0, 180) -- 高度增加
contentLabel.Position = UDim2.new(0, 20, 0, 170) -- 位置下移
contentLabel.BackgroundTransparency = 1
contentLabel.Text = config.content
contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
contentLabel.TextSize = 16 -- 稍微减小字体
contentLabel.Font = Enum.Font.Gotham
contentLabel.TextWrapped = true
contentLabel.TextXAlignment = Enum.TextXAlignment.Center
contentLabel.TextYAlignment = Enum.TextYAlignment.Top
contentLabel.Parent = mainFrame

-- 创建解释文本（位置下移）
local explanationLabel = Instance.new("TextLabel")
explanationLabel.Size = UDim2.new(1, -40, 0, 30)
explanationLabel.Position = UDim2.new(0, 20, 0, 360) -- 位置下移
explanationLabel.BackgroundTransparency = 1
explanationLabel.Text = config.explanation
explanationLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
explanationLabel.TextSize = 14 -- 稍微减小字体
explanationLabel.Font = Enum.Font.Gotham
explanationLabel.TextWrapped = true
explanationLabel.TextXAlignment = Enum.TextXAlignment.Center
explanationLabel.Parent = mainFrame

-- 创建确认按钮（位置下移）
local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 160, 0, 35) -- 稍微变小
confirmBtn.Position = UDim2.new(0.5, -170, 1, -45) -- 位置下移
confirmBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40) -- 更深的红色
confirmBtn.Text = "确认"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextSize = 18 -- 稍微减小字体
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.Parent = mainFrame

-- 胶囊形状按钮
local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(1, 0)
confirmCorner.Parent = confirmBtn

-- 按钮描边
local confirmStroke = Instance.new("UIStroke")
confirmStroke.Thickness = 2
confirmStroke.Color = Color3.fromRGB(255, 100, 100)
confirmStroke.Transparency = 0.3
confirmStroke.Parent = confirmBtn

-- 创建复制按钮（位置下移）
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 160, 0, 35) -- 稍微变小
copyBtn.Position = UDim2.new(0.5, 10, 1, -45) -- 位置下移
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 150) -- 更深的蓝色
copyBtn.Text = "复制群号"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 18 -- 稍微减小字体
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = mainFrame

-- 胶囊形状按钮
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(1, 0)
copyCorner.Parent = copyBtn

-- 按钮描边
local copyStroke = Instance.new("UIStroke")
copyStroke.Thickness = 2
copyStroke.Color = Color3.fromRGB(100, 100, 255)
copyStroke.Transparency = 0.3
copyStroke.Parent = copyBtn

-- MT字母脉冲效果
local function createMTPulseEffect()
    spawn(function()
        while true do
            -- 缩放脉冲
            TweenService:Create(mtLabel, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(255, 150, 150)
            }):Play()
            
            TweenService:Create(mtGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.1,
                Thickness = 4
            }):Play()
            
            wait(0.8)
            
            TweenService:Create(mtLabel, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(255, 100, 100)
            }):Play()
            
            TweenService:Create(mtGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3,
                Thickness = 3
            }):Play()
            
            wait(0.8)
        end
    end)
end

-- 增强故障效果函数
local function createGlitchEffect()
    -- 主标题故障效果
    local redGlitch = titleLabel:Clone()
    redGlitch.TextColor3 = Color3.fromRGB(255, 0, 0)
    redGlitch.Position = UDim2.new(0, 10 + math.random(-config.glitchIntensity, config.glitchIntensity), 0, 120 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    redGlitch.ZIndex = 9
    redGlitch.Parent = mainFrame
    
    local blueGlitch = titleLabel:Clone()
    blueGlitch.TextColor3 = Color3.fromRGB(0, 0, 255)
    blueGlitch.Position = UDim2.new(0, 10 + math.random(-config.glitchIntensity, config.glitchIntensity), 0, 120 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    blueGlitch.ZIndex = 8
    blueGlitch.Parent = mainFrame
    
    -- MT字母故障效果
    local mtRedGlitch = mtLabel:Clone()
    mtRedGlitch.TextColor3 = Color3.fromRGB(255, 0, 0)
    mtRedGlitch.Position = UDim2.new(0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2), 0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    mtRedGlitch.ZIndex = 9
    mtRedGlitch.Parent = leftBox
    
    local mtBlueGlitch = mtLabel:Clone()
    mtBlueGlitch.TextColor3 = Color3.fromRGB(0, 0, 255)
    mtBlueGlitch.Position = UDim2.new(0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2), 0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    mtBlueGlitch.ZIndex = 8
    mtBlueGlitch.Parent = leftBox
    
    -- 右侧方框文本故障效果
    local rightRedGlitch = rightBoxTextLabel:Clone()
    rightRedGlitch.TextColor3 = Color3.fromRGB(255, 0, 0)
    rightRedGlitch.Position = UDim2.new(0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2), 0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    rightRedGlitch.ZIndex = 9
    rightRedGlitch.Parent = rightBox
    
    local rightBlueGlitch = rightBoxTextLabel:Clone()
    rightBlueGlitch.TextColor3 = Color3.fromRGB(0, 0, 255)
    rightBlueGlitch.Position = UDim2.new(0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2), 0, 5 + math.random(-config.glitchIntensity/2, config.glitchIntensity/2))
    rightBlueGlitch.ZIndex = 8
    rightBlueGlitch.Parent = rightBox
    
    -- 短暂显示后消失
    delay(0.05, function()
        if redGlitch then redGlitch:Destroy() end
        if blueGlitch then blueGlitch:Destroy() end
        if mtRedGlitch then mtRedGlitch:Destroy() end
        if mtBlueGlitch then mtBlueGlitch:Destroy() end
        if rightRedGlitch then rightRedGlitch:Destroy() end
        if rightBlueGlitch then rightBlueGlitch:Destroy() end
    end)
    
    -- 创建随机故障线条（增强版）
    if math.random() > 0.5 then
        for i = 1, math.random(1, 4) do
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, math.random(30, 250), 0, math.random(1, 3))
            line.Position = UDim2.new(0, math.random(10, 300), 0, math.random(10, 430))
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.ZIndex = 11
            line.Parent = mainFrame
            
            delay(0.08 + math.random() * 0.15, function()
                if line then line:Destroy() end
            end)
        end
    end
    
    -- 方框闪烁效果
    if math.random() > 0.7 then
        local originalColor = rightBoxGlow.Color
        rightBoxGlow.Color = Color3.fromRGB(255, 0, 0)
        
        delay(0.1, function()
            if rightBoxGlow then
                rightBoxGlow.Color = originalColor
            end
        end)
    end
    
    -- MT字母闪烁效果
    if math.random() > 0.6 then
        local originalColor = mtGlow.Color
        mtGlow.Color = Color3.fromRGB(255, 0, 0)
        
        delay(0.08, function()
            if mtGlow then
                mtGlow.Color = originalColor
            end
        end)
    end
end

-- 右侧方框高级动画
local function createRightBoxAnimation()
    -- 脉冲动画
    spawn(function()
        while wait(1.5) do
            if rightBoxGlow then
                TweenService:Create(rightBoxGlow, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Transparency = 0.2
                }):Play()
                
                wait(0.5)
                
                TweenService:Create(rightBoxGlow, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Transparency = 0.4
                }):Play()
            end
        end
    end)
    
    -- 文本颜色变化
    spawn(function()
        local hue = 0
        while wait(0.1) do
            hue = (hue + 0.02) % 1
            local color = Color3.fromHSV(hue, 0.7, 1)
            if rightBoxTextGlow then
                rightBoxTextGlow.Color = color
            end
        end
    end)
end

-- 启动故障效果
local glitchActive = true
spawn(function()
    while glitchActive do
        createGlitchEffect()
        wait(config.glitchFrequency)
    end
end)

-- 启动MT字母脉冲效果
createMTPulseEffect()

-- 启动右侧方框动画
createRightBoxAnimation()

-- 复制按钮点击事件
copyBtn.MouseButton1Click:Connect(function()
    TweenService:Create(copyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 220),
        Size = UDim2.new(0, 155, 0, 33)
    }):Play()
    
    task.wait(0.15)
    
    TweenService:Create(copyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 150),
        Size = UDim2.new(0, 160, 0, 35)
    }):Play()
    
    -- 尝试复制群号
    local success = pcall(function()
        setclipboard(config.groupNumber)
    end)
    
    if success then
        copyBtn.Text = "已复制!"
        task.wait(1.5)
        copyBtn.Text = "复制群号"
    else
        copyBtn.Text = "复制失败!"
        task.wait(1.5)
        copyBtn.Text = "复制群号"
    end
end)

-- 确认按钮点击事件
confirmBtn.MouseButton1Click:Connect(function()
    glitchActive = false -- 停止故障效果
    
    TweenService:Create(confirmBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(120, 30, 30),
        Size = UDim2.new(0, 155, 0, 33)
    }):Play()
    
    task.wait(0.15)
    
    TweenService:Create(confirmBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(150, 40, 40),
        Size = UDim2.new(0, 160, 0, 35)
    }):Play()
    
    -- 创建关闭动画
    local fadeInfo = TweenInfo.new(config.animationDuration * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local shrinkInfo = TweenInfo.new(config.animationDuration, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    
    -- 同时淡出所有元素
    TweenService:Create(mainFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(shadow, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(innerGlow, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(confirmStroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(copyStroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(contentLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(explanationLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(confirmBtn, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(copyBtn, fadeInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(redOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(leftBoxGlow, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(rightBoxGlow, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(rightBoxTextLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(rightBoxTextGlow, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(mtLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(mtGlow, fadeInfo, {Transparency = 1}):Play()
    
    -- 缩小主框架
    task.wait(0.2)
    TweenService:Create(mainFrame, shrinkInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    -- 淡出模糊效果
    TweenService:Create(blur, TweenInfo.new(config.animationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 0
    }):Play()
    
    -- 淡出红色滤镜效果
    TweenService:Create(colorCorrection, TweenInfo.new(config.redFilterFadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Saturation = 0, 
        TintColor = Color3.fromRGB(255, 255, 255),
        Brightness = 0,
        Contrast = 0
    }):Play()
    
    -- 等待动画完成后再销毁
    task.wait(config.animationDuration)
    sg:Destroy()
    blur:Destroy()
    colorCorrection:Destroy()
end)

-- 初始动画 - 更流畅的入场效果
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundTransparency = 1
titleLabel.TextTransparency = 1
contentLabel.TextTransparency = 1
explanationLabel.TextTransparency = 1
confirmBtn.BackgroundTransparency = 1
confirmBtn.TextTransparency = 1
copyBtn.BackgroundTransparency = 1
copyBtn.TextTransparency = 1
redOverlay.BackgroundTransparency = 1
leftBox.BackgroundTransparency = 1
rightBox.BackgroundTransparency = 1
rightBoxTextLabel.TextTransparency = 1
mtLabel.TextTransparency = 1
blur.Size = 0
colorCorrection.Saturation = 0 -- 初始状态红色滤镜为0

-- 分阶段动画入场
task.spawn(function()
    -- 第一阶段：淡入红色覆盖和模糊效果
    TweenService:Create(redOverlay, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.85
    }):Play()
    
    TweenService:Create(blur, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = 45
    }):Play()
    
    -- 淡入红色滤镜效果
    TweenService:Create(colorCorrection, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Saturation = config.redFilterIntensity
    }):Play()
    
    task.wait(0.3)
    
    -- 第二阶段：主框架展开
    TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 580, 0, 450),
        Position = UDim2.new(0.5, -290, 0.5, -225),
        BackgroundTransparency = 0.1
    }):Play()
    
    task.wait(0.2)
    
    -- 第三阶段：顶部方框淡入
    TweenService:Create(leftBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2
    }):Play()
    
    TweenService:Create(rightBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.1
    }):Play()
    
    TweenService:Create(mtLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(rightBoxTextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    task.wait(0.1)
    
    -- 第四阶段：内容淡入
    TweenService:Create(titleLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(contentLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(explanationLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(confirmBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(copyBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
end)