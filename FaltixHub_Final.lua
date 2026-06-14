if _G.FaltixHubLoaded then return end
_G.FaltixHubLoaded = true

-- ============================================================
-- SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService  = game:GetService("TeleportService")
local TweenService     = game:GetService("TweenService")
local RepStorage       = game:GetService("ReplicatedStorage")

local LP         = Players.LocalPlayer
local PlayerGui  = LP:WaitForChild("PlayerGui")

local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function HRP()     return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") end
local function HUM()     return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") end
local function zeroVel(h)
    h.AssemblyLinearVelocity  = Vector3.zero
    h.AssemblyAngularVelocity = Vector3.zero
end
local function setAnalog(state)
    local tg = LP.PlayerGui:FindFirstChild("TouchGui")
    if tg then local f = tg:FindFirstChild("TouchControlFrame"); if f then f.Visible = state end end
end

-- ============================================================
-- CUSTOM UI SETUP
-- ============================================================
if PlayerGui:FindFirstChild("FaltixHub") then PlayerGui:FindFirstChild("FaltixHub"):Destroy() end

local function Tween(obj, t, props) TweenService:Create(obj, t, props):Play() end
local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p
end

local C = {
    BG       = Color3.fromRGB(11,11,17),
    Sidebar  = Color3.fromRGB(16,16,24),
    TopBar   = Color3.fromRGB(14,14,21),
    Accent   = Color3.fromRGB(188,28,52),
    TabIn    = Color3.fromRGB(26,26,38),
    Text     = Color3.fromRGB(238,238,248),
    TextDim  = Color3.fromRGB(148,148,168),
    Elem     = Color3.fromRGB(20,20,30),
    ElemHov  = Color3.fromRGB(30,30,44),
    TogOff   = Color3.fromRGB(44,44,60),
    Sep      = Color3.fromRGB(32,32,48),
    White    = Color3.new(1,1,1),
    CloseRed = Color3.fromRGB(200,38,55),
    Green    = Color3.fromRGB(34,180,90),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FaltixHub"; ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint = Vector2.new(0.5,0.5); Shadow.Size = UDim2.fromOffset(0,0)
Shadow.Position = UDim2.new(0.5,0,0.5,8); Shadow.BackgroundTransparency = 1
Shadow.ZIndex = 0; Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0,0,0); Shadow.ImageTransparency = 0.45
Shadow.ScaleType = Enum.ScaleType.Slice; Shadow.SliceCenter = Rect.new(49,49,450,450)
Shadow.Visible = false; Shadow.Parent = ScreenGui

local Window = Instance.new("Frame")
Window.AnchorPoint = Vector2.new(0.5,0.5); Window.Size = UDim2.fromOffset(0,0)
Window.Position = UDim2.new(0.5,0,0.5,0); Window.BackgroundColor3 = C.BG
Window.BorderSizePixel = 0; Window.Visible = false; Window.Parent = ScreenGui; Corner(Window,12)

-- LOGO BUTTON
local LogoHolder = Instance.new("Frame")
LogoHolder.Size = UDim2.fromOffset(50,50); LogoHolder.Position = UDim2.new(0,12,0,12)
LogoHolder.BackgroundColor3 = C.Sidebar; LogoHolder.BorderSizePixel = 0
LogoHolder.ZIndex = 20; LogoHolder.Parent = ScreenGui; Corner(LogoHolder,12)

local GlowRing = Instance.new("Frame")
GlowRing.Size = UDim2.new(1,6,1,6); GlowRing.Position = UDim2.new(0,-3,0,-3)
GlowRing.BackgroundColor3 = C.Accent; GlowRing.BackgroundTransparency = 0.6
GlowRing.BorderSizePixel = 0; GlowRing.ZIndex = 19; GlowRing.Parent = LogoHolder; Corner(GlowRing,14)

local LogoImg = Instance.new("ImageButton")
LogoImg.Size = UDim2.fromOffset(32,32); LogoImg.Position = UDim2.new(0.5,-16,0.5,-16)
LogoImg.BackgroundTransparency = 1; LogoImg.Image = "rbxassetid://110127950553563"
LogoImg.ZIndex = 21; LogoImg.Parent = LogoHolder

task.spawn(function()
    while true do
        Tween(GlowRing, TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {BackgroundTransparency=0.3})
        task.wait(1.2)
        Tween(GlowRing, TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut), {BackgroundTransparency=0.85})
        task.wait(1.2)
    end
end)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,42); TopBar.BackgroundColor3 = C.TopBar
TopBar.BorderSizePixel = 0; TopBar.ZIndex = 5; TopBar.Parent = Window; Corner(TopBar,12)
do
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,12); f.Position=UDim2.new(0,0,1,-12)
    f.BackgroundColor3=C.TopBar; f.BorderSizePixel=0; f.ZIndex=5; f.Parent=TopBar
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,22,33)),ColorSequenceKeypoint.new(1,Color3.fromRGB(11,11,17))})
    g.Rotation=90; g.Parent=TopBar
end

local TitleLbl=Instance.new("TextLabel"); TitleLbl.Size=UDim2.new(0,120,0,17)
TitleLbl.Position=UDim2.new(0,12,0,7); TitleLbl.BackgroundTransparency=1
TitleLbl.Text="Faltix Hub"; TitleLbl.TextColor3=C.Text; TitleLbl.TextSize=14
TitleLbl.Font=Enum.Font.GothamBold; TitleLbl.TextXAlignment=Enum.TextXAlignment.Left
TitleLbl.ZIndex=6; TitleLbl.Parent=TopBar

local SubLbl=Instance.new("TextLabel"); SubLbl.Size=UDim2.new(0,160,0,12)
SubLbl.Position=UDim2.new(0,12,0,25); SubLbl.BackgroundTransparency=1
SubLbl.Text="Lucky Block Edition | Attala"; SubLbl.TextColor3=C.TextDim
SubLbl.TextSize=10; SubLbl.Font=Enum.Font.Gotham
SubLbl.TextXAlignment=Enum.TextXAlignment.Left; SubLbl.ZIndex=6; SubLbl.Parent=TopBar

