local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)
local Flipper = require(ReplicatedStorage.Packages.Flipper)

local GaugeBar = Roact.Component:extend("GaugeBar")

function GaugeBar:init()
	self.motor = Flipper.SingleMotor.new(0)

	local binding, setBinding = Roact.createBinding(self.motor:getValue())
	self.binding = binding

	self.motor:onStep(setBinding)
end

function GaugeBar:render()
    local currentGauge = self.props.currentGauge
    local barCount = self.props.barCount
    local ratio = currentGauge/barCount

    print("Rendering gaugebar")

    self.motor:setGoal(Flipper.Spring.new(ratio), {
        frequency = 2,
        dampingRatio = 0.01
    })

    return Roact.createElement("Frame", {
        Size = UDim2.new(0, barCount*182, 0, 20),
        BackgroundColor3 = Color3.new(0.807843, 0.807843, 0.807843)
    }, {

        Progress = Roact.createElement("Frame", {
            Size = self.binding:map(function(value)
                return UDim2.new(value, -8, 1, -8)
            end),
            Position = UDim2.new(0, 4, 0, 4);
            BackgroundColor3 = Color3.new(0.203921, 0.839215, 1),
        })
    })
end

GaugeBar = RoactRodux.connect(
    function(state, props)
        return {
            currentGauge = state.currentGauge,
            barCount = state.barCount
        }
    end
)(GaugeBar)

return GaugeBar
