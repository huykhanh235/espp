-- // ESP Script - KhanhHuy Edition - Menu Đẹp + Nhiều Nâng Cấp
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
    TeamColor = true,
    Skeleton = true,
    Distance = true,
    HealthBar = true
}

local MenuVisible = true

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhanhHuy_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// Main Menu Frame - Giao diện đẹp hơn
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 340)
Frame.Position = UDim2.new(0, 30, 0.5, -170)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))
}
UIGradient.Parent = Frame

-- Title Bar đẹp
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 220)
Title.Text = "KhanhHuy ESP"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
}
TitleGradient.Parent = Title

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Kéo thả Menu
local dragging = false
local dragStart
local startPos

local function updateDrag(input)
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -38, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1,0)
CloseCorner.Parent = CloseButton

-- Toggle buttons đẹp hơn
local function CreateToggle(text, yPos, defaultValue, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -24, 0, 38)
    Toggle.Position = UDim2.new(0, 12, 0, yPos)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Toggle.Text = "  " .. text .. ": ON"
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.TextScaled = true
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.Font = Enum.Font.GothamSemibold
    Toggle.Parent = Frame

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0,8)
    tc.Parent = Toggle

    local enabled = defaultValue
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = "  " .. text .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
    return Toggle
end

CreateToggle("ESP", 55, true, function(v) ESP.Enabled = v end)
CreateToggle("Box", 100, true, function(v) ESP.Box = v end)
CreateToggle("Skeleton", 145, true, function(v) ESP.Skeleton = v end)
CreateToggle("Line", 190, true, function(v) ESP.Line = v end)
CreateToggle("Name", 235, true, function(v) ESP.Name = v end)
CreateToggle("Distance", 280, true, function(v) ESP.Distance = v end)
CreateToggle("HealthBar", 325, true, function(v) ESP.HealthBar = v end)
CreateToggle("Team Color", 370, true, function(v) ESP.TeamColor = v end)  -- menu cao hơn 1 chút

--// NÚT TRÒN NHỎ (kéo thả)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 58, 0, 58)
ToggleButton.Position = UDim2.new(0, 30, 0.5, -30)
ToggleButton.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
ToggleButton.Text = "KH"
ToggleButton.TextColor3 = Color3.fromRGB(0, 200, 255)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local RoundCorner = Instance.new("UICorner")
RoundCorner.CornerRadius = UDim.new(1, 0)
RoundCorner.Parent = ToggleButton

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3.5
Stroke.Color = Color3.fromRGB(0, 180, 255)
Stroke.Parent = ToggleButton

-- Kéo thả nút tròn
local btnDragging = false
local btnDragStart
local btnStartPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = ToggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

-- Toggle Menu
local function ToggleMenu()
    MenuVisible = not MenuVisible
    Frame.Visible = MenuVisible
    ToggleButton.Visible = not MenuVisible
end

CloseButton.MouseButton1Click:Connect(ToggleMenu)
ToggleButton.MouseButton1Click:Connect(ToggleMenu)

-- ESP Drawing
local function CreateDrawing(type)
    local obj = Drawing.new(type)
    obj.Visible = false
    return obj
end

local Connections = {}

