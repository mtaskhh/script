local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local dropdown = {}
local playernamedied = ""
local autoInteract = false
local Jump = false

for i, player in pairs(Players:GetPlayers()) do
    dropdown[i] = player.Name
end

local Config = {
    BulletTrackingEnabled = false,
    BulletDamageMultiplier = 1.0,
    BulletRange = 20,
    
    Hooks = {
        damageHook = false,
        teleportHook = false,
        animationHook = false
    },
    
    OriginalAmbient = Lighting.Ambient,
    
    Connections = {}
}

local CleanupSystem = {}

function CleanupSystem.cleanup()
    -- 清理连接
    for category, connections in pairs(Config.Connections) do
        if type(connections) == "table" then
            for _, connection in pairs(connections) do
                if connection and connection.Disconnect then
                    connection:Disconnect()
                end
            end
        elseif connections and connections.Disconnect then
            connections:Disconnect()
        end
    end
    Config.Connections = {}
    
    -- 恢复环境光
    Lighting.Ambient = Config.OriginalAmbient
    
    -- 重置钩子状态
    for hookName in pairs(Config.Hooks) do
        Config.Hooks[hookName] = false
    end
end

function Notify(top, text, ico, dur)
    StarterGui:SetCore("SendNotification", {
        Title = top,
        Text = text,
        Icon = ico,
        Duration = dur,
    })
end

local LBLG = Instance.new("ScreenGui")
local LBL = Instance.new("TextLabel")

LBLG.Name = "LBLG"
LBLG.Parent = game.CoreGui
LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LBLG.Enabled = true
LBL.Name = "LBL"
LBL.Parent = LBLG
LBL.BackgroundColor3 = Color3.new(1, 1, 1)
LBL.BackgroundTransparency = 1
LBL.BorderColor3 = Color3.new(0, 0, 0)
LBL.Position = UDim2.new(0.75,0,0.010,0)
LBL.Size = UDim2.new(0, 133, 0, 30)
LBL.Font = Enum.Font.GothamSemibold
LBL.Text = "时间:加载中..."
LBL.TextColor3 = Color3.new(1, 1, 1)
LBL.TextScaled = true
LBL.TextSize = 14
LBL.TextWrapped = true
LBL.Visible = true

local FpsLabel = LBL
local Heartbeat = RunService.Heartbeat
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
    FpsLabel.Text = ("时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
end

Start = tick()
Heartbeat:Connect(HeartbeatUpdate)

local FpsGui = Instance.new("ScreenGui") 
local FpsXS = Instance.new("TextLabel") 
FpsGui.Name = "FPSGui" 
FpsGui.ResetOnSpawn = false 
FpsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
FpsXS.Name = "FpsXS" 
FpsXS.Size = UDim2.new(0, 100, 0, 50) 
FpsXS.Position = UDim2.new(0, 10, 0, 10) 
FpsXS.BackgroundTransparency = 1 
FpsXS.Font = Enum.Font.SourceSansBold 
FpsXS.Text = "帧率: 0" 
FpsXS.TextSize = 20 
FpsXS.TextColor3 = Color3.new(1, 1, 1) 
FpsXS.Parent = FpsGui 

function updateFpsXS() 
    local fps = math.floor(1 / RunService.RenderStepped:Wait()) 
    FpsXS.Text = "帧率: " .. fps 
end 

RunService.RenderStepped:Connect(updateFpsXS) 
FpsGui.Parent = Player:WaitForChild("PlayerGui")

local Utils = {}

function Utils.safeExecute(func, errorMsg)
    local success, result = pcall(func)
    if not success then
        WindUI:Notify({
            Title = "错误",
            Content = errorMsg or "执行失败: " .. tostring(result),
            Duration = 5,
        })
        warn("Script Error:", result)
        return false, result
    end
    return true, result
end

function Utils.validateCharacter()
    if not Character or not Character.Parent then
        Character = Player.Character
        if Character then
            Humanoid = Character:WaitForChild("Humanoid")
        end
    end
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

function Utils.parseCoordinates(input)
    local coords = {}
    for num in string.gmatch(input, "[^,]+") do
        local parsed = tonumber(string.match(num, "^%s*(.-)%s*$"))
        if parsed then
            table.insert(coords, parsed)
        end
    end
    return #coords == 3 and coords or nil
end

function Utils.loadExternalScript(url, scriptName)
    Utils.safeExecute(function()
        loadstring(game:HttpGet(url))()
        WindUI:Notify({
            Title = scriptName or "脚本加载",
            Content = "已成功加载脚本",
            Duration = 3,
        })
    end, "脚本加载失败: " .. (scriptName or "未知脚本"))
end

local CombatSystem = {}

function CombatSystem.createBullet(startCFrame)
    local bullet = Instance.new("Part")
    bullet.Name = "CustomBullet"
    bullet.Size = Vector3.new(0.5, 0.5, 0.5)
    bullet.CFrame = startCFrame
    bullet.CanCollide = false
    bullet.Anchored = false
    bullet.Transparency = 0.7
    bullet.Color = Color3.fromRGB(255, 0, 0)
    bullet.Material = Enum.Material.Neon
    bullet.Parent = workspace
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = startCFrame.LookVector * 200
    bodyVelocity.Parent = bullet
    
    return bullet
end

function CombatSystem.createHitEffect(position)
    local effect = Instance.new("Part")
    effect.Name = "HitEffect"
    effect.Size = Vector3.new(2, 2, 2)
    effect.Position = position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Material = Enum.Material.Neon
    effect.Color = Color3.fromRGB(255, 0, 0)
    effect.Parent = workspace
    
    local tween = TweenService:Create(
        effect,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 1, Size = Vector3.new(4, 4, 4)}
    )
    
    tween:Play()
    Debris:AddItem(effect, 0.5)
