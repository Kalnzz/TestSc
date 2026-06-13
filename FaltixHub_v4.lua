-- Faltix Hub | Custom UI | v4
-- Powered By Attala

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FaltixHub") then
    PlayerGui:FindFirstChild("FaltixHub"):Destroy()
end

-- HELPERS
local function Tween(obj, t, props)
    TweenService:Create(obj, t, props):Play()
end
local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

-- THEME (CRIMSON)
local C = {
    BG         = Color3.fromRGB(11, 11, 17),
    Sidebar    = Color3.fromRGB(16, 16, 24),
    TopBar     = Color3.fromRGB(14, 14, 21),
    Accent     = Color3.fromRGB(188, 28, 52),
    TabIn      = Color3.fromRGB(26, 26, 38),
    Text       = Color3.fromRGB(238, 238, 248),
    TextDim    = Color3.fromRGB(148, 148, 168),
    Elem       = Color3.fromRGB(20, 20, 30),
    ElemHov    = Color3.fromRGB(30, 30, 44),
    TogOff     = Color3.fromRGB(44, 44, 60),
    Sep        = Color3.fromRGB(32, 32, 48),
    White      = Color3.new(1,1,1),
    CloseRed   = Color3.fromRGB(200, 38, 55),
    MinGray    = Color3.fromRGB(36, 36, 52),
}

-- SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "FaltixHub"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent         = PlayerGui

local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint         = Vector2.new(0.5, 0.5)
Shadow.Size                = UDim2.fromOffset(0, 0)
Shadow.Position            = UDim2.new(0.5, 0, 0.5, 8)
Shadow.BackgroundTransparency = 1
Shadow.ZIndex              = 0
Shadow.Image               = "rbxassetid://6014261993"
Shadow.ImageColor3         = Color3.new(0,0,0)
Shadow.ImageTransparency   = 0.5
Shadow.ScaleType           = Enum.ScaleType.Slice
Shadow.SliceCenter         = Rect.new(49,49,450,450)
Shadow.Parent              = ScreenGui

local Window = Instance.new("Frame")
Window.Name            = "Window"
Window.AnchorPoint     = Vector2.new(0.5, 0.5)
Window.Size            = UDim2.fromOffset(0, 0)
Window.Position        = UDim2.new(0.5, 0, 0.5, 0)
Window.BackgroundColor3 = C.BG
Window.BorderSizePixel = 0
Window.Parent          = ScreenGui
Corner(Window, 12)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size             = UDim2.new(1, 0, 0, 46)
TopBar.BackgroundColor3 = C.TopBar
TopBar.BorderSizePixel  = 0
TopBar.ZIndex           = 5
TopBar.Parent           = Window
Corner(TopBar, 12)

local TBFix = Instance.new("Frame")
TBFix.Size             = UDim2.new(1, 0, 0, 12)
TBFix.Position         = UDim2.new(0, 0, 1, -12)
TBFix.BackgroundColor3 = C.TopBar
TBFix.BorderSizePixel  = 0
TBFix.ZIndex           = 5
TBFix.Parent           = TopBar

local TBGrad = Instance.new("UIGradient")
TBGrad.Color    = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22,22,33)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(11,11,17)),
})
TBGrad.Rotation = 90
TBGrad.Parent   = TopBar

local Logo = Instance.new("ImageLabel")
Logo.Size                 = UDim2.fromOffset(28, 28)
Logo.Position             = UDim2.new(0, 11, 0.5, -14)
Logo.BackgroundTransparency = 1
Logo.Image                = "rbxassetid://110127950553563"
Logo.ZIndex               = 6
Logo.Parent               = TopBar

local LogoDiv = Instance.new("Frame")
LogoDiv.Size             = UDim2.fromOffset(2, 22)
LogoDiv.Position         = UDim2.new(0, 44, 0.5, -11)
LogoDiv.BackgroundColor3 = C.Accent
LogoDiv.BorderSizePixel  = 0
LogoDiv.ZIndex           = 6
LogoDiv.Parent           = TopBar
Corner(LogoDiv, 1)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size                = UDim2.new(0, 120, 0, 18)
TitleLbl.Position            = UDim2.new(0, 52, 0, 9)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text                = "Faltix Hub"
TitleLbl.TextColor3          = C.Text
TitleLbl.TextSize             = 15
TitleLbl.Font                = Enum.Font.GothamBold
TitleLbl.TextXAlignment      = Enum.TextXAlignment.Left
TitleLbl.ZIndex              = 6
TitleLbl.Parent              = TopBar

