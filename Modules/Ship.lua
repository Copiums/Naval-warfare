local Ship = {
        Status = {CurrentGun = -5},
        --Ship = nil
}

local shipNames: table = {
        "Heavy Cruiser", "Cruiser", "Carrier", "Destroyer", "Battleship", "Submarine"
}

function Ship:UpdateShip(seatPart : BasePart)
        if not seatPart then
                self.Ship = nil
                return
        end

        local model = seatPart.Parent
        if table.find(shipNames, model.Name) then
                self.Ship = model
        end
end

function Ship:GetGunBarrel(gunIndex : number)
        if not Ship.Ship then return nil end

        -- Main Artillery (Gun 0)
        if gunIndex == 0 then
                -- Direct PrimeGun
                local primeGun: any = self.Ship:FindFirstChild("PrimeGun", true)
                if primeGun then return primeGun end

                -- Inside Turrets
                for _, turret in next, self.Ship:GetDescendants() do
                        if turret.Name == "Turret" and turret:IsA("Model") then
                                local pg = turret:FindFirstChild("PrimeGun")
                                if pg then return pg end
                                local bright = turret:FindFirstChild("BRight")
                                if bright then return bright end
                        end
                end

                -- Inside Body
                local body = self.Ship:FindFirstChild("Body")
                if body then
                        local pg = body:FindFirstChild("PrimeGun", true)
                        if pg then return pg end
                end
        end

        -- Anti-Air (Gun 1)
        if gunIndex == 1 then
                return self.Ship:FindFirstChild("PrimeGun", true) or self.Ship:FindFirstChild("Gun", true);
        end;

        return nil;
end;

function Ship:CurrentGun()
        return Ship.Ship.GunNum.Value;
end;

return Ship
