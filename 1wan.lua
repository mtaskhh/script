getgenv().AntiAFK = game:GetService("RunService").Heartbeat:Connect(function() 
    if tick() % 3 < 0.1 then 
        pcall(mousemoverel, math.random(-2,2), math.random(-2,2)) 
        pcall(function() game.Players.LocalPlayer:GetMouse() end) 
    end 
end)

game:GetService("StarterGui"):SetCore("SendNotification",{ 
    Title = "挽脚本", 
    Text = "全力加载中喵", 
    Duration = 5 
})

task.spawn(function()
    task.wait(1.5)
    game:GetService("StarterGui"):SetCore("SendNotification",{ 
        Title = "挽脚本", 
        Text = "已开启反反挂机", 
        Duration = 4
    })
end)


local LBLG = Instance.new("ScreenGui")
local LBL = Instance.new("TextLabel")
local player = game.Players.LocalPlayer

LBLG.Name = "LBLG"
LBLG.Parent = game.CoreGui
LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LBLG.Enabled = true

LBL.Name = "LBL"
LBL.Parent = LBLG
LBL.BackgroundColor3 = Color3.new(1, 1, 1)
LBL.BackgroundTransparency = 1
LBL.BorderColor3 = Color3.new(0, 0, 0)
LBL.Position = UDim2.new(0.8, 0, 0.01, 0)
LBL.Size = UDim2.new(0, 150, 0, 20)
LBL.Font = Enum.Font.GothamSemibold
LBL.Text = "时间:加载中..."
LBL.TextColor3 = Color3.new(1, 1, 1)
LBL.TextScaled = false
LBL.TextSize = 14
LBL.TextWrapped = false
LBL.Visible = true

local FpsLabel = LBL
local Heartbeat = game:GetService("RunService").Heartbeat
local LastIteration, Start
local FrameUpdateTable = {}

local function HeartbeatUpdate()
    LastIteration = tick()
    for Index = #FrameUpdateTable, 1, -1 do
        FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
    end
    FrameUpdateTable[1] = LastIteration
    local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
    CurrentFPS = CurrentFPS - CurrentFPS % 1
    FpsLabel.Text = ("北京时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
end
Start = tick()
Heartbeat:Connect(HeartbeatUpdate)

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "挽 Script",
    Icon = "code",
    Author = "by--挽＆MT",
    Folder = "mtaskh",
    Size = UDim2.fromOffset(750, 650),
    Theme = "Dark",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true,
})

Window:CreateTopbarButton("ThemeToggle", "moon", function()
    local currentTheme = WindUI:GetCurrentTheme()
    if currentTheme == "Dark" then
        WindUI:SetTheme("Light")
        WindUI:Notify({
            Title = "已切换为光亮主题",
            Content = "",
            Duration = 3,
            Icon = "geist:sun"
        })
    else
        WindUI:SetTheme("Dark")
        WindUI:Notify({
            Title = "已切换为黑暗主题",
            Content = "",
            Duration = 3,
            Icon = "geist:moon"
        })
    end
end, 990)

WindUI:SetNotificationLower(true)

Window:EditOpenButton({
    Title = "打开挽脚本",
    Icon = "crown",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 3,
    Color = ColorSequence.new(
        Color3.fromHex("000000"), 
        Color3.fromHex("FFFFFF")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--================标签页栏目=================✨⭐🌟✨💫✨🌟⭐🌙

local infoTab = Window:Tab({Title = "信息", Icon = "user", Locked = false})

local DefaultTab = Window:Tab({Title = "公告", Icon = "geist:credit-card", Locked = false})

local firstTab = Window:Tab({Title = "通用类", Icon = "settings", Locked = false})

local thirdTab = Window:Tab({Title = "视觉类", Icon = "eye", Locked = false})

local secondTab = Window:Tab({Title = "自瞄范围类", Icon = "target", Locked = false})

local TeleportTab = Window:Tab({Title = "传送与甩飞", Icon = "lucide:move-3d"})

local serve1 = Window:Tab({Title = "服务器列表1", Icon = "book", Locked = false})

local FETab = Window:Tab({Title = "FE脚本", Icon = "lucide:zap"})

local MusicTab = Window:Tab({Title = "音乐播放器", Icon = "music", Locked = false})

--================信息栏目=================✨⭐🌟✨💫✨🌟⭐🌙

local infoSection = infoTab:Section({Title = "详情", Opened = true})

infoSection:Paragraph({
    Title = "挽脚本",
    Desc = "作者Mtaskh＆挽鹤\n作者qq:1048324261＆3345179204\n脚本还在测试中",
})

infoSection:Paragraph({
    Title = "账号注册时间",
    Desc = tostring(game.Players.LocalPlayer.AccountAge).."天"
})

infoSection:Paragraph({
    Title = "服务器ID", 
    Desc = tostring(game.GameId)
})

infoSection:Paragraph({
    Title = "用户ID",
    Desc = tostring(game.Players.LocalPlayer.UserId)
})

infoSection:Paragraph({
    Title = "客户端ID",
    Desc = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
})

infoSection:Paragraph({
    Title = "注入器",
    Desc = identifyexecutor and identifyexecutor() or "未知"
})

infoSection:Paragraph({
    Title = "用户名",
    Desc = game.Players.LocalPlayer.Name
})

infoSection:Paragraph({
    Title = "服务器名称", 
    Desc = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
})

-- ========== 公告栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

DefaultTab:Paragraph({
    Title = "此脚本为半缝合",
    Desc = "随便做的请勿拿别的半缝合来对比\n感谢支持并使用挽脚本",
    Thumbnail = "rbxassetid://100558513547339",
    ThumbnailSize = 150
})

-- ========== 通用栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local GeneralSection = firstTab:Section({Title = "基础设置", Opened = false})

GeneralSection:Slider({
    Title = "视野FOV",
    Desc = "极小部分服务器无法使用",
    Step = 1,
    Value = {
        Min = 10,
        Max = 220,
        Default = Workspace.CurrentCamera.FieldOfView
    },
    Callback = function(FOV)
        spawn(function() 
            while task.wait() do 
                Workspace.CurrentCamera.FieldOfView = FOV
            end 
        end)
    end
})

GeneralSection:Slider({
    Title = "最大视角缩放距离",
    Desc = "调整后手动缩放",
    Step = 0.5,
    Value = {
        Min = 0.5,
        Max = 1000000,
        Default = 100
    },
    Callback = function(Distance)
        local player = game.Players.LocalPlayer
        if player then
            player.CameraMaxZoomDistance = Distance
            player.CameraMinZoomDistance = 0.5
        end
    end
})

local walkSpeedConnection
GeneralSection:Slider({
    Title = "走路速度",
    Desc = "WalkSpeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
    },
    Callback = function(Speed)
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
        end
        walkSpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.WalkSpeed = Speed
            end
        end)
    end
})

GeneralSection:Slider({
    Title = "跳跃高度",
    Desc = "JumpPower",
    Step = 1,
    Value = {
        Min = 50,
        Max = 2000,
        Default = 50
    },
    Callback = function(Jump)
        local plr = game.Players.LocalPlayer
        
        local function updateJump()
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                humanoid.JumpPower = Jump
                humanoid.JumpHeight = Jump / 7
            end
        end
        
        updateJump()
        
        plr.CharacterAdded:Connect(function(char)
            wait(1)
            if char:FindFirstChildOfClass("Humanoid") then
                updateJump()
            end
        end)
    end
})

GeneralSection:Slider({
    Title = "重力设置",
    Desc = "Gravity",
    Step = 1,
    Value = {
        Min = 1,
        Max = 5000,
        Default = game.Workspace.Gravity
    },
    Callback = function(GravityValue)
        game.Workspace.Gravity = GravityValue
    end
})

local healthSettings = {max = 100, current = 100}

GeneralSection:Slider({
    Title = "最大血量",
    Step = 10,
    Value = {Min = 10, Max = 100000, Default = 100},
    Callback = function(value)
        healthSettings.max = value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.MaxHealth = value end
    end
})

GeneralSection:Slider({
    Title = "当前血量",
    Step = 10,
    Value = {Min = 1, Max = 100000, Default = 100},
    Callback = function(value)
        healthSettings.current = math.min(value, healthSettings.max)
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.Health = healthSettings.current end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = healthSettings.max
        humanoid.Health = healthSettings.current
    end
end)

GeneralSection:Button({
    Title = "FPS显示",
    Desc = "显示FPS计数器",
    Icon = "monitor",
    Callback = function()
        local RunService = game:GetService("RunService")
        local CoreGui = game:GetService("CoreGui")

        
        if CoreGui:FindFirstChild("FPSDisplay") then
            CoreGui.FPSDisplay:Destroy()
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FPSDisplay"
        screenGui.Parent = CoreGui
        screenGui.ResetOnSpawn = false

        local textLabel = Instance.new("TextLabel")
        textLabel.Text = "FPS: 0"
        textLabel.TextSize = 18
        textLabel.Font = Enum.Font.GothamBold
        textLabel.BackgroundTransparency = 1
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.Size = UDim2.new(0, 200, 0, 30)
        textLabel.Position = UDim2.new(0, 10, 0, 10)
        textLabel.AnchorPoint = Vector2.new(0, 0)
        textLabel.ZIndex = 10
        textLabel.Parent = screenGui

        local hue = 0
        local lastUpdate = 0

        RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            
            if currentTime - lastUpdate >= 0.1 then
                local fps = math.floor(1 / RunService.Heartbeat:Wait())
                hue = (hue + 0.05) % 1  
                local color = Color3.fromHSV(hue, 1, 1)
                
                textLabel.Text = "FPS: " .. fps
                textLabel.TextColor3 = color
                lastUpdate = currentTime
            end
        end)
    end
})

GeneralSection:Button({
    Title = "飞车",
    Desc = "加载飞车脚本",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G3GnBCyC", true))()
    end
})

GeneralSection:Button({
    Title = "飞车2", 
    Desc = "加载飞车脚本2",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/vb/main/%E9%A3%9E%E8%BD%A6.lua", true))()
    end
})

GeneralSection:Button({
    Title = "旋转",
    Desc = "加载旋转脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%97%8B%E8%BD%AC.lua", true))()
    end
})