local SubLbl = Instance.new("TextLabel")
SubLbl.Size                = UDim2.new(0, 140, 0, 13)
SubLbl.Position            = UDim2.new(0, 52, 0, 27)
SubLbl.BackgroundTransparency = 1
SubLbl.Text                = "Powered By Attala"
SubLbl.TextColor3          = C.TextDim
SubLbl.TextSize             = 10
SubLbl.Font                = Enum.Font.Gotham
SubLbl.TextXAlignment      = Enum.TextXAlignment.Left
SubLbl.ZIndex              = 6
SubLbl.Parent              = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.fromOffset(26, 26)
CloseBtn.Position         = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = C.CloseRed
CloseBtn.Text             = "×"
CloseBtn.TextColor3       = C.White
CloseBtn.TextSize          = 17
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.AutoButtonColor  = false
CloseBtn.ZIndex           = 6
CloseBtn.Parent           = TopBar
Corner(CloseBtn, 7)

local MinBtn = Instance.new("TextButton")
MinBtn.Size             = UDim2.fromOffset(26, 26)
MinBtn.Position         = UDim2.new(1, -68, 0.5, -13)
MinBtn.BackgroundColor3 = C.MinGray
MinBtn.Text             = "–"
MinBtn.TextColor3       = C.TextDim
MinBtn.TextSize          = 16
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.BorderSizePixel  = 0
MinBtn.AutoButtonColor  = false
MinBtn.ZIndex           = 6
MinBtn.Parent           = TopBar
Corner(MinBtn, 7)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name             = "Sidebar"
Sidebar.Size             = UDim2.new(0, 148, 1, -46)
Sidebar.Position         = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = C.Sidebar
Sidebar.BorderSizePixel  = 0
Sidebar.Parent           = Window
Corner(Sidebar, 12)

local SBTopFix = Instance.new("Frame")
SBTopFix.Size             = UDim2.new(1, 0, 0, 12)
SBTopFix.BackgroundColor3 = C.Sidebar
SBTopFix.BorderSizePixel  = 0
SBTopFix.ZIndex           = 2
SBTopFix.Parent           = Sidebar

local SBRightFix = Instance.new("Frame")
SBRightFix.Size             = UDim2.new(0, 12, 1, 0)
SBRightFix.Position         = UDim2.new(1, -12, 0, 0)
SBRightFix.BackgroundColor3 = C.Sidebar
SBRightFix.BorderSizePixel  = 0
SBRightFix.ZIndex           = 2
SBRightFix.Parent           = Sidebar

local TabList = Instance.new("ScrollingFrame")
TabList.Size               = UDim2.new(1, -8, 1, -16)
TabList.Position           = UDim2.new(0, 4, 0, 12)
TabList.BackgroundTransparency = 1
TabList.ScrollBarThickness = 0
TabList.BorderSizePixel    = 0
TabList.CanvasSize         = UDim2.new(0,0,0,0)
TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabList.Parent             = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding       = UDim.new(0, 4)
TabListLayout.SortOrder     = Enum.SortOrder.LayoutOrder
TabListLayout.Parent        = TabList

-- SEPARATOR + CONTENT
local SepLine = Instance.new("Frame")
SepLine.Size             = UDim2.new(0, 1, 1, -46)
SepLine.Position         = UDim2.new(0, 148, 0, 46)
SepLine.BackgroundColor3 = C.Sep
SepLine.BorderSizePixel  = 0
SepLine.Parent           = Window

local ContentArea = Instance.new("Frame")
ContentArea.Size               = UDim2.new(1, -150, 1, -48)
ContentArea.Position           = UDim2.new(0, 150, 0, 48)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants   = true
ContentArea.Parent             = Window

-- DRAGGING
local isDragging       = false
local isDraggingSlider = false
local dragStart, dragStartPos
local baseWindowPos = UDim2.new(0.5, 0, 0.5, 0)

