local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local Characters = "Characters"

-- Register two collision groups
PhysicsService:RegisterCollisionGroup(Characters)

-- Set Characters to be non-collidable with other Characters
PhysicsService:CollisionGroupSetCollidable(Characters, Characters, false)

local function CharacterAdded(Character)
    Character.DescendantAdded:Connect(function(Descendant)
        Descendant.CollisionGroup = Characters
    end)
end

local function DisableCollisions()
    for i,Player in pairs(Players:GetPlayers()) do
        Player.CharacterAdded:Connect(CharacterAdded)
    end
end

DisableCollisions()

game.Players.PlayerAdded:Connect(DisableCollisions)