GeneralSection:Toggle({
    Title = "防摔伤",
    Default = true,
    Callback = function(Value)
        if Value then
            local rs = game:GetService("RunService")
            local hb = rs.Heartbeat
            local rsd = rs.RenderStepped
            local lp = game.Players.LocalPlayer
            local z = Vector3.zero
            
            local function f(c)
                local r = c:WaitForChild("HumanoidRootPart")
                if r then
                    local con
                    con = hb:Connect(function()
                        if not r.Parent then
                            con:Disconnect()
                            return
                        end
                        local v = r.AssemblyLinearVelocity
                        r.AssemblyLinearVelocity = z
                        rsd:Wait()
                        r.AssemblyLinearVelocity = v
                    end)
                end
            end
            
            f(lp.Character)
            lp.CharacterAdded:Connect(f)
        end
    end
})

local ToolSection = firstTab:Section({Title = "工具功能", Opened = false})

ToolSection:Button({
    Title = "玩家加入游戏提示",
    Desc = "显示玩家加入提示",
    Icon = "user-plus",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua'))()
    end
})

ToolSection:Button({
    Title = "飞行",
    Desc = "fly Script",
    Icon = "user",
    Callback = function()
        -- 声明局部变量
        local speeds = 1
        local nowe = false
        local tpwalking = false
        
        local main = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local up = Instance.new("TextButton")
        local down = Instance.new("TextButton")
        local onof = Instance.new("TextButton")
        local TextLabel = Instance.new("TextLabel")
        local plus = Instance.new("TextButton")
        local speed = Instance.new("TextLabel")
        local mine = Instance.new("TextButton")
        local closebutton = Instance.new("TextButton")
        local mini = Instance.new("TextButton")
        local mini2 = Instance.new("TextButton")

        main.Name = "main"
        main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        main.ResetOnSpawn = false

        Frame.Parent = main
        Frame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Frame.BorderColor3 = Color3.fromRGB(150, 150, 150)
        Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
        Frame.Size = UDim2.new(0, 190, 0, 57)

        up.Name = "up"
        up.Parent = Frame
        up.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        up.Size = UDim2.new(0, 44, 0, 28)
        up.Font = Enum.Font.SourceSans
        up.Text = "上升"
        up.TextColor3 = Color3.fromRGB(0, 0, 0)
        up.TextSize = 14.000

        down.Name = "down"
        down.Parent = Frame
        down.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        down.Position = UDim2.new(0, 0, 0.491228074, 0)
        down.Size = UDim2.new(0, 44, 0, 28)
        down.Font = Enum.Font.SourceSans
        down.Text = "下降"
        down.TextColor3 = Color3.fromRGB(0, 0, 0)
        down.TextSize = 14.000

        onof.Name = "onof"
        onof.Parent = Frame
        onof.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
        onof.Size = UDim2.new(0, 56, 0, 28)
        onof.Font = Enum.Font.SourceSans
        onof.Text = "飞行"
        onof.TextColor3 = Color3.fromRGB(0, 0, 0)
        onof.TextSize = 14.000

        TextLabel.Parent = Frame
        TextLabel.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
        TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 100, 0, 28)
        TextLabel.Font = Enum.Font.SourceSans
        TextLabel.Text = "MT FLY"
        TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 14.000
        TextLabel.TextWrapped = true

        plus.Name = "plus"
        plus.Parent = Frame
        plus.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        plus.Position = UDim2.new(0.231578946, 0, 0, 0)
        plus.Size = UDim2.new(0, 45, 0, 28)
        plus.Font = Enum.Font.SourceSans
        plus.Text = "+"
        plus.TextColor3 = Color3.fromRGB(0, 0, 0)
        plus.TextScaled = true
        plus.TextSize = 14.000
        plus.TextWrapped = true

        speed.Name = "speed"
        speed.Parent = Frame
        speed.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
        speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
        speed.Size = UDim2.new(0, 44, 0, 28)
        speed.Font = Enum.Font.SourceSans
        speed.Text = "1"
        speed.TextColor3 = Color3.fromRGB(0, 0, 0)
        speed.TextScaled = true
        speed.TextSize = 14.000
        speed.TextWrapped = true

        mine.Name = "mine"
        mine.Parent = Frame
        mine.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
        mine.Size = UDim2.new(0, 45, 0, 29)
        mine.Font = Enum.Font.SourceSans
        mine.Text = "-"
        mine.TextColor3 = Color3.fromRGB(0, 0, 0)
        mine.TextScaled = true
        mine.TextSize = 14.000
        mine.TextWrapped = true

        closebutton.Name = "Close"
        closebutton.Parent = Frame  -- 改为 Frame 的子级
        closebutton.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        closebutton.Font = "SourceSans"
        closebutton.Size = UDim2.new(0, 20, 0, 20)
        closebutton.Text = "X"
        closebutton.TextSize = 14
        closebutton.Position = UDim2.new(1, -20, 0, 0)

        mini.Name = "minimize"
        mini.Parent = Frame  -- 改为 Frame 的子级
        mini.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        mini.Font = "SourceSans"
        mini.Size = UDim2.new(0, 20, 0, 20)
        mini.Text = "-"
        mini.TextSize = 14
        mini.Position = UDim2.new(1, -40, 0, 0)

        mini2.Name = "minimize2"
        mini2.Parent = Frame  -- 改为 Frame 的子级
        mini2.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        mini2.Font = "SourceSans"
        mini2.Size = UDim2.new(0, 20, 0, 20)
        mini2.Text = "+"
        mini2.TextSize = 14
        mini2.Position = UDim2.new(1, -40, 0, 0)
        mini2.Visible = false

        local speaker = game:GetService("Players").LocalPlayer

        -- 修复通知语法
        game:GetService("StarterGui"):SetCore("SendNotification", { 
            Title = "MT FLY V3",
            Text = "BY MT",
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
            Duration = 5
        })

        Frame.Active = true
        Frame.Draggable = true

        -- 保持原有的飞行功能代码...
        onof.MouseButton1Down:connect(function()
            if nowe == true then
                nowe = false
                -- ... 原有代码
            else 
                nowe = true
                -- ... 原有代码
            end
            -- ... 其余飞行代码
        end)

        -- 保持原有的按钮功能代码...
        up.MouseButton1Down:connect(function()
            -- ... 原有代码
        end)

        down.MouseButton1Down:connect(function()
            -- ... 原有代码
        end)

        plus.MouseButton1Down:connect(function()
            -- ... 原有代码
        end)

        mine.MouseButton1Down:connect(function()
            -- ... 原有代码
        end)

        -- 修复关闭和最小化功能
        closebutton.MouseButton1Click:Connect(function()
            main:Destroy()
        end)

        mini.MouseButton1Click:Connect(function()
            up.Visible = false
            down.Visible = false
            onof.Visible = false
            plus.Visible = false
            speed.Visible = false
            mine.Visible = false
            mini.Visible = false
            mini2.Visible = true
            Frame.BackgroundTransparency = 1
            TextLabel.Visible = false
        end)

        mini2.MouseButton1Click:Connect(function()
            up.Visible = true
            down.Visible = true
            onof.Visible = true
            plus.Visible = true
            speed.Visible = true
            mine.Visible = true
            mini.Visible = true
            mini2.Visible = false
            Frame.BackgroundTransparency = 0
            TextLabel.Visible = true
        end)
    end
})

