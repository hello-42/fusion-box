local cutProp = require(script.Parent.utils.state.util.cutProp)

local STATE_PROPS = {
	"Disabled",
	"Selected",
	"Pressed",
	"Hover",
}

local function getCutStateProps(props)
	local stateProps = cutProp(props, "States") or {}

	for prop in STATE_PROPS do
		stateProps[prop] = stateProps[prop] or cutProp(props, prop)
	end

	return stateProps
end

return getCutStateProps
