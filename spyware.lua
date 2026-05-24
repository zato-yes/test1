
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera



local Config = {
    ESPEnabled = false,
    BurgerESPEnabled = false,
    LoopSpeedEnabled = false,
    WalkSpeed = 30,
    NoclipEnabled = false,
    InfJumpEnabled = false,
    FlyEnabled = false,
    FlySpeed = 2,
    StackWeapon = false,
    FastAttackEnabled = false,
    FastAttackMultiplier = 10,
    BringBurger = false,
    NoFogEnabled = false,
    FullBrightEnabled = false,
    InstantPromptEnabled = false,
    NPCHitboxEnabled = false,
    NPCHitboxSize = 4,
    NPCESPEnabled = false,
    AutoFarmEnabled = false
}

local SAVE_FOLDER = "StarCrowHub"
local SAVE_FILE = SAVE_FOLDER .. "/DeadspellsConfig.json"

local function SaveConfig()
    pcall(function()
        if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
        writefile(SAVE_FILE, HttpService:JSONEncode(Config))
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile(SAVE_FILE) then
            local decoded = HttpService:JSONDecode(readfile(SAVE_FILE))
            for k, v in pairs(decoded) do
                if Config[k] ~= nil then
                    Config[k] = v
                end
            end
        end
    end)
end

LoadConfig()

local LogoGui = Instance.new("ScreenGui")
LogoGui.Name = "StarCrowLogoGui"
LogoGui.ResetOnSpawn = false
LogoGui.DisplayOrder = 10000
pcall(function() LogoGui.Parent = game:GetService("CoreGui") end)
if not LogoGui.Parent then LogoGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 46, 0, 46)
LogoFrame.Position = UDim2.new(0, 8, 0.5, -23)
LogoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = LogoGui
Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0.2, 0)

local logoStroke = Instance.new("UIStroke", LogoFrame)
logoStroke.Thickness = 1.8
logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local logoGrad = Instance.new("UIGradient", logoStroke)
logoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 0, 255)),
})
task.spawn(function() TweenService:Create(logoGrad, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = 180}):Play() end)

local LogoImg = Instance.new("ImageLabel")
LogoImg.Size = UDim2.new(1, -6, 1, -6)
LogoImg.Position = UDim2.new(0, 3, 0, 3)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = "rbxthumb://type=Asset&id=115542332056889&w=150&h=150"
LogoImg.ScaleType = Enum.ScaleType.Fit
LogoImg.Parent = LogoFrame

local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(1, 0, 1, 0)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Text = ""
LogoBtn.ZIndex = 5
LogoBtn.Parent = LogoFrame

do
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    LogoBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragInput, dragStart, startPos = true, input, input.Position, LogoFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            LogoFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end)
end

local uiVisible = true
local minimizeKey = Enum.KeyCode.LeftControl
local lastToggleTime = 0

local function toggleUI()
    local now = tick()
    if now - lastToggleTime < 0.3 then return end
    lastToggleTime = now
    uiVisible = not uiVisible
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, desc in ipairs(gui:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text == "StarCrowHub" then
                    local p = desc.Parent
                    while p and p.Parent ~= gui do p = p.Parent end
                    if p and p:IsA("Frame") then p.Visible = uiVisible return end
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == minimizeKey then
        uiVisible = not uiVisible
    end
end)

local clickStartPos = Vector2.new()
LogoBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        clickStartPos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)
LogoBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local dist = (Vector2.new(input.Position.X, input.Position.Y) - clickStartPos).Magnitude
        if dist < 10 then
            toggleUI()
        end
    end
end)

local function applyInstantPrompt(prompt)
    if not prompt:GetAttribute("OriginalHold") then
        prompt:SetAttribute("OriginalHold", prompt.HoldDuration)
    end
    prompt.HoldDuration = 0
end

local function restoreInstantPrompt(prompt)
    if prompt:GetAttribute("OriginalHold") then
        prompt.HoldDuration = prompt:GetAttribute("OriginalHold")
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if Config.InstantPromptEnabled and descendant:IsA("ProximityPrompt") then
        applyInstantPrompt(descendant)
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Config.InstantPromptEnabled and fireproximityprompt then
        fireproximityprompt(prompt)
    end
