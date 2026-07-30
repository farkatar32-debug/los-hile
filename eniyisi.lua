-- // Race Clicker Ultimate v2.0 - Çalışan ve Düzenlenmiş Sürüm // --
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local vim = game:GetService("VirtualInputManager")

-- Durum değişkenleri
local autoClick = false
local clickSpeed = 0.05
local autoRebirth = false
local rebirthThreshold = 1000
local autoEgg = false
local selectedEgg = "Common"
local autoHatch = false
local autoEquipBest = false
local autoEquipShiny = false
local autoUpgrade = false
local antiAFK = false

-- GUI Ana Yapı
local gui = Instance.new("ScreenGui", coreGui)
gui.Name = "RaceClickerUltimate"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Thickness = 1.5; mainFrame.UIStroke.Color = Color3.fromRGB(50, 50, 70)

-- Gölge
local shadow = Instance.new("Frame", mainFrame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

-- Başlık
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
}
titleGrad.Rotation = 45

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.Text = "RACE CLICKER PRO"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Kapatma
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Sekmeler
local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(0, 110, 1, -40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
tabBar.BorderSizePixel = 0

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -110, 1, -40)
content.Position = UDim2.new(0, 110, 0, 40)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do child:Destroy() end
end

-- Yardımcı UI fonksiyonları
local function makeToggle(parent, y, text, default, cb)
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
    local function update()
        if enabled then
            tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 70)}):Play()
            btn.Text = "ON"
        else
            tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
            btn.Text = "OFF"
        end
    end
    update()
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        cb(enabled)
    end)
    return frame
end

local function makeButton(parent, y, text, cb)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local grad = Instance.new("UIGradient", btn)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
    }
    btn.MouseButton1Click:Connect(function()
        cb()
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 200, 100)}):Play()
        task.wait(0.1)
        tweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    return btn
end

local function makeDropdown(parent, y, items, default, cb)
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
        cb(sel)
    end)
    return frame
end

-- // Dinamik UI Tarayıcı // --
local function findFirstButtonWithText(textPart, parent)
    for _, gui in ipairs(parent or player.PlayerGui:GetChildren()) do
        for _, elem in ipairs(gui:GetDescendants()) do
            if (elem:IsA("TextButton") or elem:IsA("ImageButton")) and elem.Visible and elem.Text:lower():find(textPart:lower()) then
                return elem
            end
        end
    end
    return nil
end

local function findProximityPrompts(nameHint)
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            if nameHint == "" or obj.Parent.Name:lower():find(nameHint:lower()) then
                table.insert(list, obj)
            end
        end
    end
    return list
end

