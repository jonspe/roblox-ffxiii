--[[ print("Client started")

while not game:IsLoaded() do
	game.Loaded:Wait()
end

print("Client loaded")
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local GaugeBar = require(ReplicatedStorage.Components.GaugeBar)


local initialState = {
    currentGauge = 0,
    barCount = 3
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
    GaugeBar = Roact.createElement(GaugeBar)
})

app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = app,
})

local handle = Roact.mount(app, Players.LocalPlayer.PlayerGui, "Application")

while true do
    wait(0.4)

    store:dispatch(combatTick(0.1))
end