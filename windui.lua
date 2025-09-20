local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ============================================
-- 皮脚本功能整合到WindUI
-- ============================================

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 碰撞箱系统
local CollisionBoxes = {}
local CollisionBoxesEnabled = false
local CollisionSize = 3

-- 子弹追踪系统
local BulletTrackingEnabled = false
local BulletDamageMultiplier = 1.0

-- 创建碰撞箱
local function createCollisionBox(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "CollisionBox"
    box.Adornee = part
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = part.Size
    box.Color3 = Color3.fromRGB(255, 0, 0)  -- 红色
    box.Transparency = 0.7  -- 70%透明度
    box.Parent = game.CoreGui
    
    return box
end

-- 更新所有玩家碰撞箱
local function updateAllCollisionBoxes()
    -- 清除现有碰撞箱
    for _, box in pairs(CollisionBoxes) do
        box:Destroy()
    end
    CollisionBoxes = {}
    
    if not CollisionBoxesEnabled then return end
    
    -- 为所有玩家(除了自己)创建碰撞箱
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local box = createCollisionBox(humanoidRootPart)
                table.insert(CollisionBoxes, box)
            end
        end
    end
end

-- 修改其他玩家碰撞箱大小
local function modifyOtherPlayersCollision(size)
    CollisionSize = size
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(size, size, size)
                -- 更新碰撞箱显示
                if CollisionBoxesEnabled then
                    updateAllCollisionBoxes()
                end
            end
        end
    end
end

-- 子弹范围伤害系统
local function setupBulletRangeDamage()
    -- 监听子弹发射事件
    local function onBulletFired(bullet)
        if not BulletTrackingEnabled then return end
        
        bullet.Touched:Connect(function(hit)
            if hit and hit.Parent then
                local humanoid = hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid")
                if humanoid and humanoid ~= Humanoid then
                    -- 应用范围伤害
                    humanoid:TakeDamage(50 * BulletDamageMultiplier)
                    
                    -- 创建伤害效果
                    local effect = Instance.new("Part")
                    effect.Size = Vector3.new(2, 2, 2)
                    effect.Position = hit.Position
                    effect.Anchored = true
                    effect.CanCollide = false
                    effect.Material = Enum.Material.Neon
                    effect.Color = Color3.fromRGB(255, 0, 0)
                    effect.Parent = workspace
                    
                    game:GetService("TweenService"):Create(
                        effect,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Transparency = 1, Size = Vector3.new(4, 4, 4)}
                    ):Play()
                    
                    game.Debris:AddItem(effect, 0.5)
                end
            end
        end)
    end
    
    -- 尝试找到子弹发射事件
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            obj.Activated:Connect(function()
                local bullet = obj.Handle:Clone()
                bullet.Parent = workspace
                bullet.CFrame = obj.Handle.CFrame
                bullet.Velocity = obj.Handle.CFrame.LookVector * 100
                onBulletFired(bullet)
            end)
        end
    end
end

-- ============================================
-- UI配置
-- ============================================

local TextConfig = {
    window = {
        title = "mtaskh - WindUI版",
        author = "WindUI",
        folder = "PiScriptWindUI"
    },
    
    tabs = {
        main = {
            title = "主要",
            icon = "user",
            desc = "角色控制和游戏功能"
        },
        combat = {
            title = "战斗功能",
            icon = "target",
            desc = "战斗相关设置和功能"
        },
        scripts = {
            title = "脚本执行",
            icon = "code",
            desc = "从URL加载和执行脚本"
        },
        teleport = {
            title = "传送功能",
            icon = "map-pin",
            desc = "传送到不同位置"
        }
    },
    
    elements = {
        speed = {
            title = "移动速度",
            desc = "调整角色移动速度"
        },
        jump = {
            title = "跳跃高度", 
            desc = "调整角色跳跃高度"
        },
        collision = {
            title = "碰撞箱大小",
            desc = "调整其他玩家碰撞箱大小"
        },
        collisionToggle = {
            title = "显示碰撞箱",
            desc = "显示/隐藏其他玩家碰撞箱(红色透明)"
        },
        noclip = {
            title = "穿墙",
            desc = "开启/关闭穿墙功能"
        },
        nightvision = {
            title = "夜视",
            desc = "开启/关闭夜视功能"
        },
        bulletTracking = {
            title = "子弹范围伤害",
            desc = "开启/关闭子弹范围伤害"
        },
        bulletDamage = {
            title = "子弹伤害倍数",
            desc = "调整子弹伤害倍数"
        }
    },
    
    buttons = {
        fly = {
            title = "飞行",
            desc = "启用飞行功能"
        },
        car = {
            title = "飞车",
            desc = "启用飞车功能"
        },
        aimbot = {
            title = "自瞄",
            desc = "启用自瞄功能"
        },
        esp = {
            title = "透视",
            desc = "启用透视功能"
        },
        script1 = {
            title = "执行脚本 1",
            desc = "从URL加载并执行第一个脚本"
        },
        script2 = {
            title = "玩家进入服务器提示",
            desc = "从URL加载并执行第二个脚本"
        },
        script3 = {
            title = "无限跳",
            desc = "从URL加载并执行第三个脚本"
        }
    }
}

