-- (Parte inicial del script sin cambios)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Agregar un efecto de borrado (frosted glass) a la GUI
local BlurEffect = Instance.new("BlurEffect", ScreenGui)
BlurEffect.Size = 5

-- Detectar si el jugador es móvil
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local scaleFactor = isMobile and 0.7 or 1  -- Reducir un 30% en móviles

-- FRAME (Se aumenta la altura para acomodar los nuevos botones: 450)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300 * scaleFactor, 0, 450 * scaleFactor)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local FrameGradient = Instance.new("UIGradient", Frame)
FrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
FrameGradient.Rotation = 90

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 10 * scaleFactor)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(100, 100, 200)
UIStroke.Thickness = 2

-- TITLEBAR
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 25 * scaleFactor)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BackgroundTransparency = 0.2

local TitleBarGradient = Instance.new("UIGradient", TitleBar)
TitleBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 70))
})
TitleBarGradient.Rotation = 0

local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(1, 0)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -50 * scaleFactor, 1, 0)
TitleLabel.Position = UDim2.new(0, 5 * scaleFactor, 0, 0)
TitleLabel.Text = "Celestial TP"
TitleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansItalic
TitleLabel.TextSize = 18 * scaleFactor

-- Reemplazo de "✖" -> "X"
local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0, 25 * scaleFactor, 1, 0)
CloseButton.Position = UDim2.new(1, -25 * scaleFactor, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.SourceSansItalic
CloseButton.TextSize = 16 * scaleFactor
local CloseButtonCorner = Instance.new("UICorner", CloseButton)
CloseButtonCorner.CornerRadius = UDim.new(1, 0)

-- Reemplazo de "–" -> "-"
local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 25 * scaleFactor, 1, 0)
MinimizeButton.Position = UDim2.new(1, -50 * scaleFactor, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.Font = Enum.Font.SourceSansItalic
MinimizeButton.TextSize = 16 * scaleFactor
local MinimizeButtonCorner = Instance.new("UICorner", MinimizeButton)
MinimizeButtonCorner.CornerRadius = UDim.new(1, 0)

-- Función auxiliar para crear botones
local function createButton(parent, text, posY)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -10 * scaleFactor, 0, 30 * scaleFactor)
    button.Position = UDim2.new(0, 5 * scaleFactor, 0, posY * scaleFactor)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansItalic
    button.TextSize = 14 * scaleFactor
    local buttonCorner = Instance.new("UICorner", button)
    buttonCorner.CornerRadius = UDim.new(1, 0)
    return button
end

-- DROPDOWN & PLAYERLIST
local Dropdown = createButton(Frame, "Seleccionar Jugador:)", 40)
local UpdateButton = createButton(Frame, "Actualizar lista", 75)
UpdateButton.MouseButton1Click:Connect(function()
    updatePlayerList()
end)

local PlayerList = Instance.new("ScrollingFrame", Frame)
PlayerList.Size = UDim2.new(1, -10 * scaleFactor, 0, 150 * scaleFactor)
PlayerList.Position = UDim2.new(0, 5 * scaleFactor, 0, 110 * scaleFactor)
PlayerList.CanvasSize = UDim2.new(0, 280 * scaleFactor, 0, 0)
PlayerList.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PlayerList.BackgroundTransparency = 0.5
PlayerList.ScrollBarThickness = 8 * scaleFactor
PlayerList.Visible = true
local PlayerListCorner = Instance.new("UICorner", PlayerList)
PlayerListCorner.CornerRadius = UDim.new(1, 0)

-- TP BUTTONS
local TeleportButton = createButton(Frame, "Start TP", 260)
TeleportButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Color original

-- Reemplazo de "Stop TP ✋" -> "Stop TP"
local StopButton = createButton(Frame, "Stop TP", 300)
StopButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)  -- Color original

-- NUEVOS BOTONES DE AUTOKILL
local StartAutoKillButton = createButton(Frame, "Start Autokill", 335)
StartAutoKillButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Color original

