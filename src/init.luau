local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate
local New = Fusion.New

local cutProp = require(script.utils.state.util.cutProp)
local cutStateProps = require(script.getCutStateProps)
local hydrateProps = require(script.getHydrateProps)
local states = require(script.utils.state.getStates)
local valueStateProps = require(script.getValueStateProps)

return function(props)
	-- Normalize 'props' - it must exist as a 'table' and must contain [Children] whose type is of 'Instance'
	props = if typeof(props) == "table" then props else {}

	local instance = cutProp(props, Children)
	instance = if typeof(instance) == "Instance" then instance else New("Frame")({})

	-- Initialize state objects
	local Values = valueStateProps(props)
	local States = states(cutStateProps(props))

	-- Retrieve hydration state objects and hydrate the Instance
	instance = Hydrate(instance)(hydrateProps(States, Values, instance))

	-- Reply by injecting our mutable state objects into our props so that we can
	-- modify them external to the Theming process.
	for prop, value in Values do
		props[prop] = value
	end

	-- Hydrate again with props who may have not been selected by the
	-- theming process, but have been sterilized of those who were,
	-- so as to not overwrite the applied theme.
	instance = Hydrate(instance)(props)

	props.States = States

	return instance
end
