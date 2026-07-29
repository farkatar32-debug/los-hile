-- // Muscle Legends Ultimate Pro Script (Çalışan & Küçültmeli) // --
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

-- Hile durum değişkenleri
local autoFarm = false
local farmMethod = "Strength"
local autoTrain = false
local trainStat = "Strength"
local autoRebirth = false
local rebirthCount = 0
local speedEnabled = false
local flyEnabled = false
local noClipEnabled = false

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuscleLegendsPro"
screenGui.Parent = coreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 0)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(50, 50, 70)

-- Başlık çubuğu
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 0))
}
titleGrad.Rotation = 45

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -140, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "MUSCLE LEGENDS PRO"
titleLabel.Parent = titleBar

-- Buton container
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 105, 1, 0)
btnContainer.Position = UDim2.new(1, -110, 0, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = titleBar

-- Küçültme butonu
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0, 0, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = btnContainer
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Kapatma butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0, 35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = btnContainer
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Küçültme/Geri açma için değişken
local isMinimized = false
local fullSize = UDim2.new(0, 500, 0, 380)
local minSize = UDim2.new(0, 500, 0, 40)

-- Sekme çubuğu (ana içerik alanı)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 120, 1, -40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -120, 1, -40)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

-- İçerik temizleme
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
end

-- Yardımcı UI fonksiyonları
local function createToggle(parent, yOffset, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, yOffset)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", frame)
    st.Thickness = 0.5
    st.Color = Color3.fromRGB(60, 60, 80)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 70) or Color3.fromRGB(70, 70, 90)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 11)
    local btnGrad = Instance.new("UIGradient", toggleBtn)

    local enabled = default
    local function updateUI()
        if enabled then
            tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 70)}):Play()
            toggleBtn.Text = "ON"
            btnGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 130, 50))
            }
        else
            tweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
            toggleBtn.Text = "OFF"
            btnGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 110)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 70))
            }
        end
    end
    updateUI()

    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateUI()
        callback(enabled)
    end)
    return {frame = frame, getState = function() return enabled end}
end

local function createButton(parent, yOffset, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnGrad = Instance.new("UIGradient", btn)
    btnGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 0))
    }
    btn.MouseButton1Click:Connect(function()
        callback()
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 180, 50)}):Play()
        task.wait(0.1)
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    return btn
end

-- Teleport fonksiyonu (güvenilir)
local function teleportTo(place)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local pos
    if place == "Spawn" then pos = Vector3.new(20, 5, 20)
    elseif place == "Strength" then pos = Vector3.new(60, 5, 80)
    elseif place == "Agility" then pos = Vector3.new(-80, 5, 40)
    elseif place == "Stamina" then pos = Vector3.new(10, 5, -100)
    elseif place == "Rebirth" then pos = Vector3.new(-20, 5, 10)
    elseif place == "Eggs" then pos = Vector3.new(100, 5, -50)
    end
    if pos then
        hrp.CFrame = CFrame.new(pos)
    end
end

-- Otomatik farm döngüsü (çalışan)
local function startAutoFarm()
    while autoFarm do
        pcall(function()
            local char = player.Character
            if not char then return end
            local target
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local name = obj.Parent.Name:lower()
                    if farmMethod == "Strength" and (name:find("bench") or name:find("weight") or name:find("strength")) then
                        target = obj; break
                    elseif farmMethod == "Agility" and (name:find("tread") or name:find("run") or name:find("agility")) then
                        target = obj; break
                    elseif farmMethod == "Stamina" and (name:find("bike") or name:find("cycle") or name:find("stamina")) then
                        target = obj; break
                    elseif farmMethod == "All" then
                        target = obj; break
                    end
                end
            end
            if target then
                fireproximityprompt(target)
            end
        end)
        task.wait(0.5)
    end
end

-- Auto train döngüsü
local function startAutoTrain()
    while autoTrain do
        pcall(function()
            local char = player.Character
            if not char then return end
            local target
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local name = obj.Parent.Name:lower()
                    if trainStat == "Strength" and (name:find("bench") or name:find("weight") or name:find("strength")) then
                        target = obj; break
                    elseif trainStat == "Agility" and (name:find("tread") or name:find("run") or name:find("agility")) then
                        target = obj; break
                    elseif trainStat == "Stamina" and (name:find("bike") or name:find("cycle") or name:find("stamina")) then
                        target = obj; break
                    elseif trainStat == "All" then
                        target = obj; break
                    end
                end
            end
            if target then
                fireproximityprompt(target)
            end
        end)
        task.wait(0.3)
    end
end

