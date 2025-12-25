-- Troll Hub responsivo (PC + Mobile) com abas exclusivas
-- Coloque em LocalScript no StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ---------- Config ----------
local WINDOW_WIDTH = 420
local WINDOW_HEIGHT = 520
local BUTTON_FLOAT_SIZE = UDim2.fromOffset(56, 56)
local IS_TOUCH = UserInputService.TouchEnabled

-- Ajustes para mobile (tamanhos maiores)
if IS_TOUCH then
    WINDOW_WIDTH = 360
    WINDOW_HEIGHT = 640
end

-- ---------- Criar ScreenGui ----------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Evita que o sistema mova a GUI em mobile
screenGui.IgnoreGuiInset = true

-- ---------- Janela principal ----------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, WINDOW_WIDTH, 0, WINDOW_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -WINDOW_WIDTH/2, 0.5, -WINDOW_HEIGHT/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Cabeçalho
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Troll Hub"
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Font = Enum.Font.SourceSansBold
title.TextSize = IS_TOUCH and 20 or 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botão fechar/minimizar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "—"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

local isVisible = true
closeBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    mainFrame.Visible = isVisible
end)

-- Área de tabs (botões)
local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "Tabs"
tabsFrame.Size = UDim2.new(1, -24, 0, 44)
tabsFrame.Position = UDim2.new(0, 12, 0, 56)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Padding = UDim.new(0, 8)

-- Conteúdo (onde os componentes aparecem)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -24, 1, -132)
contentFrame.Position = UDim2.new(0, 12, 0, 112)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 8
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 10)

-- Atualiza CanvasSize automaticamente
local function updateCanvas()
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
end
contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- ---------- Helpers de UI ----------
local function makeTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, IS_TOUCH and 84 or 96, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = IS_TOUCH and 14 or 15
    btn.Text = text
    btn.LayoutOrder = order or 1
    btn.Parent = tabsFrame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

local function makeSection(titleText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 48)
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    frame.LayoutOrder = #contentFrame:GetChildren() + 1

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    return frame
end

local function makeButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IS_TOUCH and 56 or 40)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = IS_TOUCH and 18 or 16
    btn.Text = text
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

local function makeToggle(textOff, textOn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, IS_TOUCH and 56 or 40)
    btn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = IS_TOUCH and 18 or 16
    btn.Text = textOff
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

-- Slider visual compatível com touch/mouse
local function makeSlider(labelText, minVal, maxVal, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, IS_TOUCH and 72 or 56)
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 20)
    label.Position = UDim2.new(0, 6, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextSize = IS_TOUCH and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -12, 0, 12)
    bar.Position = UDim2.new(0, 6, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
    bar.Parent = frame
    local barCorner = Instance.new("UICorner", bar)
    barCorner.CornerRadius = UDim.new(0, 6)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.Parent = bar
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 6)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, IS_TOUCH and 28 or 18, 0, IS_TOUCH and 28 or 18)
    knob.Position = UDim2.new(0, -((IS_TOUCH and 28 or 18)/2), 0.5, -((IS_TOUCH and 28 or 18)/2))
    knob.BackgroundColor3 = Color3.fromRGB(240,240,240)
    knob.Parent = bar
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1,0)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -66, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(230,230,230)
    valueLabel.Font = Enum.Font.SourceSansSemibold
    valueLabel.TextSize = IS_TOUCH and 16 or 14
    valueLabel.Parent = frame

    -- calcula posição do knob e fill a partir de valor
    local function setValue(v)
        v = math.clamp(v, minVal, maxVal)
        local ratio = (v - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        local barWidth = bar.AbsoluteSize.X
        local knobX = math.clamp(ratio * barWidth - knob.AbsoluteSize.X/2, -knob.AbsoluteSize.X/2, barWidth - knob.AbsoluteSize.X/2)
        knob.Position = UDim2.new(0, knobX, 0.5, -knob.AbsoluteSize.Y/2)
        valueLabel.Text = tostring(math.floor(v))
    end

    -- interação touch/mouse
    local dragging = false
    local function inputToValue(inputPos)
        local barPos = bar.AbsolutePosition
        local barSize = bar.AbsoluteSize
        local x = inputPos.X - barPos.X
        local ratio = x / barSize.X
        local v = minVal + ratio * (maxVal - minVal)
        return math.clamp(v, minVal, maxVal)
    end

    local function beginDrag(input)
        dragging = true
        local v = inputToValue(input.Position)
        setValue(v)
        if frame.OnValueChanged then frame.OnValueChanged(math.floor(v)) end
    end

    local function updateDrag(input)
        if not dragging then return end
        local v = inputToValue(input.Position)
        setValue(v)
        if frame.OnValueChanged then frame.OnValueChanged(math.floor(v)) end
    end

    local function endDrag()
        dragging = false
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then endDrag() end
            end)
        end
    end)

    bar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)

    -- inicializa
    RunService.Heartbeat:Wait()
    setValue(default or minVal)

    -- expõe função para set/get e callback
    function frame.Set(v) setValue(v) end
    function frame.Get()
        return tonumber(valueLabel.Text) or default
    end
    return frame
