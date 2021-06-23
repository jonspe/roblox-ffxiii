local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local CombatActions = require(ReplicatedStorage.Common.CombatActions)

local function StoreTesterGui(props)
    local onQueue = props.onQueue
    local onRemove = props.onRemove

    local buttons = {}
    for index, action in pairs(CombatActions) do
        table.insert(buttons, Roact.createElement("TextButton", {
            Text = action.name .. " - " .. action.size,
            Size = UDim2.new(0, 100, 0, 40),
            BorderSizePixel = 2,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(180, 180, 180),

            [Roact.Event.MouseButton1Click] = function()
                onQueue(action)
            end
        }))
    end

    return Roact.createElement("Frame", {
        Position = UDim2.new(0, 20, 1, -60),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1
    }, {
        Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 16)
        }),
        Roact.createElement("TextButton", {
            Text = "Remove",
            Size = UDim2.new(0, 100, 0, 40),
            BorderSizePixel = 2,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(180, 180, 180),

            [Roact.Event.MouseButton1Click] = onRemove
        }),
        unpack(buttons)
    })
end

StoreTesterGui = RoactRodux.connect(
    nil,
    function(dispatch)
        return {
            onQueue = function(combatAction)
                dispatch({
                    type = "QueueCombatAction",
                    payload = combatAction
                })
            end,
            onRemove = function()
                dispatch({
                    type = "RemoveCombatAction"
                })
            end
        }
    end
)(StoreTesterGui)

return StoreTesterGui