local CloseBtn=Instance.new("TextButton"); CloseBtn.Size=UDim2.fromOffset(24,24)
CloseBtn.Position=UDim2.new(1,-32,0.5,-12); CloseBtn.BackgroundColor3=C.CloseRed
CloseBtn.Text="×"; CloseBtn.TextColor3=C.White; CloseBtn.TextSize=16
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.BorderSizePixel=0
CloseBtn.AutoButtonColor=false; CloseBtn.ZIndex=6; CloseBtn.Parent=TopBar; Corner(CloseBtn,6)

-- SIDEBAR
local Sidebar=Instance.new("Frame"); Sidebar.Size=UDim2.new(0,138,1,-42)
Sidebar.Position=UDim2.new(0,0,0,42); Sidebar.BackgroundColor3=C.Sidebar
Sidebar.BorderSizePixel=0; Sidebar.Parent=Window; Corner(Sidebar,12)
do
    local t=Instance.new("Frame"); t.Size=UDim2.new(1,0,0,12); t.BackgroundColor3=C.Sidebar
    t.BorderSizePixel=0; t.ZIndex=2; t.Parent=Sidebar
    local r=Instance.new("Frame"); r.Size=UDim2.new(0,12,1,0); r.Position=UDim2.new(1,-12,0,0)
    r.BackgroundColor3=C.Sidebar; r.BorderSizePixel=0; r.ZIndex=2; r.Parent=Sidebar
end

local TabList=Instance.new("ScrollingFrame"); TabList.Size=UDim2.new(1,-8,1,-14)
TabList.Position=UDim2.new(0,4,0,10); TabList.BackgroundTransparency=1
TabList.ScrollBarThickness=0; TabList.BorderSizePixel=0
TabList.CanvasSize=UDim2.new(0,0,0,0); TabList.AutomaticCanvasSize=Enum.AutomaticSize.Y
TabList.Parent=Sidebar
local TLL=Instance.new("UIListLayout"); TLL.Padding=UDim.new(0,4)
TLL.SortOrder=Enum.SortOrder.LayoutOrder; TLL.Parent=TabList

-- SEPARATOR + CONTENT
local SepLine=Instance.new("Frame"); SepLine.Size=UDim2.new(0,1,1,-42)
SepLine.Position=UDim2.new(0,138,0,42); SepLine.BackgroundColor3=C.Sep
SepLine.BorderSizePixel=0; SepLine.Parent=Window

local ContentArea=Instance.new("Frame"); ContentArea.Size=UDim2.new(1,-140,1,-44)
ContentArea.Position=UDim2.new(0,140,0,44); ContentArea.BackgroundTransparency=1
ContentArea.ClipsDescendants=true; ContentArea.Parent=Window

-- DRAGGING
local isDragging,isDraggingSlider=false,false
local dragStart,dragStartPos
local baseWinPos=UDim2.new(0.5,0,0.5,0)

TopBar.InputBegan:Connect(function(input)
    if isDraggingSlider then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        isDragging=true; dragStart=input.Position; dragStartPos=baseWinPos
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then isDragging=false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=input.Position-dragStart
        baseWinPos=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
    end
end)

local floatT=0
RunService.Heartbeat:Connect(function(dt)
    if not Window.Visible then return end
    floatT=floatT+dt
    local fy=isDragging and 0 or (math.sin(floatT*0.7)*2)
    Window.Position=UDim2.new(baseWinPos.X.Scale,baseWinPos.X.Offset,baseWinPos.Y.Scale,baseWinPos.Y.Offset+fy)
    Shadow.Position=UDim2.new(Window.Position.X.Scale,Window.Position.X.Offset,Window.Position.Y.Scale,Window.Position.Y.Offset+8)
end)

-- WINDOW TOGGLE
local windowOpen=false
local function openWindow()
    windowOpen=true; Window.Size=UDim2.fromOffset(0,0); Window.Visible=true
    Shadow.Size=UDim2.fromOffset(0,0); Shadow.Visible=true
    Tween(Window,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(540,380)})
    Tween(Shadow,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(574,414)})
    Tween(LogoHolder,TweenInfo.new(0.2),{BackgroundColor3=C.Accent})
end
local function closeWindow(destroy)
    windowOpen=false
    local ti=TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
    Tween(Window,ti,{Size=UDim2.fromOffset(0,0)}); Tween(Shadow,ti,{Size=UDim2.fromOffset(0,0)})
    Tween(LogoHolder,TweenInfo.new(0.2),{BackgroundColor3=C.Sidebar})
    task.delay(0.22,function()
        Window.Visible=false; Shadow.Visible=false
        if destroy then ScreenGui:Destroy() end
    end)
end
LogoImg.MouseButton1Click:Connect(function() if windowOpen then closeWindow(false) else openWindow() end end)
CloseBtn.MouseButton1Click:Connect(function() closeWindow(false) end)

-- NOTIFICATIONS
local NH=Instance.new("Frame"); NH.Size=UDim2.new(0,255,1,0)
NH.Position=UDim2.new(1,-265,0,0); NH.BackgroundTransparency=1; NH.Parent=ScreenGui
local NL=Instance.new("UIListLayout"); NL.Padding=UDim.new(0,8)
NL.VerticalAlignment=Enum.VerticalAlignment.Bottom; NL.FillDirection=Enum.FillDirection.Vertical
NL.SortOrder=Enum.SortOrder.LayoutOrder; NL.Parent=NH
local NP=Instance.new("UIPadding"); NP.PaddingBottom=UDim.new(0,15); NP.PaddingRight=UDim.new(0,8); NP.Parent=NH