-- Auto rebirth döngüsü
local function startAutoRebirth()
    while autoRebirth do
        pcall(function()
            local gui = player.PlayerGui
            if gui then
                for _, screen in ipairs(gui:GetDescendants()) do
                    if screen:IsA("ScreenGui") then
                        for _, elem in ipairs(screen:GetDescendants()) do
                            if (elem:IsA("TextButton") or elem:IsA("ImageButton")) and (elem.Name:lower():find("rebirth") or elem.Text:lower():find("rebirth")) then
                                if elem.Visible then
                                    firesignal(elem.MouseButton1Click)
                                    rebirthCount = rebirthCount + 1
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(2)
    end
end

-- Gem toplama
local function collectGems()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled and (obj.Parent.Name:lower():find("gem") or obj.Parent.Name:lower():find("coin") or obj.Parent.Name:lower():find("diamond")) then
            fireproximityprompt(obj)
        end
    end
end

-- Yumurta açma
local function openEggs()
    local eggShop = workspace:FindFirstChild("EggShop") or workspace:FindFirstChild("Eggs")
    if eggShop then
        for _, obj in ipairs(eggShop:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                fireproximityprompt(obj)
            end
        end
    end
end

-- İçerik gösterme
local function showTab(tabName)
    clearContent()
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = contentFrame

    local y = 10
    local function addH(h) y = y + h + 5; scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20) end

    if tabName == "Main" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0); t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "QUICK TOGGLES"; t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)

        createToggle(scroll, y, "Auto Farm", false, function(v) autoFarm = v; if v then spawn(startAutoFarm) end end); addH(40)
        createToggle(scroll, y, "Auto Train", false, function(v) autoTrain = v; if v then spawn(startAutoTrain) end end); addH(40)
        createToggle(scroll, y, "Auto Rebirth", false, function(v) autoRebirth = v; if v then spawn(startAutoRebirth) end end); addH(40)

        -- Farm method dropdown
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 10, 0, y)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(200, 200, 200); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.Text = "Farm Method: "..farmMethod; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = scroll
        addH(20)
        local chBtn = Instance.new("TextButton")
        chBtn.Size = UDim2.new(0, 120, 0, 25)
        chBtn.Position = UDim2.new(0, 10, 0, y)
        chBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70); chBtn.TextColor3 = Color3.new(1,1,1); chBtn.Text = "Change"; chBtn.Font = Enum.Font.Gotham; chBtn.TextSize = 12; chBtn.Parent = scroll
        Instance.new("UICorner", chBtn).CornerRadius = UDim.new(0, 4)
        addH(25)
        local methods = {"Strength", "Agility", "Stamina", "All"}
        local idx = 1
        chBtn.MouseButton1Click:Connect(function() idx = idx % #methods + 1; farmMethod = methods[idx]; lbl.Text = "Farm Method: "..farmMethod end)

        createButton(scroll, y, "Teleport to Spawn", function() teleportTo("Spawn") end); addH(35)

    elseif tabName == "Teleports" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0); t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "TELEPORT"; t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)
        for _, place in ipairs({"Spawn","Strength","Agility","Stamina","Rebirth","Eggs"}) do
            createButton(scroll, y, place.." Gym", function() teleportTo(place) end); addH(35)
        end

    elseif tabName == "Misc" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0); t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "MISC"; t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)

        createToggle(scroll, y, "Speed Hack", false, function(v)
            speedEnabled = v
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = v and 50 or 16
            end
        end); addH(40)

        createToggle(scroll, y, "Fly/NoClip", false, function(v)
            flyEnabled = v
            local char = player.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not v
                end
            end
            if v then
                local flyLoop; flyLoop = runService.Stepped:Connect(function()
                    if not flyEnabled then flyLoop:Disconnect() return end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then
                        char.HumanoidRootPart.Velocity = Vector3.new(0, 30, 0)
                    end
                end)
            end
        end); addH(40)

        createButton(scroll, y, "Collect All Gems", collectGems); addH(35)
        createButton(scroll, y, "Open All Eggs", openEggs); addH(35)
    end
end

-- Sekme butonları
local tabs = {"Main", "Teleports", "Misc"}
local tabBtns = {}
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = tab
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    table.insert(tabBtns, btn)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do
            tweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        showTab(tab)
    end)
end

-- Küçültme butonu
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = minSize}):Play()
        minBtn.Text = "+"
    else
        tweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = fullSize}):Play()
        minBtn.Text = "—"
    end
end)

-- Kapatma
closeBtn.MouseButton1Click:Connect(function()
    tweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 500, 0, 0)}):Play()
    task.wait(0.2)
    screenGui:Destroy()
end)

-- Sürükleme
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Başlangıç
showTab("Main")
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = fullSize}):Play()

-- Hover efektleri yardımcısı
local function addHover(btn)
    btn.MouseEnter:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play() end)
    btn.MouseLeave:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play() end)
end
addHover(minBtn)
addHover(closeBtn)