end

function CombatSystem.setupBulletRangeDamage()
    if not Config.BulletTrackingEnabled then return end
    
    if Config.Connections.bulletConnections then
        for _, connection in pairs(Config.Connections.bulletConnections) do
            if connection then connection:Disconnect() end
        end
    end
    Config.Connections.bulletConnections = {}
    
    local function setupToolBullets(tool)
        if not tool:IsA("Tool") then return end
        
        local connection = tool.Activated:Connect(function()
            if not Config.BulletTrackingEnabled then return end
            
            Utils.safeExecute(function()
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local bullet = CombatSystem.createBullet(handle.CFrame)
                    
                    local hitConnection
                    hitConnection = bullet.Touched:Connect(function(hit)
                        if hit and hit.Parent and hit.Parent ~= Character then
                            local humanoid = hit.Parent:FindFirstChild("Humanoid") or 
                                           (hit.Parent.Parent and hit.Parent.Parent:FindFirstChild("Humanoid"))
                            
                            if humanoid and humanoid ~= Humanoid then
                                humanoid:TakeDamage(25 * Config.BulletDamageMultiplier)
                                CombatSystem.createHitEffect(hit.Position)
                            end
                        end
                        
                        if hitConnection then hitConnection:Disconnect() end
                        bullet:Destroy()
                    end)
                    
                    Debris:AddItem(bullet, 5)
                end
            end, "子弹创建失败")
        end)
        
        table.insert(Config.Connections.bulletConnections, connection)
    end
    
    for _, tool in ipairs(Player.Backpack:GetChildren()) do
        setupToolBullets(tool)
    end
    
    if Character then
        for _, tool in ipairs(Character:GetChildren()) do
            setupToolBullets(tool)
        end
    end
end

local HookSystem = {}

function HookSystem.setupDamageHook()
    if not Config.Hooks.damageHook then return end
    
    Utils.safeExecute(function()
        local function hookPlayerDamage(player)
            if player == Player or not player.Character then return end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid:GetAttribute("HookApplied") then return end
            
            humanoid:SetAttribute("HookApplied", true)
            local originalTakeDamage = humanoid.TakeDamage
            
            humanoid.TakeDamage = function(self, amount)
                if Config.Hooks.damageHook then
                    amount = amount * Config.BulletDamageMultiplier
                end
                return originalTakeDamage(self, amount)
            end
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            hookPlayerDamage(player)
        end
        
        if not Config.Connections.damageHookConnection then
            Config.Connections.damageHookConnection = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    wait(1)
                    hookPlayerDamage(player)
                end)
            end)
        end
    end, "伤害Hook设置失败")
end

local ScriptLoader = {}

