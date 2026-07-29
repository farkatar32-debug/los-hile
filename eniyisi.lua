-- ===================================================================
-- ULTIMATE UNIVERSAL PRO – SPIN EDITION
-- Tüm Klasik Hileler + Ayarlanabilir Spin | Animasyonlu | Profesyonel
-- ===================================================================

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")

-- ============================
-- DEĞİŞKENLER
-- ============================
local walkSpeed = 16
local flySpeed = 50
local flyActive = false
local flyBodyVelocity = nil
local flyConnection = nil

local infiniteJumpActive = false
local noclipActive = false
local noclipConnections = {}

local godModeActive = false
local godModeConnections = {}

local aimbotActive = false
local aimbotConnection = nil

local hitboxActive = false
local hitboxSize = 1

local autoFarmActive = false
local autoFarmConnection = nil

local btoolsActive = false

local teleportActive = false

local spinActive = false
local spinSpeed = 1
local spinConnection = nil

local isMinimized = false

-- ============================
-- KARAKTER FONKSİYONLARI
-- ============================
local function getCharacter()
    local char = player.Character
    if char and char.Parent then return char end
    return nil
end

local function getHRP()
    local char = getCharacter()
    if char then return char:FindFirstChild("HumanoidRootPart") end
    return nil
end

local function getHumanoid()
    local char = getCharacter()
    if char then return char:FindFirstChild("Humanoid") end
    return nil
end

-- ============================
-- HIZ
-- ============================
local function setSpeed(value)
    walkSpeed = value
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = value end
end

-- ============================
-- UÇUŞ
-- ============================
local function startFly()
    if flyActive then return end
    flyActive = true
    local hrp = getHRP()
    if not hrp then return end
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    flyConnection = runService.Heartbeat:Connect(function()
        if not flyActive or not flyBodyVelocity or not flyBodyVelocity.Parent then
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        local move = Vector3.new(0, 0, 0)
        if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
        if userInput:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
        if userInput:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then
            move = move.Unit * flySpeed
            local cam = workspace.CurrentCamera
            if cam then move = cam.CFrame:VectorToWorldSpace(move) end
            flyBodyVelocity.Velocity = move
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFly()
    flyActive = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- ============================
-- SINIRSIZ ZIPLAMA
-- ============================
local function enableInfiniteJump()
    infiniteJumpActive = true
    local hum = getHumanoid()
    if hum then hum.JumpPower = 100 end
    userInput.JumpRequest:Connect(function()
        if infiniteJumpActive then
            local hum2 = getHumanoid()
            if hum2 then hum2:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

local function disableInfiniteJump()
    infiniteJumpActive = false
    local hum = getHumanoid()
    if hum then hum.JumpPower = 50 end
end

-- ============================
-- NOCLIP
-- ============================
local function enableNoclip()
    for _, conn in ipairs(noclipConnections) do conn:Disconnect() end
    noclipConnections = {}
    local char = getCharacter()
    if not char then return end
    local function setNoCollide(part)
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    for _, part in ipairs(char:GetDescendants()) do setNoCollide(part) end
    local conn = char.DescendantAdded:Connect(setNoCollide)
    table.insert(noclipConnections, conn)
    local conn2 = player.CharacterAdded:Connect(function(newChar)
        if noclipActive then
            task.wait(0.5)
            for _, part in ipairs(newChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            local conn3 = newChar.DescendantAdded:Connect(setNoCollide)
            table.insert(noclipConnections, conn3)
        end
    end)
    table.insert(noclipConnections, conn2)
end

local function disableNoclip()
    noclipActive = false
    for _, conn in ipairs(noclipConnections) do conn:Disconnect() end
    noclipConnections = {}
    local char = getCharacter()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ============================
-- GOD MODE
-- ============================
local function enableGodMode()
    for _, conn in ipairs(godModeConnections) do conn:Disconnect() end
    godModeConnections = {}
    local hum = getHumanoid()
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        local conn = hum.Changed:Connect(function(prop)
            if prop == "Health" and hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
        table.insert(godModeConnections, conn)
    end
    local conn2 = player.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        local newHum = newChar:WaitForChild("Humanoid")
        if newHum and godModeActive then
            newHum.MaxHealth = math.huge
            newHum.Health = math.huge
            local conn3 = newHum.Changed:Connect(function(prop)
                if prop == "Health" and newHum and newHum.Health < newHum.MaxHealth then
                    newHum.Health = newHum.MaxHealth
                end
            end)
            table.insert(godModeConnections, conn3)
        end
    end)
    table.insert(godModeConnections, conn2)
end

local function disableGodMode()
    godModeActive = false
    for _, conn in ipairs(godModeConnections) do conn:Disconnect() end
    godModeConnections = {}
    local hum = getHumanoid()
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
    end
end

-- ============================
-- AIMBOT
-- ============================
local function enableAimbot()
    if aimbotActive then return end
    aimbotActive = true
    aimbotConnection = runService.Heartbeat:Connect(function()
        if not aimbotActive then return end
        local hrp = getHRP()
        if not hrp then return end
        local target = nil
        local dist = math.huge
        for _, plr in ipairs(players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local d = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d target = plr.Character.HumanoidRootPart end
            end
        end
        if target then
            local cam = workspace.CurrentCamera
            if cam then
                local direction = (target.Position - cam.CFrame.Position).Unit
                cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + direction * 100)
            end
        end
    end)
end

local function disableAimbot()
    aimbotActive = false
    if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
end

-- ============================
-- HITBOX GENİŞLETME
-- ============================
local function setHitboxSize(value)
    hitboxSize = value
    local char = getCharacter()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * hitboxSize
            end
        end
    end
end

-- ============================
-- OTOMATİK ÇİFTLİK
-- ============================
local function enableAutoFarm()
    if autoFarmActive then return end
    autoFarmActive = true
    autoFarmConnection = runService.Heartbeat:Connect(function()
        if not autoFarmActive then return end
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1,1), 0, math.random(-1,1))
        end
    end)
end

local function disableAutoFarm()
    autoFarmActive = false
    if autoFarmConnection then autoFarmConnection:Disconnect() autoFarmConnection = nil end
end

-- ============================
-- BTOOLS
-- ============================
local function enableBtools()
    btoolsActive = true
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local tool1 = Instance.new("Tool")
        tool1.Name = "Destroy Tool"
        tool1.RequiresHandle = false
        tool1.Parent = backpack
        tool1.Activated:Connect(function()
            if mouse.Target then mouse.Target:Destroy() end
        end)
        local tool2 = Instance.new("Tool")
        tool2.Name = "Build Tool"
        tool2.RequiresHandle = false
        tool2.Parent = backpack
        tool2.Activated:Connect(function()
            local part = Instance.new("Part")
            part.Size = Vector3.new(4, 4, 4)
            part.Position = mouse.Hit.Position
            part.Anchored = true
            part.Parent = workspace
        end)
    end
end

local function disableBtools()
    btoolsActive = false
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name == "Destroy Tool" or tool.Name == "Build Tool") then
                tool:Destroy()
            end
        end
    end
