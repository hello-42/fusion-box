local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Computed = Fusion.Computed
local Value = Fusion.Value

local gatedState = require(script.Parent.gatedState)
local unwrap = require(script.Parent.util.unwrap)
local xtypeof = require(script.Parent.util.xtypeof)

local GATED_STATE_MAP = {
	{ "Disabled", { "Selected", "Hover" } },
	{ "Hover", { "Pressed" } },
}
local ORDERED_ACTIONABLE_STATES = {
	"Disabled",
	"Pressed",
	"Hover",
}

local function getStates(states)
	local States = unwrap(states) or {}

	States.Disabled = if xtypeof(States.Disabled) == "State" then States.Disabled else Value(false)

	for _, map in GATED_STATE_MAP do
		local gate, gatedStates = States[map[1]], map[2]

		for _, state in gatedStates do
			States[state] = gatedState(gate)
		end
	end

	States.State = Computed(function()
		for _, state in ORDERED_ACTIONABLE_STATES do
			if States[state]:get() ~= true then
				continue
			end
            
			return state
		end

		return "Default"
	end)

	return States
end

return getStates
