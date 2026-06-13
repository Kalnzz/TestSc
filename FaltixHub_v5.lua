-- Faltix Hub v5 | Custom UI
-- Powered By Attala

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FaltixHub") then PlayerGui:FindFirstChild("FaltixHub"):Destroy() end

local function Tween(obj, t, props) TweenService:Create(obj, t, props):Play() end
local function Corner(p, r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p end

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
    MinGray  = Color3.fromRGB(36,36,52),
}

-- SCREENGUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name="FaltixHub"; ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset=true; ScreenGui.Parent=PlayerGui

-- SHADOW
local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint=Vector2.new(0.5,0.5); Shadow.Size=UDim2.fromOffset(0,0)
Shadow.Position=UDim2.new(0.5,0,0.5,8); Shadow.BackgroundTransparency=1
Shadow.ZIndex=0; Shadow.Image="rbxassetid://6014261993"
Shadow.ImageColor3=Color3.new(0,0,0); Shadow.ImageTransparency=0.45
Shadow.ScaleType=Enum.ScaleType.Slice; Shadow.SliceCenter=Rect.new(49,49,450,450)
Shadow.Visible=false; Shadow.Parent=ScreenGui

-- MAIN WINDOW (hidden by default)
local Window = Instance.new("Frame")
Window.Name="Window"; Window.AnchorPoint=Vector2.new(0.5,0.5)
Window.Size=UDim2.fromOffset(0,0); Window.Position=UDim2.new(0.5,0,0.5,0)
Window.BackgroundColor3=C.BG; Window.BorderSizePixel=0
Window.Visible=false; Window.Parent=ScreenGui; Corner(Window,12)

-- LOGO BUTTON (always visible — click to toggle window)
local LogoHolder = Instance.new("Frame")
LogoHolder.Size=UDim2.fromOffset(46,46); LogoHolder.Position=UDim2.new(0,14,0,14)
LogoHolder.BackgroundColor3=C.Sidebar; LogoHolder.BorderSizePixel=0; LogoHolder.ZIndex=20
LogoHolder.Parent=ScreenGui; Corner(LogoHolder,10)

local LogoPulse = Instance.new("Frame")
LogoPulse.Size=UDim2.new(1,0,1,0); LogoPulse.BackgroundColor3=C.Accent
LogoPulse.BackgroundTransparency=0.85; LogoPulse.BorderSizePixel=0; LogoPulse.ZIndex=19
LogoPulse.Parent=LogoHolder; Corner(LogoPulse,10)

local LogoImg = Instance.new("ImageButton")
LogoImg.Size=UDim2.fromOffset(30,30); LogoImg.Position=UDim2.new(0.5,-15,0.5,-15)
LogoImg.BackgroundTransparency=1; LogoImg.Image="rbxassetid://110127950553563"
LogoImg.ZIndex=21; LogoImg.Parent=LogoHolder

-- Pulse animation on logo
task.spawn(function()
    while true do
        Tween(LogoPulse, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency=0.7})
        task.wait(1)
        Tween(LogoPulse, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency=0.95})
        task.wait(1)
    end
end)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size=UDim2.new(1,0,0,42); TopBar.BackgroundColor3=C.TopBar
TopBar.BorderSizePixel=0; TopBar.ZIndex=5; TopBar.Parent=Window; Corner(TopBar,12)
local TBFix=Instance.new("Frame"); TBFix.Size=UDim2.new(1,0,0,12)
TBFix.Position=UDim2.new(0,0,1,-12); TBFix.BackgroundColor3=C.TopBar
TBFix.BorderSizePixel=0; TBFix.ZIndex=5; TBFix.Parent=TopBar
local TBGrad=Instance.new("UIGradient")
TBGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(22,22,33)),ColorSequenceKeypoint.new(1,Color3.fromRGB(11,11,17))})
TBGrad.Rotation=90; TBGrad.Parent=TopBar