local function Notify(title,body,dur)
    dur=dur or 3
    local nf=Instance.new("Frame"); nf.Size=UDim2.new(1,0,0,56)
    nf.BackgroundColor3=C.Sidebar; nf.BorderSizePixel=0; nf.BackgroundTransparency=1; nf.Parent=NH; Corner(nf,9)
    local na=Instance.new("Frame"); na.Size=UDim2.fromOffset(3,30); na.Position=UDim2.new(0,0,0.5,-15)
    na.BackgroundColor3=C.Accent; na.BorderSizePixel=0; na.BackgroundTransparency=1; Corner(na,2); na.Parent=nf
    local nt=Instance.new("TextLabel"); nt.Size=UDim2.new(1,-16,0,18); nt.Position=UDim2.new(0,10,0,8)
    nt.BackgroundTransparency=1; nt.Text=title; nt.TextColor3=C.Text; nt.TextSize=13
    nt.Font=Enum.Font.GothamBold; nt.TextXAlignment=Enum.TextXAlignment.Left; nt.TextTransparency=1; nt.Parent=nf
    local nb=Instance.new("TextLabel"); nb.Size=UDim2.new(1,-16,0,14); nb.Position=UDim2.new(0,10,0,30)
    nb.BackgroundTransparency=1; nb.Text=body; nb.TextColor3=C.TextDim; nb.TextSize=11
    nb.Font=Enum.Font.Gotham; nb.TextXAlignment=Enum.TextXAlignment.Left; nb.TextTransparency=1; nb.Parent=nf
    local tiIn=TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    local tiOut=TweenInfo.new(0.2)
    Tween(nf,tiIn,{BackgroundTransparency=0}); Tween(na,tiIn,{BackgroundTransparency=0})
    Tween(nt,tiIn,{TextTransparency=0}); Tween(nb,tiIn,{TextTransparency=0})
    task.delay(dur,function()
        Tween(nf,tiOut,{BackgroundTransparency=1}); Tween(na,tiOut,{BackgroundTransparency=1})
        Tween(nt,tiOut,{TextTransparency=1}); Tween(nb,tiOut,{TextTransparency=1})
        task.wait(0.25); nf:Destroy()
    end)
end

-- TAB SYSTEM
local ActiveTab=nil; local tabOrder=0
local function ActivateTab(tab)
    if ActiveTab then
        Tween(ActiveTab.Btn,TweenInfo.new(0.15),{BackgroundColor3=C.TabIn})
        Tween(ActiveTab.TLbl,TweenInfo.new(0.15),{TextColor3=C.TextDim})
        Tween(ActiveTab.Ind,TweenInfo.new(0.15),{BackgroundTransparency=1})
        ActiveTab.Page.Visible=false
    end
    Tween(tab.Btn,TweenInfo.new(0.15),{BackgroundColor3=C.Accent})
    Tween(tab.TLbl,TweenInfo.new(0.15),{TextColor3=C.White})
    Tween(tab.Ind,TweenInfo.new(0.15),{BackgroundTransparency=0})
    tab.Page.Visible=true
    tab.Page.Position=UDim2.new(0.06,0,0,0)
    Tween(tab.Page,TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)})
    ActiveTab=tab
end

local function CreateTab(name)
    tabOrder=tabOrder+1
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36)
    btn.BackgroundColor3=C.TabIn; btn.Text=""; btn.BorderSizePixel=0
    btn.AutoButtonColor=false; btn.LayoutOrder=tabOrder; btn.Parent=TabList; Corner(btn,8)
    local ind=Instance.new("Frame"); ind.Size=UDim2.fromOffset(3,18); ind.Position=UDim2.new(0,0,0.5,-9)
    ind.BackgroundColor3=C.White; ind.BorderSizePixel=0; ind.BackgroundTransparency=1; Corner(ind,2); ind.Parent=btn
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(1,-16,1,0); tl.Position=UDim2.new(0,12,0,0)
    tl.BackgroundTransparency=1; tl.Text=name; tl.TextColor3=C.TextDim; tl.TextSize=12
    tl.Font=Enum.Font.Gotham; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=btn
    local page=Instance.new("ScrollingFrame"); page.Size=UDim2.new(1,0,1,0)
    page.BackgroundTransparency=1; page.BorderSizePixel=0; page.ScrollBarThickness=3
    page.ScrollBarImageColor3=C.Accent; page.CanvasSize=UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y; page.Visible=false; page.Parent=ContentArea
    local pl=Instance.new("UIListLayout"); pl.Padding=UDim.new(0,5); pl.SortOrder=Enum.SortOrder.LayoutOrder; pl.Parent=page
    local pp=Instance.new("UIPadding"); pp.PaddingLeft=UDim.new(0,8); pp.PaddingRight=UDim.new(0,8)
    pp.PaddingTop=UDim.new(0,7); pp.PaddingBottom=UDim.new(0,8); pp.Parent=page
    local tab={Btn=btn,TLbl=tl,Ind=ind,Page=page}
    btn.MouseButton1Click:Connect(function() ActivateTab(tab) end)
    btn.MouseEnter:Connect(function() if ActiveTab~=tab then Tween(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(33,33,48)}) end end)
    btn.MouseLeave:Connect(function() if ActiveTab~=tab then Tween(btn,TweenInfo.new(0.12),{BackgroundColor3=C.TabIn}) end end)
    return tab
end

-- ELEMENT BUILDERS
local eO=0; local function nO() eO=eO+1; return eO end

local function Section(page,title)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,24); f.BackgroundTransparency=1; f.LayoutOrder=nO(); f.Parent=page
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.Text="  "..string.upper(title); l.TextColor3=C.Accent; l.TextSize=10
    l.Font=Enum.Font.GothamBold; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local ln=Instance.new("Frame"); ln.Size=UDim2.new(1,0,0,1); ln.Position=UDim2.new(0,0,1,-1)
    ln.BackgroundColor3=C.Sep; ln.BorderSizePixel=0; ln.Parent=f
