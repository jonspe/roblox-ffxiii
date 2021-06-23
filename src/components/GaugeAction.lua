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
    local filled = self.props.filled

    spawn(function()
        wait(0.2)
        self.motor:setGoal(Flipper.Spring.new(filled and 1 or 0))
    end)
    
    return Roact.createElement("Frame", {
        Size = UDim2.new(action.size, 0, 2, -16),
        BackgroundTransparency = 1,
    }, {
        Roact.createElement("TextLabel", {
            Position = self.binding:map(function(value)
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

return GaugeAction
