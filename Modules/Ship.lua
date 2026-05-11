local Ship = {
        Status = {CurrentGun = -5},
        Ship = nil,
        ShipNames = {
                "Heavy Cruiser", "Cruiser", "Carrier", "Destroyer", "Battleship", "Submarine"
        }
}

local shipNames: table = Ship.ShipNames

local debugLog: table = {}

local function logDebug(msg: string)
        local entry = os.clock() .. " | " .. msg
        table.insert(debugLog, entry)
        print(entry)
        if #debugLog > 200 then
                writefile("ship_debug.txt", table.concat(debugLog, "\n"))
        end
end

function Ship:UpdateShip(seatPart : BasePart)
        if not seatPart then
                logDebug("UpdateShip: seatPart is nil, clearing ship")
                self.Ship = nil
                return
        end
        local model = seatPart.Parent
        if not model then
                logDebug("UpdateShip: model is nil")
                return
        end
        logDebug("UpdateShip: model.Name = " .. model.Name)
        if table.find(shipNames, model.Name) then
                self.Ship = model
                logDebug("UpdateShip: ship set to " .. model.Name)
        else
                logDebug("UpdateShip: model not in shipNames, ignoring")
        end
end

function Ship:GetGunBarrel(gunIndex : number)
        if not Ship.Ship then
                logDebug("GetGunBarrel: Ship.Ship is nil")
                return nil
        end

        for _, turret in next, self.Ship:GetChildren() do
                if turret.Name == "Turret" and turret:IsA("Model") then
                        local seat = turret:FindFirstChild("SBTurretSeat")
                        local gunType = seat and seat:FindFirstChild("GunType")
                        local isAA = gunType and gunType.Value == "AA"

                        if gunIndex == 0 and not isAA then
                                local bright = turret:FindFirstChild("BRight")
                                logDebug("GetGunBarrel[0]: found main gun turret, BRight = " .. tostring(bright))
                                return bright
                        elseif gunIndex == 1 and isAA then
                                local bright = turret:FindFirstChild("BRight")
                                logDebug("GetGunBarrel[1]: found AA turret, BRight = " .. tostring(bright))
                                return bright
                        end
                end
        end

        logDebug("GetGunBarrel[" .. gunIndex .. "]: nothing found")
        return nil
end

function Ship:CurrentGun()
        if not Ship.Ship then
                return nil
        end
        return Ship.Ship.GunNum.Value
end

return Ship