end

local function Toggle(page,title,default,callback)
    local val=default or false
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,36); f.BackgroundColor3=C.Elem
    f.BorderSizePixel=0; f.LayoutOrder=nO(); f.Parent=page; Corner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-56,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.Text=title; l.TextColor3=C.Text; l.TextSize=12
    l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local bg=Instance.new("Frame"); bg.Size=UDim2.fromOffset(36,18); bg.Position=UDim2.new(1,-46,0.5,-9)
    bg.BackgroundColor3=val and C.Accent or C.TogOff; bg.BorderSizePixel=0; bg.Parent=f; Corner(bg,9)
    local kn=Instance.new("Frame"); kn.Size=UDim2.fromOffset(14,14)
    kn.Position=val and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7)
    kn.BackgroundColor3=C.White; kn.BorderSizePixel=0; kn.Parent=bg; Corner(kn,7)
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.Parent=f
    btn.MouseButton1Click:Connect(function()
        val=not val
        Tween(bg,TweenInfo.new(0.16),{BackgroundColor3=val and C.Accent or C.TogOff})
        Tween(kn,TweenInfo.new(0.16,Enum.EasingStyle.Quart),{Position=val and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7)})
        callback(val)
    end)
    btn.MouseEnter:Connect(function() Tween(f,TweenInfo.new(0.1),{BackgroundColor3=C.ElemHov}) end)
    btn.MouseLeave:Connect(function() Tween(f,TweenInfo.new(0.1),{BackgroundColor3=C.Elem}) end)
    if default then callback(default) end
end

local function Button(page,title,callback)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,36); f.BackgroundColor3=C.Elem
    f.BorderSizePixel=0; f.LayoutOrder=nO(); f.Parent=page; Corner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-38,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.Text=title; l.TextColor3=C.Text; l.TextSize=12
    l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local ar=Instance.new("TextLabel"); ar.Size=UDim2.fromOffset(18,18); ar.Position=UDim2.new(1,-26,0.5,-9)
    ar.BackgroundTransparency=1; ar.Text="›"; ar.TextColor3=C.Accent; ar.TextSize=17
    ar.Font=Enum.Font.GothamBold; ar.Parent=f
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.Parent=f
    btn.MouseButton1Click:Connect(function()
        Tween(f,TweenInfo.new(0.07),{BackgroundColor3=C.Accent})
        task.delay(0.13,function() Tween(f,TweenInfo.new(0.13),{BackgroundColor3=C.Elem}) end)
        callback()
    end)
    btn.MouseEnter:Connect(function() Tween(f,TweenInfo.new(0.1),{BackgroundColor3=C.ElemHov}) end)
    btn.MouseLeave:Connect(function() Tween(f,TweenInfo.new(0.1),{BackgroundColor3=C.Elem}) end)
end

local function Slider(page,title,min,max,default,increment,callback)
    increment=increment or 1; local val=default or min
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,52); f.BackgroundColor3=C.Elem
    f.BorderSizePixel=0; f.LayoutOrder=nO(); f.Parent=page; Corner(f,8)
    local tl=Instance.new("TextLabel"); tl.Size=UDim2.new(0.65,0,0,20); tl.Position=UDim2.new(0,10,0,6)
    tl.BackgroundTransparency=1; tl.Text=title; tl.TextColor3=C.Text; tl.TextSize=12
    tl.Font=Enum.Font.Gotham; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.Parent=f
    local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(0.3,0,0,20); vl.Position=UDim2.new(0.7,-8,0,6)
    vl.BackgroundTransparency=1; vl.Text=tostring(val); vl.TextColor3=C.Accent; vl.TextSize=12
    vl.Font=Enum.Font.GothamBold; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=f
    local tr=Instance.new("Frame"); tr.Size=UDim2.new(1,-20,0,5); tr.Position=UDim2.new(0,10,0,37)
    tr.BackgroundColor3=Color3.fromRGB(35,35,52); tr.BorderSizePixel=0; tr.Parent=f; Corner(tr,3)
    local fi=Instance.new("Frame"); fi.Size=UDim2.new((val-min)/(max-min),0,1,0)
    fi.BackgroundColor3=C.Accent; fi.BorderSizePixel=0; fi.Parent=tr; Corner(fi,3)
    local kn=Instance.new("Frame"); kn.Size=UDim2.fromOffset(12,12); kn.AnchorPoint=Vector2.new(0.5,0.5)
    kn.Position=UDim2.new((val-min)/(max-min),0,0.5,0); kn.BackgroundColor3=C.White
    kn.BorderSizePixel=0; kn.Parent=tr; Corner(kn,6)
    local dth=false
    local function sv(x)
        local rel=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        val=math.clamp(math.round((min+(max-min)*rel)/increment)*increment,min,max)
        local pct=(val-min)/(max-min); fi.Size=UDim2.new(pct,0,1,0); kn.Position=UDim2.new(pct,0,0.5,0)
        vl.Text=tostring(val); callback(val)
    end
    tr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dth=true; isDraggingSlider=true; sv(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dth and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then sv(i.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            if dth then dth=false; isDraggingSlider=false end
        end
    end)
end

-- SKIP PROTOCOL SELECTOR (radio button style)
-- Returns a frame element; callback(mode) where mode = "teleport"|"walkback"
local function SkipProtocolSelector(page, callback)
    local selected = "teleport"

    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,58); f.BackgroundColor3=C.Elem
    f.BorderSizePixel=0; f.LayoutOrder=nO(); f.Parent=page; Corner(f,8)

    local label=Instance.new("TextLabel"); label.Size=UDim2.new(1,0,0,18); label.Position=UDim2.new(0,10,0,4)
    label.BackgroundTransparency=1; label.Text="⚡ Skip Protocol"
    label.TextColor3=C.Accent; label.TextSize=11; label.Font=Enum.Font.GothamBold
    label.TextXAlignment=Enum.TextXAlignment.Left; label.Parent=f

    local desc=Instance.new("TextLabel"); desc.Size=UDim2.new(1,-12,0,11); desc.Position=UDim2.new(0,10,0,20)
    desc.BackgroundTransparency=1; desc.Text="Pilih aksi kalo dapet brainrot yg ga lu mau"
    desc.TextColor3=C.TextDim; desc.TextSize=9; desc.Font=Enum.Font.Gotham
    desc.TextXAlignment=Enum.TextXAlignment.Left; desc.Parent=f

    -- Option 1: Teleport Drop
    local o1=Instance.new("TextButton"); o1.Size=UDim2.new(0.5,-8,0,22)
    o1.Position=UDim2.new(0,6,0,34); o1.BackgroundColor3=C.Accent
    o1.Text="📦 Teleport Drop"; o1.TextColor3=C.White; o1.TextSize=10
    o1.Font=Enum.Font.GothamBold; o1.BorderSizePixel=0; o1.AutoButtonColor=false; o1.Parent=f; Corner(o1,6)

    -- Option 2: Walk Back
    local o2=Instance.new("TextButton"); o2.Size=UDim2.new(0.5,-8,0,22)
    o2.Position=UDim2.new(0.5,2,0,34); o2.BackgroundColor3=C.TabIn
    o2.Text="💀 Walk Back"; o2.TextColor3=C.TextDim; o2.TextSize=10
    o2.Font=Enum.Font.Gotham; o2.BorderSizePixel=0; o2.AutoButtonColor=false; o2.Parent=f; Corner(o2,6)

    local function selectOpt(mode)
        selected=mode
        if mode=="teleport" then
            Tween(o1,TweenInfo.new(0.15),{BackgroundColor3=C.Accent}); o1.TextColor3=C.White; o1.Font=Enum.Font.GothamBold
            Tween(o2,TweenInfo.new(0.15),{BackgroundColor3=C.TabIn}); o2.TextColor3=C.TextDim; o2.Font=Enum.Font.Gotham
        else
            Tween(o2,TweenInfo.new(0.15),{BackgroundColor3=C.Accent}); o2.TextColor3=C.White; o2.Font=Enum.Font.GothamBold
            Tween(o1,TweenInfo.new(0.15),{BackgroundColor3=C.TabIn}); o1.TextColor3=C.TextDim; o1.Font=Enum.Font.Gotham
        end
        callback(mode)
    end

    o1.MouseButton1Click:Connect(function() selectOpt("teleport") end)
    o2.MouseButton1Click:Connect(function() selectOpt("walkback") end)
    selectOpt("teleport")
