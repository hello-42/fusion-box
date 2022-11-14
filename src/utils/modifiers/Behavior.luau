local getLuminance = require(script.Parent.Parent.color.getLuminance)

return {
    -- GuiObject = {
        BorderColor3 = function(color)
            local luminance = getLuminance(color)
            local h, s, v = color:ToHSV()

            -- if luminance > 0.179 then darken our BorderColor3 property
            if luminance > 0.179 then
                return Color3.fromHSV(h, s, v * 0.8)
            end

            -- brighten our BorderColor3 property
            return Color3.fromHSV(h, s, v * 2)
        end,
    -- },
    -- GuiButton = {
        BackgroundColor3 = function(color, state)
            if state == "Default" then
                return color
            end

            -- if state == "Pressed", do nothing
            -- if state == "Disabled", darken
            -- if state == "Hover", brighten

            local multiplier = if state == "Disabled" then 0.5 elseif state == "Hover" then 1.5 else 1
            local h, s, v = color:ToHSV()

            return Color3.fromHSV(h, s, v * multiplier)
        end,
    -- },
}