local TitleLbl=Instance.new("TextLabel"); TitleLbl.Size=UDim2.new(0,120,0,17)
TitleLbl.Position=UDim2.new(0,12,0,8); TitleLbl.BackgroundTransparency=1
TitleLbl.Text="Faltix Hub"; TitleLbl.TextColor3=C.Text
TitleLbl.TextSize=14; TitleLbl.Font=Enum.Font.GothamBold
TitleLbl.TextXAlignment=Enum.TextXAlignment.Left; TitleLbl.ZIndex=6; TitleLbl.Parent=TopBar

local SubLbl=Instance.new("TextLabel"); SubLbl.Size=UDim2.new(0,140,0,12)
SubLbl.Position=UDim2.new(0,12,0,25); SubLbl.BackgroundTransparency=1
SubLbl.Text="Powered By Attala"; SubLbl.TextColor3=C.TextDim
SubLbl.TextSize=10; SubLbl.Font=Enum.Font.Gotham
SubLbl.TextXAlignment=Enum.TextXAlignment.Left; SubLbl.ZIndex=6; SubLbl.Parent=TopBar

local AccentDot=Instance.new("Frame"); AccentDot.Size=UDim2.fromOffset(6,6)
AccentDot.Position=UDim2.new(1,-18,0.5,-3); AccentDot.BackgroundColor3=C.Accent
AccentDot.BorderSizePixel=0; AccentDot.ZIndex=6; AccentDot.Parent=TopBar; Corner(AccentDot,3)

local CloseBtn=Instance.new("TextButton"); CloseBtn.Size=UDim2.fromOffset(24,24)
CloseBtn.Position=UDim2.new(1,-32,0.5,-12); CloseBtn.BackgroundColor3=C.CloseRed
CloseBtn.Text="×"; CloseBtn.TextColor3=C.White; CloseBtn.TextSize=16
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.BorderSizePixel=0
CloseBtn.AutoButtonColor=false; CloseBtn.ZIndex=6; CloseBtn.Parent=TopBar; Corner(CloseBtn,6)

-- SIDEBAR
local Sidebar=Instance.new("Frame"); Sidebar.Name="Sidebar"
Sidebar.Size=UDim2.new(0,138,1,-42); Sidebar.Position=UDim2.new(0,0,0,42)
Sidebar.BackgroundColor3=C.Sidebar; Sidebar.BorderSizePixel=0; Sidebar.Parent=Window; Corner(Sidebar,12)
local SBT=Instance.new("Frame"); SBT.Size=UDim2.new(1,0,0,12); SBT.BackgroundColor3=C.Sidebar
SBT.BorderSizePixel=0; SBT.ZIndex=2; SBT.Parent=Sidebar
local SBR=Instance.new("Frame"); SBR.Size=UDim2.new(0,12,1,0); SBR.Position=UDim2.new(1,-12,0,0)
SBR.BackgroundColor3=C.Sidebar; SBR.BorderSizePixel=0; SBR.ZIndex=2; SBR.Parent=Sidebar

local TabList=Instance.new("ScrollingFrame"); TabList.Size=UDim2.new(1,-8,1,-14)
TabList.Position=UDim2.new(0,4,0,10); TabList.BackgroundTransparency=1
TabList.ScrollBarThickness=0; TabList.BorderSizePixel=0
TabList.CanvasSize=UDim2.new(0,0,0,0); TabList.AutomaticCanvasSize=Enum.AutomaticSize.Y
TabList.Parent=Sidebar
local TLL=Instance.new("UIListLayout"); TLL.Padding=UDim.new(0,4)
TLL.SortOrder=Enum.SortOrder.LayoutOrder; TLL.Parent=TabList

-- CONTENT AREA
local SepLine=Instance.new("Frame"); SepLine.Size=UDim2.new(0,1,1,-42)
SepLine.Position=UDim2.new(0,138,0,42); SepLine.BackgroundColor3=C.Sep
SepLine.BorderSizePixel=0; SepLine.Parent=Window