-- Reemplazo de "Stop Autokill ✋" -> "Stop Autokill"
local StopAutoKillButton = createButton(Frame, "Stop Autokill", 375)
StopAutoKillButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)  -- Color original

-- LOGS
local Logs = Instance.new("TextLabel", Frame)
Logs.Size = UDim2.new(1, -10 * scaleFactor, 0, 30 * scaleFactor)
Logs.Position = UDim2.new(0, 5 * scaleFactor, 0, 415 * scaleFactor)
Logs.TextColor3 = Color3.fromRGB(240, 240, 240)
Logs.BackgroundTransparency = 1
Logs.Text = "TP: Listo"
Logs.Font = Enum.Font.SourceSansItalic
Logs.TextSize = 14 * scaleFactor
Logs.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZED CIRCLE (botón "CelestialTP")
local MinimizedCircle = Instance.new("TextButton", ScreenGui)
MinimizedCircle.Size = UDim2.new(0, 50 * scaleFactor, 0, 50 * scaleFactor)
MinimizedCircle.Position = UDim2.new(0.05, 0, 0.05, 0)
MinimizedCircle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizedCircle.BackgroundTransparency = 0.5
MinimizedCircle.Text = "CelestialTP"
MinimizedCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedCircle.Font = Enum.Font.SourceSansItalic
MinimizedCircle.TextSize = 14 * scaleFactor
MinimizedCircle.Visible = false
MinimizedCircle.Active = true
MinimizedCircle.Draggable = true
local MinimizedCircleCorner = Instance.new("UICorner", MinimizedCircle)
MinimizedCircleCorner.CornerRadius = UDim.new(1, 0)
local MinimizedCircleStroke = Instance.new("UIStroke", MinimizedCircle)
MinimizedCircleStroke.Color = Color3.new(0, 0, 0)
MinimizedCircleStroke.Thickness = 2

---------------------------------------------------------------------
-- VARIABLES Y FUNCIONES (SIN ALTERAR LA LÓGICA)
local selectedPlayer = nil
local teleporting = false
local teleportConnection
local autoKillActive = false
local blockActive = false
local originalHRPSize = nil  -- Para guardar el tamaño original del HRP

local restrictedPlayers = {"ClauzTG", "AnGamerPlay", "Crocrakxer246"}

local function isRestricted(player)
    for _, name in ipairs(restrictedPlayers) do
        if player.Name == name then
            return true
        end
    end
    return false
end

local function updatePlayerList()
    PlayerList:ClearAllChildren()
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            count = count + 1
            local PlayerButton = Instance.new("TextButton", PlayerList)
            PlayerButton.Size = UDim2.new(1, -10 * scaleFactor, 0, 30 * scaleFactor)
            PlayerButton.Position = UDim2.new(0, 5 * scaleFactor, 0, (count - 1) * 35 * scaleFactor)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            PlayerButton.Font = Enum.Font.SourceSansItalic
            PlayerButton.TextSize = 14 * scaleFactor
            local PlayerButtonCorner = Instance.new("UICorner", PlayerButton)
            PlayerButtonCorner.CornerRadius = UDim.new(1, 0)
            
            PlayerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player
                Dropdown.Text = "Jugador: " .. player.Name
                Logs.Text = "Jugador " .. player.Name .. " seleccionado"
                PlayerList.Visible = false
            end)
        end
    end
    PlayerList.CanvasSize = UDim2.new(0, 280 * scaleFactor, 0, count * 35 * scaleFactor)
end

-- Función de teletransporte (sin tocar la lógica)
local function remoteTeleport(targetPlayer)
    local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local localCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
    local localHRP = localCharacter:FindFirstChild("HumanoidRootPart") or localCharacter.PrimaryPart or localCharacter:WaitForChild("HumanoidRootPart", 5)
    
    if targetHRP and localHRP then
        local backDistance = targetHRP.Size.Z / 2 + 1.0
        local desiredCF = targetHRP.CFrame * CFrame.new(0, -0.3, backDistance)
        localHRP.CFrame = desiredCF
        localHRP.Velocity = Vector3.new(0, 0, 0)
        localHRP.RotVelocity = Vector3.new(0, 0, 0)
        
        Logs.Text = "TP: Funcionando"
    else
        Logs.Text = "TP: Error, el jugador está demasiado lejos."
    end
