local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local function GetModule(Name: string)
	local repositary = "https://raw.githubusercontent.com/BFGKO/Naval-warfare/main/Modules/%s.lua"
	local url = repositary:format(Name)
	local success, response = pcall(function()
		return loadstring(game:HttpGet(url))()
	end)
	if not success then
		warn(response)
	else
		return response
	end
end

local EventManager = GetModule("EventManager")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

local Map = Instance.new("Frame")
Map.Parent = ScreenGui
Map.Size = UDim2.fromOffset(600, 700)
Map.Position = UDim2.fromScale(1, 1)
Map.AnchorPoint = Vector2.new(1, 1)
Map.BackgroundColor3 = Color3.new(0.211764, 0.211764, 0.211764)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)

UICorner:Clone().Parent = Map

local ViewportFrame = Instance.new("ViewportFrame")
ViewportFrame.AnchorPoint = Vector2.new(0.5, 0)
ViewportFrame.Position = UDim2.fromScale(0.5, 0)
ViewportFrame.Size = UDim2.fromScale(1, 0.9)
ViewportFrame.BackgroundColor3 = Color3.new(0.211764, 0.211764, 0.211764)
ViewportFrame.Parent = Map

local worldModel = Instance.new("WorldModel", ViewportFrame)
local camera = Instance.new("Camera", worldModel)
camera.FieldOfView = 70
ViewportFrame.CurrentCamera = camera

UICorner:Clone().Parent = ViewportFrame

task.delay(15, function()
	ScreenGui:Destroy()
	EventManager:Destroy()
end)

local function AddToViewpoort(Child: Model)
	Child.Archivable = true

	local Clone = Child:Clone()
	if not Clone then
		print(Child:GetFullName())
	end
	Clone.Parent = worldModel
	if not Clone.PrimaryPart then
		return
	end
	EventManager:AddEvent(RunService.RenderStepped, function() 
        Clone.PrimaryPart.CFrame = Child.PrimaryPart.CFrame
    end)
end
for i, v in pairs(workspace:GetChildren()) do
	pcall(function()
		AddToViewpoort(v)
	end)
end

EventManager:AddEvent(RunService.RenderStepped, function(deltaTime)
	local character = Player.Character
	local root = character.HumanoidRootPart
	local rootPosition = root.Position
	camera.CFrame = CFrame.new(Vector3.new(rootPosition.X, 1200, rootPosition.Z), rootPosition)
end)