end

-- ---------- Sistema de abas (apenas uma aberta) ----------
local tabs = {}
local tabContents = {}
local currentTab = nil

local function createTab(name)
    local btn = makeTabButton(name, #tabs + 1)
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = contentFrame
    content.LayoutOrder = #tabContents + 1
    local layout = Instance.new("UIListLayout", content)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    tabContents[name] = content
    tabs[name] = btn

    btn.MouseButton1Click:Connect(function()
        -- fecha aba atual se for a mesma (toggle)
        if currentTab == name then
            tabContents[name].Visible = false
            currentTab = nil
            updateCanvas()
            return
        end
        -- fecha a anterior
        if currentTab and tabContents[currentTab] then
            tabContents[currentTab].Visible = false
        end
        -- abre a nova
        tabContents[name].Visible = true
        currentTab = name
        updateCanvas()
    end)

    return tabContents[name], btn
end

-- ---------- Criar abas e componentes ----------
-- Aba 1: Movimentação
local movContent, movBtn = createTab("Movimentação")
do
    local s1 = makeSection("Movimentação Maluca")
    s1.Parent = movContent

    local btnTeleport = makeButton("Teleport Aleatório")
    btnTeleport.Parent = movContent
    btnTeleport.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(math.random(-100,100), 10, math.random(-100,100))
        end
    end)

    local btnSuperJump = makeButton("Super Salto")
    btnSuperJump.Parent = movContent
    btnSuperJump.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            local old = humanoid.JumpPower
            humanoid.JumpPower = 300
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.delay(2, function()
                if humanoid then humanoid.JumpPower = old end
            end)
        end
    end)

    local toggleRun = makeToggle("Corrida Infinita: OFF", "Corrida Infinita: ON")
    toggleRun.Parent = movContent
    local runState = false
    toggleRun.MouseButton1Click:Connect(function()
        runState = not runState
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = runState and 200 or 16 end
        toggleRun.Text = runState and "Corrida Infinita: ON" or "Corrida Infinita: OFF"
        toggleRun.BackgroundColor3 = runState and Color3.fromRGB(100,255,100) or Color3.fromRGB(220,80,80)
    end)

    local sliderSpeed = makeSlider("Velocidade", 8, 200, 16)
    sliderSpeed.Parent = movContent
    sliderSpeed.OnValueChanged = function(v)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = v end
    end
end

