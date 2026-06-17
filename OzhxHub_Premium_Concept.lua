--[[
Ozhx Hub - Premium UI Concept
Features planned:
- Draggable floating logo
- Main window with sidebar tabs
- Main / Player / Teleport / Utility / Info
- WalkSpeed slider
- JumpPower slider
- Infinity Jump
- Noclip
- Fly placeholder
- Teleport dropdown (Carrot, Meal, Gasoline, Tree)
- Notifications
- Watermark
- Active feature tracker
- Minimize / Destroy
- Smooth animations (TweenService)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

-- CONFIG
local Theme = {
    Cyan = Color3.fromRGB(0,229,255),
    Purple = Color3.fromRGB(106,92,255),
    Violet = Color3.fromRGB(168,85,247)
}

-- Floating Logo (draggable)
-- Click = Open UI
-- Double Click = Minimize

-- Window Layout

-- ╭──────────────────────────────────╮
-- │ Ozhx Hub                    _  X │
-- ├────────────┬─────────────────────┤
-- │ 🏠 Main    │                     │
-- │ 👤 Player  │     CONTENT         │
-- │ 📍 TP      │                     │
-- │ ⚙️ Utility │                     │
-- │ ℹ️ Info    │                     │
-- ├────────────┴─────────────────────┤
-- │ FPS | Ping | Version            │
-- ╰──────────────────────────────────╯

-- MAIN TAB
-- Welcome
-- FPS Counter
-- Ping Counter
-- Server Time

-- PLAYER TAB
-- WalkSpeed Slider (16-200)
-- JumpPower Slider
-- Infinity Jump Toggle
-- Noclip Toggle
-- Fly Toggle

-- TELEPORT TAB
-- Dropdown:
-- Carrot
-- Meal
-- Gasoline
-- Tree

-- UTILITY TAB
-- Anti AFK
-- Rejoin
-- Server Hop
-- FPS Boost
-- Destroy UI

-- INFO TAB
-- Version
-- Credits

print("Ozhx Hub Premium Template Loaded")
