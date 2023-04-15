local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()
local Notiwfication = loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()

local Event = ReplicatedStorage:WaitForChild("Event")

local Player = Players.LocalPlayer
local Characater = Player.Character
local Humanoid = Characater.Humanoid

local Team = Player.Team

local Dock
local EnemyDock

local MaxBombs = {
	["Large Bomber"] = 3,
	["Bomber"] = 1
}
if Team == Teams.USA then
	Dock = workspace.USDock
	EnemyDock = workspace.JapanDock
else
	Dock = workspace.JapanDock
	EnemyDock = Workspace.USDock
end

local function GetPlane(): Model
	local Seat = Humanoid.SeatPart
	local Plane = Seat.Parent
	return Plane
end

local function Refuel()
	local Plane = GetPlane()
	local Bombs = Plane.BombC
	local orgCFrame = Plane.PrimaryPart.CFrame

	repeat
		Plane.PrimaryPart.CFrame = Dock.MainBody.CFrame
		task.wait()
	until Bombs.Value == MaxBombs[Plane.Name]

	Plane.PrimaryPart.CFrame = orgCFrame
end

local function Bomb()
	Event:FireServer("bomb")
end

local PermaAnchors = {}
local function PermaAnchor(Part, Anchor)
	if Anchor then
		PermaAnchors[Part] = Part:GetPropertyChangedSignal("Anchored"):Connect(function()
			if not Part.Anchored then
				Part.Anchored = true
			end
		end)
		Part.Anchored = true
	else
		PermaAnchors[Part]:Disconnect()
		Part.Anchored = false
	end
end

local function Attack()
	local Plane = GetPlane()
	local Root = Plane.PrimaryPart

	Notification:SendNotification("Success", "Starting auto win", 3)
	repeat
		Refuel()
		Root.CFrame = EnemyDock.MainBody.CFrame + Vector3.yAxis * 2500
		task.wait(0.1)
		Root.AssemblyLinearVelocity = Vector3.zero
		PermaAnchor(Root, true)
		
		task.wait(0)
		for i = 1, MaxBombs[Plane.Name] do
			Bomb()
		end
		
		PermaAnchor(Root, false)
	until EnemyDock.HP.Value <= 0
	Notification:SendNotification("Success", "Successfully won", 3)

	Root.Anchored = false
end



local scriptPath = game:GetService("Players").LocalPlayer.Backpack.Control
local closureName = "SetControlled"
local upvalueIndex = 5
local closureConstants = {
	[1] = "Name",
	[2] = "Bomber",
	[3] = "TargetFilter",
	[4] = "MainBody",
	[5] = "WaitForChild",
	[6] = "BodyGyro"
}

local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
local value = 0


-- DO NOT RELY ON THIS FEATURE TO PRODUCE 100% FUNCTIONAL SCRIPTS
debug.setupvalue(closure, upvalueIndex, value)

Attack()

