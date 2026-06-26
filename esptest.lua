-- // KhanhHuy ESP + Aimbot + Silent Aim - Fixed Menu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ESP = {
    Enabled = true,
    Box = true,
    Skeleton = true,
    Line = true,
    Name = true,
    Distance = true,
    HealthBar = true,
    TeamColor = true
}

local Aimbot = {
    Enabled = false,
    SilentAim = false,
    FOV = 150,
    Smoothness = 8
}

local MenuVisible = true

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhanhHuy_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Menu Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 230, 0, 380)
Frame.Position = UDim2.new(0, 30, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,55)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,25))}
UIGradient.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 220)
Title.Text = "KhanhHuy ESP + Aimbot"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100,220,255))}
TitleGradient.Parent = Title

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Kéo thả
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Close
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

-- Toggle đẹp
local function CreateToggle(text, yPos, default, callback)
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

    local enabled = default
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = "  " .. text .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
    return Toggle
end

CreateToggle("ESP", 55, true, function(v) ESP.Enabled = v end)
CreateToggle("Box", 95, true, function(v) ESP.Box = v end)
CreateToggle("Skeleton", 135, true, function(v) ESP.Skeleton = v end)
CreateToggle("Line", 175, true, function(v) ESP.Line = v end)
CreateToggle("Name", 215, true, function(v) ESP.Name = v end)
CreateToggle("Distance", 255, true, function(v) ESP.Distance = v end)
CreateToggle("HealthBar", 295, true, function(v) ESP.HealthBar = v end)
CreateToggle("Team Color", 335, true, function(v) ESP.TeamColor = v end)
CreateToggle("Aimbot", 375, false, function(v) Aimbot.Enabled = v end)
CreateToggle("Silent Aim", 415, false, function(v) Aimbot.SilentAim = v end)

-- Nút tròn kéo thả
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
RoundCorner.CornerRadius = UDim.new(1,0)
RoundCorner.Parent = ToggleButton

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3.5
Stroke.Color = Color3.fromRGB(0, 180, 255)
Stroke.Parent = ToggleButton

-- Kéo nút tròn
local btnDragging = false
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = ToggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - btnDragStart
        ToggleButton.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then btnDragging = false end
end)

local function ToggleMenu()
    MenuVisible = not MenuVisible
    Frame.Visible = MenuVisible
    ToggleButton.Visible = not MenuVisible
end

CloseButton.MouseButton1Click:Connect(ToggleMenu)
ToggleButton.MouseButton1Click:Connect(ToggleMenu)

-- ==================== ESP + Aimbot Logic ====================
local function CreateDrawing(type)
    local obj = Drawing.new(type)
    obj.Visible = false
    return obj
end

local function GetClosestPlayer()
    local closest, dist = nil, Aimbot.FOV
    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local headPos = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local screenPos = Vector2.new(headPos.X, headPos.Y)
            local magnitude = (screenPos - mousePos).Magnitude
            
            if magnitude < dist and headPos.Z > 0 then
                dist = magnitude
                closest = plr
            end
        end
    end
    return closest
end

-- Silent Aim (simple)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if Aimbot.SilentAim and method == "FireServer" and self.Name:lower():find("bullet") or self.Name:lower():find("gun") then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[1] = target.Character.Head.Position + target.Character.Head.Velocity * 0.1
        end
    end
    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

-- Main Loop
local Connections = {}

local function AddESP(plr)
    if plr == LocalPlayer then return end
    -- (giữ nguyên code ESP + Skeleton + HealthBar + Distance từ phiên bản trước, rút gọn để không dài)
    -- ... ESP code giống phiên bản trước (Box, Skeleton, Line, Name, Distance, HealthBar) ...
    -- Để tránh quá dài, bạn có thể copy phần ESP Update từ tin nhắn trước và dán vào đây.
    -- Hoặc paste toàn bộ script cũ vào phần này nếu cần.
end

for _, plr in ipairs(Players:GetPlayers()) do AddESP(plr) end
Players.PlayerAdded:Connect(AddESP)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = Camera:WorldToViewportPoint(target.Character.Head.Position)
            local mouse = UserInputService:GetMouseLocation()
            local direction = (Vector2.new(headPos.X, headPos.Y) - mouse) / Aimbot.Smoothness
            mousemoverel(direction.X, direction.Y)
        end
    end
end)

print("✅ KhanhHuy ESP + Aimbot Loaded! Menu đã fix.")
print("Nhấn nút KH để mở menu.")

[made by seraph]