end

-- ============================================================
-- BUILD TABS
-- ============================================================
local V1Tab    = CreateTab("AutoFarm V1")
local V2Tab    = CreateTab("AutoFarm V2")
local TrainTab = CreateTab("AutoTrain")
local PlyrTab  = CreateTab("Player")
local MiscTab  = CreateTab("Misc")
ActivateTab(V1Tab)

-- ============================================================
-- GAME SHARED DATA
-- ============================================================
local TARGET_CF = CFrame.new(
    690.649963, 3.000007, 232.611252,
    -0.054131, 0,  0.998534,
    0,          1,  0,
    -0.998534,  0, -0.054131
)
local TARGET_ROT do
    local _,_,_,a,b,c,d,e,f,g,h,i = TARGET_CF:GetComponents()
    TARGET_ROT = CFrame.new(0,0,0,a,b,c,d,e,f,g,h,i)
end
local SAFE_ZONE_CF = CFrame.new(0, 10, 0)

local CATEGORIES = {
    { name="OG",        list={"Karkerkar Kurkur","Blackhole Goat","Compactoroni Daskaloni","Cappuccino Clownino","Nucleoro Dinossauro","Los Noo My Hotspotsitos","Chillin Chilli","Crazyone Pizaione","Corn Sahur","Meowl","Strawberry Elephant"}},
    { name="Secret",    list={"Bombini Gusini","Castlino Fortini","Tuff Toucan","Fryuro","Burguro","Guest666","Zibra Zubra Zibrallni","Cavallo Virtuoso","Gorillo Watermelondrillo","Cocofanto Elefanto","Bambu Sahur"}},
    { name="Divine",    list={"WL","Girafa Celeste","Tralero Tralala","Tralalerita Tralala","Peant Jarro","Dipperl Chiperini","Rexosaurus","1x1x1x1","Matteo","Espresso Signora"}},
    { name="Hacked",    list={"Alessio","Tripi Tropi Tropa Tripa","Swag Soda","Stoppo Luminino","Torrtuginni Dragonfrutini","Tictac Sahur","Cactus Pingo","Los Primos Blue","La Vacca Saturno Saturnita","Agarrini La Palini","Bottellini"}},
    { name="Celestial", list={"Dragonfrutina Dolphinita","Guerriro Digitale","Chicleteira Bicicleteira","Pot Hotspot","Krupuk Pagi Pagi","Beluga Beluga","Tralaledon","Anpali Babel","Ketchuru and Musturu","Los Primos","Mastodontico Telepiedone"}},
    { name="Eternal",   list={"Ketupat Kepat","Professora 67","Astro Tim","Baba Yaga","Kicky"}},
}

local BRAINROT_SET = {}
local selectedBrainrot = {}
for _, cat in ipairs(CATEGORIES) do
    for _, name in ipairs(cat.list) do
        BRAINROT_SET[name] = true
        selectedBrainrot[name] = false
    end
end

-- WORKSPACE DETECTION: workspace > Debris > Model > [brainrot name or child]
local function scanWorkspaceDebris()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end
    for _, model in ipairs(debris:GetChildren()) do
        if model:IsA("Model") then
            if BRAINROT_SET[model.Name] then return model.Name end
            for _, child in ipairs(model:GetChildren()) do
                if BRAINROT_SET[child.Name] then return child.Name end
            end
        end
    end
    return nil
