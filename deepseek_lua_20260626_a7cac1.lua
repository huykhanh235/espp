-- // ESP + Aimbot + Silent Aim + FOV (Menu ngang, hiệu ứng mở/đóng tween)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ================== CONFIG ==================
local ESP = {
    Enabled = true,
    Box = true,
    Line = true,
    Name = true,
    TeamColor = true,
    BoxRadius = 8,
    CornerSegments = 16,
    MaxDistance = 800
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

-- Nút tròn khi ẩn menu (có thể kéo)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Text = "ESP"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Visible = false  -- bắt đầu ẩn vì menu đang mở
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
        btnDragging = false
    end
end)

-- ================== MENU NGANG ==================
local MainMenuFrame = Instance.new("Frame")
MainMenuFrame.Size = UDim2.new(0, 580, 0, 50)   -- Kích thước khi mở
MainMenuFrame.Position = UDim2.new(0, 20, 0.5, -25)
MainMenuFrame.AnchorPoint = Vector2.new(0, 0.5)
MainMenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainMenuFrame.BorderSizePixel = 0
MainMenuFrame.ClipsDescendants = true
MainMenuFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainMenuFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Transparency = 0.3
UIStroke.Parent = MainMenuFrame

-- Nội dung bên trong (để sắp xếp)
local MenuContent = Instance.new("Frame")
MenuContent.Size = UDim2.new(1, 0, 1, 0)
MenuContent.BackgroundTransparency = 1
MenuContent.Parent = MainMenuFrame

-- Nút đóng menu (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(0, 8, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = MenuContent
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1,0)

-- ScrollingFrame ngang
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -50, 1, 0)
ScrollingFrame.Position = UDim2.new(0, 45, 0, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = MenuContent

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Tự động cập nhật CanvasSize theo nội dung
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 10, 0, 0)
end)

-- ================== TOGGLE SWITCH NHỎ NGANG ==================
local function CreateToggleSwitch(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 90, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ScrollingFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 40, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(0, 45, 0.5, -10)
    SwitchBg.BackgroundColor3 = default and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(80, 80, 80)
    SwitchBg.Text = ""
    SwitchBg.Parent = ToggleFrame
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Knob.Parent = SwitchBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local enabled = default
    local function updateVisual()
        SwitchBg.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(80, 80, 80)
        Knob.Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end

    SwitchBg.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateVisual()
        callback(enabled)
    end)

    return ToggleFrame
end

-- FOV điều chỉnh
local FOVFrame = Instance.new("Frame")
FOVFrame.Size = UDim2.new(0, 110, 0, 40)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Parent = ScrollingFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 40, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. Aimbot.FOV
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 11
fovLabel.Parent = FOVFrame

local fovMinus = Instance.new("TextButton")
fovMinus.Size = UDim2.new(0, 22, 0, 22)
fovMinus.Position = UDim2.new(0, 45, 0.5, -11)
fovMinus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovMinus.Text = "-"
fovMinus.TextColor3 = Color3.new(1,1,1)
fovMinus.Font = Enum.Font.GothamBold
fovMinus.TextSize = 14
fovMinus.Parent = FOVFrame
Instance.new("UICorner", fovMinus).CornerRadius = UDim.new(0, 5)

local fovPlus = Instance.new("TextButton")
fovPlus.Size = UDim2.new(0, 22, 0, 22)
fovPlus.Position = UDim2.new(0, 72, 0.5, -11)
fovPlus.BackgroundColor3 = Color3.fromRGB(60,60,60)
fovPlus.Text = "+"
fovPlus.TextColor3 = Color3.new(1,1,1)
fovPlus.Font = Enum.Font.GothamBold
fovPlus.TextSize = 14
fovPlus.Parent = FOVFrame
Instance.new("UICorner", fovPlus).CornerRadius = UDim.new(0, 5)

local function adjustFOV(delta)
    Aimbot.FOV = math.clamp(Aimbot.FOV + delta, 30, 500)
    fovLabel.Text = "FOV: " .. Aimbot.FOV
end
fovMinus.MouseButton1Click:Connect(function() adjustFOV(-10) end)
fovPlus.MouseButton1Click:Connect(function() adjustFOV(10) end)

-- Player Count Label
local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Size = UDim2.new(0, 70, 0, 40)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "Players: 0"
PlayerCountLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
PlayerCountLabel.Font = Enum.Font.Gotham
PlayerCountLabel.TextSize = 11
PlayerCountLabel.Parent = ScrollingFrame

-- Thêm các toggle vào menu
CreateToggleSwitch("ESP", true, function(v) ESP.Enabled = v end)
CreateToggleSwitch("Box", true, function(v) ESP.Box = v end)
CreateToggleSwitch("Line", true, function(v) ESP.Line = v end)
CreateToggleSwitch("Name", true, function(v) ESP.Name = v end)
CreateToggleSwitch("Team", true, function(v) ESP.TeamColor = v end)
CreateToggleSwitch("Aimbot", false, function(v) Aimbot.Enabled = v end)
CreateToggleSwitch("Silent", false, function(v) SilentAim.Enabled = v end)
CreateToggleSwitch("Dist", true, function(v)
    ESP.MaxDistance = v and 800 or 99999
end)

-- ================== HIỆU ỨNG TWEEN MỞ/ĐÓNG ==================
local tweenOpen, tweenClose
local function setupTweens()
    local openSize = UDim2.new(0, 580, 0, 50)
    local closeSize = UDim2.new(0, 0, 0, 50)

    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    tweenOpen = TweenService:Create(MainMenuFrame, tweenInfo, {Size = openSize})
    tweenClose = TweenService:Create(MainMenuFrame, tweenInfo, {Size = closeSize})
