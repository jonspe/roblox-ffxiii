local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Flipper = require(ReplicatedStorage.Packages.Flipper)

local GaugeBar = Roact.Component:extend("GaugeBar")

function GaugeBar:init()
	self.motor = Flipper.SingleMotor.new(0)

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding

	self.motor:onStep(setBinding)
end

function GaugeBar:render()
    local gauge = self.props.gauge

    self.motor:setGoal(Flipper.Spring.new(gauge), {
        frequency = 1,
        dampingRatio = 0.75
    })

    return Roact.createElement("Frame", {
        Size = self.binding:map(function(value)
            return UDim2.new(value, 0, 1, 0)
        end),
        BackgroundColor3 = Color3.new(0.203921, 0.839215, 1)
    })
end

return GaugeBar