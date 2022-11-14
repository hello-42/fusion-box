-- Taken from NevermoreEngine's 'Color3Utils'
local function getLuminance(color)
	local components = { color.r, color.g, color.b }
	local vals = {}

	for i, val in pairs(components) do
		if val <= 0.03928 then
			vals[i] = val / 12.92
		else
			vals[i] = ((val + 0.055) / 1.055) ^ 2.4
		end
	end

	return 0.2126 * vals[1] + 0.7152 * vals[2] + 0.0722 * vals[3]
end

return getLuminance
