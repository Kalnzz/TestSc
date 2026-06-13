--// Faltix Hub v3
--// Powered By Attala

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local Window = WindUI:CreateWindow({
    Title = "Faltix Hub",
    Icon = "rbxassetid://0",
    Author = "Powered By Attala",
    Folder = "FaltixHub_Config",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Crimson",
    SideBarWidth = 200,
})

local MainTab  = Window:Tab({ Title = "Main",  Icon = "house"    })
local SewerTab = Window:Tab({ Title = "Sewer", Icon = "zap"      })
local MiscTab  = Window:Tab({ Title = "Misc",  Icon = "settings" })

--// Services
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// State
local State = {
    Buy        = false,
    Upgrade    = false,
    Fruit      = false,
    Rebirth    = false,
    Evolve     = false,
    PowerLevel = false,
    CashDrop   = false,
    Delay      = 0.25,
}

--// Character
local function GetCharacter()
    local char = LocalPlayer.Character
    if not char then char = LocalPlayer.CharacterAdded:Wait() end
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hrp
end

--// Find Tycoon
local function FindTycoon()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:match("Tycoon") then
            local owner = v:FindFirstChild("Owner")
            if owner and owner.Value == LocalPlayer then return v end
        end
    end
end

local Tycoon = FindTycoon()
if not Tycoon then
    WindUI:Notify({ Title = "Error", Content = "Tycoon tidak ditemukan!", Duration = 5 })
    return
end

-- ============================================================
--  AUTO BUY
-- ============================================================
local Buttons = {}

local function RefreshButtons()
    table.clear(Buttons)
    local folder = Tycoon:FindFirstChild("Purchases")
    if not folder then return end
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("Model") and obj:GetAttribute("Shown") and not obj:GetAttribute("Purchased") then
            local part = obj:FindFirstChild("Button")
            if part and part:IsA("BasePart") then table.insert(Buttons, part) end
        end
    end
end

local function Touch(part)
    pcall(function()
        local _, hrp = GetCharacter()
        firetouchinterest(hrp, part, 0)
        task.wait(0.05)
        firetouchinterest(hrp, part, 1)
    end)
end

task.spawn(function()
    while true do
        if State.Buy then
            RefreshButtons()
            for _, button in ipairs(Buttons) do
                if button and button.Parent then Touch(button) end
            end
        end
        task.wait(State.Delay)
    end
end)

-- ============================================================
--  AUTO UPGRADE (cached remotes)
-- ============================================================
local upgradeRemotes  = {}
local upgradeLevel    = {}
local lastUpgradeScan = 0

