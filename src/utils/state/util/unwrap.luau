local xtypeof = require(script.Parent.xtypeof)

-- Taken from Fusion's 'unwrap'
local function unwrap(item, useDependency)
	return if xtypeof(item) == "State" then item:get(useDependency) else item
end

return unwrap
