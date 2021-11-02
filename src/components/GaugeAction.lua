local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Hooks = require(ReplicatedStorage.Packages.Hooks)
local RoactFlipper = require(ReplicatedStorage.Packages.RoactFlipper)

local function GaugeAction(props, hooks)
    local action = props.action
    local filled = props.filled

    local motorBinding = RoactFlipper.useSpring(filled and 1 or 0, {}, hooks)
    
    return Roact.createElement("Frame", {
        Size = UDim2.new(action.size, (action.size-1)*6, 2, -16),
        BackgroundTransparency = 1,
    }, {
        Roact.createElement("TextLabel", {
            Position = motorBinding:map(function(value)
                return UDim2.new(0, 0, 0, math.ceil(value * 30))
            end),
            Size = UDim2.new(1, 0, 1, 0),
            Text = action.name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            BorderSizePixel = 2,
            BorderMode = Enum.BorderMode.Inset,
            BorderColor3 = Color3.fromRGB(194, 194, 194),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
    })
end

return Hooks.new(Roact)(GaugeAction)
