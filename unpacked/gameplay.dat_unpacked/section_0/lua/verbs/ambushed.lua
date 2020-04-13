local Wargroove = require "wargroove/wargroove"
local Verb = require "wargroove/verb"

local Die = Verb:new()

function Die:canExecuteAt(unit, endPos)
    return true
end

function Die:execute(unit, targetPos, strParam, path)
    Wargroove.spawnPaletteSwappedMapAnimation(targetPos, 0, "fx/ambush_fx", unit.playerId, "default", "over_units", { x = 12, y = 0 })
    Wargroove.playMapSound("cutscene/surprised", unit.pos)
    Wargroove.waitTime(1.0)
    if strParam == "die" then
        unit:setHealth(0, unit.id)
        Wargroove.updateUnit(unit)
    end
end


return Die
