-- // ESP + Aimbot + Silent Aim + FOV (Menu đẹp, Box bo góc, Kéo thả nút)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ================== CONFIG ==================
local ESP = {
    Enabled = true,
    Box = true,
    Line = true,
    Name = true,
    TeamColor = true,
    BoxRadius = 8         -- Bán kính bo góc box
}
local Aimbot = {
    Enabled = false,
    Smoothness = 0.15,
    FOV = 120
}
local SilentAim = { Enabled = false }
local MenuVisible = true
local FOVCircle

-- ================== GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 440)
Frame.Position = UDim2.new(0, 20, 0.5, -220)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

-- Bo góc + viền sáng
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Transparency = 0.3
UIStroke.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "🔥  ESP + Aimbot"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

-- Gradient cho Title
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
}
TitleGradient.Parent = Title

-- Draggable (Menu)
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
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -40, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = Frame
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1,0)

-- Nút tròn hiện khi ẩn menu (có thể kéo)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Text = "ESP"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ToggleButton).Color = Color3.fromRGB(0, 180, 255)

-- Kéo nút tròn
local btnDragging, btnDragInput, btnDragStart, btnStartPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = ToggleButton.Position
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        btnDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and input == btnDragInput then
        local delta = input.Position - btnDragStart
        ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        btnDragging = false
    end
end)

-- Toggle hiển thị menu
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

-- ================== SCROLLING FRAME ==================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -55)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 500) -- sẽ cập nhật sau
ScrollingFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Hàm tạo Toggle Switch đẹp
local function CreateToggleSwitch(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ScrollingFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Size = UDim2.new(0, 44, 0, 24)
    SwitchBg.Position = UDim2.new(1, -50, 0.5, -12)
    SwitchBg.BackgroundColor3 = default and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(80, 80, 80)
    SwitchBg.Parent = ToggleFrame
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Knob.Parent = SwitchBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local enabled = default
    local function updateVisual()
        SwitchBg.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(80, 80, 80)
        Knob.Position = enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    end

    SwitchBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateVisual()
            callback(enabled)
        end
    end)
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateVisual()
            callback(enabled)
        end
    end)

    return ToggleFrame
end

-- FOV Label và nút điều chỉnh
local FOVSection = Instance.new("Frame")
FOVSection.Size = UDim2.new(1, -10, 0, 30)
FOVSection.BackgroundTransparency = 1
FOVSection.Parent = ScrollingFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.5, 0, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. Aimbot.FOV
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 14
fovLabel.Parent = FOVSection

local fovMinus = Instance.new("TextButton")
fovMinus.Size = UDim2.new(0, 30, 0, 24)
fovMinus.Position = UDim2.new(1, -70, 0, 3)
fovMinus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovMinus.Text = "-"
fovMinus.TextColor3 = Color3.new(1,1,1)
fovMinus.Font = Enum.Font.GothamBold
fovMinus.TextSize = 18
fovMinus.Parent = FOVSection
Instance.new("UICorner", fovMinus).CornerRadius = UDim.new(0, 6)

local fovPlus = Instance.new("TextButton")
fovPlus.Size = UDim2.new(0, 30, 0, 24)
fovPlus.Position = UDim2.new(1, -30, 0, 3)
fovPlus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovPlus.Text = "+"
fovPlus.TextColor3 = Color3.new(1,1,1)
fovPlus.Font = Enum.Font.GothamBold
fovPlus.TextSize = 18
fovPlus.Parent = FOVSection
Instance.new("UICorner", fovPlus).CornerRadius = UDim.new(0, 6)

local function adjustFOV(delta)
    Aimbot.FOV = math.clamp(Aimbot.FOV + delta, 30, 500)
    fovLabel.Text = "FOV: " .. Aimbot.FOV
end
fovMinus.MouseButton1Click:Connect(function() adjustFOV(-10) end)
fovPlus.MouseButton1Click:Connect(function() adjustFOV(10) end)

-- Thêm các toggle
CreateToggleSwitch("ESP", true, function(v) ESP.Enabled = v end)
CreateToggleSwitch("Box", true, function(v) ESP.Box = v end)
CreateToggleSwitch("Line", true, function(v) ESP.Line = v end)
CreateToggleSwitch("Name", true, function(v) ESP.Name = v end)
CreateToggleSwitch("Team Color", true, function(v) ESP.TeamColor = v end)
CreateToggleSwitch("Aimbot (Head)", false, function(v) Aimbot.Enabled = v end)
CreateToggleSwitch("Silent Aim (Head)", false, function(v) SilentAim.Enabled = v end)