local ContentArea=Instance.new("Frame"); ContentArea.Name="ContentArea"
ContentArea.Size=UDim2.new(1,-140,1,-44); ContentArea.Position=UDim2.new(0,140,0,44)
ContentArea.BackgroundTransparency=1; ContentArea.ClipsDescendants=true; ContentArea.Parent=Window

-- DRAGGING
local isDragging,isDraggingSlider=false,false
local dragStart,dragStartPos
local baseWindowPos=UDim2.new(0.5,0,0.5,0)

TopBar.InputBegan:Connect(function(input)
    if isDraggingSlider then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        isDragging=true; dragStart=input.Position; dragStartPos=baseWindowPos
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then isDragging=false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=input.Position-dragStart
        baseWindowPos=UDim2.new(dragStartPos.X.Scale,dragStartPos.X.Offset+d.X,dragStartPos.Y.Scale,dragStartPos.Y.Offset+d.Y)
    end
end)

-- FLOAT EFFECT
local floatT=0
RunService.Heartbeat:Connect(function(dt)
    if not Window.Visible then return end
    floatT=floatT+dt
    local fy=isDragging and 0 or (math.sin(floatT*0.7)*2)
    Window.Position=UDim2.new(baseWindowPos.X.Scale,baseWindowPos.X.Offset,baseWindowPos.Y.Scale,baseWindowPos.Y.Offset+fy)
    Shadow.Position=UDim2.new(Window.Position.X.Scale,Window.Position.X.Offset,Window.Position.Y.Scale,Window.Position.Y.Offset+8)
end)

-- LOGO TOGGLE
local windowOpen=false
local WIN_SIZE=UDim2.fromOffset(520,370)
local SHD_SIZE=UDim2.fromOffset(554,404)

local function openWindow()
    windowOpen=true
    Window.Size=UDim2.fromOffset(0,0); Window.Visible=true
    Shadow.Size=UDim2.fromOffset(0,0); Shadow.Visible=true
    Tween(Window,TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=WIN_SIZE})
    Tween(Shadow,TweenInfo.new(0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=SHD_SIZE})
    Tween(LogoHolder,TweenInfo.new(0.2),{BackgroundColor3=C.Accent})
end

local function closeWindow(destroy)
    windowOpen=false
    local ti=TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    Tween(Window,ti,{Size=UDim2.fromOffset(0,0)})
    Tween(Shadow,ti,{Size=UDim2.fromOffset(0,0)})
    Tween(LogoHolder,TweenInfo.new(0.2),{BackgroundColor3=C.Sidebar})
    task.delay(0.25,function()
        Window.Visible=false; Shadow.Visible=false
        if destroy then ScreenGui:Destroy() end
    end)
end

LogoImg.MouseButton1Click:Connect(function()
    if windowOpen then closeWindow(false) else openWindow() end
end)

CloseBtn.MouseButton1Click:Connect(function() closeWindow(true) end)

-- NOTIFICATIONS
local NH=Instance.new("Frame"); NH.Size=UDim2.new(0,260,1,0)
NH.Position=UDim2.new(1,-270,0,0); NH.BackgroundTransparency=1; NH.Parent=ScreenGui
local NL=Instance.new("UIListLayout"); NL.Padding=UDim.new(0,8)
NL.VerticalAlignment=Enum.VerticalAlignment.Bottom; NL.FillDirection=Enum.FillDirection.Vertical
NL.SortOrder=Enum.SortOrder.LayoutOrder; NL.Parent=NH
local NP=Instance.new("UIPadding"); NP.PaddingBottom=UDim.new(0,16); NP.PaddingRight=UDim.new(0,8); NP.Parent=NH

