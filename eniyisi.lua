-- // Muscle Legends Pet Dupe PRO // --
local player = game:GetService("Players").LocalPlayer
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetDupePro"
screenGui.Parent = coreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 0)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Thickness = 1.5; mainFrame.UIStroke.Color = Color3.fromRGB(50, 50, 70)

-- Başlık
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
titleBar:FindFirstChild("UIGradient"):Destroy() -- temizleyelim, yeni gradyan
local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 255))
}
titleGrad.Rotation = 45

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "PET DUPER"

-- Buton container
local btnContainer = Instance.new("Frame", titleBar)
btnContainer.Size = UDim2.new(0, 80, 1, 0)
btnContainer.Position = UDim2.new(1, -85, 0, 0)
btnContainer.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", btnContainer)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0, 0, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", btnContainer)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0, 40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local isMinimized = false
local fullSize = UDim2.new(0, 400, 0, 250)
local minSize = UDim2.new(0, 400, 0, 40)

-- İçerik alanı
local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1

-- Bilgilendirme etiketi
local infoLabel = Instance.new("TextLabel", content)
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 15)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Text = "Envanterindeki tüm petleri çoğaltır."

-- Dupe butonu
local dupeAllBtn = Instance.new("TextButton", content)
dupeAllBtn.Size = UDim2.new(1, -20, 0, 50)
dupeAllBtn.Position = UDim2.new(0, 10, 0, 60)
dupeAllBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 200)
dupeAllBtn.TextColor3 = Color3.new(1, 1, 1)
dupeAllBtn.Text = "DUPE ALL PETS"
dupeAllBtn.Font = Enum.Font.GothamBlack
dupeAllBtn.TextSize = 20
Instance.new("UICorner", dupeAllBtn).CornerRadius = UDim.new(0, 10)
Instance.new("UIGradient", dupeAllBtn).Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 0, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 150))
}

-- Durum göstergesi
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 125)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = ""

-- Pet Dupe işlevi (envanterdeki tüm petleri çoğaltır)
local function dupeAllPets()
    statusLabel.Text = "Petler taranıyor..."
    task.wait(0.2)
    
    -- Oyuncunun petlerini bul (genelde workspace.Pets veya player.Pets)
    local petsFolder = workspace:FindFirstChild("Pets") or player:FindFirstChild("Pets")
    if not petsFolder then
        statusLabel.Text = "Pet klasörü bulunamadı!"
        return
    end

    local pets = {}
    for _, pet in ipairs(petsFolder:GetChildren()) do
        if pet:IsA("Model") and pet:FindFirstChild("Owner") and pet.Owner.Value == player then
            table.insert(pets, pet)
        end
    end

    if #pets == 0 then
        statusLabel.Text = "Hiç pet bulunamadı!"
        return
    end

    statusLabel.Text = "Çoğaltma başlıyor..."
    local dupedCount = 0
    for _, pet in ipairs(pets) do
        pcall(function()
            -- Pet donat/çıkart işlemiyle dupe dene (hızlı Equip/Unequip)
            local equipRemote = game:GetService("ReplicatedStorage"):FindFirstChild("EquipPet") or 
                                game:GetService("ReplicatedStorage"):FindFirstChild("PetEquip")
            local unequipRemote = game:GetService("ReplicatedStorage"):FindFirstChild("UnequipPet") or 
                                  game:GetService("ReplicatedStorage"):FindFirstChild("PetUnequip")
            if equipRemote and unequipRemote then
                -- Peti çıkar
                unequipRemote:InvokeServer(pet)
                task.wait(0.1)
                -- İki kez hızlıca donat (bazen dupe yapar)
                equipRemote:InvokeServer(pet)
                task.wait(0.05)
                equipRemote:InvokeServer(pet)
                dupedCount = dupedCount + 1
            end
        end)
        task.wait(0.3)
    end
    statusLabel.Text = "Tamamlandı! " .. dupedCount .. " pet çoğaltıldı."
end

dupeAllBtn.MouseButton1Click:Connect(dupeAllPets)

-- Buton efektleri
dupeAllBtn.MouseEnter:Connect(function()
    tweenService:Create(dupeAllBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 50, 255)}):Play()
end)
dupeAllBtn.MouseLeave:Connect(function()
    tweenService:Create(dupeAllBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 0, 200)}):Play()
end)
local function addHover(btn)
    btn.MouseEnter:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play() end)
    btn.MouseLeave:Connect(function() tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play() end)
end
addHover(minBtn)
addHover(closeBtn)

-- Küçültme/Kapatma
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

closeBtn.MouseButton1Click:Connect(function()
    tweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 400, 0, 0)}):Play()
    task.wait(0.2)
    screenGui:Destroy()
end)

-- Sürükleme
local dragging, dragStart, startPos
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
mainFrame.Size = UDim2.new(0, 400, 0, 0)
tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = fullSize}):Play()