-- // Ana Hile Döngüleri (Bağımsız) // --
spawn(function()
    while runService.Heartbeat:Wait() do
        if autoClick then
            -- Ana tıklama butonunu bul (en büyük buton genelde odur)
            local mainBtn = findFirstButtonWithText("click") or findFirstButtonWithText("tap") or findFirstButtonWithText("run")
            if not mainBtn then
                -- Alternatif: PlayerGui'deki en büyük TextButton'ı bul
                for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                    for _, btn in ipairs(gui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Visible and btn.Text ~= "" then
                            mainBtn = btn
                            break
                        end
                    end
                    if mainBtn then break end
                end
            end
            if mainBtn then
                firesignal(mainBtn.MouseButton1Click)
            end
            task.wait(clickSpeed)
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoRebirth then
            local lvlText = findFirstButtonWithText("level") or findFirstButtonWithText("speed")
            local current = lvlText and tonumber(lvlText.Text:match("%d+"))
            if current and current >= rebirthThreshold then
                local reb = findFirstButtonWithText("rebirth")
                if reb then
                    firesignal(reb.MouseButton1Click)
                    task.wait(0.8)
                    local confirm = findFirstButtonWithText("yes") or findFirstButtonWithText("confirm") or findFirstButtonWithText("rebirth")
                    if confirm then firesignal(confirm.MouseButton1Click) end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(1.5) do
        if autoEgg then
            -- Yumurta dükkanındaki buton
            local eggBtn = findFirstButtonWithText(selectedEgg)
            if eggBtn then firesignal(eggBtn.MouseButton1Click) end
        end
    end
end)

spawn(function()
    while task.wait(2) do
        if autoHatch then
            local hatch = findFirstButtonWithText("hatch") or findFirstButtonWithText("open")
            if hatch then firesignal(hatch.MouseButton1Click) end
        end
    end
end)

spawn(function()
    while task.wait(1) do
        if autoEquipBest or autoEquipShiny then
            -- Pet seçim butonları
            for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                for _, btn in ipairs(gui:GetDescendants()) do
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                        if autoEquipShiny and btn.Text:lower():find("shiny") then
                            firesignal(btn.MouseButton1Click)
                            break
                        elseif autoEquipBest then
                            firesignal(btn.MouseButton1Click)
                            break
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
            for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                for _, btn in ipairs(gui:GetDescendants()) do
                    if (btn:IsA("TextButton")) and btn.Visible and (btn.Text:lower():find("buy") or btn.Text:lower():find("upgrade")) then
                        firesignal(btn.MouseButton1Click)
                    end
                end
            end
        end
    end
end)

spawn(function()
    while task.wait(30) do
        if antiAFK then
            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end
end)

-- // Teleportlar //
local function teleportTo(loc)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local pos = Vector3.new(0, 10, 0)
    if loc == "Shop" then pos = Vector3.new(50, 10, 50)
    elseif loc == "Rebirth" then pos = Vector3.new(-50, 10, 50)
    elseif loc == "Eggs" then pos = Vector3.new(0, 10, 80)
    elseif loc == "Coins" then pos = Vector3.new(80, 10, 0)
    end
    char.HumanoidRootPart.CFrame = CFrame.new(pos)
end

-- // İçerik Yükleme //
local function loadTab(tab)
    clearContent()
    local scr = Instance.new("ScrollingFrame", content)
    scr.Size = UDim2.new(1, 0, 1, 0)
    scr.BackgroundTransparency = 1
    scr.CanvasSize = UDim2.new(0, 0, 0, 0)
    scr.ScrollBarThickness = 4
    scr.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 0)

    local y = 10
    local function add(h) y = y + h + 5; scr.CanvasSize = UDim2.new(0, 0, 0, y + 20) end

    if tab == "Main" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "MAIN"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        makeToggle(scr, y, "Auto Click", false, function(v) autoClick = v end); add(38)
        makeToggle(scr, y, "Auto Rebirth", false, function(v) autoRebirth = v end); add(38)
        makeToggle(scr, y, "Anti AFK", false, function(v) antiAFK = v end); add(38)
    elseif tab == "Eggs" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "EGGS & HATCH"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        makeDropdown(scr, y, {"Common", "Rare", "Epic", "Legendary", "Mythic"}, "Common", function(v) selectedEgg = v end); add(35)
        makeToggle(scr, y, "Auto Open Egg", false, function(v) autoEgg = v end); add(38)
        makeToggle(scr, y, "Auto Hatch", false, function(v) autoHatch = v end); add(38)
    elseif tab == "Pets" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "PETS"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        makeToggle(scr, y, "Auto Equip Best Pets", false, function(v) autoEquipBest = v end); add(38)
        makeToggle(scr, y, "Auto Equip Shiny Pets", false, function(v) autoEquipShiny = v end); add(38)
    elseif tab == "Upgrades" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "UPGRADES"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        makeToggle(scr, y, "Auto Upgrade All", false, function(v) autoUpgrade = v end); add(38)
    elseif tab == "Teleports" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "TELEPORTS"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        for _, loc in ipairs({"Spawn", "Shop", "Rebirth", "Eggs", "Coins"}) do
            makeButton(scr, y, loc, function() teleportTo(loc) end); add(35)
        end
    elseif tab == "Misc" then
        local t = Instance.new("TextLabel", scr)
        t.Size = UDim2.new(1, -20, 0, 25); t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundTransparency = 1; t.TextColor3 = Color3.fromRGB(255, 80, 0)
        t.Font = Enum.Font.GothamBlack; t.TextSize = 16; t.Text = "MISC"; t.TextXAlignment = Enum.TextXAlignment.Left
        add(25)
        makeButton(scr, y, "Collect All Coins", function()
            for _, pp in ipairs(findProximityPrompts("coin")) do fireproximityprompt(pp) end
        end); add(35)
        makeButton(scr, y, "Instant Rebirth", function()
            local reb = findFirstButtonWithText("rebirth")
            if reb then firesignal(reb.MouseButton1Click) end
        end); add(35)
        makeButton(scr, y, "Claim Rewards", function()
            for _, gui in ipairs(player.PlayerGui:GetChildren()) do
                for _, btn in ipairs(gui:GetDescendants()) do
                    if (btn:IsA("TextButton")) and btn.Visible and (btn.Text:lower():find("claim") or btn.Text:lower():find("reward")) then
                        firesignal(btn.MouseButton1Click)
                    end
                end
            end
        end); add(35)
    end
end

-- Sekme butonları
local tabs = {"Main", "Eggs", "Pets", "Upgrades", "Teleports", "Misc"}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
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
        loadTab(name)
    end)
end

-- Başlat
loadTab("Main")
mainFrame.Size = UDim2.new(0, 450, 0, 0)
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 300)}):Play()

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
