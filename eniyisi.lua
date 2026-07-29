-- // Professional Tool Duper v2.0 - Animasyonlu Menü
-- // GitHub Raw Link: https://raw.githubusercontent.com/farkatar32-debug/los-hile/refs/heads/main/eniyisi.lua

local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

-- // Değişkenler
local isDupeEnabled = false
local isMinimized = false
local lastTool = nil
local cooldown = false

-- // Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProfessionalToolDuper"
screenGui.Parent = coreGui

-- // Ana Container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 280, 0, 0)
mainContainer.Position = UDim2.new(0.5, -140, 0.5, -90)
mainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.Parent = screenGui

-- // Köşe yuvarlama için UIStroke
local containerStroke = Instance.new("UIStroke")
containerStroke.Name = "ContainerStroke"
containerStroke.Thickness = 1.5
containerStroke.Color = Color3.fromRGB(60, 60, 80)
containerStroke.Parent = mainContainer

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = mainContainer

-- // Gölge efekti
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(1, 10, 1, 10)
shadowFrame.Position = UDim2.new(0, -5, 0, -5)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.7
shadowFrame.BorderSizePixel = 0
shadowFrame.ZIndex = -1
shadowFrame.Parent = mainContainer

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadowFrame

-- // Başlık Çubuğu
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainContainer

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

-- Gradient başlık
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 255))
}
titleGradient.Rotation = 45
titleGradient.Parent = titleBar

-- Başlık metni
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0, 150, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Text = "TOOL DUPER"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- // Başlık ışık efekti
local titleGlow = Instance.new("ImageLabel")
titleGlow.Name = "TitleGlow"
titleGlow.Size = UDim2.new(0, 20, 0, 20)
titleGlow.Position = UDim2.new(0, 10, 0.5, -10)
titleGlow.BackgroundTransparency = 1
titleGlow.Image = "rbxassetid://16255699706"
titleGlow.ImageColor3 = Color3.fromRGB(180, 120, 255)
titleGlow.ScaleType = Enum.ScaleType.Fit
titleGlow.Parent = titleBar

-- Buton container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 80, 1, 0)
buttonContainer.Position = UDim2.new(1, -85, 0, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = titleBar

-- // Küçültme Butonu
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0, 0, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Text = "—"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.Parent = buttonContainer

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- // Kapatma Butonu
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 40, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = buttonContainer

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- // İçerik Alanı (Dupe Kontrolleri)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, 0, 0, 0)
contentArea.Position = UDim2.new(0, 0, 0, 45)
contentArea.BackgroundTransparency = 1
contentArea.ClipsDescendants = true
contentArea.Parent = mainContainer

-- Durum Paneli
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, -30, 0, 50)
statusPanel.Position = UDim2.new(0, 15, 0, 20)
statusPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
statusPanel.BorderSizePixel = 0
statusPanel.Parent = contentArea

local statusPanelCorner = Instance.new("UICorner")
statusPanelCorner.CornerRadius = UDim.new(0, 8)
statusPanelCorner.Parent = statusPanel

local statusStroke = Instance.new("UIStroke")
statusStroke.Thickness = 1
statusStroke.Color = Color3.fromRGB(50, 50, 70)
statusStroke.Parent = statusPanel

-- Durum metni
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, 0, 0, 20)
statusTitle.Position = UDim2.new(0, 10, 0, 5)
statusTitle.BackgroundTransparency = 1
statusTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
statusTitle.Text = "STATUS"
statusTitle.Font = Enum.Font.GothamSemibold
statusTitle.TextSize = 12
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = statusPanel

local statusValue = Instance.new("TextLabel")
statusValue.Name = "StatusValue"
statusValue.Size = UDim2.new(1, 0, 0, 20)
statusValue.Position = UDim2.new(0, 10, 0, 25)
statusValue.BackgroundTransparency = 1
statusValue.TextColor3 = Color3.fromRGB(255, 60, 60)
statusValue.Text = "INACTIVE"
statusValue.Font = Enum.Font.GothamBold
statusValue.TextSize = 14
statusValue.TextXAlignment = Enum.TextXAlignment.Left
statusValue.Parent = statusPanel

-- Durum göstergesi nokta
local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -20, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusPanel

local statusDotCorner = Instance.new("UICorner")
statusDotCorner.CornerRadius = UDim.new(1, 0)
statusDotCorner.Parent = statusDot

-- Dupe Toggle Butonu
local dupeButton = Instance.new("TextButton")
dupeButton.Name = "DupeButton"
dupeButton.Size = UDim2.new(1, -30, 0, 50)
dupeButton.Position = UDim2.new(0, 15, 0, 85)
dupeButton.BackgroundColor3 = Color3.fromRGB(30, 170, 70)
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.Text = "ENABLE DUPER"
dupeButton.Font = Enum.Font.GothamBold
dupeButton.TextSize = 16
dupeButton.Parent = contentArea

local dupeButtonCorner = Instance.new("UICorner")
dupeButtonCorner.CornerRadius = UDim.new(0, 8)
dupeButtonCorner.Parent = dupeButton

local dupeButtonGradient = Instance.new("UIGradient")
dupeButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 180, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 130, 50))
}
dupeButtonGradient.Rotation = 90
dupeButtonGradient.Parent = dupeButton