-- Cập nhật CanvasSize dựa trên số lượng phần tử
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

-- ================== DRAWING ==================
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Hàm tạo Box bo góc (rounded rectangle)
local function CreateRoundedBox()
    local parts = {}
    -- 4 cạnh thẳng: top, right, bottom, left
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Transparency = 1
        table.insert(parts, line)
    end
    -- 4 góc bo, mỗi góc 8 đoạn
    local cornerSegments = 8
    for i = 1, 4 do
        for j = 1, cornerSegments do
            local line = Drawing.new("Line")
            line.Thickness = 2
            line.Transparency = 1
            table.insert(parts, line)
        end
    end
    return parts
end

local function UpdateRoundedBox(parts, tl, tr, br, bl, radius, color)
    -- Hàm tính điểm trên cung tròn (góc phần tư) từ startAngle đến endAngle
    local function arcPoints(center, startAngle, endAngle, segments)
        local pts = {}
        for i = 0, segments do
            local angle = startAngle + (endAngle - startAngle) * (i / segments)
            local x = center.X + math.cos(angle) * radius
            local y = center.Y + math.sin(angle) * radius
            table.insert(pts, Vector2.new(x, y))
        end
        return pts
    end

    -- Xác định vùng bên trong bo góc (inset)
    local innerTL = tl + Vector2.new(radius, radius)
    local innerTR = tr + Vector2.new(-radius, radius)
    local innerBR = br + Vector2.new(-radius, -radius)
    local innerBL = bl + Vector2.new(radius, -radius)

    -- Các cạnh thẳng
    local edgeLines = { parts[1], parts[2], parts[3], parts[4] }
    -- Cạnh trên (từ innerTL đến innerTR)
    edgeLines[1].From = innerTL
    edgeLines[1].To = innerTR
    -- Cạnh phải (từ innerTR đến innerBR)
    edgeLines[2].From = innerTR
    edgeLines[2].To = innerBR
    -- Cạnh dưới (từ innerBR đến innerBL)
    edgeLines[3].From = innerBR
    edgeLines[3].To = innerBL
    -- Cạnh trái (từ innerBL đến innerTL)
    edgeLines[4].From = innerBL
    edgeLines[4].To = innerTL

    for _, l in ipairs(edgeLines) do
        l.Color = color
        l.Visible = true
    end

    -- Góc: Top-Left, Top-Right, Bottom-Right, Bottom-Left
    local corners = {
        {center = innerTL, start = math.pi, endAngle = math.pi * 1.5},      -- TL: 180 -> 270
        {center = innerTR, start = math.pi * 1.5, endAngle = 0},           -- TR: 270 -> 360 (0)
        {center = innerBR, start = 0, endAngle = math.pi / 2},             -- BR: 0 -> 90
        {center = innerBL, start = math.pi / 2, endAngle = math.pi}        -- BL: 90 -> 180
    }

    local lineIdx = 5
    local cornerSegments = 8
    for c = 1, 4 do
        local corner = corners[c]
        local pts = arcPoints(corner.center, corner.start, corner.endAngle, cornerSegments)
        -- Vẽ các đoạn nối giữa các điểm liên tiếp
        for i = 1, #pts-1 do
            local l = parts[lineIdx]
            l.From = pts[i]
            l.To = pts[i+1]
            l.Color = color
            l.Visible = true
            lineIdx = lineIdx + 1
        end
    end
end

-- ================== ESP & Aimbot LOGIC ==================
local Connections = {}

local function GetClosestPlayer()
    local closest, dist = nil, Aimbot.FOV
    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
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

    local BoxParts = CreateRoundedBox()
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
            UpdateRoundedBox(BoxParts, tl, tr, br, bl, ESP.BoxRadius, Color)
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

    -- Silent Aim (hook)
    if SilentAim.Enabled then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" and (self.Name:lower():find("bullet") or self.Name:lower():find("shoot")) then
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    args[1] = target.Character.Head.Position + Vector3.new(0,0.1,0)
                end
            end
            return oldNamecall(self, unpack(args))
        end)
        setreadonly(mt, true)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do AddESP(plr) end
Players.PlayerAdded:Connect(AddESP)

-- FOV Circle update
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = Aimbot.FOV
    FOVCircle.Visible = true
end)

print("✅ ESP + Aimbot + Silent Aim loaded! [Nâng cấp: menu cuộn, box bo góc, kéo nút]")