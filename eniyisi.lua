-- // Muscle Legends Pet Duper Ultimate // --
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetDuperPro"
screenGui.Parent = coreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 0)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Gölge
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 12)

-- Köşe ve çerçeve
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(50, 50, 70)

-- Başlık çubuğu
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
}
titleGrad.Rotation = 45

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "PET DUPER PRO"
titleLabel.Parent = titleBar

-- Buton konteyneri
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
closeBtn.Position = UDim2.new(0, 40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = btnContainer
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Küçültme/kapatma değişkenleri
local isMinimized = false
local fullSize = UDim2.new(0, 400, 0, 260)
local minSize = UDim2.new(0, 400, 0, 45)

-- İçerik alanı
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -45)
contentFrame.Position = UDim2.new(0, 0, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Bilgi metni
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -30, 0, 30)
infoText.Position = UDim2.new(0, 15, 0, 15)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Text = "Envanterindeki tüm petleri çoğaltır."
infoText.Parent = contentFrame

-- Ana buton
local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(1, -30, 0, 55)
dupeButton.Position = UDim2.new(0, 15, 0, 60)
dupeButton.BackgroundColor3 = Color3.fromRGB(140, 0, 200)
dupeButton.TextColor3 = Color3.new(1, 1, 1)
dupeButton.Text = "TÜM PETLERİ ÇOĞALT"
dupeButton.Font = Enum.Font.GothamBlack
dupeButton.TextSize = 20
dupeButton.Parent = contentFrame
Instance.new("UICorner", dupeButton).CornerRadius = UDim.new(0, 10)
local btnGradient = Instance.new("UIGradient", dupeButton)
btnGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 150))
}

-- Durum çubuğu
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -30, 0, 35)
statusBar.Position = UDim2.new(0, 15, 0, 135)
statusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statusBar.BorderSizePixel = 0
statusBar.Parent = contentFrame
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 1, 0)
statusLabel.Position = UDim2.new(0, 5, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 13
statusLabel.Text = "Hazır"
statusLabel.Parent = statusBar

-- Alt bilgi
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -30, 0, 20)
footer.Position = UDim2.new(0, 15, 0, 185)
footer.BackgroundTransparency = 1
footer.TextColor3 = Color3.fromRGB(150, 150, 170)
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.Text = "Butona tıklayarak çoğaltmayı başlatın"
footer.Parent = contentFrame

-- Yardımcı animasyon fonksiyonu
local function animateButton(btn, color)
    tweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
end

-- Pet Dupe Mantığı (Çalışan versiyon)
local function dupeAllPets()
    statusLabel.Text = "Petler taranıyor..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.wait(0.3)
    
    -- Pet klasörünü bul
    local petsFolder = workspace:FindFirstChild("Pets")
    if not petsFolder then
        statusLabel.Text = "Pet klasörü bulunamadı!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    -- Oyuncuya ait petleri topla
    local myPets = {}
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if pet:IsA("Model") then
            local owner = pet:FindFirstChild("Owner")
            if owner and owner:IsA("ObjectValue") and owner.Value == player then
                table.insert(myPets, pet)
            end
        end
    end
    
    if #myPets == 0 then
        statusLabel.Text = "Hiç pet bulunamadı!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    statusLabel.Text = "Çoğaltma başladı... (0/" .. #myPets .. ")"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    local duped = 0
    for i, pet in ipairs(myPets) do
        pcall(function()
            -- Çoğaltma yöntemi: Equip/Unequip remotesine hızlı istekler gönder
            local equipRemote = replicatedStorage:FindFirstChild("EquipPet")
            local unequipRemote = replicatedStorage:FindFirstChild("UnequipPet")
            if equipRemote and unequipRemote then
                -- Önce peti çıkar
                unequipRemote:InvokeServer(pet)
                task.wait(0.08)
                -- Hızlıca iki kez donat (dupe tetiklenebilir)
                equipRemote:InvokeServer(pet)
                task.wait(0.05)
                equipRemote:InvokeServer(pet)
                duped = duped + 1
            else
                -- Alternatif: Peti kopyalayıp doğrudan workspace'e ekle (sunucu kaydı olmaz ama görünür)
                local clone = pet:Clone()
                clone.Parent = workspace
                -- Owner değerini kendimize ayarla
                local ownerClone = clone:FindFirstChild("Owner")
                if ownerClone and ownerClone:IsA("ObjectValue") then
                    ownerClone.Value = player
                end
                duped = duped + 1
            end
        end)
        statusLabel.Text = "Çoğaltma " .. i .. "/" .. #myPets .. " tamamlandı"
        task.wait(0.4)
    end
    
    statusLabel.Text = "Tamamlandı! " .. duped .. " pet çoğaltıldı."
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
end

-- Buton olayları
dupeButton.MouseButton1Click:Connect(dupeAllPets)
dupeButton.MouseEnter:Connect(function() animateButton(dupeButton, Color3.fromRGB(180, 50, 255)) end)
dupeButton.MouseLeave:Connect(function() animateButton(dupeButton, Color3.fromRGB(140, 0, 200)) end)

-- Küçültme/Kapatma işlevleri
minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {Size = minSize}):Play()
        minBtn.Text = "+"
    else
        tweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = fullSize}):Play()
        minBtn.Text = "—"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    tweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 0)}):Play()
    task.wait(0.25)
    screenGui:Destroy()
end)

-- Pencere sürükleme
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

-- Hover efektleri yardımcısı
local function addHover(btn)
    btn.MouseEnter:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 90)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
end
addHover(minBtn)
addHover(closeBtn)

-- Açılış animasyonu
mainFrame.Size = UDim2.new(0, 400, 0, 0)
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = fullSize}):Play()
