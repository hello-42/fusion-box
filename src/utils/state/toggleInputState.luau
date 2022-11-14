local function toggleInputState(value)
	return function()
		value:set(not value:get())
	end
end

return toggleInputState
