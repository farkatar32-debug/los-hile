-- // Muscle Legends Ultimate Script - Tüm Hileler // --
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local virtualInputManager = game:GetService("VirtualInputManager")
local httpService = game:GetService("HttpService")

-- Varsayılan değişkenler
local tabButtons = {}
local currentTab = "Main"
local menuOpen = true
local dragging = false
local dragStart, startPos

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuscleLegendsPro"
screenGui.Parent = coreGui

-- Ana konteyner
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 380)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Gölge
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

-- Köşe yuvarlama ve çerçeve
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(50, 50, 70)

-- Başlık çubuğu
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
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
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "MUSCLE LEGENDS PRO"
titleLabel.Parent = titleBar

-- Kapatma butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    menuOpen = false
    tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 500, 0, 0)}):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

-- Sekme çubuğu
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(0, 120, 1, -40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

-- Sekme butonları oluşturma fonksiyonu
local tabs = {"Main", "AutoFarm", "Training", "Rebirth", "Teleports", "Misc"}
local function createTabButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 5 + (index - 1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, b in pairs(tabButtons) do
            tweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        -- İçerik alanını güncelle
        showTabContent(name)
    end)
end

for i, tab in ipairs(tabs) do
    createTabButton(tab, i)
end

-- İçerik alanı
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -120, 1, -40)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

-- Yardımcı fonksiyon: Toggle oluşturma
local function createToggle(parent, yOffset, text, callback, default)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = UDim2.new(0, 10, 0, yOffset)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", toggleFrame)
    stroke.Thickness = 0.5
    stroke.Color = Color3.fromRGB(60, 60, 80)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 22)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 70) or Color3.fromRGB(70, 70, 90)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = toggleFrame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 11)
    local btnGrad = Instance.new("UIGradient", toggleBtn)
    local enabled = default or false

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
    return toggleFrame, function() return enabled end
end

-- Buton oluşturma
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

-- Alt sekmeler için içerik yönetimi
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
end

-- Tüm hile değişkenleri ve fonksiyonlarını tanımlayalım
-- AutoFarm
local autoFarmEnabled = false
local farmMethod = "Strength" -- varsayılan

local function autoFarmLoop()
    while autoFarmEnabled do
        -- Oyun içi alanlara göre farm işlemleri
        pcall(function()
            local character = player.Character
            if not character then return end
            -- Strength: bench press, Agility: treadmill vb. Bu script obby'leri için click işlemleri
            -- Remote eventler veya touch interest ile yapılabilir. Basitçe en yakın antrenman aletine git ve ateşle
            -- Burada basit bir auto farm implementasyonu, gerçek oyun yapısına uygun olmalı.
            -- Muscle Legends antrenman aletleri genelde ProximityPrompt veya TouchTransmitter ile çalışır.
            -- En yakın aleti bul ve tetikle.
            local tool = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    if farmMethod == "Strength" and obj.Parent.Name:lower():find("bench") then
                        tool = obj
                        break
                    elseif farmMethod == "Agility" and obj.Parent.Name:lower():find("tread") then
                        tool = obj
                        break
                    elseif farmMethod == "Stamina" and obj.Parent.Name:lower():find("bike") then
                        tool = obj
                        break
                    elseif farmMethod == "All" then
                        tool = obj
                        break
                    end
                end
            end
            if tool then
                fireproximityprompt(tool)
            end
        end)
        task.wait(0.5)
    end
end

-- Training
local autoTrainEnabled = false
local trainStat = "Strength"

