local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Value = Fusion.Value

return {
	BackgroundColor3 = Value(Color3.fromRGB(15, 30, 45)),
	-- BackgroundTransparency = Value(0),
	-- BorderSizePixel = Value(2),
	-- CornerRadius = Value(UDim.new(0, 3)),
}
