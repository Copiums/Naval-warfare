local Ship = {
    Status = {
        CurrentGun = -5
    }
}

local ShipNames = {
	"Heavy Cruiser",
	"Cruiser",
	"Carrier",
	"Destroyer",
}

function Ship:UpdateShip(SeatPart : BasePart)
    if not SeatPart then
        self.Ship = nil
        return
    end
    local Parent = SeatPart.Parent
    if table.find(ShipNames, Parent.Name) then
        self.Ship = Parent
    end
end

function Ship:GetGunBarrel(gunIndex : number)
    gunIndex = 2 - gunIndex
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

function Ship:CurrentGun()
    return Ship.Ship.GunNum.Value
end


return Ship