local function autoTrainLoop()
    while autoTrainEnabled do
        pcall(function()
            local character = player.Character
            if not character then return end
            -- Spesifik antrenman aletini bul ve tıkla
            local target = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local parentName = obj.Parent.Name:lower()
                    if trainStat == "Strength" and parentName:find("bench") then
                        target = obj
                        break
                    elseif trainStat == "Agility" and parentName:find("tread") then
                        target = obj
                        break
                    elseif trainStat == "Stamina" and parentName:find("bike") then
                        target = obj
                        break
                    elseif trainStat == "All" then
                        target = obj
                        break
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

-- Auto Rebirth
local autoRebirthEnabled = false
local rebirthCount = 0

local function autoRebirthLoop()
    while autoRebirthEnabled do
        pcall(function()
            -- Rebirth işlemi genelde butona basarak yapılır. Uygun UI butonunu bul.
            local rebirthButton = player.PlayerGui:FindFirstChild("RebirthButton") or player.PlayerGui:FindFirstChild("RebirthMenu")
            if rebirthButton then
                -- butona basmayı simule et
                local btn = rebirthButton:FindFirstChildWhichIsA("TextButton") or rebirthButton:FindFirstChildWhichIsA("ImageButton")
                if btn then
                    firesignal(btn.MouseButton1Click)
                    rebirthCount = rebirthCount + 1
                end
            end
        end)
        task.wait(2)
    end
end

-- Teleportlar
local function teleportTo(place)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart
    local targetCFrame
    if place == "Spawn" then
        targetCFrame = CFrame.new(20, 5, 20) -- yaklaşık
    elseif place == "Strength Gym" then
        targetCFrame = CFrame.new(50, 5, 80)
    elseif place == "Agility Gym" then
        targetCFrame = CFrame.new(-80, 5, 40)
    elseif place == "Stamina Gym" then
        targetCFrame = CFrame.new(10, 5, -100)
    elseif place == "Rebirth" then
        targetCFrame = CFrame.new(-20, 5, 10)
    elseif place == "Eggs" then
        targetCFrame = CFrame.new(100, 5, -50)
    end
    if targetCFrame then
        root.CFrame = targetCFrame
    end
end

-- Hile listeleri ile içerikleri doldur
local function showTabContent(tab)
    clearContent()
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Position = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = contentFrame

    local y = 10
    local function addElement(height)
        y = y + height + 5
        scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)
    end

    if tab == "Main" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "QUICK TOGGLES"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        createToggle(scroll, y, "Auto Farm", function(val) autoFarmEnabled = val if val then spawn(autoFarmLoop) end end, false)
        addElement(40)

        createToggle(scroll, y, "Auto Train", function(val) autoTrainEnabled = val if val then spawn(autoTrainLoop) end end, false)
        addElement(40)

        createToggle(scroll, y, "Auto Rebirth", function(val) autoRebirthEnabled = val if val then spawn(autoRebirthLoop) end end, false)
        addElement(40)

        -- Alt seçenekler için dropdown
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -20, 0, 20)
        dropdownLabel.Position = UDim2.new(0, 10, 0, y)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 13
        dropdownLabel.Text = "Farm Method: " .. farmMethod
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = scroll
        addElement(20)

        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(0, 120, 0, 25)
        dropdownBtn.Position = UDim2.new(0, 10, 0, y)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdownBtn.Text = "Change"
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.TextSize = 12
        dropdownBtn.Parent = scroll
        Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 4)
        addElement(25)

        local methods = {"Strength", "Agility", "Stamina", "All"}
        local currentMethodIndex = 1
        dropdownBtn.MouseButton1Click:Connect(function()
            currentMethodIndex = currentMethodIndex % #methods + 1
            farmMethod = methods[currentMethodIndex]
            dropdownLabel.Text = "Farm Method: " .. farmMethod
        end)

        createButton(scroll, y, "Teleport to Spawn", function() teleportTo("Spawn") end)
        addElement(35)
    end

    if tab == "AutoFarm" then
        -- Detaylı farm seçenekleri
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "AUTO FARM SETTINGS"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        createToggle(scroll, y, "Enable Auto Farm", function(val) autoFarmEnabled = val if val then spawn(autoFarmLoop) end end, autoFarmEnabled)
        addElement(40)

        local methodLabel = Instance.new("TextLabel")
        methodLabel.Size = UDim2.new(1, -20, 0, 20)
        methodLabel.Position = UDim2.new(0, 10, 0, y)
        methodLabel.BackgroundTransparency = 1
        methodLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        methodLabel.Font = Enum.Font.Gotham
        methodLabel.TextSize = 13
        methodLabel.Text = "Current Method: " .. farmMethod
        methodLabel.TextXAlignment = Enum.TextXAlignment.Left
        methodLabel.Parent = scroll
        addElement(20)

        local changeBtn = Instance.new("TextButton")
        changeBtn.Size = UDim2.new(1, -20, 0, 30)
        changeBtn.Position = UDim2.new(0, 10, 0, y)
        changeBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        changeBtn.TextColor3 = Color3.new(1, 1, 1)
        changeBtn.Text = "Cycle Method"
        changeBtn.Font = Enum.Font.GothamBold
        changeBtn.TextSize = 13
        changeBtn.Parent = scroll
        Instance.new("UICorner", changeBtn).CornerRadius = UDim.new(0, 6)
        addElement(30)

        local methods = {"Strength", "Agility", "Stamina", "All"}
        local idx = 1
        changeBtn.MouseButton1Click:Connect(function()
            idx = idx % #methods + 1
            farmMethod = methods[idx]
            methodLabel.Text = "Current Method: " .. farmMethod
        end)
    end

    -- Diğer sekmelerde benzer şekilde doldur
    if tab == "Training" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "TRAINING STATS"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        createToggle(scroll, y, "Auto Train", function(val) autoTrainEnabled = val if val then spawn(autoTrainLoop) end end, false)
        addElement(40)

        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(1, -20, 0, 20)
        statLabel.Position = UDim2.new(0, 10, 0, y)
        statLabel.BackgroundTransparency = 1
        statLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statLabel.Font = Enum.Font.Gotham
        statLabel.TextSize = 13
        statLabel.Text = "Target: " .. trainStat
        statLabel.Parent = scroll
        addElement(20)

        local cycleBtn = Instance.new("TextButton")
        cycleBtn.Size = UDim2.new(1, -20, 0, 30)
        cycleBtn.Position = UDim2.new(0, 10, 0, y)
        cycleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        cycleBtn.TextColor3 = Color3.new(1, 1, 1)
        cycleBtn.Text = "Cycle Stat"
        cycleBtn.Font = Enum.Font.GothamBold
        cycleBtn.TextSize = 13
        cycleBtn.Parent = scroll
        Instance.new("UICorner", cycleBtn).CornerRadius = UDim.new(0, 6)
        addElement(30)

        local stats = {"Strength", "Agility", "Stamina", "All"}
        local statIdx = 1
        cycleBtn.MouseButton1Click:Connect(function()
            statIdx = statIdx % #stats + 1
            trainStat = stats[statIdx]
            statLabel.Text = "Target: " .. trainStat
        end)
    end

    if tab == "Rebirth" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "AUTO REBIRTH"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        createToggle(scroll, y, "Auto Rebirth", function(val) autoRebirthEnabled = val if val then spawn(autoRebirthLoop) end end, false)
        addElement(40)

        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(1, -20, 0, 20)
        countLabel.Position = UDim2.new(0, 10, 0, y)
        countLabel.BackgroundTransparency = 1
        countLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        countLabel.Font = Enum.Font.Gotham
        countLabel.TextSize = 13
        countLabel.Text = "Rebirths: " .. rebirthCount
        countLabel.Parent = scroll
        addElement(20)

        spawn(function()
            while true do
                if countLabel.Parent then
                    countLabel.Text = "Rebirths: " .. rebirthCount
                end
                task.wait(1)
            end
        end)
    end

    if tab == "Teleports" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "TELEPORT LOCATIONS"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        local places = {
            {"Spawn", "Spawn"},
            {"Strength Gym", "Strength Gym"},
            {"Agility Gym", "Agility Gym"},
            {"Stamina Gym", "Stamina Gym"},
            {"Rebirth Room", "Rebirth"},
            {"Egg Shop", "Eggs"}
        }
        for _, place in ipairs(places) do
            createButton(scroll, y, place[1], function() teleportTo(place[2]) end)
            addElement(35)
        end
    end

    if tab == "Misc" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, y)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 140, 0)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.Text = "MISC FEATURES"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = scroll
        addElement(25)

        createToggle(scroll, y, "Speed Hack", function(val) 
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = val and 50 or 16
            end
        end, false)
        addElement(40)

        createToggle(scroll, y, "Fly (NoClip)", function(val)
            -- Basit fly/noclip implementasyonu
            if val then
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                -- Fly loop
                spawn(function()
                    while val and player.Character do
                        if uis:IsKeyDown(Enum.KeyCode.Space) then
                            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 30, 0)
                        end
                        task.wait()
                    end
                end)
            else
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end, false)
        addElement(40)

        createButton(scroll, y, "Collect All Gems", function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Parent.Name == "Gem" then
                    fireproximityprompt(obj)
                end
            end
        end)
        addElement(35)

        createButton(scroll, y, "Open All Eggs", function()
            local eggShop = workspace:FindFirstChild("EggShop")
            if eggShop then
                for _, obj in ipairs(eggShop:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        fireproximityprompt(obj)
                    end
                end
            end
        end)
        addElement(35)
    end
end

-- Başlangıçta Main sekmesini göster
showTabContent("Main")

-- Pencere sürükleme
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

-- Açılış animasyonu
mainFrame.Size = UDim2.new(0, 500, 0, 0)
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 380)}):Play()

-- Buton hover efektleri için yardımcı
local function addHover(btn)
    btn.MouseEnter:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play() end)
    btn.MouseLeave:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play() end)
end
addHover(closeBtn)
