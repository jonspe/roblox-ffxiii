print("Client started")

while not game:IsLoaded() do
	game.Loaded:Wait()
end

print("Client loaded")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

--local Flipper = require(ReplicatedStorage.Packages.Flipper)

local GaugeBar = require(ReplicatedStorage.Components.GaugeBar)


--[[ 
local store = Rodux.Store.new(function(action, currentState)
    if action.type == "TICK" then
        print("Combat gauge ticked")
        return currentState
    elseif action.type == "COMBAT_ACTION_1" then
        print("Combat action queued one bar")
        return currentState
    elseif action.type == "COMBAT_ACTION_2" then
        return currentState
    elseif action.type == "COMBAT_ACTION_3" then
        return currentState
    elseif action.type == "COMBAT_ACTION_4" then
        return currentState
    else
        return currentState
    end
end)
 ]]


--[[ local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = Roact.createElement("ScreenGui", {}, {gaugeElement}),
}) ]]

local initialState = {
    currentGauge = 0,
    barCount = 3
}

local gaugeReducer = function(state, action)
    state = state or initialState
    if action.type == "COMBAT_TICK" then
        return {
            currentGauge = state.currentGauge + 0.1,
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
    wait(0.2)

    store:dispatch(combatTick(0.1))
end