TopBar.InputBegan:Connect(function(input)
    if isDraggingSlider then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging    = true
        dragStart     = input.Position
        dragStartPos  = baseWindowPos
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        baseWindowPos = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
    end
end)

-- FLOATING EFFECT
local floatT = 0
RunService.Heartbeat:Connect(function(dt)
    floatT = floatT + dt
    local floatY = isDragging and 0 or (math.sin(floatT * 0.7) * 2.5)
    Window.Position = UDim2.new(
        baseWindowPos.X.Scale, baseWindowPos.X.Offset,
        baseWindowPos.Y.Scale, baseWindowPos.Y.Offset + floatY
    )
    Shadow.Position = UDim2.new(
        Window.Position.X.Scale, Window.Position.X.Offset,
        Window.Position.Y.Scale, Window.Position.Y.Offset + 8
    )
end)

-- NOTIFICATIONS
local NotifHolder = Instance.new("Frame")
NotifHolder.Size               = UDim2.new(0, 270, 1, 0)
NotifHolder.Position           = UDim2.new(1, -280, 0, 0)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent             = ScreenGui

local NLayout = Instance.new("UIListLayout")
NLayout.Padding           = UDim.new(0, 8)
NLayout.VerticalAlignment  = Enum.VerticalAlignment.Bottom
NLayout.FillDirection      = Enum.FillDirection.Vertical
NLayout.SortOrder          = Enum.SortOrder.LayoutOrder
NLayout.Parent             = NotifHolder

local NPad = Instance.new("UIPadding")
NPad.PaddingBottom = UDim.new(0, 16)
NPad.PaddingRight  = UDim.new(0, 8)
NPad.Parent        = NotifHolder

local function Notify(title, body, dur)
    dur = dur or 3
    local nf = Instance.new("Frame")
    nf.Size             = UDim2.new(1, 0, 0, 62)
    nf.BackgroundColor3 = C.Sidebar
    nf.BorderSizePixel  = 0
    nf.BackgroundTransparency = 1
    nf.Parent           = NotifHolder
    Corner(nf, 9)

    local nAccent = Instance.new("Frame")
    nAccent.Size             = UDim2.fromOffset(3, 36)
    nAccent.Position         = UDim2.new(0, 0, 0.5, -18)
    nAccent.BackgroundColor3 = C.Accent
    nAccent.BorderSizePixel  = 0
    nAccent.BackgroundTransparency = 1
    Corner(nAccent, 2)
    nAccent.Parent = nf

    local nTitle = Instance.new("TextLabel")
    nTitle.Size               = UDim2.new(1, -20, 0, 20)
    nTitle.Position           = UDim2.new(0, 12, 0, 10)
    nTitle.BackgroundTransparency = 1
    nTitle.Text               = title
    nTitle.TextColor3         = C.Text
    nTitle.TextSize            = 13
    nTitle.Font               = Enum.Font.GothamBold
    nTitle.TextXAlignment     = Enum.TextXAlignment.Left
    nTitle.TextTransparency   = 1
    nTitle.Parent             = nf

    local nBody = Instance.new("TextLabel")
    nBody.Size               = UDim2.new(1, -20, 0, 16)
    nBody.Position           = UDim2.new(0, 12, 0, 33)
    nBody.BackgroundTransparency = 1
    nBody.Text               = body
    nBody.TextColor3         = C.TextDim
    nBody.TextSize            = 11
    nBody.Font               = Enum.Font.Gotham
    nBody.TextXAlignment     = Enum.TextXAlignment.Left
    nBody.TextTransparency   = 1
    nBody.Parent             = nf

    local tiIn  = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tiOut = TweenInfo.new(0.25, Enum.EasingStyle.Quart)

    Tween(nf,     tiIn, {BackgroundTransparency = 0})
    Tween(nAccent,tiIn, {BackgroundTransparency = 0})
    Tween(nTitle, tiIn, {TextTransparency = 0})
    Tween(nBody,  tiIn, {TextTransparency = 0})

    task.delay(dur, function()
        Tween(nf,     tiOut, {BackgroundTransparency = 1})
        Tween(nAccent,tiOut, {BackgroundTransparency = 1})
        Tween(nTitle, tiOut, {TextTransparency = 1})
        Tween(nBody,  tiOut, {TextTransparency = 1})
        task.wait(0.3)
        nf:Destroy()
    end)
