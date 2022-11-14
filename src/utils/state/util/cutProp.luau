local function cutProp(props, prop)
	local value = props[prop]

	props[prop] = nil

	return value
end

return cutProp
