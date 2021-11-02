local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local GaugeBar = require(ReplicatedStorage.Components.GaugeBar)
local GaugeAction = require(ReplicatedStorage.Components.GaugeAction)

local function GaugeMeter(props)
    local currentGauge = props.currentGauge
    local barCount = props.barCount
    local actionQueue = props.actionQueue

    local bars = {}
    for i = 1, barCount do
        bars[i] = Roact.createElement(GaugeBar, {
            gauge = math.max(0, math.min(1, currentGauge - i + 1))
        })
    end

    local actions = {}
    local cumulativeGauge = 0
    for index, action in ipairs(actionQueue) do
        cumulativeGauge = cumulativeGauge + action.size
        actions[index] = Roact.createElement(GaugeAction, {
            action = action,
            filled = currentGauge >= cumulativeGauge
        })
    end

    return Roact.createElement("Frame", {
        Size = UDim2.new(0, barCount*182, 0, 20),
        Position = UDim2.new(0, 8, 0.7, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(115, 149, 160)
    }, {
        BarContainer = Roact.createElement("Frame", {
            Size =  UDim2.new(1/barCount, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
        }, {
            Layout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6)
            }),
            unpack(bars)
        }),
        ActionContainer = Roact.createElement("Frame", {
            Size =  UDim2.new(1/barCount, -8, 1, 0),
            Position = UDim2.new(0, 4, 0, -32),
            BackgroundTransparency = 1,
        }, {
            Layout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6)
            }),
            unpack(actions)
        })
    })
end

GaugeMeter = RoactRodux.connect(
    function(state, props)
        return {
            currentGauge = state.currentGauge,
            barCount = state.barCount,
            actionQueue = state.actionQueue
        }
    end
)(GaugeMeter)

return GaugeMeter
