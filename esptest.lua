-- // ESP + Aimbot + Silent Aim + FOV (Nâng cấp đẹp)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ESP = {
    Enabled = true,
    Box = true,
    Line = true,
    Name = true,
    TeamColor = true
}

local Aimbot = {
    Enabled = false,
    Smoothness = 0.15,  -- Càng nhỏ càng ghim chặt
    FOV = 120
}

local SilentAim = {
    Enabled = false
}

local MenuVisible = true
local FOVCircle

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 380)
Frame.Position = UDim2.new(0, 20, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Title.Text = "ESP + Aimbot Menu"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Draggable
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.TextScaled = true
CloseButton.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1,0)
CloseCorner.Parent = CloseButton

-- Toggle Function
local function CreateToggle(text, yPos, defaultValue, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 0, 35)
    Toggle.Position = UDim2.new(0, 10, 0, yPos)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.Text = text .. ": ON"
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.TextScaled = true
    Toggle.Parent = Frame

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0,8)
    tc.Parent = Toggle

    local enabled = defaultValue
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = text .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
    return Toggle
end

-- FOV Label + Button adjust
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -20, 0, 30)
fovLabel.Position = UDim2.new(0, 10, 0, 320)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. Aimbot.FOV
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.TextScaled = true
fovLabel.Parent = Frame

CreateToggle("ESP", 50, true, function(v) ESP.Enabled = v end)
CreateToggle("Box", 95, true, function(v) ESP.Box = v end)
CreateToggle("Line", 140, true, function(v) ESP.Line = v end)
CreateToggle("Name", 185, true, function(v) ESP.Name = v end)
CreateToggle("Team Color", 230, true, function(v) ESP.TeamColor = v end)
CreateToggle("Aimbot (Head)", 275, false, function(v) Aimbot.Enabled = v end)
CreateToggle("Silent Aim (Head)", 320, false, function(v) SilentAim.Enabled = v end)

-- FOV Adjust
local function adjustFOV(delta)
    Aimbot.FOV = math.clamp(Aimbot.FOV + delta, 30, 500)
    fovLabel.Text = "FOV: " .. Aimbot.FOV
end

local fovMinus = Instance.new("TextButton")
fovMinus.Size = UDim2.new(0, 40, 0, 30)
fovMinus.Position = UDim2.new(0, 10, 0, 355)
fovMinus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovMinus.Text = "-"
fovMinus.TextScaled = true
fovMinus.Parent = Frame
fovMinus.MouseButton1Click:Connect(function() adjustFOV(-10) end)

local fovPlus = Instance.new("TextButton")
fovPlus.Size = UDim2.new(0, 40, 0, 30)
fovPlus.Position = UDim2.new(0, 170, 0, 355)
fovPlus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovPlus.Text = "+"
fovPlus.TextScaled = true
fovPlus.Parent = Frame
fovPlus.MouseButton1Click:Connect(function() adjustFOV(10) end)

-- Rounded Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Text = "ESP"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextScaled = true
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local RoundCorner = Instance.new("UICorner")
RoundCorner.CornerRadius = UDim.new(1, 0)
RoundCorner.Parent = ToggleButton

CloseButton.MouseButton1Click:Connect(function() 
    MenuVisible = not MenuVisible
    Frame.Visible = MenuVisible
    ToggleButton.Visible = not MenuVisible
end)
ToggleButton.MouseButton1Click:Connect(function() 
    MenuVisible = not MenuVisible
    Frame.Visible = MenuVisible
    ToggleButton.Visible = not MenuVisible
end)

-- FOV Circle
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Corner Box Drawing
local function CreateCornerBox()
    local parts = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Transparency = 1
        table.insert(parts, line)
    end
    return parts
end