ToolSection:Button({
    Title = "紫砂",
    Desc = "重置本地玩家",
    Icon = "geist:user",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

ToolSection:Button({
    Title = "死亡笔记",
    Desc = "死亡笔记功能",
    Icon = "book",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))()
    end
})

ToolSection:Button({
    Title = "汉化穿墙",
    Desc = "穿墙功能",
    Icon = "move",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))()
    end
})

ToolSection:Button({
    Title = "飞檐走壁",
    Desc = "无法取消效果",
    Icon = "geist:bug",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

local autoInteract = false
local autoInteractConnection
ToolSection:Toggle({
    Title = "自动互动",
    Desc = "Auto Interact",
    Default = false,
    Callback = function(state)
        autoInteract = state
        if state then
            autoInteractConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not autoInteract then
                    autoInteractConnection:Disconnect()
                    return
                end
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
            end)
        else
            if autoInteractConnection then
                autoInteractConnection:Disconnect()
            end
        end
    end
})

ToolSection:Button({
    Title = "工具挂",
    Desc = "加载工具挂脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua", true))()
    end
})

ToolSection:Button({
    Title = "点击传送工具",
    Desc = "生成点击传送工具",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "MT点击传送"
        tool.Activated:Connect(function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
            end
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

ToolSection:Button({
    Title = "电脑键盘",
    Desc = "加载虚拟键盘功能",
    Icon = "keyboard",
    Callback = function()
        WindUI:Notify({
            Title = "正在加载",
            Content = "加载虚拟键盘中...",
            Duration = 1,
            Icon = "download"
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
        end)
        
        if success then
            WindUI:Notify({
                Title = "加载成功",
                Content = "虚拟键盘已加载完成",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "虚拟键盘加载失败: " .. tostring(err),
                Duration = 5,
                Icon = "alert-circle"
            })
        end
    end
})

local godModeEnabled = false
local connection = nil

ToolSection:Toggle({
    Title = "无敌模式(无限回血)",
    Desc = "反作弊差的服务器有效",
    Default = false,
    Callback = function(state)
        godModeEnabled = state
        
        if connection then
            connection:Disconnect()
        end
        
        if state then
            local lastUpdate = 0
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not godModeEnabled then
                    connection:Disconnect()
                    return
                end
                
                if tick() - lastUpdate >= 0.1 then
                    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = math.huge
                        humanoid.MaxHealth = math.huge
                    end
                    lastUpdate = tick()
                end
            end)
        end
    end
})

local airWalkEnabled = false
local bodyPositionInstance = nil

ToolSection:Toggle({
    Title = "空中行走",
    Desc = "固定Y轴位置，不会掉落",
    Default = false,
    Callback = function(state)
        airWalkEnabled = state
        
        if state then
            
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                bodyPositionInstance = Instance.new("BodyPosition")
                bodyPositionInstance.Position = Vector3.new(0, hrp.Position.Y, 0)
                bodyPositionInstance.MaxForce = Vector3.new(0, 40000, 0)
                bodyPositionInstance.P = 10000
                bodyPositionInstance.Parent = hrp
                
                game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
                    wait(1)
                    if airWalkEnabled and newChar:FindFirstChild("HumanoidRootPart") then
                        bodyPositionInstance = Instance.new("BodyPosition")
                        bodyPositionInstance.Position = Vector3.new(0, newChar.HumanoidRootPart.Position.Y, 0)
                        bodyPositionInstance.MaxForce = Vector3.new(0, 40000, 0)
                        bodyPositionInstance.Parent = newChar.HumanoidRootPart
                    end
                end)
            end
            WindUI:Notify({Title = "空中行走已启用", Content = "Y轴位置已固定", Duration = 2})
        else
            if bodyPositionInstance then
                bodyPositionInstance:Destroy()
                bodyPositionInstance = nil
            end
            WindUI:Notify({Title = "空中行走已禁用", Content = "可以正常掉落", Duration = 2})
        end
    end
})

local infiniteJump = false
ToolSection:Toggle({
    Title = "无限跳",
    Desc = "Toggle",
    Default = false,
    Callback = function(Value)
        infiniteJump = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJump and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- ========== 视觉栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local ESPSettingsSection = thirdTab:Section({Title = "ESP设置", Opened = false}) 

ESPSettingsSection:Toggle({
    Title = "显示追踪线",
    Desc = "启用/禁用追踪线",
    Default = true,
    Callback = function(Value)
        if ESPElements then
            for _, espElement in pairs(ESPElements) do
                if espElement and not espElement.Deleted and espElement.CurrentSettings and espElement.CurrentSettings.Tracer then
                    espElement.CurrentSettings.Tracer.Enabled = Value
                end
            end
        end
    end
})

ESPSettingsSection:Toggle({
    Title = "显示箭头",
    Desc = "启用/禁用方向箭头",
    Default = true,
    Callback = function(Value)
        if ESPElements then
            for _, espElement in pairs(ESPElements) do
                if espElement and not espElement.Deleted and espElement.CurrentSettings and espElement.CurrentSettings.Arrow then
                    espElement.CurrentSettings.Arrow.Enabled = Value
                end
            end
        end
    end
})

ESPSettingsSection:Slider({
    Title = "显示距离",
    Desc = "ESP最大显示距离",
    Step = 100,
    Value = {
        Min = 500,
        Max = 50000, 
        Default = 2000
    },
    Callback = function(Value)
        if ESPElements then
            for _, espElement in pairs(ESPElements) do
                if espElement and not espElement.Deleted and espElement.CurrentSettings then
                    espElement.CurrentSettings.MaxDistance = Value
                end
            end
        end
    end
})

ESPSettingsSection:Slider({
    Title = "填充透明度",
    Desc = "ESP填充透明度",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.3
    },
    Callback = function(Value)
        if ESPElements then
            for _, espElement in pairs(ESPElements) do
                if espElement and not espElement.Deleted and espElement.CurrentSettings then
                    espElement.CurrentSettings.FillTransparency = Value
                end
            end
        end
    end
})

local ESPEnabled = false
local ESPElements = {}

local function enableAdvancedESP()
    ESPEnabled = true
    local Players = game:GetService("Players")
    
    local function setupPlayerESP(player)
        if player == Players.LocalPlayer then return end
        
        local randomColor = Color3.new(
            math.random(),
            math.random(), 
            math.random()
        )
        
        local function onCharacterAdded(character)
            if not ESPEnabled then return end
            
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
            if not humanoidRootPart then return end
            
            if ESPElements[player] and not ESPElements[player].Deleted then
                ESPElements[player]:Destroy()
            end
            
            local espElement = ESPLibrary:Add({
                Name = player.Name,
                Model = character,
                Color = randomColor,
                MaxDistance = 2000,
                TextSize = 14,
                ESPType = "Highlight",
                FillColor = randomColor,
                OutlineColor = Color3.new(1, 1, 1),
                FillTransparency = 0.3,
                OutlineTransparency = 0,
                Tracer = {
                    Enabled = true,
                    Color = randomColor,
                    Thickness = 1,
                    Transparency = 0,
                    From = "Bottom"
                },
                Arrow = {
                    Enabled = true,
                    Color = randomColor,
                    Size = 15,
                    Transparency = 0
                }
            })
            
            ESPElements[player] = espElement
        end
        
        if player.Character then
            onCharacterAdded(player.Character)
        end
        
        player.CharacterAdded:Connect(onCharacterAdded)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        setupPlayerESP(player)
    end
    
    Players.PlayerAdded:Connect(setupPlayerESP)
    
    WindUI:Notify({
        Title = "esp已启用",
        Content = "使用ESP库的增强透视功能",
        Duration = 3,
        Icon = "eye"
    })
end

local function disableAdvancedESP()
    ESPEnabled = false
    
    for player, espElement in pairs(ESPElements) do
        if espElement and not espElement.Deleted then
            espElement:Destroy()
        end
    end
    ESPElements = {}
    
    ESPLibrary:Clear()
    
    WindUI:Notify({
        Title = "esp透视已禁用", 
        Content = "所有ESP元素已清除",
        Duration = 3,
        Icon = "eye-off"
    })
end

local VisualSection = thirdTab:Section({Title = "视觉功能", Opened = false})

VisualSection:Toggle({
    Title = "esp透视",
    Desc = "执行后刚开始可能卡顿",
    Default = false,
    Callback = function(state)
        if state then
            enableAdvancedESP()
        else
            disableAdvancedESP()
        end
    end
})

VisualSection:Button({
    Title = "基础透视",
    Desc = "使用Highlight的基础透视",
    Icon = "eye",
    Callback = function()
        _G.FriendColor = Color3.fromRGB(0, 0, 255)
        local function ApplyESP(v)
            if v.Character and v.Character:FindFirstChildOfClass('Humanoid') then
                v.Character.Humanoid.NameDisplayDistance = 9e9
                v.Character.Humanoid.NameOcclusion = "NoOcclusion"
                v.Character.Humanoid.HealthDisplayDistance = 9e9
                v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
            end
        end
        
        for i,v in pairs(game.Players:GetPlayers()) do
            ApplyESP(v)
            v.CharacterAdded:Connect(function()
                task.wait(0.33)
                ApplyESP(v)
            end)
        end
        
        game.Players.PlayerAdded:Connect(function(v)
            ApplyESP(v)
            v.CharacterAdded:Connect(function()
                task.wait(0.33)
                ApplyESP(v)
            end)
        end)
        
        local Players = game:GetService("Players"):GetChildren()
        local RunService = game:GetService("RunService")
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        for i, v in pairs(Players) do
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                    local highlightClone = highlight:Clone()
                    highlightClone.Adornee = v.Character
                    highlightClone.Parent = v.Character.HumanoidRootPart
                    highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end
        
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if character and character:FindFirstChild("HumanoidRootPart") then
                    if not character.HumanoidRootPart:FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = character
                        highlightClone.Parent = character.HumanoidRootPart
                        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end)
        end)
        
        game.Players.PlayerRemoving:Connect(function(playerRemoved)
            if playerRemoved.Character and playerRemoved.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = playerRemoved.Character.HumanoidRootPart:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end)
    end
})

VisualSection:Toggle({
    Title = "夜视",
    Desc = "Toggle",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

local guangyingSection = thirdTab:Section({Title = "光影效果", Opened = false})

guangyingSection:Button({
    Title = "光影",
    Desc = "加载光影效果",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

guangyingSection:Button({
    Title = "光影滤镜",
    Desc = "加载光影滤镜效果", 
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

guangyingSection:Button({
    Title = "超高画质",
    Desc = "加载超高画质效果",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
    end
})

guangyingSection:Button({
    Title = "光影V4",
    Desc = "加载光影V4效果",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

guangyingSection:Button({
    Title = "RTX高仿",
    Desc = "加载RTX高仿效果",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/Bkf0BJb3'))()
    end
})

guangyingSection:Button({
    Title = "光影深",
    Desc = "加载深色光影效果",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

guangyingSection:Button({
    Title = "光影浅",
    Desc = "加载浅色光影效果", 
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
    end
})

-- ========== 自瞄范围栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local function clearAllRanges()
    for i, obj in pairs(Workspace:GetChildren()) do
        if obj:FindFirstChild("SquareAttackRangeESP") then
            obj.SquareAttackRangeESP:Destroy()
        end
        if obj:FindFirstChild("AttackRangeESP") then
            obj.AttackRangeESP:Destroy()
        end
    end
    for _, connection in pairs(rangeConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    rangeConnections = {}
end

local function createRangeESP(character, rangeType)
    if not character or not character.Parent then return end
    
    local partName = rangeType == "square" and "SquareAttackRangeESP" or "AttackRangeESP"
    local shape = rangeType == "square" and Enum.PartType.Block or Enum.PartType.Ball
    
    if character:FindFirstChild(partName) then
        character[partName]:Destroy()
    end
    
    local rangePart = Instance.new("Part")
    rangePart.Name = partName
    rangePart.Shape = shape
    rangePart.Size = Vector3.new(10, 10, 10)
    rangePart.Transparency = 0.7
    rangePart.Color = _G.CurrentRangeColor
    rangePart.Material = Enum.Material.Neon
    rangePart.Anchored = true
    rangePart.CanCollide = false
    rangePart.Parent = character
    
    local connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not character or not character.Parent or not character:FindFirstChild("HumanoidRootPart") then
            if connection then
                connection:Disconnect()
            end
            if rangePart then
                rangePart:Destroy()
            end
            return
        end
        local hrp = character.HumanoidRootPart
        rangePart.Position = hrp.Position
    end)
    
    table.insert(rangeConnections, connection)
end

local AttackRangeSection = secondTab:Section({Title = "攻击范围", Opened = false})

AttackRangeSection:Toggle({
    Title = "立体",
    Desc = "SquareAttackRangeToggle",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.CurrentRangeType = "square"
            clearAllRanges()
            
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    createRangeESP(player.Character, "square")
                end
            end
        else
            if _G.CurrentRangeType == "square" then
                _G.CurrentRangeType = nil
            end
            clearAllRanges()
        end
    end
})

AttackRangeSection:Toggle({
    Title = "圆形",
    Desc = "AttackRange",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.CurrentRangeType = "circle"
            clearAllRanges()
            
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    createRangeESP(player.Character, "circle")
                end
            end
        else
            if _G.CurrentRangeType == "circle" then
                _G.CurrentRangeType = nil
            end
            clearAllRanges()
        end
    end
})

AttackRangeSection:Slider({
    Title = "范围大小",
    Desc = "RangeSize",
    Step = 1,
    Value = {
        Min = 1,
        Max = 200,
        Default = 10
    },
    Callback = function(Size)
        if _G.CurrentRangeType then
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local partName = _G.CurrentRangeType == "square" and "SquareAttackRangeESP" or "AttackRangeESP"
                    local rangePart = player.Character:FindFirstChild(partName)
                    if rangePart then
                        rangePart.Size = Vector3.new(Size, Size, Size)
                    end
                end
            end
        end
    end
})

AttackRangeSection:Slider({
    Title = "范围透明度",
    Desc = "RangeTransparency",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 30
    },
    Callback = function(Transparency)
        if _G.CurrentRangeType then
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local partName = _G.CurrentRangeType == "square" and "SquareAttackRangeESP" or "AttackRangeESP"
                    local rangePart = player.Character:FindFirstChild(partName)
                    if rangePart then
                        rangePart.Transparency = Transparency / 100
                    end
                end
            end
        end
    end
})

local function updateRangeColor(color)
    _G.CurrentRangeColor = color
    if _G.CurrentRangeType then
        for i, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local partName = _G.CurrentRangeType == "square" and "SquareAttackRangeESP" or "AttackRangeESP"
                local rangePart = player.Character:FindFirstChild(partName)
                if rangePart then
                    rangePart.Color = color
                end
            end
        end
    end
end

local colors = {
    {name = "红色", color = Color3.fromRGB(255, 0, 0)},
    {name = "绿色", color = Color3.fromRGB(0, 255, 0)},
    {name = "蓝色", color = Color3.fromRGB(0, 0, 255)},
    {name = "黄色", color = Color3.fromRGB(255, 255, 0)},
    {name = "紫色", color = Color3.fromRGB(255, 0, 255)},
    {name = "白色", color = Color3.fromRGB(255, 255, 255)}
}

local ColorSection = secondTab:Section({Title = "范围颜色", Opened = false})

for _, colorInfo in pairs(colors) do
    ColorSection:Button({
        Title = colorInfo.name,
        Desc = "设置" .. colorInfo.name .. "范围",
        Callback = function()
            updateRangeColor(colorInfo.color)
        end
    })
end

local QuickSection = secondTab:Section({Title = "快速调整", Opened = false})

local quickSizes = {
    {name = "普通范围", size = 10, desc = "设置10x10范围"},
    {name = "中等范围", size = 30, desc = "设置30x30范围"},
    {name = "远程范围", size = 50, desc = "设置50x50范围"}
}

for _, sizeInfo in pairs(quickSizes) do
    QuickSection:Button({
        Title = sizeInfo.name,
        Desc = sizeInfo.desc,
        Callback = function()
            if _G.CurrentRangeType then
                for i, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local partName = _G.CurrentRangeType == "square" and "SquareAttackRangeESP" or "AttackRangeESP"
                        local rangePart = player.Character:FindFirstChild(partName)
                        if rangePart then
                            rangePart.Size = Vector3.new(sizeInfo.size, sizeInfo.size, sizeInfo.size)
                        end
                    end
                end
            end
        end
    })
end

-- ========== 传送甩飞栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local PlayerSection = TeleportTab:Section({Title = "玩家选择", Opened = false})

local selectedPlayer = nil
local playerList = {}

local function refreshPlayers()
    playerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end

refreshPlayers()

local PlayerDropdown = PlayerSection:Dropdown({
    Title = "选择玩家",
    Values = playerList,
    Value = "",
    Callback = function(selected)
        selectedPlayer = game.Players:FindFirstChild(selected)
    end
})

PlayerSection:Button({
    Title = "刷新玩家列表",
    Callback = function()
        refreshPlayers()
        PlayerDropdown:Refresh(playerList)
    end
})

PlayerSection:Button({
    Title = "查看玩家",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character then
            game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

PlayerSection:Button({
    Title = "停止查看",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character then
            game.Workspace.CurrentCamera.CameraSubject = localPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

PlayerSection:Button({
    Title = "甩飞该玩家",
    Desc = "高级旋转甩飞 - 强力效果",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character then
            local targetChar = selectedPlayer.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHead = targetChar:FindFirstChild("Head")
            local localChar = game.Players.LocalPlayer.Character
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and localRoot then
                local OriginalPos = localRoot.CFrame
                
                local targetPart = targetHead or targetRoot

                local BV = Instance.new("BodyVelocity")
                BV.Name = "EpixVel"
                BV.Parent = localRoot
                BV.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                
                local humanoid = localChar:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                end
                
                local rotationSpeed = 1000
                local rotationTime = 3.0
                local startTime = tick()
                local angle = 0
                
                local rotationConnection
                rotationConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if tick() - startTime > rotationTime then
                        rotationConnection:Disconnect()
                        BV:Destroy()

                        if humanoid then
                            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                        end
                        
                        localRoot.CFrame = OriginalPos
                        return
                    end
                    
                    local currentTime = tick() - startTime
                    angle = angle + rotationSpeed
                    
                    local positions = {
                        Vector3.new(math.cos(math.rad(angle)) * 3, 1.5, math.sin(math.rad(angle)) * 3),
                        Vector3.new(math.sin(math.rad(angle)) * 2.5, -1.5, math.cos(math.rad(angle)) * 2.5),
                        Vector3.new(math.cos(math.rad(angle + 120)) * 2, 2, math.sin(math.rad(angle + 120)) * 2),
                        Vector3.new(math.sin(math.rad(angle + 240)) * 3, -2, math.cos(math.rad(angle + 240)) * 3)
                    }
                    
                    local posIndex = math.floor(currentTime * 8) % 4 + 1
                    local offset = positions[posIndex]
                   
                    localRoot.CFrame = CFrame.new(targetPart.Position + offset)
                   
                    targetRoot.AssemblyLinearVelocity = Vector3.new(
                        math.random(-400, 400),
                        math.random(300, 800), 
                        math.random(-400, 400)
                    )
                    
                    targetRoot.AssemblyAngularVelocity = Vector3.new(
                        math.random(-100, 100),
                        math.random(-100, 100),
                        math.random(-100, 100)
                    )
                    
                    localRoot.AssemblyAngularVelocity = Vector3.new(
                        math.random(-200, 200),
                        math.random(-200, 200),
                        math.random(-200, 200)
                    )
                    
                    if math.random(1, 3) == 1 then
                        BV.Velocity = Vector3.new(
                            math.random(-9e7, 9e7),
                            math.random(9e7, 9e7 * 15),
                            math.random(-9e7, 9e7)
                        )
                    end
                end)
                
                spawn(function()
                    wait(rotationTime + 0.5)
                    if BV and BV.Parent then
                        BV:Destroy()
                    end
                    if rotationConnection then
                        rotationConnection:Disconnect()
                    end
                    if humanoid then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    end
                    localRoot.CFrame = OriginalPos
                    localRoot.Velocity = Vector3.new(0, 0, 0)
                    localRoot.RotVelocity = Vector3.new(0, 0, 0)
                end)
                
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "目标玩家缺少必要部件！",
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "错误",
                Content = "请先选择玩家！",
                Duration = 3
            })
        end
    end
})

local TeleportSection = TeleportTab:Section({Title = "传送功能", Opened = false})

TeleportSection:Button({
    Title = "传送到玩家旁边",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character then
            local targetPos = selectedPlayer.Character:FindFirstChild("HumanoidRootPart").Position
            game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
        end
    end
})

local LockTPToggle = TeleportSection:Toggle({
    Title = "锁定传送",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not selectedPlayer or not selectedPlayer.Character then
                    connection:Disconnect()
                    return
                end
                local targetPos = selectedPlayer.Character:FindFirstChild("HumanoidRootPart").Position
                game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
            end)
        end
    end
})

TeleportSection:Button({
    Title = "把玩家传送过来",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character then
            local myChar = game.Players.LocalPlayer.Character
            if myChar then
                local myPos = myChar:FindFirstChild("HumanoidRootPart").Position
                selectedPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
            end
        end
    end
})

local LoopTPToggle = TeleportSection:Toggle({
    Title = "循环把玩家传送过来",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not selectedPlayer or not selectedPlayer.Character then
                    connection:Disconnect()
                    return
                end
                local myChar = game.Players.LocalPlayer.Character
                if myChar then
                    local myPos = myChar:FindFirstChild("HumanoidRootPart").Position
                    selectedPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
                end
            end)
        end
    end
})

local AttractSection = TeleportTab:Section({Title = "吸附功能", Opened = false})

local AttractToggle = AttractSection:Toggle({
    Title = "吸附所有人",
    Default = false,
    Callback = function(state)
        if state then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                local myChar = game.Players.LocalPlayer.Character
                if myChar then
                    local myPos = myChar:FindFirstChild("HumanoidRootPart").Position
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            player.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
                        end
                    end
                end
            end)
        end
    end
})

local ThrowSection = TeleportTab:Section({Title = "甩飞", Opened = false})

ThrowSection:Button({
    Title = "甩飞所有人",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

local PositionSection = TeleportTab:Section({Title = "传送玩家前后方", Opened = false})

local FrontDistance = 5
local FrontSlider = PositionSection:Slider({
    Title = "传送至玩家前方距离",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 5,
    },
    Callback = function(value)
        FrontDistance = value
    end
})

local FrontToggle = PositionSection:Toggle({
    Title = "循环传送至玩家前方",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not selectedPlayer or not selectedPlayer.Character then
                    connection:Disconnect()
                    return
                end
                local targetCF = selectedPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
                local frontPos = targetCF.Position + targetCF.LookVector * FrontDistance
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(frontPos)
                end
            end)
        end
    end
})

local HeadDistance = 5
local HeadSlider = PositionSection:Slider({
    Title = "传送至玩家头顶距离",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 5,
    },
    Callback = function(value)
        HeadDistance = value
    end
})

local HeadToggle = PositionSection:Toggle({
    Title = "循环传送至玩家头顶",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not selectedPlayer or not selectedPlayer.Character then
                    connection:Disconnect()
                    return
                end
                local targetPos = selectedPlayer.Character:FindFirstChild("HumanoidRootPart").Position
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(targetPos.X, targetPos.Y + HeadDistance, targetPos.Z)
                end
            end)
        end
    end
})

local BackDistance = 5
local BackSlider = PositionSection:Slider({
    Title = "传送至玩家后面距离",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 5,
    },
    Callback = function(value)
        BackDistance = value
    end
})

local BackToggle = PositionSection:Toggle({
    Title = "循环传送至玩家后面",
    Default = false,
    Callback = function(state)
        if state and selectedPlayer then
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not selectedPlayer or not selectedPlayer.Character then
                    connection:Disconnect()
                    return
                end
                local targetCF = selectedPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
                local backPos = targetCF.Position - targetCF.LookVector * BackDistance
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(backPos)
                end
            end)
        end
    end
})

-- ========== 服务器列表1栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local CheeseSection = serve1:Section({Title = "奶酪逃生", Opened = false})

CheeseSection:Button({
    Title = "奶酪逃生脚本",
    Desc = "by--Mtaskh",
    Icon = "geist:box",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/mtaskhh/script/raw/refs/heads/main/nlts%20(1).lua"))()
    end
})

local KanshuSection = serve1:Section({Title = "砍伐树木", Opened = false})

KanshuSection:Button({
    Title = "砍伐树木脚本",
    Desc = "by--Mtaskh", 
    Icon = "shift",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/mt/kfsm"))()
    end
})

local shamoSection = serve1:Section({Title = "沙漠探测器", Opened = false})

shamoSection:Button({
    Title = "沙漠探测器",
    Desc = "by--Mtaskh",
    Icon = "geist:rss",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/mtaskhh/script/refs/heads/main/smtc.lua"))()
    end
})

local zhishangSection = serve1:Section({Title = "智商测试", Opened = false})

zhishangSection:Button({
    Title = "智商测试获取最大IQ",
    Desc = "获取后手动跳转到200层即可",
    Icon = "geist:robot",
    Callback = function()
        for i = 1, 200 do
    local args = {
        [1] = i
    }
    game:GetService("ReplicatedStorage").RemoteEvents.ChangeIQ:FireServer(unpack(args))
end
    end
})

-- ========== FE栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local FESection = FETab:Section({Title = "FE脚本集", Opened = true})

FESection:Button({
    Title = "FE C00lgui",
    Callback = function()
        loadstring(game:GetObjects("rbxassetid://8127297852")[1].Source)()
    end
})

FESection:Button({
    Title = "FE 1x1x1x1", 
    Callback = function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/JipYNCht'),true))()
    end
})

FESection:Button({
    Title = "FE大长腿",
    Callback = function()
        loadstring(game:HttpGet('https://gist.githubusercontent.com/1BlueCat/7291747e9f093555573e027621f08d6e/raw/23b48f2463942befe19d81aa8a06e3222996242c/FE%2520Da%2520Feets'))()
    end
})

FESection:Button({
    Title = "FE用头",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/BK4Q0DfU"))()
    end
})

FESection:Button({
    Title = "复仇者",
    Callback = function()
        loadstring(game:HttpGet(('https://pastefy.ga/iGyVaTvs/raw'),true))()
    end
})

FESection:Button({
    Title = "鼠标",
    Callback = function()
        loadstring(game:HttpGet(('https://pastefy.ga/V75mqzaz/raw'),true))()
    end
})

FESection:Button({
    Title = "变怪物",
    Callback = function()
        loadstring(game:HttpGetAsync("https://pastebin.com/raw/jfryBKds"))()
    end
})

FESection:Button({
    Title = "香蕉枪",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNeRD0/Doors-Hack/main/BananaGunByNerd.lua"))()
    end
})

FESection:Button({
    Title = "超长机巴",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ESWSFND7", true))()
    end
})

FESection:Button({
    Title = "操人",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoYunCN/UWU/main/AHAJAJAKAK/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A/A.LUA", true))()
    end
})

FESection:Button({
    Title = "FE动画中心",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui", true))()
    end
})

FESection:Button({
    Title = "FE变玩家",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/XR4sGcgJ"))()
    end
})

FESection:Button({
    Title = "FE猫娘R63",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Tescalus/Pendulum-Hubs-Source/main/Pendulum%20Hub%20V5.lua"))()
    end
})

FESection:Button({
    Title = "FE脚本",
    Callback = function()
        loadstring(game:HttpGet('https://pastefy.ga/a7RTi4un/raw'))()
    end
})

-- ========== 音乐播放器栏目 ==========✨⭐🌟✨💫✨🌟⭐🌙

local MusicSection = MusicTab:Section({Title = "音乐控制", Opened = false})

local currentSound = nil
local isPlaying = false

-- 音乐库
local musicLibrary = {
    -- Doors 相关
    ["Ambush音效"] = 10722835168,
    ["Rush音效"] = 10803213909,
    ["Seek音效"] = 10642752409,
    ["绿脸音效"] = 9113115842,
    ["TheHunt倒计时结束"] = 16695021133,
    ["TheHunt倒计时开始"] = 16695384009,
    ["结束追杀音效"] = 16695425474,
    ["获取金币音效"] = 8646410774,
    
    -- Evade/Nextbot 相关
    ["Bad to the Bone"] = 6965169740,
    ["钢管落地(大声)"] = 6729922069,
    ["Grand Dad音效"] = 848785973,
    ["Taco Bell音效"] = 5523122402,
    ["Cloaker音效"] = 231777931,
    ["You Are An Idiot"] = 2665943889,
    
    -- CS:GO 相关
    ["T阵营胜利音乐"] = 1420383375,
    ["C4倒计时"] = 4873271533,
    ["C4爆炸"] = 4854660190,
    ["闪光弹爆炸"] = 9114799182,
    ["C4被拆除"] = 9117341652,
    ["安放C4"] = 4915042781,
    ["手雷扔出"] = 5124872763,
    
    -- 经典MEME/网络热梗
    ["Ouch!"] = 12222058,
    ["通用Meme音效"] = 5257196749,
    ["Nope Meme"] = 6346074926,
    ["粗口"] = 7334239757,
    ["窜稀音效"] = 4809574295,
    ["苹果手机闹钟"] = 4203251375,
    ["Windows错误提示音"] = 2661731024,
    ["OMG~"] = 336771379,
    
    -- 环境与动作音效
    ["钢管落地"] = 6011094380,
    ["核弹爆炸"] = 421256280,
    ["核弹爆炸倒计时"] = 6456981311,
    ["警报声"] = 675587093,
    ["警报声(另一种)"] = 4988826279,
    ["Minecraft门关闭"] = 180090455,
    ["Minecraft受伤音效"] = 6361963422,
    ["Minecraft吃东西"] = 6748255118,
    
    -- 音乐曲目
    ["Lo-fi Chill音乐"] = 9043887091,
    ["Clair De Lune (月光)"] = 1838457617,
    ["投弹兵进行曲"] = 1840172845,
    ["《起风了》"] = 7548510678,
    ["《海阔天空》"] = 3875049052,
    ["《光辉岁月》"] = 6116888743,
    ["安静的住宅区音乐"] = 1845554017,
    ["From La With Love"] = 9046864900,
    
    -- Phonk 音乐
    ["No Light"] = 14145623221,
    ["Bell Pepper"] = 14145626111,
    ["The Final Phonk"] = 14145620056,
    ["Baller (原版)"] = 13530438299
}

-- 停止当前音乐
local function stopMusic()
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
        currentSound = nil
    end
    isPlaying = false
end

-- 播放音乐
local function playMusic(soundId, musicName)
    stopMusic()
    
    currentSound = Instance.new("Sound")
    currentSound.SoundId = "rbxassetid://" .. soundId
    currentSound.Parent = game:GetService("SoundService")
    currentSound.Volume = 0.5
    currentSound.Looped = false
    
    currentSound.Ended:Connect(function()
        isPlaying = false
        WindUI:Notify({
            Title = "音乐播放结束",
            Content = musicName .. " 已播放完毕",
            Duration = 3,
            Icon = "music"
        })
    end)
    
    currentSound:Play()
    isPlaying = true
    
    WindUI:Notify({
        Title = "正在播放",
        Content = musicName,
        Duration = 3,
        Icon = "play"
    })
end

-- 音乐控制按钮
MusicSection:Button({
    Title = "停止播放",
    Desc = "停止当前播放的音乐",
    Icon = "square",
    Callback = function()
        stopMusic()
        WindUI:Notify({
            Title = "音乐已停止",
            Content = "所有音乐播放已停止",
            Duration = 3,
            Icon = "square"
        })
    end
})

local VolumeSlider = MusicSection:Slider({
    Title = "音量控制",
    Desc = "调整音乐音量大小",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.5
    },
    Callback = function(Value)
        if currentSound then
            currentSound.Volume = Value
        end
    end
})

-- 自定义音乐输入
MusicSection:Input({
    Title = "自定义音乐ID",
    Desc = "输入Roblox音效ID",
    Placeholder = "例如: 10722835168",
    Callback = function(Value)
        if Value and Value ~= "" then
            local soundId = tonumber(Value)
            if soundId then
                playMusic(soundId, "自定义音乐")
            else
            
        WindUI:Notify({
          Title = "错误",
           Content = "请输入有效的数字ID",
           Duration = 3,
           Icon = "alert-circle"
        })
            end
        end
    end
})

-- 创建分类按钮
local function createMusicButtons(categoryName, musicList)
    local categorySection = MusicTab:Section({
        Title = categoryName,
        Opened = false
    })
    
    for musicName, soundId in pairs(musicList) do
        categorySection:Button({
            Title = musicName,
            Desc = "ID: " .. soundId,
            Callback = function()
                playMusic(soundId, musicName)
            end
        })
    end
end

-- 按分类创建音乐按钮
local categorizedMusic = {
    ["Doors音效"] = {
        ["Ambush音效"] = 10722835168,
        ["Rush音效"] = 10803213909,
        ["Seek音效"] = 10642752409,
        ["绿脸音效"] = 9113115842,
        ["TheHunt倒计时结束"] = 16695021133,
        ["TheHunt倒计时开始"] = 16695384009,
        ["结束追杀音效"] = 16695425474,
        ["获取金币音效"] = 8646410774
    },
    
    ["游戏音效"] = {
        ["Bad to the Bone"] = 6965169740,
        ["钢管落地(大声)"] = 6729922069,
        ["T阵营胜利音乐"] = 1420383375,
        ["C4倒计时"] = 4873271533,
        ["C4爆炸"] = 4854660190,
        ["闪光弹爆炸"] = 9114799182
    },
    
    ["MEME音效"] = {
        ["Ouch!"] = 12222058,
        ["通用Meme音效"] = 5257196749,
        ["Nope Meme"] = 6346074926,
        ["苹果手机闹钟"] = 4203251375,
        ["Windows错误提示音"] = 2661731024,
        ["OMG~"] = 336771379
    },
    
    ["环境音效"] = {
        ["钢管落地"] = 6011094380,
        ["核弹爆炸"] = 421256280,
        ["警报声"] = 675587093,
        ["Minecraft门关闭"] = 180090455,
        ["Minecraft受伤音效"] = 6361963422
    },
    
    ["音乐曲目"] = {
        ["Lo-fi Chill音乐"] = 9043887091,
        ["Clair De Lune (月光)"] = 1838457617,
        ["投弹兵进行曲"] = 1840172845,
        ["《起风了》"] = 7548510678,
        ["《海阔天空》"] = 3875049052,
        ["《光辉岁月》"] = 6116888743
    },
    
    ["Phonk音乐"] = {
        ["No Light"] = 14145623221,
        ["Bell Pepper"] = 14145626111,
        ["The Final Phonk"] = 14145620056,
        ["Baller (原版)"] = 13530438299
    }
}

for categoryName, musicList in pairs(categorizedMusic) do
    createMusicButtons(categoryName, musicList)
end

Window:SelectTab(2)

WindUI:Notify({
    Title = "挽脚本加载完成",
    Content = "欢迎使用挽脚本",
    Duration = 5,
    Icon = "crown"
})

print("挽脚本加载完成(◍•ᴗ•◍)") %