end)

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                local head = char.Head
                local esp = head:FindFirstChild("StarCrowESP")
                local chams = char:FindFirstChild("StarCrowChams")

                if Config.ESPEnabled and hum.Health > 0 then
                    if not esp then
                        esp = Instance.new("BillboardGui")
                        esp.Name = "StarCrowESP"
                        esp.Adornee = head
                        esp.Size = UDim2.new(0, 350, 0, 30)
                        esp.StudsOffset = Vector3.new(0, 1.2, 0)
                        esp.AlwaysOnTop = true
                        esp.MaxDistance = math.huge
                        local text = Instance.new("TextLabel")
                        text.Name = "NameText"
                        text.Parent = esp
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextScaled = false
                        text.TextSize = 12
                        text.Font = Enum.Font.GothamBold
                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                        text.TextStrokeTransparency = 0
                        text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        text.RichText = true
                        esp.Parent = head
                    end
                    local dist = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
                    local hp = math.floor((hum.Health / hum.MaxHealth) * 100)
                    local teamColor = Color3.fromRGB(255, 255, 255)
                    local tR, tG, tB = 255, 255, 255
                    if player.Team then
                        local tc = player.Team.TeamColor.Color
                        teamColor = tc
                        tR, tG, tB = math.floor(tc.R*255), math.floor(tc.G*255), math.floor(tc.B*255)
                    end
                    local hpColor = hp > 70 and "rgb(0, 255, 127)" or hp > 30 and "rgb(255, 200, 0)" or "rgb(255, 50, 50)"
                    esp.NameText.Text = string.format('<font color="rgb(%d,%d,%d)">%s</font> | %dm | <font color="%s">%d%%</font>', tR, tG, tB, player.DisplayName, dist, hpColor, hp)
                    
                    if not chams then
                        chams = Instance.new("Highlight")
                        chams.Name = "StarCrowChams"
                        chams.Parent = char
                    end
                    chams.FillColor = teamColor
                    chams.OutlineColor = teamColor
                    chams.FillTransparency = 0.7
                    chams.OutlineTransparency = 0
                    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    if esp then esp:Destroy() end
                    if chams then chams:Destroy() end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
    updateESP()
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if Config.NoclipEnabled then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and Config.LoopSpeedEnabled then hum.WalkSpeed = Config.WalkSpeed end
    end
    
    if Config.NoFogEnabled then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
        local atm = Lighting:FindFirstChildWhichIsA("Atmosphere")
        if atm then
            atm.Density = 0
        end
    end
    
    if Config.FullBrightEnabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

local AUTOCLICK_DELAY_PC = 0.15
local AUTOCLICK_DELAY_MOBILE = 0.08
local autoClickRunning = false

local function doGlobalClick()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local x = math.floor(vp.X * 0.78)
    local y = math.floor(vp.Y * 0.82)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
end

local function activateHeldTool()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return false end
    pcall(function() tool:Activate() end)
    return true
end

local function stopAutoClick()
    autoClickRunning = false
end

local function startAutoClick()
    stopAutoClick()
    autoClickRunning = true
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    task.spawn(function()
        while autoClickRunning do
            if uiVisible then
                task.wait(0.1)
            else
                if isMobile then
                    local usedTool = activateHeldTool()
                    task.wait(usedTool and AUTOCLICK_DELAY_MOBILE or 0.15)
                else
                    doGlobalClick()
                    task.wait(AUTOCLICK_DELAY_PC)
                end
            end
        end
    end)
end

local flyConnection = nil
local jumpStateConnection = nil

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 1e7
    bg.D = 12000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    jumpStateConnection = humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Jumping
        or new == Enum.HumanoidStateType.Freefall then
            humanoid.PlatformStand = true
        end
    end)

    flyConnection = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        local md = humanoid.MoveDirection

        if md.Magnitude > 0 then
            local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
            local flatRight = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)

            if flatLook.Magnitude > 0.01 and flatRight.Magnitude > 0.01 then
                local fwdAmt = md:Dot(flatLook.Unit)
                local rightAmt = md:Dot(flatRight.Unit)

                move += cam.CFrame.LookVector * fwdAmt
                move += cam.CFrame.RightVector * rightAmt
            end
        end

        if move.Magnitude > 0 then move = move.Unit end
        bv.Velocity = move * Config.FlySpeed * 50
        local look = cam.CFrame.LookVector
        bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + look, Vector3.new(0, 1, 0))
    end)