local function refreshUpgradeRemotes()
    upgradeRemotes = {}
    upgradeLevel   = {}
    local purchases = Tycoon:FindFirstChild("Purchases")
    if not purchases then return end
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
            upgradeRemotes[#upgradeRemotes + 1] = obj
        end
    end
end

task.spawn(function()
    while true do
        if State.Upgrade then
            if tick() - lastUpgradeScan > 3 then
                refreshUpgradeRemotes()
                lastUpgradeScan = tick()
            end
            for _, remote in ipairs(upgradeRemotes) do
                if remote.Parent then
                    local lvl = (upgradeLevel[remote] or 0) + 1
                    while lvl <= 100 do
                        local ok, res = pcall(function() return remote:InvokeServer(lvl) end)
                        if (not ok) or res == false then break end
                        upgradeLevel[remote] = lvl
                        lvl = lvl + 1
                    end
                end
            end
        end
        task.wait(0.25)
    end
end)

-- ============================================================
--  AUTO POWER LEVEL
-- ============================================================
local function getPowerLevelRemote()
    local remotes = Tycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("UpgradePowerLevel")
end

task.spawn(function()
    while true do
        if State.PowerLevel then
            local remote = getPowerLevelRemote()
            if remote then pcall(function() remote:InvokeServer() end) end
        end
        task.wait(0.25)
    end
end)

-- ============================================================
--  AUTO REBIRTH (optimal)
-- ============================================================
local RebirthGainMultiple = 1.0
local MinPotential        = 1
local RebirthCooldown     = 2
local RebirthTimeout      = 8
local rebirthBusy         = false

local NUM_SCALE = {
    thousand=1e3,  million=1e6,    billion=1e9,     trillion=1e12,
    quadrillion=1e15, quintillion=1e18, sextillion=1e21, septillion=1e24,
    k=1e3, m=1e6, b=1e9, t=1e12, qd=1e15, qn=1e18, sx=1e21, sp=1e24,
}
local function parseNumber(s)
    if not s then return nil end
    s = tostring(s):gsub(",",""):lower()
    local val = tonumber(s:match("[%d%.]+"))
    if not val then return nil end
    local word = s:match("[%d%.%s]+([a-z]+)")
    if word and NUM_SCALE[word] then val = val * NUM_SCALE[word] end
    return val
end

local function investorBody()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local r  = pg and pg:FindFirstChild("Rebirth")
    local im = r  and r:FindFirstChild("InvestorsMenu")
    return im and im:FindFirstChild("Body")
end
local function readQuantity(name)
    local body  = investorBody()
    local frame = body and body:FindFirstChild(name)
    local q     = frame and frame:FindFirstChild("Quantity")
    return q and parseNumber(q.Text)
end
local function getCurrentInvestors()   return readQuantity("Amount")    or 0 end
local function getPotentialInvestors() return readQuantity("Potential")       end

local function getRebirthRemote()
    local r = Tycoon:FindFirstChild("Remotes")
    return r and r:FindFirstChild("Rebirth")
end
local function getRebirthedSignal()
    local r = Tycoon:FindFirstChild("Remotes")
    return r and r:FindFirstChild("Rebirthed")
end

task.spawn(function()
    while true do
        if State.Rebirth and not rebirthBusy then
            local remote    = getRebirthRemote()
            local potential = getPotentialInvestors()
            local current   = getCurrentInvestors()
            local worthIt   = remote and potential
                and potential >= MinPotential
                and potential >= current * RebirthGainMultiple
            if worthIt then
                rebirthBusy = true
                pcall(function()
                    local done = false
                    local signal = getRebirthedSignal()
                    local conn
                    if signal and signal:IsA("RemoteEvent") then
                        conn = signal.OnClientEvent:Connect(function() done = true end)
                    end
                    remote:InvokeServer()
                    local t = 0
                    while not done and t < RebirthTimeout do task.wait(0.1); t += 0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(RebirthCooldown)
                rebirthBusy = false
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================
--  AUTO EVOLVE (optimal)
-- ============================================================
local EvolveAt       = 100
local EvolveCooldown = 2
local EvolveTimeout  = 8
local evolveBusy     = false

local function getEvolveRemote()
    local r = Tycoon:FindFirstChild("Remotes")
    return r and r:FindFirstChild("Evolve")
end
local function getEvolvedSignal()
    local r = Tycoon:FindFirstChild("Remotes")
    return r and r:FindFirstChild("Evolved")
end
local function getEvolveProgress()
    local pg   = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local r    = pg and pg:FindFirstChild("Rebirth")
    local em   = r  and r:FindFirstChild("EvolutionMenu")
    local body = em and em:FindFirstChild("Body")
    local p    = body and body:FindFirstChild("Progress")
    if not p then return nil end
    return tonumber(tostring(p.Text):match("[%d%.]+"))
end

task.spawn(function()
    while true do
        if State.Evolve and not evolveBusy then
            local remote   = getEvolveRemote()
            local progress = getEvolveProgress()
            if remote and progress and progress >= EvolveAt then
                evolveBusy = true
                pcall(function()
                    local done = false
                    local signal = getEvolvedSignal()
                    local conn
                    if signal and signal:IsA("RemoteEvent") then
                        conn = signal.OnClientEvent:Connect(function() done = true end)
                    end
                    remote:InvokeServer()
                    local t = 0
                    while not done and t < EvolveTimeout do task.wait(0.1); t += 0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(EvolveCooldown)
                evolveBusy = false
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================
--  AUTO FRUIT (realtime tree listener)
-- ============================================================
local Trees = {}

local function addTree(obj)
    if obj:IsA("Model") and obj.Name == "LemonTree" then
        if not table.find(Trees, obj) then table.insert(Trees, obj) end
    end
end
local function removeTree(obj)
    local i = table.find(Trees, obj)
    if i then table.remove(Trees, i) end
end

for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function collectFruit(tree)
    for _, obj in ipairs(tree:GetDescendants()) do
        if obj:IsA("BasePart") then obj.CanCollide = false end
    end
    pcall(function()
        local _, hrp = GetCharacter()
        hrp.CFrame = tree:GetPivot() + Vector3.new(0, 5, 0)
        for _, obj in ipairs(tree:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Fruit" then
                obj.CanCollide = false
                local clickPart = obj:FindFirstChild("ClickPart")
                if clickPart then
                    local det = clickPart:FindFirstChildOfClass("ClickDetector")
                    if det then task.wait(0.45); pcall(function() fireclickdetector(det) end) end
                end
            end
        end
    end)
end

task.spawn(function()
    while true do
        if State.Fruit then
            for _, tree in ipairs(Trees) do
                if not State.Fruit then break end
                if tree and tree.Parent then pcall(function() collectFruit(tree) end) end
            end
        end
        task.wait(0.1)
    end
end)

-- ============================================================
--  AUTO CASHDROP
-- ============================================================
local function AutoCashDrop()
    local _, hrp = GetCharacter()
    if not hrp then return end
    local originalCF = hrp.CFrame
    local dropFolder = workspace:FindFirstChild("CashDrop")
    if not dropFolder then return end
    local drops = {}
    for _, v in ipairs(dropFolder:GetChildren()) do
        if v.Name == "CashDrop" then table.insert(drops, v) end
    end
    if #drops == 0 then return end
    for _, drop in ipairs(drops) do
        if drop and drop.Parent then
            pcall(function()
                local pos
                if drop:IsA("BasePart") then
                    pos = drop.CFrame
                elseif drop:IsA("Model") then
                    pos = drop.PrimaryPart and drop:GetPivot()
                        or (drop:FindFirstChildWhichIsA("BasePart") and
                            drop:FindFirstChildWhichIsA("BasePart").CFrame)
                end
                if pos then hrp.CFrame = pos + Vector3.new(0, 3, 0); task.wait(0.15) end
            end)
        end
    end
    task.wait(0.1)
    hrp.CFrame = originalCF
end

task.spawn(function()
    while true do
        if State.CashDrop then AutoCashDrop() end
        task.wait(State.Delay)
    end
end)

-- ============================================================
--  SEWER RUN
-- ============================================================
local function touchPart(hrp, part)
    pcall(function() firetouchinterest(hrp, part, 0); firetouchinterest(hrp, part, 1) end)
end

local function doSewerRun()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local sewer = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Sewer")
    if not sewer then return false end

    for _, o in ipairs(sewer:GetDescendants()) do
        if o:IsA("BasePart") and string.lower(o.Name):find("lever") then touchPart(hrp, o) end
    end

    for _, fn in ipairs({"CashVine","SewerAlien"}) do
        local f = sewer:FindFirstChild(fn)
        if f then
            for _, o in ipairs(f:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name=="VineKey" or o.Name=="UFOKey") then
                    touchPart(hrp, o)
                end
            end
        end
    end
    task.wait(0.3)

    local cv = sewer:FindFirstChild("CashVine")
    if cv then
        local vd = cv:FindFirstChild("VineDoor")
        if vd then for _, o in ipairs(vd:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp,o) end end end
        task.wait(0.3)
        local vm = cv:FindFirstChild("CashVine")
        if vm then
            pcall(function() hrp.CFrame = vm:GetPivot() + Vector3.new(0,3,0) end)
            task.wait(0.2)
            for _, o in ipairs(vm:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp,o) end end
        end
    end
    return true
end

local function teleportToAlien()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function() hrp.CFrame = CFrame.new(-42, -41, 180) end)
end

-- ============================================================
--  UI ― MAIN TAB
-- ============================================================
local AutoSection     = MainTab:Section({ Title = "Auto Features", Open = true })
local SettingsSection = MainTab:Section({ Title = "Settings",      Open = true })

AutoSection:Toggle({ Title = "Auto Buy",         Default = false, Callback = function(v) State.Buy        = v end })
AutoSection:Toggle({ Title = "Auto Upgrade",     Default = false, Callback = function(v) State.Upgrade    = v end })
AutoSection:Toggle({ Title = "Auto Fruit",       Default = false, Callback = function(v) State.Fruit      = v end })
AutoSection:Toggle({ Title = "Auto Rebirth",     Default = false, Callback = function(v) State.Rebirth    = v end })
AutoSection:Toggle({ Title = "Auto Evolve",      Default = false, Callback = function(v) State.Evolve     = v end })
AutoSection:Toggle({ Title = "Auto Power Level", Default = false, Callback = function(v) State.PowerLevel = v end })
AutoSection:Toggle({ Title = "Auto CashDrop",    Default = false, Callback = function(v) State.CashDrop   = v end })

SettingsSection:Slider({
    Title     = "Delay (Buy & CashDrop)",
    Min       = 0.05,
    Max       = 2,
    Default   = 0.25,
    Increment = 0.05,
    Callback  = function(v) State.Delay = v end,
})

-- ============================================================
--  UI ― SEWER TAB
-- ============================================================
local SewerSection = SewerTab:Section({ Title = "Sewer Actions", Open = true })

SewerSection:Button({
    Title = "Sewer Run",
    Callback = function()
        task.spawn(function()
            local ok = doSewerRun()
            WindUI:Notify({
                Title   = "Sewer Run",
                Content = ok and "Selesai!" or "Sewer tidak ditemukan!",
                Duration = 3,
            })
        end)
    end,
})

SewerSection:Button({
    Title = "Teleport to Sewer Alien",
    Callback = function()
        teleportToAlien()
        WindUI:Notify({ Title = "Teleport", Content = "Menuju Sewer Alien!", Duration = 3 })
    end,
})

-- ============================================================
--  UI ― MISC TAB
-- ============================================================
local ControlSection = MiscTab:Section({ Title = "Controls", Open = true })

ControlSection:Button({
    Title = "Emergency Stop",
    Callback = function()
        State.Buy = false; State.Upgrade = false; State.Fruit  = false
        State.Rebirth = false; State.Evolve = false
        State.PowerLevel = false; State.CashDrop = false
        WindUI:Notify({ Title = "Emergency Stop", Content = "Semua dimatikan!", Duration = 3 })
    end,
})

ControlSection:Button({
    Title = "Destroy GUI",
    Callback = function() WindUI:Destroy() end,
})

-- ============================================================
WindUI:Notify({ Title = "Faltix Hub", Content = "Powered By Attala | Ready!", Duration = 4 })
