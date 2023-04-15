local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Notification =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()

Notification:SendNotification("Info", "Executed", 3)

local function GetModule(Name: string)
	local repositary = "https://raw.githubusercontent.com/BFGKO/Naval-warfare/main/Modules/%s.lua"
	local url = repositary:format(Name)
	local success, response = pcall(function()
		return loadstring(game:HttpGet(url))()
	end)
	if not success then
		Notification:SendNotification("Error", ("%s when trying to load %s"):format(response, Name), 4)
	else
		return response
	end
end

local Calculations = GetModule("Calculations")
local EventManager = GetModule("EventManager")
local Visualizer = GetModule("Visualizer")
local Ship = GetModule("Ship")
local Network = GetModule("Network")
Network:Init()

local Event = ReplicatedStorage.Event
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Planes = {}

local function GetIsland(Letter)
	for i, Island in pairs(workspace:GetChildren()) do
		if Island.Name == "Island" and Island.IslandCode.Value == Letter then
			return Island
		end
	end
end

local function Shoot(target: Vector3)
	if Ship.Ship.GunNum.Value ~= 0 then
		Event:FireServer("ChangeGun", { 0 })
	end
	local barrel = Ship:GetGunBarrel(0)
	local distance = (barrel.Position - target).Magnitude

	local angle = Calculations.Artillery:angle(distance, 800)
	local highestPoint = Calculations.Artillery:highestPoint(angle, 800)

	local middlePoint = (barrel.Position + target) / 2 + Vector3.yAxis * highestPoint

	Network:Send("aim", middlePoint)

	Network:Send("bomb", true)
	Network:Send("bomb", false)
end

EventManager:AddEvent(RunService.RenderStepped, function(deltaTime)
	if Ship.Ship then
		local Character = Player.Character
		local Root = Character.HumanoidRootPart
		local ClosestPlane = {
			Distance = math.huge,
		}
		for i, Plane in pairs(Planes) do
			if not Plane:FindFirstChild("MainBody") or not Plane:FindFirstChild("HP") then
				continue
			end
			local Distance = (Root.Position - Plane.MainBody.Position).Magnitude
			if Distance < ClosestPlane["Distance"] and Plane.HP.Value > 0 then
				ClosestPlane["Distance"] = Distance
				ClosestPlane["Plane"] = Plane
			end
		end

		if not ClosestPlane.Plane then
			if Network.Info.shooting then
				Network:Send("bomb", false)
			end
			return
		end

		local Plane = ClosestPlane.Plane

		local shootAt = Calculations.AntiAir:shootAt(Root, Plane.MainBody)

		Network:Send("aim", shootAt)

		if Ship.Status.CurrentGun ~= 1 then
			Network:Send("ChangeGun", 1)
		end
		if Network.Info.shooting then
			return
		else
			Network:Send("bomb", true)
		end
	end
end)

EventManager:AddEvent(RunService.RenderStepped, function(deltaTime)
	local Character = Player.Character
	if not Character or not Ship then
		return
	end
	local Root = Character.HumanoidRootPart
	for i, Plane in pairs(workspace:GetChildren()) do
		if not Plane:IsA("Model") then
			continue
		end
		local isPlane = string.match(Plane.Name, "Bomber")
		if not isPlane then
			continue
		end
		if not Plane:FindFirstChild("Team") then
			continue
		end

		local isFriendly = Plane.Team.Value == Player.Team.Name
		local isSpoted = Planes[Plane]
		if isFriendly then
			continue
		end
		local Distance = (Root.Position - Plane.PrimaryPart.Position).Magnitude
		local inRange = Distance < 1500
		if not inRange then
			Planes[Plane] = nil
		elseif not isSpoted then
			Notification:SendNotification("Warning", Plane.Name .. " has entered airspace", 4)
			Planes[Plane] = Plane
		end
	end
end)

EventManager:AddEvent(RunService.RenderStepped, function(deltaTime)
	getgenv().Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
end)

EventManager:AddEvent(Player.Chatted, function(message, recipient)
	if message == "/e b" then
		Shoot(GetIsland("B").MainBody.Position)
	elseif message == "/e a" then
		Shoot(GetIsland("A").MainBody.Position)
	elseif message == "/e c" then
		Shoot(GetIsland("C").MainBody.Position)
	elseif message == "/e dock" then
		if Player.Team.Name == "USA" then
			Shoot(workspace.JapanDock.MainBody.Position)
		else
			Shoot(workspace.USDock.MainBody.Position)
		end
	elseif message == "/e stop" then
		Notification:SendNotification("Success", "Stopping the script", 5)
		EventManager:Destroy()
		Visualizer:Destroy()
		Network:Destroy()
	end
end)

EventManager:AddEvent(Player.CharacterAdded, function(Character)
	local Humanoid = Character:WaitForChild("Humanoid")
	Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function(SeatPart)
		Ship:UpdateShip(SeatPart)
	end)
end)

for _, Beam in pairs({
	Visualizer:CreateCircle(1700),
	-- Visualizer:CreateCircle(1500),
}) do
	EventManager:AddEvent(RunService.RenderStepped, function()
		local Character = Player.Character
		if not Character then
			return
		end
		local Root = Character:FindFirstChild("HumanoidRootPart")
		if not Root then
			return
		end
		Beam.Position = Root.Position
	end)
end

local Character = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function(SeatPart)
	Ship:UpdateShip(SeatPart)
end)

Ship:UpdateShip(Humanoid.SeatPart)
