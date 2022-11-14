local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Fusion)
local Children = Fusion.Children
local Computed = Fusion.Computed
local New = Fusion.New
local OnEvent = Fusion.OnEvent
local OnChange = Fusion.OnChange
local Out = Fusion.Out
local Spring = Fusion.Spring

local utils = script.Parent.utils
local Behavior = require(utils.modifiers.Behavior)

local state = utils.state
local toggleInputState = require(state.toggleInputState)
local isSpringMoving = require(state.animation.isSpringMoving)

local util = state.util
local cutProp = require(util.cutProp)
local unwrap = require(util.unwrap)

local function getHydrateStateProps(states, values, instance)
	local IS_A_GUI_BUTTON = instance:IsA("GuiButton")

	local hydrateProps = {
		Archivable = states.Disabled,
		Selected = if IS_A_GUI_BUTTON then states.Selected else nil,
	}

	-- Schedule hydration of all Values as Springed values
	values.BorderColor3 = Computed(function()
		return values.BackgroundColor3:get()
	end)

	for prop, value in values do
		hydrateProps[prop] = Spring(
			Computed(function()
				local xvalue = unwrap(value)

				if Behavior[prop] then
					return Behavior[prop](xvalue, unwrap(states.State))
				end

				return xvalue
			end),
			40
		)
	end

	-- Update BackgroundColor3 only when at 'rest'. This lets us change the
	-- BackgroundColor3 value without running into Out/Spring race conditions.
	for _, name in { "BackgroundColor3" } do
		hydrateProps[OnChange(name)] = function(...)
			local isMoving = isSpringMoving(hydrateProps[name])

			if unwrap(states.State) == "Default" and isMoving == false then
				values[name]:set(...)
			end
		end
	end

	-- Apply standard GuiObject theming of [Children] - can we do this better by
	-- referencing Theme instead, and applying Theming specific to UI elements, somehow?
	hydrateProps[Children] = {
		New("UICorner")({
			-- hydrateProps.CornerRadius always exists - it is inherited through
			-- BoxBorder's Theming and can be overriden at the top-level CornerRadius prop.
			CornerRadius = ({ cutProp(values, "CornerRadius"), cutProp(hydrateProps, "CornerRadius") })[1],
		}),
		New("UIStroke")({
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,

			--[[
                Setting both Color and Thickness to the BoxBorder's BorderColor3
                and BorderSizePixel props helps us keep things simple, focused on
                the instance receiving BoxBorder Theming. Note that these are able
                to be overriden from the top-level BorderColor3 and BorderSizePixel
                props, respectively.
            --]]

			Color = hydrateProps.BorderColor3,
			Thickness = hydrateProps.BorderSizePixel,

			-- UIStroke does not respect CanvasGroup's GroupTransparency, so it must be set manually
			Transparency = hydrateProps.GroupTransparency or hydrateProps.BackgroundTransparency,
		}),
	}

	-- Out all GuiObject props relating to Selection, Transparency, and Thickness
	-- so they may act as two-way bindings for dynamic theming.
	for propContainer, map in
		{
			[states] = { if IS_A_GUI_BUTTON then "Selected" else nil },
			[values] = { "BackgroundTransparency", "BorderSizePixel" },
		}
	do
		for _, prop in map do
			if not propContainer[prop] then
				continue
			end

			hydrateProps[Out(prop)] = propContainer[prop]
		end
	end

	-- Only apply interaction state theming if the instance is a GuiButton or otherwise
	-- interactable ClassName.
	if IS_A_GUI_BUTTON then
		for name, events in
			{
				Selected = { "MouseButton1Click" },
				Pressed = { "MouseButton1Down", "MouseButton1Up" },
				Hover = { "MouseEnter", "MouseLeave" },
			}
		do
			for _, event in events do
				hydrateProps[OnEvent(event)] = toggleInputState(states[name])
			end
		end
	end

	return hydrateProps
end

return getHydrateStateProps
