local Verb = require "wargroove/verb"
local OldWait = require "verbs/wait"

local TempUnits = require "temp_units"

local Wait = Verb:new()

function Wait:init()
    OldWait.onPostUpdateUnit = Wait.onPostUpdateUnit
    OldWait.TempUnits = TempUnits
end

function Wait:onPostUpdateUnit(unit, targetPos, strParam, path)
    if self.TempUnits.forward[unit.unitClassId] then
        unit.unitClassId = self.TempUnits.forward[unit.unitClassId]
        unit.hadTurn = false
        return
    end
    if self.TempUnits.reverse[unit.unitClassId] then
        unit.unitClassId = self.TempUnits.reverse[unit.unitClassId]
        unit.grooveCharge = 0
    end
end

return Wait
