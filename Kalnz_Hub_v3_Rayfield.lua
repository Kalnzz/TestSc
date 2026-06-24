--[[
    KALNZ HUB v3.0 - MM2 Edition
    Rayfield UI - 100% Lua

    Features:
    ESP Roles (Inventory Detection)
    ESP GunDrop
    Aimbot
    Insta Gun
    Teleport GunDrop (Manual)
    Fling Player (Murder, Sheriff, All, Custom)
    Fly, Noclip, Walkspeed, Inf Jump
    Godmode, Invisible
    Teleport Loop
--]]

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Character refs
local Character, Humanoid, HumanoidRootPart, Head
local function UpdateChar()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:FindFirstChild("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        Head = Character:FindFirstChild("Head")
    end
end
UpdateChar()

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(0.3)
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Head = newChar:WaitForChild("Head")
    if FlyEnabled then task.wait(0.5); StartFly() end
    if WalkspeedEnabled then task.wait(0.5); Humanoid.WalkSpeed = WalkspeedValue end
    if GodmodeEnabled then task.wait(0.5); EnableGodmode() end
    if InvisibleEnabled then task.wait(0.5); SetInvisible(true) end
end)

-- State variables
local ESPEnabled = false
local ESPNames = false
local ESPDistance = false
local ESPLines = false
local ESPGunDropEnabled = false
local ESPMurderColor = Color3.fromRGB(255, 0, 0)
local ESPSheriffColor = Color3.fromRGB(0, 100, 255)
local ESPInnocentColor = Color3.fromRGB(0, 255, 0)
local ESPGunDropColor = Color3.fromRGB(255, 215, 0)
local ESPMaxDistance = 2000
local ESPObjects = {}
local ESPGunDropObject = nil

local AimbotEnabled = false
local AimbotTarget = "Murder"
local AimbotFOV = 200
local AimbotSmoothness = 0.15
local AimbotKey = Enum.UserInputType.MouseButton2

local InstaGunEnabled = false
local GunDropConnection = nil

local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local WalkspeedEnabled = false
local WalkspeedValue = 100
local InfJumpEnabled = false
local NoclipEnabled = false
local NoclipConnection = nil

local InvisibleEnabled = false
local GodmodeEnabled = false
local TeleportLoopEnabled = false
local TeleportLoopSpeed = 0.1

local FlingEnabled = false
local FlingTarget = "Murder"
local FlingCustomUser = ""
local FlingPower = 5000
local FlingConnection = nil

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Kalnz Hub v3.0",
    LoadingTitle = "Kalnz Hub",
    LoadingSubtitle = "by Kalnz",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KalnzHub",
        FileName = "Config"
    },
    KeySystem = false,
})

-- Tabs
local TabESP = Window:CreateTab("ESP", 4483362458)
local TabAimbot = Window:CreateTab("Aimbot", 4483362458)
local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabFling = Window:CreateTab("Fling", 4483362458)
local TabMovement = Window:CreateTab("Movement", 4483362458)
local TabMisc = Window:CreateTab("Misc", 4483362458)
local TabInfo = Window:CreateTab("Info", 4483362458)

-- Helper Functions
local function GetPlayerRole(player)
    if not player or player == LocalPlayer then return nil end
    local char = player.Character
    if not char then return nil end
    local backpack = player:FindFirstChild("Backpack")
    local hasGun = false
    local hasKnife = false
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            local name = item.Name:lower()
            if name:find("gun") then hasGun = true end
            if name:find("knife") then hasKnife = true end
        end
    end
    if char then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("gun") then hasGun = true end
                if name:find("knife") then hasKnife = true end
            end
        end
    end
    if hasGun then return "Sheriff" end
    if hasKnife then return "Murder" end
    return "Innocent"
end

local function GetRoleColor(role)
    if role == "Murder" then return ESPMurderColor end
    if role == "Sheriff" then return ESPSheriffColor end
    return ESPInnocentColor
end

-- ESP Player Functions
local function CreateESP(player)
    if ESPObjects[player] then return end
    if player == LocalPlayer then return end
    local espData = {}
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KalnzESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = ESPMaxDistance
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 2
    frame.Parent = billboard
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.new(1, 1, 1)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = frame
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1.5
    line.Transparency = 1
    espData.Billboard = billboard
    espData.Frame = frame
    espData.NameLabel = nameLabel
    espData.DistLabel = distLabel
    espData.Line = line
    espData.Player = player
    ESPObjects[player] = espData
end

