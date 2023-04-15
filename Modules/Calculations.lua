local calculations = {
	Artillery = {},
    AntiAir = {},
	G = 58.5984,
    BULLET_VELOCITY = 800
}

setmetatable(calculations.Artillery, {
	__index = function(_, index)
		return calculations[index]
	end,
})

setmetatable(calculations.AntiAir, {
	__index = function(_, index)
		return calculations[index]
	end,
})

function calculations.Artillery:angle(distance: number, bulletVelocity: number) : number
	-- distance = Velocity^2 * sin(x)^2 / g
	local x = distance / (bulletVelocity ^ 2) * self.G 
	local angle = math.asin(x/2)

	return angle
end
function calculations.Artillery:highestPoint(angle: number, bulletVelocity: number): number
	local verticalVelocity = bulletVelocity * math.sin(angle)
	local highestPoint = verticalVelocity ^ 2 / (2 * self.G)

	return highestPoint
end
function calculations.Artillery:flightTime(angle:number, bulletVelocity:number)
    local t = 2 * (bulletVelocity / self.G) * math.sin(angle)
    return t
end
function calculations.Artillery:shootRange(angle: number, bulletVelocity: number): number
    local t = self:flightTime(angle, bulletVelocity)
	return (bulletVelocity * math.cos(angle)) * t
end

function calculations.AntiAir:flightTime(distance:number, targetVelocity : number, bulletVelocity : number) : number
    -- distance + targetVelocity * x = bulletVelocity * x
    local bulletAproachVelocity = targetVelocity - bulletVelocity
    local collisionTime = -distance / bulletAproachVelocity
    return collisionTime
end

function calculations.AntiAir:aproachVelocity(ourPosition : Vector3 ,targetPosition : Vector3, targetVelocity : Vector3)
    local distanceBefore = (ourPosition - targetPosition).Magnitude
    local targetPositionAfterTravel = targetPosition + targetVelocity
    local distanceAfter = (ourPosition - targetPositionAfterTravel).Magnitude

    local aproachVelocity = distanceBefore - distanceAfter
    return aproachVelocity
end

return calculations
