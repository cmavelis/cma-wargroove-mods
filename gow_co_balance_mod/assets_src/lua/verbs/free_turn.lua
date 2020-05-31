local Wargroove = require "wargroove/wargroove"
local Verb = require "wargroove/verb"

local FreeTurn = Verb:new()

function FreeTurn:canExecuteAnywhere(unit)
  local usedFreeTurn = Wargroove.getUnitState(unit, "freeTurnUsed")

  if usedFreeTurn == "true" then
    return false
  end

  return #unit.loadedUnits == 0
end

-- function FreeTurn:execute(unit, targetPos, strParam, path)

-- end

function FreeTurn:onPostUpdateUnit(unit, targetPos, strParam, path)
  -- GrooveVerb.onPostUpdateUnit(self, unit, targetPos, strParam, path)
  unit.hadTurn = false
  Wargroove.setUnitState(unit, "freeTurnUsed", "true")
end

return FreeTurn
