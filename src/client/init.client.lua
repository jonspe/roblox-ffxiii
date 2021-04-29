local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local GaugeMeter = require(ReplicatedStorage.Components.GaugeMeter)

local CombatGaugeTick = function(increment)
    return {
        type = "CombatGaugeTick",
        increment = increment
    }
end

local gaugeReducer = Rodux.createReducer({
    currentGauge = 0,
    barCount = 4
}, {
    CombatGaugeTick = function(state, action)
        return {
            currentGauge = state.currentGauge > state.barCount and 0 or state.currentGauge + action.increment,
            barCount = state.barCount
        }
    end
})

local store = Rodux.Store.new(gaugeReducer)

local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = Roact.createElement("ScreenGui", {}, {
        GaugeMeter = Roact.createElement(GaugeMeter)
    }),
})

local handle = Roact.mount(app, Players.LocalPlayer.PlayerGui, "Application")

while true do
    wait(0.3)
    store:dispatch(CombatGaugeTick(0.17))
end