local springCoefficients = require(script.Parent.springCoefficients)

local EPSILON = 0.0001

-- Taken from Fusion's 'SpringScheduler'
-- *with slight modification to fit the module's specific use-case.
local function isSpringMoving(spring)
	local lastUpdateTime = os.clock()
	local isMoving = false

	if not spring._lastSchedule then
		return isMoving
	end

	local posPos, posVel, velPos, velVel =
		springCoefficients(lastUpdateTime - spring._lastSchedule, spring._currentDamping, spring._currentSpeed)

	local positions = spring._springPositions
	local velocities = spring._springVelocities
	local startDisplacements = spring._startDisplacements
	local startVelocities = spring._startVelocities

	for index, goal in ipairs(spring._springGoals) do
		local oldDisplacement = startDisplacements[index]
		local oldVelocity = startVelocities[index]
		local newDisplacement = oldDisplacement * posPos + oldVelocity * posVel
		local newVelocity = oldDisplacement * velPos + oldVelocity * velVel

		if math.abs(newDisplacement) > EPSILON or math.abs(newVelocity) > EPSILON then
			isMoving = true
		end

		positions[index] = newDisplacement + goal
		velocities[index] = newVelocity
	end

	return isMoving
end

return isSpringMoving
