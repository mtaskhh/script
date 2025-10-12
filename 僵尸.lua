local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "blade zombie Script",
    Icon = "crown",
    Author = "by--Mtaskh",
    Folder = "blade zombie",
    Size = UDim2.fromOffset(750, 650),
    Theme = "Dark",
})

local firstTab = Window:Tab({
    Title = "通用功能",
    Icon = "settings"
})

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

GeneralSection:Toggle({
    Title = "耐摔王",
    Desc = "what can i say",
    icon = "geist:accessibility",
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
    Title = "飞行",
    Desc = "fly Script",
    Icon = "user",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/XxwanhexxX/Script/main/fly'))()
    end
})

ToolSection:Button({
    Title = "汉化悬浮ui穿墙",
    Desc = "加载汉化穿墙功能",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))()
    end
})

ToolSection:Button({
    Title = "踏空ui",
    Desc = "加载踏空行走功能",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float', true))()
    end
})

ToolSection:Button({
    Title = "解锁第三人称",
    Desc = "解锁第三人称视角",
    Callback = function()
        game.Players.LocalPlayer.CameraMaxZoomDistance = 50
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
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
    Title = "动态模糊",
    Desc = "根据移动速度动态调整模糊效果",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        
        local motionBlur = Instance.new("BlurEffect")
        motionBlur.Name = "DynamicMotionBlur"
        motionBlur.Size = 10
        motionBlur.Parent = Lighting
        
        game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
            local player = game:GetService("Players").LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local velocity = player.Character.HumanoidRootPart.Velocity.Magnitude
                motionBlur.Size = math.clamp(velocity / 20, 0, 15)
            end
        end)
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
    Desc = "加载后无法取消效果",
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


local Tab = Window:Tab({
    Title = "主页面",
    Icon = "code"
})

local currentWalkSpeed = 16
local currentJumpPower = 50

local SpeedSlider = Tab:Slider({
    Title = "移动速度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 2000,
        Default = 16,
    },
    Callback = function(value)
        currentWalkSpeed = value
    end
})

local speedProtection
speedProtection = game:GetService("RunService").Heartbeat:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= currentWalkSpeed then
            humanoid.WalkSpeed = currentWalkSpeed
        end
    end
end)

local JumpSlider = Tab:Slider({
    Title = "跳跃高度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 600,
        Default = 50,
    },
    Callback = function(value)
        currentJumpPower = value
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = currentWalkSpeed
    humanoid.JumpPower = currentJumpPower
end)

local SkipStageToggle = Tab:Toggle({
    Title = "跳过环节",
    Desc = "自动跳过游戏环节",
    Value = false,
    Callback = function(state)
        _G.SkipStageEnabled = state
        if state then
            WindUI:Notify({
                Title = "跳过环节已开启",
                Content = "将自动跳过游戏环节",
                Duration = 2,
                Icon = "fast-forward"
            })
        else
            WindUI:Notify({
                Title = "跳过环节已关闭", 
                Content = "停止跳过游戏环节",
                Duration = 2,
                Icon = "square"
            })
        end
    end
})

local StartButton = Tab:Button({
    Title = "启动自动杀戮",
    Desc = "开始自动攻击僵尸和传送",
    Callback = function()
        startAutoKill()
    end
})

local StopButton = Tab:Button({
    Title = "停止自动杀戮",
    Desc = "停止自动攻击功能",
    Callback = function()
        stopAutoKill()
    end
})

_G.SkipStageEnabled = false
_G.AutoKillRunning = false
_G.AutoKillConnections = nil

function startAutoKill()
    if _G.AutoKillRunning then
        stopAutoKill()
        wait(0.1)
    end
    
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local SkillRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSkillEvent")
    local SwingRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestSwing")
    local SkipRemote = ReplicatedStorage:WaitForChild("RemoteGUI"):WaitForChild("USkipActiveEvent")

    local connections = {}
    local currentNPC, currentHumanoid

    local function findNPC()
        if not Workspace:FindFirstChild("Enemies") then
            return nil
        end
        
        local nearestNPC = nil
        local nearestDistance = math.huge
        
        for _, model in pairs(Workspace.Enemies:GetChildren()) do
            if model:IsA("Model") and string.sub(model.Name, 1, 3):lower() == "npc" then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local npcRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
                    if npcRoot then
                        local distance = (rootPart.Position - npcRoot.Position).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestNPC = model
                        end
                    end
                end
            end
        end
        return nearestNPC
    end

    local skillConnection
    skillConnection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent or not rootPart or not rootPart.Parent then
            return
        end
        
        for i = 1, 2 do
            local skillArgs = {[1] = "Skill_" .. i}
            pcall(function()
                SkillRemote:FireServer(unpack(skillArgs))
            end)
        end
        
        local swingArgs = {
            [1] = {
                ["clientTime"] = tick(),
                ["originCFrame"] = rootPart.CFrame
            }
        }
        pcall(function()
            SwingRemote:FireServer(unpack(swingArgs))
        end)
        
        if _G.SkipStageEnabled then
            local skipArgs = {
                [1] = true
            }
            pcall(function()
                SkipRemote:FireServer(unpack(skipArgs))
            end)
        end
    end)
    table.insert(connections, skillConnection)

    local autoInteractConnection
    autoInteractConnection = RunService.Heartbeat:Connect(function()
        for _, descendant in pairs(Workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                pcall(function()
                    fireproximityprompt(descendant)
                end)
            end
        end
    end)
    table.insert(connections, autoInteractConnection)

    local tpConnection

    tpConnection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent or not rootPart or not rootPart.Parent then
            return
        end

        if not currentNPC or not currentNPC.Parent or not currentHumanoid or currentHumanoid.Health <= 0 then
            currentNPC, currentHumanoid = findNPC()
            if not currentNPC then
                return
            end
        end
        
        local npcRoot = currentNPC:FindFirstChild("HumanoidRootPart") or currentNPC:FindFirstChild("Head")
        if npcRoot then
            local npcPosition = npcRoot.Position
            rootPart.CFrame = CFrame.new(npcPosition.X, npcPosition.Y + 6, npcPosition.Z)
        end
    end)
    table.insert(connections, tpConnection)

    local characterConnection = player.CharacterAdded:Connect(function(newChar)
        character = newChar
        rootPart = newChar:WaitForChild("HumanoidRootPart")
        currentNPC, currentHumanoid = nil, nil
    end)
    table.insert(connections, characterConnection)

    _G.AutoKillConnections = connections
    _G.AutoKillRunning = true

    WindUI:Notify({
        Title = "自动杀戮已启动",
        Content = "自动攻击僵尸已开启",
        Duration = 3,
        Icon = "sword"
    })
end

function stopAutoKill()
    if _G.AutoKillConnections then
        for _, connection in pairs(_G.AutoKillConnections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
        _G.AutoKillConnections = nil
    end
    
    _G.AutoKillRunning = false
    
    WindUI:Notify({
        Title = "自动杀戮已停止",
        Content = "自动攻击已关闭",
        Duration = 2,
        Icon = "square"
    })
end

WindUI:Notify({
    Title = "脚本加载完成",
    Content = "Mtaskh脚本已成功加载！", 
    Duration = 5,
})