local function UpdateESP()
    for player, espData in pairs(ESPObjects) do
        if not player or not player.Parent then
            if espData.Billboard then espData.Billboard:Destroy() end
            if espData.Line then espData.Line:Remove() end
            ESPObjects[player] = nil
            continue
        end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local myHrp = HumanoidRootPart
        if not char or not hrp or not myHrp then
            espData.Billboard.Enabled = false
            espData.Line.Visible = false
            continue
        end
        local role = GetPlayerRole(player)
        local color = GetRoleColor(role)
        local distance = math.floor((myHrp.Position - hrp.Position).Magnitude)
        espData.Billboard.Adornee = head or hrp
        espData.Billboard.Enabled = ESPEnabled
        espData.Frame.BorderColor3 = color
        espData.Frame.BackgroundColor3 = color
        espData.NameLabel.Text = ESPNames and (player.Name .. " [" .. role .. "]") or ""
        espData.NameLabel.Visible = ESPNames
        espData.DistLabel.Text = ESPDistance and (tostring(distance) .. " studs") or ""
        espData.DistLabel.Visible = ESPDistance
        if ESPLines then
            local headPos, onScreen = Camera:WorldToViewportPoint((head or hrp).Position)
            local myHeadPos = Camera:WorldToViewportPoint(myHrp.Position)
            if onScreen then
                espData.Line.Visible = true
                espData.Line.From = Vector2.new(myHeadPos.X, myHeadPos.Y)
                espData.Line.To = Vector2.new(headPos.X, headPos.Y)
                espData.Line.Color = color
            else
                espData.Line.Visible = false
            end
        else
            espData.Line.Visible = false
        end
    end
end

-- ESP GunDrop Functions
local function CreateESPGunDrop()
    if ESPGunDropObject then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KalnzGunDropESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = ESPGunDropColor
    frame.BorderSizePixel = 2
    frame.BorderColor3 = ESPGunDropColor
    frame.Parent = billboard
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = "GUN DROP"
    label.Parent = frame
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 2
    line.Transparency = 1
    line.Color = ESPGunDropColor
    ESPGunDropObject = {
        Billboard = billboard,
        Label = label,
        Line = line
    }
end

local function UpdateESPGunDrop()
    if not ESPGunDropEnabled or not ESPGunDropObject then return end
    local gunDrop = Workspace:FindFirstChild("GunDrop")
    local myHrp = HumanoidRootPart
    if not gunDrop or not myHrp then
        ESPGunDropObject.Billboard.Enabled = false
        ESPGunDropObject.Line.Visible = false
        return
    end
    ESPGunDropObject.Billboard.Adornee = gunDrop
    ESPGunDropObject.Billboard.Enabled = true
    local distance = math.floor((myHrp.Position - gunDrop.Position).Magnitude)
    ESPGunDropObject.Label.Text = "GUN DROP [" .. tostring(distance) .. " studs]"
    if ESPLines then
        local pos, onScreen = Camera:WorldToViewportPoint(gunDrop.Position)
        local myPos = Camera:WorldToViewportPoint(myHrp.Position)
        if onScreen then
            ESPGunDropObject.Line.Visible = true
            ESPGunDropObject.Line.From = Vector2.new(myPos.X, myPos.Y)
            ESPGunDropObject.Line.To = Vector2.new(pos.X, pos.Y)
        else
            ESPGunDropObject.Line.Visible = false
        end
    else
        ESPGunDropObject.Line.Visible = false
    end
end

-- Init ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreateESP(player) end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then CreateESP(player) end
end)
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Billboard:Destroy()
        ESPObjects[player].Line:Remove()
        ESPObjects[player] = nil
    end
end)
CreateESPGunDrop()

RunService.RenderStepped:Connect(function()
    if ESPEnabled then UpdateESP() end
    if ESPGunDropEnabled then UpdateESPGunDrop() end
end)

-- Aimbot
local function GetAimbotTarget()
    local closest = nil
    local closestDist = AimbotFOV
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local role = GetPlayerRole(player)
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then continue end
        if AimbotTarget == "Murder" and role ~= "Murder" then continue end
        if AimbotTarget == "Sheriff" and role ~= "Sheriff" then continue end
        if AimbotTarget == "Both" and role ~= "Murder" and role ~= "Sheriff" then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = head
        end
    end
    return closest
end

local function AimAt(target)
    if not target then return end
    local targetPos = Camera:WorldToViewportPoint(target.Position)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local moveVec = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * AimbotSmoothness
    mousemoverel(moveVec.X, moveVec.Y)
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(AimbotKey) then
        local target = GetAimbotTarget()
        if target then AimAt(target) end
    end
end)