end

local function stopFly()
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    if humanoid then humanoid.PlatformStand = false end
    if jumpStateConnection then
        jumpStateConnection:Disconnect()
        jumpStateConnection = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
        end
    end
end

local autoEquipping = false
local function isMelee(tool)
    local cfg = tool:FindFirstChildOfClass("Configuration")
    return cfg and cfg:GetAttribute("Type") == "Melee"
end
--important implement.
local function equipAllMelee(source)
    if not Config.StackWeapon or autoEquipping or uiVisible then return end
    autoEquipping = true
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if backpack and character then
        for _, tool in backpack:GetChildren() do
            if tool:IsA("Tool") and tool ~= source and isMelee(tool) then
                tool.Parent = character
            end
        end
    end
    autoEquipping = false
end

local function unequipAllMelee(source)
    if not Config.StackWeapon or autoEquipping then return end
    autoEquipping = true
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if backpack and character then
        for _, tool in character:GetChildren() do
            if tool:IsA("Tool") and tool ~= source and isMelee(tool) then
                tool.Parent = backpack
            end
        end
    end
    autoEquipping = false
end

local function watchTool(tool)
    if not tool:IsA("Tool") or not isMelee(tool) then return end
    tool.Equipped:Connect(function() equipAllMelee(tool) end)
    tool.Unequipped:Connect(function() unequipAllMelee(tool) end)
end

local function initStackWeapon()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if backpack then
        for _, tool in backpack:GetChildren() do watchTool(tool) end
        backpack.ChildAdded:Connect(watchTool)
    end
    if character then
        for _, tool in character:GetChildren() do watchTool(tool) end
    end
end

initStackWeapon()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    initStackWeapon()
    if Config.FlyEnabled then startFly() end
end)
--
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

    local originalMeleeHit
    originalMeleeHit = hookfunction(Remotes.RegisterMeleeHit.fireServer, function(...)
        local args = {...}

            task.spawn(function()
                for i = 1, 200 - 1 do
                    task.wait(0.03)
                    originalMeleeHit(unpack(args))
                end
            end)
        
        return originalMeleeHit(...)
    end)
end)
--


    local originalLaserHit
    originalLaserHit = hookfunction(Remotes.RegisterLaser.fireServer, function(...)
        local args = {...}
        if Config.FastAttackEnabled then
            task.spawn(function()
                for i = 1, Config.FastAttackMultiplier - 1 do
                    task.wait(0.03)
                    originalLaserHit(unpack(args))
                end
            end)
        end
        return originalLaserHit(...)
    end)
end)

local npcs = {}
local origSizes = {}

local function isValidNPC(model)
    if not model or not model.Parent then return false end
    if not model:IsA("Model") then return false end
    if model == LocalPlayer.Character then return false end
    if Players:GetPlayerFromCharacter(model) then return false end

    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    if not hum or not root then return false end
    if hum.Health <= 0 or hum.MaxHealth <= 0 then return false end
    if root.Anchored then return false end

    return true
end

local function cleanupNPC(npc)
    local data = npcs[npc]
    if not data then return end
    if data.connection then data.connection:Disconnect() end
    local head = data.head
    if head and head.Parent then
        head.Size = origSizes[head] or Vector3.new(2,1,1)
        head.Transparency = 0
        head.CanCollide = true
        head.Massless = false
        
        local outline = head:FindFirstChild("StarCrowHitboxOutline")
        if outline then outline:Destroy() end
    end
    origSizes[head] = nil
    npcs[npc] = nil
end

local function applyHitbox(npc)
    if not isValidNPC(npc) then return end
    if npcs[npc] then return end

    local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
    local hum = npc:FindFirstChildOfClass("Humanoid")

    if not head or not hum then return end

    origSizes[head] = head.Size

    local outline = Instance.new("SelectionBox")
    outline.Name = "StarCrowHitboxOutline"
    outline.Color3 = Color3.fromRGB(255, 50, 50) 
    outline.LineThickness = 0.05 
    outline.Transparency = 0.5 
    outline.SurfaceTransparency = 1 
    outline.Adornee = head
    outline.Parent = head

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Config.NPCHitboxEnabled or not npc.Parent or hum.Health <= 0 then
            cleanupNPC(npc)
            return
        end

        local wanted = Vector3.new(Config.NPCHitboxSize, Config.NPCHitboxSize, Config.NPCHitboxSize)
        if head.Size ~= wanted then
            head.Size = wanted
            head.Transparency = 1 
            head.CanCollide = false
            head.Massless = true
        end
    end)

    npcs[npc] = {
        head = head,
        connection = connection
    }
