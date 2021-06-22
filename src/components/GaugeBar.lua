local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Flipper = require(ReplicatedStorage.Packages.Flipper)

local GaugeBar = Roact.Component:extend("GaugeBar")

function GaugeBar:init()
    local gaugeBinding, setGaugeBinding = Roact.createBinding(0)
    self.gaugeBinding = gaugeBinding
    self.gaugeMotor = Flipper.SingleMotor.new(0)
    self.gaugeMotor:onStep(setGaugeBinding)

    local fillerBinding, setFillerBinding = Roact.createBinding(0)
    self.fillerBinding = fillerBinding
    self.fillerMotor = Flipper.SingleMotor.new(0)
    self.fillerMotor:onStep(setFillerBinding)
end

function GaugeBar:render()
    local gauge = self.props.gauge

    self.gaugeMotor:setGoal(Flipper.Spring.new(gauge))
    self.fillerMotor:setGoal(Flipper.Spring.new(gauge < 1 and 0 or 1))

    return Roact.createElement("Frame", {
        Size = self.gaugeBinding:map(function(value)
            return UDim2.new(value, 0, 1, 0)
        end),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(109, 226, 255)
    }, {
        Roact.createElement("Frame", {
            Size = self.fillerBinding:map(function(value)
                return UDim2.new(1, 0, value*2, 0)
            end),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(1, 1, 1)
        })
    })
end

return GaugeBar
