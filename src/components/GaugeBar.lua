local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local function GaugeBar(props)
    local currentGauge = props.currentGauge
    local barCount = props.barCount
    local ratio = currentGauge/barCount

    return Roact.createElement("Frame", {
        Size = UDim2.new(0, barCount*100, 0, 20)
    }, {
        Progress = Roact.createElement("Frame", {
            Size = UDim2.new(ratio, 0, 1, 0),
            BackgroundColor3 = Color3.new(1, 0, 0),
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
