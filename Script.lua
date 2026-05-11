--[[
    Naval Warfare Script
]]

local vape: any = shared.veloc
local velo: table = {}

local replicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local playersService: Players = cloneref(game:GetService("Players"))
local runService: RunService = cloneref(game:GetService("RunService"))
local stats: Stats = cloneref(game:GetService("Stats"))

local lplr: Player = playersService.LocalPlayer

local Notification: any = loadstring(game:HttpGet("https://raw.githubusercontent.com/lobox920/Notification-Library/Main/Library.lua"))()
Notification:SendNotification("Info", "Executed", 3)

local function GetModule(Name: string): any
        local repo: string = "https://raw.githubusercontent.com/Copiums/Naval-warfare/main/Modules/%s.lua"
        local url: string = repo:format(Name)
        
        local suc: boolean, resp: any = pcall(function()
                return loadstring(game:HttpGet(url))()
        end)
        
        if not suc then
                Notification:SendNotification("Error", ("%s when trying to load %s"):format(resp, Name), 4)
                return nil
        end
        return resp
end

local Calculations: any = GetModule("Calculations")
local EventManager: any = GetModule("EventManager")
local Visualizer: any = GetModule("Visualizer")
local Ship: any = GetModule("Ship")
local Network: any = GetModule("Network")
local Ui: any = GetModule("Ui")

Network:Init()
Ui:Init()

local Event: any = replicatedStorage.Event
local Planes: table = {}

local GetIsland: (letter: string) -> any = function(letter: string)
        for _, island in next, workspace:GetChildren() do
                if island.Name == "Island" and island:FindFirstChild("IslandCode") and island.IslandCode.Value == letter then
                        return island
                end
        end
        return nil
end

local Shoot: (target: Vector3) -> () = function(target: Vector3)
        if not Ship.Ship then
                Notification:SendNotification("Error", "No ship detected!", 4)
                return
        end

        if Ship:GetCurrentGun() ~= 0 then
                Event:FireServer("ChangeGun", {0})
                task.wait(0.2)
        end

        local barrel: any = Ship:GetGunBarrel(0)
        if not barrel then
                Notification:SendNotification("Error", "Could not find gun barrel!", 4)
                return
        end

        local dist: number = (barrel.Position - target).Magnitude
        local angle: number = Calculations.Artillery:angle(dist, 800)
        local highest: number = Calculations.Artillery:highestPoint(angle, 800)

        local aimPos: Vector3 = (barrel.Position + target) / 2 + Vector3.yAxis * highest

        Network:Send("aim", aimPos)
        Network:Send("bomb", true)
        task.wait(0.1)
        Network:Send("bomb", false)

        Notification:SendNotification("Success", "Artillery Fired | Dist: " .. math.floor(dist), 3)
end

-- Anti Air
EventManager:AddEvent(runService.RenderStepped, function()
        if not Ship.Ship then return end
        local char = lplr.Character
        if not char then return end
        local hrp: BasePart? = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local closest: table = {Dist = math.huge}

        for _, plane in next, Planes do
                if not plane:FindFirstChild("MainBody") or not plane:FindFirstChild("HP") then continue end
                local dist: number = (hrp.Position - plane.MainBody.Position).Magnitude
                if dist < closest.Dist and plane.HP.Value > 0 then
                        closest.Dist = dist
                        closest.Plane = plane
                end
        end

        if not closest.Plane then
                if Network.Info.shooting then Network:Send("bomb", false) end
                return
        end

        local plane = closest.Plane
        local aimAt: Vector3 = Calculations.AntiAir:shootAt(hrp, plane.MainBody)

        Network:Send("aim", aimAt)
        if Ship.Status.CurrentGun ~= 1 then
                Network:Send("ChangeGun", 1)
        end
        Network:Send("bomb", true)
        task.wait(0.05)
        Network:Send("bomb", false)
end)

-- Plane Detector
EventManager:AddEvent(runService.RenderStepped, function()
        local char = lplr.Character
        if not char then return end
        local hrp: BasePart? = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, plane in next, workspace:GetChildren() do
                if not plane:IsA("Model") then continue end
                if not string.match(plane.Name, "Bomber") then continue end
                if not plane:FindFirstChild("Team") then continue end

                local friendly: boolean = plane.Team.Value == lplr.Team.Name
                if friendly then continue end

                local dist: number = (hrp.Position - plane.PrimaryPart.Position).Magnitude
                local inrange: boolean = dist < 1500

                if not inrange then
                        Planes[plane] = nil
                elseif not Planes[plane] then
                        Notification:SendNotification("Warning", plane.Name .. " has entered airspace", 4)
                        Planes[plane] = plane
                end
        end
end)

-- Ping
EventManager:AddEvent(runService.RenderStepped, function()
        getgenv().Ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
end)

-- Chat Commands
EventManager:AddEvent(lplr.Chatted, function(msg: string)
        msg = msg:lower()

        if msg == ";b" then
                local island = GetIsland("B")
                if island and island:FindFirstChild("MainBody") then Shoot(island.MainBody.Position) end
        elseif msg == ";a" then
                local island = GetIsland("A")
                if island and island:FindFirstChild("MainBody") then Shoot(island.MainBody.Position) end
        elseif msg == ";c" then
                local island = GetIsland("C")
                if island and island:FindFirstChild("MainBody") then Shoot(island.MainBody.Position) end
        elseif msg == ";dock" then
                if lplr.Team.Name == "USA" then
                        Shoot(workspace.JapanDock and workspace.JapanDock.MainBody.Position or Vector3.zero)
                else
                        Shoot(workspace.USDock and workspace.USDock.MainBody.Position or Vector3.zero)
                end
        elseif msg == ";stop" then
                Notification:SendNotification("Success", "Stopping the script", 5)
                for _, mod in next, {EventManager, Visualizer, Network, Ui} do
                        pcall(function() mod:Destroy() end)
                end
        end
end)

-- Seat Handler
EventManager:AddEvent(lplr.CharacterAdded, function(char)
        local hum: Humanoid = char:WaitForChild("Humanoid")
        EventManager:AddEvent(hum:GetPropertyChangedSignal("SeatPart"), function()
                Ship:UpdateShip(hum.SeatPart)
        end)
end)

local char = lplr.Character
if char then
        local hum: Humanoid = char:WaitForChild("Humanoid")
        EventManager:AddEvent(hum:GetPropertyChangedSignal("SeatPart"), function()
                local seat = hum.SeatPart
                if seat then
                        Notification:SendNotification("Success", "New Ship(" .. seat.Parent.Name .. ")", 4)
                else
                        Notification:SendNotification("Success", "Left ship", 4)
                end
                Ship:UpdateShip(seat)
        end)
        Ship:UpdateShip(hum.SeatPart)
end

-- Visualizer Circle
for _, beam in next, {Visualizer:CreateCircle(1700)} do
        EventManager:AddEvent(runService.RenderStepped, function()
                local char = lplr.Character
                local hrp: BasePart? = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                        beam.Position = hrp.Position
                end
        end)
end

Notification:SendNotification("Success", "Naval Warfare Script Loaded", 5)