end

local function detectAnyBrainrot()
    return scanWorkspaceDebris() ~= nil
end

local function fireKick()
    pcall(function()
        RepStorage:WaitForChild("Shared",5):WaitForChild("Packages",5)
            :WaitForChild("Network",5):WaitForChild("rev_KickEvent",5):FireServer(1,1)
    end)
end

-- WALK TO TARGET (analog disabled, jalan biasa)
local function walkToTarget(isActiveFunc, onDone)
    local tPos = TARGET_CF.Position
    setAnalog(false)
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not isActiveFunc() then conn:Disconnect(); setAnalog(true); onDone(); return end
        local h=HRP(); local hum=HUM()
        if not h or not hum then conn:Disconnect(); setAnalog(true); onDone(); return end
        local pos=h.Position; local dx=tPos.X-pos.X; local dz=tPos.Z-pos.Z
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist < 0.6 then
            zeroVel(h); h.CFrame=CFrame.new(tPos.X,pos.Y,tPos.Z)*TARGET_ROT
            conn:Disconnect(); setAnalog(true); onDone(); return
        end
        local spd=math.max(hum.WalkSpeed,1); local step=math.min(spd*dt,dist)
        zeroVel(h); h.CFrame=CFrame.new(pos.X+(dx/dist)*step,pos.Y,pos.Z+(dz/dist)*step)*TARGET_ROT
    end)
end

-- WALK BACK (bunuh diri) → respawn → ke target
local function walkBackThenRespawn(isActiveFunc, onDone)
    setAnalog(false)
    local h=HRP(); if not h then onDone(); return end
    local backDir=-h.CFrame.LookVector
    backDir=Vector3.new(backDir.X,0,backDir.Z).Unit
    local BACK_SPEED=20; local conn
    conn=RunService.Heartbeat:Connect(function(dt)
        if not isActiveFunc() then conn:Disconnect(); setAnalog(true); onDone(); return end
        local hrp=HRP(); local hum=HUM()
        if not hrp or not hum or hum.Health<=0 then
            conn:Disconnect()
            LP.CharacterAdded:Wait(); local nc=getChar(); nc:WaitForChild("HumanoidRootPart")
            task.wait(0.5); walkToTarget(isActiveFunc,onDone); return
        end
        zeroVel(hrp)
        hrp.CFrame=CFrame.new(hrp.Position+backDir*BACK_SPEED*dt,hrp.Position+backDir*BACK_SPEED*dt+backDir)
    end)
end

-- TELEPORT DROP (sengaja kena anti-cheat biar brainrot ke-drop)
local function teleportDrop(isActiveFunc, onDone)
    local h=HRP(); if not h then onDone(); return end
    -- Teleport ke safe zone → anti-cheat deteksi → brainrot ke-drop
    pcall(function() h.CFrame = SAFE_ZONE_CF end)
    task.wait(0.4)
    if not isActiveFunc() then onDone(); return end
    -- Balik ke target
    walkToTarget(isActiveFunc, onDone)
end

-- ============================================================
-- AUTOFARM V1 (workspace detection, jalan biasa kalo dapet)
-- ============================================================
local farmV1=false; local autoCash=false; local autoUpg=false

local function doOneCycleV1(nextCycle)
    if not farmV1 then return end
    local h=HRP(); if not h then task.wait(1); nextCycle(); return end
    zeroVel(h); h.CFrame=TARGET_CF; task.wait(0.35)
    fireKick()
    -- Deteksi via workspace > Debris > Model
    local detected=false; local tStart=tick()
    repeat
        RunService.Heartbeat:Wait()
        if not farmV1 then return end
        if detectAnyBrainrot() then detected=true; break end
    until (tick()-tStart)>5
    if not farmV1 then return end
    -- Kalo kedeteksi → jalan biasa ke target (analog disable, NO teleport)
    if detected then
        walkToTarget(function() return farmV1 end, function() task.wait(0.1); nextCycle() end)
    else
        task.wait(0.1); nextCycle()
    end
end

local function startLoopV1() if not farmV1 then return end; doOneCycleV1(function() task.spawn(startLoopV1) end) end