end

local function scanNPCs()
    for _, v in ipairs(workspace:GetDescendants()) do
        if isValidNPC(v) then
            applyHitbox(v)
        end
    end
end

local function clearHitbox()
    for npc in pairs(npcs) do
        cleanupNPC(npc)
    end
end

task.spawn(function()
    while task.wait(1) do
        if Config.NPCHitboxEnabled then
            scanNPCs()
        end
    end
end)


local activeNPCESP = {}

local function getNPCColor(npc)
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then return hrp.Color end
    for _, part in ipairs(npc:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            return part.Color
        end
    end
    return Color3.fromRGB(255, 100, 100)
end

local function setupNPCESP(npc)
    if not isValidNPC(npc) then return end
    if activeNPCESP[npc] then return end

    local hum = npc:FindFirstChildOfClass("Humanoid")
    local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
    if not hum or not root then return end

    local npcColor = getNPCColor(npc)

    local highlight = Instance.new("Highlight")
    highlight.Name = "StarCrowNPCChams"
    highlight.FillColor = Color3.fromRGB(0, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(220, 80, 80)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = Config.NPCESPEnabled
    highlight.Parent = npc

    activeNPCESP[npc] = {
        highlight = highlight,
        hum = hum
    }
end

local function cleanupNPCESP(npc)
    local data = activeNPCESP[npc]
    if not data then return end
    pcall(function() data.highlight:Destroy() end)
    activeNPCESP[npc] = nil
end

local function updateNPCESP()
    for npc, data in pairs(activeNPCESP) do
        if not npc or not npc.Parent or data.hum.Health <= 0 then
            cleanupNPCESP(npc)
        else
            local on = Config.NPCESPEnabled
            data.highlight.Enabled = on
        end
    end
end

local function scanNPCESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if isValidNPC(v) then
            setupNPCESP(v)
        end
    end
end

workspace.DescendantAdded:Connect(function(v)
    task.wait(0.2)
    if Config.NPCESPEnabled and isValidNPC(v) then
        setupNPCESP(v)
    end
end)

task.spawn(function()
    while task.wait(2) do
        if Config.NPCESPEnabled then
            scanNPCESP()
        end
    end
end)

local targetItems = { ["Burger"] = true, ["GoldenBurger"] = true, ["DiamondBurger"] = true }
local burgerColors = { ["Burger"] = Color3.fromRGB(205, 133, 63), ["GoldenBurger"] = Color3.fromRGB(255, 215, 0), ["DiamondBurger"] = Color3.fromRGB(0, 255, 255) }

local itemQueue = {}
local activeBurgers = {}
local currentTarget = nil
local processTimer = 0

local function isValidItem(obj)
    if not obj or not obj.Parent then return false end
    if not targetItems[obj.Name] then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then return false end
    if obj:FindFirstAncestorWhichIsA("Configuration") then return false end
    if obj:FindFirstAncestorWhichIsA("Tool") then return false end
    if obj:FindFirstAncestorWhichIsA("Accessory") then return false end
    return true
end

local function buildBurgerESP(obj)
    local old = obj:FindFirstChild("StarCrowBurgerESP")
    if old then old:Destroy() end

    local espFolder = Instance.new("Folder")
    espFolder.Name = "StarCrowBurgerESP"
    espFolder.Parent = obj

    local highlight = Instance.new("Highlight")
    highlight.Name = "Chams"
    highlight.FillColor = burgerColors[obj.Name] or Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.2
    highlight.Enabled = Config.BurgerESPEnabled
    highlight.Parent = espFolder

    local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
    if not targetPart and obj:IsA("Model") then targetPart = obj:FindFirstChildWhichIsA("BasePart") end

    if targetPart then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Text"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 5000
        billboard.Adornee = targetPart
        billboard.Enabled = Config.BurgerESPEnabled

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = obj.Name
        label.TextColor3 = burgerColors[obj.Name] or Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = billboard
        billboard.Parent = espFolder
    end
end

local function setupBurgerESP(obj)
    if not isValidItem(obj) then return end
    local found = false
    for _, v in ipairs(activeBurgers) do
        if v == obj then found = true break end
    end
    if not found then table.insert(activeBurgers, obj) end
    buildBurgerESP(obj)
end

local function addToQueue(obj)
    if isValidItem(obj) then
        for _, v in ipairs(itemQueue) do if v == obj then return end end
        table.insert(itemQueue, obj)
        setupBurgerESP(obj)
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do addToQueue(obj) end
workspace.DescendantAdded:Connect(addToQueue)

local function updateBurgerESP()
    for i = #activeBurgers, 1, -1 do
        local obj = activeBurgers[i]
        if not obj or not obj.Parent then
            table.remove(activeBurgers, i)
        else
            local espFolder = obj:FindFirstChild("StarCrowBurgerESP")
            if not espFolder then
                buildBurgerESP(obj)
                espFolder = obj:FindFirstChild("StarCrowBurgerESP")
            end
            if espFolder then
                local highlight = espFolder:FindFirstChild("Chams")
                if highlight then highlight.Enabled = Config.BurgerESPEnabled end
                local billboard = espFolder:FindFirstChild("Text")
                if billboard then
                    billboard.Enabled = Config.BurgerESPEnabled
                    if Config.BurgerESPEnabled then
                        local label = billboard:FindFirstChildWhichIsA("TextLabel")
                        local targetPart = billboard.Adornee
                        if label and targetPart and Camera then
                            local dist = math.floor((Camera.CFrame.Position - targetPart.Position).Magnitude)
                            label.Text = string.format("%s\n[%dm]", obj.Name, dist)
                        end
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function(deltaTime)
    updateBurgerESP()
    updateNPCESP()

    if not Config.BringBurger then return end

    if not isValidItem(currentTarget) then
        if #itemQueue > 0 then
            currentTarget = table.remove(itemQueue, 1)
            processTimer = 0
        else
            currentTarget = nil
        end
    end

    if currentTarget then
        local targetCFrame = Camera.CFrame * CFrame.new(0, 0, -2.5)

        if currentTarget:IsA("Model") then
            currentTarget:PivotTo(targetCFrame)
        elseif currentTarget:IsA("BasePart") then
            currentTarget.CFrame = targetCFrame
        end

        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

        processTimer = processTimer + deltaTime
        if processTimer > 0.2 then
            currentTarget = nil
            processTimer = 0
        end
    end
end)

local bosses = {
    {n = "mastersamurai", pos = CFrame.new(103.27, 40.89, -3560.05)},
    {n = "eldervampire", pos = CFrame.new(165.61, 3.00, 5058.65)},
    {n = "gnomechampion", pos = CFrame.new(37.76, 3.00, 13993.09)},
    {n = "steamborneczar", pos = CFrame.new(-15.31, 3.02, 27032.90)},
    {n = "kingice", pos = CFrame.new(24.27, 3.00, 45907.91)}
}

local skyIslandPos = CFrame.new(64.97, 3.00, 34971.64)
local currentIdx = 1
local hoverPos = nil
local visited = false
local engaged = false
local visitedSkyIsland = false

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and hoverPos and Config.AutoFarmEnabled then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hoverPos
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not Config.AutoFarmEnabled or uiVisible then continue end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, v in ipairs(pg:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then
                    local text = string.lower(v.Text or "")
                    if string.find(text, "play again") then
                        local targetBtn = v:IsA("TextButton") and v or v.Parent
                        if targetBtn and targetBtn:IsA("GuiButton") and targetBtn.Visible then
                            pcall(function()
                                if getconnections then
                                    for _, e in ipairs(getconnections(targetBtn.MouseButton1Click)) do e:Fire() end
                                    for _, e in ipairs(getconnections(targetBtn.MouseButton1Down)) do e:Fire() end
                                end
                                if firesignal then
                                    firesignal(targetBtn.MouseButton1Click)
                                    firesignal(targetBtn.MouseButton1Down)
                                end
                                
                                local absPos = targetBtn.AbsolutePosition
                                local absSize = targetBtn.AbsoluteSize
                                local inset = GuiService:GetGuiInset()
                                local cx = absPos.X + (absSize.X / 2)
                                local cy = absPos.Y + (absSize.Y / 2) + inset.Y
                                
                                VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                                task.wait(0.1)
                                VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if not Config.AutoFarmEnabled then 
            hoverPos = nil
            continue 
        end
        
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if hrp and hum then
                if hum.Health <= 0 then
                    hoverPos = nil
                    visited = false
                    engaged = false
                    visitedSkyIsland = false
                    currentIdx = 1
                    task.wait(1)
                else
                    if currentIdx <= #bosses then
                        local info = bosses[currentIdx]
                        local targetBoss = nil

                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
                                local name = string.gsub(string.lower(v.Name), "%s+", "")
                                if string.find(name, info.n) then
                                    local bHum = v:FindFirstChildOfClass("Humanoid")
                                    if bHum.Health > 0 then
                                        targetBoss = v
                                        break
                                    end
                                end
                            end
                        end

                        if targetBoss then
                            local bHrp = targetBoss:FindFirstChild("HumanoidRootPart")
                            if bHrp then
                                if not visited then
                                    hoverPos = nil
                                    hrp.CFrame = info.pos
                                    hrp.Anchored = true
                                    task.wait(2)
                                    hrp.Anchored = false
                                    visited = true
                                end
                                
                                engaged = true
                                hoverPos = CFrame.lookAt(info.pos.Position + Vector3.new(0, 15, 0), info.pos.Position)
                                
                                bHrp.CFrame = CFrame.new(info.pos.Position)
                                bHrp.Velocity = Vector3.new(0, 0, 0)
                                
                                local tool = char:FindFirstChildOfClass("Tool")
                                if not tool or not isMelee(tool) then
                                    for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                        if t:IsA("Tool") and isMelee(t) then
                                            t.Parent = char
                                            break
                                        end
                                    end
                                end
                            end
                        else
                            if engaged then
                                task.wait(3)
                                engaged = false
                                visited = false
                                hoverPos = nil
                                currentIdx = currentIdx + 1
                            else
                                if not visited then
                                    hoverPos = nil
                                    hrp.CFrame = info.pos
                                    hrp.Anchored = true
                                    task.wait(2)
                                    hrp.Anchored = false
                                    visited = true
                                end
                                hoverPos = CFrame.new(info.pos.Position + Vector3.new(0, 15, 0))
                            end
                        end
                    else
                        if not visitedSkyIsland then
                            hoverPos = nil
                            hrp.CFrame = skyIslandPos
                            hrp.Anchored = true
                            task.wait(2)
                            hrp.Anchored = false
                            visitedSkyIsland = true
                            hoverPos = skyIslandPos
                        end

                        if #itemQueue == 0 and currentTarget == nil then
                            task.wait(3)
                            if #itemQueue == 0 and currentTarget == nil then
                                hoverPos = nil
                                visitedSkyIsland = false
                                currentIdx = 1
                                
                                task.spawn(function()
                                    pcall(function()
                                        local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))
                                        Remotes.Reset.fireServer()
                                    end)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local function teleportPlayer(cframePos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframePos
    end
end

local Window = Fluent:CreateWindow({
    Title = "StarCrowHub",
    SubTitle = "Dead Spells",
    TabWidth = 130,
    Size = UDim2.fromOffset(460, 400),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local FastAttackToggleObj, FastAttackSliderObj, NPCHitboxToggleObj, NPCHitboxSliderObj, BringBurgerToggleObj
local _autoFarmReady = false

Tabs.Info:AddParagraph({
    Title = "Join our Discord",
    Content = "Discord is the best place to get updates and report bugs."
})

Tabs.Info:AddButton({
    Title = "Copy Discord Link",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/4xMFad5He")
            Fluent:Notify({ Title = "Copied!", Content = "Discord link copied to clipboard.", Duration = 3 })
        end)
    end
})

Tabs.Main:AddSection("Auto Farm")
Tabs.Main:AddParagraph({
    Title = "Auto Farm",
    Content = "You need a class that has a sword or any melee weapon to use Auto Farm Magic staves do not work"
})

Tabs.Main:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = Config.AutoFarmEnabled,
    Callback = function(Value)
        Config.AutoFarmEnabled = Value
        if Value then
            Config.FastAttackEnabled = true
            Config.FastAttackMultiplier = 200
            Config.NPCHitboxEnabled = true
            Config.NPCHitboxSize = 200
            Config.BringBurger = true
            
            if FastAttackToggleObj then FastAttackToggleObj:SetValue(true) end
            if FastAttackSliderObj then FastAttackSliderObj:SetValue(200) end
            if NPCHitboxToggleObj then NPCHitboxToggleObj:SetValue(true) end
            if NPCHitboxSliderObj then NPCHitboxSliderObj:SetValue(200) end
            if BringBurgerToggleObj then BringBurgerToggleObj:SetValue(true) end

            if _autoFarmReady then
                startAutoClick()
                if uiVisible then
                    task.wait(0.2)
                    toggleUI()
                end
            end
        else
            if _autoFarmReady then
                stopAutoClick()
            end
        end
        SaveConfig()
    end
})

_autoFarmReady = true

if Config.AutoFarmEnabled then
    startAutoClick()
end

Tabs.Main:AddSection("Combat")

Tabs.Main:AddToggle("StackWeaponToggle", {
    Title = "Stack Weapon",
    Default = Config.StackWeapon,
    Callback = function(Value)
        Config.StackWeapon = Value
        SaveConfig()
    end
})

FastAttackToggleObj = Tabs.Main:AddToggle("FastAttackToggle", {
    Title = "Fast Attack",
    Default = Config.FastAttackEnabled,
    Callback = function(Value)
        Config.FastAttackEnabled = Value
        SaveConfig()
    end
})

FastAttackSliderObj = Tabs.Main:AddSlider("FastAttackSlider", {
    Title = "Fast Attack",
    Default = Config.FastAttackMultiplier,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.FastAttackMultiplier = Value
        SaveConfig()
    end
})

Tabs.Main:AddSection("NPC Hitbox")

NPCHitboxToggleObj = Tabs.Main:AddToggle("NPCHitboxToggle", {
    Title = "Enable NPC Hitbox",
    Default = Config.NPCHitboxEnabled,
    Callback = function(Value)
        Config.NPCHitboxEnabled = Value
        SaveConfig()
        if not Value then
            clearHitbox()
        end
    end
})

NPCHitboxSliderObj = Tabs.Main:AddSlider("NPCHitboxSlider", {
    Title = "NPC Hitbox Size",
    Default = Config.NPCHitboxSize,
    Min = 2,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        Config.NPCHitboxSize = Value
        SaveConfig()
    end
})

Tabs.ESP:AddToggle("ESPPlayers", {
    Title = "ESP Players",
    Default = Config.ESPEnabled,
    Callback = function(Value)
        Config.ESPEnabled = Value
        SaveConfig()
    end
})

Tabs.ESP:AddToggle("ESPBurgersToggle", {
    Title = "ESP Burgers",
    Default = Config.BurgerESPEnabled,
    Callback = function(Value)
        Config.BurgerESPEnabled = Value
        SaveConfig()
        for _, obj in ipairs(activeBurgers) do
            if obj and obj.Parent then
                local espFolder = obj:FindFirstChild("StarCrowBurgerESP")
                if espFolder then
                    for _, child in ipairs(espFolder:GetChildren()) do
                        if child:IsA("Highlight") or child:IsA("BillboardGui") then
                            child.Enabled = Value
                        end
                    end
                end
            end
        end
    end
})


Tabs.ESP:AddToggle("ESPNPCToggle", {
    Title = "ESP NPC",
    Default = Config.NPCESPEnabled,
    Callback = function(Value)
        Config.NPCESPEnabled = Value
        SaveConfig()
        if Value then
            scanNPCESP()
        else
            for npc in pairs(activeNPCESP) do
                cleanupNPCESP(npc)
            end
        end
    end
})

Tabs.Player:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = Config.FlyEnabled,
    Callback = function(Value)
        Config.FlyEnabled = Value
        SaveConfig()
        if Value then
            startFly()
        else
            stopFly()
        end
    end
})