local function UpdateCornerBox(boxParts, topLeft, topRight, bottomRight, bottomLeft, color)
    local positions = {topLeft, topRight, bottomRight, bottomLeft}
    for i = 1, 4 do
        local p1 = positions[i]
        local p2 = positions[i % 4 + 1]
        boxParts[i*2-1].From = p1
        boxParts[i*2-1].To = p2
        boxParts[i*2-1].Color = color
        boxParts[i*2-1].Visible = true
    end
end

local Connections = {}

local function GetClosestPlayer()
    local closest, dist = nil, Aimbot.FOV
    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local headPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local magnitude = (screenPos - mousePos).Magnitude
                if magnitude < dist then
                    dist = magnitude
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function AddESP(plr)
    if plr == LocalPlayer then return end
    
    local BoxParts = CreateCornerBox()
    local Line = Drawing.new("Line")
    Line.Thickness = 2
    Line.Transparency = 1
    
    local Name = Drawing.new("Text")
    Name.Size = 16
    Name.Center = true
    Name.Outline = true
    Name.Transparency = 1

    local function Update()
        if not ESP.Enabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, part in ipairs(BoxParts) do part.Visible = false end
            Line.Visible = false
            Name.Visible = false
            return
        end

        local Root = plr.Character.HumanoidRootPart
        local Head = plr.Character:FindFirstChild("Head")
        local Humanoid = plr.Character:FindFirstChild("Humanoid")
        if not Head then return end

        local Vector, OnScreen = Camera:WorldToViewportPoint(Root.Position)
        if not OnScreen then
            for _, part in ipairs(BoxParts) do part.Visible = false end
            Line.Visible = false
            Name.Visible = false
            return
        end

        local HeadPos = Camera:WorldToViewportPoint(Head.Position)
        local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0,3,0))

        local BoxHeight = (HeadPos.Y - LegPos.Y) * 1.3
        local BoxWidth = BoxHeight / 2

        local tl = Vector2.new(Vector.X - BoxWidth/2, HeadPos.Y - BoxHeight/2)
        local tr = Vector2.new(Vector.X + BoxWidth/2, HeadPos.Y - BoxHeight/2)
        local br = Vector2.new(Vector.X + BoxWidth/2, HeadPos.Y + BoxHeight/2)
        local bl = Vector2.new(Vector.X - BoxWidth/2, HeadPos.Y + BoxHeight/2)

        local Color = ESP.TeamColor and (plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255,0,0)) or Color3.fromRGB(255,0,0)

        if ESP.Box then
            UpdateCornerBox(BoxParts, tl, tr, br, bl, Color)
        else
            for _, part in ipairs(BoxParts) do part.Visible = false end
        end

        if ESP.Line then
            Line.Visible = true
            Line.Color = Color
            Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            Line.To = Vector2.new(Vector.X, Vector.Y)
        else
            Line.Visible = false
        end

        if ESP.Name and Humanoid then
            Name.Visible = true
            Name.Text = plr.Name .. " [" .. math.floor(Humanoid.Health) .. "]"
            Name.Position = Vector2.new(Vector.X, HeadPos.Y - 30)
            Name.Color = Color
        else
            Name.Visible = false
        end

        -- Aimbot
        if Aimbot.Enabled then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetPos = Camera:WorldToViewportPoint(target.Character.Head.Position)
                local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local direction = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * Aimbot.Smoothness
                mousemoverel(direction.X, direction.Y)
            end
        end
    end

    table.insert(Connections, RunService.RenderStepped:Connect(Update))

    -- Silent Aim (simple hook - works in many games)
    if SilentAim.Enabled then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" and self.Name:lower():find("bullet") or self.Name:lower():find("shoot") then
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    args[1] = target.Character.Head.Position + Vector3.new(0,0.1,0)  -- slight offset for head
                end
            end
            return oldNamecall(self, unpack(args))
        end)
        setreadonly(mt, true)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do AddESP(plr) end
Players.PlayerAdded:Connect(AddESP)

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = Aimbot.FOV
    FOVCircle.Visible = true
end)

print("ESP + Aimbot + Silent Aim loaded! Kéo title để di chuyển menu. [made by seraph]")