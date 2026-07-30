--// Race Clicker Ultimate Script
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local virtualInputManager = game:GetService("VirtualInputManager")

-- Hile değişkenleri
local autoClick = false
local clickInterval = 0.05 -- saniye
local autoRebirth = false
local rebirthAt = 1000 -- seviye
local autoEgg = false
local selectedEgg = "Common" -- Common, Rare, Epic, Legendary, Mythic
local autoHatch = false
local autoEquipBest = false
local autoEquipShiny = false
local autoUpgrade = false
local antiAFK = false

-- GUI
local gui = Instance.new("ScreenGui", coreGui)
gui.Name = "RaceClickerPro"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 450, 0, 320)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Thickness = 1.5; mainFrame.UIStroke.Color = Color3.fromRGB(50, 50, 70)

-- Gölge
local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

-- Başlık çubuğu
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local grad = Instance.new("UIGradient", titleBar)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
}
grad.Rotation = 45

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.Text = "RACE CLICKER PRO"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Kapatma butonu
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Sekme bar
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(0, 110, 1, -40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
tabBar.BorderSizePixel = 0

-- İçerik alanı
local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -110, 1, -40)
content.Position = UDim2.new(0, 110, 0, 40)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end
end

-- Yardımcı UI
local function createToggle(parent, y, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 38)
    frame.Position = UDim2.new(0, 10, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", frame).Thickness = 0.5; frame.UIStroke.Color = Color3.fromRGB(60, 60, 80)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 180, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -55, 0.5, -11)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 70) or Color3.fromRGB(70, 70, 90)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = default and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local enabled = default
    local function updateUI()
        if enabled then
            tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 70)}):Play()
            btn.Text = "ON"
        else
            tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
            btn.Text = "OFF"
        end
    end
    updateUI()
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateUI()
        callback(enabled)
    end)
    return frame
end

local function createButton(parent, y, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnGrad = Instance.new("UIGradient", btn)
    btnGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
    }
    btn.MouseButton1Click:Connect(function()
        callback()
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 200, 100)}):Play()
        task.wait(0.1)
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    return btn
end

local function addDropdown(parent, y, items, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = default
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local idx = table.find(items, default) or 1
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 80, 0, 25)
    btn.Position = UDim2.new(1, -90, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = "▼"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        idx = idx % #items + 1
        local sel = items[idx]
        label.Text = sel
        callback(sel)
    end)
    return frame
end

-- Hile döngüleri
spawn(function()
    while runService.Heartbeat:Wait() do
        if autoClick then
            -- Ana tıklama butonunu bul ve ateşle
            local clickButton = player.PlayerGui:FindFirstChild("ClickButton") or player.PlayerGui:FindFirstChild("MainButton")
            if clickButton and clickButton.Visible then
                firesignal(clickButton.MouseButton1Click)
            end
            task.wait(clickInterval)
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoRebirth then
            -- Seviye kontrolü ve rebirth yap
            local levelGui = player.PlayerGui:FindFirstChild("Level") or player.PlayerGui:FindFirstChild("Speed")
            if levelGui then
                local current = tonumber(levelGui.Text:match("%d+"))
                if current and current >= rebirthAt then
                    -- Rebirth butonunu bul
                    local rebBtn = player.PlayerGui:FindFirstChild("RebirthButton")
                    if rebBtn and rebBtn.Visible then
                        firesignal(rebBtn.MouseButton1Click)
                        task.wait(1)
                        -- Onay butonu varsa tıkla
                        local confirm = player.PlayerGui:FindFirstChild("ConfirmRebirth") or player.PlayerGui:FindFirstChild("YesButton")
                        if confirm and confirm.Visible then
                            firesignal(confirm.MouseButton1Click)
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoEgg then
            -- Yumurta dükkanındaki butonları bul
            local eggShop = player.PlayerGui:FindFirstChild("EggShop") or player.PlayerGui:FindFirstChild("ShopFrame")
            if eggShop then
                for _, child in ipairs(eggShop:GetDescendants()) do
                    if child:IsA("TextButton") and child.Text:find(selectedEgg) and child.Visible then
                        firesignal(child.MouseButton1Click)
                        break
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(2) do
        if autoHatch then
            local hatchBtn = player.PlayerGui:FindFirstChild("HatchButton") or player.PlayerGui:FindFirstChild("OpenEggButton")
            if hatchBtn and hatchBtn.Visible then
                firesignal(hatchBtn.MouseButton1Click)
            end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoEquipBest or autoEquipShiny then
            -- Pet envanterini aç
            local petsFrame = player.PlayerGui:FindFirstChild("PetsFrame") or player.PlayerGui:FindFirstChild("Inventory")
            if petsFrame then
                for _, petBtn in ipairs(petsFrame:GetDescendants()) do
                    if petBtn:IsA("TextButton") and petBtn.Visible then
                        if autoEquipShiny and petBtn.Text:find("Shiny") then
                            firesignal(petBtn.MouseButton1Click)
                            break
                        elseif autoEquipBest then
                            -- Burada petin gücünü okuyamıyoruz, sırayla deneyelim; basitçe hepsini tıklayarak en iyisini bulmaya çalış
                            -- Daha gelişmiş olarak pet çarpanına bakılabilir.
                            firesignal(petBtn.MouseButton1Click)
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoUpgrade then
            local upgradeFrame = player.PlayerGui:FindFirstChild("Upgrades") or player.PlayerGui:FindFirstChild("Shop")
            if upgradeFrame then
                for _, button in ipairs(upgradeFrame:GetDescendants()) do
                    if button:IsA("TextButton") and button.Visible and (button.Text:find("Buy") or button.Text:find("Upgrade")) then
                        firesignal(button.MouseButton1Click)
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(30) do
        if antiAFK then
            virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end
end)

