local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hooks = require(ReplicatedStorage.Packages.Hooks)
local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactFlipper = require(ReplicatedStorage.Packages.RoactFlipper)

local function GaugeBar(props, hooks)
    local gauge = props.gauge

    local gaugeBinding = RoactFlipper.useSpring(gauge, {}, hooks)
    local fillerBinding = RoactFlipper.useSpring(gauge < 1 and 0 or 1, {}, hooks)

    return Roact.createElement("Frame", {
        Size = gaugeBinding:map(function(value)
            return UDim2.new(value, 0, 1, 0)
        end),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(109, 226, 255)
    }, {
        Roact.createElement("Frame", {
            Size = fillerBinding:map(function(value)
                return UDim2.new(1, 0, value*2, 0)
            end),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(1, 1, 1)
        })
    })
end

return Hooks.new(Roact)(GaugeBar)