end

-- ============================
-- TELEPORT
-- ============================
mouse.Button1Down:Connect(function()
    if teleportActive then
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- ============================
-- SPIN
-- ============================
local function startSpin()
    if spinActive then return end
    spinActive = true
    spinConnection = runService.Heartbeat:Connect(function()
        if not spinActive then return end
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end)
end

local function stopSpin()
    spinActive = false
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

-- ============================
-- ANTI-AFK (Otomatik)
-- ============================
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ============================
-- PROFESYONEL GUI
-- ============================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateUniversalPro"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 550)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 0, 3)
shadow.Position = UDim2.new(0, 0, 0, 0)
shadow.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

mainFrame.BackgroundTransparency = 1
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Ultimate Universal Pro"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar
minBtn.MouseEnter:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
minBtn.MouseLeave:Connect(function()
    tweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 200, 0, 40),
            Position = UDim2.new(1, -210, 0, 10)
        }):Play()
        minBtn.Text = "+"
    else
        tweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 420, 0, 550),
            Position = UDim2.new(0.5, -210, 0.5, -275)
        }):Play()
        minBtn.Text = "−"
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseEnter:Connect(function()
    tweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    tweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFly()
    if godModeActive then disableGodMode() end
    if noclipActive then disableNoclip() end
    if aimbotActive then disableAimbot() end
    if autoFarmActive then disableAutoFarm() end
    if btoolsActive then disableBtools() end
    if spinActive then stopSpin() end
    screenGui:Destroy()
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 720)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local yPos = 10

-- ============================
-- UI YARDIMCI FONKSİYONLAR
-- ============================
local function addCategory(text, y, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Position = UDim2.new(0, 0, 0, y)
    lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    lbl.BackgroundTransparency = 0.5
    lbl.Text = "  " .. text
    lbl.TextColor3 = color
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = scrollFrame
    return lbl
end

local function addLabel(text, y, color)
    color = color or Color3.fromRGB(200, 200, 220)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.9, 0, 0, 22)
    lbl.Position = UDim2.new(0.05, 0, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = scrollFrame
    return lbl
end

local function addSlider(labelText, min, max, default, color, callback)
    local y = yPos
    yPos = yPos + 45
    addLabel(labelText .. ": " .. default, y, color)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.8, 0, 0, 6)
    bg.Position = UDim2.new(0.05, 0, 0, y + 25)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    bg.BorderSizePixel = 0
    bg.Parent = scrollFrame
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(default/max, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = color
    fill.BorderSizePixel = 0
    fill.Parent = bg
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 16, 0, 16)
    btn.Position = UDim2.new(default/max, -8, 0.5, -8)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = bg
    local dragging = false
    local function update(value)
        value = math.clamp(value, min, max)
        fill.Size = UDim2.new(value/max, 0, 1, 0)
        btn.Position = UDim2.new(value/max, -8, 0.5, -8)
        callback(value)
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Position.Y.Offset == y and child.Text:find(labelText) then
                child.Text = labelText .. ": " .. math.floor(value)
            end
        end
    end
    btn.MouseButton1Down:Connect(function() dragging = true end)
    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    mouse.Move:Connect(function()
        if dragging then
            local mousePos = mouse.X
            local framePos = bg.AbsolutePosition.X
            local frameSize = bg.AbsoluteSize.X
            if frameSize > 0 then
                local percent = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                local value = percent * max
                update(value)
            end
        end
    end)
    return update
