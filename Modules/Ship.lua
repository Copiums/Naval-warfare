local Ship = {
        Status = {CurrentGun = -5},
        Ship = nil
}

local shipNames: table = {
        "Heavy Cruiser", "Cruiser", "Carrier", "Destroyer", "Battleship", "Submarine"
}

local ShipUpdate: (seatPart: BasePart?) -> () = function(seatPart: BasePart?)
        if not seatPart then
                Ship.Ship = nil
                return
        end

        local model = seatPart.Parent
        if table.find(shipNames, model.Name) then
                Ship.Ship = model
        end
end

local GetGunBarrel: (gunIndex: number) -> any = function(gunIndex: number)
        if not Ship.Ship then return nil end

        -- Main Artillery (Gun 0)
        if gunIndex == 0 then
                -- Direct PrimeGun
                local primeGun: any = Ship.Ship:FindFirstChild("PrimeGun", true)
                if primeGun then return primeGun end

                -- Inside Turrets
                for _, turret in next, Ship.Ship:GetDescendants() do
                        if turret.Name == "Turret" and turret:IsA("Model") then
                                local pg = turret:FindFirstChild("PrimeGun")
                                if pg then return pg end
                                local bright = turret:FindFirstChild("BRight")
                                if bright then return bright end
                        end
                end

                -- Inside Body
                local body = Ship.Ship:FindFirstChild("Body")
                if body then
                        local pg = body:FindFirstChild("PrimeGun", true)
                        if pg then return pg end
                end
        end

        -- Anti-Air (Gun 1)
        if gunIndex == 1 then
                return Ship.Ship:FindFirstChild("PrimeGun", true) or Ship.Ship:FindFirstChild("Gun", true)
        end

        return nil
end

local GetCurrentGun: () -> number = function()
        if Ship.Ship and Ship.Ship:FindFirstChild("GunNum") then
                return Ship.Ship.GunNum.Value
        end
        return -1
end

Ship.UpdateShip = ShipUpdate
Ship.GetGunBarrel = GetGunBarrel
Ship.GetCurrentGun = GetCurrentGun

return Ship
