local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Flipper = require(ReplicatedStorage.Packages.Flipper)

local GaugeAction = Roact.Component:extend("GaugeAction")

function GaugeAction:init()
    local binding, setBinding = Roact.createBinding(0)
    self.binding = binding
    self.motor = Flipper.SingleMotor.new(0)
    self.motor:onStep(setBinding)
end

function GaugeAction:render()
    local action = self.props.action

    return Roact.createElement("TextLabel", {
        Size = UDim2.new(action.size, 0, 1, 0),
        Text = action.name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(165, 165, 165),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
end

return GaugeAction