local function Notify(title,body,dur)
    dur=dur or 3
    local nf=Instance.new("Frame"); nf.Size=UDim2.new(1,0,0,58)
    nf.BackgroundColor3=C.Sidebar; nf.BorderSizePixel=0; nf.BackgroundTransparency=1; nf.Parent=NH; Corner(nf,9)
    local na=Instance.new("Frame"); na.Size=UDim2.fromOffset(3,32); na.Position=UDim2.new(0,0,0.5,-16)
    na.BackgroundColor3=C.Accent; na.BorderSizePixel=0; na.BackgroundTransparency=1; Corner(na,2); na.Parent=nf
    local nt=Instance.new("TextLabel"); nt.Size=UDim2.new(1,-16,0,19); nt.Position=UDim2.new(0,10,0,9)
    nt.BackgroundTransparency=1; nt.Text=title; nt.TextColor3=C.Text; nt.TextSize=13
    nt.Font=Enum.Font.GothamBold; nt.TextXAlignment=Enum.TextXAlignment.Left; nt.TextTransparency=1; nt.Parent=nf
    local nb=Instance.new("TextLabel"); nb.Size=UDim2.new(1,-16,0,15); nb.Position=UDim2.new(0,10,0,31)
    nb.BackgroundTransparency=1; nb.Text=body; nb.TextColor3=C.TextDim; nb.TextSize=11
    nb.Font=Enum.Font.Gotham; nb.TextXAlignment=Enum.TextXAlignment.Left; nb.TextTransparency=1; nb.Parent=nf
    local tiIn=TweenInfo.new(0.28,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
    local tiOut=TweenInfo.new(0.22,Enum.EasingStyle.Quart)
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
        Tween(ActiveTab.Btn,TweenInfo.new(0.18),{BackgroundColor3=C.TabIn})
        Tween(ActiveTab.TLbl,TweenInfo.new(0.18),{TextColor3=C.TextDim})
        Tween(ActiveTab.Ind,TweenInfo.new(0.18),{BackgroundTransparency=1})
        ActiveTab.Page.Visible=false
    end
    Tween(tab.Btn,TweenInfo.new(0.18),{BackgroundColor3=C.Accent})
    Tween(tab.TLbl,TweenInfo.new(0.18),{TextColor3=C.White})
    Tween(tab.Ind,TweenInfo.new(0.18),{BackgroundTransparency=0})
    -- slide in animation
    tab.Page.Visible=true; tab.Page.Position=UDim2.new(0.08,0,0,0)
    Tween(tab.Page,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,0)})
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
local eO=0
local function nO() eO=eO+1; return eO end

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

-- ==================================================
-- GAME SETUP
-- ==================================================
local State = {
    Buy=false,Upgrade=false,Fruit=false,Rebirth=false,
    Evolve=false,PowerLevel=false,CashDrop=false,
    NoClip=false,Fly=false,WalkSpeed=16,JumpPower=50,
}

local function GetHRP()
    local char=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end
local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function GetHum()
    local char=GetChar()
    return char:FindFirstChildOfClass("Humanoid")
end

local function FindTycoon()
    for _,v in ipairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:match("Tycoon") then
            local o=v:FindFirstChild("Owner")
            if o and o.Value==LocalPlayer then return v end
        end
    end
end

local Tycoon=FindTycoon()
if not Tycoon then
    task.defer(function() Notify("Error","Tycoon tidak ditemukan!",5) end)
    return
end

-- AUTO BUY (max speed)
local Btns={}
local function RefreshBtns()
    table.clear(Btns)
    local p=Tycoon:FindFirstChild("Purchases"); if not p then return end
    for _,obj in ipairs(p:GetDescendants()) do
        if obj:IsA("Model") and obj:GetAttribute("Shown") and not obj:GetAttribute("Purchased") then
            local part=obj:FindFirstChild("Button")
            if part and part:IsA("BasePart") then table.insert(Btns,part) end
        end
    end
end
local function Touch(part)
    pcall(function()
        local hrp=GetHRP(); firetouchinterest(hrp,part,0); task.wait(); firetouchinterest(hrp,part,1)
    end)
end
task.spawn(function()
    while true do
        if State.Buy then RefreshBtns(); for _,b in ipairs(Btns) do if b and b.Parent then Touch(b) end end end
        task.wait()
    end
end)