-- Tool Bilgi Metni
local toolInfo = Instance.new("TextLabel")
toolInfo.Name = "ToolInfo"
toolInfo.Size = UDim2.new(1, -30, 0, 30)
toolInfo.Position = UDim2.new(0, 15, 0, 150)
toolInfo.BackgroundTransparency = 1
toolInfo.TextColor3 = Color3.fromRGB(160, 160, 180)
toolInfo.Text = "Holding: None"
toolInfo.Font = Enum.Font.Gotham
toolInfo.TextSize = 13
toolInfo.TextXAlignment = Enum.TextXAlignment.Left
toolInfo.Parent = contentArea

-- // Alt bilgi
local footerBar = Instance.new("Frame")
footerBar.Name = "FooterBar"
footerBar.Size = UDim2.new(1, 0, 0, 25)
footerBar.Position = UDim2.new(0, 0, 0, 190)
footerBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
footerBar.BorderSizePixel = 0
footerBar.Parent = contentArea

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 8)
footerCorner.Parent = footerBar

local footerText = Instance.new("TextLabel")
footerText.Name = "FooterText"
footerText.Size = UDim2.new(1, 0, 1, 0)
footerText.Position = UDim2.new(0, 10, 0, 0)
footerText.BackgroundTransparency = 1
footerText.TextColor3 = Color3.fromRGB(120, 120, 140)
footerText.Text = "Tool Duper v2.0 | Press ENABLE to start"
footerText.Font = Enum.Font.Gotham
footerText.TextSize = 11
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footerBar

-- // Toplam içerik yüksekliği
contentArea.Size = UDim2.new(1, 0, 0, 220) -- durum paneli + buton + bilgi + footer

-- Animasyon fonksiyonları
local function tweenObject(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = tweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Menü açılış animasyonu
mainContainer.Size = UDim2.new(0, 280, 0, 0)
mainContainer.ClipsDescendants = true
tweenObject(mainContainer, {Size = UDim2.new(0, 280, 0, 265)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tweenObject(mainContainer, {Position = UDim2.new(0.5, -140, 0.5, -132)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Buton hover efektleri
local function addButtonHover(button)
    button.MouseEnter:Connect(function()
        tweenObject(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)
    end)
    button.MouseLeave:Connect(function()
        tweenObject(button, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
    end)
end

addButtonHover(minimizeButton)
addButtonHover(closeButton)

-- Dupe buton hoverı
dupeButton.MouseEnter:Connect(function()
    if not isDupeEnabled then
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(40, 200, 80)}, 0.2)
    else
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(220, 40, 40)}, 0.2)
    end
end)

dupeButton.MouseLeave:Connect(function()
    if not isDupeEnabled then
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(30, 170, 70)}, 0.2)
    else
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}, 0.2)
    end
end)

-- // Minimize / Kapatma İşlevleri
local originalSize = UDim2.new(0, 280, 0, 265)
local minimizedSize = UDim2.new(0, 280, 0, 45)
local originalPosition = UDim2.new(0.5, -140, 0.5, -132)

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tweenObject(mainContainer, {Size = minimizedSize}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        minimizeButton.Text = "+"
    else
        tweenObject(mainContainer, {Size = originalSize}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        minimizeButton.Text = "—"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    tweenObject(mainContainer, {Size = UDim2.new(0, 280, 0, 0), Position = UDim2.new(0.5, -140, 0.5, -0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.wait(0.3)
    screenGui:Destroy()
end)

-- // Dupe Ana Mantığı
local function dupeTool()
    if not isDupeEnabled then return end
    local character = player.Character
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        toolInfo.Text = "Holding: " .. tool.Name
        if tool ~= lastTool and not cooldown then
            cooldown = true
            local newTool = tool:Clone()
            newTool.Parent = player.Backpack
            task.wait(0.5)
            cooldown = false
            lastTool = tool
        end
    else
        toolInfo.Text = "Holding: None"
        lastTool = nil
    end
end

-- Dupe Buton Toggle
dupeButton.MouseButton1Click:Connect(function()
    isDupeEnabled = not isDupeEnabled
    if isDupeEnabled then
        -- Aktif animasyonu
        dupeButton.Text = "DISABLE DUPER"
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}, 0.3)
        dupeButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 20, 20))
        }
        statusValue.Text = "ACTIVE"
        statusValue.TextColor3 = Color3.fromRGB(60, 255, 60)
        tweenObject(statusDot, {BackgroundColor3 = Color3.fromRGB(60, 255, 60)}, 0.3)
        footerText.Text = "Tool Duper v2.0 | Duplicating..."
        lastTool = nil
    else
        -- Pasif animasyonu
        dupeButton.Text = "ENABLE DUPER"
        tweenObject(dupeButton, {BackgroundColor3 = Color3.fromRGB(30, 170, 70)}, 0.3)
        dupeButtonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 180, 70)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 130, 50))
        }
        statusValue.Text = "INACTIVE"
        statusValue.TextColor3 = Color3.fromRGB(255, 60, 60)
        tweenObject(statusDot, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, 0.3)
        footerText.Text = "Tool Duper v2.0 | Press ENABLE to start"
    end
end)

-- // Sürükleme Sistemi
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Ana döngü
runService.Heartbeat:Connect(dupeTool)

-- // Durum noktası yanıp sönme efekti (aktifken)
spawn(function()
    while task.wait(1) do
        if isDupeEnabled and mainContainer and mainContainer.Parent then
            tweenObject(statusDot, {BackgroundTransparency = 0.7}, 0.3)
            task.wait(0.3)
            tweenObject(statusDot, {BackgroundTransparency = 0}, 0.3)
        end
    end
end)
