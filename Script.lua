local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")


local Notification =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()

local function GetModule(Name : string)
	local repositary = "https://raw.githubusercontent.com/BFGKO/Naval-warfare/main/Modules/%s.lua"
	local url = repositary:format(Name)
	success, err = pcall(function()
		
		return loadstring(game:HttpGet(url))
	end)
	if not success then
		Notification:SendNotification("Error", ("%s when trying to load %s"):format(err, Name), 4)
	else
		return success
	end
end

local Calculations = GetModule("Calculations")
local EventManager = GetModule("EventManager")


local Event = ReplicatedStorage.Event

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Ship
local Info = {}
local Planes = {}
local Events = {}




local function InitBeams(Radius)
	local Radius = 1700
	local BeamParent = Instance.new("Part")
	BeamParent.CanCollide = false
	BeamParent.Anchored = true
	BeamParent.Position = Vector3.new(0, math.huge, 0)
	BeamParent.Transparency = 1

	BeamParent.Parent = workspace

	local Attach1 = Instance.new("Attachment")
	Attach1.Parent = BeamParent

	local Attach2 = Instance.new("Attachment")
	Attach2.Parent = BeamParent

	local Beam1 = Instance.new("Beam")
	Beam1.Attachment0 = Attach2
	Beam1.Attachment1 = Attach1
	Beam1.CurveSize0 = Radius * 4 / 3
	Beam1.CurveSize1 = Radius * 4 / 3

	Beam1.Width0 = 15
	Beam1.Width1 = 15
	Beam1.Segments = 100

	Beam1.Parent = BeamParent

	local Beam2 = Instance.new("Beam")
	Beam2.Attachment0 = Attach2
	Beam2.Attachment1 = Attach1
	Beam2.CurveSize0 = -Radius * 4 / 3
	Beam2.CurveSize1 = -Radius * 4 / 3

	Beam2.Width0 = 15
	Beam2.Width1 = 15
	Beam2.Segments = 100

	Beam2.Parent = BeamParent

	Events["Beam("..Radius..") updator"] = RunService.RenderStepped:Connect(function(deltaTime)
		if Player.Character then
			local Root = Player.Character.HumanoidRootPart
			BeamParent.CFrame = Root.CFrame
			Attach1.WorldCFrame = CFrame.new(Root.CFrame.Position + Vector3.new(0, 0, Radius), Root.Position)
			Attach2.WorldCFrame = CFrame.new(Root.CFrame.Position + Vector3.new(0, 0, -Radius), Root.Position)
		end
	end)
end

InitBeams(1700)
InitBeams(1500)

local function GetIsland(Letter)
	for i, Island in pairs(workspace:GetChildren()) do
		if Island.Name == "Island" and Island.IslandCode.Value == Letter then
			return Island
		end
	end
end

local function Shoot(Target: Vector3)
	Event:FireServer("ChangeGun", { 0 })
	local Character = Player.Character
	local Root = Character.HumanoidRootPart
	local distance = (Root.Position - Target).Magnitude

	local angle = Calculations.Artillery:angle(distance, 800)
	local highestPoint = Calculations.Artillery:highestPoint(angle, 800)

	local middlePoint = (Root.Position + Target) / 2 + Vector3.yAxis * highestPoint

	Event:FireServer("aim", {
		middlePoint,
	})

	Event:FireServer("bomb", { true })
	Event:FireServer("bomb", { false })
end



Events["RunServiceShipUpdater"] = RunService.RenderStepped:Connect(function(deltaTime)
	if Player.Character then
		local Humanoid = Player.Character:WaitForChild("Humanoid")
		if Humanoid and Humanoid.SeatPart then
			Ship = Humanoid.SeatPart.Parent
		end
	end
end)
Events["AntiAirShooter"] = RunService.RenderStepped:Connect(function(deltaTime)
	if Ship and Player.Character then
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
			return
		end

		local Plane = ClosestPlane.Plane

		local ShootAt = Calculations.AntiAir:shootAt(Root, Plane.MainBody)

		Event:FireServer("aim", {
			ShootAt,
		})

		if Info.CurrentGun ~= 1 then
			Event:FireServer("ChangeGun", { 1 })
		end

		Event:FireServer("bomb", { true })
		Event:FireServer("bomb", { false })
	end
end)

Events["AntiAir"] = RunService.RenderStepped:Connect(function(deltaTime)
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

Events["PingUpdated"] = RunService.RenderStepped:Connect(function(deltaTime)
	Info.Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
end)

local gmt = getrawmetatable(game)
setreadonly(gmt, false)

local namecall = gmt.__namecall

gmt.__namecall = function(self, ...)
	local method = getnamecallmethod()
	if self == Event and method == "FireServer" then
		local args = { ... }
		local eventType = args[1]
		local eventArgs = args[2]

		if eventType == "ChangeGun" then
			Info.CurrentGun = eventArgs[1]
		elseif eventType == "bomb" and eventArgs then
			Info.Shooting = eventArgs[1]
		end
	end
	return namecall(self, ...)
end

Events["Chatted"] = game.Players.LocalPlayer.Chatted:Connect(function(message, recipient)
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
		for i, event in pairs(Events) do
			print("Disconnected", i)
			event:Disconnect()
		end
		BeamParent:Destroy()

		gmt.__namecall = namecall
	end
end)
