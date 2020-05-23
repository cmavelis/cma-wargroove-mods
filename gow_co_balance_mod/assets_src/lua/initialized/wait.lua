local Verb = require "wargroove/verb"
local OldWait = require "verbs/wait"

local Wait = Verb:new()

-- local doubleTurns = {
--     "harpoonship": "harpoonship_move_only",
-- }

-- function Wait:execute(unit, targetPos, strParam, path)
--     print('We wait')
    
-- end

function Wait:init()
    OldWait.onPostUpdateUnit = Wait.onPostUpdateUnit
end

function Wait:onPostUpdateUnit(unit, targetPos, strParam, path)
    if unit.unitClassId == "harpoonship" then
        unit.unitClassId = "harpoonship_move_only"
        unit.hadTurn = false
    end
    -- unit.unitClassId = "commander_twins_water"
    -- unit.hadTurn = false
    -- unit.grooveCharge = unit.unitClass.maxGroove
end

return Wait
