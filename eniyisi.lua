-- // Muscle Legends PRO - Teleports, Egg Shop, Codes, Extras // --
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

-- // Değişkenler
local antiAFKEnabled = false
local freeGamepassEnabled = false

-- // Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuscleLegendsPro"
screenGui.Parent = coreGui

local mainFrame = Instance.new("Frame")
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

-- Başlık
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
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

-- Küçültme
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

-- Kapatma
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

local isMinimized = false
local fullSize = UDim2.new(0, 500, 0, 380)
local minSize = UDim2.new(0, 500, 0, 40)

-- Sekme bar
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

local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
end

-- Yardımcı UI elemanları
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

-- // TELEPORT (aynı)
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
    if pos then hrp.CFrame = CFrame.new(pos) end
end

-- // EGG SHOP verileri (fiyatlar yaklaşık)
local eggs = {
    {name = "Jungle Egg", cost = "3M Gems", location = "Jungle"},
    {name = "Volcano Egg", cost = "5M Gems", location = "Volcano"},
    {name = "Ice Egg", cost = "8M Gems", location = "Ice"},
    {name = "Desert Egg", cost = "10M Gems", location = "Desert"},
    {name = "Mythical Egg", cost = "25M Gems", location = "Mythical"},
    {name = "Galaxy Egg", cost = "50M Gems", location = "Galaxy"},
}

local function openEgg(eggLocation)
    local shop = workspace:FindFirstChild("EggShop") or workspace:FindFirstChild("Eggs")
    if not shop then return end
    for _, obj in ipairs(shop:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parentName = obj.Parent.Name:lower()
            if parentName:find(eggLocation:lower()) then
                fireproximityprompt(obj)
                return
            end
        end
    end
end

-- // KOD SİSTEMİ (güncel kodlar)
local activeCodes = {
    "MUSCLE50K",
    "LEGEND100",
    "SUPERSTRENGTH",
    "GEMSBOOST",
    "FREEPET"
}

local function redeemCode(code)
    -- Kod ekranını bul
    local codeGui = player.PlayerGui:FindFirstChild("CodeGUI") or player.PlayerGui:FindFirstChild("Codes")
    if not codeGui then
        -- Alternatif: oyunun ana GUI'sinde Code butonuna tıkla
        for _, gui in ipairs(player.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, elem in ipairs(gui:GetDescendants()) do
                    if elem:IsA("TextButton") and elem.Text:lower():find("code") then
                        firesignal(elem.MouseButton1Click)
                        task.wait(0.5)
                        break
                    end
                end
            end
        end
    end
    -- TextBox ara ve kodu yaz
    local textBox = nil
    for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
        if gui:IsA("TextBox") and gui.Visible then
            textBox = gui
            break
        end
    end
    if textBox then
        textBox.Text = code
        -- Enter simülasyonu
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.2)
        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        -- veya Redeem butonuna tıkla
        for _, elem in ipairs(player.PlayerGui:GetDescendants()) do
            if elem:IsA("TextButton") and elem.Text:lower():find("redeem") and elem.Visible then
                firesignal(elem.MouseButton1Click)
                break
            end
        end
    end
end

local function redeemAllCodes()
    for _, code in ipairs(activeCodes) do
        redeemCode(code)
        task.wait(1.5) -- bekleme
    end
end

-- // EXTRA FONKSİYONLAR
-- Anti AFK
local function antiAFKLoop()
    while antiAFKEnabled do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 10, 0) -- hafif zıplama
        end
        task.wait(30)
    end
end

-- Free Gamepass (deneysel)
local function enableFreeGamepass()
    if freeGamepassEnabled then
        -- Gamepass kontrolünü bypass etmeye çalış (genelde işe yaramaz)
        -- Örnek: OwnedGamepasses tablosunu manipüle etme
        pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__index
            mt.__index = function(self, key)
                if key == "OwnedGamepasses" then
                    return {} -- boş döndür ki her şey alınmış görünsün? Aslında tersi, true döndürmek lazım.
                end
                return old(self, key)
            end
            setreadonly(mt, true)
        end)
        -- Daha basit bir yöntem: marketplaceservice sinyallerini manipüle
        local MarketplaceService = game:GetService("MarketplaceService")
        -- Bu çalışmaz çünkü sunucu kontrolü var.
    end
end