end

local function addToggle(labelText, default, color, callback)
    local y = yPos
    yPos = yPos + 30
    addLabel(labelText .. ": KAPALI", y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 24)
    btn.Position = UDim2.new(0.85, -60, 0, y - 2)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = "AÇ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = scrollFrame
    local active = default
    local function updateUI()
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(60, 60, 80)
        btn.Text = active and "KAPA" or "AÇ"
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.Position.Y.Offset == y and child.Text:find(labelText) then
                child.Text = labelText .. ": " .. (active and "AÇIK" or "KAPALI")
            end
        end
    end
    btn.MouseEnter:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 100)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(60, 60, 80)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        updateUI()
    end)
    updateUI()
    return btn
end

-- ============================
-- MENÜ ÖĞELERİ (Kategorilere Ayrılmış)
-- ============================

-- Kategori: Hareket
addCategory("🏃 HAREKET", yPos, Color3.fromRGB(100, 200, 255))
yPos = yPos + 30

addSlider("🏃 Hız", 1, 500, 16, Color3.fromRGB(0, 150, 255), function(val) setSpeed(val) end)

addSlider("✈️ Uçuş Hızı", 1, 500, 50, Color3.fromRGB(255, 100, 50), function(val) flySpeed = val end)

addToggle("🚀 Uçuş", false, Color3.fromRGB(255, 100, 50), function(val)
    if val then startFly() else stopFly() end
end)

addToggle("🌀 Sınırsız Zıplama", false, Color3.fromRGB(255, 200, 50), function(val)
    if val then enableInfiniteJump() else disableInfiniteJump() end
end)

addToggle("🌀 Noclip", false, Color3.fromRGB(255, 200, 50), function(val)
    noclipActive = val
    if val then enableNoclip() else disableNoclip() end
end)

addToggle("🌀 Tıkla Işınlan", false, Color3.fromRGB(255, 200, 50), function(val)
    teleportActive = val
end)

-- Kategori: Avcılık
addCategory("🎯 AVCILIK", yPos, Color3.fromRGB(255, 100, 100))
yPos = yPos + 30

addToggle("🎯 Aimbot", false, Color3.fromRGB(255, 50, 50), function(val)
    if val then enableAimbot() else disableAimbot() end
end)

addSlider("🎯 Hitbox Genişlik", 0.5, 3, 1, Color3.fromRGB(255, 50, 50), function(val)
    setHitboxSize(val)
end)

-- Kategori: Karakter
addCategory("🦸 KARAKTER", yPos, Color3.fromRGB(100, 255, 150))
yPos = yPos + 30

addToggle("🛡️ God Mode", false, Color3.fromRGB(100, 200, 255), function(val)
    godModeActive = val
    if val then enableGodMode() else disableGodMode() end
end)

-- Kategori: Mekanik
addCategory("🛠️ MEKANİK", yPos, Color3.fromRGB(255, 200, 150))
yPos = yPos + 30

addToggle("⚙️ Otomatik Çiftlik", false, Color3.fromRGB(255, 200, 150), function(val)
    if val then enableAutoFarm() else disableAutoFarm() end
end)

-- Kategori: Araçlar
addCategory("🧰 ARAÇLAR", yPos, Color3.fromRGB(150, 200, 255))
yPos = yPos + 30

addToggle("🧰 Btools (Yık/Yap)", false, Color3.fromRGB(150, 200, 255), function(val)
    if val then enableBtools() else disableBtools() end
end)

-- Kategori: Spin
addCategory("🌀 SPIN", yPos, Color3.fromRGB(255, 150, 255))
yPos = yPos + 30

addSlider("🌀 Spin Hızı", 0, 10, 1, Color3.fromRGB(255, 100, 200), function(val)
    spinSpeed = val
end)

addToggle("🌀 Spin (Dön)", false, Color3.fromRGB(255, 100, 200), function(val)
    if val then startSpin() else stopSpin() end
end)

-- ============================
-- MENÜYÜ TAŞIMA (DRAG)
-- ============================
local dragging = false
local dragStart, startPos

titleBar.MouseButton1Down:Connect(function(input)
    if input.Position.Y > 30 then return end
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

userInput.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================
-- ANTI-AFK (Otomatik)
-- ============================
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ============================
-- BİLDİRİM
-- ============================
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 400, 0, 50)
notification.Position = UDim2.new(0.5, -200, 0.08, 0)
notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
notification.BackgroundTransparency = 0.3
notification.Text = "⚡ Ultimate Universal Pro Yüklendi!"
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.TextScaled = true
notification.Font = Enum.Font.GothamBold
notification.Parent = screenGui
tweenService:Create(notification, TweenInfo.new(3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
task.wait(3)
notification:Destroy()

print("Ultimate Universal Pro – Spin Edition çalışıyor!")