ScriptLoader.Scripts = {
    fly = "https://raw.githubusercontent.com/mtaskhh/script/refs/heads/mt/Fly V3 gui.txt",
    car = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/c3dcf58fa8cf7277.txt_2024-08-08_160648.OTed.lua",
    aimbot = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/3683e49998644fb7.txt_2024-08-09_094310.OTed.lua",
    esp = "https://pastebin.com/raw/uw2P2fbY",
    playernotify = "https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua",
    infinitejump = "https://pastebin.com/raw/V5PQy3y0"
}

function ScriptLoader.loadScript(url, name)
    Utils.safeExecute(function()
        loadstring(game:HttpGet(url))()
        WindUI:Notify({
            Title = name or "脚本加载",
            Content = "已成功加载脚本",
            Duration = 3,
        })
    end, "脚本加载失败: " .. (name or "未知脚本"))
end

local TeleportSystem = {}

TeleportSystem.Locations = {
    {Name = "出生点", Position = Vector3.new(0, 5, 0)},
    {Name = "高处", Position = Vector3.new(0, 100, 0)},
    {Name = "远处", Position = Vector3.new(100, 5, 100)},
    {Name = "左侧", Position = Vector3.new(-50, 5, 0)},
    {Name = "右侧", Position = Vector3.new(50, 5, 0)}
}

function TeleportSystem.teleportTo(position, name)
    if not Utils.validateCharacter() then
        WindUI:Notify({
            Title = "传送失败",
            Content = "角色不存在或无效",
            Duration = 3,
        })
        return
    end
    
    Utils.safeExecute(function()
        Character.HumanoidRootPart.CFrame = CFrame.new(position)
        WindUI:Notify({
            Title = "传送成功",
            Content = "已传送到 " .. (name or "指定位置"),
            Duration = 3,
        })
    end, "传送失败")
end

local Window = WindUI:CreateWindow({
    Title = "mtaskH - WindUI",
    Icon = "rbxassetid://4483345998",
    Author = "mtaskh脚本",
    Folder = "MTColdScriptEnhanced",
    Size = UDim2.fromOffset(750, 650),
    Theme = "Dark",
})

local MainSection = Window:Section({Title = "主要功能", Icon = "user", Opened = true})
local CombatSection = Window:Section({Title = "战斗功能", Icon = "target", Opened = true})
local VisualSection = Window:Section({Title = "视觉功能", Icon = "eye", Opened = true})
local MusicSection = Window:Section({Title = "音乐功能", Icon = "music", Opened = true})

local MainTab = MainSection:Tab({Title = "主要控制", Icon = "settings", Desc = "角色控制和游戏功能"})
local CombatTab = CombatSection:Tab({Title = "战斗设置", Icon = "sword", Desc = "战斗相关设置和功能"})
local VisualTab = VisualSection:Tab({Title = "视觉设置", Icon = "eye", Desc = "视觉和图形设置"})
local MusicTab = MusicSection:Tab({Title = "音乐播放", Icon = "music", Desc = "游戏内音乐播放"})

Window:SelectTab(1)

MainTab:Slider({
    Title = "移动速度",
    Desc = "调整角色移动速度 (16-400)",
    Value = {Min = 16, Max = 800, Default = 16},
    Callback = function(value)
        if Utils.validateCharacter() then
            Humanoid.WalkSpeed = value
        end
    end
})

MainTab:Slider({
    Title = "跳跃高度", 
    Desc = "调整角色跳跃高度 (50-400)",
    Value = {Min = 50, Max = 800, Default = 50},
    Callback = function(value)
        if Utils.validateCharacter() then
            Humanoid.JumpPower = value
        end
    end
})

MainTab:Slider({
    Title = "重力设置",
    Desc = "调整游戏重力 (196.2-1000)",
    Value = {Min = 196.2, Max = 2000, Default = 196.2, Precision = 1},
    Callback = function(value)
        workspace.Gravity = value
    end
})

MainTab:Button({
    Title = "隐身模式",
    Desc = "加载外部隐身脚本",
    Callback = function()
        Utils.safeExecute(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-35376"))()
            WindUI:Notify({
                Title = "隐身模式",
                Content = "隐身脚本已加载",
                Duration = 3,
            })
        end, "隐身脚本加载失败")
    end
})

