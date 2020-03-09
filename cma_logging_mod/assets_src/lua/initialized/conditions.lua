local OldConditions = require "triggers/conditions"

local Conditions = {}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local CopyConditions = deepcopy(OldConditions)

function Conditions.init()
    print('===Conditions.init')
    OldConditions.startOfTurn = Conditions.startOfTurn

    -- local mapSize = CopyWargroove.getMapSize()
    -- print('mapSize')
    -- print(dump(mapSize))
    
    -- print('getting during init')
    -- print(dump(OldWargroove.getAllUnitsForPlayer(0,0)))
end

function Conditions.startOfTurn(context)
    print('Conditions.startOfTurn(context)')
    result = context:checkState("startOfTurn")
    print(result)
    return result
end

return Conditions
