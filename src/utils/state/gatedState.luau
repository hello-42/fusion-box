local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Computed = Fusion.Computed
local Value = Fusion.Value

local unwrap = require(script.Parent.util.unwrap)

local function gatedState(gate)
	local value = Value(false)

	-- Even though we're returning 'value', we want Fusion to
	-- compute 'value's value based on 'gate's value, regardless
	-- of 'value's value, so:

	return Computed(function()
		-- Set value to nil if gate returns a value ~= true
		value:set(if unwrap(gate) ~= true then value:get() else nil)

		return value
	end):get()
end

return gatedState