-- Insta Gun
local function CheckGunDrop()
    if not InstaGunEnabled then return end
    local gunDrop = Workspace:FindFirstChild("GunDrop")
    if gunDrop and gunDrop:IsA("BasePart") and HumanoidRootPart then
        HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.3)
        Rayfield:Notify({
            Title = "Insta Gun",
            Content = "GunDrop ditemukan dan diambil!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Fly
local function StartFly()
    if not Character or not HumanoidRootPart then return end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = HumanoidRootPart.CFrame
    FlyBodyGyro.Parent = HumanoidRootPart
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.zero
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Parent = HumanoidRootPart
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyEnabled then return end
        if not FlyBodyVelocity or not FlyBodyGyro then return end
        local camCF = Camera.CFrame
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * FlySpeed end
        FlyBodyVelocity.Velocity = moveDir
        FlyBodyGyro.CFrame = camCF
    end)
end

local function StopFly()
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
end

-- Noclip
local function StartNoclip()
    if NoclipConnection then return end
    NoclipConnection = RunService.Stepped:Connect(function()
        if not NoclipEnabled or not Character then return end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function StopNoclip()
    if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- Godmode
local GodmodeConnection = nil
local function EnableGodmode()
    if not Humanoid then return end
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    if GodmodeConnection then GodmodeConnection:Disconnect() end
    GodmodeConnection = Humanoid.HealthChanged:Connect(function()
        if GodmodeEnabled then Humanoid.Health = math.huge end
    end)
end

local function DisableGodmode()
    if GodmodeConnection then GodmodeConnection:Disconnect(); GodmodeConnection = nil end
    if Humanoid then Humanoid.MaxHealth = 100; Humanoid.Health = 100 end
end

-- Invisible
local function SetInvisible(state)
    if not Character then return end
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
        end
        if part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = state and 1 or 0
        end
    end
end

-- Teleport Loop
local TeleportLoopCoroutine = nil
local function StartTeleportLoop()
    if TeleportLoopCoroutine then return end
    TeleportLoopCoroutine = task.spawn(function()
        while TeleportLoopEnabled do
            for _, player in pairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                if not TeleportLoopEnabled then break end
                local targetChar = player.Character
                local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                if targetHRP and HumanoidRootPart then
                    HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                    task.wait(TeleportLoopSpeed)
                end
            end
            task.wait(0.05)
        end
    end)
end

local function StopTeleportLoop()
    TeleportLoopEnabled = false
    TeleportLoopCoroutine = nil
end

-- Fling Functions
local function GetFlingTargetPlayer()
    if FlingTarget == "All" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then return player end
        end
    elseif FlingTarget == "Murder" then
        for _, player in pairs(Players:GetPlayers()) do
            if GetPlayerRole(player) == "Murder" then return player end
        end
    elseif FlingTarget == "Sheriff" then
        for _, player in pairs(Players:GetPlayers()) do
            if GetPlayerRole(player) == "Sheriff" then return player end
        end
    elseif FlingTarget == "Custom" then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower() == FlingCustomUser:lower() then return player end
        end
    end
    return nil
end

local function StartFling()
    if FlingConnection then FlingConnection:Disconnect(); FlingConnection = nil end
    if not HumanoidRootPart then return end

    local targetPlayer = GetFlingTargetPlayer()
    if not targetPlayer then
        Rayfield:Notify({
            Title = "Fling",
            Content = "Target tidak ditemukan!",
            Duration = 3,
            Image = 4483362458,
        })
        return
    end

    local targetChar = targetPlayer.Character
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        Rayfield:Notify({
            Title = "Fling",
            Content = "Target tidak punya HRP!",
            Duration = 3,
            Image = 4483362458,
        })
        return
    end

    -- Create fling part
    local flingPart = Instance.new("BodyAngularVelocity")
    flingPart.Name = "FlingVelocity"
    flingPart.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flingPart.AngularVelocity = Vector3.new(FlingPower, FlingPower, FlingPower)
    flingPart.Parent = HumanoidRootPart

    FlingConnection = RunService.Heartbeat:Connect(function()
        if not FlingEnabled then return end
        if not targetHRP or not targetHRP.Parent then
            if flingPart then flingPart:Destroy() end
            return
        end
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = targetHRP.CFrame
        end
    end)

    Rayfield:Notify({
        Title = "Fling",
        Content = "Flinging " .. targetPlayer.Name .. "!",
        Duration = 3,
        Image = 4483362458,
    })
end

local function StopFling()
    FlingEnabled = false
    if FlingConnection then FlingConnection:Disconnect(); FlingConnection = nil end
    if HumanoidRootPart then
        local flingPart = HumanoidRootPart:FindFirstChild("FlingVelocity")
        if flingPart then flingPart:Destroy() end
    end
    if Humanoid then Humanoid.Sit = false end
end

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====================
-- TAB: ESP
-- ====================
TabESP:CreateSection("Player ESP")

TabESP:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(state)
        ESPEnabled = state
    end,
})