-- AUTO UPGRADE (max speed)
local upR={},upLv={},lastSc=0
local function refUp()
    upR={};upLv={}; local p=Tycoon:FindFirstChild("Purchases"); if not p then return end
    for _,obj in ipairs(p:GetDescendants()) do
        if obj:IsA("RemoteFunction") and obj.Name=="Upgrade" then upR[#upR+1]=obj end
    end
end
task.spawn(function()
    while true do
        if State.Upgrade then
            if tick()-lastSc>3 then refUp(); lastSc=tick() end
            for _,rem in ipairs(upR) do
                if rem.Parent then
                    local lvl=(upLv[rem] or 0)+1
                    while lvl<=100 do
                        local ok,res=pcall(function() return rem:InvokeServer(lvl) end)
                        if not ok or res==false then break end; upLv[rem]=lvl; lvl=lvl+1
                    end
                end
            end
        end
        task.wait()
    end
end)

-- POWER LEVEL (max speed)
task.spawn(function()
    while true do
        if State.PowerLevel then
            local r=Tycoon:FindFirstChild("Remotes"); local rf=r and r:FindFirstChild("UpgradePowerLevel")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
        task.wait()
    end
end)

-- REBIRTH
local NS={thousand=1e3,million=1e6,billion=1e9,trillion=1e12,quadrillion=1e15,k=1e3,m=1e6,b=1e9,t=1e12}
local function parseNum(s)
    if not s then return nil end; s=tostring(s):gsub(",",""):lower()
    local v=tonumber(s:match("[%d%.]+"));if not v then return nil end
    local w=s:match("[%d%.%s]+([a-z]+)");if w and NS[w] then v=v*NS[w] end; return v
end
local function readQ(name)
    local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui"); local r=pg and pg:FindFirstChild("Rebirth")
    local im=r and r:FindFirstChild("InvestorsMenu"); local body=im and im:FindFirstChild("Body")
    local frame=body and body:FindFirstChild(name); local q=frame and frame:FindFirstChild("Quantity")
    return q and parseNum(q.Text)
end
local rebirthBusy=false
task.spawn(function()
    while true do
        if State.Rebirth and not rebirthBusy then
            local rems=Tycoon:FindFirstChild("Remotes"); local remote=rems and rems:FindFirstChild("Rebirth")
            local pot=readQ("Potential"); local cur=readQ("Amount") or 0
            if remote and pot and pot>=1 and pot>=cur then
                rebirthBusy=true
                pcall(function()
                    local done=false; local sig=rems:FindFirstChild("Rebirthed"); local conn
                    if sig and sig:IsA("RemoteEvent") then conn=sig.OnClientEvent:Connect(function() done=true end) end
                    remote:InvokeServer(); local t=0
                    while not done and t<8 do task.wait(0.1); t=t+0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(2); rebirthBusy=false
            end
        end
        task.wait(0.5)
    end
end)

-- EVOLVE
local evolveBusy=false
task.spawn(function()
    while true do
        if State.Evolve and not evolveBusy then
            local rems=Tycoon:FindFirstChild("Remotes"); local remote=rems and rems:FindFirstChild("Evolve")
            local pg=LocalPlayer:FindFirstChildOfClass("PlayerGui"); local r=pg and pg:FindFirstChild("Rebirth")
            local em=r and r:FindFirstChild("EvolutionMenu"); local body=em and em:FindFirstChild("Body")
            local p=body and body:FindFirstChild("Progress"); local pct=p and tonumber(tostring(p.Text):match("[%d%.]+"))
            if remote and pct and pct>=100 then
                evolveBusy=true
                pcall(function()
                    local done=false; local sig=rems:FindFirstChild("Evolved"); local conn
                    if sig and sig:IsA("RemoteEvent") then conn=sig.OnClientEvent:Connect(function() done=true end) end
                    remote:InvokeServer(); local t=0
                    while not done and t<8 do task.wait(0.1); t=t+0.1 end
                    if conn then conn:Disconnect() end
                end)
                task.wait(2); evolveBusy=false
            end
        end
        task.wait(0.5)
    end
end)

-- AUTO FRUIT
local Trees={}
local function addTree(obj) if obj:IsA("Model") and obj.Name=="LemonTree" and not table.find(Trees,obj) then table.insert(Trees,obj) end end
local function remTree(obj) local i=table.find(Trees,obj); if i then table.remove(Trees,i) end end
for _,v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree); workspace.DescendantRemoving:Connect(remTree)
local function collectFruit(tree)
    for _,obj in ipairs(tree:GetDescendants()) do if obj:IsA("BasePart") then obj.CanCollide=false end end
    pcall(function()
        local hrp=GetHRP(); hrp.CFrame=tree:GetPivot()+Vector3.new(0,5,0)
        for _,obj in ipairs(tree:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name=="Fruit" then
                local cp=obj:FindFirstChild("ClickPart"); if cp then
                    local det=cp:FindFirstChildOfClass("ClickDetector"); if det then task.wait(0.4); pcall(function() fireclickdetector(det) end) end
                end
            end
        end
    end)
end
task.spawn(function()
    while true do
        if State.Fruit then for _,tree in ipairs(Trees) do if not State.Fruit then break end; if tree and tree.Parent then pcall(function() collectFruit(tree) end) end end end
        task.wait(0.1)
    end
end)

-- CASHDROP (FIXED — workspace > CashDrop folder > CashDrop items)
task.spawn(function()
    while true do
        if State.CashDrop then
            pcall(function()
                local hrp=GetHRP(); local orig=hrp.CFrame
                local df=workspace:FindFirstChild("CashDrop")
                if df then
                    local drops={}
                    for _,v in ipairs(df:GetChildren()) do if v.Name=="CashDrop" then table.insert(drops,v) end end
                    for _,drop in ipairs(drops) do
                        if drop and drop.Parent then
                            pcall(function()
                                local pos
                                if drop:IsA("BasePart") then pos=drop.Position
                                elseif drop:IsA("Model") then
                                    local pp=drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")
                                    if pp then pos=pp.Position end
                                end
                                if pos then hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0)); task.wait(0.15) end
                            end)
                        end
                    end
                    task.wait(0.05); hrp.CFrame=orig
                end
            end)
        end
        task.wait()
    end
end)

