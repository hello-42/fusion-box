local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Computed = Fusion.Computed
local Value = Fusion.Value

local utils = script.Parent.utils
local Theme = require(utils.modifiers.Theme)

local util = utils.state.util
local cutProp = require(util.cutProp)
local unwrap = require(util.unwrap)
local xtypeof = require(util.xtypeof)

local function getValueStateProps(props)
	local values = {}

	for prop, value in Theme do
		local xvalue = cutProp(props, prop)

		if xtypeof(xvalue) ~= "State" then
			xvalue = Value(xvalue)
		end

		-- Always return a Value, since we may want to use :set() in the future
		values[prop] = unwrap(Computed(function()
			if unwrap(xvalue) == nil then
				-- If xvalue is ever nil, default to and return the Theme's value
				-- instead.
				return unwrap(Computed(function()
					return if unwrap(xvalue) ~= nil then xvalue else value
				end))
			end

			return xvalue
		end))
	end

	return values
end

return getValueStateProps