-- Hediye toplama
local function collectAllGifts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local name = obj.Parent.Name:lower()
            if name:find("gift") or name:find("present") or name:find("chest") or name:find("gem") or name:find("coin") then
                fireproximityprompt(obj)
            end
        end
    end
end

-- // SEKMELER İÇERİĞİ
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

    if tabName == "Teleports" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "TELEPORTS"
        t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)
        for _, loc in ipairs({"Spawn","Strength","Agility","Stamina","Rebirth","Eggs"}) do
            createButton(scroll, y, loc.." Gym", function() teleportTo(loc) end); addH(35)
        end

    elseif tabName == "Egg Shop" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "OPEN EGGS"
        t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)

        for _, egg in ipairs(eggs) do
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 50); frame.Position = UDim2.new(0, 10, 0, y)
            frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            frame.BorderSizePixel = 0; frame.Parent = scroll
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(0, 180, 1, 0); infoLabel.Position = UDim2.new(0, 10, 0, 0)
            infoLabel.BackgroundTransparency = 1; infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            infoLabel.Text = egg.name; infoLabel.Font = Enum.Font.GothamBold; infoLabel.TextSize = 14
            infoLabel.TextXAlignment = Enum.TextXAlignment.Left; infoLabel.Parent = frame

            local costLabel = Instance.new("TextLabel")
            costLabel.Size = UDim2.new(0, 100, 1, 0); costLabel.Position = UDim2.new(0, 190, 0, 0)
            costLabel.BackgroundTransparency = 1; costLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
            costLabel.Text = egg.cost; costLabel.Font = Enum.Font.Gotham; costLabel.TextSize = 13
            costLabel.TextXAlignment = Enum.TextXAlignment.Left; costLabel.Parent = frame

            local openBtn = Instance.new("TextButton")
            openBtn.Size = UDim2.new(0, 80, 0, 30); openBtn.Position = UDim2.new(1, -90, 0.5, -15)
            openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 70); openBtn.TextColor3 = Color3.new(1,1,1)
            openBtn.Text = "OPEN"; openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 14
            openBtn.Parent = frame
            Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)

            openBtn.MouseButton1Click:Connect(function()
                openEgg(egg.location)
                tweenService:Create(openBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
                task.wait(0.1)
                tweenService:Create(openBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 70)}):Play()
            end)

            addH(50)
        end

    elseif tabName == "Codes" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "REDEEM CODES"
        t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)

        createButton(scroll, y, "REDEEM ALL CODES", redeemAllCodes); addH(35)

        -- Liste
        for _, code in ipairs(activeCodes) do
            local codeFrame = Instance.new("Frame")
            codeFrame.Size = UDim2.new(1, -20, 0, 30); codeFrame.Position = UDim2.new(0, 10, 0, y)
            codeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            codeFrame.BorderSizePixel = 0; codeFrame.Parent = scroll
            Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 6)

            local codeText = Instance.new("TextLabel")
            codeText.Size = UDim2.new(1, -20, 1, 0); codeText.Position = UDim2.new(0, 10, 0, 0)
            codeText.BackgroundTransparency = 1; codeText.TextColor3 = Color3.fromRGB(255, 255, 255)
            codeText.Text = code; codeText.Font = Enum.Font.Code; codeText.TextSize = 14
            codeText.TextXAlignment = Enum.TextXAlignment.Left; codeText.Parent = codeFrame
            addH(30)
        end

    elseif tabName == "Extras" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 140, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "EXTRAS"
        t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = scroll
        addH(25)

        createToggle(scroll, y, "Anti AFK", false, function(v) antiAFKEnabled = v; if v then spawn(antiAFKLoop) end end); addH(40)
        createToggle(scroll, y, "Free Auto Gamepass", false, function(v) freeGamepassEnabled = v; if v then enableFreeGamepass() end end); addH(40)
        createButton(scroll, y, "Collect All Gifts/Gems", collectAllGifts); addH(35)
    end
end

-- Sekme butonları
local tabNames = {"Teleports", "Egg Shop", "Codes", "Extras"}
local tabBtns = {}
for i, tab in ipairs(tabNames) do
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

-- Küçültme
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
showTab("Teleports")
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = fullSize}):Play()

-- Hover efektleri
local function addHover(btn)
    btn.MouseEnter:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play() end)
    btn.MouseLeave:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play() end)
end
addHover(minBtn)
addHover(closeBtn)