TabESP:CreateToggle({
    Name = "Show Names",
    CurrentValue = false,
    Flag = "ESPNamesToggle",
    Callback = function(state)
        ESPNames = state
    end,
})

TabESP:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "ESPDistToggle",
    Callback = function(state)
        ESPDistance = state
    end,
})

TabESP:CreateToggle({
    Name = "Show Lines",
    CurrentValue = false,
    Flag = "ESPLinesToggle",
    Callback = function(state)
        ESPLines = state
    end,
})

TabESP:CreateSlider({
    Name = "ESP Max Distance",
    Range = {10, 5000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 2000,
    Flag = "ESPMaxDist",
    Callback = function(value)
        ESPMaxDistance = value
    end,
})

TabESP:CreateSection("GunDrop ESP")

TabESP:CreateToggle({
    Name = "ESP GunDrop",
    CurrentValue = false,
    Flag = "ESPGunDropToggle",
    Callback = function(state)
        ESPGunDropEnabled = state
    end,
})

-- ====================
-- TAB: AIMBOT
-- ====================
TabAimbot:CreateSection("Aimbot Settings")

TabAimbot:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(state)
        AimbotEnabled = state
    end,
})

TabAimbot:CreateDropdown({
    Name = "Aimbot Target",
    Options = {"Murder", "Sheriff", "Both"},
    CurrentOption = "Murder",
    Flag = "AimbotTarget",
    Callback = function(option)
        AimbotTarget = option
    end,
})

TabAimbot:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 800},
    Increment = 10,
    Suffix = " px",
    CurrentValue = 200,
    Flag = "AimbotFOV",
    Callback = function(value)
        AimbotFOV = value
    end,
})

TabAimbot:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = 0.15,
    Flag = "AimbotSmooth",
    Callback = function(value)
        AimbotSmoothness = value
    end,
})

-- ====================
-- TAB: COMBAT
-- ====================
TabCombat:CreateSection("Insta Gun")

TabCombat:CreateToggle({
    Name = "Enable Insta Gun (Auto)",
    CurrentValue = false,
    Flag = "InstaGunToggle",
    Callback = function(state)
        InstaGunEnabled = state
        if state then
            GunDropConnection = RunService.Heartbeat:Connect(CheckGunDrop)
        else
            if GunDropConnection then GunDropConnection:Disconnect(); GunDropConnection = nil end
        end
    end,
})