end

Dropdown.MouseButton1Click:Connect(function()
    PlayerList.Visible = true
    updatePlayerList()
end)

TeleportButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        if isRestricted(selectedPlayer) then
            Logs.Text = "No puedes hacer esto con el creador"
            Logs.TextColor3 = Color3.fromRGB(139, 0, 0)
            Logs.Font = Enum.Font.SourceSansItalic
            return
        end
        teleporting = true
        teleportConnection = RunService.Heartbeat:Connect(function()
            if teleporting then
                remoteTeleport(selectedPlayer)
            end
        end)
    else
        Logs.Text = "TP: No hay jugador seleccionado ❌"
    end
end)

StopButton.MouseButton1Click:Connect(function()
    teleporting = false
    if teleportConnection then
        teleportConnection:Disconnect()
        teleportConnection = nil
    end
    Logs.Text = "TP: Detenido"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        hrp.Anchored = true
        wait(0.1)
        hrp.Anchored = false
    end
end)

---------------------------------------------------------------------
-- Funciones de Autokill (con delay reducido a 0.005 s en cada ataque)
local attack1  = "Mach Kick"
local attack2  = "God Slicer"
local attack3  = "High Power Rush"
local attack4  = "Destruction"
local attack5  = "Wolf Fang Fist"
local attack6  = ""
local attack7  = "Sledgehammer"
local attack8  = "Super Dragon Fist"
local attack9  = "Meteor Strike"
local attack10 = "Meteor Crash"
local attack11 = "Bone Crusher"
local attack12 = "Flash Kick"
local attack13 = "Spirit Breaking Cannon"
local attack14 = "Vanish Strike"
local attack15 = "Uppercut"
local attack16 = "Vital Strike"
local attack17 = "Meteor Charge"
local attack18 = "Energy Volley"
local attack19 = "p"

-- Declarar equipArgs globalmente para la transformación
local equipArgs = { [1] = "Divine Rose Prominence" }
local transformed = false

-- Al reaparecer, se reinicia la bandera y si AutoKill está activo se vuelve a transformar
LocalPlayer.CharacterAdded:Connect(function(character)
    transformed = false
    if autoKillActive then
        wait(1)
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("equipskill"):InvokeServer(unpack(equipArgs))
        wait(1)
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("ta"):InvokeServer()
        transformed = true
    end
end)