Section(V1Tab.Page,"Farm")
Toggle(V1Tab.Page,"Auto Farm V1",false,function(v)
    farmV1=v; if v then task.spawn(startLoopV1) else setAnalog(true) end
end)
Section(V1Tab.Page,"Collect & Upgrade")
Toggle(V1Tab.Page,"Auto Collect Cash",false,function(v)
    autoCash=v; if not v then return end
    task.spawn(function()
        while autoCash do
            for i=1,50 do pcall(function() RepStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_B_Collect"):FireServer(i) end); task.wait(0.05) end
            task.wait(3)
        end
    end)
end)
Toggle(V1Tab.Page,"Auto Upgrade Brainrot",false,function(v)
    autoUpg=v; if not v then return end
    task.spawn(function()
        while autoUpg do
            for i=1,50 do pcall(function() RepStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_B_Upgrade"):FireServer(i) end); task.wait(0.05) end
            task.wait(5)
        end
    end)
end)
Section(V1Tab.Page,"Extra")
Button(V1Tab.Page,"Set Safe Zone (posisi sekarang)",function()
    local h=HRP(); if h then SAFE_ZONE_CF=h.CFrame; Notify("Safe Zone","Posisi disimpen!",3) end
end)
Button(V1Tab.Page,"God Mode",function()
    local function apply(char)
        if not char then return end
        for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=1; p.CanCollide=false end end
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then
            hum.MaxHealth=math.huge; hum.Health=math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false); hum.BreakJointsOnDeath=false
            local hrp=char:FindFirstChild("HumanoidRootPart"); if hrp then hrp.CanCollide=true; hrp.Transparency=1 end
        end
    end
    apply(LP.Character)
    RunService.Heartbeat:Connect(function()
        local char=LP.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then
            hum.MaxHealth=math.huge; hum.Health=math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
        end
    end)
    LP.CharacterAdded:Connect(function(char) task.wait(0.3); apply(char) end)
    Notify("God Mode","Aktif!",3)
end)

-- ============================================================
-- AUTOFARM V2 (workspace detection + Skip Protocol)
-- ============================================================
local farmV2Active=false; local v2SkipMode="teleport"
local selectedV2 = {}
for _, cat in ipairs(CATEGORIES) do
    for _, name in ipairs(cat.list) do selectedV2[name]=false end
end

local function doOneCycleV2(nextCycle)
    if not farmV2Active then return end
    local h=HRP(); if not h then task.wait(1); nextCycle(); return end
    zeroVel(h); h.CFrame=TARGET_CF; task.wait(0.35)
    fireKick()
    -- Scan workspace > Debris > Model max 3 detik
    local matched=nil; local tStart=tick()
    repeat
        task.wait(0.08); if not farmV2Active then return end
        matched=scanWorkspaceDebris()
    until matched~=nil or (tick()-tStart)>3
    if not farmV2Active then return end
    -- Dapet yang kita mau → jalan biasa (analog disable, NO teleport)
    if matched and selectedV2[matched] then
        Notify("V2","Dapet: "..matched.." ✅",4)
        walkToTarget(function() return farmV2Active end, function() task.wait(0.1); nextCycle() end)
    else
        -- Skip Protocol
        if v2SkipMode=="teleport" then
            -- Teleport Drop: kena anti-cheat → brainrot ke-drop
            teleportDrop(function() return farmV2Active end, function() task.wait(0.1); nextCycle() end)
        else
            -- Walk Back: bunuh diri → respawn → ke target
            walkBackThenRespawn(function() return farmV2Active end, function() task.wait(0.1); nextCycle() end)
        end
    end
end

local function startLoopV2() if not farmV2Active then return end; doOneCycleV2(function() task.spawn(startLoopV2) end) end

Section(V2Tab.Page,"Skip Protocol")
SkipProtocolSelector(V2Tab.Page, function(mode) v2SkipMode=mode end)

Button(V2Tab.Page,"Set Safe Zone (posisi sekarang)",function()
    local h=HRP(); if h then SAFE_ZONE_CF=h.CFrame; Notify("Safe Zone","Posisi disimpen!",3) end
end)

Section(V2Tab.Page,"Pilih Brainrot per Rarity")
-- Brainrot checkboxes per category (multi-toggle)
for _, cat in ipairs(CATEGORIES) do
    -- Section header per rarity
    local catFrame=Instance.new("Frame"); catFrame.Size=UDim2.new(1,0,0,0)
    catFrame.AutomaticSize=Enum.AutomaticSize.Y; catFrame.BackgroundColor3=C.Elem
    catFrame.BorderSizePixel=0; catFrame.LayoutOrder=nO(); catFrame.Parent=V2Tab.Page; Corner(catFrame,8)
    local catLayout=Instance.new("UIListLayout"); catLayout.Padding=UDim.new(0,2); catLayout.Parent=catFrame
    local catPad=Instance.new("UIPadding"); catPad.PaddingLeft=UDim.new(0,6); catPad.PaddingRight=UDim.new(0,6)
    catPad.PaddingTop=UDim.new(0,4); catPad.PaddingBottom=UDim.new(0,6); catPad.Parent=catFrame

    local catTitle=Instance.new("TextLabel"); catTitle.Size=UDim2.new(1,0,0,20)
    catTitle.BackgroundTransparency=1; catTitle.Text=cat.name; catTitle.TextColor3=C.Accent
    catTitle.TextSize=11; catTitle.Font=Enum.Font.GothamBold; catTitle.TextXAlignment=Enum.TextXAlignment.Left; catTitle.Parent=catFrame

    for _, brainrotName in ipairs(cat.list) do
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,26); row.BackgroundTransparency=1; row.Parent=catFrame
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-36,1,0); lbl.Position=UDim2.new(0,4,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=brainrotName; lbl.TextColor3=C.Text; lbl.TextSize=11
        lbl.Font=Enum.Font.Gotham; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local cbBG=Instance.new("Frame"); cbBG.Size=UDim2.fromOffset(20,20); cbBG.Position=UDim2.new(1,-22,0.5,-10)
        cbBG.BackgroundColor3=C.TogOff; cbBG.BorderSizePixel=0; cbBG.Parent=row; Corner(cbBG,5)
        local cbCheck=Instance.new("TextLabel"); cbCheck.Size=UDim2.new(1,0,1,0)
        cbCheck.BackgroundTransparency=1; cbCheck.Text="✓"; cbCheck.TextColor3=C.White
        cbCheck.TextSize=13; cbCheck.Font=Enum.Font.GothamBold; cbCheck.Visible=false; cbCheck.Parent=cbBG
        local cbBtn=Instance.new("TextButton"); cbBtn.Size=UDim2.new(1,0,1,0)
        cbBtn.BackgroundTransparency=1; cbBtn.Text=""; cbBtn.Parent=row
        local checked=false
        cbBtn.MouseButton1Click:Connect(function()
            checked=not checked; selectedV2[brainrotName]=checked
            Tween(cbBG,TweenInfo.new(0.15),{BackgroundColor3=checked and C.Accent or C.TogOff})
            cbCheck.Visible=checked
        end)
    end
end

Section(V2Tab.Page,"Control")
Toggle(V2Tab.Page,"AutoFarm V2 ON/OFF",false,function(v)
    farmV2Active=v; if v then task.spawn(startLoopV2) else setAnalog(true) end
end)

-- ============================================================
-- AUTOTRAIN (UPGRADED — spam rev_TaviMishkal biar bonus 2x)
-- ============================================================
local autoTrainEnabled=false
local weightList={"Giant Gold Star Barbell","Golden Barbell","Bone Barbell","Copper Plate","Donut Barbell","Emerald Barbell","Heaven Plate","Ice Barbell","Iron Plate","Mega Golden Barbell","Neon Pulse","Stone Block","Wooden Stick"}
local weightSet={}
for _,w in ipairs(weightList) do weightSet[w]=true end

local function autoEquipWeight()
    local char=LP.Character; local bp=LP:FindFirstChild("Backpack"); if not char or not bp then return end
    for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") and not weightSet[obj.Name] then obj.Parent=bp end end
    for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") and weightSet[obj.Name] then return end end
    for _,tool in ipairs(bp:GetChildren()) do if weightSet[tool.Name] then tool.Parent=char; return end end
end

local walkDuringTrain = false

local function runAutoTrain()
    local taviRemote = nil
    pcall(function()
        taviRemote = RepStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("rev_TaviMishkal")
    end)

    -- Koneksi untuk keep player bisa jalan pas training
    local moveConn = RunService.Heartbeat:Connect(function()
        if not autoTrainEnabled or not walkDuringTrain then return end
        -- Keep TouchGui analog visible (bypass game disable)
        local tg = LP.PlayerGui:FindFirstChild("TouchGui")
        if tg then
            local f = tg:FindFirstChild("TouchControlFrame")
            if f and not f.Visible then f.Visible = true end
        end
        -- Reset WalkSpeed kalo game nge-zero-in
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed < 8 then
                hum.WalkSpeed = 16
            end
        end
    end)

    while autoTrainEnabled do
        autoEquipWeight()
        -- Spam rev_TaviMishkal → bikin bonus count 2x
        if taviRemote then
            pcall(function() taviRemote:FireServer() end)
            pcall(function() taviRemote:FireServer() end)
            pcall(function() taviRemote:FireServer() end)
        end
        -- Click bonus button
        pcall(function()
            local gui = LP.PlayerGui:FindFirstChild("KickUpgrades"); if not gui then return end
            local bonuses = {}
            for _, c in ipairs(gui:GetChildren()) do if c.Name == "Bonus" then bonuses[#bonuses+1] = c end end
            if #bonuses == 0 then return end
            local btn = bonuses[#bonuses]
            if firesignal then firesignal(btn.MouseButton1Click); firesignal(btn.Activated)
            else pcall(function() btn:SimulateClick() end) end
        end)
        task.wait(0.02)
    end

    moveConn:Disconnect()
    -- Kembaliin analog kalo walk during train di-off
    local tg = LP.PlayerGui:FindFirstChild("TouchGui")
    if tg then local f = tg:FindFirstChild("TouchControlFrame"); if f then f.Visible = true end end
end

Section(TrainTab.Page,"Auto Train")
Toggle(TrainTab.Page,"Auto Train + Bonus (2x spam)",false,function(v)
    autoTrainEnabled=v
    if v then
        task.spawn(runAutoTrain)
    else
        local char=LP.Character; local bp=LP:FindFirstChild("Backpack")
        if char and bp then for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") and weightSet[obj.Name] then obj.Parent=bp end end end
    end
end)
Toggle(TrainTab.Page,"Bisa Jalan Pas Training",false,function(v)
    walkDuringTrain=v
    if not v then
        -- Kembaliin state normal
        local char=LP.Character; if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=16 end
        local tg=LP.PlayerGui:FindFirstChild("TouchGui")
        if tg then local f=tg:FindFirstChild("TouchControlFrame"); if f then f.Visible=true end end
    end
end)

-- ============================================================
-- PLAYER TAB
-- ============================================================
local wsEnabled=false; local wsValue=16
local jpEnabled=false; local jpValue=50
local noclip=false; local infjump=false

Section(PlyrTab.Page,"WalkSpeed")
Toggle(PlyrTab.Page,"Enable WalkSpeed",false,function(v) wsEnabled=v end)
Slider(PlyrTab.Page,"WalkSpeed",16,150,16,1,function(v) wsValue=v end)

Section(PlyrTab.Page,"JumpPower")
Toggle(PlyrTab.Page,"Enable JumpPower",false,function(v) jpEnabled=v end)
Slider(PlyrTab.Page,"JumpPower",50,300,50,5,function(v) jpValue=v end)

Section(PlyrTab.Page,"Movement")
Toggle(PlyrTab.Page,"No Clip",false,function(v) noclip=v end)
Toggle(PlyrTab.Page,"Infinite Jump",false,function(v) infjump=v end)

RunService.RenderStepped:Connect(function()
    if not wsEnabled or farmV1 or farmV2Active then return end
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.WalkSpeed=wsValue
    if hum.MoveDirection.Magnitude>0 then
        hrp.Velocity=Vector3.new(hum.MoveDirection.X*wsValue,hrp.Velocity.Y,hum.MoveDirection.Z*wsValue)
    end
end)
RunService.RenderStepped:Connect(function()
    if not jpEnabled then return end
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.UseJumpPower=true; hum.JumpPower=jpValue end
end)
RunService.Stepped:Connect(function()
    if not noclip then return end
    local char=LP.Character; if not char then return end
    for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
end)
UserInputService.JumpRequest:Connect(function()
    if not infjump then return end
    local char=LP.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ============================================================
-- MISC TAB
-- ============================================================
Section(MiscTab.Page,"Server")
Button(MiscTab.Page,"Rejoin Server",function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)
end)
Section(MiscTab.Page,"UI")
Button(MiscTab.Page,"Destroy GUI",function() closeWindow(true) end)

-- Anti AFK
for _,v in pairs(getconnections(LP.Idled)) do v:Disable() end

-- READY
Notify("Faltix Hub","Klik logo merah kiri atas! 🔴",5)
print("FALTIX HUB LOADED | Workspace Detection | Skip Protocol Active")