end
setupTweens()

local function openMenu()
    MenuVisible = true
    ToggleButton.Visible = false
    MainMenuFrame.Visible = true
    tweenOpen:Play()
end

local function closeMenu()
    MenuVisible = false
    tweenClose:Play()
    -- Sau khi tween xong thì ẩn menu và hiện nút tròn
    tweenClose.Completed:Wait()
    MainMenuFrame.Visible = false
    ToggleButton.Visible = true
end

-- Gán sự kiện cho nút đóng và nút tròn
CloseButton.MouseButton1Click:Connect(function()
    if MenuVisible then closeMenu() end
end)
ToggleButton.MouseButton1Click:Connect(function()
    if not MenuVisible then openMenu() end
end)

-- Khi khởi động, menu đang mở (MenuVisible = true), không cần tween vì đã đúng Size
-- Nhưng để đồng bộ, ta đảm bảo MenuVisible true và menu hiển thị ngay
MainMenuFrame.Size = UDim2.new(0, 580, 0, 50)
MainMenuFrame.Visible = true
ToggleButton.Visible = false

-- Kéo menu (drag toàn bộ MainMenuFrame)
local draggingMenu, dragInputMenu, dragStartMenu, startPosMenu
MainMenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Chỉ kéo nếu không click vào nút con (như CloseButton hoặc toggle)
        -- Đơn giản: kiểm tra nếu target là MainMenuFrame hoặc MenuContent
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingMenu = true
            dragStartMenu = input.Position
            startPosMenu = MainMenuFrame.Position
        end
    end
end)
MainMenuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMenu = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingMenu and input == dragInputMenu then
        local delta = input.Position - dragStartMenu
        MainMenuFrame.Position = UDim2.new(startPosMenu.X.Scale, startPosMenu.X.Offset + delta.X, startPosMenu.Y.Scale, startPosMenu.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = false
    end
end)

-- ================== DRAWING ==================
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Hàm tạo Box bo góc siêu mượt
local function CreateRoundedBox()
    local parts = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Transparency = 1
        table.insert(parts, line)
    end
    local segs = ESP.CornerSegments
    for i = 1, 4 do
        for j = 1, segs do
            local line = Drawing.new("Line")
            line.Thickness = 2
            line.Transparency = 1
            table.insert(parts, line)
        end
    end
    return parts
end

local function UpdateRoundedBox(parts, tl, tr, br, bl, radius, color)
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

    local innerTL = tl + Vector2.new(radius, radius)
    local innerTR = tr + Vector2.new(-radius, radius)
    local innerBR = br + Vector2.new(-radius, -radius)
    local innerBL = bl + Vector2.new(radius, -radius)

    local edgeLines = { parts[1], parts[2], parts[3], parts[4] }
    edgeLines[1].From = innerTL
    edgeLines[1].To = innerTR
    edgeLines[2].From = innerTR
    edgeLines[2].To = innerBR
    edgeLines[3].From = innerBR
    edgeLines[3].To = innerBL
    edgeLines[4].From = innerBL
    edgeLines[4].To = innerTL
    for _, l in ipairs(edgeLines) do
        l.Color = color
        l.Visible = true
    end

    local corners = {
        {center = innerTL, start = math.pi, endAngle = math.pi * 1.5},
        {center = innerTR, start = math.pi * 1.5, endAngle = 0},
        {center = innerBR, start = 0, endAngle = math.pi / 2},
        {center = innerBL, start = math.pi / 2, endAngle = math.pi}
    }
    local segs = ESP.CornerSegments
    local lineIdx = 5
    for c = 1, 4 do
        local corner = corners[c]
        local pts = arcPoints(corner.center, corner.start, corner.endAngle, segs)
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

-- ================== ESP & AIMBOT LOGIC ==================
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
        local character = plr.Character
        if not ESP.Enabled or not character or not character:FindFirstChild("HumanoidRootPart") then
            for _, part in ipairs(BoxParts) do part.Visible = false end
            Line.Visible = false
            Name.Visible = false
            return
        end

        local Root = character.HumanoidRootPart
        local Head = character:FindFirstChild("Head")
        local Humanoid = character:FindFirstChild("Humanoid")
        if not Head then return end

        local distance = (Camera.CFrame.Position - Root.Position).Magnitude
        if distance > ESP.MaxDistance then
            for _, part in ipairs(BoxParts) do part.Visible = false end
            Line.Visible = false
            Name.Visible = false
            return
        end

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
            -- Tia từ đỉnh màn hình
            Line.From = Vector2.new(Camera.ViewportSize.X/2, 0)
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
end

for _, plr in ipairs(Players:GetPlayers()) do
    AddESP(plr)
end
Players.PlayerAdded:Connect(AddESP)

-- Cập nhật số lượng người chơi
RunService.RenderStepped:Connect(function()
    local count = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            count = count + 1
        end
    end
    PlayerCountLabel.Text = "Players: " .. count
end)

-- Silent Aim Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" then
        local nameLower = self.Name:lower()
        if (nameLower:find("bullet") or nameLower:find("shoot")) and SilentAim.Enabled then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                args[1] = target.Character.Head.Position + Vector3.new(0,0.1,0)
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- FOV Circle Update
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = Aimbot.FOV
    FOVCircle.Visible = true
end)

print("✅ ESP + Aimbot + Silent Aim (Menu ngang, hiệu ứng mở/đóng) đã sẵn sàng!")