Tabs.Player:AddSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Default = Config.FlySpeed,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        Config.FlySpeed = Value
        SaveConfig()
    end
})

Tabs.Player:AddToggle("LoopSpeedToggle", {
    Title = "Enable WalkSpeed",
    Default = Config.LoopSpeedEnabled,
    Callback = function(Value)
        Config.LoopSpeedEnabled = Value
        SaveConfig()
    end
})

Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "Speed Amount",
    Default = Config.WalkSpeed,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Callback = function(Value)
        Config.WalkSpeed = Value
        SaveConfig()
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = Config.NoclipEnabled,
    Callback = function(Value)
        Config.NoclipEnabled = Value
        SaveConfig()
    end
})

Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = Config.InfJumpEnabled,
    Callback = function(Value)
        Config.InfJumpEnabled = Value
        SaveConfig()
    end
})

Tabs.Teleport:AddParagraph({ Title = "Locations", Content = "Select a location below to instantly teleport your character" })

Tabs.Teleport:AddSection("Sky Island")
Tabs.Teleport:AddButton({ Title = "Sky Island", Callback = function() teleportPlayer(CFrame.new(64.97, 3.00, 34971.64)) end })

Tabs.Teleport:AddSection("Castles")
local tpLocations = {
    {"Castle 1", Vector3.new(44.00, 3.52, -39978.82)}, {"Castle 2", Vector3.new(33.43, 3.00, -29972.26)},
    {"Castle 3", Vector3.new(41.05, 3.50, -19973.70)}, {"Castle 4", Vector3.new(41.75, 3.50, -9980.53)},
    {"Castle 5", Vector3.new(39.04, 3.56, 23.96)}, {"Castle 6", Vector3.new(41.47, 3.50, 10020.76)},
    {"Castle 7", Vector3.new(39.80, 3.50, 20024.25)}, {"Castle 8", Vector3.new(37.93, 3.59, 30015.68)},
    {"Castle 9", Vector3.new(39.13, 3.56, 40019.69)}, {"Final Castle", Vector3.new(7.80, 3.00, 46854.27)}
}
for _, loc in ipairs(tpLocations) do
    Tabs.Teleport:AddButton({ Title = loc[1], Callback = function() teleportPlayer(CFrame.new(loc[2])) end })