local function activateAbility()
    autoKillActive = true
    local args = { [1] = "Attack Name", [2] = "Blacknwhite27" }
    if selectedPlayer and isRestricted(selectedPlayer) then
        Logs.Text = "No puedes hacer esto con el creador"
        Logs.TextColor3 = Color3.fromRGB(139, 0, 0)
        Logs.Font = Enum.Font.SourceSansItalic
        return
    end
    -- Si no está transformado, se ejecuta la transformación
    if not transformed then
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("equipskill"):InvokeServer(unpack(equipArgs))
        wait(1)
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("ta"):InvokeServer()
        transformed = true
    end

    while autoKillActive do
        -- Si se detecta que no está transformado (por ejemplo, tras morir y reaparecer) se vuelve a transformar
        if not transformed and LocalPlayer.Character then
            ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("equipskill"):InvokeServer(unpack(equipArgs))
            wait(1)
            ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("ta"):InvokeServer()
            transformed = true
        end

        -- ACTIVAR RELOAD KI y BLOQUEO mientras AutoKill esté activo (lo más rápido posible)
        local chaArgs = { [1] = "Blacknwhite27" }
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("cha"):InvokeServer(unpack(chaArgs))
        local blockArgs = { [1] = true }
        ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("block"):InvokeServer(unpack(blockArgs))

        local event = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("mel")
        local hakEvent = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("Hak")
        local remoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Skills")
        local volleyEvent = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("voleys")
        local pEvent = ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("p")
        
        for _, attack in pairs({attack1, attack2, attack3, attack5, attack7, attack8, attack9, attack10, attack11, attack12, attack13, attack14, attack15, attack16, attack17}) do
            coroutine.wrap(function()
                args[1] = attack
                event:InvokeServer(unpack(args))
                wait(0.005)
                event:InvokeServer(unpack(args))
            end)()
        end
        
        coroutine.wrap(function()
            local destructionArgs = { [1] = attack4, [2] = {["FaceMouse"] = true, ["MouseHit"] = CFrame.new()}, [3] = "Blacknwhite27" }
            hakEvent:InvokeServer(unpack(destructionArgs))
            wait(0.005)
            hakEvent:InvokeServer(unpack(destructionArgs))
        end)()
        
        coroutine.wrap(function()
            local spaceCutterArgs = { [1] = attack6, [2] = CFrame.new(), [3] = {["MouseHit"] = {["FaceMouse"] = false, ["MouseHit"] = CFrame.new()}} }
            remoteEvent:FireServer(unpack(spaceCutterArgs))
            wait(0.005)
            remoteEvent:FireServer(unpack(spaceCutterArgs))
        end)()
        
        coroutine.wrap(function()
            local volleyArgs = { [1] = attack18, [2] = {["FaceMouse"] = true, ["MouseHit"] = CFrame.new()}, [3] = "Blacknwhite27" }
            volleyEvent:InvokeServer(unpack(volleyArgs))
            wait(0.005)
            volleyEvent:InvokeServer(unpack(volleyArgs))
        end)()
        
        coroutine.wrap(function()
            local pArgs = { [1] = "Blacknwhite27", [2] = 1, [3] = false }
            pEvent:FireServer(unpack(pArgs))
            wait(0.005)
            pEvent:FireServer(unpack(pArgs))
        end)()
        
        if blockActive then
            local blockArgs = { [1] = true }
            ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("block"):InvokeServer(unpack(blockArgs))
        end
        
        wait(0.01)
    end
end

local function stopAbility()
    autoKillActive = false
end

Dropdown.MouseButton1Click:Connect(function()
    PlayerList.Visible = true
    updatePlayerList()
end)

StartAutoKillButton.MouseButton1Click:Connect(function()
    if selectedPlayer and isRestricted(selectedPlayer) then
        Logs.Text = "No puedes hacer esto con el creador"
        Logs.TextColor3 = Color3.fromRGB(139, 0, 0)
        Logs.Font = Enum.Font.SourceSansItalic
        return
    end
    Logs.Text = "AK: Activando habilidad..."
    spawn(function()
        activateAbility()
    end)
end)

StopAutoKillButton.MouseButton1Click:Connect(function()
    stopAbility()
    Logs.Text = "AK: Habilidad detenida"
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    MinimizedCircle.Visible = true
end)

MinimizedCircle.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MinimizedCircle.Visible = false
end)

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

updatePlayerList()

---------------------------------------------------------------------
-- NUEVA CONEXIÓN: Reaplicar bloqueo continuamente al reaparecer
LocalPlayer.CharacterAdded:Connect(function(character)
    spawn(function()
        while autoKillActive and character.Parent do
            local blockArgs = { [1] = true }
            ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("block"):InvokeServer(unpack(blockArgs))
            wait(0.1)
        end
    end)
end)

---------------------------------------------------------------------
-- NUEVA CONEXIÓN: Recargar KI (energía) continuamente
spawn(function()
    while true do
        local chaArgs = { [1] = "Blacknwhite27" }
        if transformed then
            ReplicatedStorage:WaitForChild("Package"):WaitForChild("Events"):WaitForChild("cha"):InvokeServer(unpack(chaArgs))
        end
        wait(0.05)
    end
end)
