local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Event = ReplicatedStorage.Event

game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
for i,Player in pairs(Players:GetPlayers()) do
    if Player.Team == game.Players.LocalPlayer.Team then
        continue
    end
    local Character = Player.Character
    local Head = Character.Head
    if not Head then
        continue
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Head.CFrame
    task.wait()
    for i = 1,10 do
        
        local args = {
            [1] = "shootRifle",
            [2] = "",
            [3] = {
                [1] = Head
            }
        }
        
        Event:FireServer(unpack(args))
    
    end
    task.wait()
end

local args = {
	[1] = "Teleport",
	[2] = {
		[1] = "Island",
		[2] = "A",
		[3] = 0,
	},
}
game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer(unpack(args))

game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false