MainTab:Toggle({
    Title = "夜视模式",
    Desc = "开启/关闭夜视功能",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            Lighting.Ambient = Config.OriginalAmbient
        end
    end
})

MainTab:Toggle({
    Title = "无限跳跃",
    Desc = "开启/关闭无限跳跃",
    Value = false,
    Callback = function(state)
        Jump = state
        if state then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if Jump and Utils.validateCharacter() then
                    Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "自动互动",
    Desc = "自动与附近的ProximityPrompt互动",
    Value = false,
    Callback = function(state)
        autoInteract = state
        if state then
            spawn(function()
                while autoInteract do
                    for _, descendant in pairs(workspace:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") then
                            fireproximityprompt(descendant)
                        end
                    end
                    task.wait(0.25)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "子弹范围伤害",
    Desc = "开启/关闭子弹范围伤害",
    Value = false,
    Callback = function(state)
        Config.BulletTrackingEnabled = state
        if state then
            CombatSystem.setupBulletRangeDamage()
        end
    end
})

CombatTab:Slider({
    Title = "子弹伤害倍数",
    Desc = "调整子弹伤害倍数 (0.5-10)",
    Value = {Min = 0.5, Max = 10, Default = 1, Precision = 1},
    Callback = function(value)
        Config.BulletDamageMultiplier = value
    end
})

local aimbotScripts = {
    {"冷自瞄", "https://pastefy.app/ZYMlyhhz/raw"},
    {"宙斯自瞄", "https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"},
    {"英文自瞄", "https://rentry.co/n55gmtpi/raw"},
    {"自瞄50", "https://pastefy.app/b3uXjRF6/raw"},
    {"自瞄100", "https://pastefy.app/tQrd2r0L/raw"},
    {"自瞄150", "https://pastefy.app/UOQWFvGp/raw"},
    {"自瞄200", "https://pastefy.app/b5CuDuer/raw"},
    {"自瞄250", "https://pastefy.app/p2huH7eF/raw"},
    {"自瞄300", "https://pastefy.app/nIyVhrvV/raw"},
    {"自瞄350", "https://pastefy.app/pnjKHMvV/raw"},
    {"自瞄400", "https://pastefy.app/LQuP7sjj/raw"},
    {"自瞄600", "https://pastefy.app/WmcEe2HB/raw"},
    {"自瞄全屏", "https://pastefy.app/n5LhGGgf/raw"}
}

for i, aimbot in ipairs(aimbotScripts) do
    CombatTab:Button({
        Title = aimbot[1],
        Desc = "加载" .. aimbot[1] .. "脚本",
        Callback = function()
            Utils.loadExternalScript(aimbot[2], aimbot[1])
        end
    })
end

VisualTab:Button({
    Title = "ESP显示名字",
    Desc = "启用ESP名字显示",
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
        
        for i,v in pairs(Players:GetPlayers()) do
            ApplyESP(v)
            v.CharacterAdded:Connect(function()
                task.wait(0.33)
                ApplyESP(v)
            end)
        end
        
        Players.PlayerAdded:Connect(function(v)
            ApplyESP(v)
            v.CharacterAdded:Connect(function()
                task.wait(0.33)
                ApplyESP(v)
            end)
        end)
        
        WindUI:Notify({Title = "ESP", Content = "ESP名字显示已启用", Duration = 3})
    end
})

VisualTab:Button({
    Title = "光影效果",
    Desc = "加载光影效果",
    Callback = function()
        Utils.loadExternalScript("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml", "光影效果")
    end
})

local musicTracks = {
    {"彩虹瀑布", 1837879082},
    {"防空警报", 792323017},
    {"义勇军进行曲", 1845918434},
    {"火车音", 3900067524},
    {"Gentry Road", 5567523008},
    {"植物大战僵尸", 158260415},
    {"早安越南", 8295016126},
    {"愤怒芒西 Evade?", 5029269312},
    {"梅西", 7354576319},
    {"永春拳", 1845973140},
    {"带劲的音乐", 18841891575},
    {"韩国国歌", 1837478300},
    {"哥哥你女朋友不会吃醋吧?", 8715811379},
    {"蜘蛛侠出场声音", 9108472930},
    {"消防车", 317455930},
    {"万圣节1🎃", 1837467198},
    {"好听的", 1844125168},
    {"国歌[Krx版]", 1845918434},
    {"妈妈生的", 6689498326},
    {"Music Ball-CTT", 9045415830},
    {"电音", 6911766512},
    {"梗合集", 8161248815},
    {"Its been so long", 6913550990},
    {"Baller", 13530439660},
    {"男娘必听", 6797864253},
    {"螃蟹之舞", 54100886218},
    {"布鲁克林惨案", 6783714255},
    {"航空模拟器音乐", 1838080629}
}

for i, track in ipairs(musicTracks) do
    MusicTab:Button({
        Title = track[1],
        Desc = "播放" .. track[1],
        Callback = function()
            Utils.safeExecute(function()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://" .. track[2]
                sound.Parent = workspace
                sound:Play()
                WindUI:Notify({
                    Title = "音乐播放",
                    Content = "正在播放: " .. track[1],
                    Duration = 3,
                })
            end, "播放音乐失败: " .. track[1])
        end
    })
end

MusicTab:Button({
    Title = "国外音乐脚本",
    Desc = "加载国外音乐脚本",
    Callback = function()
        Utils.loadExternalScript("https://pastebin.com/raw/g97RafnE", "国外音乐脚本")
    end
})

local graphicsScripts = {
    {"光影滤镜", "https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"},
    {"超高画质", "https://pastebin.com/raw/jHBfJYmS"},
    {"光影V4", "https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"},
    {"RTX高仿", "https://pastebin.com/raw/Bkf0BJb3"},
    {"光影深", "https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"},
    {"光影浅", "https://pastebin.com/raw/jHBfJYmS"}
}

for i, graphic in ipairs(graphicsScripts) do
    VisualTab:Button({
        Title = graphic[1],
        Desc = "加载" .. graphic[1] .. "效果",
        Callback = function()
            Utils.loadExternalScript(graphic[2], graphic[1])
        end
    })
end

-- 创建一个新的ScriptTab
local ScriptTab = MainSection:Tab({Title = "脚本功能", Icon = "code", Desc = "各种实用脚本功能"})

local remainingFunctions = {
    {"iy指令", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"工具挂", "https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"},
    {"飞行v1", "\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\112\97\115\116\101\98\105\110\46\99\111\109\47\114\97\119\47\90\66\122\99\84\109\49\102\34\41\41\40\41\10"},
    {"冷飞行", "https://raw.githubusercontent.com/odhdshhe/-V3.0/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%ACV3(%E5%85%A8%E6%B8%B8%E6%88%8F%E9%80%9A%E7%94%A8)%20(1).txt"},
    {"踏空行走", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"},
    {"飞檐走壁", "https://pastebin.com/raw/zXk4Rq2r"},
    {"夜视仪", function() 
        _G.OnShop = true
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DeividComSono/Scripts/main/Scanner.lua'))()
    end},
    {"转圈", "https://pastebin.com/raw/r97d7dS0"},
    {"Dex抓包", "https://raw.githubusercontent.com/XiaoFenHG/Dex-Explorer/refs/heads/main/Dex-Explorer.lua"}
}

for i, func in ipairs(remainingFunctions) do
    ScriptTab:Button({
        Title = func[1],
        Desc = "加载" .. func[1] .. "功能",
        Callback = function()
            if type(func[2]) == "string" then
                Utils.loadExternalScript(func[2], func[1])
            else
                Utils.safeExecute(func[2], "加载" .. func[1] .. "失败")
            end
        end
    })
end

ScriptTab:Button({
    Title = "紫砂",
    Desc = "角色自杀",
    Callback = function()
        if Utils.validateCharacter() then
            Humanoid.Health = 0
            WindUI:Notify({
                Title = "紫莎",
                Content = "角色已自杀",
                Duration = 3,
            })
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    dropdown[player.UserId] = player.Name
end)

Players.PlayerRemoved:Connect(function(player)
    for k, v in pairs(dropdown) do
        if v == player.Name then
            dropdown[k] = nil
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        CleanupSystem.cleanup()
        WindUI:Notify({
            Title = "清理完成",
            Content = "所有脚本资源已清理",
            Duration = 3,
        })
    end
end)

WindUI:Notify({
    Title = "脚本加载完成",
    Content = "mtaskh已加载完成！",
    Duration = 5,
})

print("mtaskh加载完成！")