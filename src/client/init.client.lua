local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local GaugeMeter = require(ReplicatedStorage.Components.GaugeMeter)


local initialState = {
    currentGauge = 0,
    barCount = 4
}

local gaugeReducer = function(state, action)
    state = state or initialState
    if action.type == "COMBAT_TICK" then
        return {
            currentGauge = state.currentGauge > state.barCount and 0 or state.currentGauge + action.increment,
            barCount = state.barCount
        }
    end
    return state
end

local combatTick = function(increment)
    return {
        type = "COMBAT_TICK",
        increment = increment
    }
end

local store = Rodux.Store.new(gaugeReducer)

local app = Roact.createElement("ScreenGui", {}, {
    GaugeMeter = Roact.createElement(GaugeMeter)
})

app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = app,
})

local handle = Roact.mount(app, Players.LocalPlayer.PlayerGui, "Application")

while true do
    wait(0.3)

    store:dispatch(combatTick(math.random()*0.1+0.1))
end