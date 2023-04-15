local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character

local args = {
	[1] = "Teleport",
	[2] = {
		[1] = "Island",
		[2] = "A",
		[3] = 0,
	},
}


local function FF()
    game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer(unpack(args))
    
    Character.HumanoidRootPart.Anchored = true
    local oldCFrame = Character.HumanoidRootPart.CFrame
    Character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Once(function()
        Character.HumanoidRootPart.CFrame = oldCFrame
        Character.HumanoidRootPart.Anchored = false
    end)
    
end


FF()

Character.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("ForceField") then
        FF()
    end
end)