local function AddESP(plr)
    if plr == LocalPlayer then return end
    
    local Box = CreateDrawing("Square")
    Box.Thickness = 2.6
    Box.Transparency = 1
    
    local BoxOutline = CreateDrawing("Square")
    BoxOutline.Thickness = 1.2
    BoxOutline.Transparency = 0.8
    BoxOutline.Color = Color3.fromRGB(0,0,0)

    local Line = CreateDrawing("Line")
    Line.Thickness = 2.2
    Line.Transparency = 1
    
    local Name = CreateDrawing("Text")
    Name.Size = 17
    Name.Center = true
    Name.Outline = true
    Name.Transparency = 1

    local DistanceText = CreateDrawing("Text")
    DistanceText.Size = 15
    DistanceText.Center = true
    DistanceText.Outline = true
    DistanceText.Transparency = 1

    -- Health Bar
    local HealthBarBG = CreateDrawing("Square")
    HealthBarBG.Thickness = 1
    HealthBarBG.Color = Color3.fromRGB(0,0,0)
    HealthBarBG.Transparency = 0.6

    local HealthBar = CreateDrawing("Square")
    HealthBar.Thickness = 1
    HealthBar.Transparency = 1

    -- Skeleton
    local SkeletonLines = {}
    for i = 1, 12 do
        local l = CreateDrawing("Line")
        l.Thickness = 1.8
        l.Transparency = 1
        table.insert(SkeletonLines, l)
    end

    local function Update()
        if not ESP.Enabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            Box.Visible = false; BoxOutline.Visible = false; Line.Visible = false
            Name.Visible = false; DistanceText.Visible = false
            HealthBarBG.Visible = false; HealthBar.Visible = false
            for _, l in ipairs(SkeletonLines) do l.Visible = false end
            return
        end

        local Root = plr.Character.HumanoidRootPart
        local Head = plr.Character:FindFirstChild("Head")
        local Humanoid = plr.Character:FindFirstChild("Humanoid")
        if not Head or not Humanoid then return end

        local Vector, OnScreen = Camera:WorldToViewportPoint(Root.Position)
        if not OnScreen then
            Box.Visible = false; BoxOutline.Visible = false; Line.Visible = false
            Name.Visible = false; DistanceText.Visible = false
            HealthBarBG.Visible = false; HealthBar.Visible = false
            for _, l in ipairs(SkeletonLines) do l.Visible = false end
            return
        end

        local HeadPos = Camera:WorldToViewportPoint(Head.Position)
        local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0,3,0))

        local BoxHeight = (HeadPos.Y - LegPos.Y) * 1.25
        local BoxWidth = BoxHeight / 2.05

        local Color = ESP.TeamColor and (plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 70, 70)) or Color3.fromRGB(0, 255, 180)

        -- Box
        if ESP.Box then
            Box.Visible = true
            Box.Color = Color
            Box.Size = Vector2.new(BoxWidth, BoxHeight)
            Box.Position = Vector2.new(Vector.X - BoxWidth/2, Vector.Y - BoxHeight/2 + 5)
            
            BoxOutline.Visible = true
            BoxOutline.Size = Vector2.new(BoxWidth + 4, BoxHeight + 4)
            BoxOutline.Position = Vector2.new(Vector.X - BoxWidth/2 - 2, Vector.Y - BoxHeight/2 + 3)
        else
            Box.Visible = false; BoxOutline.Visible = false
        end

        -- Tracer
        if ESP.Line then
            Line.Visible = true
            Line.Color = Color
            Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y - 20)
            Line.To = Vector2.new(Vector.X, Vector.Y)
        else Line.Visible = false end

        -- Name + Distance
        if ESP.Name then
            Name.Visible = true
            Name.Text = plr.Name
            Name.Position = Vector2.new(Vector.X, HeadPos.Y - 32)
            Name.Color = Color
        else Name.Visible = false end

        if ESP.Distance then
            DistanceText.Visible = true
            local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (Root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0)
            DistanceText.Text = dist .. "m"
            DistanceText.Position = Vector2.new(Vector.X, HeadPos.Y - 15)
            DistanceText.Color = Color3.fromRGB(255,255,255)
        else DistanceText.Visible = false end

        -- Health Bar
        if ESP.HealthBar then
            local healthPercent = Humanoid.Health / Humanoid.MaxHealth
            local barHeight = BoxHeight * 0.9
            HealthBarBG.Visible = true
            HealthBarBG.Size = Vector2.new(4, barHeight)
            HealthBarBG.Position = Vector2.new(Vector.X - BoxWidth/2 - 8, Vector.Y - BoxHeight/2 + 5)

            HealthBar.Visible = true
            HealthBar.Color = Color3.fromRGB(255 - 255*healthPercent, 255*healthPercent, 0)
            HealthBar.Size = Vector2.new(4, barHeight * healthPercent)
            HealthBar.Position = Vector2.new(Vector.X - BoxWidth/2 - 8, Vector.Y - BoxHeight/2 + 5 + barHeight * (1 - healthPercent))
        else
            HealthBarBG.Visible = false; HealthBar.Visible = false
        end

        -- Skeleton
        if ESP.Skeleton then
            local function GetPos(part) 
                if part then 
                    local p = Camera:WorldToViewportPoint(part.Position)
                    return Vector2.new(p.X, p.Y) 
                end 
                return nil 
            end

            local parts = {
                Head = Head,
                UpperTorso = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso"),
                LowerTorso = plr.Character:FindFirstChild("LowerTorso") or plr.Character:FindFirstChild("Torso"),
                LeftUpperArm = plr.Character:FindFirstChild("LeftUpperArm"),
                LeftLowerArm = plr.Character:FindFirstChild("LeftLowerArm"),
                LeftHand = plr.Character:FindFirstChild("LeftHand"),
                RightUpperArm = plr.Character:FindFirstChild("RightUpperArm"),
                RightLowerArm = plr.Character:FindFirstChild("RightLowerArm"),
                RightHand = plr.Character:FindFirstChild("RightHand"),
                LeftUpperLeg = plr.Character:FindFirstChild("LeftUpperLeg"),
                LeftLowerLeg = plr.Character:FindFirstChild("LeftLowerLeg"),
                LeftFoot = plr.Character:FindFirstChild("LeftFoot"),
                RightUpperLeg = plr.Character:FindFirstChild("RightUpperLeg"),
                RightLowerLeg = plr.Character:FindFirstChild("RightLowerLeg"),
                RightFoot = plr.Character:FindFirstChild("RightFoot"),
            }

            local lineIndex = 1
            -- Spine + Torso
            local spinePairs = {{parts.Head, parts.UpperTorso}, {parts.UpperTorso, parts.LowerTorso}}
            for _, pair in ipairs(spinePairs) do
                if pair[1] and pair[2] then
                    local p1, p2 = GetPos(pair[1]), GetPos(pair[2])
                    if p1 and p2 then
                        SkeletonLines[lineIndex].From = p1
                        SkeletonLines[lineIndex].To = p2
                        SkeletonLines[lineIndex].Color = Color
                        SkeletonLines[lineIndex].Visible = true
                        lineIndex += 1
                    end
                end
            end

            local limbs = {
                {parts.LeftUpperArm, parts.LeftLowerArm}, {parts.LeftLowerArm, parts.LeftHand},
                {parts.RightUpperArm, parts.RightLowerArm}, {parts.RightLowerArm, parts.RightHand},
                {parts.LeftUpperLeg, parts.LeftLowerLeg}, {parts.LeftLowerLeg, parts.LeftFoot},
                {parts.RightUpperLeg, parts.RightLowerLeg}, {parts.RightLowerLeg, parts.RightFoot},
            }

            for _, limb in ipairs(limbs) do
                if limb[1] and limb[2] then
                    local p1, p2 = GetPos(limb[1]), GetPos(limb[2])
                    if p1 and p2 then
                        SkeletonLines[lineIndex].From = p1
                        SkeletonLines[lineIndex].To = p2
                        SkeletonLines[lineIndex].Color = Color
                        SkeletonLines[lineIndex].Visible = true
                        lineIndex += 1
                    end
                end
            end

            for i = lineIndex, #SkeletonLines do SkeletonLines[i].Visible = false end
        else
            for _, l in ipairs(SkeletonLines) do l.Visible = false end
        end
    end

    table.insert(Connections, RunService.RenderStepped:Connect(Update))

    plr.CharacterRemoving:Connect(function()
        Box.Visible = false; BoxOutline.Visible = false; Line.Visible = false
        Name.Visible = false; DistanceText.Visible = false
        HealthBarBG.Visible = false; HealthBar.Visible = false
        for _, l in ipairs(SkeletonLines) do l.Visible = false end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do AddESP(plr) end
Players.PlayerAdded:Connect(AddESP)

print("KhanhHuy ESP loaded! Menu đã được nâng cấp đẹp hơn.")

[made by seraph]