TabCombat:CreateButton({
    Name = "Teleport to GunDrop (Manual)",
    Callback = function()
        local gunDrop = Workspace:FindFirstChild("GunDrop")
        if gunDrop and HumanoidRootPart then
            HumanoidRootPart.CFrame = gunDrop.CFrame + Vector3.new(0, 3, 0)
            Rayfield:Notify({
                Title = "GunDrop",
                Content = "Teleported to GunDrop!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "GunDrop",
                Content = "GunDrop tidak ditemukan!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

TabCombat:CreateSection("Teleport Loop")

TabCombat:CreateToggle({
    Name = "Enable Teleport Loop",
    CurrentValue = false,
    Flag = "TeleportLoopToggle",
    Callback = function(state)
        TeleportLoopEnabled = state
        if state then StartTeleportLoop() else StopTeleportLoop() end
    end,
})

TabCombat:CreateSlider({
    Name = "Teleport Speed",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = 0.1,
    Flag = "TeleportSpeed",
    Callback = function(value)
        TeleportLoopSpeed = value
    end,
})

-- ====================
-- TAB: FLING
-- ====================
TabFling:CreateSection("Fling Player")

TabFling:CreateToggle({
    Name = "Enable Fling",
    CurrentValue = false,
    Flag = "FlingToggle",
    Callback = function(state)
        FlingEnabled = state
        if state then StartFling() else StopFling() end
    end,
})

TabFling:CreateDropdown({
    Name = "Fling Target",
    Options = {"Murder", "Sheriff", "All", "Custom"},
    CurrentOption = "Murder",
    Flag = "FlingTarget",
    Callback = function(option)
        FlingTarget = option
    end,
})

TabFling:CreateInput({
    Name = "Custom Username",
    PlaceholderText = "Enter username...",
    RemoveTextAfterFocusLost = false,
    Flag = "FlingCustomUser",
    Callback = function(text)
        FlingCustomUser = text
    end,
})

TabFling:CreateSlider({
    Name = "Fling Power",
    Range = {1000, 20000},
    Increment = 500,
    Suffix = "",
    CurrentValue = 5000,
    Flag = "FlingPower",
    Callback = function(value)
        FlingPower = value
    end,
})

-- ====================
-- TAB: MOVEMENT
-- ====================
TabMovement:CreateSection("Walkspeed")

TabMovement:CreateToggle({
    Name = "Enable Walkspeed",
    CurrentValue = false,
    Flag = "WalkspeedToggle",
    Callback = function(state)
        WalkspeedEnabled = state
        if Humanoid then Humanoid.WalkSpeed = state and WalkspeedValue or 16 end
    end,
})

TabMovement:CreateSlider({
    Name = "Walkspeed Value",
    Range = {16, 500},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 100,
    Flag = "WalkspeedValue",
    Callback = function(value)
        WalkspeedValue = value
        if WalkspeedEnabled and Humanoid then Humanoid.WalkSpeed = value end
    end,
})

TabMovement:CreateSection("Infinite Jump")

TabMovement:CreateToggle({
    Name = "Enable Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(state)
        InfJumpEnabled = state
    end,
})

TabMovement:CreateSection("Noclip (Advanced)")

TabMovement:CreateToggle({
    Name = "Enable Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(state)
        NoclipEnabled = state
        if state then StartNoclip() else StopNoclip() end
    end,
})

TabMovement:CreateSection("Fly (Advanced)")

TabMovement:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(state)
        FlyEnabled = state
        if state then
            StartFly()
            Rayfield:Notify({
                Title = "Fly",
                Content = "Fly aktif! W/A/S/D + Space/Shift",
                Duration = 3,
                Image = 4483362458,
            })
        else
            StopFly()
        end
    end,
})

TabMovement:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = " speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        FlySpeed = value
    end,
})

-- ====================
-- TAB: MISC
-- ====================
TabMisc:CreateSection("Godmode")

TabMisc:CreateToggle({
    Name = "Enable Godmode",
    CurrentValue = false,
    Flag = "GodmodeToggle",
    Callback = function(state)
        GodmodeEnabled = state
        if state then EnableGodmode() else DisableGodmode() end
    end,
})

TabMisc:CreateSection("Invisible")

TabMisc:CreateToggle({
    Name = "Enable Invisible",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(state)
        InvisibleEnabled = state
        SetInvisible(state)
    end,
})

TabMisc:CreateSection("Utility")

TabMisc:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if Character then Character:BreakJoints() end
    end,
})

TabMisc:CreateButton({
    Name = "Teleport to Random Player",
    Callback = function()
        local players = Players:GetPlayers()
        if #players > 1 then
            local target = players[math.random(1, #players)]
            if target ~= LocalPlayer and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp and HumanoidRootPart then
                    HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end,
})

-- ====================
-- TAB: INFO
-- ====================
TabInfo:CreateSection("Kalnz Hub v3.0")

TabInfo:CreateParagraph({
    Title = "Fitur Utama",
    Content = [[
ESP Roles (Deteksi Inventory):
- Merah = Murder (ada Knife)
- Biru = Sheriff (ada Gun)
- Hijau = Innocent (kosong)

ESP GunDrop (Kuning)
Aimbot ke Sheriff/Murder/Both
Insta Gun (Auto-detect GunDrop)
Teleport GunDrop (Manual)
Fling Player (Murder, Sheriff, All, Custom)
Fly Advanced (BodyVelocity + BodyGyro)
Noclip Advanced (RunService.Stepped)
Walkspeed & Inf Jump
Godmode & Invisible
Teleport Loop ke semua player

Cara Pakai:
- Fly: W/A/S/D + Space/Shift
- Aimbot: Hold Right Click
- ESP: Auto-detect semua player
- Fling: Pilih target, toggle on
    ]]
})

TabInfo:CreateParagraph({
    Title = "Disclaimer",
    Content = "Gunakan dengan bijak. Developer tidak bertanggung jawab atas banned akun. Script ini untuk educational purpose only."
})

-- Initial notification
Rayfield:Notify({
    Title = "Kalnz Hub v3.0 Loaded!",
    Content = "ESP | Aimbot | Fly | Noclip | Godmode | Fling | Insta Gun",
    Duration = 5,
    Image = 4483362458,
})

print("[Kalnz Hub v3.0] Script loaded successfully!")