-- Aba 2: Players
local playersContent, playersBtn = createTab("Players")
do
    local s2 = makeSection("Players")
    s2.Parent = playersContent

    local btnTeleportPlayer = makeButton("Teleport até Jogador Aleatório")
    btnTeleportPlayer.Parent = playersContent
    btnTeleportPlayer.MouseButton1Click:Connect(function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        local target = list[math.random(1,#list)]
        if target == LocalPlayer then
            for _,p in pairs(list) do if p ~= LocalPlayer then target = p break end end
        end
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,2)
        end
    end)

    local btnPush = makeButton("Empurrar Jogador Próximo")
    btnPush.Parent = playersContent
    btnPush.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = plr.Character.HumanoidRootPart
                local dist = (targetHRP.Position - hrp.Position).Magnitude
                if dist <= 10 then
                    targetHRP.Velocity = (targetHRP.Position - hrp.Position).Unit * 60 + Vector3.new(0, 30, 0)
                end
            end
        end
    end)

    local toggleFollow = makeToggle("Seguir Aleatório: OFF", "Seguir Aleatório: ON")
    toggleFollow.Parent = playersContent
    local followState = false
    toggleFollow.MouseButton1Click:Connect(function()
        followState = not followState
        toggleFollow.Text = followState and "Seguir Aleatório: ON" or "Seguir Aleatório: OFF"
        toggleFollow.BackgroundColor3 = followState and Color3.fromRGB(100,255,100) or Color3.fromRGB(220,80,80)
        if followState then
            spawn(function()
                while followState do
                    local list = Players:GetPlayers()
                    if #list > 1 then
                        local target = list[math.random(1,#list)]
                        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,3)
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end)

    local sliderDist = makeSlider("Distância Seguimento", 1, 20, 3)
    sliderDist.Parent = playersContent
    sliderDist.OnValueChanged = function(v)
        -- expõe se quiser usar
    end
end

-- Aba 3: Diversão
local funContent, funBtn = createTab("Diversão")
do
    local s3 = makeSection("Diversão Troll")
    s3.Parent = funContent

    local btnDance = makeButton("Dançar Aleatório")
    btnDance.Parent = funContent
    btnDance.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://507771019"
            local track = humanoid:LoadAnimation(anim)
            track:Play()
            task.delay(4, function() track:Stop() end)
        end
    end)

    local btnConfuse = makeButton("Confundir Movimento")
    btnConfuse.Parent = funContent
    btnConfuse.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            local old = humanoid.WalkSpeed
            humanoid.WalkSpeed = -math.abs(old)
            task.delay(2, function()
                if humanoid then humanoid.WalkSpeed = math.abs(old) end
            end)
        end
    end)

    local toggleLaugh = makeToggle("Risada Troll: OFF", "Risada Troll: ON")
    toggleLaugh.Parent = funContent
    local laughState = false
    toggleLaugh.MouseButton1Click:Connect(function()
        laughState = not laughState
        toggleLaugh.Text = laughState and "Risada Troll: ON" or "Risada Troll: OFF"
        toggleLaugh.BackgroundColor3 = laughState and Color3.fromRGB(100,255,100) or Color3.fromRGB(220,80,80)
        if laughState then
            spawn(function()
                while laughState do
                    -- placeholder: tocar som se tiver permissão
                    task.wait(1)
                end
            end)
        end
    end)

    local sliderTroll = makeSlider("Intensidade Troll", 1, 10, 1)
    sliderTroll.Parent = funContent
end

-- Aba 4: Modo God
local godContent, godBtn = createTab("Modo God")
do
    local s4 = makeSection("Modo God")
    s4.Parent = godContent

    local btnInvis = makeButton("Ativar Invisibilidade")
    btnInvis.Parent = godContent
    local invisState = false
    btnInvis.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        invisState = not invisState
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = invisState and 1 or 0
            end
            if part:IsA("Decal") then
                part.Transparency = invisState and 1 or 0
            end
        end
        btnInvis.Text = invisState and "Desativar Invisibilidade" or "Ativar Invisibilidade"
    end)

    local btnGod = makeButton("Ativar God Mode")
    btnGod.Parent = godContent
    local godState = false
    btnGod.MouseButton1Click:Connect(function()
        godState = not godState
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = godState and math.huge or 100
                humanoid.Health = humanoid.MaxHealth
            end
        end
        btnGod.Text = godState and "Desativar God Mode" or "Ativar God Mode"
    end)

    local toggleAntiFall = makeToggle("Anti-Queda: OFF", "Anti-Queda: ON")
    toggleAntiFall.Parent = godContent
    local antiFall = false
    toggleAntiFall.MouseButton1Click:Connect(function()
        antiFall = not antiFall
        toggleAntiFall.Text = antiFall and "Anti-Queda: ON" or "Anti-Queda: OFF"
        toggleAntiFall.BackgroundColor3 = antiFall and Color3.fromRGB(100,255,100) or Color3.fromRGB(220,80,80)
        if antiFall then
            spawn(function()
                while antiFall do
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        if hrp.Position.Y < 5 then
                            hrp.CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end)
end

-- ---------- Botão flutuante (toggle janela) ----------
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatToggle"
floatBtn.Size = BUTTON_FLOAT_SIZE
floatBtn.Position = UDim2.new(0, 18, 0.5, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
floatBtn.Text = "Hub"
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Font = Enum.Font.SourceSansBold
floatBtn.TextSize = IS_TOUCH and 16 or 14
floatBtn.Parent = screenGui
local floatCorner = Instance.new("UICorner", floatBtn)
floatCorner.CornerRadius = UDim.new(1,0)

floatBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    mainFrame.Visible = isVisible
end)

-- Arrastar botão flutuante (touch + mouse)
do
    local dragging = false
    local dragStart, startPos
    floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    floatBtn.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            floatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Arrastar janela pelo header (touch + mouse)
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ---------- Inicialização ----------
-- Abre a primeira aba por padrão
for name,_ in pairs(tabContents) do
    currentTab = name
    tabContents[name].Visible = true
    break
end
updateCanvas()

-- Reaplica visibilidade ao respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if isVisible then mainFrame.Visible = true end
end)

-- Fim do script