-- SEWER
local function tp(hrp,part) pcall(function() firetouchinterest(hrp,part,0); firetouchinterest(hrp,part,1) end) end
local function doSewer()
    return pcall(function()
        local hrp=GetHRP(); local map=workspace:FindFirstChild("Map"); local sewer=map and map:FindFirstChild("Sewer")
        if not sewer then error("no sewer") end
        for _,o in ipairs(sewer:GetDescendants()) do if o:IsA("BasePart") and string.lower(o.Name):find("lever") then tp(hrp,o) end end
        for _,fn in ipairs({"CashVine","SewerAlien"}) do local fld=sewer:FindFirstChild(fn); if fld then for _,o in ipairs(fld:GetDescendants()) do if o:IsA("BasePart") and (o.Name=="VineKey" or o.Name=="UFOKey") then tp(hrp,o) end end end end
        task.wait(0.3)
        local cv=sewer:FindFirstChild("CashVine")
        if cv then
            local vd=cv:FindFirstChild("VineDoor"); if vd then for _,o in ipairs(vd:GetDescendants()) do if o:IsA("BasePart") then tp(hrp,o) end end end
            task.wait(0.3); local vm=cv:FindFirstChild("CashVine"); if vm then pcall(function() hrp.CFrame=vm:GetPivot()+Vector3.new(0,3,0) end); task.wait(0.2); for _,o in ipairs(vm:GetDescendants()) do if o:IsA("BasePart") then tp(hrp,o) end end end
        end
    end)
end

-- NOCLIP
local noclipConn
task.spawn(function()
    while true do
        if State.NoClip then
            local char=LocalPlayer.Character
            if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=false end end end
        end
        task.wait()
    end
end)

-- FLY
local flyConn,flyBV,flyBG

