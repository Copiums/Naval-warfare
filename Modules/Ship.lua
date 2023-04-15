local Ship = {}

local ShipNames = {
	"Heavy Cruiser",
	"Cruiser",
	"Carrier",
	"Destroyer",
}

function Ship:UpdateShip(Humanoid: Humanoid)
	if Humanoid.SeatPart then
        local Parent = Humanoid.SeatPart.Parent
        if table.find(ShipNames, Parent.name) then
            self.Ship = Parent
        end
	end
end

function Ship:GetGunBarrel(gunIndex : number)
    for i,Gun in pairs(self.Ship:GetChildren()) do
        if Gun.Name ~= "Turret" then
            continue
        end
        if Gun.ID.Value ~= gunIndex then
            continue
        end
        local PrimeGun = Gun:FindFirstChild("PrimeGun")
        local BRight = Gun:FindFirstChild("BRight")

        return PrimeGun or BRight
    end
end

return Ship
