local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.Roact)
local Rodux = require(ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local Util = require(ReplicatedStorage.Common.Util)
local CombatActions = require(ReplicatedStorage.Common.CombatActions)

local GaugeMeter = require(ReplicatedStorage.Components.GaugeMeter)

local CombatGaugeTick = function(increment)
    return {
        type = "CombatGaugeTick",
        increment = increment
    }
end

local QueueCombatAction = function(action)
    return {
        type = "QueueCombatAction",
        action = action
    }
end


local gaugeReducer = Rodux.createReducer({
    currentGauge = 0,
    barCount = 4,
    queue = {}
}, {
    CombatGaugeTick = function(state, action)
        return Util.combine(state, {
            currentGauge = state.currentGauge > state.barCount and 0 or state.currentGauge + action.increment,
        })
    end,
    QueueCombatAction = function(state, action)
        local count = Util.reduce(state.queue, function(a, b) return a + b.size end, 0)
        local newQueue = Util.copy(state.queue)
        local action = action.action

        if count + action.size <= state.barCount then
            table.insert(newQueue, action)
        end

        return Util.combine(state, {
            queue = newQueue
        })
    end
})

local store = Rodux.Store.new(gaugeReducer, nil, { Rodux.loggerMiddleware })

local app = Roact.createElement(RoactRodux.StoreProvider, {
    store = store,
}, {
    Main = Roact.createElement("ScreenGui", {}, {
        GaugeMeter = Roact.createElement(GaugeMeter),
        Button = Roact.createElement("TextButton", {
            Text = "Attack",
            Position = UDim2.new(1, 0, 1, 0),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 200, 0, 100),

            [Roact.Event.MouseButton1Click] = function(rbx)
                store:dispatch(QueueCombatAction(CombatActions.Attack))
            end
        })
    }),
})

local handle = Roact.mount(app, Players.LocalPlayer.PlayerGui, "Application")

while true do
    wait(0.5)
    store:dispatch(CombatGaugeTick(0.17))
end