local function startFly()
    local char=LocalPlayer.Character; if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    flyBV=Instance.new("BodyVelocity"); flyBV.Velocity=Vector3.new(0,0,0)
    flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Parent=hrp
    flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=9e4; flyBG.Parent=hrp
    local spd=60
    flyConn=RunService.Heartbeat:Connect(function()
        if not State.Fly then return end
        local cam=workspace.CurrentCamera; local dir=Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
        flyBV.Velocity=dir.Magnitude>0 and dir.Unit*spd or Vector3.new(0,0,0)
        flyBG.CFrame=cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBV then flyBV:Destroy(); flyBV=nil end
    if flyBG then flyBG:Destroy(); flyBG=nil end
end

-- WALKSPEED + JUMP persistent
task.spawn(function()
    while true do
        local hum=GetHum()
        if hum then
            if State.WalkSpeed~=16 then hum.WalkSpeed=State.WalkSpeed end
            if State.JumpPower~=50 then hum.JumpPower=State.JumpPower end
        end
        task.wait(0.5)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.Fly then startFly() end
end)

-- ==================================================
-- BUILD TABS
-- ==================================================
local MainTab   = CreateTab("Main")
local PlayerTab = CreateTab("Player")
local SewerTab  = CreateTab("Sewer")
local MiscTab   = CreateTab("Misc")

-- MAIN TAB
Section(MainTab.Page,"Auto Features")
Toggle(MainTab.Page,"Auto Buy",         false,function(v) State.Buy=v end)
Toggle(MainTab.Page,"Auto Upgrade",     false,function(v) State.Upgrade=v end)
Toggle(MainTab.Page,"Auto Fruit",       false,function(v) State.Fruit=v end)
Toggle(MainTab.Page,"Auto Rebirth",     false,function(v) State.Rebirth=v end)
Toggle(MainTab.Page,"Auto Evolve",      false,function(v) State.Evolve=v end)
Toggle(MainTab.Page,"Auto Power Level", false,function(v) State.PowerLevel=v end)
Toggle(MainTab.Page,"Auto CashDrop",    false,function(v) State.CashDrop=v end)

-- PLAYER TAB
Section(PlayerTab.Page,"Movement")
Toggle(PlayerTab.Page,"No Clip",false,function(v)
    State.NoClip=v
    if not v then
        local char=LocalPlayer.Character
        if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)
Toggle(PlayerTab.Page,"Fly (WASD + Space/Ctrl)",false,function(v)
    State.Fly=v
    if v then startFly() else stopFly() end
end)
Section(PlayerTab.Page,"Stats")
Slider(PlayerTab.Page,"Walk Speed",16,250,16,1,function(v)
    State.WalkSpeed=v; local hum=GetHum(); if hum then hum.WalkSpeed=v end
end)
Slider(PlayerTab.Page,"Jump Power",50,500,50,10,function(v)
    State.JumpPower=v; local hum=GetHum(); if hum then hum.JumpPower=v end
end)

-- SEWER TAB
Section(SewerTab.Page,"Sewer Actions")
Button(SewerTab.Page,"Sewer Run",function()
    task.spawn(function()
        local ok=doSewer(); Notify("Sewer Run",ok and "Berhasil!" or "Sewer tidak ditemukan!",3)
    end)
end)
Button(SewerTab.Page,"Teleport to Alien",function()
    pcall(function() GetHRP().CFrame=CFrame.new(-42,-41,180) end)
    Notify("Teleport","Menuju Sewer Alien!",3)
end)

-- MISC TAB
Section(MiscTab.Page,"Controls")
Button(MiscTab.Page,"Emergency Stop",function()
    State.Buy=false;State.Upgrade=false;State.Fruit=false
    State.Rebirth=false;State.Evolve=false;State.PowerLevel=false;State.CashDrop=false
    State.NoClip=false;State.Fly=false;stopFly()
    Notify("Stop","Semua fitur dimatikan!",3)
end)
Button(MiscTab.Page,"Destroy GUI",function()
    closeWindow(true)
end)

ActivateTab(MainTab)
task.defer(function() Notify("Faltix Hub","Powered By Attala — Ready!",4) end)