end

Tabs.Teleport:AddSection("Boss Locations")
local bossLocations = {
    {"Master Samurai", Vector3.new(103.27, 40.89, -3560.05)}, {"Elder Vampire", Vector3.new(165.61, 3.00, 5058.65)},
    {"Gnome", Vector3.new(37.76, 3.00, 13993.09)}, {"Steam Punk", Vector3.new(-15.31, 3.02, 27032.90)},
    {"King Ice", Vector3.new(24.27, 3.00, 45907.91)}
}
for _, loc in ipairs(bossLocations) do
    Tabs.Teleport:AddButton({ Title = loc[1], Callback = function() teleportPlayer(CFrame.new(loc[2])) end })
end

BringBurgerToggleObj = Tabs.Misc:AddToggle("BringBurgerToggle", {
    Title = "Bring Burger+ Auto Collect",
    Default = Config.BringBurger,
    Callback = function(Value)
        Config.BringBurger = Value
        SaveConfig()
    end
})

Tabs.Misc:AddToggle("NoFogToggle", {
    Title = "Loop No Fog",
    Default = Config.NoFogEnabled,
    Callback = function(Value)
        Config.NoFogEnabled = Value
        SaveConfig()
    end
})

Tabs.Misc:AddToggle("FullBrightToggle", {
    Title = "Loop Full Bright",
    Default = Config.FullBrightEnabled,
    Callback = function(Value)
        Config.FullBrightEnabled = Value
        SaveConfig()
    end
})

Tabs.Misc:AddToggle("InstantPromptToggle", {
    Title = "Instant Interact",
    Default = Config.InstantPromptEnabled,
    Callback = function(Value)
        Config.InstantPromptEnabled = Value
        SaveConfig()
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                if Value then
                    applyInstantPrompt(prompt)
                else
                    restoreInstantPrompt(prompt)
                end
            end
        end
    end
})

Tabs.Misc:AddSection("Camera Mode")
Tabs.Misc:AddButton({
    Title = "First Person Camera",
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 0.5
    end
})

Tabs.Misc:AddButton({
    Title = "Third Person Camera",
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 1000
    end
})

Tabs.Settings:AddKeybind("ToggleUIKeybind", {
    Title = "Minimize UI Keybind",
    Mode = "Toggle",
    Default = "LeftControl",
    ChangedCallback = function(NewKey)
        local keyCode = typeof(NewKey) == "EnumItem" and NewKey or Enum.KeyCode[tostring(NewKey)] or Enum.KeyCode.LeftControl
        minimizeKey = keyCode
        Window.MinimizeKey = keyCode
    end
})

Window:SelectTab(1) 