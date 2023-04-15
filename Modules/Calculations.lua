local calculations = {
	Artillery = {},
	AntiAir = {},
	G = 58.5984,
	BULLET_VELOCITY = 800,
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

function calculations.Artillery:angle(distance: number, bulletVelocity: number): number
	-- distance = Velocity^2 * sin(x)^2 / g
	bulletVelocity = bulletVelocity or self.BULLET_VELOCITY
	local x = distance / (bulletVelocity ^ 2) * self.G
	local angle = math.asin(x / 2)

	return angle
end
function calculations.Artillery:highestPoint(angle: number, bulletVelocity: number): number
	bulletVelocity = bulletVelocity or self.BULLET_VELOCITY

	local verticalVelocity = bulletVelocity * math.sin(angle)
	local highestPoint = verticalVelocity ^ 2 / (2 * self.G)

	return highestPoint
end
function calculations.Artillery:flightTime(angle: number, bulletVelocity: number)
	bulletVelocity = bulletVelocity or self.BULLET_VELOCITY

	local t = 2 * (bulletVelocity / self.G) * math.sin(angle)
	return t
end
function calculations.Artillery:shootRange(angle: number, bulletVelocity: number): number
	bulletVelocity = bulletVelocity or self.BULLET_VELOCITY

	local t = self:flightTime(angle, bulletVelocity)
	return (bulletVelocity * math.cos(angle)) * t
end

function calculations.AntiAir:flightTime(distance: number, targetVelocity: number, bulletVelocity: number): number
	bulletVelocity = bulletVelocity or self.BULLET_VELOCITY

	local bulletAproachVelocity = targetVelocity - bulletVelocity
	local collisionTime = -distance / bulletAproachVelocity
	return collisionTime
end

function calculations.AntiAir:aproachVelocity(ourPosition: Vector3, targetPosition: Vector3, targetVelocity: Vector3)
	
	local distanceBefore = (ourPosition - targetPosition).Magnitude
	local targetPositionAfterTravel = targetPosition + targetVelocity
	local distanceAfter = (ourPosition - targetPositionAfterTravel).Magnitude

	local aproachVelocity = distanceBefore - distanceAfter
	return aproachVelocity
end

function calculations.AntiAir:shootAt(turret: BasePart, target: BasePart): Vector3
    local targetVelocity = target.AssemblyLinearVelocity
	local aproachVelocity = self:aproachVelocity(turret.Position, target.Position, targetVelocity)
	local distance = (turret.Position - target.Position).Magnitude
	local travelTime = self:flightTime(distance, aproachVelocity, self.BULLET_VELOCITY)
    local shootAtPosition = target.Position + (targetVelocity * travelTime)
    return shootAtPosition
end

return calculations
