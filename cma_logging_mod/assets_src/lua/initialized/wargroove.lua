local OldWargroove = require "wargroove/wargroove"
local Functional = require "halley/functional"

local Wargroove = {}

local inspect = require "inspect"

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

local CopyWargroove = deepcopy(OldWargroove)

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function Wargroove.init()
    print('===Wargroove.init')
    OldWargroove.changeMoney = Wargroove.changeMoney
    OldWargroove.getAllUnitsForPlayer = Wargroove.getAllUnitsForPlayer
    OldWargroove.getAllUnitIdsForPlayer = Wargroove.getAllUnitIdsForPlayer
    OldWargroove.getAllUnitsForPlayer = Wargroove.getAllUnitsForPlayer
    OldWargroove.getMapVariables = Wargroove.getMapVariables
    OldWargroove.getMoney = Wargroove.getMoney
    OldWargroove.setMoney = Wargroove.setMoney
    OldWargroove.setTurnInfo = Wargroove.setTurnInfo
    OldWargroove.startCombat = Wargroove.startCombat
    OldWargroove.setMatchSeed = Wargroove.setMatchSeed
    OldWargroove.getUnitById = Wargroove.getUnitById
    -- local mapSize = CopyWargroove.getMapSize()
    -- print('mapSize')
    -- print(dump(mapSize))

    -- print('getting during init')
    -- print(dump(OldWargroove.getAllUnitsForPlayer(0,0)))
end


function Wargroove.getAllUnitsForPlayer(playerId, includeChildren)
    print('===Wargroove.getAllUnitsForPlayer')
    local allUnits = Functional.map(OldWargroove.getUnitById, CopyWargroove.getAllUnitIdsForPlayer(playerId, includeChildren))
    print(inspect(allUnits))
    return allUnits
end

function Wargroove.startCombat(attacker, defender, path)
    print('===Wargroove.startCombat')
    print('attacker')
    print(dump(attacker))
    print('defender')
    print(dump(defender))
    print('path')
    print(dump(path))

    local mapSize = CopyWargroove.getMapSize()
    print('mapSize')
    print(dump(mapSize))

    print('getting all units')
    print(dump(OldWargroove.getAllUnitsForPlayer(0,0)))

    print('Wargroove.getTerrainNameAt(pos)')
    local pos = {}
    for y=0,5 do
        pos.y = y
        for x=0,5 do
            pos.x = x
            print(dump(pos),CopyWargroove.getTerrainNameAt(pos))
        end
    end

    CopyWargroove.startCombat(attacker, defender, path)
end

function Wargroove.getUnitById(unitId)
    local result = CopyWargroove.getUnitById(unitId)
    print("===Wargroove.getUnitById")
    print(inspect(result))
    return result
end

function Wargroove.setMoney(playerId, value)
    print('===Wargroove.setMoney')
    print(playerId)
    print(value)
    CopyWargroove.setMoney(playerId, value)
end

function Wargroove.changeMoney(playerId, delta)
    print('===Wargroove.changeMoney')
    print(playerId)
    print(delta)
    CopyWargroove.changeMoney(playerId, delta)
end

function Wargroove.getAllUnitIdsForPlayer(playerId, includeChildren)
    print('===Wargroove.getAllUnitIdsForPlayer(playerId, includeChildren)')
    local answer = CopyWargroove.getAllUnitIdsForPlayer(playerId, includeChildren)
    print(dump(answer))
    return answer
end


function Wargroove.getAllUnitsForPlayer(playerId, includeChildren)
    print('===Wargroove.getAllUnitsForPlayer(playerId, includeChildren)')
    local answer = CopyWargroove.getAllUnitsForPlayer(playerId, includeChildren)
    print(dump(answer))
    return answer
end

function Wargroove.getMapVariables(id)
    print('===Wargroove.getMapVariables(id)')
    local answer = CopyWargroove.getMapVariables(id)
    print(dump(answer))
    return answer
end

function Wargroove.getMoney(playerId)
    print('===Wargroove.getMoney(playerId)')
    local answer = CopyWargroove.getMoney(playerId)
    print(dump(answer))
    return answer
end

function Wargroove.setTurnInfo(turnNumber, currentPlayerId)
    print('===Wargroove.setTurnInfo')
    print(turnNumber)
    print(currentPlayerId)
    CopyWargroove.setTurnInfo(turnNumber, currentPlayerId)
end


function Wargroove.setMatchSeed(matchSeed)
    print('===Wargroove.setMatchSeed(matchSeed)')
    local answer = CopyWargroove.setMatchSeed(matchSeed)
    print(dump(answer))
    return answer
end

return Wargroove
