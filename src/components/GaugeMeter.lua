local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local GaugeBar = require(ReplicatedStorage.Components.GaugeBar)
local GaugeMeter = Roact.Component:extend("GaugeMeter")

function GaugeMeter:render()
    local currentGauge = self.props.currentGauge
    local barCount = self.props.barCount
    
    local bars = {}
    for i = 1, barCount do
        bars[i] = Roact.createElement(GaugeBar, {
            gauge = math.max(0, math.min(1, currentGauge - i + 1))
        })
    end

    return Roact.createElement("Frame", {
        Size = UDim2.new(0, barCount*182, 0, 20),
        BackgroundColor3 = Color3.new(0.807843, 0.807843, 0.807843)
    }, {

        Container = Roact.createElement("Frame", {
            Size =  UDim2.new(1/barCount, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
        }, {
            Layout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal
            }),
            unpack(bars)
        })
    })
end

GaugeMeter = RoactRodux.connect(
    function(state, props)
        return {
            currentGauge = state.currentGauge,
            barCount = state.barCount
        }
    end
)(GaugeMeter)

return GaugeMeter