-- ============================================
-- UI创建代码
-- ============================================

local Window = WindUI:CreateWindow({
    Title = TextConfig.window.title,
    Icon = "rbxassetid://4483345998",
    Author = TextConfig.window.author,
    Folder = TextConfig.window.folder,
    Size = UDim2.fromOffset(650, 550),
    Theme = "Dark",
})

-- 创建标签页
local MainTab = Window:Section({Title = "主要", Icon = "user"}):Tab({
    Title = TextConfig.tabs.main.title,
    Icon = TextConfig.tabs.main.icon,
    Desc = TextConfig.tabs.main.desc
})

local CombatTab = Window:Section({Title = "战斗功能", Icon = "target"}):Tab({
    Title = TextConfig.tabs.combat.title,
    Icon = TextConfig.tabs.combat.icon,
    Desc = TextConfig.tabs.combat.desc
})

local ScriptsTab = Window:Section({Title = "脚本执行", Icon = "code"}):Tab({
    Title = TextConfig.tabs.scripts.title,
    Icon = TextConfig.tabs.scripts.icon,
    Desc = TextConfig.tabs.scripts.desc
})

local TeleportTab = Window:Section({Title = "传送功能", Icon = "map-pin"}):Tab({
    Title = TextConfig.tabs.teleport.title,
    Icon = TextConfig.tabs.teleport.icon,
    Desc = TextConfig.tabs.teleport.desc
})

-- 选择主标签页
Window:SelectTab(1)

-- ============================================
-- 添加功能元素
-- ============================================

-- 速度滑条
MainTab:Slider({
    Title = TextConfig.elements.speed.title,
    Desc = TextConfig.elements.speed.desc,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end
})

-- 跳跃高度滑条
MainTab:Slider({
    Title = TextConfig.elements.jump.title,
    Desc = TextConfig.elements.jump.desc,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        if Humanoid then
            Humanoid.JumpPower = value
        end
    end
})

-- 碰撞箱大小滑条
MainTab:Slider({
    Title = TextConfig.elements.collision.title,
    Desc = TextConfig.elements.collision.desc,
    Value = {
        Min = 1,
        Max = 10,
        Default = 3,
    },
    Callback = function(value)
        modifyOtherPlayersCollision(value)
    end
})

-- 碰撞箱显示开关
MainTab:Toggle({
    Title = TextConfig.elements.collisionToggle.title,
    Desc = TextConfig.elements.collisionToggle.desc,
    Value = false,
    Callback = function(state)
        CollisionBoxesEnabled = state
        updateAllCollisionBoxes()
    end
})

-- 穿墙开关
local Noclip = false
local Stepped
MainTab:Toggle({
    Title = TextConfig.elements.noclip.title,
    Desc = TextConfig.elements.noclip.desc,
    Value = false,
    Callback = function(state)
        Noclip = state
        if Noclip then
            Stepped = game:GetService("RunService").Stepped:Connect(function()
                if Noclip and Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                else
                    Stepped:Disconnect()
                end
            end)
        elseif Stepped then
            Stepped:Disconnect()
        end
    end
})

