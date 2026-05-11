local Ship = {
        Status = {CurrentGun = -5},
        Ship = nil
}

local shipNames: table = {
        "Heavy Cruiser", "Cruiser", "Carrier", "Destroyer", "Battleship", "Submarine"
}

function Ship:UpdateShip(seatPart : BasePart)
        if not seatPart then
                self.Ship = nil;
                return;
        end;
        local model = seatPart.Parent;
        if not model then return; end;
        if table.find(shipNames, model.Name) then
                self.Ship = model;
        end;
end;

function Ship:GetGunBarrel(gunIndex : number)
        if not Ship.Ship then print("GetGunBarrel: Ship.Ship is nil") return nil end

        if gunIndex == 0 then
                local primeGun = self.Ship:FindFirstChild("PrimeGun", true)
                print("PrimeGun direct:", primeGun)

                for _, turret in next, self.Ship:GetDescendants() do
                        if turret.Name == "Turret" and turret:IsA("Model") then
                                print("Found turret:", turret:GetFullName())
                                local pg = turret:FindFirstChild("PrimeGun")
                                local bright = turret:FindFirstChild("BRight")
                                print("  PrimeGun:", pg, "BRight:", bright)
                        end
                end

                local body = self.Ship:FindFirstChild("Body")
                print("Body:", body)
        end

        -- Anti-Air (Gun 1)
        if gunIndex == 1 then
                return self.Ship:FindFirstChild("PrimeGun", true) or self.Ship:FindFirstChild("Gun", true);
        end;

        return nil;
end;

function Ship:CurrentGun()
        if not Ship.Ship then 
                return nil; 
        end;
        return Ship.Ship.GunNum.Value;
end;

return Ship
