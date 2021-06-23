local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local Util = require(ReplicatedStorage.Common.Util)

local GaugeMeter = require(ReplicatedStorage.Components.GaugeMeter)
local StoreTesterGui = require(ReplicatedStorage.Components.StoreTesterGui)

local gaugeReducer = Rodux.createReducer({
    currentGauge = 0,
    barCount = 4,
    actionQueue = {}
}, {
    CombatGaugeIncrement = function(state, action)
        return Util.combine(state, {
            currentGauge = state.currentGauge > state.barCount and 0 or state.currentGauge + action.payload,
        })
    end,
    QueueCombatAction = function(state, action)
        local count = Util.reduce(state.actionQueue, function(a, b) return a + b.size end, 0)
        local newQueue = Util.copy(state.actionQueue)
        action = action.payload

        if count + action.size <= state.barCount then
            table.insert(newQueue, action)
        end

        return Util.combine(state, {
            actionQueue = newQueue
        })
    end,
    RemoveCombatAction = function(state, action)
        local newQueue = Util.copy(state.actionQueue)
        table.remove(newQueue, #newQueue)

        return Util.combine(state, {
            actionQueue = newQueue
        })
    end
})

local store = Rodux.Store.new(gaugeReducer)

local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = Roact.createElement("ScreenGui", {}, {
        GaugeMeter = Roact.createElement(GaugeMeter),
        StoreTesterGui = Roact.createElement(StoreTesterGui)
    }),
})

local handle = Roact.mount(app, Players.LocalPlayer.PlayerGui, "Application")

while true do
    wait(0.5)
    store:dispatch({
        type = "CombatGaugeIncrement",
        payload = 0.17
    })
end