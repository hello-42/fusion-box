local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Children = Fusion.Children
local New = Fusion.New

local FusionBox = require(script.Parent)

return function(target)
	local component = FusionBox {
		AnchorPoint = Vector2.one * 0.5,
		Parent = target,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(200, 200),

        [Children] = New "TextButton" {},
	}

	return function()
		component:destroy()
	end
end