end

-- TAB SYSTEM
local ActiveTab = nil
local tabOrder  = 0

local function ActivateTab(tab)
    if ActiveTab then
        Tween(ActiveTab.Btn,      TweenInfo.new(0.2), {BackgroundColor3 = C.TabIn})
        Tween(ActiveTab.TLbl,     TweenInfo.new(0.2), {TextColor3 = C.TextDim})
        Tween(ActiveTab.Indicator,TweenInfo.new(0.2), {BackgroundTransparency = 1})
        ActiveTab.Page.Visible = false
    end
    Tween(tab.Btn,      TweenInfo.new(0.2), {BackgroundColor3 = C.Accent})
    Tween(tab.TLbl,     TweenInfo.new(0.2), {TextColor3 = C.White})
    Tween(tab.Indicator,TweenInfo.new(0.2), {BackgroundTransparency = 0})
    tab.Page.Visible = true
    ActiveTab = tab
end

local function CreateTab(name)
    tabOrder = tabOrder + 1
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = C.TabIn
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.AutoButtonColor  = false
    btn.LayoutOrder      = tabOrder
    btn.Parent           = TabList
    Corner(btn, 8)

    local indicator = Instance.new("Frame")
    indicator.Size             = UDim2.fromOffset(3, 20)
    indicator.Position         = UDim2.new(0, 0, 0.5, -10)
    indicator.BackgroundColor3 = C.White
    indicator.BorderSizePixel  = 0
    indicator.BackgroundTransparency = 1
    Corner(indicator, 2)
    indicator.Parent = btn

    local tLbl = Instance.new("TextLabel")
    tLbl.Size               = UDim2.new(1, -18, 1, 0)
    tLbl.Position           = UDim2.new(0, 14, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text               = name
    tLbl.TextColor3         = C.TextDim
    tLbl.TextSize            = 13
    tLbl.Font               = Enum.Font.Gotham
    tLbl.TextXAlignment     = Enum.TextXAlignment.Left
    tLbl.Parent             = btn

    local page = Instance.new("ScrollingFrame")
    page.Size               = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel    = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Accent
    page.CanvasSize         = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible            = false
    page.Parent             = ContentArea

    local pLayout = Instance.new("UIListLayout")
    pLayout.Padding     = UDim.new(0, 5)
    pLayout.SortOrder   = Enum.SortOrder.LayoutOrder
    pLayout.Parent      = page

    local pPad = Instance.new("UIPadding")
    pPad.PaddingLeft   = UDim.new(0, 10)
    pPad.PaddingRight  = UDim.new(0, 10)
    pPad.PaddingTop    = UDim.new(0, 8)
    pPad.PaddingBottom = UDim.new(0, 10)
    pPad.Parent        = page

    local tab = {Btn=btn, TLbl=tLbl, Indicator=indicator, Page=page}
    btn.MouseButton1Click:Connect(function() ActivateTab(tab) end)
    btn.MouseEnter:Connect(function()
        if ActiveTab ~= tab then Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(33,33,48)}) end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= tab then Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.TabIn}) end
    end)
    return tab
end

-- ELEMENT BUILDERS
local elemOrder = 0
local function nO() elemOrder = elemOrder + 1; return elemOrder end

local function Section(page, title)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 26); f.BackgroundTransparency = 1
    f.LayoutOrder = nO(); f.Parent = page
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. string.upper(title)
    lbl.TextColor3 = C.Accent; lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = C.Sep; line.BorderSizePixel = 0; line.Parent = f
end