-- 夜视开关
MainTab:Toggle({
    Title = TextConfig.elements.nightvision.title,
    Desc = TextConfig.elements.nightvision.desc,
    Value = false,
    Callback = function(state)
        if state then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

-- 添加分隔线
MainTab:Divider()

-- 功能按钮
MainTab:Button({
    Title = TextConfig.buttons.fly.title,
    Desc = TextConfig.buttons.fly.desc,
    Callback = function()
        loadstring(game:HttpGet(""))()
        WindUI:Notify({
            Title = "飞行功能",
            Content = "已启用飞行",
            Duration = 3,
        })
    end
})

MainTab:Button({
    Title = TextConfig.buttons.car.title,
    Desc = TextConfig.buttons.car.desc,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/c3dcf58fa8cf7277.txt_2024-08-08_160648.OTed.lua"))()
        WindUI:Notify({
            Title = "飞车功能",
            Content = "已启用飞车",
            Duration = 3,
        })
    end
})

-- ============================================
-- 战斗功能标签页
-- ============================================

-- 子弹范围伤害开关
CombatTab:Toggle({
    Title = TextConfig.elements.bulletTracking.title,
    Desc = TextConfig.elements.bulletTracking.desc,
    Value = false,
    Callback = function(state)
        BulletTrackingEnabled = state
        if state then
            setupBulletRangeDamage()
            WindUI:Notify({
                Title = "子弹范围伤害",
                Content = "已启用子弹范围伤害",
                Duration = 3,
            })
        end
    end
})

-- 子弹伤害倍数滑条
CombatTab:Slider({
    Title = TextConfig.elements.bulletDamage.title,
    Desc = TextConfig.elements.bulletDamage.desc,
    Value = {
        Min = 0.5,
        Max = 5,
        Default = 1,
        Precision = 1
    },
    Callback = function(value)
        BulletDamageMultiplier = value
    end
})

-- 战斗功能按钮
CombatTab:Button({
    Title = TextConfig.buttons.aimbot.title,
    Desc = TextConfig.buttons.aimbot.desc,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/3683e49998644fb7.txt_2024-08-09_094310.OTed.lua"))()
        WindUI:Notify({
            Title = "自瞄功能",
            Content = "已启用自瞄",
            Duration = 3,
        })
    end
})

CombatTab:Button({
    Title = TextConfig.buttons.esp.title,
    Desc = TextConfig.buttons.esp.desc,
    Callback = function()
    loadstring(game:GetObjects("rbxassetid://10092697033")[1].Source)()
        WindUI:Notify({
            Title = "透视功能",
            Content = "已启用最强透视",
            Duration = 3,
        })
    end
})

-- ============================================
-- 脚本执行功能
-- ============================================

-- 脚本URL列表
local ScriptURLs = {
    "https://pastebin.com/raw/YNVbeqPy",  -- 传送玩家
    "https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua",  -- 玩家进入提示
    "https://pastebin.com/raw/V5PQy3y0"   -- 无限跳
}

-- 脚本执行按钮
ScriptsTab:Button({
    Title = TextConfig.buttons.script1.title,
    Desc = TextConfig.buttons.script1.desc,
    Callback = function()
        loadstring(game:HttpGet(ScriptURLs[1]))()
        WindUI:Notify({
            Title = "脚本执行",
            Content = "已执行脚本 1 (传送玩家)",
            Duration = 3,
        })
    end
})

ScriptsTab:Button({
    Title = TextConfig.buttons.script2.title,
    Desc = TextConfig.buttons.script2.desc,
    Callback = function()
        loadstring(game:HttpGet(ScriptURLs[2]))()
        WindUI:Notify({
            Title = "脚本执行",
            Content = "已执行脚本 2 (玩家进入提示)",
            Duration = 3,
        })
    end
})

ScriptsTab:Button({
    Title = TextConfig.buttons.script3.title,
    Desc = TextConfig.buttons.script3.desc,
    Callback = function()
        loadstring(game:HttpGet(ScriptURLs[3]))()
        WindUI:Notify({
            Title = "脚本执行",
            Content = "已执行脚本 3 (无限跳)",
            Duration = 3,
        })
    end
})

-- 自定义脚本输入
ScriptsTab:Input({
    Title = "自定义脚本URL",
    Desc = "输入自定义脚本URL并执行",
    Value = "",
    Placeholder = "https://pastebin.com/raw/...",
    Callback = function(url)
        if url and url ~= "" then
            loadstring(game:HttpGet(url))()
            WindUI:Notify({
                Title = "脚本执行",
                Content = "已执行自定义脚本",
                Duration = 3,
            })
        end
    end
})

-- ============================================
-- 传送功能
-- ============================================

-- 传送地点
local TeleportLocations = {
    {Name = "出生点", Position = Vector3.new(0, 5, 0)},
    {Name = "高处", Position = Vector3.new(0, 100, 0)},
    {Name = "远处", Position = Vector3.new(100, 5, 100)}
}

-- 添加传送按钮
for _, location in ipairs(TeleportLocations) do
    TeleportTab:Button({
        Title = "传送到 " .. location.Name,
        Desc = "传送到指定位置",
        Callback = function()
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = CFrame.new(location.Position)
                WindUI:Notify({
                    Title = "传送",
                    Content = "已传送到 " .. location.Name,
                    Duration = 3,
                })
            end
        end
    })
end

-- ============================================
-- 事件监听和初始化
-- ============================================

-- 玩家加入/离开时更新碰撞箱
game.Players.PlayerAdded:Connect(function()
    updateAllCollisionBoxes()
end)

game.Players.PlayerRemoving:Connect(function()
    updateAllCollisionBoxes()
end)

-- 角色变化时重新获取Humanoid
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
end)

-- 关闭事件
Window:OnClose(function()
    -- 清理碰撞箱
    for _, box in pairs(CollisionBoxes) do
        box:Destroy()
    end
    CollisionBoxes = {}
    
    -- 关闭穿墙
    if Stepped then
        Stepped:Disconnect()
    end
    
    -- 恢复夜视
    game.Lighting.Ambient = Color3.new(0, 0, 0)
    
    -- 恢复碰撞箱大小
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Size = Vector3.new(2, 2, 1)
            end
        end
    end
end)

-- 初始化
WindUI:Notify({
    Title = "脚本已加载",
    Content = "WindUI版本已就绪，享受游戏!",
    Duration = 5,
})