-- Işınlanma fonksiyonları
local function teleportTo(name)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local pos
    if name == "Spawn" then pos = Vector3.new(0, 10, 0)
    elseif name == "Shop" then pos = Vector3.new(50, 10, 50)
    elseif name == "Rebirth" then pos = Vector3.new(-50, 10, 50)
    elseif name == "Eggs" then pos = Vector3.new(0, 10, 80)
    elseif name == "Coins" then pos = Vector3.new(80, 10, 0)
    end
    if pos then hrp.CFrame = CFrame.new(pos) end
end

-- Sekme içerikleri
local function showTab(name)
    clearContent()
    local y = 10
    local scr = Instance.new("ScrollingFrame", content)
    scr.Size = UDim2.new(1, 0, 1, 0)
    scr.BackgroundTransparency = 1
    scr.CanvasSize = UDim2.new(0, 0, 0, 0)
    scr.ScrollBarThickness = 4
    scr.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 0)

    local function add(h) y = y + h + 5; scr.CanvasSize = UDim2.new(0, 0, 0, y + 20) end

    if name == "Main" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "MAIN"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        createToggle(scr, y, "Auto Click", false, function(v) autoClick = v end)
        add(38)
        createToggle(scr, y, "Auto Rebirth", false, function(v) autoRebirth = v end)
        add(38)
        createToggle(scr, y, "Anti AFK", false, function(v) antiAFK = v end)
        add(38)
    elseif name == "Eggs" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "EGGS & HATCH"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        addDropdown(scr, y, {"Common", "Rare", "Epic", "Legendary", "Mythic"}, "Common", function(v) selectedEgg = v end)
        add(35)
        createToggle(scr, y, "Auto Open Egg", false, function(v) autoEgg = v end)
        add(38)
        createToggle(scr, y, "Auto Hatch", false, function(v) autoHatch = v end)
        add(38)
    elseif name == "Pets" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "PETS"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        createToggle(scr, y, "Auto Equip Best Pets", false, function(v) autoEquipBest = v end)
        add(38)
        createToggle(scr, y, "Auto Equip Shiny Pets", false, function(v) autoEquipShiny = v end)
        add(38)
    elseif name == "Upgrades" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "UPGRADES"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        createToggle(scr, y, "Auto Upgrade All", false, function(v) autoUpgrade = v end)
        add(38)
    elseif name == "Teleports" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "TELEPORTS"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        for _, loc in ipairs({"Spawn", "Shop", "Rebirth", "Eggs", "Coins"}) do
            createButton(scr, y, loc, function() teleportTo(loc) end)
            add(35)
        end
    elseif name == "Misc" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 16
        t.Text = "MISC"
        t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)

        createButton(scr, y, "Collect All Coins", function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent.Name:find("Coin") then
                    fireproximityprompt(obj)
                end
            end
        end)
        add(35)
        createButton(scr, y, "Instant Rebirth", function()
            local rebBtn = player.PlayerGui:FindFirstChild("RebirthButton")
            if rebBtn then firesignal(rebBtn.MouseButton1Click) end
        end)
        add(35)
        createButton(scr, y, "Claim Rewards", function()
            -- Ödül alma fonksiyonu
            for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                for _, btn in ipairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") and btn.Visible and (btn.Text:find("Claim") or btn.Text:find("Reward")) then
                        firesignal(btn.MouseButton1Click)
                    end
                end
            end
        end)
        add(35)
    end
end

-- Sekme butonları
local tabs = {
    {name = "Main", label = "Main"},
    {name = "Eggs", label = "Eggs"},
    {name = "Pets", label = "Pets"},
    {name = "Upgrades", label = "Upgrades"},
    {name = "Teleports", label = "Teleports"},
    {name = "Misc", label = "Misc"}
}
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = tab.label
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBar:GetChildren()) do
            if b:IsA("TextButton") then
                tweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
            end
        end
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 0)}):Play()
        showTab(tab.name)
    end)
end

-- İlk sekmeyi göster
showTab("Main")

-- Sürükleme
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Açılış animasyonu
mainFrame.Size = UDim2.new(0, 450, 0, 0)
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 320)}):Play()