local function Toggle(page, title, default, callback)
    local val = default or false
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38); f.BackgroundColor3 = C.Elem
    f.BorderSizePixel = 0; f.LayoutOrder = nO(); f.Parent = page
    Corner(f, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -58, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = title
    lbl.TextColor3 = C.Text; lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    local togBG = Instance.new("Frame")
    togBG.Size = UDim2.fromOffset(38, 20); togBG.Position = UDim2.new(1, -50, 0.5, -10)
    togBG.BackgroundColor3 = val and C.Accent or C.TogOff
    togBG.BorderSizePixel = 0; togBG.Parent = f; Corner(togBG, 10)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = val and UDim2.new(0, 20, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = C.White; knob.BorderSizePixel = 0
    knob.Parent = togBG; Corner(knob, 8)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = f
    btn.MouseButton1Click:Connect(function()
        val = not val
        Tween(togBG, TweenInfo.new(0.18), {BackgroundColor3 = val and C.Accent or C.TogOff})
        Tween(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
            Position = val and UDim2.new(0, 20, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        })
        callback(val)
    end)
    btn.MouseEnter:Connect(function() Tween(f, TweenInfo.new(0.12), {BackgroundColor3 = C.ElemHov}) end)
    btn.MouseLeave:Connect(function() Tween(f, TweenInfo.new(0.12), {BackgroundColor3 = C.Elem}) end)
    if default then callback(default) end
end

local function Button(page, title, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38); f.BackgroundColor3 = C.Elem
    f.BorderSizePixel = 0; f.LayoutOrder = nO(); f.Parent = page
    Corner(f, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -40, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = title
    lbl.TextColor3 = C.Text; lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = f
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(20, 20); arrow.Position = UDim2.new(1, -28, 0.5, -10)
    arrow.BackgroundTransparency = 1; arrow.Text = "›"; arrow.TextColor3 = C.Accent
    arrow.TextSize = 18; arrow.Font = Enum.Font.GothamBold; arrow.Parent = f
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = f
    btn.MouseButton1Click:Connect(function()
        Tween(f, TweenInfo.new(0.08), {BackgroundColor3 = C.Accent})
        task.delay(0.15, function() Tween(f, TweenInfo.new(0.15), {BackgroundColor3 = C.Elem}) end)
        callback()
    end)
    btn.MouseEnter:Connect(function() Tween(f, TweenInfo.new(0.12), {BackgroundColor3 = C.ElemHov}) end)
    btn.MouseLeave:Connect(function() Tween(f, TweenInfo.new(0.12), {BackgroundColor3 = C.Elem}) end)
end

local function Slider(page, title, min, max, default, increment, callback)
    increment = increment or 0.05
    local val = default or min
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 54); f.BackgroundColor3 = C.Elem
    f.BorderSizePixel = 0; f.LayoutOrder = nO(); f.Parent = page; Corner(f, 8)
    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.65, 0, 0, 22); tLbl.Position = UDim2.new(0, 12, 0, 7)
    tLbl.BackgroundTransparency = 1; tLbl.Text = title
    tLbl.TextColor3 = C.Text; tLbl.TextSize = 13
    tLbl.Font = Enum.Font.Gotham; tLbl.TextXAlignment = Enum.TextXAlignment.Left; tLbl.Parent = f
    local vLbl = Instance.new("TextLabel")
    vLbl.Size = UDim2.new(0.3, 0, 0, 22); vLbl.Position = UDim2.new(0.7, -8, 0, 7)
    vLbl.BackgroundTransparency = 1; vLbl.Text = tostring(math.round(val*100)/100)
    vLbl.TextColor3 = C.Accent; vLbl.TextSize = 13
    vLbl.Font = Enum.Font.GothamBold; vLbl.TextXAlignment = Enum.TextXAlignment.Right; vLbl.Parent = f
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 5); track.Position = UDim2.new(0, 12, 0, 38)
    track.BackgroundColor3 = Color3.fromRGB(35,35,52); track.BorderSizePixel = 0; track.Parent = f
    Corner(track, 3)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = C.Accent; fill.BorderSizePixel = 0; fill.Parent = track; Corner(fill, 3)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14,14); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((val-min)/(max-min), 0, 0.5, 0)
    knob.BackgroundColor3 = C.White; knob.BorderSizePixel = 0; knob.Parent = track; Corner(knob, 7)
    local draggingThis = false
    local function setVal(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = min + (max - min) * rel
        val = math.clamp(math.round(raw / increment) * increment, min, max)
        local pct = (val-min)/(max-min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        vLbl.Text = tostring(math.round(val*100)/100)
        callback(val)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            draggingThis = true; isDraggingSlider = true; setVal(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingThis and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then setVal(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            if draggingThis then draggingThis = false; isDraggingSlider = false end
        end
    end)
end

-- MINIMIZE / CLOSE
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quart)
    Tween(Window, ti, {Size = isMin and UDim2.fromOffset(580,46) or UDim2.fromOffset(580,420)})
    MinBtn.Text = isMin and "+" or "–"
end)

CloseBtn.MouseButton1Click:Connect(function()
    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Tween(Window, ti, {Size = UDim2.fromOffset(0,0)})
    Tween(Shadow, ti, {Size = UDim2.fromOffset(0,0)})
    task.delay(0.3, function() ScreenGui:Destroy() end)
end)

-- OPEN ANIMATION
task.defer(function()
    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(Window, ti, {Size = UDim2.fromOffset(580, 420)})
    Tween(Shadow, ti, {Size = UDim2.fromOffset(614, 454)})
end)

-- ==================================================
-- GAME SETUP
-- ==================================================
local State = {
    Buy=false, Upgrade=false, Fruit=false,
    Rebirth=false, Evolve=false, PowerLevel=false,
    CashDrop=false, Delay=0.25,
}

local function GetHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function FindTycoon()
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:match("Tycoon") then
            local o = v:FindFirstChild("Owner")
            if o and o.Value == LocalPlayer then return v end
        end
    end
end

local Tycoon = FindTycoon()
if not Tycoon then
    task.defer(function() Notify("Error", "Tycoon tidak ditemukan!", 5) end)
    return
end

-- AUTO BUY
local Btns = {}
local function RefreshBtns()
    table.clear(Btns)
    local purchases = Tycoon:FindFirstChild("Purchases")
    if not purchases then return end
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("Model") and obj:GetAttribute("Shown") and not obj:GetAttribute("Purchased") then
            local part = obj:FindFirstChild("Button")
            if part and part:IsA("BasePart") then table.insert(Btns, part) end
        end
    end
end
local function Touch(part)
    pcall(function()
        local hrp = GetHRP()
        firetouchinterest(hrp, part, 0); task.wait(0.05); firetouchinterest(hrp, part, 1)
    end)
end
task.spawn(function()
    while true do
        if State.Buy then RefreshBtns(); for _, b in ipairs(Btns) do if b and b.Parent then Touch(b) end end end
        task.wait(State.Delay)
    end
end)

-- AUTO UPGRADE (cached)
local upRems = {}; local upLvl = {}; local lastScan = 0
local function refreshUp()
    upRems = {}; upLvl = {}
    local p = Tycoon:FindFirstChild("Purchases"); if not p then return end
    for _, obj in ipairs(p:GetDescendants()) do
        if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then upRems[#upRems+1] = obj end
    end
end
task.spawn(function()
    while true do
        if State.Upgrade then
            if tick() - lastScan > 3 then refreshUp(); lastScan = tick() end
            for _, rem in ipairs(upRems) do
                if rem.Parent then
                    local lvl = (upLvl[rem] or 0) + 1
                    while lvl <= 100 do
                        local ok, res = pcall(function() return rem:InvokeServer(lvl) end)
                        if not ok or res == false then break end
                        upLvl[rem] = lvl; lvl = lvl + 1
                    end
                end
            end
        end
        task.wait(0.25)
    end
end)

-- AUTO POWER LEVEL
task.spawn(function()
    while true do
        if State.PowerLevel then
            local rems = Tycoon:FindFirstChild("Remotes")
            local r = rems and rems:FindFirstChild("UpgradePowerLevel")
            if r then pcall(function() r:InvokeServer() end) end
        end
        task.wait(0.25)
    end
end)

-- REBIRTH HELPERS
local NS = {thousand=1e3,million=1e6,billion=1e9,trillion=1e12,quadrillion=1e15,quintillion=1e18,k=1e3,m=1e6,b=1e9,t=1e12}
local function parseNum(s)
    if not s then return nil end
    s = tostring(s):gsub(",",""):lower()
    local val = tonumber(s:match("[%d%.]+"))
    if not val then return nil end
    local word = s:match("[%d%.%s]+([a-z]+)")
    if word and NS[word] then val = val * NS[word] end
    return val
end
local function readQ(name)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local r = pg and pg:FindFirstChild("Rebirth")
    local im = r and r:FindFirstChild("InvestorsMenu")
    local body = im and im:FindFirstChild("Body")
    local frame = body and body:FindFirstChild(name)
    local q = frame and frame:FindFirstChild("Quantity")
    return q and parseNum(q.Text)
end

-- AUTO REBIRTH
local rebirthBusy = false
task.spawn(function()
    while true do
        if State.Rebirth and not rebirthBusy then
            local rems = Tycoon:FindFirstChild("Remotes")
            local remote = rems and rems:FindFirstChild("Rebirth")
            local potential = readQ("Potential"); local current = readQ("Amount") or 0
            if remote and potential and potential >= 1 and potential >= current then
                rebirthBusy = true
                pcall(function()
                    local done = false; local sig = rems:FindFirstChild("Rebirthed"); local conn
                    if sig and sig:IsA("RemoteEvent") then conn = sig.OnClientEvent:Connect(function() done = true end) end
                    remote:InvokeServer()
                    local t = 0; while not done and t < 8 do task.wait(0.1); t = t + 0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(2); rebirthBusy = false
            end
        end
        task.wait(0.5)
    end
end)

-- AUTO EVOLVE
local evolveBusy = false
task.spawn(function()
    while true do
        if State.Evolve and not evolveBusy then
            local rems = Tycoon:FindFirstChild("Remotes"); local remote = rems and rems:FindFirstChild("Evolve")
            local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local r = pg and pg:FindFirstChild("Rebirth")
            local em = r and r:FindFirstChild("EvolutionMenu"); local body = em and em:FindFirstChild("Body")
            local p = body and body:FindFirstChild("Progress")
            local pct = p and tonumber(tostring(p.Text):match("[%d%.]+"))
            if remote and pct and pct >= 100 then
                evolveBusy = true
                pcall(function()
                    local done = false; local sig = rems:FindFirstChild("Evolved"); local conn
                    if sig and sig:IsA("RemoteEvent") then conn = sig.OnClientEvent:Connect(function() done = true end) end
                    remote:InvokeServer()
                    local t = 0; while not done and t < 8 do task.wait(0.1); t = t + 0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(2); evolveBusy = false
            end
        end
        task.wait(0.5)
    end
end)

-- AUTO FRUIT
local Trees = {}
local function addTree(obj)
    if obj:IsA("Model") and obj.Name == "LemonTree" and not table.find(Trees, obj) then table.insert(Trees, obj) end
end
local function removeTree(obj) local i = table.find(Trees, obj); if i then table.remove(Trees, i) end end
for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)
local function collectFruit(tree)
    for _, obj in ipairs(tree:GetDescendants()) do if obj:IsA("BasePart") then obj.CanCollide = false end end
    pcall(function()
        local hrp = GetHRP(); hrp.CFrame = tree:GetPivot() + Vector3.new(0, 5, 0)
        for _, obj in ipairs(tree:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Fruit" then
                local cp = obj:FindFirstChild("ClickPart")
                if cp then local det = cp:FindFirstChildOfClass("ClickDetector"); if det then task.wait(0.4); pcall(function() fireclickdetector(det) end) end end
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

-- AUTO CASHDROP (FIXED)
-- Structure: workspace > CashDrop (folder) > CashDrop (actual items)
task.spawn(function()
    while true do
        if State.CashDrop then
            pcall(function()
                local hrp = GetHRP()
                local originalCF = hrp.CFrame

                local dropFolder = workspace:FindFirstChild("CashDrop")
                if dropFolder then
                    local drops = {}
                    for _, v in ipairs(dropFolder:GetChildren()) do
                        if v.Name == "CashDrop" then table.insert(drops, v) end
                    end

                    for _, drop in ipairs(drops) do
                        if drop and drop.Parent then
                            pcall(function()
                                local pos
                                if drop:IsA("BasePart") then
                                    pos = drop.Position
                                elseif drop:IsA("Model") then
                                    local pp = drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
                                    if pp then pos = pp.Position end
                                end
                                if pos then
                                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                                    task.wait(0.2)
                                end
                            end)
                        end
                    end

                    task.wait(0.1)
                    hrp.CFrame = originalCF
                end
            end)
        end
        task.wait(State.Delay)
    end
end)

-- SEWER
local function touchPart(hrp, part)
    pcall(function() firetouchinterest(hrp, part, 0); firetouchinterest(hrp, part, 1) end)
end
local function doSewerRun()
    local ok = pcall(function()
        local hrp = GetHRP()
        local map = workspace:FindFirstChild("Map"); local sewer = map and map:FindFirstChild("Sewer")
        if not sewer then error("no sewer") end
        for _, o in ipairs(sewer:GetDescendants()) do
            if o:IsA("BasePart") and string.lower(o.Name):find("lever") then touchPart(hrp, o) end
        end
        for _, fn in ipairs({"CashVine","SewerAlien"}) do
            local fld = sewer:FindFirstChild(fn)
            if fld then for _, o in ipairs(fld:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name=="VineKey" or o.Name=="UFOKey") then touchPart(hrp, o) end
            end end
        end
        task.wait(0.3)
        local cv = sewer:FindFirstChild("CashVine")
        if cv then
            local vd = cv:FindFirstChild("VineDoor")
            if vd then for _, o in ipairs(vd:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp,o) end end end
            task.wait(0.3)
            local vm = cv:FindFirstChild("CashVine")
            if vm then
                pcall(function() hrp.CFrame = vm:GetPivot() + Vector3.new(0,3,0) end); task.wait(0.2)
                for _, o in ipairs(vm:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp,o) end end
            end
        end
    end)
    return ok
end

-- ==================================================
-- BUILD TABS + UI
-- ==================================================
local MainTab  = CreateTab("Main")
local SewerTab = CreateTab("Sewer")
local MiscTab  = CreateTab("Misc")

-- MAIN
Section(MainTab.Page, "Auto Features")
Toggle(MainTab.Page, "Auto Buy",         false, function(v) State.Buy        = v end)
Toggle(MainTab.Page, "Auto Upgrade",     false, function(v) State.Upgrade    = v end)
Toggle(MainTab.Page, "Auto Fruit",       false, function(v) State.Fruit      = v end)
Toggle(MainTab.Page, "Auto Rebirth",     false, function(v) State.Rebirth    = v end)
Toggle(MainTab.Page, "Auto Evolve",      false, function(v) State.Evolve     = v end)
Toggle(MainTab.Page, "Auto Power Level", false, function(v) State.PowerLevel = v end)
Toggle(MainTab.Page, "Auto CashDrop",    false, function(v) State.CashDrop   = v end)
Section(MainTab.Page, "Settings")
Slider(MainTab.Page, "Delay (sec)", 0.05, 2, 0.25, 0.05, function(v) State.Delay = v end)

-- SEWER
Section(SewerTab.Page, "Sewer Actions")
Button(SewerTab.Page, "Sewer Run", function()
    task.spawn(function()
        local ok = doSewerRun()
        Notify("Sewer Run", ok and "Berhasil!" or "Sewer tidak ditemukan!", 3)
    end)
end)
Button(SewerTab.Page, "Teleport to Alien", function()
    pcall(function() local hrp = GetHRP(); hrp.CFrame = CFrame.new(-42, -41, 180) end)
    Notify("Teleport", "Menuju Sewer Alien!", 3)
end)

-- MISC
Section(MiscTab.Page, "Controls")
Button(MiscTab.Page, "Emergency Stop", function()
    State.Buy=false; State.Upgrade=false; State.Fruit=false
    State.Rebirth=false; State.Evolve=false; State.PowerLevel=false; State.CashDrop=false
    Notify("Stop", "Semua fitur dimatikan!", 3)
end)
Button(MiscTab.Page, "Destroy GUI", function()
    local ti = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    Tween(Window, ti, {Size = UDim2.fromOffset(0,0)}); Tween(Shadow, ti, {Size = UDim2.fromOffset(0,0)})
    task.delay(0.3, function() ScreenGui:Destroy() end)
end)

ActivateTab(MainTab)
task.defer(function() Notify("Faltix Hub", "Powered By Attala — Ready!", 4) end)
