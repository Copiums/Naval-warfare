local Ship = {
    Status = {}
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
    end
    local Parent = SeatPart.Parent
    if table.find(ShipNames, Parent.name) then
        self.Ship = Parent
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

function Ship:HookEvent()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    self.gmt = gmt
    local namecall = gmt.__namecall
    self.namecall = namecall
    gmt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        if self == Event and method == "FireServer" then
            local args = { ... }
            local eventType = args[1]
            local eventArgs = args[2]
    
            if eventType == "ChangeGun" then
                self.Status.CurrentGun = eventArgs[1]
            elseif eventType == "bomb" and eventArgs then
                self.Status.CurrentGun = eventArgs[1]
            end
        end
        return namecall(self, ...)
    end
end

function Ship:Destroy()
    self.gmt.__namecall = self.namecall
    return true
end

return Ship
