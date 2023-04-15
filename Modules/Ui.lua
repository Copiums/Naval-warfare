local HttpService = game:GetService("HttpService")
local Ui = {
    Buttons = {},
    Viewport = nil
}


local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIPadding = Instance.new("UIPadding")
local Map = Instance.new("ViewportFrame")
local UICorner_2 = Instance.new("UICorner")
local CurrentPosition = Instance.new("ImageButton")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local Buttons = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local Fire = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local UIPadding_2 = Instance.new("UIPadding")
local UIPadding_3 = Instance.new("UIPadding")
local FocusShip_1 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local UIPadding_4 = Instance.new("UIPadding")

-- Properties

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.227451, 0.227451, 0.227451)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.583049297, 0, 0.343499213, 0)
Frame.Size = UDim2.new(0.416821033, 0, 0.656427979, 0)

UICorner.Parent = Frame

UIPadding.Parent = Frame
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.PaddingTop = UDim.new(0, 10)

Map.Ambient = Color3.new(1, 1, 1)
Map.LightColor = Color3.new(1, 0.847059, 0.0823529)
Map.LightDirection = Vector3.new(0, -1, -1)
Map.AnchorPoint = Vector2.new(0.5, 0)
Map.BackgroundColor3 = Color3.new(0.152941, 0.152941, 0.152941)
Map.Name = HttpService:GenerateGUID()
Map.Parent = Frame
Map.Position = UDim2.new(0.5, 0, 0, 0)

UICorner_2.Parent = Map

CurrentPosition.Name = HttpService:GenerateGUID()
CurrentPosition.Parent = Map
CurrentPosition.BackgroundTransparency = 1
CurrentPosition.Position = UDim2.new(0.302600801, 0, 0.4268803, 0)
CurrentPosition.Size = UDim2.new(0.107936345, 0, 0.143745422, 0)
CurrentPosition.ZIndex = 2
CurrentPosition.Image = "rbxassetid://3926305904"
CurrentPosition.ImageRectOffset = Vector2.new(724, 204)
CurrentPosition.ImageRectSize = Vector2.new(36, 36)

UIAspectRatioConstraint.Parent = CurrentPosition

Buttons.Name = HttpService:GenerateGUID()
Buttons.Parent = Frame
Buttons.AnchorPoint = Vector2.new(0.5, 1)
Buttons.BackgroundColor3 = Color3.new(0.152941, 0.152941, 0.152941)
Buttons.Position = UDim2.new(0.5, 0, 1, 0)
Buttons.Size = UDim2.new(1, 0, 0.150000006, -10)

UICorner_3.Parent = Buttons

UIListLayout.Parent = Buttons
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 15)

Fire.Name = HttpService:GenerateGUID()
Fire.Parent = Buttons
Fire.BackgroundColor3 = Color3.new(0.227451, 0.227451, 0.227451)
Fire.Size = UDim2.new(0, 0, 1, 0)
Fire.Font = Enum.Font.SciFi
Fire.Text = "FIRE"
Fire.TextColor3 = Color3.new(1, 1, 1)
Fire.TextScaled = true
Fire.TextSize = 14
Fire.TextWrapped = true

UICorner_4.Parent = Fire

UIPadding_2.Parent = Fire
UIPadding_2.PaddingLeft = UDim.new(0, 10)
UIPadding_2.PaddingRight = UDim.new(0, 10)

UIPadding_3.Parent = Buttons
UIPadding_3.PaddingBottom = UDim.new(0, 10)
UIPadding_3.PaddingLeft = UDim.new(0, 10)
UIPadding_3.PaddingRight = UDim.new(0, 10)
UIPadding_3.PaddingTop = UDim.new(0, 10)

FocusShip_1.Name = HttpService:GenerateGUID()
FocusShip_1.Parent = Buttons
FocusShip_1.BackgroundColor3 = Color3.new(0.227451, 0.227451, 0.227451)
FocusShip_1.Size = UDim2.new(0, 0, 1, 0)
FocusShip_1.Font = Enum.Font.SciFi
FocusShip_1.Text = "Focus ship"
FocusShip_1.TextColor3 = Color3.new(1, 1, 1)
FocusShip_1.TextScaled = true
FocusShip_1.TextSize = 14
FocusShip_1.TextWrapped = true

UICorner_5.Parent = FocusShip_1

UIPadding_4.Parent = FocusShip_1
UIPadding_4.PaddingLeft = UDim.new(0, 10)
UIPadding_4.PaddingRight = UDim.new(0, 10)

Ui.Buttons.Fire = Fire
Ui.Buttons.Focus = FocusShip_1
Ui.Viewport = Map


return Ui